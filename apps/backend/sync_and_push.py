import shutil
import os
import subprocess

src_base = r"D:\A - Học Tập\Lập Trình Web\Đ.Án\apps\backend"
dst_base = r"D:\Dự Án\UTECoffe-main\UTECoffe-main\apps\backend"

files = [
    r"src\main\java\com\utecoffe\service\VietQrService.java",
    r"src\main\java\com\utecoffe\service\impl\VietQrServiceImpl.java",
    r"src\main\java\com\utecoffe\service\impl\ProductServiceImpl.java",
    r"src\main\java\com\utecoffe\service\impl\TableReservationServiceImpl.java",
    r"src\main\java\com\utecoffe\repository\TableReservationRepository.java",
    r"src\main\java\com\utecoffe\controller\api\PaymentRestController.java",
    r"src\main\webapp\WEB-INF\views\customer\cart.jsp",
    r"src\main\webapp\WEB-INF\views\customer\order-tracking.jsp",
    r"app.war"
]

for f in files:
    s = os.path.join(src_base, f)
    d = os.path.join(dst_base, f)
    os.makedirs(os.path.dirname(d), exist_ok=True)
    shutil.copy2(s, d)
    print(f"Synced {f}")

repo_dir = r"D:\A - Học Tập\Lập Trình Web\Đ.Án"
def run_git(cmd):
    res = subprocess.run(cmd, cwd=repo_dir, capture_output=True, text=True, shell=True)
    print("GIT:", cmd)
    if res.stdout: print(res.stdout.strip())
    if res.stderr: print(res.stderr.strip())
    return res.returncode

run_git("git add -A")
run_git('git commit -m "feat(algorithms): add Levenshtein fuzzy search, EMVCo CRC-16 VietQR, Greedy Best-Fit table reservation and interactive cart sync"')
run_git("git push origin main")
print(">>> ALL SYNCED & PUSHED TO GITHUB! <<<")
