import subprocess

repo_dir = r"D:\A - Học Tập\Lập Trình Web\Đ.Án"

def run_git(cmd):
    result = subprocess.run(cmd, cwd=repo_dir, capture_output=True, text=True, shell=True)
    print("CMD:", cmd)
    print("STDOUT:", result.stdout)
    if result.stderr:
        print("STDERR:", result.stderr)
    return result.returncode

run_git("git remote -v")
run_git("git status --short")
run_git("git add apps/backend/src/main/java/com/utecoffe/dto/cart")
run_git("git add apps/backend/src/main/java/com/utecoffe/entity/Order.java")
run_git("git add apps/backend/src/main/java/com/utecoffe/entity/OrderItem.java")
run_git("git add apps/backend/src/main/java/com/utecoffe/entity/ProductSize.java")
run_git("git add apps/backend/src/main/java/com/utecoffe/security/SecurityConfig.java")
run_git("git add apps/backend/src/main/java/com/utecoffe/service/impl/OrderServiceImpl.java")
run_git("git add apps/backend/src/main/java/com/utecoffe/controller/api/PaymentRestController.java")
run_git("git add apps/backend/src/main/java/com/utecoffe/controller/mvc/CartController.java")
run_git("git add apps/backend/src/main/webapp/WEB-INF/views/customer/product-detail.jsp")
run_git("git add apps/backend/src/main/webapp/WEB-INF/views/customer/checkout.jsp")
run_git("git add apps/backend/src/main/webapp/WEB-INF/views/customer/order-tracking.jsp")
run_git('git commit -m "feat(order-flow): deepen fullstack ordering flow with Knapsack vouchers, Apriori pairings, Haversine store routing & dynamic VietQR"')
run_git("git push origin main")
