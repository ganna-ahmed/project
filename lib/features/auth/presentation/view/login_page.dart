import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:project/features/auth/presentation/view/cubits/login_cubit/login_cubit.dart';
import 'package:project/features/auth/presentation/view/widgets/back_grod_paiter.dart';
import 'package:project/features/auth/presentation/view/widgets/custom_button.dart';
import 'package:project/helper/show_snack_bar.dart';

import '../../../../core/utils/app_router.dart';
import '../../../user/presentation/views/widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  bool isLoading = false;
  String? id, password;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          GoRouter.of(context).push(AppRouter.kMainScreen);
          isLoading = false;
        } else if (state is LoginFailure) {
          showSnackBar(context, state.errMessage);
          isLoading = false;
        }
      },
      builder: (context, state) => ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: BackgroundPainter(),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 65.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),
                      Text(
                        LoginTexts.loginTitle,
                        style: TextStyle(color: Colors.white, fontSize: 28.sp),
                      ),
                      SizedBox(height: 290.h),
                      CustomTextField(
                        label: LoginTexts.emailLabel,
                        hintText: LoginTexts.emailHintText,
                        onChanged: (data) {
                          id = data;
                        },
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        label: LoginTexts.passwordLabel,
                        hintText: LoginTexts.passwordHintText,
                        obscureText: true,
                        onChanged: (data) {
                          password = data;
                        },
                      ),
                      SizedBox(height: 26.h),
                      CustomButton(
                        text: LoginTexts.loginButtonText,
                        onPressed: () async {
                          BlocProvider.of<LoginCubit>(context)
                              .loginUser(id: id!, password: password!);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
