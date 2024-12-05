import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Edit profile",
          style: TextStyle(
            fontSize: 28.0,
            color: AppColors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: screenHeight * 0.1,
                  backgroundColor: Colors.transparent,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/profile.png',
                        height: screenHeight * 0.9,
                        width: screenHeight * 0.9,
                      ),
                      Positioned(
                        bottom: screenHeight * 0.05,
                        child: Image.asset(
                          'assets/images/camera.png',
                          height: screenHeight * 0.07,
                          width: screenHeight * 0.07,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            _buildTextField(
              label: "Name",
              screenWidth: screenWidth,
              textColor: AppColors.black,
              textSize: screenWidth * 0.05,
            ),
            SizedBox(height: screenHeight * 0.05),
            _buildTextField(
              label: "Email",
              screenWidth: screenWidth,
              textColor: AppColors.black,
              textSize: screenWidth * 0.05,
            ),
            SizedBox(height: screenHeight * 0.05),
            _buildTextField(
              label: "Department",
              screenWidth: screenWidth,
              textColor: AppColors.black,
              textSize: screenWidth * 0.05,
            ),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.ceruleanBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            minimumSize: Size(screenWidth, screenHeight * 0.07),
          ),
          child: const Text(
            'Done',
            style: TextStyle(color: Colors.white, fontSize: 28.0),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required double screenWidth,
    required Color textColor,
    required double textSize,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: textSize, 
            fontWeight: FontWeight.w400,
            color: textColor,
          ),
        ),
        SizedBox(height: screenWidth * 0.01),
        TextField(
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: "type here...",
            hintStyle: TextStyle(
              fontSize: screenWidth * 0.04,
              color: Colors.grey,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 1.5,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
