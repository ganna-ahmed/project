// profile_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/assets.dart';
import 'package:project/features/auth/data/cubits/login_cubit/login_cubit.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
  late AnimationController _emailController;
  late AnimationController _nameController;
  late AnimationController _departmentController;

  late Animation<double> _emailAnimation;
  late Animation<double> _nameAnimation;
  late Animation<double> _departmentAnimation;

  bool _emailSelected = false;
  bool _nameSelected = false;
  bool _departmentSelected = false;
  bool _phoneSelected = false;
  bool _officeSelected = false;
  bool _experienceSelected = false;

  final Color sharedColor = const Color(0xFF4285F4); // Google Blue

  @override
  void initState() {
    super.initState();
    _emailController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _nameController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _departmentController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    _emailAnimation = _buildAnimation(_emailController);
    _nameAnimation = _buildAnimation(_nameController);
    _departmentAnimation = _buildAnimation(_departmentController);
  }

  Animation<double> _buildAnimation(AnimationController controller) {
    return Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  void _toggleCard(String cardType) {
    setState(() {
      _emailSelected = cardType == 'email';
      _nameSelected = cardType == 'name';
      _departmentSelected = cardType == 'department';
      _phoneSelected = cardType == 'phone';
      _officeSelected = cardType == 'office';
      _experienceSelected = cardType == 'experience';

      _emailController.forwardOrReverse(_emailSelected);
      _nameController.forwardOrReverse(_nameSelected);
      _departmentController.forwardOrReverse(_departmentSelected);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = colorScheme.brightness == Brightness.dark;

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        if (state is LoginSuccess) {
          final doctor = state.doctor;

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: isDarkMode
                  ? colorScheme.background
                  : Colors.transparent, // Transparent background in Light Mode
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Profile',
                style: TextStyle(
                    color: isDarkMode
                        ? colorScheme.onBackground
                        : AppColors.darkBlue,
                    fontSize: 20.sp), // Text color based on mode
              ),
            ),
            backgroundColor: isDarkMode
                ? colorScheme.background
                : Colors.white, // White background in Light Mode
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 60.h),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 30.h),
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.2,
                        backgroundColor: isDarkMode
                            ? colorScheme.primary
                            : AppColors
                            .darkBlue, // Primary color based on mode
                        backgroundImage: doctor.image.path.isNotEmpty
                            ? NetworkImage(doctor.image.path)
                            : const AssetImage('assets/images/profile.png')
                        as ImageProvider,
                        onBackgroundImageError: (exception, stackTrace) {
                          print('Error loading profile image: $exception');
                        },
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          'DR. ${doctor.nameDoctor}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? colorScheme.onPrimaryContainer
                                : AppColors
                                .darkBlue, // Text color based on mode
                            fontSize: MediaQuery.of(context).size.width < 360
                                ? 24.sp
                                : 28.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          doctor.emailDoctor,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDarkMode
                                ? colorScheme.onSurfaceVariant
                                : Colors.grey
                                .shade600, // Text color based on mode
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 40.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          children: [
                            _buildEditableInfoCard(
                              title: 'Email',
                              value: doctor.emailDoctor,
                              icon: Icons.email,
                              onTap: () => _toggleCard('email'),
                              isSelected: _emailSelected,
                              isDarkMode: isDarkMode,
                            ),
                            SizedBox(height: 15.h),
                            _buildEditableInfoCard(
                              title: 'Name',
                              value: doctor.nameDoctor,
                              icon: Icons.person,
                              onTap: () => _toggleCard('name'),
                              isSelected: _nameSelected,
                              isDarkMode: isDarkMode,
                            ),
                            SizedBox(height: 15.h),
                            _buildDepartmentCard(
                              department: doctor.departmentDoctor,
                              specialization: doctor.specializationDoctor,
                              onTap: () => _toggleCard('department'),
                              isSelected: _departmentSelected,
                              isDarkMode: isDarkMode,
                            ),
                            SizedBox(height: 15.h),
                            _buildEditableInfoCard(
                              title: 'Phone',
                              value: doctor.phoneDoctor,
                              icon: Icons.phone,
                              onTap: () => _toggleCard('phone'),
                              isSelected: _phoneSelected,
                              isDarkMode: isDarkMode,
                            ),
                            SizedBox(height: 15.h),
                            _buildEditableInfoCard(
                              title: 'Office',
                              value: doctor.officeDoctor,
                              icon: Icons.business,
                              onTap: () => _toggleCard('office'),
                              isSelected: _officeSelected,
                              isDarkMode: isDarkMode,
                            ),
                            SizedBox(height: 15.h),
                            _buildEditableInfoCard(
                              title: 'Experience',
                              value: '${doctor.expDoctor} years',
                              icon: Icons.work,
                              onTap: () => _toggleCard('experience'),
                              isSelected: _experienceSelected,
                              isDarkMode: isDarkMode,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: isDarkMode
                  ? colorScheme.background
                  : Colors.transparent, // Transparent background in Light Mode
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Profile',
                style: TextStyle(
                    color: isDarkMode
                        ? colorScheme.onBackground
                        : AppColors.darkBlue,
                    fontSize: 20.sp), // Text color based on mode
              ),
            ),
            backgroundColor: isDarkMode
                ? colorScheme.background
                : Colors.white, // White background in Light Mode
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off,
                      size: 64.sp,
                      color: isDarkMode
                          ? colorScheme.onSurfaceVariant
                          : Colors
                          .grey), // Icon color based on mode
                  SizedBox(height: 16.h),
                  Text(
                    'No doctor logged in',
                    style: TextStyle(
                        fontSize: 18.sp,
                        color: isDarkMode
                            ? colorScheme.onSurfaceVariant
                            : Colors
                            .grey), // Text color based on mode
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildEditableInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
    required bool isSelected,
    required bool isDarkMode,
  }) {
    return _buildAnimatedCard(
      icon: icon,
      title: title,
      value: value,
      onTap: onTap,
      isSelected: isSelected,
      isDarkMode: isDarkMode,
    );
  }

  Widget _buildDepartmentCard({
    required String department,
    required String specialization,
    required VoidCallback onTap,
    required bool isSelected,
    required bool isDarkMode,
  }) {
    return _buildAnimatedCard(
      icon: Icons.apartment,
      title: 'Department',
      valueWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            department,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: isSelected ? sharedColor : AppColors.darkBlue,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            specialization,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? sharedColor
                  : Colors.grey
                  .shade600,
            ),
          ),
        ],
      ),
      onTap: onTap,
      isSelected: isSelected,
      isDarkMode: isDarkMode,
    );
  }

  Widget _buildAnimatedCard({
    required IconData icon,
    required String title,
    Widget? valueWidget,
    String? value,
    required VoidCallback onTap,
    required bool isSelected,
    required bool isDarkMode,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(isSelected ? 18.w : 15.w),
        decoration: BoxDecoration(
          color: isSelected
              ? sharedColor.withOpacity(0.1)
              : isDarkMode
              ? Colors.grey.shade800
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? sharedColor
                : isDarkMode
                ? Colors.grey.shade700
                : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: sharedColor.withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            )
          ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isSelected ? sharedColor : sharedColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon,
                  color: isSelected ? Colors.white : sharedColor,
                  size: 20.sp),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isSelected
                          ? sharedColor
                          : isDarkMode
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  valueWidget ??
                      Text(
                        value ?? '',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? sharedColor
                              : isDarkMode
                              ? Colors.white
                              : AppColors.darkBlue,
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on AnimationController {
  void forwardOrReverse(bool condition) {
    condition ? forward() : reverse();
  }
}