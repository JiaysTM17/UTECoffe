# 03. Thiết kế kiến trúc, dữ liệu và API dự kiến

**Phiên bản 1.2 — 18/11/2026. Trạng thái:** đặc tả để bắt đầu thiết kế chi tiết và viết code sau này. Tên bảng, đường dẫn và trường ở đây là hợp đồng dự kiến; chưa có migration, mã Java, JSP hoặc API được triển khai. Bổ sung OrderUnit/Adjustment, kiểm soát quote, combo, bao bì theo mode và quyền đọc ảnh riêng.

## 1. Quyết định cơ sở dữ liệu: PostgreSQL

Chọn PostgreSQL vì bài toán trung tâm là giao dịch quan hệ: đơn, ly, nguyên liệu dùng chung, khoản thu/hoàn và quyền cơ sở. Dự án cần ràng buộc dữ liệu mạnh, truy vấn báo cáo và khóa khi nhiều người cùng mua/pha. PostgreSQL có cơ chế khóa hàng và chính sách hỗ trợ phiên bản công khai. Đây là đánh giá phù hợp với UTECoffe, không phải kết luận PostgreSQL luôn nhanh hoặc ổn định hơn mọi hệ khác. [Khóa PostgreSQL](https://www.postgresql.org/docs/current/explicit-locking.html) · [Chính sách phiên bản](https://www.postgresql.org/support/versioning/).

| Phương án | Phù hợp khi | Đánh giá cho đề tài |
|---|---|---|
| PostgreSQL | Cần giao dịch, dữ liệu quan hệ, báo cáo và chủ động môi trường triển khai | Chọn làm chuẩn phát triển, test và staging |
| MySQL với InnoDB | Nhóm hoặc hạ tầng đã chuẩn hóa MySQL | Có giao dịch/khóa phù hợp; không có lý do nghiệp vụ bắt buộc đổi sang MySQL |
| SQL Server | Đơn vị vận hành theo hệ Microsoft hoặc môn học yêu cầu | Có cơ chế giao dịch/row versioning; cần chọn edition, hạ tầng và điều kiện sử dụng tương ứng |

Nguồn năng lực hai lựa chọn còn lại: [MySQL InnoDB transaction model](https://dev.mysql.com/doc/refman/8.4/en/innodb-transaction-model.html), [SQL Server transaction locking and row versioning](https://learn.microsoft.com/en-us/sql/relational-databases/sql-server-transaction-locking-and-row-versioning-guide?view=sql-server-ver17). Không chọn theo cảm tính “chỉ hệ X mới dùng được cho thực tế”.

**Baseline đề xuất:** PostgreSQL 17.x với bản vá còn được hỗ trợ khi bắt đầu; ghi chính xác phiên bản trong ADR và môi trường. Có thể chọn major mới hơn nếu thư viện, hosting và test tương thích. JPA không khiến đổi DB tự động an toàn: migration, kiểu thời gian/UUID/JSON, collation tiếng Việt, index, locking và SQL báo cáo phải được kiểm lại. Không tạo ba schema khác nhau trong phạm vi đồ án.

## 2. Bộ công nghệ và kiểm tra tương thích

| Thành phần | Baseline dự kiến | Quyết định |
|---|---|---|
| Java | Java 21 | Một phiên bản JDK trên máy dev và CI |
| Backend/MVC | Spring Boot 4.1.x | Dùng BOM quản lý Spring Framework/Security/Data tương ứng |
| View | JSP + Jakarta JSTL | JSP đặt dưới WEB-INF; không Java scriptlet trong view |
| Decorator | SiteMesh 3.3.x | Layout khách, nhân viên, admin; chỉ HTML |
| Servlet/container | Tomcat 11 theo baseline Boot | Build WAR, kiểm thử bản đóng gói |
| UI | Bootstrap 5.3.x và JavaScript vừa đủ | SSR trước, fetch cho cấu hình món/queue/tracking |
| ORM | Spring Data JPA/Hibernate theo BOM | DTO, transaction tại service, tránh trả entity trực tiếp |
| Database | PostgreSQL 17.x | Migration có phiên bản, không tự update schema ở production |
| Xác thực | Spring Security + JWT | Cookie bảo mật cho cùng origin; CSRF và refresh có thu hồi |
| Realtime | Spring WebSocket/STOMP | Một instance ở P0; snapshot REST khi reconnect |
| Media | Cloudinary Java SDK | Public menu, authenticated evidence, secret ở server |
| Tác vụ nền | Scheduler + job/outbox trong PostgreSQL | Chưa bắt buộc Redis/Kafka cho một người |
| Build/test | Maven Wrapper, JUnit, Testcontainers, trình duyệt E2E | Kiểm concurrency trên PostgreSQL thật |

Baseline1.2 thay thế đề xuất Boot3.5/SiteMesh3.2 ở bản1.1. Spring đã thông báo kết thúc OSS của dòng3.5; chọn Boot4.1 với BOM tương ứng, Java21, SiteMesh3.3 và Tomcat11. Ngày bắt đầu code kiểm lại patch/support/CVE, lưu dependency tree và ADR; không nâng riêng từng thư viện Spring trái BOM. [Thông báo Spring](https://spring.io/blog/2026/06/25/spring-boot-3-5-16-available-now/) · [System requirements](https://docs.spring.io/spring-boot/system-requirements.html).

JSP dùng WAR trên stack này. Với Boot4/Tomcat11, hướng dẫn SiteMesh yêu cầu `alwaysInclude=true` trên JSP ViewResolver; kiểm cả decorator dispatch và view include trong spike. Không trộn servlet/JSTL `javax.*` với `jakarta.*`, phải có API và implementation JSTL tương thích. [Spring Boot JSP](https://docs.spring.io/spring-boot/reference/web/servlet.html) · [SiteMesh compatibility](https://github.com/sitemesh/sitemesh3/blob/master/JAKARTA_UPGRADE.md).

**Spike phải chứng minh:** WAR build/chạy ngoài IDE; JSP có JSTL tiếng Việt; SiteMesh không bọc API JSON; login điều hướng SSR đúng; WebSocket qua security hoạt động; JPA kết nối PostgreSQL; upload Cloudinary trong môi trường thử. Nếu một thành phần không đạt, giải quyết trước khi triển khai hàng chục màn hình.

## 3. Kiến trúc ứng dụng

Luồng đọc: browser → Spring Security → MVC controller → application service → repository/JPA → PostgreSQL → view model → JSP/JSTL → SiteMesh → HTML Bootstrap. Một số thao tác tương tác nhận JSON từ REST controller dùng cùng service.

Luồng ghi: command → xác thực/phân quyền → validate → transaction nghiệp vụ → dữ liệu + audit + outbox → commit → worker gửi thông báo/WebSocket/đối tác. Không đưa logic giá/tồn vào JSP hoặc JavaScript.

| Module | Sở hữu nghiệp vụ | Không được tự sửa |
|---|---|---|
| identity | User, credential, session, membership | Tiền/kho |
| branch | Cơ sở, lịch, kênh, capacity | Payment |
| catalog | Menu, variants, options, giá, nội dung | Snapshot đơn đã tạo |
| inventory | Recipe, lô, balance, movement, reservation | Trạng thái tiền |
| checkout | Cart, quote, pricing, điều phối đặt đơn | Không có bảng tồn riêng |
| ordering | Order, line, ticket, state machine | Không giả paid từ yêu cầu khách |
| payment | Attempts, receipts, refunds, provider inbox | Không tự pha khi callback đến |
| fulfillment | Pickup, chuyến giao, no-show | Điểm và giá gốc |
| promotion/loyalty | Voucher, redemption, points ledger | Thu tiền |
| support | Complaint, resolution, remake request | Refund phải đi qua payment service |
| finance | Ca, cash movement, reconciliation | Không sửa entry đã chốt |
| content/media | Bài nội dung, asset, publication | Hồ sơ ảnh riêng không được public hóa |
| platform | Audit, outbox, job, config, observability | Không thay business rules bằng job tự tiện |

Đây là **modular monolith**: một ứng dụng triển khai, module có ranh giới và service rõ. Chưa tách microservices. Job có thể chạy cùng tiến trình P0 nhưng trạng thái nằm trong DB; sau này tách tiến trình không phải viết lại nghiệp vụ. Kiến trúc không cần Next.js, React hoặc NestJS vì không thuộc stack đề tài.

## 4. Quy ước dữ liệu

- Khóa nội bộ dùng UUID hoặc bigint theo một chuẩn đã chốt; đề xuất UUID cho aggregate công khai, bigint cho ledger lớn. Mã đơn hiển thị tách khỏi PK, duy nhất, không phải bí mật xác thực.
- Tiền VND lưu bigint; phép tính trung gian tỷ lệ dùng BigDecimal, làm tròn có quy tắc. Số lượng nguyên liệu dùng numeric(18,3), hệ số chuyển đổi numeric(18,6); phải kiểm miền và độ chính xác theo thực tế.
- Timestamp sự kiện lưu timestamptz/Instant, biểu diễn API ISO-8601; lịch mở cửa lưu giờ địa phương + timezone. Mốc báo cáo quy đổi thống nhất.
- Dữ liệu mutable có version để optimistic lock. Ledger, snapshot và event không sửa nội dung sau ghi; đảo bằng dòng mới.
- JSONB phù hợp snapshot option/config có phiên bản, không thay thế FK của dữ liệu quan hệ chính. Không chứa mật khẩu/token thô.
- Xóa mềm danh mục/món/nhân viên đã phát sinh giao dịch; tránh cascade delete order, receipt, movement. Tài khoản đóng có thể ẩn danh trường PII theo chính sách lưu được duyệt.
- Mỗi entity quan trọng có createdAt/by; cập nhật có updatedAt/by; thay đổi nghiệp vụ có audit riêng, không chỉ dựa vào hai timestamp.

## 5. Danh mục dữ liệu và quan hệ

Bảng sau là ERD dạng từ điển; dấu “1–N” biểu thị một–nhiều. Khi vẽ ERD vật lý, thể hiện rõ PK, FK, nullable, unique, check, index và delete behavior. P1/P2 chỉ tạo bảng khi tính năng đó bước vào triển khai.

### 5.1 Người dùng và cơ sở

| Đối tượng | Trường trọng tâm | Quan hệ/ràng buộc |
|---|---|---|
| User | id, emailNormalized, passwordHash, status, authVersion | Email duy nhất; không trả passwordHash ra view |
| VerificationToken | tokenHash, purpose, expiresAt, usedAt | 1–N User; token một lần |
| AuthSession | userId, familyId, refreshHash, expiresAt, revokedAt | Rotation; session bị thu hồi không refresh được |
| Role/Permission | code, permissionSet | Mã duy nhất; cấp quyền không lấy từ client |
| BranchMembership | userId, branchId, roleId, effectiveFrom/To | Không trùng membership cùng phạm vi hiệu lực |
| Address | userId, contact, phone, addressText, coordinates | 1–N User; đơn copy snapshot |
| Branch | code, name, address, timezone, status | Code duy nhất; không xóa branch có đơn |
| BranchHours/Exception | branchId, date/day, open/close, cutoff, channel | Ngày ngoại lệ ưu tiên; khoảng giờ hợp lệ |
| BranchServiceZone | branchId, area, feeVersion, active | P1; check vùng ở server |
| CapacityBucket/Hold | branchId, startAt, maxUnits, reservedUnits, orderId | Unique bucket; không giữ vượt max |

### 5.2 Menu và công thức

| Đối tượng | Trường trọng tâm | Quan hệ/ràng buộc |
|---|---|---|
| Category | name, slug, sortOrder, status | Slug duy nhất, không cho cây vòng |
| MenuItem | categoryId, name, itemType, description, status, allergens | itemType=PREPARED_DRINK/PACKAGED_FOOD; 1–N Variant |
| Variant | menuItemId, size, temperature, code | Unique tổ hợp hoạt động, code duy nhất |
| OptionGroup/OptionChoice | min/max, required, extraPrice, status | Một choice thuộc một group |
| ItemOptionRule | item/variant, group, allowedChoices, condition | Rule version; không dùng client làm validator duy nhất |
| BranchMenu | branchId, item/variant, enabled, stopReason | Unique branch + đối tượng bán |
| PriceVersion | variant/choice, branchScope, amount, validFrom/To | Khoảng giá không chồng trong cùng scope |
| RecipeVersion | targetVariant/modifier, serviceMode, effectiveAt, status | Published bất biến; bao bì phụ thuộc mode; draft có thể sửa |
| RecipeComponent | recipeVersionId, ingredientId, quantity, quantityDelta, unit | Nền không âm; modifier delta có thể âm; tổng hiệu lực cho mọi cấu hình bán phải không âm |
| MediaAsset | publicId, resourceType, deliveryType, owner, purpose, status | Unique publicId; không chỉ lưu URL do client gửi |
| ItemMedia | itemId, assetId, position, altText | Chỉ asset menu/public phù hợp |

### 5.3 Nguyên liệu và chứng từ kho

| Đối tượng | Trường trọng tâm | Quan hệ/ràng buộc |
|---|---|---|
| Ingredient | code, baseUnit, tracked, safetyStock | Code duy nhất; unit chuẩn |
| UnitConversion | ingredientId, fromUnit, factor, effectiveAt | Factor dương; không mơ hồ chuyển g/ml |
| IngredientLot | ingredientId, branchId, lotCode, expiry, status, cost | Một lô thuộc vị trí cụ thể; trace nguồn |
| InventoryBalance | branchId, ingredientId, physical, reserved, version | Unique branch+ingredient; 0 ≤ reserved ≤ physical |
| LotBalance | lotId, physical, reserved | Không âm, tổng lô khớp balance theo kỳ đối chiếu |
| StockMovement | lotId, delta, kind, sourceType/Id, componentId, allocationId, actor | Unique tác dụng theo allocation+kind; một component có thể lấy từ nhiều lô |
| Reservation/ReservationLine | orderId/ticketId, lotId, qty, deadline, state | Tổng còn giữ khớp reserved; nguồn release/consume duy nhất |
| Supplier/PurchaseOrder/Line | supplier, orderedQty, expectedAt | P1; đặt mua chưa tăng tồn |
| GoodsReceipt/Line | purchaseRef, lot, acceptedQty, unitCost | Ghi sổ atomic; nhận nhiều đợt có hạn lượng |
| StockTransfer/Line | from/to, sentQty, receivedQty, inTransitQty | P1; từ khác đến; nhận không vượt xuất nếu chưa điều chỉnh |
| InventoryCount/Line | cutoff, expected, counted, variance, approval | P1; tính movement phát sinh quanh lúc kiểm |
| WasteRecord | lot/ticket/transfer, qty, kind, reason, approval, consumedMovementRef | RAW/FINISHED/TRANSIT phân biệt; FINISHED không giảm kho lần nữa |
| PrepBatch/Input/Output | recipe, inputs, yield, lotExpiry | P1; mẻ topping từ nguyên liệu đầu vào |

### 5.4 Giỏ, đơn và phục vụ

| Đối tượng | Trường trọng tâm | Quan hệ/ràng buộc |
|---|---|---|
| Cart/CartLine | owner/session, branch, serviceMode, checkoutGeneration, version, variant, optionsHash, note, qty | Một giỏ active; gộp login có token một lần |
| CheckoutQuote | ownerId, cartId, cartVersion, checkoutGeneration, branch, totals, expiresAt, priceFingerprint, consumedByOrderId | Một quote tối đa một order; generation cũng chỉ tiêu dùng một lần |
| Order | customerId nullable, quoteId, cartId, checkoutGeneration, branchId, channel, serviceMode, status, fulfillmentOutcome, originalTotal, effectiveTotal, deadlines, version | Customer null chỉ với quầy; unique quoteId và cartId+checkoutGeneration cho order web |
| OrderItem | orderId, qty, variantRef, names/options/recipeSnapshot, amounts | Dữ liệu bán bất biến; ref món nullable khi lưu lịch sử |
| OrderItemOption | lineId, choiceRef, nameSnapshot, qty, surcharge | Có thể chuẩn hóa lựa chọn và giữ snapshot đầy đủ |
| DiscountAllocation | orderItemId, promotionRef, amount, allocationOrder | Tổng phân bổ bằng giảm; không vượt gross |
| OrderStatusHistory | orderId, from/to, actor, reason, happenedAt | Chỉ service state machine thêm |
| OrderUnit | orderItemId, unitIndex, gross, discount, net, obligationState, fulfilledAt | Unique line+unitIndex; định danh từng ly/bánh và phần tiền, không thêm unit khi remake |
| PreparationTicket | orderUnitId, attemptNo, kind, parentTicketId, state, assignee, claimLeaseUntil, recipeSnapshot, version | Unique unit+attemptNo; một attempt phục vụ active/unit; kind=PREPARE/PICK |
| OrderAdjustment/Line | orderId, orderUnitId nullable, kind, approvedAmount, decisionId, policyVersion | Bất biến; giảm nghĩa vụ, phí và bồi hoàn tách loại; có business key |
| PickupProof | orderId, codeHash, codeCiphertext, keyVersion, expiresAt, attempts, handedAt/by | Hash xác minh; ciphertext để chủ đơn xem lại; thay mã vô hiệu mã cũ |
| DeliveryTask | orderId, driverId, state, feeSnapshot, timestamps | P1; một nhiệm vụ active/order ở bản đầu |
| DeliveryEvent | taskId, type, evidenceRef, occurredAt | EventId duy nhất; hạn chế PII |
| IdempotencyRecord | actorId, operation, key, requestHash, resourceId, resultState | Unique actor+operation+key; có chính sách retention |

### 5.5 Tiền, ưu đãi và hậu mãi

| Đối tượng | Trường trọng tâm | Quan hệ/ràng buộc |
|---|---|---|
| PaymentAttempt | orderId, method, requestedAmount, currency, providerRef, state | Unique providerRef; nhiều attempts/order |
| PaymentReceipt | attemptId/orderId, amount, method, tenderedAmount, changeAmount, externalTxnId, confirmedAt | Unique provider+txn hoặc source mặt; amount=thu ròng |
| ProviderEvent | provider, eventId/hash, payloadRef, verified, processingState | Inbox chống lặp; lưu tối thiểu cần thiết |
| Refund/RefundLine | receiptId, orderUnitId nullable, adjustmentId nullable, refundPurpose, amount, state, reason | Giữ hạn mức pending; QUALITY/CANCELLATION/DUPLICATE_COLLECTION tách hạn mức |
| Complaint/Message/Evidence | owner, order/line, assignee, SLA, state, assetRef | Evidence private, message có quyền |
| Resolution/Remake | complaintId, approver, action, replacementTicketId | Liên kết tiền và hàng bằng quyết định |
| Promotion/Rule | scope, code, thresholds, cap, starts/ends | Code chuẩn hóa; phiên bản rule |
| PromotionRedemption | promotion, user, order, state, reservedUntil | Unique nguồn; kiểm tổng quota atomic |
| LoyaltyLedger | customerId, orderId, kind, entitlementDelta, balanceDelta, expiresAt, reversalOf | Bất biến, unique nguồn+kỳ điều chỉnh; thu hồi phần đã hết hạn không trừ balance lần nữa |
| LoyaltySpendAllocation/ExpiryAllocation/ReversalAllocation | actionId, earnEntryId, amount, bucket | Phân biệt available/expired/spent; không thu hồi hai lần cùng quyền hưởng |
| CashShift/CashMovement | branch, cashier, opening, state, signedAmount, kind, source | Một ca active theo register; nguồn không lặp |
| CashHandover | driver/shift, expected, actual, acceptedBy | P1; giao COD chưa nộp không mất dấu |
| ReconciliationBatch/Line | provider/fileHash, externalTxn, expected/actual, matchState | FileHash và business transaction chống trùng |
| FinancePeriod/Adjustment | dateRange, lockedAt, reason, reference | Khóa kỳ, điều chỉnh thêm dòng |

### 5.6 Nội dung và nền tảng

| Đối tượng | Trường trọng tâm | Quan hệ/ràng buộc |
|---|---|---|
| Review/Revision | user, orderItem, rating, text, moderationState | Unique current review/line; rating trong miền |
| ContentPage/Banner | slug, content, publishAt/until, state | Không hiển thị draft công khai |
| Notification/DeliveryAttempt | receiver, type, payload, channel, status | Unique event+receiver+channel |
| OutboxEvent | aggregateId/version, type, payload, nextAttempt, status | Lưu cùng transaction nghiệp vụ |
| JobExecution | jobType, sourceId, leaseUntil, retries, error | Lease timeout cho process chết |
| AuditLog | actor, action, target, before/after, requestId, timestamp | Giới hạn quyền đọc, không chứa secret |
| PolicyVersion | kind, parameters, effectiveAt, approvedBy | Đơn lưu policy version cần truy nguyên |

### 5.7 Các trục quan hệ cần thể hiện trên ERD

User 1–N Order; Branch 1–N Order; Order 1–N OrderItem; OrderItem 1–N OrderUnit; OrderUnit 1–N PreparationTicket theo lần làm, bao gồm remake. Ticket 1–N ReservationLine; ReservationLine N–1 IngredientLot; Lot 1–N StockMovement. Order 1–N PaymentAttempt; Attempt 0–N Receipt; Receipt 1–N Refund. Order 1–N Adjustment, AdjustmentLine có thể trỏ OrderUnit hoặc loại phí. User N–N Branch qua Membership. Variant 1–N RecipeVersion; RecipeVersion 1–N RecipeComponent; Component N–1 Ingredient. Complaint liên kết OrderItem/OrderUnit và Resolution, không sở hữu/xóa Payment.

## 6. Index, ràng buộc và hiệu năng dữ liệu

Index dự kiến: Order(branchId,status,createdAt), Order(customerId,createdAt); Ticket(branchId,state,promisedAt) nếu branchId được lưu nhất quán; Lot(branchId,ingredientId,status,expiry); Reservation(state,deadline); Outbox(status,nextAttempt); Membership(userId,branchId,status); Payment(providerRef), Receipt(provider,externalTxnId); Audit(targetType,targetId,createdAt).

FK không thay kiểm scope: một ticket của cơ sở B vẫn phải bị A từ chối dù FK hợp lệ. Thêm composite key/FK cho cặp branch–object khi phù hợp để giảm lỗi gán chéo. Check cân đối trên một hàng; tổng nhiều hàng và hạn mức refund cần khóa/giao dịch, không tưởng CHECK đơn giản đủ bảo vệ.

Đọc danh sách dùng projection/DTO, pagination, fetch có chủ đích; tắt phụ thuộc lazy load trong JSP và kiểm N+1. Search P0 dùng query chuẩn hóa tiếng Việt + index được đánh giá bằng EXPLAIN; không thêm Elasticsearch trước khi có nhu cầu đo được. Giá trị search escape đúng, không nối SQL từ input.

## 7. Ranh giới giao dịch

### TX-01 — Tạo đơn

1. Xác thực, kiểm idempotency và request hash. Hai request đồng thời cùng khóa phải tranh unique record; bên thua trả kết quả đã commit hoặc trạng thái đang xử lý.
2. Khóa/kiểm cartVersion, checkoutGeneration, quote ownership, expiry, menu/price/policy fingerprint. Unique order.quoteId và order(cartId,checkoutGeneration) ngăn hai khóa gửi khác nhau tạo trùng. Không nhận tổng tiền từ client làm nguồn sự thật.
3. Tính yêu cầu nguyên liệu từng ticket; khóa balance theo thứ tự ổn định, kiểm lô/hạn, capacity và voucher quota nếu P1.
4. Tạo Order/Items/Units/Tickets, reservation allocations, capacity hold, promotion hold, snapshot, history và outbox; tiêu dùng quote/generation trong cùng commit. Việc tạo giỏ mới không được làm quote đã dùng hợp lệ trở lại.
5. Commit toàn bộ. Payment adapter được gọi sau commit; timeout adapter không khiến tạo đơn lần hai.

### TX-02 — Bắt đầu phiếu

Khóa order trước, rồi units/tickets theo ID; kiểm staff scope, version, trạng thái và lô còn dùng được; chuyển held quantity sang consumption, thêm StockMovement; ghi PREPARING và outbox; commit. Order cancellation dùng cùng quy ước khóa để không release phần đã tiêu hao. JPA hỗ trợ khai báo chế độ khóa; lựa chọn cụ thể phải thử bằng concurrent integration test. [Spring Data JPA locking](https://docs.spring.io/spring-data/jpa/reference/jpa/locking.html).

### TX-03 — Nhận kết quả thanh toán

Xác minh payload trước; ghi inbox chống lặp; khóa order trước rồi attempt liên quan; đối chiếu amount/currency/merchant; ghi receipt duy nhất; cập nhật trạng thái suy ra và deadline theo BR-27; nếu hết hold tạo review/refund nghĩa vụ; outbox. Callback sai không đổi paid. Nếu transaction chết sau nhận event, inbox pending được job xử lý lại. Giao thức acknowledgment phải theo tài liệu của adapter đã chọn.

### TX-04 — Hoàn tiền

Khóa order trước rồi receipt và các dòng hoàn liên quan, tính hạn mức đã thu trừ hoàn thành công và đã giữ cho refund pending. Ghi refund + allocation + outbox trong transaction. Worker gửi đối tác dùng business idempotency key cố định. UNKNOWN phải inquiry trước retry; không tạo một refund mới chỉ vì HTTP timeout. Kết quả xác minh mới chuyển success; chỉ hoàn ảnh hưởng giá trị mua mới điều chỉnh điểm, có chống lặp, không đảo điểm vì hoàn khoản thu trùng.

### TX-05 — Hết hạn và job

Job lấy bản ghi đến hạn bằng lease rồi khóa order theo quy ước, kiểm loại deadline và trạng thái lần nữa. Payment/acceptance expiry chỉ release phần chưa tiêu hao; holdReviewAt sau ACCEPTED/PREPARING đưa review, không release mù. DB time/server time chuẩn; không phụ thuộc tab mở. Job tắt/restart vẫn xử lý hạn khi chạy lại. Retry deadlock có giới hạn/backoff và chạy lại toàn transaction; không giữ lock qua cuộc gọi mạng. Chuẩn hóa thứ tự khóa giữa mọi service trước khi viết code.

## 8. Hợp đồng HTTP

### 8.1 Quy ước

Trang JSP dùng URL đọc dễ hiểu, form submit theo Post/Redirect/Get. Các tương tác JSON dùng `/api/v1`. HTTP GET không hủy/thu/đổi quyền. Command có CSRF với cookie auth; idempotency cho tạo đơn, thu, hoàn, nhập và consume. PATCH yêu cầu version khi sửa dữ liệu mutable.

Response lỗi gồm code ổn định, message tiếng Việt, fieldErrors, requestId và currentVersion/newQuote khi phù hợp. 400 dữ liệu sai; 401 hết phiên; 403 thiếu quyền; 404 không thấy/ẩn đối tượng không thuộc quyền; 409 xung đột phiên bản/trạng thái; 422 quy tắc không đáp ứng; 429 vượt giới hạn; 503 tạm không xử lý. Dùng thống nhất trong toàn dự án, không đưa stack trace ra khách.

### 8.2 Trang SSR dự kiến

| Nhóm | URL trang | Trách nhiệm |
|---|---|---|
| Công khai | `/`, `/thuc-don`, `/mon/{slug}`, `/cua-hang`, `/cua-hang/{slug}` | SEO/menu/chi tiết/cơ sở |
| Thành viên | `/dang-nhap`, `/dang-ky`, `/tai-khoan`, `/dia-chi` | Tài khoản và hồ sơ |
| Mua | `/gio-hang`, `/thanh-toan`, `/don-hang`, `/don-hang/{code}` | Quote, checkout, tracking |
| Hậu mãi | `/ho-tro`, `/ho-tro/{id}`, `/diem-thuong` | P0 hỗ trợ cơ bản, P1 mở rộng |
| Nhân viên | `/staff/ban-hang`, `/staff/don`, `/staff/pha-che`, `/staff/ban-giao` | Quầy theo membership |
| Quản lý | `/manager/kho`, `/manager/ca`, `/manager/bao-cao` | Dữ liệu cơ sở |
| Chuỗi | `/admin/co-so`, `/admin/menu`, `/admin/quyen`, `/admin/doi-soat`, `/admin/audit` | Quản trị tập trung |

### 8.3 Nhóm endpoint nghiệp vụ

| Method và endpoint | Quyền | Đầu vào trọng tâm | Kết quả/điều kiện |
|---|---|---|---|
| POST `/auth/register`, `/verify`, `/login` | Public giới hạn tốc độ | Credential/token | Không lộ tồn tại email ngoài chính sách |
| POST `/auth/refresh`, `/logout`, `/password/reset` | Phiên/token phù hợp | Cookie, CSRF | Rotation/thu hồi |
| GET `/branches`, `/branches/{id}/menu` | Public | Mode, tìm kiếm, phân trang | Menu của cơ sở, trạng thái nhận |
| GET `/menu-items/{id}` | Public | Branch, variant | Options/giá/thành phần |
| POST `/cart/lines` | Cart owner | Variant, options, qty, note, version | Cart tính lại ở server |
| PATCH/DELETE `/cart/lines/{id}` | Cart owner | Version, qty/options | Chặn sửa dòng người khác |
| POST `/cart/change-branch/preview`, `/confirm` | Cart owner | Branch mới, previewVersion | So sánh rồi xác nhận |
| POST `/checkout/quotes` | Thành viên | CartVersion, mode, address, voucher | Quote theo một cơ sở; tiền/ETA/expiry |
| POST `/orders` | Thành viên | QuoteId, method, idempotency key | 201 order hoặc replay cùng resource |
| GET `/orders`, `/orders/{id}` | Owner/staff scope | Filter/page | Snapshot, trạng thái, hành động được phép |
| POST `/orders/{id}/cancel` | Owner/quản lý | Reason, version, key | Cancel hoặc cần review |
| POST `/orders/{id}/payment-attempts` | Owner/thu ngân | Method, key | Link/attempt; không tự paid |
| POST `/providers/{provider}/events` | Chữ ký provider | Payload gốc | Không yêu cầu cookie CSRF; xác minh riêng |
| POST `/staff/orders` | Thu ngân | Branch, lines, mode | Dùng cùng pricing/inventory engine |
| POST `/staff/orders/{id}/accept`, `/reject` | Thu ngân/quản lý | Version, reason | State machine |
| GET `/staff/preparation-tickets` | Pha chế scope | Branch, cursor/state | Snapshot queue |
| POST `/staff/tickets/{id}/claim`, `/start`, `/ready` | Pha chế scope | Version, key | Một lần, state hợp lệ |
| POST `/staff/orders/{id}/handover` | Thu ngân | Pickup code, payment state, key | Bàn giao duy nhất |
| POST `/complaints` | Owner | Order/line, reason, assetIds | Hồ sơ có quyền riêng |
| POST `/staff/complaints/{id}/resolve` | CSKH/quản lý | Action, amount/qty, reason | Tạo refund/remake liên kết |
| POST `/finance/refunds/{id}/approve` | Người có hạn mức | Version, key | Giữ hạn mức hoàn |
| POST `/inventory/receipts`, `/waste` | Kho/quản lý scope | Lot/qty/unit/source/key | Ledger nhất quán |
| POST `/inventory/transfers`, `/{id}/receive` | P1 kho scope | From/to/actualQty/key | Không nhận hai lần |
| POST `/promotions/validate` | P1 owner | Cart/quote | Không bảo đảm quota đến khi giữ |
| GET `/loyalty/balance`, `/loyalty/history` | P1 owner | Page | Chỉ điểm mình |
| POST `/loyalty/redeem` | P1 owner | RewardId, key | Atomic điểm/voucher |
| POST `/media/upload-authorizations` | Role/purpose | MIME, size, purpose | Chữ ký hạn ngắn hoặc upload qua backend |
| POST `/media/confirm` | Asset owner | Provider asset metadata | Backend xác minh lại, không tin URL |
| GET `/media/{id}/content` | Người có quyền hồ sơ | Asset id | Proxy bytes sau kiểm quyền, no-store, không lộ signed URL lâu dài |
| GET `/reports/sales`, `/audit` | Scope tương ứng | Branch/date/filter | Giới hạn phạm vi và khối lượng |

Các CRUD quản trị menu, giá, recipe, lịch, membership và policy phải có validate, quyền, version và audit cùng chuẩn; không expose Spring Data repositories trực tiếp ra mạng. Hợp đồng OpenAPI chi tiết sẽ được viết trước từng module, gồm ví dụ request/response và error codes theo bảng này.

## 9. JWT, CSRF và quyền trong JSP

JSP là trang server render nên browser phải gửi xác thực cả khi điều hướng trang, không chỉ khi fetch. Baseline dùng access JWT trong cookie HttpOnly, Secure trên HTTPS, SameSite phù hợp cùng origin; server cấu hình resolver đọc cookie và xác minh JWT. Không lưu access/refresh trong localStorage và không đặt JWT vào URL.

Đề xuất access TTL 15 phút, refresh TTL 7 ngày, refresh dạng opaque token ngẫu nhiên chỉ lưu hash ở DB và rotation theo family. JWT có sub, iss, aud, exp, iat, jti/sessionId; khóa ký ở secret store/env, chỉ chấp nhận thuật toán đã định. Dùng thư viện Spring Security, không tự viết crypto. Phần cấu hình cookie resolver/audience/revocation là việc dự án phải làm; dependency không tự giải quyết hết. [Spring Security JWT](https://docs.spring.io/spring-security/reference/servlet/oauth2/resource-server/jwt.html).

Vì cookie tự đi cùng request, bật CSRF cho form và JSON command, cả login/logout/refresh theo cấu hình phù hợp; token CSRF riêng được render/read cho client, JWT vẫn HttpOnly. Xác minh Origin cho thao tác nhạy cảm. OAuth2 resource server chỉ là khối xác minh token, không tự cung cấp đăng ký/refresh; identity module phải được thiết kế và kiểm thử.

Logout thu hồi AuthSession; HTTP kiểm session/authVersion với dữ liệu quyền hiện hành, không chỉ tin role cũ trong JWT. P0 ưu tiên kiểm DB cho quyền nhạy cảm để thu hồi có hiệu lực ngay; nếu cache sau này phải đặt hạn và invalidation. CSRF/nonce dùng kho phù hợp cho cùng instance; khi scale phải xử lý kho session/CSRF tập trung hoặc cơ chế đã kiểm chứng. Không quảng cáo hệ thống “hoàn toàn stateless” khi vẫn quản lý refresh/revocation.

## 10. WebSocket/STOMP

Handshake dùng cookie cùng origin và Principal đã xác thực. Browser WebSocket không cho tự thêm mọi HTTP header như fetch; tránh token trên query string. STOMP CONNECT phải đáp ứng CSRF của Spring Security, cùng kiểm Origin. [Spring WebSocket token authentication](https://docs.spring.io/spring-framework/reference/web/websocket/stomp/authentication-token-based.html) · [Spring Security WebSocket](https://docs.spring.io/spring-security/reference/servlet/integrations/websocket.html).

| Luồng | Destination dự kiến | Kiểm soát |
|---|---|---|
| Khách theo dõi | `/user/queue/orders` | Server gửi riêng theo principal; không broadcast PII |
| Queue pha chế | `/topic/branches/{id}/preparation` | SUBSCRIBE kiểm membership của branch cụ thể |
| Thông báo cá nhân | `/user/queue/notifications` | Đúng principal, không nhận userId tùy ý |
| Bảng gọi số công khai | Endpoint riêng hoặc snapshot giới hạn | Chỉ số rút gọn, không gửi hồ sơ đầy đủ rồi ẩn bằng CSS |

Chặn client SEND vào topic server và mặc định từ chối destination chưa khai báo. Theo dõi phiên WS để ngắt khi JWT hết hạn, logout hoặc bị thu hồi membership; kiểm lại quyền khi subscribe chưa đủ nếu kết nối đã tồn tại. Client refresh qua HTTP rồi reconnect, không kéo dài WS vô hạn bằng token cũ.

Payload tối thiểu: eventId, entityId, entityVersion, eventType, occurredAt, dữ liệu hiển thị cần thiết. Reconnect lấy snapshot có version rồi áp event mới hơn; trong lúc đồng bộ có thể buffer, sau đó bỏ trùng. Simple broker P0 phù hợp một instance, không phải hàng đợi bền vững; DB/outbox giữ sự kiện nghiệp vụ. Scale P2 cần broker relay/pub-sub và quản lý connection theo node.

## 11. Cloudinary và vòng đời media

P0 ưu tiên upload qua backend hoặc ký upload có hạn, chỉ role/purpose được phép. Kiểm MIME thực, kích thước, số lượng và loại file; tên/publicId do server quản lý. Ảnh món public tối ưu kích thước; không nhúng ảnh gốc nặng ở mọi thẻ. Secret Cloudinary chỉ ở server. [Hướng dẫn upload](https://cloudinary.com/documentation/upload_images).

Cloudinary phân biệt authenticated assets, signed delivery URLs và cơ chế truy cập có thời hạn. Authenticated bảo vệ bản gốc/các bản biến đổi; chữ ký đường dẫn thông thường không đồng nghĩa một phiên quyền theo user tự hết hạn. Tài liệu có API private download với expires_at và các cơ chế token access riêng. [Kiểm soát truy cập media](https://cloudinary.com/documentation/control_access_to_media).

**Lựa chọn P0:** ảnh khiếu nại lưu authenticated; browser đọc `/api/v1/media/{id}/content`. Backend kiểm quyền mỗi request, lấy ảnh từ nhà cung cấp bằng thông tin server kiểm soát rồi stream bytes với Cache-Control: private, no-store và Content-Type đã xác minh, không redirect hay trả URL ký lâu dài cho browser. Chặn arbitrary upstream URL để tránh SSRF; chỉ đọc asset đã đăng ký, giới hạn bytes/timeout và rate. Với ảnh cần resize, chuẩn bị biến đổi được phép khi upload thay vì cho client tự tạo vô hạn. Việc proxy tăng tải/băng thông phải được tính khi chọn môi trường. P2 có thể dùng token access có hạn đã kiểm chứng nếu gói hỗ trợ. Dù dùng cách nào, không thu hồi được bản ảnh người dùng đã tải xuống trước đó.

Upload xong chưa gắn đối tượng được đánh dấu TEMPORARY; job dọn orphan sau thời gian chờ đề xuất 24 giờ, có kiểm reference trước xóa. Sửa ảnh menu không xóa ngay tài sản vẫn được dùng nơi khác. Lưu manifest publicId/type/version và chính sách sao lưu ảnh cần thiết; backup PostgreSQL không tự backup ảnh Cloudinary.

## 12. Tích hợp ngoài và cấu hình môi trường

| Adapter | Phát triển | Staging | Thực tế |
|---|---|---|---|
| Thanh toán | Fake có success/fail/duplicate/late/unknown | VNPAY hoặc cổng được chọn trong sandbox sau đọc tài liệu hiện hành | Hợp đồng merchant, refund/inquiry, đối soát và khóa thật |
| Email | Mail capture hoặc hộp thử | Dịch vụ thử đúng domain/sender | Xác nhận gửi, giới hạn và retry |
| Giao hàng | Nhân viên giả lập, vùng tự cấu hình | Diễn tập nội bộ | Chọn đối tác giao đồ uống theo hợp đồng, không mặc định bưu kiện |
| Cloudinary | Tài khoản/folder dev | Tách credentials/assets | Quyền, quota, access và backup được kiểm |

Kế hoạch không giả định đã có tài khoản đối tác hay đã được duyệt tiền thật. Mọi adapter có timeout, retry phân loại, idempotency, requestId và công cụ đối chiếu. Dev/staging/prod tách secret, DB, media namespace và provider keys; fake adapter không được bật trong production.

## 13. ADR cần lập trước khi triển khai

| ADR | Quyết định cần lưu | Tiêu chí kiểm chứng |
|---|---|---|
| ADR-01 | PostgreSQL và phiên bản | Migration, restore, locking tests |
| ADR-02 | Boot/JSP/SiteMesh/WAR | Artifact chạy ngoài IDE và loại trừ decorator đúng |
| ADR-03 | Cookie JWT + refresh + CSRF | SSR navigation, logout, token replay, WS expiry |
| ADR-04 | Công thức/lô/reservation | Shared ingredient concurrency và FEFO |
| ADR-05 | State machine + tiền độc lập | Callback trễ, hủy khi pha, refund pending |
| ADR-06 | Outbox + một instance | Restart/retry không nhân tác dụng |
| ADR-07 | Cloudinary public/private | Ảnh riêng bị từ chối với người không có quyền |
| ADR-08 | Giá/voucher/điểm | Các fixture số học trong tài liệu kiểm thử |

Mỗi ADR ghi bối cảnh, lựa chọn, phương án đã cân nhắc, hệ quả và ngày xem xét lại. Tài liệu này chưa thay cho DDL/sequence diagram chi tiết; các bản đó phải được hoàn thiện theo từng mốc trong kế hoạch trước khi lập trình module tương ứng.

## 14. Mô hình bổ sung và bất biến cần đưa vào thiết kế chi tiết

### 14.1 Entity còn thiếu được bổ sung

| Đối tượng | Trường chính | Bất biến |
|---|---|---|
| CartMergeProposal | guestCartId, accountCartId, versions, preview, expiresAt, consumedAt | Gộp tối đa một lần; ownership cả hai phía được chứng minh |
| BundleVersion/BundleSlot | bundleId, effectiveAt, slotCount, allowedVariants, bundlePrice | Slot có giá trị tham chiếu dương, không bundle lồng nhau |
| OrderBundleGroup | orderId, bundleVersionId, originalPrice, allocationSnapshot | Các child OrderItem/Unit giữ giá phân bổ; tổng đúng giá combo |
| PackagedStockMapping | variantId, inventoryIngredientId, unitFactor | Một bánh tiêu hao stock item theo cái; không dùng recipe đồ uống giả |
| LotRecall/RecallAffectedUnit | lotId, reason, blockingAt, resolution, orderUnitId | Chặn giữ mới; danh sách đơn đã dùng không public |
| ApprovalPolicy/ApprovalRequest | operation, branch, limit, requester, approver, decision, policyVersion | Người duyệt có quyền và khác requester khi policy yêu cầu |
| CashTender | receiptId, tendered, change, net, cashier, registerRef | tendered−change=net=receipt.amount; đồng tiền VND |
| LoyaltyRewardIssue | customerId, spendEntryId, voucherId, replacementOf, state | Một lần spend không cấp hai voucher; replacement chain không tạo lặp |
| PrivacyRequest/RetentionPolicy/Hold | subjectId, purpose, dueAt, verifiedAt, resultRef, holdReason | Không xóa hồ sơ bị hold; đọc export kiểm quyền hiện hành |
| MfaCredential/RecoveryCode | userId, encryptedSecret/publicKey, verifiedAt, recoveryHash, usedAt | Secret mã hóa; recovery code một lần, không lưu bản rõ |
| ServingLocation | branchId, label, active | P1 nhãn bàn đơn giản; không thể truy đơn bằng nhãn bàn |

**Các check liên bảng phải kiểm bằng transaction/test:** tổng OrderUnit.net bằng OrderItem.net; tổng dòng bằng tổng món; tổng allocations bằng discount; originalTotal không bị sửa; effectiveTotal=originalTotal−approved reductions và không âm; tổng refunded+reservedRefund≤receipt.amount; tổng fulfilled/void units không vượt số mua; một unit có nhiều attempt lịch sử nhưng chỉ một nghĩa vụ giao đang hoạt động.

### 14.2 Transaction bổ sung

**TX-06 — Hủy một phần/làm lại:** khóa order và units theo ID; kiểm version, đã pha/đã giao, hạn refund và quyền duyệt; ghi Resolution/Adjustment; VOID unit được hủy hoặc tạo ticket attempt mới cho unit làm lại; release phần còn giữ hoặc ghi FINISHED_WASTE tham chiếu consumption cũ; cập nhật E và nghĩa vụ hoàn; tạo outbox. Không tự sửa originalTotal. Tiêu hao của attempt làm lại là transaction start mới. Nếu không đủ nguyên liệu remake, hồ sơ vẫn mở và phải có phương án khác được khách đồng ý.

**TX-07 — Khóa/thu hồi lô:** khóa balance/lot và đánh dấu lô không được cấp mới; ghi job durable để tìm/review holds và orders đã dùng. Start prep luôn kiểm trạng thái lô trong transaction nên bị chặn ngay cả khi job liệt kê chưa xong. Di chuyển reservation sang lô khác là atomic. Báo cáo thu hồi có tiến độ, không giả đã xử lý hết khi mới enqueue.

**TX-08 — Nhận tiền mặt/bàn giao:** khóa order, kiểm E, R, H và payment attempts UNKNOWN; xác minh quyền/register/ca nếu bật P1; ghi net receipt và CashTender, cập nhật tiền. Bàn giao có thể cùng transaction nếu thu ngay tại handover hoặc command riêng idempotent có kiểm lại. Nếu nhận tiền ngoài hệ thống nhưng transaction thất bại, thu ngân phải đối chiếu requestId/receipt rồi xác minh, không thu khách lần nữa chỉ vì UI báo lỗi.

**Quy ước khóa để thiết kế:** mọi đường ghi cùng aggregate phải lấy lock order trước units/tickets/payment rows của order; dữ liệu chia sẻ như quota, capacity, balance/lot lấy theo cùng thứ tự loại tài nguyên và ID đã công bố trong ADR-04. Worker expiry/refund/recall không được đảo thứ tự tùy ý. Chứng minh bằng test đua giữa checkout, cancel, prep, recall và refund. Balance/slot cần unique key và cơ chế khởi tạo hàng an toàn; không coi khóa một query không trả hàng là đã khóa được tài nguyên chưa tồn tại.

### 14.3 Các response không được mơ hồ

| Code | Trường nên có | UI xử lý |
|---|---|---|
| QUOTE_CHANGED | reasonByLine, proposedQuoteId, totalsDifference | Hiện so sánh, chờ xác nhận |
| CHECKOUT_ALREADY_CONSUMED | existingOrderId, authorizedSummary | Đi đến đơn đã có, không đặt lại |
| RESOURCE_VERSION_CONFLICT | currentVersion, allowedActions | Tải lại và cho thao tác phù hợp |
| INGREDIENT_UNAVAILABLE | affectedLineIds, allowedAlternatives | Không lộ toàn bộ số tồn/recipe cho khách |
| ORDER_REQUIRES_REVIEW | caseId, publicReason, nextStep | Giữ theo dõi, không giả failed hoàn toàn |
| PAYMENT_UNCERTAIN | attemptId, nextCheckAt, supportRef | Không khuyến khích trả lần nữa khi chưa rõ |
| APPROVAL_LIMIT_EXCEEDED | requiredPermission, requestId | Chuyển cấp duyệt, không nâng role client |

Không trả tên nhà cung cấp, định lượng recipe, dữ liệu nhân viên hay stack trace trong response public chỉ để giải thích hết món.

### 14.4 API bổ sung

| Endpoint dự kiến | Quyền | Hành vi |
|---|---|---|
| POST `/cart/merge-preview`, `/cart/merge-confirm` | Chủ giỏ đã xác minh | Proposal/version, chỉ gộp một lần |
| POST `/staff/orders/{id}/adjustments/preview`, `/confirm` | Quản lý/hạn mức | So sánh units, nghĩa vụ tiền và refund trước duyệt |
| POST `/staff/tickets/{id}/reassign` | Quản lý cơ sở | Chỉ trạng thái cho phép; PREPARING cần xác minh |
| POST `/staff/orders/{id}/cash-receipts` | Thu ngân | Tender/change/net, idempotency, còn phải thu |
| POST `/admin/menu/{id}/publish-check`, `/publish` | Quản trị menu | Kiểm đầy đủ version, publish atomic |
| POST `/inventory/lots/{id}/recall` | Quản lý kho được cấp | Block ngay, job trace và quyết định riêng |
| GET/POST `/admin/bundles`, `/{id}/versions` | P1 catalog | Slot/giá, kiểm recipe/stock từng thành phần |
| POST `/approvals/{id}/decision` | Người có hạn mức | Không tự duyệt khi yêu cầu hai người |
| POST `/privacy/requests`; GET `/privacy/requests/{id}/export` | P1 chủ thể đã xác minh | Scope, re-auth và hạn truy cập |
| POST `/auth/mfa/enroll`, `/verify`, `/recover` | P1 chủ thể/quy trình recovery | Không mở đường bỏ qua factor khi reset |

Các endpoint bổ sung thừa hưởng CSRF, object authorization, version, audit và idempotency tại mục 8; không tạo đường quản trị bỏ qua service nghiệp vụ.

## 15. Từ điển chỉ số và công thức báo cáo

| Chỉ số | Công thức/nguồn | Thời điểm và lưu ý |
|---|---|---|
| Giá trị đơn đặt | Tổng originalTotal của đơn tạo trong kỳ | Có thể gồm đơn hủy; phải ghi rõ tên chỉ số |
| Doanh số món đã giao trước hậu mãi | Tổng net đã phân bổ của units fulfilled trong kỳ | Không gồm unit VOID, phí giao tách riêng |
| Giảm doanh số do hậu mãi | Adjustment chất lượng/hủy liên quan theo ngày duyệt | Đơn kỳ trước dùng dòng điều chỉnh kỳ hiện tại khi khóa kỳ |
| Tiền thu | Tổng PaymentReceipt confirmed trong kỳ | Gồm khoản thu trùng thật, khoản đó được gắn cờ |
| Tiền hoàn | Tổng Refund SUCCEEDED theo thời gian xác nhận | Pending không tính như tiền đã ra |
| Tiền thu ròng | Tiền thu − tiền hoàn | Không đồng nhất với doanh số theo ngày giao |
| Còn phải thu | max(0,E−R+H) mỗi order | Theo nghĩa vụ hiện hành, không cộng toàn bộ originalTotal |
| Thừa cần xử lý | max(0,R−H−E) | Đối chiếu phần đã có refund pending để không tạo hai yêu cầu |
| Tiền mặt kỳ vọng | Đầu ca + net thu mặt − hoàn mặt − chi − nộp | Không cộng tiền gateway hoặc tiền tài xế chưa nộp |
| Giá vốn sử dụng ước tính | Movement consume × đơn giá lô snapshot | FINISHED_WASTE là phân loại của phần đã consume, không cộng hai lần |
| Tỷ lệ hoàn/làm lại | Số units có resolution loại tương ứng / units đã giao của cohort | Cho lọc theo ngày mua hoặc ngày xử lý, ghi rõ denominator |
| Thời gian chờ pha | readyAt−acceptedAt cho đơn đủ điều kiện | Median/p95, tách no-show, partial và đơn lỗi |

Báo cáo có hai cách xem: **theo kỳ phát sinh** để đối soát và **theo nhóm đơn gốc** để phân tích chất lượng. Không trộn refund hôm nay với doanh số hôm qua mà không ghi cách tính. Dữ liệu ngày kinh doanh dùng cùng timezone/cutoff; export ghi timezone, thời điểm sinh và bộ lọc.

## 16. Bảo mật/vòng đời dữ liệu bổ sung

P1 yêu cầu MFA cho tài khoản thay đổi quyền, chính sách tiền và duyệt refund trong thí điểm. Chọn thư viện/nhà cung cấp đã được kiểm chứng khi triển khai; không tự viết thuật toán OTP. Recovery phải có xác minh, mã dùng một lần, thông báo và audit; không cho bỏ MFA chỉ bằng câu hỏi bảo mật. Đây là đề xuất cho UTECoffe dựa trên nguyên tắc triển khai MFA và phục hồi tài khoản. [OWASP MFA Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Multifactor_Authentication_Cheat_Sheet.html).

P0 bảo vệ quản trị bằng password mạnh/hash thích hợp, hạn tốc độ, quyền theo object và xác thực lại khi thao tác nhạy cảm; không cho tự cấp quyền vượt actor, không cho vô hiệu hóa quản trị viên cuối cùng mà chưa có tài khoản thay thế. Trường role/branch/refundAmount không được mass-assign từ DTO public.

Refresh đa tab cần cơ chế một lần gọi đang chạy và phối hợp tab khi khả thi; server vẫn dùng rotation atomic. Nếu token đã dùng lại hoặc trạng thái không rõ, đăng nhập lại an toàn và giải thích hết phiên, không tự kết luận khách gian lận. Không để nhiều retry refresh gây vòng lặp HTTP/WS vô hạn. Mật khẩu reset, đổi MFA và role revoke phải kích hoạt thu hồi phiên và kết nối liên quan.

| Nhóm | Quyền/mục đích | Cách kết thúc vòng đời dự kiến |
|---|---|---|
| Giỏ/quote hết hạn | Chủ giỏ, phục vụ checkout | Dọn sau kỳ cấu hình; giữ khóa chống đặt trùng và tham chiếu order |
| Reset/verification/refresh | Identity service | Hash/token hết hạn; thu hồi và dọn theo chính sách bảo mật |
| Ảnh tạm/chứng cứ | Owner và người xử lý hồ sơ | Dọn orphan; evidence chỉ xóa khi hết retention và không hold |
| Hồ sơ khách/địa chỉ | Khách và nhân viên cần phục vụ | Xóa/ẩn danh theo yêu cầu hợp lệ, tách snapshot cần lưu |
| Order/receipt/ledger/audit | Vận hành/tài chính đúng scope | Lưu theo thời hạn được xác nhận; không xóa làm hỏng liên kết |
| Export/log/backup | Người vận hành được cấp | Hạn tải, redaction, mã hóa backup và quy trình tiêu hủy |

Thời hạn lưu số năm/tháng chưa được tự áp đặt trong hồ sơ: đó là D-06 cần chốt theo mục đích và nghĩa vụ hiện hành. Có test chứng minh job retention tôn trọng hold, không chỉ một checkbox “đã tuân thủ”.

## 17. Danh sách kiểm tích hợp trước khi chọn nhà cung cấp thật

Với payment adapter, cần ghi đơn vị tiền trên wire và trong DB, canonicalization/chữ ký, thời gian/nonce, mã merchant/reference, acknowledgment, retry, inquiry, partial refund, báo cáo settlement, phí và môi trường khóa. Không suy số VND trực tiếp thành trường amount của cổng nếu tài liệu yêu cầu đơn vị khác. Lần rà soát này URL tài liệu thanh toán VNPAY bị timeout, nên không bổ sung khẳng định chi tiết giao thức chưa xác minh; W10 phải đọc tài liệu hiện hành và khóa hợp đồng adapter trước khi code sandbox.

Với email, phải có timeout/retry/dedup, SPF/DKIM/DMARC khi dùng domain thật và hủy đăng ký cho marketing nếu triển khai; email giao dịch không bị tắt cùng lựa chọn quảng cáo. Với vận chuyển, phải chốt vùng/phí, custody, failed delivery, COD và kết quả xác minh; không tự coi update từ client tài xế là webhook đối tác đã xác thực.

Với release, lập inventory dependency và license, secret scan, dependency scan, migration rehearsal và phiên bản artifact. Kết quả scanner phải phân loại theo khả năng ảnh hưởng thực tế; không chỉ ghi “scan xanh”. Migration dùng tài khoản có quyền DDL riêng, ứng dụng thường ngày dùng quyền DB tối thiểu. Thông tin secrets/backup/deploy chỉ nằm trong tài liệu vận hành riêng có quyền thích hợp khi triển khai thật.

## 18. Hợp đồng chi tiết bổ sung của bản 1.2

[Tài liệu09](09-HOP-DONG-DU-LIEU-LENH-VA-VAN-HANH.md) bổ sung field validation, entity mới, bảng lệnh, lỗi API, ma trận quyền, JWT/SSR hết hạn, job/lease và thứ tự khóa. Khi thiết kế physical schema, đọc cùng UC ở tài liệu08 và test ở05; không suy ra quyền/thời hạn chỉ từ tên entity.

Phần tiền cần hiểu paymentCoverage và refundProgress là hai trục dẫn xuất từ facts; PAID/PARTIALLY_REFUNDED/OVERPAID trong mô tả UI cũ không phải một enum loại trừ duy nhất. OrderUnit giữ nghĩa vụ PENDING/VOID/FULFILLED riêng trạng thái PrepTicket. Sau giao thành công, remake thuộc resolution riêng, không lùi order gốc.

P1 kiểm kê dùng lock epoch/cutoff cho tập nguyên liệu được đếm; lệnh mutation trên tập tạm dừng. Không mặc định hỗ trợ kiểm kê động trong lúc movement tiếp diễn. Supplier return, DeliveryAttempt/CustodyEvent, guest support, Favorites, ImportBatch, ETAProposal và BranchIncident được bổ sung theo BR-33–40.

## 19. Thiết kế kiến trúc mở rộng cho kịch bản biên và sự cố vận hành F&B

### 19.1 Kiến trúc Hàng đợi in ấn POS (Print Spooler) & Driver ESC/POS
Hệ thống tích hợp module `PrintSpoolerService` bất đồng bộ:
- Phân tách tiến trình thanh toán (Payment) và in ấn (Print): Trạng thái đơn lưu `PAID` độc lập với tiến trình in ấn phần cứng.
- Driver ESC/POS giao tiếp TCP Socket qua cổng 9100 và USB Virtual COM, gửi lệnh thăm dò `DLE EOT n` (Real-time status transmission) để bắt cờ Paper-End và Jam.
- Hàng đợi in nền `PrintQueue` với cơ chế Exponential Backoff (3s, 5s, 10s) và tự động Failover sang máy in phụ dự phòng (`backupPrinterId`).
- Hỗ trợ định tuyến in đa trạm (Khách vs Barista/Bếp) và in tem nhãn ly (Cup Sticker 50x30mm kèm mã vạch Code128).

### 19.2 Kiến trúc Quản lý bàn & Vòng đời bàn thời gian thực (Table FSM & WebSocket STOMP)
- Máy trạng thái hữu hạn 6 trạng thái: `AVAILABLE` -> `RESERVED` -> `OCCUPIED` -> `BILL_PRINTED` -> `CLEANING` -> `OUT_OF_SERVICE`.
- Giao thức WebSocket STOMP kênh `/topic/branch/{branchId}/tables` đồng bộ thời gian thực trạng thái bàn lên sơ đồ POS và tablet nhân viên.
- Khóa bi quan `SELECT FOR UPDATE` trên thực thể `RestaurantTable` đảm bảo tính nguyên tử khi thực hiện chuyển bàn (Table Move) và gộp bàn (Table Merge), chống tranh chấp cùng tích tắc.
- Sự kiện `TABLE_MOVED` đẩy trực tiếp đến màn hình KDS của Barista qua STOMP `/topic/branch/{branchId}/kds`.

### 19.3 Kiến trúc Vận hành ca đêm xuyên ngày & Sổ cái chốt số kép (Midnight Snapshot)
- Thực thể `CashierShift` định danh tài chính bằng `businessDate = D` cho toàn bộ ca đêm (22:00 hôm trước đến 06:00 hôm sau).
- Báo cáo chốt sổ kép Midnight Snapshot: Bộ lọc truy vấn doanh thu theo `businessDate` cho vận hành nội bộ và cắt lát theo `calendarTimestamp` cho báo cáo thuế pháp định cuối tháng.
- Cơ chế Kiểm tiền mù (Blind Cash Count) ẩn số dư kỳ vọng, tính chênh lệch tự động và định tuyến 3 cấp độ dung sai.
- Quản lý giao dịch rút tiền giữa ca (`CashDropTransaction`) có xác thực kép và mã vạch niêm phong.

### 19.4 Kiến trúc Giám sát kho lạnh IoT & Động cơ tự động cách ly lô (Automated Quarantine Engine)
- Thiết bị cảm biến IoT ESP32/Modbus gửi dữ liệu nhiệt độ định kỳ 30 phút qua giao thức MQTT/HTTP đến endpoint `/api/v1/internal/iot/temperature`.
- `TemperatureMonitorEngine` phát hiện vi phạm ngưỡng $> 8^\circ	ext{C}$ kéo dài quá 120 phút (hoặc mất điện quá 2 giờ) lập tức kích hoạt:
  1. Chuyển trạng thái các lô nhạy cảm trong tủ đó sang `IngredientLot.status = QUARANTINED`.
  2. Quét bảng `MenuItemRecipe`, chuyển toàn bộ món phụ thuộc sang `MenuItem.isAvailable = FALSE` (`OUT_OF_STOCK`).
  3. Bắn thông báo khẩn cấp (Push Notification / SMS) đến Quản lý cơ sở và Giám đốc Vận hành.
- Phiếu xuất hủy khẩn cấp (`InventoryDisposalVoucher`) bắt buộc upload 2 ảnh chứng cứ lên Cloudinary và định khoản chi phí khác TK 811.

### 19.5 Kiến trúc POS Ngoại tuyến (Offline Mode), Lưu trữ SQLite cục bộ & Ký số HMAC SHA-256
- POS Client (Electron / Web PWA) tự động chuyển sang chế độ Offline Mode khi mất kết nối mạng Internet.
- Lưu trữ cục bộ trên SQLite / IndexedDB với mã đơn offline tuần tự: `[BranchCode]-[PosId]-OFF-[Sequence]`.
- Mỗi giao dịch offline được ký số HMAC SHA-256 sử dụng hardware key lưu trữ trong POS keystore: `signature = HMAC_SHA256(orderPayload, deviceSecretKey)`.
- Khi có mạng trở lại, tiến trình `OfflineSyncQueue` đẩy đơn lên máy chủ theo FIFO. Thuật toán giải quyết xung đột tồn kho: **Ưu tiên Khách tại quầy**, đơn Web online bị xung đột hết hàng được tự động hủy hoàn tiền 100% kèm voucher đền bù 20%.

### 19.6 Kiến trúc Sổ cái Thanh toán kết hợp Đa phương thức (Split Payment Ledger)
- Mô hình quan hệ 1-N giữa `Order` và `PaymentTransaction`. Bất biến tài chính:
  $$Order.totalAmount = \sum(PaymentTransaction_{SUCCESS}.amount)$$
- Trình tự trừ tiền: Điểm/Voucher -> MoMo/VNPAY -> Thẻ POS -> Tiền mặt.
- Cơ chế Graceful Abort: Tự động đảo giao dịch hoàn tiền MoMo/VNPAY và trả lại điểm thành viên nếu giao dịch dở dang bị hủy.

### 19.7 Bổ sung Mô hình dữ liệu quan hệ (15 thực thể CSDL mở rộng)
1. `pos_printer_devices`: Thiết bị in, IP, port, vai trò, khổ giấy, máy in backup.
2. `print_jobs`: Hàng đợi in, payload ESC/POS, trạng thái, retryCount.
3. `bill_reprint_logs`: Lịch sử in lại hóa đơn, mã PIN quản lý, lý do, watermark.
4. `table_zones`: Khu vực/tầng bàn (Tầng trệt, Lầu 1, Sân vườn).
5. `restaurant_tables`: Bàn ăn, FSM trạng thái, đơn hàng active, mã QR động.
6. `table_reservations`: Đặt bàn trước, cọc, ân hạn 15m, tịch thu cọc No-show.
7. `cashier_shifts`: Ca làm việc, businessDate, tiền đầu ca, expected cash, actual cash.
8. `shift_cash_count_details`: Chi tiết đếm tiền mù theo mệnh giá (500k..1k).
9. `cash_discrepancy_reports`: Biên bản chênh lệch tiền két Cấp 3, chữ ký hai bên.
10. `cash_drop_transactions`: Giao dịch rút tiền giữa ca, mã niêm phong phong bì.
11. `cold_storage_units`: Tủ mát/tủ đông, dải nhiệt độ an toàn, trạng thái thiết bị.
12. `storage_temperature_logs`: Nhật ký nhiệt độ IoT/thủ công, cảnh báo vượt ngưỡng.
13. `inventory_disposal_vouchers`: Phiếu xuất hủy kho khẩn cấp, tổng tổn thất, cấp duyệt.
14. `disposal_evidence_media`: Ảnh chụp hiện trường (tem lô và đổ bỏ bồn rác).
15. `drink_waste_logs`: Sổ theo dõi lãng phí ly nước pha dở dang hoặc bỏ quên.

### 19.8 Ranh giới giao dịch mở rộng (TX Boundaries)
- `TX-09 (Atomic Table Move)`: Khóa bàn đích `SELECT FOR UPDATE`, cập nhật `Order.tableId`, đổi trạng thái 2 bàn trong 1 transaction.
- `TX-10 (Table Merge)`: Chuyển items sang Master Order, hủy voucher phụ, cập nhật cọc, đóng Slave Order `MERGED_VOID`.
- `TX-11 (Cash Drop)`: Ghi bản ghi rút tiền, trừ expected cash két, cập nhật sổ quỹ an toàn.
- `TX-12 (Automated Quarantine)`: Đổi trạng thái lô sang `QUARANTINED`, khóa `OUT_OF_STOCK` các món menu liên quan trong cùng commit.
- `TX-13 (Disposal Approval)`: Duyệt phiếu hủy, trừ tồn kho `IngredientLot`, ghi `StockMovement(DISPOSAL_LOSS)`, định khoản TK 811.
- `TX-14 (Split Tender Checkout)`: Ghi nhận giao dịch thành phần, cập nhật `remainingBalance`, chốt `Order.paymentStatus = PAID` khi balance = 0.
