import 'package:docudi/homescreen/google_sign_in_api.dart';
import 'package:docudi/homescreen/homescreen.dart.dart';
import 'package:docudi/homescreen/login_screen.dart';
import 'package:docudi/palette.dart';
import 'package:docudi/user_api.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = "/homescreen";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool isLoading = false;

  Future signIn(BuildContext context, String type) async {
    setState(() {
      isLoading = true;
    });
    if (type == "google") {
      final user = await GoogleSignInApi.login();
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign in Failed")));
      }
      await signInPost(user!.displayName.toString(), user.email, user.id);
      Navigator.of(context).pushNamed(HomeScreen.routeName);
    } else {
      try {
        await signInPost(nameController.text, emailController.text, passwordController.text);
        Navigator.of(context).pushNamed(HomeScreen.routeName);
      } catch (err) {
        print(err);
        String? errTxt;
        if (err == "existing email") {
          errTxt = "Email already exists, please try logging in!";
        } else if (err == "other") {
          errTxt = "Seems to be an issue, please try again later!";
        }
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(errTxt.toString())));
      }
    }
  }

  bool passwordVisible = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Positioned(
            bottom: -40,
            child: Image.asset("assets/images/background_graphic.png"),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Let's sign up",
                            style: TextStyle(
                              fontSize: 18,
                              color: primaryFontColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryFontColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              inputFields("Full Name", "Enter your name", false, nameController),
                              SizedBox(
                                height: 10,
                              ),
                              inputFields("E-mail", "Enter your e-mail", false, emailController),
                              SizedBox(
                                height: 10,
                              ),
                              inputFields("Password", "Enter your password", true, passwordController),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Processing Data')),
                              );
                              signIn(context, "email");
                            }
                          },
                          style: ElevatedButton.styleFrom(elevation: 0),
                          child: Container(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "or continue with",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                              onTap: () {
                                signIn(context, "google");
                              },
                              child: socialLogin("Google", "assets/images/google.png")),
                          socialLogin("Facebook", "assets/images/facebook.png"),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                "already have an account? ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(LoginScreen.routeName);
                                },
                                child: Text(
                                  "Log in",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Container socialLogin(String name, String img) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            child: Image.asset(img),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            name,
            style: TextStyle(
              fontSize: 15,
              color: Color.fromRGBO(103, 103, 103, 1),
            ),
          )
        ],
      ),
    );
  }

  Column inputFields(String label, String hintText, bool isPassword, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: primaryFontColor,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  validator: label == "Full Name"
                      ? (s) {
                          if (s!.isEmpty || s == null) return "Please enter the name!";
                          return null;
                        }
                      : label == "E-mail"
                          ? (s) {
                              if (s!.isEmpty || s == null) return "Please enter the email!";
                              if (!s.contains('@')) return "Please enter valid email!";
                              return null;
                            }
                          : (s) {
                              if (s!.isEmpty || s == null) return "Please enter the password!";
                              if (s.length < 8) return "Password length should be atleast 8 characters long!";
                              return null;
                            },
                  obscureText: isPassword
                      ? passwordVisible
                          ? true
                          : false
                      : false,
                  controller: controller,
                  decoration: InputDecoration.collapsed(
                      hintText: hintText,
                      hintStyle: TextStyle(
                        fontSize: 15,
                      )),
                ),
              ),
              isPassword
                  ? GestureDetector(
                      onTap: () => setState(() {
                        passwordVisible = !passwordVisible;
                      }),
                      child: Container(
                        child: passwordVisible
                            ? Image.asset(
                                "assets/images/password_hidden.png",
                              )
                            : Image.asset("assets/images/password_visible.png"),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
