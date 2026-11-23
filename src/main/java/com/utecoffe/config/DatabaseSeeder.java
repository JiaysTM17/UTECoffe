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
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        if (roleRepository.count() == 0) {
            seedRolesAndUsers();
            seedStoresAndTables();
            seedCatalogAndBOM();
            seedCoupons();
            System.out.println(">>> UTECoffe: Database seeded successfully for first-time launch!");
        }
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

        storeRepository.save(Store.builder()
                .name("UTECoffe Roastery Quận 1")
                .address("68 Lê Lợi, Bến Nghé, Quận 1, TP.HCM")
                .latitude(10.7735)
                .longitude(106.7001)
                .phoneNumber("02838221999")
                .openingTime("06:30")
                .closingTime("23:00")
                .isActive(true)
                .build());

        storeTableRepository.save(StoreTable.builder().store(s1).tableNumber("T-01").capacity(2).isOccupied(false).isActive(true).build());
        storeTableRepository.save(StoreTable.builder().store(s1).tableNumber("T-02").capacity(4).isOccupied(false).isActive(true).build());
        storeTableRepository.save(StoreTable.builder().store(s1).tableNumber("VIP-01").capacity(8).isOccupied(false).isActive(true).build());
    }

    private void seedCatalogAndBOM() {
        Category cCoffee = categoryRepository.save(Category.builder().name("Cà Phê Đặc Sản").slug("ca-phe-dac-san").displayOrder(1).isActive(true).build());
        Category cTea = categoryRepository.save(Category.builder().name("Trà Thượng Hạng").slug("tra-thuong-hang").displayOrder(2).isActive(true).build());
        Category cPastry = categoryRepository.save(Category.builder().name("Bánh Ngọt Thủ Công").slug("banh-ngot-thu-cong").displayOrder(3).isActive(true).build());

        // Specialty Coffee (13 items)
        createProductWithSizes(cCoffee, "Cold Brew Cam Vàng Specialty", "cold-brew-cam-vang-specialty",
                "Cà phê Arabica ủ lạnh 18 tiếng kết hợp nước cam vàng Sunkist mọng nước nguyên chất.",
                "https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?q=80&w=800", 59000, true);

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
                "https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?q=80&w=800", 65000, true);

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
        toppingRepository.save(Topping.builder().name("Trân Châu Oolong Hoàng Kim").price(BigDecimal.valueOf(10000)).isAvailable(true).build());
        toppingRepository.save(Topping.builder().name("Kem Cheese Kem Mặn Signature").price(BigDecimal.valueOf(15000)).isAvailable(true).build());
        toppingRepository.save(Topping.builder().name("Thạch Nha Đam Mật Ong").price(BigDecimal.valueOf(10000)).isAvailable(true).build());

        ingredientRepository.save(Ingredient.builder().name("Hạt Cà Phê Arabica Cầu Đất").sku("ING-CF-ARA").unit("gram").minThreshold(BigDecimal.valueOf(5000)).currentCostPrice(BigDecimal.valueOf(320)).build());
        ingredientRepository.save(Ingredient.builder().name("Lá Trà Oolong Lâm Đồng").sku("ING-TEA-OOL").unit("gram").minThreshold(BigDecimal.valueOf(3000)).currentCostPrice(BigDecimal.valueOf(450)).build());
    }

    private void createProductWithSizes(Category cat, String name, String slug, String desc, String img, int price, boolean featured) {
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
                .code("UTECOFFEWELCOME")
                .title("Chào Mừng Thành Viên Mới")
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
                .code("FREESHIP30K")
                .title("Miễn Phí Giao Hàng 30K")
                .description("Giảm 30.000đ phí vận chuyển")
                .discountType(DiscountType.FIXED_AMOUNT)
                .discountValue(BigDecimal.valueOf(30000))
                .minOrderValue(BigDecimal.valueOf(100000))
                .startDate(LocalDateTime.now())
                .endDate(LocalDateTime.now().plusDays(365))
                .usageLimit(5000)
                .usedCount(0)
                .isActive(true)
                .build());
    }
}
