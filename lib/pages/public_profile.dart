import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PublicProfilePage extends StatelessWidget {
  final String profileUserId; // id ของ user ที่เรากำลังดู

  const PublicProfilePage({super.key, required this.profileUserId});

  // เพิ่ม Stream สำหรับ real-time updates
  Stream<DocumentSnapshot> getUserDataStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(profileUserId)
        .snapshots();
  }

  // ฟังก์ชันสำหรับ Toggle Follow
  Future<void> _toggleFollow(String currentUserId) async {
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
  Future<void> _setRating(String currentUserId, double rating) async {
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

  // ฟังก์ชันแสดง Dialog สำหรับให้เรทติ้ง
  void _showRatingDialog(
    BuildContext context,
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
                await _setRating(currentUserId, tempRating);
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
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final isOwnProfile = currentUserId == profileUserId;

    return Scaffold(
      appBar: AppBar(
        title: const Text("โปรไฟล์"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        actions: [
          // Settings button - แสดงเฉพาะเมื่อเป็นโปรไฟล์ตัวเอง
          if (isOwnProfile)
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
            return const Center(child: Text("ไม่พบข้อมูลผู้ใช้"));
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

          bool isFollowing = followers.contains(currentUserId);
          double myRating = ratings[currentUserId]?.toDouble() ?? 0.0;

          return Column(
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Profile Avatar
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: userData['profileImage'] != null
                          ? ClipOval(
                              child: Image.network(
                                userData['profileImage'],
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            ),
                    ),
                    const SizedBox(height: 16),

                    // Username
                    Text(
                      userData['fullName'] ?? 'ไม่ระบุชื่อ',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // User Info
                    if (userData['gender'] != null ||
                        userData['dateOfBirth'] != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (userData['gender'] != null)
                            Text(
                              userData['gender'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          if (userData['gender'] != null &&
                              userData['dateOfBirth'] != null)
                            Text(
                              ' • ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          if (userData['dateOfBirth'] != null)
                            Text(
                              'อายุ ${calculateAge(userData['dateOfBirth'])} ปี',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Stats Row - ใช้ข้อมูลจริงจาก Firestore
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // คลิกที่เรทติ้งเพื่อให้คะแนน (เฉพาะเมื่อไม่ใช่โปรไฟล์ตัวเอง)
                            if (!isOwnProfile) {
                              _showRatingDialog(
                                context,
                                currentUserId,
                                myRating,
                              );
                            }
                          },
                          child: _buildStatColumn(
                            avgRating.toStringAsFixed(1),
                            'เรทติ้ง',
                            canTap: !isOwnProfile,
                          ),
                        ),
                        const SizedBox(width: 40),
                        _buildStatColumn('${followers.length}', 'ผู้ติดตาม'),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Action Buttons
                    if (!isOwnProfile) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => _toggleFollow(currentUserId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isFollowing
                                  ? Colors.grey[300]
                                  : Colors.green,
                              foregroundColor: isFollowing
                                  ? Colors.black
                                  : Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(isFollowing ? 'เลิกติดตาม' : 'ติดตาม'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              // TODO: เปิดหน้าแชท
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('ฟีเจอร์แชทยังไม่พร้อมใช้งาน'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: Colors.black,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('พูดคุย'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ] else ...[
                      // ปุ่มสำหรับโปรไฟล์ตัวเอง
                    ],

                    // แสดงคะแนนที่ให้ไป (เฉพาะเมื่อไม่ใช่โปรไฟล์ตัวเอง)
                    if (!isOwnProfile && myRating > 0) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'คุณให้คะแนน: ${myRating.toStringAsFixed(1)} ⭐',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // แสดงหัวข้อสินค้า
                    const Text(
                      'สินค้าของฉัน',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // Products Grid - แสดงเฉพาะสินค้าของผู้ใช้
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: 6, // สินค้าหลอกๆ
                    itemBuilder: (context, index) {
                      return _buildProductCard(
                        'สินค้า ${index + 1}',
                        '฿${(index + 1) * 100}',
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, {bool canTap = false}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: canTap ? Colors.green : Colors.black,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: canTap ? Colors.green[700] : Colors.grey[600],
          ),
        ),
        if (canTap)
          Text(
            'แตะเพื่อให้คะแนน',
            style: TextStyle(
              fontSize: 10,
              color: Colors.green[500],
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }

  Widget _buildProductCard(String title, String price) {
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
                color: Colors.blue[50],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Icon(
                Icons.shopping_bag,
                size: 40,
                color: Colors.blue[300],
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
                      Icon(Icons.shopping_cart, size: 16, color: Colors.green),
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
}
