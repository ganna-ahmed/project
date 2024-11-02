import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/assets.dart';
import 'package:project/features/user/presentation/views/widgets/custom_app_bar_button.dart';
import 'package:project/features/user/presentation/views/widgets/custom_card.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.darkBlue,
            )),
        backgroundColor: Colors.transparent,
        actions: const [
          CustomAppBarButton(
            text: 'edit',
          ),
        ],
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: AppColors.darkBlue),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.05,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(120),
                child: Image.asset(
                  AssetsData.profile,
                  fit: BoxFit.cover,
                  width: 285,
                  height: 235,
                ),
              ),
              const Text(
                'DR.Osama Elghonemey',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.1,
              ),
              const Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomCard(
                    title: 'Email',
                    subTitle: 'osamaelghonemy@gmail.com',
                    color: AppColors.darkBlue,
                  ),
                  Positioned(
                    right: 0,
                    left: 0,
                    bottom: -107,
                    child: CustomCard(
                        title: 'Name',
                        subTitle: 'osamaelghonemy',
                        color: AppColors.ceruleanBlue),
                  ),
                  Positioned(
                    right: 0,
                    left: 0,
                    bottom: -214,
                    child: CustomCard(
                        title: 'Department',
                        subTitle: 'CSE',
                        color: AppColors.wildBlueYonder),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
