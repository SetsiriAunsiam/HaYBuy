import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier<bool>(false);
  final ValueNotifier<DateTime?> _selectedDate = ValueNotifier<DateTime?>(null);
  final ValueNotifier<String> _selectedGender = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              // HaYBuy Icon/Logo
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.storefront,
                  size: 50,
                  color: Colors.white,
                ),
              ),

              // HaYBuy Logo/Title
              const Text(
                "HaYBuy",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Subtitle
              const Text(
                "ซื้อ ขาย และเชื่อมโยงกับชุมชนของคุณ",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

              // ชื่อ-สกุล label
              const Text(
                "ชื่อ-สกุล",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Full Name field
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: fullNameController,
                  decoration: const InputDecoration(
                    hintText: "ชื่อ-สกุล",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // อีเมล label
              const Text(
                "อีเมล",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Email field
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: "อีเมล",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 20),

              // วันเดือนปีเกิด label
              const Text(
                "วันเดือนปีเกิด",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Date of Birth field
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ValueListenableBuilder<DateTime?>(
                  valueListenable: _selectedDate,
                  builder: (context, selectedDate, child) {
                    return GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          _selectedDate.value = picked;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              selectedDate != null
                                  ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
                                  : "เลือกวันเดือนปีเกิด",
                              style: TextStyle(
                                fontSize: 16,
                                color: selectedDate != null
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // รหัสผ่าน label
              const Text(
                "รหัสผ่าน",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Password field
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isPasswordVisible,
                  builder: (context, isVisible, child) {
                    return TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "รหัสผ่าน",
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            _isPasswordVisible.value =
                                !_isPasswordVisible.value;
                          },
                        ),
                      ),
                      obscureText: !isVisible,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // ยืนยันรหัสผ่าน label
              const Text(
                "ยืนยันรหัสผ่าน",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Confirm Password field
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isPasswordVisible,
                  builder: (context, isVisible, child) {
                    return TextField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: "ยืนยันรหัสผ่าน",
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            _isPasswordVisible.value =
                                !_isPasswordVisible.value;
                          },
                        ),
                      ),
                      obscureText: !isVisible,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // เพศ label
              const Text(
                "เพศ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Gender field
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ValueListenableBuilder<String>(
                  valueListenable: _selectedGender,
                  builder: (context, selectedGender, child) {
                    return DropdownButtonFormField<String>(
                      value: selectedGender.isEmpty ? null : selectedGender,
                      decoration: const InputDecoration(
                        hintText: "เลือกเพศ",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.grey,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: "ชาย", child: Text("ชาย")),
                        DropdownMenuItem(value: "หญิง", child: Text("หญิง")),
                        DropdownMenuItem(value: "อื่นๆ", child: Text("อื่นๆ")),
                      ],
                      onChanged: (String? value) {
                        if (value != null) {
                          _selectedGender.value = value;
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Sign Up button
              Container(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();
                    final confirmPassword = confirmPasswordController.text
                        .trim();
                    final fullName = fullNameController.text.trim();

                    // Validation
                    if (email.isEmpty ||
                        password.isEmpty ||
                        confirmPassword.isEmpty ||
                        fullName.isEmpty) {
                      _showMessage(context, "กรุณากรอกข้อมูลให้ครบถ้วน");
                      return;
                    }

                    if (!email.contains('@')) {
                      _showMessage(context, "รูปแบบอีเมลไม่ถูกต้อง");
                      return;
                    }

                    if (password != confirmPassword) {
                      _showMessage(context, "รหัสผ่านไม่ตรงกัน");
                      return;
                    }

                    if (password.length < 6) {
                      _showMessage(
                        context,
                        "รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร",
                      );
                      return;
                    }

                    if (_selectedDate.value == null) {
                      _showMessage(context, "กรุณาเลือกวันเดือนปีเกิด");
                      return;
                    }

                    if (_selectedGender.value.isEmpty) {
                      _showMessage(context, "กรุณาเลือกเพศ");
                      return;
                    }

                    try {
                      // Create user account
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                      // Save user data to Firestore
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userCredential.user!.uid)
                          .set({
                            'email': email,
                            'fullName': fullName,
                            'dateOfBirth': Timestamp.fromDate(
                              _selectedDate.value!,
                            ),
                            'gender': _selectedGender.value,
                            'createdAt': Timestamp.now(),// จะอัปเดตภายหลังถ้ามีการอัปโหลดภาพ
                            'followers': [], // รายการผู้ติดตาม
                            'ratings': {}, // คะแนนเรทติ้งจากผู้ใช้อื่น
                          });

                      _showMessage(context, "สร้างบัญชีสำเร็จ!");

                      // Navigate to home or login page
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, '/signin');
                      }
                    } on FirebaseAuthException catch (e) {
                      String errorMsg = "เกิดข้อผิดพลาด";
                      if (e.code == 'email-already-in-use') {
                        errorMsg = "อีเมลนี้ถูกใช้งานแล้ว";
                      } else if (e.code == 'weak-password') {
                        errorMsg = "รหัสผ่านไม่แข็งแรงพอ";
                      } else if (e.code == 'invalid-email') {
                        errorMsg = "รูปแบบอีเมลไม่ถูกต้อง";
                      }
                      _showMessage(context, errorMsg);
                    } catch (e) {
                      _showMessage(context, "เกิดข้อผิดพลาดในการบันทึกข้อมูล");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "สร้างบัญชี",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "มีบัญชีอยู่แล้ว? ",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "เข้าสู่ระบบ",
                      style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
