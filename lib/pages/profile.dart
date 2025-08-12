import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_shopee/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:local_shopee/providers/favorite_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // ValueNotifier สำหรับจัดการสถานะการเลือกแท็บ
  static final ValueNotifier<bool> _showUserProducts = ValueNotifier<bool>(
    true,
  ); // true = รถเข็น, false = หัวใจ

  Future<Map<String, dynamic>?> getUserData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    }
    return null;
  }

  // เพิ่ม Stream สำหรับ real-time updates
  Stream<DocumentSnapshot> getUserDataStream() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }

  // ฟังก์ชันสำหรับ Toggle Follow
  Future<void> _toggleFollow(String profileUserId, String currentUserId) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(profileUserId);

    final snapshot = await docRef.get();
    if (!snapshot.exists) return;

    List followers = snapshot.data()?['followers'] ?? [];

    if (followers.contains(currentUserId)) {
      // เลิกติดตาม
      followers.remove(currentUserId);
    } else {
      // ติดตาม
      followers.add(currentUserId);
    }

    await docRef.update({'followers': followers});
  }

  // ฟังก์ชันสำหรับให้เรทติ้ง
  Future<void> _setRating(
    String profileUserId,
    String currentUserId,
    double rating,
  ) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(profileUserId);

    final snapshot = await docRef.get();
    if (!snapshot.exists) return;

    Map<String, dynamic> ratings = Map<String, dynamic>.from(
      snapshot.data()?['ratings'] ?? {},
    );
    ratings[currentUserId] = rating;

    await docRef.update({'ratings': ratings});
  }

  int calculateAge(Timestamp dateOfBirth) {
    DateTime birthDate = dateOfBirth.toDate();
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;

    // ตรวจสอบว่าวันเกิดผ่านไปแล้วในปีนี้หรือยัง
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final productProvider = Provider.of<ProductProvider>(context);

    // สำหรับตัวอย่าง จะใช้ products ทั้งหมดเป็นสินค้าที่ลงขาย และ favoriteProducts เป็นสินค้าโปรด
    final userProducts = productProvider.productsDb;
    // final favoriteProducts = productProvider.favoriteProductsDb;
    // final displayProducts = _showUserProducts ? userProducts : favoriteProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text("โปรไฟล์"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false, // ลบ arrow icon
        actions: [
          // Settings button
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () {
                try {
                  Navigator.pushNamed(context, '/setting');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ไม่สามารถเปิดหน้าตั้งค่าได้'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.settings_outlined,
                color: Colors.black,
                size: 24,
              ),
              tooltip: 'ตั้งค่า',
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: getUserDataStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No user data found"));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          // คำนวณข้อมูลเรทติ้งและผู้ติดตาม
          final followers = List<String>.from(userData['followers'] ?? []);
          final ratings = Map<String, dynamic>.from(userData['ratings'] ?? {});

          double avgRating = ratings.isNotEmpty
              ? ratings.values
                        .map((e) => e.toDouble())
                        .reduce((a, b) => a + b) /
                    ratings.length
              : 0.0;

          final currentUserId = FirebaseAuth.instance.currentUser!.uid;
          bool isOwnProfile =
              currentUserId == FirebaseAuth.instance.currentUser!.uid;

          return Column(
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Profile Avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Username
                    Text(
                      userData['fullName'] ?? 'ไม่ระบุชื่อ',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Stats Row - ใช้ข้อมูลจริงจาก Firestore
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // คลิกที่เรทติ้งเพื่อให้คะแนน
                            double myRating =
                                ratings[currentUserId]?.toDouble() ?? 0.0;
                            _showRatingDialog(
                              context,
                              currentUserId,
                              currentUserId,
                              myRating,
                            );
                          },
                          child: _buildStatColumn(
                            avgRating.toStringAsFixed(1),
                            'เรทติ้ง',
                          ),
                        ),
                        const SizedBox(width: 40),
                        _buildStatColumn('${followers.length}', 'ผู้ติดตาม'),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Icons Row - Cart and Heart with underline and animation
                    ValueListenableBuilder<bool>(
                      valueListenable: _showUserProducts,
                      builder: (context, showUserProducts, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Cart Icon (for user products)
                            GestureDetector(
                              onTap: () {
                                _showUserProducts.value = true;
                              },
                              child: Column(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    child: Icon(
                                      Icons.shopping_cart_outlined,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    height: 3,
                                    width: showUserProducts ? 40 : 0,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 60),
                            // Heart Icon (for favorite products)
                            GestureDetector(
                              onTap: () {
                                _showUserProducts.value = false;
                              },
                              child: Column(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    child: Icon(
                                      Icons.favorite_outline,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    height: 3,
                                    width: !showUserProducts ? 40 : 0,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              const Divider(thickness: 1),

              // Content area with AnimatedSwitcher
              Expanded(
                child: ValueListenableBuilder<bool>(
                  valueListenable: _showUserProducts,
                  builder: (context, showUserProducts, child) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position:
                                    Tween<Offset>(
                                      begin: const Offset(0.2, 0),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeInOut,
                                      ),
                                    ),
                                child: child,
                              ),
                            );
                          },
                      child: Padding(
                        key: ValueKey(
                          showUserProducts,
                        ), // Key สำหรับ AnimatedSwitcher
                        padding: const EdgeInsets.all(16),
                        child: showUserProducts
                            ? _buildUserProductsGrid()
                            : _buildFavoriteProductsGrid(),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ฟังก์ชันแสดง Dialog สำหรับให้เรทติ้ง
  void _showRatingDialog(
    BuildContext context,
    String profileUserId,
    String currentUserId,
    double currentRating,
  ) {
    double tempRating = currentRating;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('ให้คะแนนผู้ใช้'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'คะแนนปัจจุบัน: ${tempRating.toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Slider(
                value: tempRating,
                min: 0,
                max: 5,
                divisions: 50,
                label: tempRating.toStringAsFixed(1),
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    tempRating = value;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0', style: TextStyle(color: Colors.grey[600])),
                  Text('5', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('ให้คะแนน'),
              onPressed: () async {
                await _setRating(profileUserId, currentUserId, tempRating);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'ให้คะแนน ${tempRating.toStringAsFixed(1)} เรียบร้อยแล้ว',
                    ),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildActionButton(String text) {
    return ElevatedButton(
      onPressed: () {
        // ปุ่มหลอกๆ ไม่ทำอะไร
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(text),
    );
  }

  Widget _buildUserProductsGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 4, // จำนวน placeholder cards สำหรับสินค้าที่ลงขาย
      itemBuilder: (context, index) {
        return _buildProductCard(
          title: 'สินค้าของฉัน ${index + 1}',
          price: '฿${220 + (index * 50)}',
          isUserProduct: true,
        );
      },
    );
  }

  Widget _buildFavoriteProductsGrid() {
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        // ใช้ข้อมูลหลอกๆ เพื่อทดสอบ
        final favorites = favoriteProvider.getDummyFavoriteProducts();

        if (favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'ยังไม่มีสินค้าโปรด',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'เพิ่มสินค้าที่ชื่นชอบเข้ารายการโปรด',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final favorite = favorites[index];
            return _buildFavoriteProductCard(context, favorite);
          },
        );
      },
    );
  }

  Widget _buildProductCard({
    required String title,
    required String price,
    required bool isUserProduct,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Icon(
                  isUserProduct ? Icons.store : Icons.favorite,
                  size: 40,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.favorite_outline,
                        size: 16,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 12, color: Colors.grey),
                      const Text(
                        '0.5 กิโลเมตร',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      const Spacer(),
                      Icon(Icons.star, size: 12, color: Colors.orange),
                      const Text(
                        '5.0',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteProductCard(
    BuildContext context,
    Map<String, dynamic> favorite,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.favorite,
                      size: 40,
                      color: Colors.red[300],
                    ),
                  ),
                  // ปุ่มลบออกจากรายการโปรด
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        _removeFromFavorites(context, favorite);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 16,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Product Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    favorite['productName'] ?? 'ไม่ระบุชื่อ',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '฿${favorite['price']?.toStringAsFixed(0) ?? '0'}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 12, color: Colors.grey),
                      Expanded(
                        child: Text(
                          favorite['distance'] ?? '0 กิโลเมตร',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.star, size: 12, color: Colors.orange),
                      Text(
                        favorite['rating']?.toString() ?? '0.0',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _removeFromFavorites(
    BuildContext context,
    Map<String, dynamic> favorite,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('ลบออกจากรายการโปรด'),
        content: Text(
          'คุณต้องการลบ "${favorite['productName']}" ออกจากรายการโปรดหรือไม่?',
        ),
        actions: [
          TextButton(
            child: const Text('ยกเลิก'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('ลบ'),
            onPressed: () async {
              try {
                await Provider.of<FavoriteProvider>(
                  context,
                  listen: false,
                ).removeFromFavorites(favorite['productId']);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'ลบ "${favorite['productName']}" ออกจากรายการโปรดแล้ว',
                    ),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('เกิดข้อผิดพลาด: $e'),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
