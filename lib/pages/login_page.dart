import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kurakani/auth/auth_service.dart';
import 'package:kurakani/components/my_button.dart';
import 'package:kurakani/components/my_textfields.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key, this.onTap});

  // yo chai controller for email and password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //function to define what wi. ll happen user click on Register now button
  final void Function()? onTap;
  //login method, like when user click on login , this method is called
  void login(BuildContext context) async {
    debugPrint("Tapped login");
    //first get auth service
    final authService = AuthService();

    //login
    try {
      await authService.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text(e.toString())),
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
                    "KuraKani",
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
                'assets/images/logo.svg',
                height: 200,
                width: 200,
              ),

              //welcome back message
              const SizedBox(height: 30),
              Text(
                "Welcome back , you've been missed",
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
              //pw textfield
              MyTextfields(
                hintText: "Password",
                obscureText: true,
                controller: _passwordController,
              ),

              const SizedBox(height: 28),
              //login now button
              MyButton(buttonText: "Login", onTap: () => login(context)),
              const SizedBox(height: 25),

              //register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      " Register now",
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
