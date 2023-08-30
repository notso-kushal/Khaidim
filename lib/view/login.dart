import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neww/controllers/authController.dart';
import 'package:neww/view/register.dart';

class Login extends StatefulWidget {
  const Login({Key? key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final uscontroller = TextEditingController();
  final passcontroller = TextEditingController();
  bool isChecked = false;
  final _formKey = GlobalKey<FormState>();
  Map<String, String> userLoginData = {"email": "", "password": ""};

  AuthController controller = Get.put(AuthController());

  @override
  void dispose() {
    _formKey;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 252, 252),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.topRight,
                child: Image.asset(
                  'images/AS.png',
                  height: 100,
                  width: 100,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Welcome Back",
                    style: GoogleFonts.signika(
                      textStyle: const TextStyle(
                        color: Color(0xFF990009),
                        decoration: TextDecoration.none,
                        textBaseline: TextBaseline.alphabetic,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  'Login To Your Account.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF990009),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Email',
                          style: GoogleFonts.signika(
                            textStyle:
                                const TextStyle(fontSize: 20, color: Color(0xFF990009), fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : "Please enter a valid email";
                        },
                        onSaved: (value) {
                          userLoginData['email'] = value!;
                        },
                        controller: uscontroller,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          fillColor: const Color(0xFF990009).withOpacity(0.3),
                          filled: true,
                          labelText: 'Email',
                          contentPadding: const EdgeInsets.only(left: 20),
                          labelStyle:
                              GoogleFonts.signika(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                style: BorderStyle.none,
                              ),
                              borderRadius: BorderRadius.circular(30)),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.none),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Password',
                          style: GoogleFonts.signika(
                            textStyle:
                                const TextStyle(fontSize: 20, color: Color(0xFF990009), fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.go,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password is too short';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          userLoginData['password'] = value!;
                        },
                        controller: passcontroller,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          fillColor: const Color(0xFF990009).withOpacity(0.3),
                          filled: true,
                          labelText: 'Password',
                          contentPadding: const EdgeInsets.only(left: 20),
                          labelStyle:
                              GoogleFonts.signika(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                style: BorderStyle.none,
                              ),
                              borderRadius: BorderRadius.circular(30)),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.none),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                activeColor: const Color(0xFF990009),
                                side: const BorderSide(color: Color(0xFF990009), width: 2),
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                              ),
                              const Row(
                                children: [
                                  Text(
                                    'Remember me',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 90),
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        splashColor: const Color.fromARGB(255, 209, 0, 14),
                        child: Ink(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color(0xFF990009),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 2.0,
                                  offset: Offset(2.0, 2.0),
                                )
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )),
                        onTap: () {
                          handleLogin();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                constraints: BoxConstraints(maxHeight: 30),
                padding: EdgeInsets.only(left: 45),
                child: Row(
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    TextButton(
                        onPressed: () {
                          Get.to(() => Register());
                        },
                        child: const Text(
                          "\tRegister Now",
                          style: TextStyle(
                              color: Color(0xFF990009),
                              decoration: TextDecoration.underline,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Divider(
                      indent: 10.0,
                      endIndent: 10.0,
                      thickness: 1,
                      color: Colors.black,
                    ),
                  ),
                  Text("OR",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(color: Color(0xFF990009), fontWeight: FontWeight.bold),
                      )),
                  const Expanded(
                    child: Divider(
                      indent: 10.0,
                      endIndent: 10.0,
                      thickness: 1,
                      color: Colors.black,
                      height: 60,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  AuthController().signInWithGoogle();
                  // controller.googleLogin().then((value) async => await Navigator.pushReplacement(
                  //     context, MaterialPageRoute(builder: (context) => const landing())));
                },
                child: Card(
                  elevation: 5,
                  shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Row(children: [
                      Image.asset(
                        'images/G.png',
                        height: 40,
                        width: 40,
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      const Text(
                        'Sign In With Google',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Tiktok'),
                      )
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  handleLogin() {
    if (_formKey.currentState!.validate()) {
      print("Form is valid ");
      _formKey.currentState!.save();
      print('Data for login $userLoginData');
      controller.login(userLoginData['email'], userLoginData['password']);
    }
  }
}
