import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stars/essentials/basicpairedwidgets.dart';
import 'package:stars/models/addprofile.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var isUserLoggingIn = false;
  var authenticating = false;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final phoneNoController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  Map<String, bool> loginEntry = {
    "Email": true,
    "Phone": false,
  };
  Widget loginEntryType() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < loginEntry.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: ChoiceChip(
                  label: Text(
                    loginEntry.keys.toList()[i],
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  selected: loginEntry.values.toList()[i],
                  onSelected: (value) => setState(
                    () {
                      loginEntry.updateAll((key, value) {
                        if (loginEntry.keys.toList()[i] == key) {
                          return true;
                        } else {
                          return false;
                        }
                      });
                    },
                  ),
                ),
              ),
          ],
        ),
        loginEntry["Email"] == true
            ? BasicPairedWidgets.textFormFieldWithText(
                context: context,
                controller: emailController,
                text: "Email",
                hint: "email",
                width: 75,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Your Email";
                  } else if (value.contains(RegExp(r"[\s]"))) {
                    return "Enter valid email";
                  } else if (value.contains(RegExp(r"[@]"))) {
                    return null;
                  }
                  return "Enter valid email";
                },
              )
            : BasicPairedWidgets.textFormFieldWithText(
                context: context,
                controller: phoneNoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Your Phone No";
                  } else if (value.contains(RegExp(r"[a-zA-Z]"))) {
                    return "NO letters are allowed";
                  } else if (value.contains(RegExp(r"[0-9]")) &&
                      value.length == 10) {
                    return null;
                  } else {
                    return "Enter valid phone number";
                  }
                },
                text: "Phone No",
                hint: "phone",
                width: 75,
                keyboardType: TextInputType.phone,
              ),
      ],
    );
  }

  Future<void> authenticate({
    required String email,
    required String password,
    bool newUser = false,
  }) async {
    try {
      if (newUser) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) {
              return const AddProfile();
            }),
          );
        }
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on FirebaseAuthException catch (e) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(
                e.message.toString(),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Okay"),
                ),
              ],
            );
          },
        ),
      );
      setState(() {
        authenticating = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isUserLoggingIn ? "Hi" : "Welcome Back",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    loginEntryType(),
                    BasicPairedWidgets.textFormFieldWithText(
                      context: context,
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter the Password";
                        } else if (value.contains(r"[\s]")) {
                          return "no spaces are allowed";
                        } else if (value.length >= 6 &&
                            value.contains(RegExp(
                              r"[a-z0-9]",
                              caseSensitive: false,
                            ))) {
                          return null;
                        } else {
                          return "Enter valid password atleast having a number";
                        }
                      },
                      text: "Password",
                      hint: "password",
                      width: 75,
                      keyboardType: TextInputType.visiblePassword,
                      obscrueText: true,
                    ),
                    isUserLoggingIn
                        ? BasicPairedWidgets.textFormFieldWithText(
                            context: context,
                            controller: confirmPasswordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter the Password again";
                              } else if (value.contains(r"[\s]")) {
                                return "no spaces are allowed";
                              } else if (value.length >= 6 &&
                                  value.contains(RegExp(
                                    r"[a-z0-9]",
                                    caseSensitive: false,
                                  )) &&
                                  value == passwordController.text) {
                                return null;
                              } else {
                                return "password does not match";
                              }
                            },
                            text: "Confirm Password",
                            hint: "password",
                            width: 75,
                            keyboardType: TextInputType.visiblePassword,
                            obscrueText: true,
                          )
                        : const Center(),
                    authenticating == true
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                authenticating = true;
                                setState(() {});
                                await authenticate(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  newUser: isUserLoggingIn,
                                );
                              }
                            },
                            child: Text(
                              isUserLoggingIn ? "SignUp" : "Login",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                    Text(
                      "or",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    TextButton(
                      onPressed: () => setState(() {
                        isUserLoggingIn = !isUserLoggingIn;
                      }),
                      child: Text(
                          isUserLoggingIn ? "aldready an user" : "New user"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
