# 09. Hợp đồng dữ liệu, lệnh và vận hành trước khi code

**Phiên bản 1.2 — 18/11/2026.** Tài liệu bổ sung cho kiến trúc ở tài liệu 03 và 28 luồng ở tài liệu 08. Tên endpoint/entity là thiết kế dự kiến. Chưa tạo schema, Java, JSP, migration hoặc API chạy thật.

## 1. Quy ước dữ liệu và validation đầu vào

| Nhóm/trường | Hợp đồng đề xuất | Lỗi và hành vi |
|---|---|---|
| id | UUID hoặc kiểu ID bất biến thống nhất sau ADR; orderCode chỉ hiển thị/tra cứu có quyền | Không coi mã khó đoán là phân quyền |
| version | Số nguyên tăng khi thay đổi aggregate; bắt buộc với lệnh sửa | Thiếu/khác version → 409, trả currentVersion và bước tải lại |
| amountVnd | Số nguyên không âm, không floating-point; tổng trung gian dùng kiểu đủ lớn, kiểm overflow | Đầu vào vượt giới hạn/âm → 422; JSON quy ước số an toàn hoặc decimal string thống nhất trong OpenAPI |
| quantity của ly/bánh | Số nguyên 1–10 mỗi dòng demo; tổng giỏ ≤20 đơn vị, còn chịu capacity/hold cap | Không cắt bớt quantity âm thầm; đơn nhóm lớn nằm ngoài P0 |
| ingredient quantity | Decimal tối đa 3 chữ số thập phân cho base unit g/ml/pcs theo danh mục; pcs phải nguyên nếu không chia được | Reject precision vượt quy định; không tự đổi kg↔ml |
| timestamp | ISO-8601 có offset ở API; lưu instant UTC; server clock là nguồn deadline | Client clock không kéo dài quote/hold; lịch địa phương tách timezone |
| tên | Trim, Unicode NFC; tên món 1–120, tên khách 1–80, nhãn mẫu1–80 ký tự | Không xóa dấu tiếng Việt để lưu; normalize search ở trường riêng |
| email | Trim, validate, chuẩn hóa so sánh theo ADR; unique normalizedEmail | Không tự bỏ dấu chấm/plus theo quy tắc riêng Gmail; race kiểm bằng constraint |
| mật khẩu | Demo tối thiểu12 ký tự, tối đa128; cho paste/password manager; hash chứ không mã hóa đảo ngược | Không trim/normalize âm thầm; không ghi request body vào log; chính sách cuối qua security review |
| số điện thoại | Canonical theo quốc gia đã chọn; bản đầu Việt Nam, có validate và giá trị hiển thị riêng | Không suy ra owner/order từ phone; không gắn verified khi chưa xác minh |
| địa chỉ giao | Tên nhận, phone, địa chỉ văn bản, mã vùng phục vụ và ghi chú; tọa độ optional | Server kiểm vùng, không tin phí/distance từ client; thiếu vùng → không quote delivery |
| note/reason | Note đơn≤300, mô tả case≤4000, reason code thuộc allowlist | Escape theo output context; reason bắt buộc ở tiền/kho/quyền |
| selection | IDs đúng item/group/version, số lượng group và topping hợp lệ | Unknown IDs/cấu hình bị vô hiệu → 422/409, không tự thay lựa chọn |
| page/sort | page size mặc định20, tối đa100; sort allowlist, tie-break id | Không nhận tên cột SQL tự do; search≤100 ký tự, query timeout |
| upload | JPEG/PNG/WebP, tối đa5MB/ảnh demo; menu≤8 ảnh/món, case≤5 ảnh | Kiểm nội dung thật và kích thước pixel sau decode; không tin đuôi/MIME; loại metadata nhạy cảm |
| import | CSV UTF-8, ≤500 dòng và≤2MB demo, header cố định theo loại | Parse/preview toàn bộ trước commit; báo row+field; chống công thức khi export |

Giới hạn là cấu hình có version, áp dụng server trước cấp tài nguyên tốn kém. Mã tiền chỉ VND ở P0/P1; không giả đa tiền tệ. Giá trị null phải phân biệt với 0 hoặc chuỗi rỗng. PATCH cần quy định rõ field omitted = giữ nguyên, explicit null chỉ cho trường cho phép xóa.

## 2. Bất biến dữ liệu bắt buộc

