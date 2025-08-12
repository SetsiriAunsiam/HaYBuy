import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  bool _showUserProducts = true; // true = สินค้าที่ลงขาย, false = สินค้าโปรด
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController?.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully signed out'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate to sign in page after sign out
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/signin', (route) => false);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error signing out'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final productProvider = Provider.of<ProductProvider>(context);

    // สำหรับตัวอย่าง จะใช้ products ทั้งหมดเป็นสินค้าที่ลงขาย และ favoriteProducts เป็นสินค้าโปรด
    final userProducts = productProvider.productsDb;
    final favoriteProducts = productProvider.favoriteProductsDb;
    final displayProducts = _showUserProducts ? userProducts : favoriteProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรไฟล์'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false, // ลบ arrow icon
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _signOut(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text('ออกจากระบบ'),
                    ],
                  ),
                ),
              ];
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _signOut(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text('ออกจากระบบ'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
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
                  child: const Icon(Icons.person, size: 40, color: Colors.grey),
                ),
                const SizedBox(height: 12),

                // Username
                Text(
                  user?.email?.split('@')[0] ?? 'เพมรหัวงด',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStatColumn('${userProducts.length}', 'เรทติ้ง'),
                    const SizedBox(width: 40),
                    _buildStatColumn('${favoriteProducts.length}', 'ผู้ติดตาม'),
                  ],
                ),
                const SizedBox(height: 20),

                // Action Buttons (หลอกๆ ไม่เชื่อมกับการทำงาน)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFakeActionButton('ติดตาม'),
                    const SizedBox(width: 16),
                    _buildFakeActionButton('พูดคุย'),
                  ],
                ),
                const SizedBox(height: 20),

                // Icons Row - Cart and Heart with underline and animation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Cart Icon (for user products)
                    GestureDetector(
                      onTap: () {
                        setState(() => _showUserProducts = true);
                        _animationController?.reset();
                        _animationController?.forward();
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
                            width: _showUserProducts ? 40 : 0,
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
                        setState(() => _showUserProducts = false);
                        _animationController?.reset();
                        _animationController?.forward();
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
                            width: !_showUserProducts ? 40 : 0,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(thickness: 1),

          // Products Grid with Animation
          Expanded(
            child: displayProducts.isEmpty
                ? const Center(
                    child: Text(
                      'ไม่มีสินค้า',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : AnimatedSwitcher(
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
                        _showUserProducts,
                      ), // Key สำหรับ AnimatedSwitcher
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemCount: displayProducts.length,
                        itemBuilder: (context, index) {
                          return AnimatedContainer(
                            duration: Duration(
                              milliseconds: 100 + (index * 50),
                            ),
                            curve: Curves.easeOutBack,
                            child: ProductCard(product: displayProducts[index]),
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ],
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

  Widget _buildFakeActionButton(String text) {
    return ElevatedButton(
      onPressed: () {
        // ปุ่มหลอกๆ ไม่ทำอะไร
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$text - ฟีเจอร์นี้ยังไม่พร้อมใช้งาน')),
        );
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
}
