Set-Location 'D:\A - Học Tập\Lập Trình Web\Đ.Án\apps\backend'

$lombok = 'C:\Users\PC HP\.m2\repository\org\projectlombok\lombok\1.18.36\lombok-1.18.36.jar'
$cp = "lib_cache/*;$lombok;target/classes"

$srcFiles = @(
    'src/main/java/com/utecoffe/dto/cart/CartItemViewDto.java',
    'src/main/java/com/utecoffe/dto/cart/CartViewDto.java',
    'src/main/java/com/utecoffe/entity/Order.java',
    'src/main/java/com/utecoffe/entity/OrderItem.java',
    'src/main/java/com/utecoffe/entity/Review.java',
    'src/main/java/com/utecoffe/entity/ProductSize.java',
    'src/main/java/com/utecoffe/security/SecurityConfig.java',
    'src/main/java/com/utecoffe/service/VietQrService.java',
    'src/main/java/com/utecoffe/service/impl/VietQrServiceImpl.java',
    'src/main/java/com/utecoffe/service/impl/ProductServiceImpl.java',
    'src/main/java/com/utecoffe/repository/TableReservationRepository.java',
    'src/main/java/com/utecoffe/entity/TableReservation.java',
    'src/main/java/com/utecoffe/dto/request/ReservationRequest.java',
    'src/main/java/com/utecoffe/service/TableReservationService.java',
    'src/main/java/com/utecoffe/service/impl/TableReservationServiceImpl.java',
    'src/main/java/com/utecoffe/service/impl/OrderServiceImpl.java',
    'src/main/java/com/utecoffe/controller/api/PaymentRestController.java',
    'src/main/java/com/utecoffe/controller/mvc/CartController.java',
    'src/main/java/com/utecoffe/controller/mvc/MenuController.java',
    'src/main/java/com/utecoffe/controller/mvc/StoreMvcController.java'
)

& javac -parameters -encoding UTF-8 -cp $cp -processorpath $lombok -d target/classes $srcFiles
if ($LASTEXITCODE -eq 0) {
    Write-Output ">>> JAVAC SUCCESSFUL! <<<"
} else {
    Write-Error ">>> JAVAC FAILED! <<<"
    exit 1
}
