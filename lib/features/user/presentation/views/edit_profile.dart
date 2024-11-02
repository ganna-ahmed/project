import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project/features/auth/presentation/view/widgets/constant.dart';
import 'package:project/features/auth/presentation/view/widgets/custom_button.dart';
import 'package:project/features/auth/presentation/view/widgets/icons.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackIconWidget(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Edit profile",
          style: TextStyle(
            fontSize: ProfileConstants.titleFontSize,
            color: ProfileConstants.titleColor,
          ),
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: DoneButton(
              onPressed: () {},
              backgroundColor: Colors.blue,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                child: SvgPicture.asset(
                  'assets/svg/camera_883787 1.svg',
                  height: 50,
                  width: 50,
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildTextField("Name"),
            const SizedBox(height: 20),
            _buildTextField("Email"),
            const SizedBox(height: 20),
            _buildTextField("Department"),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: BottomDoneButton(
        onPressed: () {},
      ),
    );
  }

  Widget _buildTextField(String label) {
    return TextField(
      style: const TextStyle(
        fontSize: ProfileConstants.inputFontSize,
        color: ProfileConstants.inputTextColor,
      ),
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: const TextStyle(
          fontSize: ProfileConstants.labelFontSize,
          color: ProfileConstants.labelTextColor,
        ),
        hintText: "type here...",
        hintStyle: const TextStyle(
          fontSize: ProfileConstants.hintFontSize,
          color: ProfileConstants.hintTextColor,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
