import shutil
import os

src_base = r"D:\A - Học Tập\Lập Trình Web\Đ.Án\apps\backend"
dst_base = r"D:\Dự Án\UTECoffe-main\UTECoffe-main\apps\backend"

files = [
    r"src\main\java\com\utecoffe\dto\cart\CartItemViewDto.java",
    r"src\main\java\com\utecoffe\dto\cart\CartViewDto.java",
    r"src\main\java\com\utecoffe\entity\Order.java",
    r"src\main\java\com\utecoffe\entity\OrderItem.java",
    r"src\main\java\com\utecoffe\entity\ProductSize.java",
    r"src\main\java\com\utecoffe\security\SecurityConfig.java",
    r"src\main\java\com\utecoffe\service\impl\OrderServiceImpl.java",
    r"src\main\java\com\utecoffe\controller\api\PaymentRestController.java",
    r"src\main\java\com\utecoffe\controller\mvc\CartController.java",
    r"src\main\webapp\WEB-INF\views\customer\product-detail.jsp",
    r"src\main\webapp\WEB-INF\views\customer\checkout.jsp",
    r"src\main\webapp\WEB-INF\views\customer\order-tracking.jsp",
    r"app.war"
]

for f in files:
    s = os.path.join(src_base, f)
    d = os.path.join(dst_base, f)
    os.makedirs(os.path.dirname(d), exist_ok=True)
    shutil.copy2(s, d)
    print(f"Copied {f}")

print(">>> ALL FILES SYNCED SUCCESSFULLY! <<<")
