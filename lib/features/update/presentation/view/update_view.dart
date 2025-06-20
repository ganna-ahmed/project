import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_image.dart';

class UpdatePage extends StatelessWidget {
  const UpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.05,
              horizontal: screenWidth * 0.08,
            ),
            child: Column(
              children: [
                ImageWidget(
                  height: screenHeight * 0.35,
                  width: screenWidth,
                ),
                SizedBox(height: screenHeight * 0.05),
                ButtonsWidget(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'widgets/custom_button.dart';
// import 'widgets/custom_image.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class UpdatePage extends StatelessWidget {
//   const UpdatePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height.h;
//     final screenWidth = MediaQuery.of(context).size.width.w;

//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       body: SafeArea(
//         child: Column(
//           children: [
//             ImageWidget(
//               height: screenHeight * 0.4,
//               width: screenWidth.w,
//             ),
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1.w),
//                 child: ButtonsWidget(
//                   screenHeight: screenHeight,
//                   screenWidth: screenWidth,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
