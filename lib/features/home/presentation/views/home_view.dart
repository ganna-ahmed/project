import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/app_router.dart';
import 'package:project/core/utils/assets.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.wildBlueYonder,
        centerTitle: true,
        title: const Text(
          'Home',
          style: TextStyle(color: AppColors.darkBlue),
        ),
        actions: [
          Image.asset(
            AssetsData.profile,
            width: 73,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 400,
            decoration: const BoxDecoration(
              color: AppColors.wildBlueYonder,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(150.0),
                bottomRight: Radius.circular(150.0),
              ),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.ceruleanBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 40.0,
                          horizontal: 5.0,
                        ),
                        minimumSize: const Size(160, 60),
                      ),
                      onPressed: () {
                        GoRouter.of(context).push(AppRouter.kUploadView);
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Update',
                            style: TextStyle(fontSize: 28, color: Colors.white),
                          ),
                          Text(
                            'Project',
                            style: TextStyle(fontSize: 28, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.ceruleanBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 40.0,
                          horizontal: 5.0,
                        ),
                        minimumSize: Size(160, 60),
                      ),
                      onPressed: () {
                        GoRouter.of(context).push(AppRouter.kAddQuestion);
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'New',
                            style: TextStyle(fontSize: 28, color: Colors.white),
                          ),
                          Text(
                            'Project',
                            style: TextStyle(fontSize: 28, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ceruleanBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () {
                    GoRouter.of(context).push(AppRouter.kBubbleShett);
                  },
                  child: const Text(
                    'Create Bubble Sheet',
                    style: TextStyle(
                      fontSize: 22,
                      color: AppColors.snow,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ceruleanBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Creat Models Of Question',
                    style: TextStyle(
                      fontSize: 22,
                      color: AppColors.snow,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ceruleanBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Correction Of Bubble Sheet',
                    style: TextStyle(
                      fontSize: 22,
                      color: AppColors.snow,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
