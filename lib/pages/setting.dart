import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatelessWidget {
  final User user = FirebaseAuth.instance.currentUser!;

  SettingsPage({super.key});

  // ฟังก์ชันออกจากระบบ
  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  // ฟังก์ชันแสดง Dialog เพื่อแก้ข้อมูล
  void _editField(BuildContext context, String fieldName, String currentValue) {
    final controller = TextEditingController(text: currentValue);

    // กำหนดชื่อที่จะแสดงใน Dialog
    String displayName;
    if (fieldName == 'fullName') {
      displayName = 'ชื่อ-สกุล';
    } else if (fieldName == 'gender') {
      displayName = 'เพศ';
    } else {
      displayName = fieldName;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('แก้ไข $displayName'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: displayName,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
          ),
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
            child: const Text('บันทึก'),
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .update({fieldName: controller.text.trim()});
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('บันทึก$displayNameเรียบร้อยแล้ว'),
                    backgroundColor: Colors.green,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('การตั้งค่า'),
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
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // รูปโปรไฟล์
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // TODO: อัปโหลดและเปลี่ยนรูปโปรไฟล์
                        },
                        child: Stack(
                          children: [
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
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userData['fullName'] ?? 'ไม่ระบุชื่อ',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email ?? '',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // การตั้งค่าข้อมูลส่วนตัว
                _buildSectionTitle('ข้อมูลส่วนตัว'),
                const SizedBox(height: 12),

                _buildSettingItem(
                  title: 'ชื่อ-สกุล',
                  value: userData['fullName'] ?? '',
                  icon: Icons.person_outline,
                  onTap: () => _editField(
                    context,
                    'fullName',
                    userData['fullName'] ?? '',
                  ),
                ),

                _buildSettingItem(
                  title: 'เพศ',
                  value: userData['gender'] ?? '',
                  icon: Icons.wc_outlined,
                  onTap: () =>
                      _editField(context, 'gender', userData['gender'] ?? ''),
                ),

                _buildSettingItem(
                  title: 'วันเกิด',
                  value: userData['dateOfBirth'] != null
                      ? '${userData['dateOfBirth'].toDate().day}/${userData['dateOfBirth'].toDate().month}/${userData['dateOfBirth'].toDate().year}'
                      : 'ไม่ระบุ',
                  icon: Icons.cake_outlined,
                  showTrailing: false,
                  onTap: () {
                    // ไม่สามารถแก้ไขได้
                  },
                ),

                const SizedBox(height: 32),

                // การตั้งค่าบัญชี
                _buildSectionTitle('การตั้งค่าบัญชี'),
                const SizedBox(height: 12),

                _buildSettingItem(
                  title: 'ดูโปรไฟล์สาธารณะ',
                  value: '',
                  icon: Icons.visibility_outlined,
                  showTrailing: false,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/public_profile',
                      arguments: user.uid,
                    );
                  },
                ),

                _buildSettingItem(
                  title: 'เปลี่ยนรหัสผ่าน',
                  value: '',
                  icon: Icons.lock_outline,
                  showTrailing: false,
                  onTap: () {
                    _showPasswordResetDialog(context);
                  },
                ),

                _buildSettingItem(
                  title: 'ออกจากระบบ',
                  value: '',
                  icon: Icons.logout,
                  showTrailing: false,
                  isDestructive: true,
                  onTap: () => _showSignOutDialog(context),
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
    bool showTrailing = true,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDestructive ? Colors.red[50] : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : Colors.grey[700],
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDestructive ? Colors.red : Colors.black87,
          ),
        ),
        subtitle: value.isNotEmpty
            ? Text(
                value,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              )
            : null,
        trailing: showTrailing
            ? Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400])
            : null,
        onTap: onTap,
      ),
    );
  }

  void _showPasswordResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('เปลี่ยนรหัสผ่าน'),
        content: const Text(
          'ระบบจะส่งลิงก์สำหรับเปลี่ยนรหัสผ่านไปที่อีเมลของคุณ',
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
            child: const Text('ส่งอีเมล'),
            onPressed: () {
              FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('ส่งอีเมลเปลี่ยนรหัสผ่านแล้ว'),
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
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('ออกจากระบบ'),
        content: const Text('คุณต้องการออกจากระบบหรือไม่?'),
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
            child: const Text('ออกจากระบบ'),
            onPressed: () {
              Navigator.pop(context);
              _signOut(context);
            },
          ),
        ],
      ),
    );
  }
}
