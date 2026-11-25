import urllib.request
import time
import sys

time.sleep(5)

urls = [
    ("Homepage", "http://localhost:8080/"),
    ("Menu", "http://localhost:8080/menu"),
    ("Cart", "http://localhost:8080/cart"),
    ("Checkout", "http://localhost:8080/checkout"),
    ("Stores", "http://localhost:8080/stores"),
    ("Barista KDS", "http://localhost:8080/barista"),
    ("Products API", "http://localhost:8080/api/products")
]

all_ok = True
for name, url in urls:
    for attempt in range(6):
        try:
            req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
            with urllib.request.urlopen(req, timeout=10) as resp:
                status = resp.status
                length = len(resp.read())
                print(f"[OK] {name}: HTTP {status} ({length:,} bytes)")
                break
        except Exception as e:
            if attempt < 5:
                time.sleep(2)
            else:
                print(f"[FAIL] {name} ({url}): {e}")
                all_ok = False

if not all_ok:
    sys.exit(1)
print("ALL VERIFIED SUCCESSFULLY!")
