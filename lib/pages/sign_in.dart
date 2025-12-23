import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier<bool>(false);
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
              const SizedBox(height: 80),
              
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
              
              // HaYBuy Title
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
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

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
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 20),

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
              const SizedBox(height: 40),

              // Sign In Button
              Container(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();

                if (email.isEmpty || password.isEmpty) {
                  _showMessage(context, "Please fill in all fields");
                  return;
                }

                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  _showMessage(context, "Login successful!");
                  // ไปหน้า HomePage หรือหน้าอื่นที่ต้องการ
                  Navigator.pushReplacementNamed(context, '/home');
                } on FirebaseAuthException catch (e) {
                  String errorMsg = "An error occurred";
                  if (e.code == 'user-not-found') {
                    errorMsg = "No account found for that email";
                  } else if (e.code == 'wrong-password') {
                    errorMsg = "Incorrect password";
                  }
                  _showMessage(context, errorMsg);
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
                "Sign In",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Sign Up link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "ยังไม่มีบัญชี? ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text(
                  "สร้างบัญชี",
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