| Aggregate | Bất biến/constraint | Cách bảo đảm dự kiến |
|---|---|---|
| BranchMembership | User có role theo cơ sở, thời hạn và trạng thái; branchId trên command không tự cấp quyền | Lookup membership/authVersion trước giao dịch và kiểm lại ở service ghi |
| Cart/Quote | Một quote và một cartGeneration tối đa một Order; quote cùng owner/branch/version | Unique FK trên order source; khóa cart/quote, idempotency operation cùng transaction |
| Order/Line/Unit | Một branch/order; mỗi unit thuộc line đúng order; snapshots không sửa khi catalog đổi | FK/composite consistency, unique(lineId,unitIndex), immutable snapshot |
| Unit fulfillment | Nghĩa vụ PENDING/VOID/FULFILLED; VOID chỉ khi chưa bàn giao, chỉ sau adjustment được chấp nhận | Command validate và optimistic/pessimistic lock; sau bán dùng resolution riêng |
| PrepTicket | attemptNo tăng theo unit, tối đa một active attempt; source remake duy nhất | Unique(unitId,attemptNo), partial unique active + service transaction |
| Stock/Reservation | Physical/reserved không âm, reserved không vượt sellable; allocations tổng đúng nhu cầu | Khóa balance/lots theo thứ tự; movement source unique; constraint hàng đơn và kiểm liên bảng trong transaction |
| Capacity | reservedWork+usedWork≤maxWork tại bucket; không giải phóng phần đã dùng | Khóa bucket; unique reservation source; thay capacity thấp hơn committed → từ chối/pause thay vì sửa âm |
| Receipt/Refund | External txn/source unique; succeeded và pending refund không vượt nghĩa vụ hợp lệ/tổng đã thu | Khóa order+obligations, unique reference và conditional transition; không chỉ CHECK trên một hàng |
| Promo/Points | Quota/budget/available points không âm, source event không phát sinh ledger hai lần | Khóa campaign/user wallet; ledger bất biến; projection balance có thể rebuild |
| Delivery | Một task/order, nhiều attempt, tối đa một active; custody không mất sau reassignment | Unique và transition command; history actor/time/from/to |
| ImportBatch | Owner/scope/fileHash/version preview cố định; một confirmed batch apply tối đa một lần | Unique operation key + committedAt, transaction all-or-nothing nhỏ |
| Audit/Outbox | Tác động quan trọng có source/actor/reason; event tồn tại nếu transaction thành công | Ghi cùng transaction, không chứa password/token/evidence binary |

Không tuyên bố mọi invariant liên bảng được giải quyết chỉ bằng SQL CHECK. Một số cần transaction service/khóa/unique và test đồng thời. DB là nguồn thật; cache/WS không được phép quyết định đã trả tiền hay nguyên liệu còn bán.

## 3. Entity bổ sung từ lần rà soát hai

| Entity | Trường trọng tâm và liên kết | Vòng đời |
|---|---|---|
| FavoriteTemplate | ownerId, item/variant/selection references, label, version | Active/deleted; không giữ giá/tồn |
| EmailChangeRequest | userId, newNormalizedEmail, tokenHash, expiresAt, confirmedAt | Một request hiệu lực; unique email kiểm lúc confirm |
| SupplierReturn/Line | receipt/lot, requested/approved/dispatched/accepted qty, reason, approver | Draft→quarantined→approved→dispatched→resolved/disputed; correction riêng |
| SupplierCreditReference | returnId, supplierDocRef, amountVnd, currency, evidenceAssetId | Tham chiếu chứng từ, không là sổ công nợ kế toán hoàn chỉnh |
| DeliveryAttempt | taskId, sequence, driverId, pickupAt, failedAt/deliveredAt, reason, proofAssetId | Assigned→pickedUp→delivered/failed; tối đa một active |
| CustodyEvent | task/attempt, resource GOODS/CASH, fromActor,toActor,qty/amount, confirmedAt, supervisorReason | Append-only; bàn giao thực tế có chứng cứ |
| CollectionException | order/task, expected/collected amount, responsibleActor, dueAt, resolution | Open→investigating→resolved; POD không bị xóa |
| BranchChecklist/Incident | branchId, checklistVersion, result, performedBy, incidentReason, affectedOrderIds | Open/acknowledged/resolved; giữ lịch sử mở/đóng |
| ShiftHandoverItem | source order/refund/task/case, fromShift,toOwner,deadline,acknowledgedAt | Pending→accepted→resolved; không biến đổi source order |
| ETAProposal | orderId/version, old/new promisedAt, reason, expiresAt, answer, capacity plan | Pending→accepted/rejected/expired; một proposal active/order |
| ImportBatch/Row | owner,kind,scope,fileHash,operationKey,targetVersions,errors,summary | Uploaded→validated→confirmed→applied hoặc rejected; file riêng có hạn lưu |
| StockCountSession/Line | branch,ingredient set,lockEpoch,cutoffSequence,theoretical,counted,variance,approver | Lock→count→approve→post→unlock hoặc abort; có runbook unlock |
| AccountOrderGuard | userId,version, giới hạn cấu hình; active counts đọc cùng khóa | Khóa theo account bảo vệ kiểm tra+tạo; không dựa Redis counter duy nhất |

