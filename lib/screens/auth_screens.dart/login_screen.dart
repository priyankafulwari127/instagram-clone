import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramclone/colors/colors.dart';
import 'package:instagramclone/resources/auth_method.dart';
import 'package:instagramclone/responsive/mobileScreen_layout.dart';
import 'package:instagramclone/responsive/responsive_layout.dart';
import 'package:instagramclone/responsive/webScreen_layout.dart';
import 'package:instagramclone/screens/auth_screens.dart/image_picker.dart';
import 'package:instagramclone/screens/auth_screens.dart/sign_up_screen.dart';
import 'package:instagramclone/screens/auth_screens.dart/textfield_card.dart';
import 'package:instagramclone/utils/global_variables.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    @override
    void dispose() {
      super.dispose();
      emailController.dispose();
      passwordController.dispose();
    }

    void loginUser() async {
      setState(() {
        _isLoading = true;
      });

      String res = await AuthMethod().loginUser(
          email: emailController.text, password: passwordController.text);

      if (res == 'success') {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
                webScreenLayout: WebScreenLayout(),
                mobileScreenLayout: MobileScreenLayout())));
      } else {
        showSnackBar(context, res);
      }

      setState(() {
        _isLoading = false;
      });
    }

    void navigateToSignUp() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const SignUpScreen()));
    }

    return Scaffold(
      body: Container(
        padding: MediaQuery.of(context).size.width > webscreenSize ? const EdgeInsets.symmetric(horizontal: 32) :
        const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            SvgPicture.asset(
              'Assets/Images/insta.svg',
              height: 64,
              color: Colors.white,
            ),
            const SizedBox(
              height: 50,
            ),
            TextFieldCard(
                textEditingController: emailController,
                hintText: 'Enter your email address',
                textInputType: TextInputType.emailAddress),
            const SizedBox(
              height: 10,
            ),
            TextFieldCard(
              textEditingController: passwordController,
              hintText: 'Enter your password',
              textInputType: TextInputType.text,
              isPass: true,
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: loginUser,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    color: blueColor),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : const Text(
                        'Login',
                      ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Flexible(
              flex: 2,
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text("Don't have an account?"),
                ),
                GestureDetector(
                  onTap: navigateToSignUp,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      "Sign up.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
