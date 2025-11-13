import 'package:flutter/material.dart';

import '../../../core/constants/asset_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/constants/value_constants.dart';



class ChangePasswordApp extends StatelessWidget {
  const ChangePasswordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangePasswordScreen(),
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: [
            // Icon menu trước logo
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: Colors.black),
              onSelected: (value) {
                print("Chọn: $value");
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(value: "find_job", child: Text("Tìm việc làm")),
                const PopupMenuItem(value: "applied_jobs", child: Text("Việc làm đã ứng tuyển")),
                const PopupMenuItem(value: "saved_jobs", child: Text("Việc làm đã lưu")),
              ],
            ),

            const SizedBox(width: 10), // Khoảng cách giữa menu và logo

            Flexible( // Đảm bảo logo không bị chèn ép
              child: Image.asset(AssetConstants.logoSplash,height: 20,),
            ),
          ],
        ),
        actions: [
          Wrap( // Dùng Wrap để tự động xuống dòng nếu thiếu chỗ
            spacing: 5, // Khoảng cách giữa các phần tử
            children: [
              // Quốc kỳ VN

              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage(AssetConstants.iconVN),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.black),
                ],
              ),
              // Avatar + Tên người dùng
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Nguyen Hoa",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage(AssetConstants.exCV),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],


      )
      ,



      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Đổi mật khẩu",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildPasswordField(
                    label: "Mật khẩu hiện tại",
                    hint: "Nhập mật khẩu hiện tại",
                    controller: _oldPasswordController,
                    obscureText: _obscureOldPassword,
                    toggleVisibility: () {
                      setState(() {
                        _obscureOldPassword = !_obscureOldPassword;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildPasswordField(
                    label: "Mật khẩu mới",
                    hint: "6-32 ký tự, chứa ít nhất 1 chữ hoa và 1 số",
                    controller: _newPasswordController,
                    obscureText: _obscureNewPassword,
                    toggleVisibility: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildPasswordField(
                    label: "Xác nhận mật khẩu mới",
                    hint: "Xác nhận mật khẩu phải trùng với mật khẩu mới vừa nhập",
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    toggleVisibility: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Thực hiện logic đổi mật khẩu
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Mật khẩu đã được thay đổi')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Thay đổi", style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Hủy", style: TextStyle(fontSize: 16, color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            suffixIcon: IconButton(
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed: toggleVisibility,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Vui lòng nhập $label";
            }
            if (label == "Mật khẩu mới" && value.length < 6) {
              return "Mật khẩu phải có ít nhất 6 ký tự";
            }
            if (label == "Xác nhận mật khẩu mới" && value != _newPasswordController.text) {
              return "Mật khẩu xác nhận không khớp";
            }
            return null;
          },
        ),
        const SizedBox(height: 5), // Khoảng cách nhỏ giữa ô nhập và text hướng dẫn
        Text(
          hint,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
