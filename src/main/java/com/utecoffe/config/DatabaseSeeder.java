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

        Product p1 = productRepository.save(Product.builder()
                .category(cCoffee)
                .name("Cold Brew Cam Vàng Specialty")
                .slug("cold-brew-cam-vang-specialty")
                .description("Cà phê Arabica ủ lạnh 18 tiếng kết hợp nước cam vàng Sunkist nguyên chất")
                .imageUrl("https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?q=80&w=600")
                .basePrice(BigDecimal.valueOf(59000))
                .isAvailable(true)
                .isFeatured(true)
                .build());

        productSizeRepository.save(ProductSize.builder().product(p1).sizeName("Regular (M)").extraPrice(BigDecimal.ZERO).build());
        productSizeRepository.save(ProductSize.builder().product(p1).sizeName("Large (L)").extraPrice(BigDecimal.valueOf(10000)).build());

        productRepository.save(Product.builder()
                .category(cCoffee)
                .name("Espresso Tonic Signature")
                .slug("espresso-tonic-signature")
                .description("Double shot Espresso Cầu Đất trên nền Tonic cao cấp và lát chanh vàng")
                .imageUrl("https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?q=80&w=600")
                .basePrice(BigDecimal.valueOf(55000))
                .isAvailable(true)
                .isFeatured(true)
                .build());

        productRepository.save(Product.builder()
                .category(cTea)
                .name("Trà Oolong Kem Phô Mai Vàng")
                .slug("tra-oolong-kem-phomai-vang")
                .description("Trà Oolong nướng Mộc Châu kết hợp lớp macchiato cheese béo ngậy")
                .imageUrl("https://images.unsplash.com/photo-1576092768241-dec231879fc3?q=80&w=600")
                .basePrice(BigDecimal.valueOf(62000))
                .isAvailable(true)
                .isFeatured(true)
                .build());

        productRepository.save(Product.builder()
                .category(cPastry)
                .name("Croissant Bơ Pháp Thủ Công")
                .slug("croissant-bo-phap-thu-cong")
                .description("Bánh sừng bò nướng giòn tan với 100% bơ Elle & Vire cao cấp")
                .imageUrl("https://images.unsplash.com/photo-1555507036-ab1f4038808a?q=80&w=600")
                .basePrice(BigDecimal.valueOf(45000))
                .isAvailable(true)
                .isFeatured(false)
                .build());

        toppingRepository.save(Topping.builder().name("Trân Châu Oolong Hoàng Kim").price(BigDecimal.valueOf(10000)).isAvailable(true).build());
        toppingRepository.save(Topping.builder().name("Kem Cheese Kem Mặn Signature").price(BigDecimal.valueOf(15000)).isAvailable(true).build());
        toppingRepository.save(Topping.builder().name("Thạch Nha Đam Mật Ong").price(BigDecimal.valueOf(10000)).isAvailable(true).build());

        ingredientRepository.save(Ingredient.builder().name("Hạt Cà Phê Arabica Cầu Đất").sku("ING-CF-ARA").unit("gram").minThreshold(BigDecimal.valueOf(5000)).currentCostPrice(BigDecimal.valueOf(320)).build());
        ingredientRepository.save(Ingredient.builder().name("Lá Trà Oolong Lâm Đồng").sku("ING-TEA-OOL").unit("gram").minThreshold(BigDecimal.valueOf(3000)).currentCostPrice(BigDecimal.valueOf(450)).build());
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