Không thêm entity chỉ để có tên nếu chức năng dùng được bảng sẵn có; W02 quyết định tên/mapping cuối và ghi ADR. Các liên kết ảnh riêng đều trỏ MediaAsset có owner/purpose/status, không lưu URL công khai làm bằng chứng.

## 4. Auth trên JSP/SSR, refresh và WebSocket

**Luồng bình thường:** login POST có CSRF theo thiết kế cùng origin; server xác thực rồi set access/refresh cookies phù hợp HttpOnly/Secure/SameSite và path. Access JWT chứa subject/sessionId/authVersion/claims tối thiểu, xác minh signature/issuer/audience/exp theo cấu hình. Phải kiểm trạng thái phiên/quyền có thu hồi; có JWT không đồng nghĩa quyền sống mãi đến hết hạn.

**Access hết hạn khi mở trang GET:** server không lấy token từ localStorage và không âm thầm làm refresh bằng GET. Trả trang bridge tối thiểu không chứa dữ liệu bảo vệ, có CSRF token và nút/logic POST refresh. Refresh thành công thì điều hướng lại URL GET cùng origin thuộc allowlist; thất bại thì login. Return URL không nhận `//host`, scheme ngoài hoặc endpoint gây mutation. Giới hạn một vòng refresh để tránh redirect loop.

**Access hết hạn trong lệnh POST:** trả 401 có error code; client hoàn tất refresh có CSRF rồi chỉ retry khi lệnh có idempotency key giữ nguyên payload. Với lệnh tài chính/đặt đơn có kết quả không rõ, tra trạng thái operation trước. Không tự gửi lại form thay đổi giá/quyền/import nếu user chưa xác nhận version mới. Double-submit token hay synchronizer token phải chọn một mô hình thống nhất tại W04 và có test; HttpOnly không tự chống CSRF.

**Nhiều tab refresh:** phối hợp browser để giảm race nhưng server vẫn phải an toàn. Chốt chính sách rotation với request đồng thời trong ADR, có thể dùng grace rất ngắn gắn cùng session/request và phản hồi refresh đã phát trước đó; không kéo dài hiệu lực refresh cũ tùy ý. Replay ngoài cửa sổ hợp lệ thu hồi token family. Kiểm thử cả tab ngủ tỉnh lại và logout giữa refresh.

**WebSocket:** xác thực handshake/CONNECT theo cơ chế đã chọn, kiểm CSRF/origin phù hợp, authorize mỗi SUBSCRIBE/SEND. User không tự SEND event “đã thanh toán/đã pha”; chỉ command server xử lý. Session revoke hoặc authVersion đổi phải ngắt/deny subscription cũ. Message chứa entityId/version/eventId tối thiểu; reconnect tải snapshot có quyền rồi tiếp nhận sự kiện mới, bỏ event version cũ. Không đưa toàn bộ PII đơn lên topic chung.

Các quyết định dùng Spring Security theo phiên bản BOM và tài liệu chính thức; không tự viết thuật toán ký/giải mã JWT. Security Resource Server xác minh JWT không tự cung cấp đầy đủ đăng ký/phục hồi/refresh nghiệp vụ; các service đó vẫn phải thiết kế và test riêng.

## 5. View/layout và bằng chứng công nghệ

