import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kurakani/auth/auth_service.dart';
import 'package:kurakani/components/my_button.dart';
import 'package:kurakani/components/my_textfields.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key, this.onTap});

  // yo chai controller for email and password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  //route to login page
  final void Function()? onTap;

  //register method, like when user click on register , this method is called
  void register(BuildContext context) async {
    //get the damn authservice bro
    final auth = AuthService();

    debugPrint("Register button clicked");

    //if the password matches , it will create a user
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        await auth.signUp(
          email: _emailController.text,
          password: _passwordController.text,
        );

        await auth
            .signOutRn(); //this is done inorder to show the login page immediately after the user registers
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(title: Text(e.toString())),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "पस्स्वर्ड मिलेन ?? Type गर्न नि जान्देनस साले खाते 😡🤬",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),

              //app name here
              SizedBox(
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    """Welcome to
KuraKani
                    """,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.black12,
                        ),
                        Shadow(
                          offset: Offset(-1, -1),
                          blurRadius: 2,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              //logo
              SvgPicture.asset(
                'assets/images/logo2.svg',
                height: 120,
                width: 120,
              ),

              //welcome back message
              const SizedBox(height: 30),
              Text(
                "Let's create an account for you",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 30),

              //email textfield
              MyTextfields(
                hintText: "Email",
                obscureText: false,
                controller: _emailController,
              ),

              const SizedBox(height: 10),
              //password textfield
              MyTextfields(
                hintText: "Password",
                obscureText: true,
                controller: _passwordController,
              ),

              const SizedBox(height: 10),
              //confirm password textfield
              MyTextfields(
                hintText: "Confirm Password",
                obscureText: true,
                controller: _confirmPasswordController,
              ),

              const SizedBox(height: 28),
              //login now button
              MyButton(buttonText: "Register", onTap: () => register(context)),
              const SizedBox(height: 25),
              //register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      " Login now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                    ),
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

//laxmanthp@gmail.com
