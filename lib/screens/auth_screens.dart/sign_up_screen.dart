import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/colors/colors.dart';
import 'package:instagramclone/resources/auth_method.dart';
import 'package:instagramclone/responsive/mobileScreen_layout.dart';
import 'package:instagramclone/responsive/responsive_layout.dart';
import 'package:instagramclone/responsive/webScreen_layout.dart';
import 'package:instagramclone/screens/auth_screens.dart/image_picker.dart';
import 'package:instagramclone/screens/auth_screens.dart/login_screen.dart';
import 'package:instagramclone/screens/auth_screens.dart/textfield_card.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    bioController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethod().signUpUser(
        email: emailController.text,
        password: passwordController.text,
        username: userNameController.text,
        bio: bioController.text,
        file: _image!);

    setState(() {
      _isLoading = false;
    });

    if (res == 'success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout())
            )
          );
    }
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
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
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : const CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            ExactAssetImage('Assets/Images/download.png')),
                Positioned(
                  bottom: -5,
                  left: 60,
                  child: IconButton(
                      onPressed: () {
                        selectImage();
                      },
                      icon: const Icon(
                        Icons.add_a_photo,
                        size: 28,
                      )),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            TextFieldCard(
              textEditingController: userNameController,
              hintText: 'Enter your username',
              textInputType: TextInputType.text,
              // isPass: true,
            ),
            const SizedBox(
              height: 10,
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
            TextFieldCard(
              textEditingController: bioController,
              hintText: 'Enter your bio',
              textInputType: TextInputType.text,
              // isPass: true,
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: signUpUser,
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
                        child: CircularProgressIndicator(),
                      )
                    : const Text(
                        'Sign Up',
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
                  child: const Text("Already have an account?"),
                ),
                GestureDetector(
                  onTap: navigateToLogin,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      "Login.",
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