| Thành phần | Quyết định triển khai | Kiểm chứng |
|---|---|---|
| JSP/JSTL | ViewModel đã tính sẵn, view ở WEB-INF, JSTL loops/conditions/formatting, escape text theo context | Không scriptlet/SQL; input `<script>` hiển thị là text; UTF-8 form/render và VND đúng |
| SiteMesh | Decorator khách/nhân viên/admin, exclude `/api/**`,`/ws/**`,`/media/**`, assets và health | JSON giữ content-type; title/head/body không lặp; trang lỗi có status đúng |
| Boot4/Tomcat11 | WAR; JSP resolver `alwaysInclude=true` theo hướng dẫn SiteMesh, kiểm dispatch mode tương thích | Test artifact packaged, không chỉ IDE; response không rỗng; redirect/status/download không bị decorator can thiệp |
| Bootstrap | Thành phần có label/focus/validation feedback, breakpoint mobile-first, bảng cuộn ngang có nhãn | 390px không tràn trang; keyboard mở/đóng modal và focus quay lại; error không chỉ bằng màu |
| JavaScript | Chỉ tương tác UI; không chứa secret/logic giá có thẩm quyền; JSON encode đúng context | Không chèn JSON thô vào inline script dễ thoát tag; policy CSP tương thích inline cần thiết |
| JPA | Service transaction, DTO projections/pagination, explicit fetch plan, version/locks | Không LazyInitialization lỗi ở JSP, không N+1 vô hạn theo số dòng; test PostgreSQL thật |

