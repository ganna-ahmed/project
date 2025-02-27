import 'package:flutter/material.dart';
import 'package:project/features/correction_bubble_sheet/custom_button.dart';

class UploadModelAnswer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Correction Bubble Sheet",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Accurate correction, secure results.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xff2262C6),
        // centerTitle: true,
        elevation: 0,
        toolbarHeight: 80,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, right: 25, left: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/folder.png',
              width: 170,
            ),
            CustomButton(
              onPressed: () {},
              backgroundColor: const Color(0xff2D4263),
              icon: Icons.upload_file_rounded,
              title: "Upload Model Answer",
              subtitle:
                  "Upload the model answer PDF.\nEnsure images are 870x600 for accurate results.",
            ),
            // const SizedBox(height: 20),
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //     vertical: 8.0,
            //   ),
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Color(0xff2D4263),
            //       padding:
            //           const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //     ),
            //     child: const Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Row(
            //           children: [
            //             Icon(Icons.upload_file_rounded, color: Colors.white),
            //             SizedBox(width: 8),
            //             Text(
            //               "Upload Model Answer",
            //               style: TextStyle(color: Colors.white, fontSize: 16),
            //             ),
            //           ],
            //         ),
            //         SizedBox(height: 4),
            //         Text(
            //           "Upload the model answer PDF.\nEnsure images are 870x600 for accurate results.",
            //           style: TextStyle(color: Colors.white70, fontSize: 12),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 8.0),
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Color(0xffC9DEFF),
            //       padding:
            //           const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //     ),
            //     child: const Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Row(
            //           children: [
            //             Icon(Icons.upload_file_rounded, color: Colors.white),
            //             SizedBox(width: 8),
            //             Text(
            //               "Upload Student Paper",
            //               style: TextStyle(color: Colors.white, fontSize: 16),
            //             ),
            //           ],
            //         ),
            //         SizedBox(height: 4),
            //         Text(
            //           "Upload the student paper PDF.\nEnsure images are 870x600 for accurate results.",
            //           style: TextStyle(color: Colors.grey, fontSize: 12),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff2262C6),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Correction",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
