package com.utecoffe.config;

import com.utecoffe.entity.*;
import com.utecoffe.enums.*;
import com.utecoffe.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Component
@Profile("!test")
public class DatabaseSeeder implements CommandLineRunner {

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private StoreRepository storeRepository;

    @Autowired
    private StoreTableRepository storeTableRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ProductSizeRepository productSizeRepository;

    @Autowired
    private ToppingRepository toppingRepository;

    @Autowired
    private IngredientRepository ingredientRepository;

    @Autowired
    private StoreInventoryRepository storeInventoryRepository;

    @Autowired
    private CouponRepository couponRepository;

    @Autowired
    private LoyaltyCardRepository loyaltyCardRepository;

    @Autowired
    private LoyaltyTransactionRepository loyaltyTransactionRepository;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderItemRepository orderItemRepository;

    @Autowired
    private UserCouponRepository userCouponRepository;

    @Autowired
    private SupplierRepository supplierRepository;

    @Autowired
    private PurchaseOrderRepository purchaseOrderRepository;

    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    private RecipeRepository recipeRepository;

    @Autowired
    private RefundRepository refundRepository;

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        if (roleRepository.count() == 0) {
            seedRolesAndUsers();
            seedStoresAndTables();
        }
        if (productRepository.count() < 36) {
            seedCatalogAndBOM();
        }
        if (couponRepository.count() == 0) {
            seedCoupons();
        }
        if (orderRepository.count() == 0) {
            seedCustomerProfilesAndOrders();
        }
        seedEnterpriseModules();
        System.out.println(">>> UTECoffe: Database status verified. Products in DB: " + productRepository.count());
    }

    private void seedRolesAndUsers() {
        Role adminRole = roleRepository.save(Role.builder().name(RoleName.ROLE_ADMIN).description("Quan tri toan quyen").build());
        Role managerRole = roleRepository.save(Role.builder().name(RoleName.ROLE_STORE_MANAGER).description("Quan ly chi nhanh").build());
        Role baristaRole = roleRepository.save(Role.builder().name(RoleName.ROLE_BARISTA).description("Pha che KDS").build());
        Role customerRole = roleRepository.save(Role.builder().name(RoleName.ROLE_CUSTOMER).description("Khach hang thanh vien").build());

        String defaultPass = passwordEncoder.encode("Admin@2026");

        userRepository.save(User.builder()
                .fullName("Quản Trị Viên UTECoffe")
                .email("admin@utecoffe.vn")
                .phoneNumber("0901234567")
                .passwordHash(defaultPass)
                .role(adminRole)
                .status(true)
                .build());

        userRepository.save(User.builder()
                .fullName("Barista Trưởng Thủ Đức")
                .email("barista.thuduc@utecoffe.vn")
                .phoneNumber("0907654321")
                .passwordHash(defaultPass)
                .role(baristaRole)
                .status(true)
                .build());

        // 3 Khách Hàng Đặc Biệt với 3 Cấp Bậc Riêng Biệt:
        // 1. Nguyễn Thị Mai Phương - Hạng Đồng (Bronze)
        userRepository.save(User.builder()
                .fullName("Nguyễn Thị Mai Phương")
                .email("phuong.bronze@utecoffe.vn")
                .phoneNumber("0911223344")
                .passwordHash(defaultPass)
                .role(customerRole)
                .status(true)
                .build());

        // 2. Trần Quốc Bảo - Hạng Bạc (Silver)
        userRepository.save(User.builder()
                .fullName("Trần Quốc Bảo")
                .email("bao.silver@utecoffe.vn")
                .phoneNumber("0933445566")
                .passwordHash(defaultPass)
                .role(customerRole)
                .status(true)
                .build());

        // 3. Lê Hoàng Yến Vy - Hạng Kim Cương VIP (Diamond)
        userRepository.save(User.builder()
                .fullName("Lê Hoàng Yến Vy")
                .email("vy.diamond@utecoffe.vn")
                .phoneNumber("0977889900")
                .passwordHash(defaultPass)
                .role(customerRole)
                .status(true)
                .build());

        userRepository.save(User.builder()
                .fullName("Nguyễn Văn A (Khách Hàng)")
                .email("khachhang@gmail.com")
                .phoneNumber("0912345678")
                .passwordHash(defaultPass)
                .role(customerRole)
                .status(true)
                .build());
    }

    private void seedStoresAndTables() {
        Store s1 = storeRepository.save(Store.builder()
                .name("UTECoffe Flagship Thủ Đức")
                .address("01 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức, TP.HCM")
                .latitude(10.8514)
                .longitude(106.7720)
                .phoneNumber("02838968641")
                .openingTime("07:00")
                .closingTime("22:30")
                .isActive(true)
                .build());

        Store s2 = storeRepository.save(Store.builder()
                .name("UTECoffe Roastery Quận 1")
                .address("68 Lê Lợi, Bến Nghé, Quận 1, TP.HCM")
                .latitude(10.7735)
                .longitude(106.7001)
                .phoneNumber("02838221999")
                .openingTime("06:30")
                .closingTime("23:00")
                .isActive(true)
                .build());

        Store s3 = storeRepository.save(Store.builder()
                .name("UTECoffe Garden Bình Thạnh")
                .address("180 Ung Văn Khiêm, Phường 25, Q. Bình Thạnh, TP.HCM")
                .latitude(10.8030)
                .longitude(106.7155)
                .phoneNumber("02835128888")
                .openingTime("07:00")
                .closingTime("22:30")
                .isActive(true)
                .build());

        storeTableRepository.save(StoreTable.builder().store(s1).tableNumber("T-01").capacity(2).isOccupied(false).isActive(true).build());
        storeTableRepository.save(StoreTable.builder().store(s1).tableNumber("T-02").capacity(4).isOccupied(false).isActive(true).build());
        storeTableRepository.save(StoreTable.builder().store(s1).tableNumber("VIP-01").capacity(8).isOccupied(false).isActive(true).build());

        storeTableRepository.save(StoreTable.builder().store(s2).tableNumber("Q1-01").capacity(2).isOccupied(false).isActive(true).build());
        storeTableRepository.save(StoreTable.builder().store(s2).tableNumber("Q1-VIP").capacity(6).isOccupied(false).isActive(true).build());

        storeTableRepository.save(StoreTable.builder().store(s3).tableNumber("BT-01").capacity(2).isOccupied(false).isActive(true).build());
        storeTableRepository.save(StoreTable.builder().store(s3).tableNumber("BT-GARDEN").capacity(8).isOccupied(false).isActive(true).build());
    }

    public void seedCatalogAndBOM() {
        Category cCoffee = getOrCreateCategory("Cà Phê Đặc Sản", "ca-phe-dac-san", 1);
        Category cTea = getOrCreateCategory("Trà Thượng Hạng", "tra-thuong-hang", 2);
        Category cPastry = getOrCreateCategory("Bánh Ngọt Thủ Công", "banh-ngot-thu-cong", 3);

        // Specialty Coffee (13 items)
        createProductWithSizes(cCoffee, "Cold Brew Cam Vàng Specialty", "cold-brew-cam-vang-specialty",
                "Cà phê Arabica ủ lạnh 18 tiếng kết hợp nước cam vàng Sunkist mọng nước nguyên chất.",
                "/assets/images/products/coldbrew-cam-vang.jpg", 59000, true);

        createProductWithSizes(cCoffee, "Espresso Tonic Signature", "espresso-tonic-signature",
                "Double shot Espresso Cầu Đất đậm đà trên nền nước tonic cao cấp và lát chanh vàng tươi mát.",
                "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?q=80&w=800", 55000, true);

        createProductWithSizes(cCoffee, "Cà Phê Muối Hoàng Gia", "ca-phe-muoi-hoang-gia",
                "Cà phê Robusta mộc Cầu Đất kết hợp lớp kem béo mặn caramel hoàng gia bùng nổ vị giác.",
                "https://images.unsplash.com/photo-1572442388796-11668a67e53d?q=80&w=800", 52000, true);

        createProductWithSizes(cCoffee, "Pour-Over V60 Bourbon Cầu Đất", "pour-over-v60-bourbon-cau-dat",
                "Chiết xuất thủ công từng giọt tinh hoa, dải hương hoa nhài trắng và quả mọng thanh khiết.",
                "/assets/images/products/pourover-v60.jpg", 68000, false);

        createProductWithSizes(cCoffee, "Latte Sữa Yến Mạch Oatly", "latte-sua-yen-mach-oatly",
                "Espresso rang mộc hòa quyện sữa yến mạch Oatly Thụy Điển béo bùi, thuần thực vật.",
                "https://images.unsplash.com/photo-1534778101976-62847782c213?q=80&w=800", 65000, false);

        createProductWithSizes(cCoffee, "Flat White Cầu Đất Double Shot", "flat-white-cau-dat-double-shot",
                "Lớp bọt sữa microfoam mịn màng hòa quyện 2 shot espresso đậm đà thơm ngậy.",
                "https://images.unsplash.com/photo-1577968897966-3d4325b36b61?q=80&w=800", 59000, false);

        createProductWithSizes(cCoffee, "Affogato Gelato Vani", "affogato-gelato-vani",
                "Single shot Espresso Cầu Đất đậm đà rót trực tiếp trên viên kem gelato vani Madagascar ngọt ngào, tạo độ tương phản nhiệt độ và hương vị đỉnh cao.",
                "/assets/images/products/affogato.jpg", 55000, false);

        createProductWithSizes(cCoffee, "Cà Phê Trứng Hà Nội Specialty", "ca-phe-trung-ha-noi-specialty",
                "Cà phê phin Cầu Đất hòa quyện cùng lớp kem trứng đánh bông mịn như mây, thơm bùi béo ngậy không tanh, chuẩn phong vị hoàng thành.",
                "/assets/images/products/ca-phe-trung.jpg", 56000, false);

        createProductWithSizes(cCoffee, "Cold Brew Ủ Thùng Gỗ Sồi", "cold-brew-u-thung-go-soi",
                "Cà phê Arabica Cầu Đất ủ 48 giờ trong thùng gỗ sồi, tạo tầng hương khói gỗ, vanilla và caramel nồng nàn độc bản.",
                "https://images.unsplash.com/photo-1517701604599-bb29b565090c?q=80&w=800", 68000, true);

        createProductWithSizes(cCoffee, "Cà Phê Dừa Non Bến Tre", "ca-phe-dua-non-ben-tre",
                "Espresso Cầu Đất đậm đà rót trên nền cốt dừa tươi Bến Tre xay mịn cùng cơm dừa non sấy giòn thơm bùi.",
                "https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=800", 55000, false);

        createProductWithSizes(cCoffee, "Cold Brew Sparkling Yuzu", "cold-brew-sparkling-yuzu",
                "Cà phê Arabica Cầu Đất ủ lạnh 24 giờ phối cùng nước ép quả Yuzu Nhật Bản và bọt sủi sparkling thanh mát đánh thức mọi giác quan.",
                "/assets/images/products/coldbrew-sparkling-yuzu.jpg", 65000, true);

        createProductWithSizes(cCoffee, "Cà Phê Bạc Xỉu 4 Tầng Cầu Đất", "ca-phe-bac-xiu-4-tang-cau-dat",
                "Tuyệt phẩm phân tầng thị giác nghệ thuật: sữa đặc thượng hạng, sữa tươi thanh trùng Đà Lạt, cà phê Arabica và bọt microfoam bồng bềnh.",
                "https://images.unsplash.com/photo-1461023058943-07fcbe16d735?q=80&w=800", 49000, false);

        createProductWithSizes(cCoffee, "Single Origin Geisha Panama Pour-Over", "single-origin-geisha-panama-pour-over",
                "Dòng hạt Geisha quý hiếm hàng đầu thế giới được pha thủ công tại bàn, bùng nổ nốt hương hoa cam, quả mơ và mật ong rừng nguyên bản.",
                "https://images.unsplash.com/photo-1518057111178-44a106bad636?q=80&w=800", 85000, false);

        // Artisanal Tea (12 items)
        createProductWithSizes(cTea, "Trà Oolong Kem Phô Mai Vàng", "tra-oolong-kem-phomai-vang",
                "Trà Oolong nướng Mộc Châu thơm lừng kết hợp lớp macchiato phô mai béo ngậy sánh mịn đỉnh cao.",
                "https://images.unsplash.com/photo-1558160074-4d7d8bdf4256?q=80&w=800", 62000, true);

        createProductWithSizes(cTea, "Trà Sen Vàng Macchiato Tây Hồ", "tra-sen-vang-macchiato-tay-ho",
                "Trà ướp hoa sen bách diệp Tây Hồ ngát hương, hạt sen tươi hầm mềm bùi và củ năng giòn ngọt.",
                "/assets/images/products/tra-sen-tay-ho.jpg", 65000, true);

        createProductWithSizes(cTea, "Trà Nhài Mãng Cầu Đắk Lắk", "tra-nhai-mang-cau-dak-lak",
                "Trà hoa nhài thanh khiết kết hợp những tép mãng cầu xiêm Đắk Lắk dầm chua ngọt thanh mát giải nhiệt.",
                "https://images.unsplash.com/photo-1556881286-fc6915169721?q=80&w=800", 55000, false);

        createProductWithSizes(cTea, "Trà Đào Cam Sả Thảo Mộc", "tra-dao-cam-sa-thao-moc",
                "Hương sả tươi nồng ấm, lát cam vàng mọng nước và từng miếng đào ngâm giòn ngọt quyến rũ.",
                "/assets/images/products/tra-dao-cam-sa.jpg", 52000, false);

        createProductWithSizes(cTea, "Matcha Latte Uji Kyoto Nguyên Bản", "matcha-latte-uji-kyoto",
                "Bột trà xanh Uji Kyoto nghiền cối đá truyền thống hòa quyện sữa tươi thanh trùng Đà Lạt ngậy ngọt dịu dàng.",
                "https://images.unsplash.com/photo-1536256263959-770b48d82b0a?q=80&w=800", 65000, true);

        createProductWithSizes(cTea, "Trà Sữa Oolong Rang Khói", "tra-sua-oolong-rang-khoi",
                "Trà Oolong sao trên than hoa nồng đượm khói ấm quyện sữa béo ngậy và trân châu hoàng kim dẻo dai.",
                "https://images.unsplash.com/photo-1576092768241-dec231879fc3?q=80&w=800", 58000, false);

        createProductWithSizes(cTea, "Trà Vải Hoa Hồng Damask", "tra-vai-hoa-hong-damask",
                "Trà đen hảo hạng ướp nụ hoa hồng Damask thơm ngát, trái vải mọng nước ngọt ngào quý phái.",
                "/assets/images/products/tra-vai-hoa-hong.jpg", 58000, false);

        createProductWithSizes(cTea, "Trà Long Nhãn Hạt Chia Hưng Yên", "tra-long-nhan-hat-chia-hung-yen",
                "Trà đen cổ thụ ướp long nhãn cùi dày ngọt thanh tiến vua Hưng Yên kết hợp hạt chia organic thanh lọc cơ thể.",
                "/assets/images/products/tra-long-nhan.jpg", 54000, false);

        createProductWithSizes(cTea, "Hojicha Latte Rang Củi Nhật Bản", "hojicha-latte-rang-cui-nhat-ban",
                "Trà xanh Hojicha sao lửa củi truyền thống Nhật Bản, vị thơm khói bánh nướng đặc trưng kết hợp sữa béo ngậy không caffeine.",
                "https://images.unsplash.com/photo-1517701604599-bb29b565090c?q=80&w=800", 62000, false);

        createProductWithSizes(cTea, "Trà Bưởi Hồng Ruby Mật Ong Bạc Hà", "tra-buoi-hong-ruby-mat-ong",
                "Trà xanh ướp hoa bưởi kết hợp tép bưởi hồng Ruby căng mọng chua ngọt và mật ong hoa bạc hà mát lạnh thanh lọc cơ thể.",
                "https://images.unsplash.com/photo-1753719055878-8da0e4d1a021?q=80&w=800", 55000, false);

        createProductWithSizes(cTea, "Trà Dâu Tây Đà Lạt Macchiato Kem Mặn", "tra-dau-tay-da-lat-macchiato",
                "Nền trà nhài hữu cơ phối cùng dâu tây giống Nhật Bản trồng tại Đà Lạt dầm tươi, phủ lớp kem mặn béo ngậy sánh mịn.",
                "https://images.unsplash.com/photo-1553530666-ba11a7da3888?q=80&w=800", 58000, true);

        createProductWithSizes(cTea, "Trà Thảo Mộc Cúc La Mã & Táo Đỏ", "tra-thao-moc-cuc-la-ma-tao-do",
                "Trà hoa cúc Chamomile hữu cơ kết hợp táo đỏ Tân Cương và kỷ tử ninh nhừ, thơm dịu giúp thư giãn và ngủ ngon sâu giấc.",
                "/assets/images/products/tra-cuc-la-ma.jpg", 52000, false);

        // Craft Pastry & Bakery (11 items)
        createProductWithSizes(cPastry, "Croissant Bơ Pháp Thủ Công", "croissant-bo-phap-thu-cong",
                "Bánh sừng bò ngàn lớp nướng giòn rụm với 100% bơ Elle & Vire thơm lừng chuẩn vị Paris.",
                "https://images.unsplash.com/photo-1555507036-ab1f4038808a?q=80&w=800", 45000, true);

        createProductWithSizes(cPastry, "Pain Au Chocolat Bơ Tươi", "pain-au-chocolat-bo-tuoi",
                "Bánh cuộn bơ Pháp giòn tan bên ngoài, nhân socola đắng Bỉ tan chảy ngọt ngào bên trong.",
                "/assets/images/products/pain-au-chocolat.jpg", 48000, false);

        createProductWithSizes(cPastry, "Tiramisu Espresso Mascarpone", "tiramisu-espresso-mascarpone",
                "Bánh Tiramisu Ý truyền thống tẩm đẫm espresso Cầu Đất, phô mai Mascarpone và bột cacao.",
                "https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?q=80&w=800", 58000, false);

        createProductWithSizes(cPastry, "Canelé De Bordeaux Truyền Thống", "canele-de-bordeaux-truyen-thong",
                "Bánh Pháp vỏ caramel giòn sẫm bóng bẩy, ruột mềm ẩm dẻo quánh hương vani và rượu rum.",
                "/assets/images/products/canele-bordeaux.jpg", 42000, false);

        createProductWithSizes(cPastry, "Mousse Dâu Tằm Rừng Đà Lạt", "mousse-dau-tam-rung-da-lat",
                "Lớp bánh mousse mịn màng chế tác từ dâu tằm rừng Đà Lạt tươi chua ngọt sảng khoái.",
                "/assets/images/products/mousse-dau-tam.jpg", 52000, false);

        createProductWithSizes(cPastry, "Basque Burnt Cheesecake Nướng Cháy", "basque-burnt-cheesecake",
                "Bánh phô mai nướng cháy xém bề mặt theo phong cách San Sebastián với lớp kem phô mai béo ngậy tan chảy ở tâm.",
                "/assets/images/products/basque-cheesecake.jpg", 62000, false);

        createProductWithSizes(cPastry, "Bánh Tart Dâu Tây & Quả Mọng", "banh-tart-dau-tay-qua-mong",
                "Vỏ bánh tart bột hạnh nhân nướng vàng giòn, phủ kem pastry vani Pháp và dâu tây tươi Đà Lạt căng mọng.",
                "/assets/images/products/tart-dau-tay.jpg", 55000, false);

        createProductWithSizes(cPastry, "Croffle Bơ Nướng Mật Ong Rừng", "croffle-bo-nuong-mat-ong-rung",
                "Bánh sừng bò ép waffle nóng giòn phủ lớp đường caramel giòn rụm và mật ong hoa bạc hà nguyên chất thơm lừng.",
                "https://images.unsplash.com/photo-1562376552-0d160a2f238d?q=80&w=800", 48000, false);

        createProductWithSizes(cPastry, "Bánh Danish Đào & Phô Mai Tươi", "banh-danish-dao-pho-mai-tuoi",
                "Vỏ bánh nghìn lớp bơ Pháp vàng ươm ôm trọn lớp kem phô mai béo ngậy và miếng đào vàng tươi mọng nước thơm ngọt.",
                "/assets/images/products/danish-dao.jpg", 46000, false);

        createProductWithSizes(cPastry, "Croissant Kẹp Phô Mai & Jambon Pháp", "croissant-jambon-pho-mai-phap",
                "Bánh sừng bò nướng giòn rụm kẹp thịt nguội Jambon Pháp cao cấp, phô mai Cheddar tan chảy và mù tạt vàng Dijon cay dịu.",
                "/assets/images/products/croissant-jambon.jpg", 58000, true);

        createProductWithSizes(cPastry, "Bánh Sourdough Bơ Tỏi Lá Thyme", "banh-sourdough-bo-toi-la-thyme",
                "Bánh mì men tự nhiên ủ 36 giờ nướng giòn tan trên đá, phết đẫm bơ Elle & Vire tỏi nướng và lá thyme thơm lừng nức mũi.",
                "https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?q=80&w=800", 45000, false);
        if (toppingRepository.count() == 0) {
            toppingRepository.save(Topping.builder().name("Trân Châu Oolong Hoàng Kim").price(BigDecimal.valueOf(10000)).isAvailable(true).build());
            toppingRepository.save(Topping.builder().name("Kem Cheese Kem Mặn Signature").price(BigDecimal.valueOf(15000)).isAvailable(true).build());
            toppingRepository.save(Topping.builder().name("Thạch Nha Đam Mật Ong").price(BigDecimal.valueOf(10000)).isAvailable(true).build());
        }

        if (ingredientRepository.count() == 0) {
            ingredientRepository.save(Ingredient.builder().name("Hạt Cà Phê Arabica Cầu Đất").sku("ING-CF-ARA").unit("gram").minThreshold(BigDecimal.valueOf(5000)).currentCostPrice(BigDecimal.valueOf(320)).build());
            ingredientRepository.save(Ingredient.builder().name("Lá Trà Oolong Lâm Đồng").sku("ING-TEA-OOL").unit("gram").minThreshold(BigDecimal.valueOf(3000)).currentCostPrice(BigDecimal.valueOf(450)).build());
            ingredientRepository.save(Ingredient.builder().name("Sữa Tươi Thanh Trùng Dalat Milk").sku("ING-MILK-DL").unit("ml").minThreshold(BigDecimal.valueOf(10000)).currentCostPrice(BigDecimal.valueOf(42)).build());
            ingredientRepository.save(Ingredient.builder().name("Bơ Pháp Elle & Vire").sku("ING-BUTTER-EV").unit("gram").minThreshold(BigDecimal.valueOf(5000)).currentCostPrice(BigDecimal.valueOf(280)).build());
        }
    }

    private Category getOrCreateCategory(String name, String slug, int order) {
        return categoryRepository.findBySlug(slug)
                .orElseGet(() -> categoryRepository.save(Category.builder()
                        .name(name)
                        .slug(slug)
                        .displayOrder(order)
                        .isActive(true)
                        .build()));
    }

    private void createProductWithSizes(Category cat, String name, String slug, String desc, String img, int price, boolean featured) {
        if (productRepository.findBySlug(slug).isPresent()) {
            return;
        }
        Product p = productRepository.save(Product.builder()
                .category(cat)
                .name(name)
                .slug(slug)
                .description(desc)
                .imageUrl(img)
                .basePrice(BigDecimal.valueOf(price))
                .isAvailable(true)
                .isFeatured(featured)
                .build());

        productSizeRepository.save(ProductSize.builder().product(p).sizeName("Regular (M)").extraPrice(BigDecimal.ZERO).build());
        productSizeRepository.save(ProductSize.builder().product(p).sizeName("Large (L)").extraPrice(BigDecimal.valueOf(10000)).build());
    }

    private void seedCoupons() {
        couponRepository.save(Coupon.builder()
                .code("UTE2026")
                .title("Ưu Đãi Chào Mừng Thành Viên Mới")
                .description("Giảm 20% cho đơn hàng đầu tiên")
                .discountType(DiscountType.PERCENTAGE)
                .discountValue(BigDecimal.valueOf(20))
                .minOrderValue(BigDecimal.valueOf(50000))
                .maxDiscountAmount(BigDecimal.valueOf(30000))
                .startDate(LocalDateTime.now())
                .endDate(LocalDateTime.now().plusDays(365))
                .usageLimit(10000)
                .usedCount(0)
                .isActive(true)
                .build());

        couponRepository.save(Coupon.builder()
                .code("FREESHIP")
                .title("Miễn Phí Giao Hàng Toàn Quốc")
                .description("Miễn phí vận chuyển cho đơn hàng từ 100k")
                .discountType(DiscountType.FIXED_AMOUNT)
                .discountValue(BigDecimal.valueOf(30000))
                .minOrderValue(BigDecimal.valueOf(100000))
                .startDate(LocalDateTime.now())
                .endDate(LocalDateTime.now().plusDays(365))
                .usageLimit(5000)
                .usedCount(0)
                .isActive(true)
                .build());

        couponRepository.save(Coupon.builder()
                .code("SILVER10")
                .title("Voucher Hàng Tháng Hạng Bạc")
                .description("Giảm 10% toàn bộ thực đơn dành riêng cho hội viên Bạc")
                .discountType(DiscountType.PERCENTAGE)
                .discountValue(BigDecimal.valueOf(10))
                .minOrderValue(BigDecimal.valueOf(80000))
                .maxDiscountAmount(BigDecimal.valueOf(40000))
                .startDate(LocalDateTime.now())
                .endDate(LocalDateTime.now().plusDays(365))
                .usageLimit(1000)
                .usedCount(0)
                .isActive(true)
                .build());

        couponRepository.save(Coupon.builder()
                .code("TOPPINGFREE")
                .title("Tặng 01 Phần Topping Tự Chọn")
                .description("Miễn phí 1 phần Topping Macchiato hoặc Trân châu")
                .discountType(DiscountType.FIXED_AMOUNT)
                .discountValue(BigDecimal.valueOf(15000))
                .minOrderValue(BigDecimal.valueOf(50000))
                .startDate(LocalDateTime.now())
                .endDate(LocalDateTime.now().plusDays(365))
                .usageLimit(1000)
                .usedCount(0)
                .isActive(true)
                .build());

        couponRepository.save(Coupon.builder()
                .code("DIAMOND15")
                .title("Đặc Quyền Kim Cương Giảm 15%")
                .description("Giảm trực tiếp 15% trọn đời trên mọi hóa đơn")
                .discountType(DiscountType.PERCENTAGE)
                .discountValue(BigDecimal.valueOf(15))
                .minOrderValue(BigDecimal.ZERO)
                .maxDiscountAmount(BigDecimal.valueOf(150000))
                .startDate(LocalDateTime.now())
                .endDate(LocalDateTime.now().plusDays(365))
                .usageLimit(500)
                .usedCount(0)
                .isActive(true)
                .build());

        couponRepository.save(Coupon.builder()
                .code("BIRTHDAYVIP")
                .title("Quà Tặng Sinh Nhật Kim Cương")
                .description("01 Ly Signature + 01 Bánh Sừng Bò miễn phí tháng sinh nhật")
                .discountType(DiscountType.FIXED_AMOUNT)
                .discountValue(BigDecimal.valueOf(110000))
                .minOrderValue(BigDecimal.ZERO)
                .startDate(LocalDateTime.now())
                .endDate(LocalDateTime.now().plusDays(365))
                .usageLimit(100)
                .usedCount(0)
                .isActive(true)
                .build());

        couponRepository.save(Coupon.builder()
                .code("CUPPINGVIP")
                .title("Vé Mời Private Cupping Roastery Tour")
                .description("Tham dự buổi thử nếm cà phê đỉnh cao cùng Master Roaster")
                .discountType(DiscountType.FIXED_AMOUNT)
                .discountValue(BigDecimal.ZERO)
                .minOrderValue(BigDecimal.ZERO)
                .startDate(LocalDateTime.now())
                .endDate(LocalDateTime.now().plusDays(365))
                .usageLimit(50)
                .usedCount(0)
                .isActive(true)
                .build());
    }

    private void seedCustomerProfilesAndOrders() {
        User uBronze = userRepository.findByEmail("phuong.bronze@utecoffe.vn").orElse(null);
        User uSilver = userRepository.findByEmail("bao.silver@utecoffe.vn").orElse(null);
        User uDiamond = userRepository.findByEmail("vy.diamond@utecoffe.vn").orElse(null);

        if (uBronze == null || uSilver == null || uDiamond == null) return;

        Store s1 = storeRepository.findById(1L).orElse(null);
        Store s2 = storeRepository.findById(2L).orElse(null);
        Store s3 = storeRepository.findById(3L).orElse(null);
        if (s1 == null) return;
        if (s2 == null) s2 = s1;
        if (s3 == null) s3 = s1;

        // 1. Loyalty Cards
        LoyaltyCard cardBronze = loyaltyCardRepository.save(LoyaltyCard.builder()
                .user(uBronze)
                .cardNumber("UTE-BRONZE-8801")
                .pointsBalance(120)
                .lifetimePoints(120)
                .tier(LoyaltyTier.BRONZE)
                .build());

        LoyaltyCard cardSilver = loyaltyCardRepository.save(LoyaltyCard.builder()
                .user(uSilver)
                .cardNumber("UTE-SILVER-6622")
                .pointsBalance(850)
                .lifetimePoints(850)
                .tier(LoyaltyTier.SILVER)
                .build());

        LoyaltyCard cardDiamond = loyaltyCardRepository.save(LoyaltyCard.builder()
                .user(uDiamond)
                .cardNumber("UTE-DIAMOND-9999")
                .pointsBalance(3650)
                .lifetimePoints(3650)
                .tier(LoyaltyTier.DIAMOND)
                .build());

        // 2. Loyalty Transactions
        loyaltyTransactionRepository.save(LoyaltyTransaction.builder()
                .loyaltyCard(cardBronze)
                .pointsChange(120)
                .transactionType("EARN")
                .description("Tích 10% từ Đơn hàng #UTE-ORD-1010")
                .createdAt(LocalDateTime.now().minusDays(2))
                .build());

        loyaltyTransactionRepository.save(LoyaltyTransaction.builder()
                .loyaltyCard(cardSilver)
                .pointsChange(320)
                .transactionType("EARN")
                .description("Tích 10% từ Đơn hàng #UTE-ORD-1021")
                .createdAt(LocalDateTime.now().minusDays(10))
                .build());
        loyaltyTransactionRepository.save(LoyaltyTransaction.builder()
                .loyaltyCard(cardSilver)
                .pointsChange(280)
                .transactionType("EARN")
                .description("Tích 10% từ Đơn hàng #UTE-ORD-1022")
                .createdAt(LocalDateTime.now().minusDays(5))
                .build());
        loyaltyTransactionRepository.save(LoyaltyTransaction.builder()
                .loyaltyCard(cardSilver)
                .pointsChange(250)
                .transactionType("EARN")
                .description("Tích 10% từ Đơn hàng #UTE-ORD-1023")
                .createdAt(LocalDateTime.now().minusDays(1))
                .build());

        loyaltyTransactionRepository.save(LoyaltyTransaction.builder()
                .loyaltyCard(cardDiamond)
                .pointsChange(1200)
                .transactionType("EARN")
                .description("Tích lũy từ Tiệc Hội Nghị VIP Lounge Flagship")
                .createdAt(LocalDateTime.now().minusDays(15))
                .build());
        loyaltyTransactionRepository.save(LoyaltyTransaction.builder()
                .loyaltyCard(cardDiamond)
                .pointsChange(950)
                .transactionType("EARN")
                .description("Tích lũy từ Hộp Quà Hạt Geisha & Trà Shan Tuyết")
                .createdAt(LocalDateTime.now().minusDays(8))
                .build());
        loyaltyTransactionRepository.save(LoyaltyTransaction.builder()
                .loyaltyCard(cardDiamond)
                .pointsChange(1500)
                .transactionType("EARN")
                .description("Tích lũy từ Chuỗi Thưởng Thức Tại Bình Thạnh Garden")
                .createdAt(LocalDateTime.now().minusDays(2))
                .build());

        // 3. User Coupons
        couponRepository.findByCode("UTE2026").ifPresent(c -> userCouponRepository.save(UserCoupon.builder().user(uBronze).coupon(c).isUsed(false).build()));
        couponRepository.findByCode("FREESHIP").ifPresent(c -> {
            userCouponRepository.save(UserCoupon.builder().user(uBronze).coupon(c).isUsed(false).build());
            userCouponRepository.save(UserCoupon.builder().user(uSilver).coupon(c).isUsed(false).build());
        });
        couponRepository.findByCode("SILVER10").ifPresent(c -> userCouponRepository.save(UserCoupon.builder().user(uSilver).coupon(c).isUsed(false).build()));
        couponRepository.findByCode("TOPPINGFREE").ifPresent(c -> userCouponRepository.save(UserCoupon.builder().user(uSilver).coupon(c).isUsed(false).build()));
        couponRepository.findByCode("DIAMOND15").ifPresent(c -> userCouponRepository.save(UserCoupon.builder().user(uDiamond).coupon(c).isUsed(false).build()));
        couponRepository.findByCode("BIRTHDAYVIP").ifPresent(c -> userCouponRepository.save(UserCoupon.builder().user(uDiamond).coupon(c).isUsed(false).build()));
        couponRepository.findByCode("CUPPINGVIP").ifPresent(c -> userCouponRepository.save(UserCoupon.builder().user(uDiamond).coupon(c).isUsed(false).build()));

        // 4. Realistic Orders & OrderItems
        var products = productRepository.findAll();
        if (products.isEmpty()) return;

        // Bronze: 1 order
        Order oBronze = orderRepository.save(Order.builder()
                .orderCode("UTE-ORD-1010")
                .user(uBronze)
                .store(s1)
                .orderType(OrderType.DELIVERY)
                .status(OrderStatus.COMPLETED)
                .subtotal(BigDecimal.valueOf(90000))
                .discountAmount(BigDecimal.ZERO)
                .shippingFee(BigDecimal.valueOf(15000))
                .finalAmount(BigDecimal.valueOf(105000))
                .deliveryAddress("KTX ĐHQG Khu B, TP. Thủ Đức, TP.HCM")
                .recipientName("Nguyễn Thị Mai Phương")
                .recipientPhone("0911223344")
                .createdAt(LocalDateTime.now().minusDays(2))
                .build());
        orderItemRepository.save(OrderItem.builder().order(oBronze).product(products.get(0)).unitPrice(BigDecimal.valueOf(45000)).quantity(1).subtotal(BigDecimal.valueOf(45000)).note("50% đường, 100% đá").build());
        orderItemRepository.save(OrderItem.builder().order(oBronze).product(products.size() > 10 ? products.get(10) : products.get(0)).unitPrice(BigDecimal.valueOf(45000)).quantity(1).subtotal(BigDecimal.valueOf(45000)).note("Nóng giòn").build());

        // Silver: 3 orders
        Order oSilver1 = orderRepository.save(Order.builder()
                .orderCode("UTE-ORD-1021")
                .user(uSilver)
                .store(s2)
                .orderType(OrderType.DINE_IN)
                .status(OrderStatus.COMPLETED)
                .subtotal(BigDecimal.valueOf(120000))
                .discountAmount(BigDecimal.ZERO)
                .shippingFee(BigDecimal.ZERO)
                .finalAmount(BigDecimal.valueOf(120000))
                .recipientName("Trần Quốc Bảo")
                .recipientPhone("0933445566")
                .createdAt(LocalDateTime.now().minusDays(10))
                .build());
        orderItemRepository.save(OrderItem.builder().order(oSilver1).product(products.size() > 2 ? products.get(2) : products.get(0)).unitPrice(BigDecimal.valueOf(65000)).quantity(1).subtotal(BigDecimal.valueOf(65000)).note("Không đá, uống lạnh").build());
        orderItemRepository.save(OrderItem.builder().order(oSilver1).product(products.size() > 1 ? products.get(1) : products.get(0)).unitPrice(BigDecimal.valueOf(55000)).quantity(1).subtotal(BigDecimal.valueOf(55000)).build());

        Order oSilver2 = orderRepository.save(Order.builder()
                .orderCode("UTE-ORD-1022")
                .user(uSilver)
                .store(s1)
                .orderType(OrderType.TAKE_AWAY)
                .status(OrderStatus.COMPLETED)
                .subtotal(BigDecimal.valueOf(121000))
                .discountAmount(BigDecimal.valueOf(12000))
                .shippingFee(BigDecimal.ZERO)
                .finalAmount(BigDecimal.valueOf(109000))
                .recipientName("Trần Quốc Bảo")
                .recipientPhone("0933445566")
                .createdAt(LocalDateTime.now().minusDays(5))
                .build());
        orderItemRepository.save(OrderItem.builder().order(oSilver2).product(products.size() > 3 ? products.get(3) : products.get(0)).unitPrice(BigDecimal.valueOf(62000)).quantity(1).subtotal(BigDecimal.valueOf(62000)).build());
        orderItemRepository.save(OrderItem.builder().order(oSilver2).product(products.size() > 4 ? products.get(4) : products.get(0)).unitPrice(BigDecimal.valueOf(59000)).quantity(1).subtotal(BigDecimal.valueOf(59000)).build());

        Order oSilver3 = orderRepository.save(Order.builder()
                .orderCode("UTE-ORD-1023")
                .user(uSilver)
                .store(s2)
                .orderType(OrderType.DINE_IN)
                .status(OrderStatus.COMPLETED)
                .subtotal(BigDecimal.valueOf(95000))
                .discountAmount(BigDecimal.ZERO)
                .shippingFee(BigDecimal.ZERO)
                .finalAmount(BigDecimal.valueOf(95000))
                .recipientName("Trần Quốc Bảo")
                .recipientPhone("0933445566")
                .createdAt(LocalDateTime.now().minusDays(1))
                .build());
        orderItemRepository.save(OrderItem.builder().order(oSilver3).product(products.get(0)).unitPrice(BigDecimal.valueOf(45000)).quantity(1).subtotal(BigDecimal.valueOf(45000)).build());
        orderItemRepository.save(OrderItem.builder().order(oSilver3).product(products.size() > 11 ? products.get(11) : products.get(0)).unitPrice(BigDecimal.valueOf(50000)).quantity(1).subtotal(BigDecimal.valueOf(50000)).build());

        // Diamond: 3 VIP orders
        Order oDiamond1 = orderRepository.save(Order.builder()
                .orderCode("UTE-ORD-1031")
                .user(uDiamond)
                .store(s1)
                .orderType(OrderType.DINE_IN)
                .status(OrderStatus.COMPLETED)
                .subtotal(BigDecimal.valueOf(580000))
                .discountAmount(BigDecimal.valueOf(87000))
                .shippingFee(BigDecimal.ZERO)
                .finalAmount(BigDecimal.valueOf(493000))
                .recipientName("Lê Hoàng Yến Vy")
                .recipientPhone("0977889900")
                .note("Phòng VIP Lounge tiếp khách đối tác")
                .createdAt(LocalDateTime.now().minusDays(15))
                .build());
        orderItemRepository.save(OrderItem.builder().order(oDiamond1).product(products.size() > 5 ? products.get(5) : products.get(0)).unitPrice(BigDecimal.valueOf(290000)).quantity(2).subtotal(BigDecimal.valueOf(580000)).note("Hộp quà rang mộc thượng hạng").build());

        Order oDiamond2 = orderRepository.save(Order.builder()
                .orderCode("UTE-ORD-1032")
                .user(uDiamond)
                .store(s3)
                .orderType(OrderType.DINE_IN)
                .status(OrderStatus.COMPLETED)
                .subtotal(BigDecimal.valueOf(290000))
                .discountAmount(BigDecimal.valueOf(43500))
                .shippingFee(BigDecimal.ZERO)
                .finalAmount(BigDecimal.valueOf(246500))
                .recipientName("Lê Hoàng Yến Vy")
                .recipientPhone("0977889900")
                .note("Bàn Sân Vườn Garden Bình Thạnh")
                .createdAt(LocalDateTime.now().minusDays(8))
                .build());
        orderItemRepository.save(OrderItem.builder().order(oDiamond2).product(products.get(0)).unitPrice(BigDecimal.valueOf(59000)).quantity(2).subtotal(BigDecimal.valueOf(118000)).build());
        orderItemRepository.save(OrderItem.builder().order(oDiamond2).product(products.size() > 10 ? products.get(10) : products.get(0)).unitPrice(BigDecimal.valueOf(45000)).quantity(2).subtotal(BigDecimal.valueOf(90000)).build());

        Order oDiamond3 = orderRepository.save(Order.builder()
                .orderCode("UTE-ORD-1033")
                .user(uDiamond)
                .store(s1)
                .orderType(OrderType.DINE_IN)
                .status(OrderStatus.COMPLETED)
                .subtotal(BigDecimal.valueOf(350000))
                .discountAmount(BigDecimal.valueOf(52500))
                .shippingFee(BigDecimal.ZERO)
                .finalAmount(BigDecimal.valueOf(297500))
                .recipientName("Lê Hoàng Yến Vy")
                .recipientPhone("0977889900")
                .createdAt(LocalDateTime.now().minusDays(2))
                .build());
        orderItemRepository.save(OrderItem.builder().order(oDiamond3).product(products.size() > 6 ? products.get(6) : products.get(0)).unitPrice(BigDecimal.valueOf(175000)).quantity(2).subtotal(BigDecimal.valueOf(350000)).note("Set Pour-Over Geisha Cầu Đất").build());
    }

    private void seedEnterpriseModules() {
        if (supplierRepository.count() > 0) return;

        List<Store> stores = storeRepository.findAll();
        List<Product> products = productRepository.findAll();
        List<Ingredient> ingredients = ingredientRepository.findAll();
        List<User> users = userRepository.findAll();
        List<Order> orders = orderRepository.findAll();

        Store s1 = stores.get(0);
        Store s2 = stores.size() > 1 ? stores.get(1) : s1;

        // 1. Suppliers
        Supplier sup1 = supplierRepository.save(Supplier.builder()
                .name("Nông Trại Cầu Đất Farm")
                .contactName("Anh Tuấn Cầu Đất")
                .phone("02633888999")
                .email("caudat.coffee@farm.vn")
                .address("Xã Trạm Hành, Cao Nguyên Cầu Đất, TP. Đà Lạt")
                .isActive(true)
                .build());

        Supplier sup2 = supplierRepository.save(Supplier.builder()
                .name("Nông Trường Trà Mộc Châu")
                .contactName("Chị Lan Mộc Châu")
                .phone("02123868686")
                .email("contact@mocchautea.vn")
                .address("Tiểu khu 34, TT. Nông Trường Mộc Châu, Sơn La")
                .isActive(true)
                .build());

        Supplier sup3 = supplierRepository.save(Supplier.builder()
                .name("Công Ty CP Sữa Dalat Milk")
                .contactName("Phòng Phân Phối F&B")
                .phone("02633848484")
                .email("sales@dalatmilk.vn")
                .address("Xã Tu Tra, Huyện Đơn Dương, Tỉnh Lâm Đồng")
                .isActive(true)
                .build());

        Supplier sup4 = supplierRepository.save(Supplier.builder()
                .name("Elle & Vire Dairy Products France")
                .contactName("Đại Diện Nhập Khẩu Thực Phẩm")
                .phone("02838229999")
                .email("orders@ellevire.vn")
                .address("Tòa nhà Bitexco, Bến Nghé, Quận 1, TP.HCM")
                .isActive(true)
                .build());

        // 2. Purchase Orders (PO)
        User admin = users.stream().filter(u -> u.getRole().getName() == RoleName.ROLE_ADMIN).findFirst().orElse(users.get(0));
        purchaseOrderRepository.save(PurchaseOrder.builder()
                .store(s1)
                .supplier(sup1)
                .orderCode("PO-2026-001")
                .totalAmount(BigDecimal.valueOf(18500000))
                .status("RECEIVED")
                .createdBy(admin)
                .build());

        purchaseOrderRepository.save(PurchaseOrder.builder()
                .store(s2)
                .supplier(sup3)
                .orderCode("PO-2026-002")
                .totalAmount(BigDecimal.valueOf(4800000))
                .status("SENT")
                .createdBy(admin)
                .build());

        // 3. Customer Reviews
        if (!products.isEmpty() && !users.isEmpty()) {
            User uVy = users.stream().filter(u -> "vy.diamond@utecoffe.vn".equals(u.getEmail())).findFirst().orElse(users.get(0));
            User uBao = users.stream().filter(u -> "bao.silver@utecoffe.vn".equals(u.getEmail())).findFirst().orElse(users.get(0));
            User uPhuong = users.stream().filter(u -> "phuong.bronze@utecoffe.vn".equals(u.getEmail())).findFirst().orElse(users.get(0));

            reviewRepository.save(Review.builder()
                    .user(uVy)
                    .product(products.get(0))
                    .rating(5)
                    .comment("Cold Brew Cam Vàng ở chi nhánh Thủ Đức hương vị đỉnh cao! Vị cam vàng Sunkist thanh mát kết hợp cà phê ủ lạnh 18h thơm bùi rất tuyệt vời.")
                    .build());

            reviewRepository.save(Review.builder()
                    .user(uBao)
                    .product(products.size() > 2 ? products.get(2) : products.get(0))
                    .rating(5)
                    .comment("Trà Oolong nướng thơm đậm đà, lớp macchiato kem cheese béo ngậy vừa vặn, không gian chi nhánh Quận 1 yên tĩnh lịch sự.")
                    .build());

            reviewRepository.save(Review.builder()
                    .user(uPhuong)
                    .product(products.size() > 3 ? products.get(3) : products.get(0))
                    .rating(4)
                    .comment("Bánh sừng bò nướng giòn rụm thơm nức mùi bơ Pháp Elle & Vire, chấm cùng cà phê rất hợp. Sẽ ghé lại thường xuyên.")
                    .build());
        }

        // 4. Recipes (Công thức SOP)
        if (!products.isEmpty() && !ingredients.isEmpty()) {
            recipeRepository.save(Recipe.builder()
                    .product(products.get(0))
                    .ingredient(ingredients.get(0))
                    .quantityRequired(BigDecimal.valueOf(30)) // 30g hat Arabica
                    .build());

            if (products.size() > 1) {
                recipeRepository.save(Recipe.builder()
                        .product(products.get(1))
                        .ingredient(ingredients.get(0))
                        .quantityRequired(BigDecimal.valueOf(18)) // 18g double shot
                        .build());
            }

            if (products.size() > 2 && ingredients.size() > 2) {
                recipeRepository.save(Recipe.builder()
                        .product(products.get(2))
                        .ingredient(ingredients.get(2))
                        .quantityRequired(BigDecimal.valueOf(15)) // 15g tra Oolong
                        .build());
            }
        }

        // 4.1. Store Inventory (Tồn kho nguyên liệu tại từng chi nhánh)
        if (storeInventoryRepository.count() == 0 && !stores.isEmpty() && !ingredients.isEmpty()) {
            for (Store st : stores) {
                for (Ingredient ing : ingredients) {
                    storeInventoryRepository.save(StoreInventory.builder()
                            .store(st)
                            .ingredient(ing)
                            .currentStock(BigDecimal.valueOf(80000))
                            .safetyStock(BigDecimal.valueOf(5000))
                            .lastRestockedAt(LocalDateTime.now())
                            .build());
                }
            }
        }

        // 5. Refunds & Payment sample
        if (!orders.isEmpty()) {
            Order o1 = orders.get(0);
            Payment pay = paymentRepository.save(Payment.builder()
                    .order(o1)
                    .paymentMethod(PaymentMethod.VIETQR)
                    .status(PaymentStatus.PAID)
                    .transactionId("VQR-2026-998811")
                    .amount(o1.getFinalAmount())
                    .paymentTime(LocalDateTime.now().minusDays(1))
                    .build());

            refundRepository.save(Refund.builder()
                    .payment(pay)
                    .refundCode("REF-2026-001")
                    .amount(BigDecimal.valueOf(59000))
                    .reason("Shipper làm nghiêng đổ thức uống, hoàn tiền 100% vào Ví Điểm thưởng UTEClub")
                    .status("REFUNDED")
                    .build());
        }
    }
}