Nguồn compatibility: [SiteMesh Jakarta upgrade](https://github.com/sitemesh/sitemesh3/blob/master/JAKARTA_UPGRADE.md), [Spring Boot servlet/JSP](https://docs.spring.io/spring-boot/reference/web/servlet.html). Những chi tiết cấu hình phải được xác nhận bằng TC-109–114, không phải mã nguồn đã cung cấp.

## 6. Hợp đồng lỗi và idempotency

Response lỗi dùng một dạng thống nhất gồm requestId, code, message tiếng Việt, fieldErrors, currentVersion hoặc replacementQuote khi phù hợp, retryable và nextAction. Không trả stack trace/SQL/token. Ngôn ngữ thông báo có thể thay đổi; client xử lý theo code.

| HTTP/code | Điều kiện | Client làm gì |
|---|---|---|
| 400 MALFORMED_REQUEST | JSON/format không đọc được | Sửa request, không retry tự động |
| 401 AUTH_REQUIRED/TOKEN_EXPIRED | Chưa đăng nhập/access hết hạn | Luồng refresh/login đúng mục4 |
| 403 OPERATION_FORBIDDEN | Biết tài nguyên nhưng không có quyền thao tác | Thông báo không được phép; không lộ thông tin nhạy cảm |
| 404 RESOURCE_NOT_FOUND | Tài nguyên không có hoặc cần che tồn tại với người ngoài scope | Cùng dạng lỗi, không phân biệt đối tượng của người khác |
| 409 VERSION_CONFLICT/QUOTE_STALE/STATE_CONFLICT | Version/giá/trạng thái đổi | Tải lại hoặc xác nhận quote mới, không tự tiếp tục giá mới |
| 409 IDEMPOTENCY_PAYLOAD_MISMATCH | Cùng key khác payload | Không retry đổi key để vượt lỗi; khôi phục yêu cầu đúng |
| 409 RESOURCE_UNAVAILABLE | Hết lô/capacity/quota lúc commit | Hiện dòng/lý do được phép biết, cho sửa giỏ |
| 422 VALIDATION_FAILED | Giá trị/ràng buộc nghiệp vụ đầu vào sai | Hiện lỗi trường và giữ input hợp lệ |
| 429 LIMIT_EXCEEDED | Rate hoặc số đơn đang giữ vượt giới hạn | Retry-After khi có; cho xem/hủy đơn chờ của mình |
| 503 SERVICE_UNAVAILABLE | Không bảo đảm commit/đối tác chưa rõ | Tra operation/order trước retry; không báo đã trả tiền |

Idempotency lưu scope actor+operation+key, requestHash, resourceId, resultCode và trạng thái. Key ở P0/P1 giữ tối thiểu theo thời gian retry/callback được chốt; unique nguồn tài chính/kho giữ theo tuổi đời nghiệp vụ, không hết theo TTL cache. Record IN_PROGRESS có lease/recovery, không để key treo mãi hoặc xóa rồi thực hiện lại mù. Lỗi validation trước side effect có thể cho sửa request bằng key mới; sau commit phải replay kết quả cũ.

## 7. Ma trận lệnh và trạng thái cho order/fulfillment

| Lệnh | Actor và điều kiện | Tác động atomic | Bị từ chối khi |
|---|---|---|---|
| CreateOrder | Owner giỏ/thu ngân đúng branch; quote hợp lệ | Order/units+holds+quota+capacity+outbox, consume quote | Stale/used quote, limit hoặc tài nguyên thiếu |
| RecordCashReceipt | Thu ngân đúng cơ sở (ca khi bật P1), cash due>0 hoặc xử lý khoản dư được duyệt | Receipt+cash ledger, recompute coverage | Ca P1 đóng, amount không phù hợp, source trùng khác payload |
| AcceptOrder | Nhân viên branch; waiting acceptance, chưa quá hạn, payment rule đạt | Acceptance/time/deadline, outbox | Hủy/expired/payment unresolved, ETA cần consent |
| RejectOrder | Nhân viên có quyền, chưa bắt đầu pha; reason | Adjustment/obligation, release unused holds, refund task nếu có | Có unit đã start mà không qua resolution review |
| ClaimTicket | Pha chế branch, waiting chưa claim hoặc lease hết | Claim owner/lease/version | Active claim người khác hoặc ticket đã start |
| StartTicket | Claim owner/quản lý override được audit | Consume allocations+movement+ticket PREPARING+unit active attempt | Recall/expiry, nguồn giữ không đủ, order VOID/canceled |
| MarkReady | Người pha được quyền, PREPARING hoặc picking hợp lệ | Ticket ready, unit readiness; order READY khi đủ | Ticket đã waste/void, unit không thuộc attempt active |
| HandoverPickup | Quầy branch; READY, coverage đủ | Handover, unit fulfilled, order completed, loyalty event | Giao rồi/hủy/không đủ tiền/sai cơ sở |
| DispatchDelivery | Điều phối/driver theo assignment; delivery READY | Attempt pickup, custody goods, order out for delivery | Tài xế không hợp lệ/quality hết hạn |
| RecordDelivery | Assigned driver, active attempt | POD, fulfilled units, COD receipt/custody hoặc exception | Proof/amount thiếu mà cố complete thông thường |
| CancelUnits | Owner trong cửa sổ tự hủy hoặc staff theo quyền | Unit void/adjustment, release unused allocations, refund obligation | Unit đã fulfilled; phần đã pha cần resolution/waste riêng |
| ApproveRemake | Người có quyền resolution | Source linked, new ticket attempt/reservation, audit | Đã có active remake cho cùng obligation hoặc hết tài nguyên |
| Propose/AcceptETA | Staff/customer owner; trước pha, proposal còn hạn | Proposal answer, capacity swap atomically, promisedAt | Tăng E, version đổi, proposal cũ/hết hạn |
| ResolveCollectionException | Tài chính/manager đúng scope và hạn mức | Thu bù/điều chỉnh được duyệt + close exception; giữ POD | Không có chứng cứ quyết định, tự đánh dấu thu đủ |

Đây là action endpoints, không có API tổng quát cho client gửi status tùy ý. Chi tiết state machine trong tài liệu 02 vẫn là nguồn cho tên enum; nếu một order có nhiều unit ở trạng thái khác nhau, status tổng là projection và không được dùng để bỏ qua kiểm từng unit. Sau COMPLETED, hậu mãi là aggregate riêng, không đảo ngược lịch sử bàn giao.

## 8. Tiền: tách sự thật số học khỏi nhãn hiển thị

Giữ định nghĩa trong tài liệu 02/03: G tổng ban đầu; C giảm nghĩa vụ được duyệt; E=G−C; R tổng thu thành công; H tổng hoàn thành công. Phải thu = max(0,E−R+H); thu dư = max(0,R−H−E). Refund đang pending không tăng H; có thể đã giảm E và tạo refund payable. Phân biệt giảm nghĩa vụ với chuyển tiền để không thu lại phần đang được hoàn.

**Không dùng một enum duy nhất làm nguồn tiền.** Lưu facts/ledger rồi chiếu hai trục:

| Trục | Giá trị dẫn xuất | Quy tắc |
|---|---|---|
| paymentCoverage | UNPAID / PARTIAL / SETTLED / EXCESS | So netReceipt=R−H với E; E=0 và netReceipt=0 là SETTLED, không phải UNPAID |
| refundProgress | NONE / PENDING / PARTIAL / FULL | Dựa nghĩa vụ refund được duyệt, pending/succeeded amounts; FULL nghĩa vụ hiện tại đã hoàn đủ, không mặc định toàn G đã hoàn |
| exception flags | PAYMENT_UNKNOWN / COLLECTION_EXCEPTION / RECONCILIATION_OPEN | Độc lập, không tự đổi Receipt hay E |

Các nhãn PAID/PARTIALLY_REFUNDED/OVERPAID ở tài liệu trước là nhãn UI dẫn xuất, không ba trạng thái loại trừ nhau của một transaction. Ví dụ G105.000, C37.800, E67.200, R105.000, H0 có EXCESS37.800 + PENDING37.800; hoàn xong H37.800 thì SETTLED + FULL của nghĩa vụ hoàn37.800. Khách không bị nhắc trả thêm. Thu dư do thanh toán lặp có refund source DUPLICATE_COLLECTION; không thay net hàng hoặc entitlement điểm.

## 9. API bổ sung và màn hình cần có

| Nhóm | Endpoint dự kiến | Form/output và quyền |
|---|---|---|
| Session/email | GET `/api/v1/me/sessions`; POST `/api/v1/me/sessions/{id}/revoke`; POST `/api/v1/me/email-change` và `/confirm` | UI tài khoản; owner, re-auth và CSRF ở lệnh ghi |
| Favorites | GET/POST `/api/v1/me/favorites`; PATCH/DELETE theo id; POST `/{id}/to-cart` | Cấu hình stale cần sửa, giá hiện hành; owner only |
| Guest support | POST `/api/v1/staff/guest-cases` | Receipt/order reference+verification method; nhân viên scoped, không endpoint public dò đơn |
| ETA | POST `/api/v1/staff/orders/{id}/eta-proposals`; POST `/api/v1/me/eta-proposals/{id}/answer` | Version, accept/reject; chỉ owner hoặc staff đại diện được ghi lý do |
| Supplier returns | POST `/api/v1/inventory/supplier-returns`; action approve/dispatch/resolve | Kho/approver branch; lot/qty/evidence/credit reference |
| Delivery | POST `/api/v1/delivery/tasks/{id}/attempts`; action custody/failed/delivered | Assignment+version+proof; không tùy ý sửa driver sau pickup |
| Branch checklist | POST `/api/v1/branches/{id}/checklists`; POST `/incidents`; POST `/shift-handovers` | Checklist version, item results, unresolved owner |
| Import | POST `/api/v1/imports/preview`; GET `/{id}`; POST `/{id}/confirm` | Actor/scope/kind/file cap; preview errors + version mismatch |
| Count | POST `/api/v1/stock-counts`; action lock/submit/approve/post/abort | Lock epoch/cutoff, actual independent expected, reason khi variance |
| Commands | POST `/api/v1/orders/{id}/...` hoặc staff namespace theo actor | Idempotency-Key, expectedVersion; OpenAPI không chỉ schema success mà cả lỗi |

Các endpoint lõi vẫn ở tài liệu03 mục8. Quy ước menu URL/màn hình có thể đổi trước code nhưng không đổi ownership/validation mà không cập nhật test. Không đưa endpoint provider inbound vào cookie JWT/CSRF của user; dùng xác minh protocol riêng, rate limit và inbox như UC-08.

## 10. Ma trận quyền tối thiểu

| Thao tác | Khách | Thu ngân/pha chế | Quản lý cơ sở | Quản trị chuỗi/tài chính | Điều kiện bắt buộc |
|---|---|---|---|---|---|
| Xem/sửa giỏ, favorite | Của mình | Không tự đọc khách tùy ý | Không tự đọc khách tùy ý | Không mặc định xem mọi PII | Owner |
| Xem đơn | Của mình | Branch và nhiệm vụ | Branch được giao | Scope được cấp | Field redaction theo role |
| Start/ready ticket | Không | Pha chế đúng branch | Override có reason | Không tự có quyền vận hành từ role tài chính | Claim/version |
| Thu tiền mặt/in lại | Không | Thu ngân đúng cơ sở/ca khi bật P1 | Theo quyền được cấp | Theo chức năng, không mặc định | Source unique, ca mở khi bật P1 |
| Duyệt hoàn | Đề nghị | Không mặc định duyệt | Trong hạn mức | Theo hạn mức được phân công | Tách proposer/approver khi policy yêu cầu |
| Sửa giá/recipe | Không | Không | Chỉ phần được cấp | Catalog admin | Version/publish readiness |
| Nhập/chuyển/kiểm kho | Không | Chỉ role kho được cấp | Duyệt branch | Scoped inventory admin | Lô/đơn vị/không sửa balance |
| Duyệt trả nhà cung cấp | Không | Lập phiếu nếu role kho | Duyệt branch | Theo quyền mua/finance | Không tự duyệt vượt hạn mức |
| Delivery/POD/COD | Xem của mình | Driver chỉ assigned task | Điều phối branch | Finance xem tiền theo scope | Custody/proof |
| Đổi lịch/dừng bán | Không | Báo sự cố | Branch được giao | Theo chain scope | Ảnh hưởng đơn phải có owner |
| CMS/review moderation | Đăng review hợp lệ | Không | Nếu được cấp moderator | Content/moderator | Reason/audit, không xóa review chỉ vì chê |
| Private evidence | Case của mình | Theo assignment | Case branch nếu được cấp | Theo case scope | Proxy kiểm mỗi lần, no-store |
| Export | Dữ liệu mình qua request | Không mặc định | Report branch tối thiểu | Scoped finance/privacy | Audit/expiry/PII tối thiểu |
| Import | Không | Không mặc định | Kind và branch được cấp | Kind được cấp | Preview+version, không import quyền/tiền |
| Cấp quyền/MFA reset | Tự đổi yếu tố theo flow | Không | Không tự tăng chain role | Security admin được chỉ định | Re-auth/MFA, audit, revoke sessions |
| Job replay/restore | Không | Không | Báo incident | Ops role riêng | Không có quyền xem secret trong UI; replay an toàn |

Không dùng “ADMIN được mọi thứ” thay ma trận. Role có thể gộp cho người làm demo nhưng backend vẫn kiểm operation/scope. Các test phải đổi ID trên HTTP và WS trực tiếp, không chỉ xem nút có bị ẩn.

## 11. Hợp đồng job, retry và thời hạn

| Job | Điều kiện/source | Tần suất demo | Tác động và bảo vệ |
|---|---|---|---|
| Expire pending order | paymentDueAt/acceptDueAt≤now, state còn phù hợp | Mỗi30 giây | Khóa order, release unused hold, tạo nghĩa vụ hoàn nếu thu trễ; không hủy ticket đã start |
| Expire proposal/claim | proposal expiresAt, claim leaseUntil | Mỗi15 giây | Conditional transition; claim chỉ hết khi chưa pha |
| Payment/refund inquiry | UNKNOWN/PENDING quá ngưỡng adapter | Sau1m,2m,5m rồi chu kỳ được chốt | Query reference cũ, không tạo lại payment/refund mới |
| Publish outbox | dueAt và lease hết/chưa claim | Poll1 giây demo | Claim lease30 giây, source key dedup; retry1s/5s/30s/2m/10m rồi DLQ theo loại |
| Email/notification | DeliveryAttempt pending | Theo outbox | Unique event+channel+recipient; provider UNKNOWN cần kiểm trước gửi lại nếu hỗ trợ |
| Recall/expiry availability | Lot state/time và affected reservations | Query authoritative + sweep1 phút | Dừng start, tạo task review; không chỉ cập nhật cache |
| Points expiry | Point lot expiresAt≤now | Mỗi giờ, truy vấn chi điểm vẫn kiểm thời gian | Ledger unique expiry source, không double revoke |
| CMS publishing | publish/unpublishAt | Mỗi phút hỗ trợ cache | Query vẫn kiểm visibility khi job trễ |
| SLA/escalation | dueAt case/COD/discrepancy | Mỗi5 phút | Alert/assign theo policy, không tự hoàn/khóa người dùng |
| Media cleanup | Orphan upload chưa attach, quá TTL demo24h | Hằng ngày | Kiểm lại reference+legal hold trong transaction trước mark deleting; race attach bị từ chối/retry rõ |
| Retention/export expiry | RetentionPlan được duyệt, không hold | Hằng ngày | Xóa/ẩn danh theo loại, có audit; không hard-delete ledger tùy ý |
| Reconciliation | Statement import/scheduled report | Theo kỳ, có manual trigger | Source/version/hash dedup; chênh lệch không tự sửa tiền |

Tần suất poll không phải cam kết deadline xử lý chính xác từng giây. Alert khi lag vượt ngưỡng, đồng thời mọi lệnh vẫn kiểm expiresAt bằng server clock. Job nhiều worker phải claim bằng khóa/lease, heartbeat hoặc giới hạn thời gian; mất lease không được tiếp tục ghi nếu fencing/version đã đổi. UNKNOWN financial không tự DLQ rồi coi thất bại để trả lại tiền lần nữa.

## 12. Thứ tự transaction và tích hợp ngoài

Mỗi command có transaction DB ngắn; validate/authorize, khóa aggregate theo thứ tự chung, kiểm invariant, ghi facts/projections/audit/outbox rồi commit. Thứ tự tổng quát: account guard → cart/quote → order → promotion/points → capacity → inventory balances/lots → tickets/refund obligation theo sorted IDs. Lệnh không đụng nhóm nào thì bỏ qua; không khóa ngược. W02 phải rà cụ thể mọi service để tránh một module giữ inventory rồi chờ order trong khi module khác làm ngược.

Network call provider/Cloudinary/email nằm ngoài transaction. Cần ý định durable trước call, correlation/idempotency stable, inbox nhận kết quả sau; timeout đi UNKNOWN/inquiry. Provider có side effect nhưng DB commit cuối thất bại thì tra lại cùng reference, không gọi tạo mới bằng key mới. Mọi callback phải revalidate business state; không tin thứ tự đến.

VNPAY: thông số chữ ký/canonicalization/amount unit/reply code/refund/inquiry cần đọc đúng tài liệu và hợp đồng sandbox tại W10. URL tài liệu từng không tải được trong rà soát; chưa coi protocol đã xác minh. [Tài liệu mục tiêu VNPAY](https://sandbox.vnpayment.vn/apis/docs/thanh-toan-pay/pay.html). Bộ fake cần mô phỏng các trạng thái nhưng không được giả chữ ký là tương thích thật.

## 13. Checklist sẵn sàng bắt đầu một chức năng

- Có F/RQ, UC và actor; xác định P0/P1/P2, branch/owner và điều kiện được thao tác.
- Có input schema/giới hạn, output success/error, expectedVersion/idempotency và hành vi mất mạng.
- Có aggregate/entity/constraint, transaction boundary và thứ tự khóa; tiền/kho dùng fixture cụ thể.
- Có trạng thái trước/sau, source snapshot, outbox/audit và cách recovery.
- Có UI loading/empty/error/conflict/offline, thông báo tiếng Việt, bàn phím/mobile và quyền của từng vai.
- Có test happy path, quyền sai, race/retry liên quan, actual evidence cần ghi; P2 ghi rõ chưa làm.
- Có WBS/ngày công/phụ thuộc và quyết định còn mở với owner/deadline; không để TODO không người phụ trách.

## 14. Definition of Done và thay đổi sau khi bắt đầu code

Một chức năng xong khi reviewer có thể đi từ dòng F trong tài liệu10 đến luồng, API, dữ liệu, màn hình và test đã chạy; migration chạy mới/nâng cấp được; lỗi tiền/quyền/tồn chưa giải quyết không được đánh dấu Done. Ghi rõ phần fake/sandbox/live, performance đo trên môi trường nào và những hạn chế còn mở.

Thay đổi BR cần cập nhật đồng thời fixtures, constraints, commands, tests, UX message và WBS; không chỉ sửa code rồi để tài liệu sai. Thay đổi policy áp dụng bằng version/effective time, giữ snapshot lịch sử. Các thông số thời gian/giá/giới hạn demo chuyển sang thật phải có phê duyệt vận hành riêng, không suy diễn rằng người dùng đã duyệt mọi con số trong kế hoạch.

P0 khi chưa bật phân hệ ca đầy đủ vẫn phải ghi receipt theo cơ sở, thu ngân, quầy và business date; P1 bắt buộc liên kết CashShift đang mở. Không ép phụ thuộc W18 vào luồng bán tại quầy P0. Các kiểm tra liên quan ca trong UC-09 chỉ bắt buộc khi P1 được bật.
