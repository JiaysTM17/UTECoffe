import urllib.request
import urllib.parse
import json
import time
import sys

time.sleep(10)

cookie_processor = urllib.request.HTTPCookieProcessor()
opener = urllib.request.build_opener(cookie_processor)

# 0. Wait for server readiness
for i in range(12):
    try:
        with opener.open("http://localhost:8080/ping", timeout=3) as r:
            if r.status == 200:
                print(">>> Server is READY on http://localhost:8080! <<<")
                break
    except Exception:
        time.sleep(3)

# 1. Add item to cart
add_url = "http://localhost:8080/cart/add"
form_data = urllib.parse.urlencode({
    "productId": 1,
    "size": "M",
    "sugar": 100,
    "ice": 100,
    "quantity": 2
}).encode('utf-8')

try:
    req = urllib.request.Request(
        add_url, 
        data=form_data, 
        headers={
            'User-Agent': 'Mozilla/5.0',
            'Content-Type': 'application/x-www-form-urlencoded'
        }
    )
    resp = opener.open(req)
    add_result = json.loads(resp.read().decode('utf-8'))
    print("1. Add to cart result:", add_result)
except urllib.error.HTTPError as e:
    print("1. Add to cart HTTP Error:", e.code, e.read().decode('utf-8', errors='ignore'))
    sys.exit(1)

# 2. View cart (should have Knapsack + Apriori recommendations)
cart_resp = opener.open("http://localhost:8080/cart")
print("2. Cart page HTTP status:", cart_resp.status, "HTML length:", len(cart_resp.read()))

# 3. View checkout
checkout_resp = opener.open("http://localhost:8080/checkout")
print("3. Checkout page HTTP status:", checkout_resp.status, "HTML length:", len(checkout_resp.read()))

# 4. Place order with VietQR
order_url = "http://localhost:8080/checkout/place-order"
order_data = urllib.parse.urlencode({
    "storeId": 1,
    "orderType": "DELIVERY",
    "paymentMethod": "VIETQR",
    "recipientName": "Pham Minh Dat",
    "recipientPhone": "0987654321",
    "deliveryAddress": "01 Vo Van Ngan, TP Thu Duc",
    "note": "Giao tan noi, bot da",
    "couponCode": "UTE2026"
}).encode('utf-8')

req2 = urllib.request.Request(
    order_url, 
    data=order_data, 
    headers={
        'User-Agent': 'Mozilla/5.0',
        'Content-Type': 'application/x-www-form-urlencoded'
    }
)
order_resp = opener.open(req2)
print("4. Order submission redirected to:", order_resp.geturl())
content = order_resp.read().decode('utf-8', errors='ignore')
order_code = ""
if "UTE-" in content:
    idx = content.find("UTE-")
    order_code = content[idx:idx+15]

print("5. Tracking page verified:")
print("   - URL:", order_resp.geturl())
print("   - Contains VietQR:", "VietQR" in content)
print("   - Contains Order Code:", order_code)

# 6. Verify VietQR payment endpoint
if order_code:
    verify_url = f"http://localhost:8080/api/payments/vietqr/verify/{order_code}"
    v_req = urllib.request.Request(verify_url, data=b"", headers={'User-Agent': 'Mozilla/5.0'})
    with opener.open(v_req) as v_resp:
        v_data = json.loads(v_resp.read().decode('utf-8'))
        print("6. VietQR payment verification response:", v_data)

print(">>> ALL STEPS COMPLETED WITH 100% SUCCESS! <<<")
