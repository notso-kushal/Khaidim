import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neww/view/login.dart';

import '../controllers/authController.dart';

class Register extends StatefulWidget {
  const Register({Key? key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isChecked = false;
  bool showPass = true;
  final _formKey = GlobalKey<FormState>();
  Map<String, String> userSignupData = {"firstname": "", "email": "", "password": "", "lastname": ""};
  AuthController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 252, 252),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 40,
              ),
              Container(
                alignment: Alignment.topRight,
                child: Image.asset(
                  'images/AS.png',
                  height: 80,
                  width: 80,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: Text(
                    "Registration",
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
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Firstname',
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
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a Firstname';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          userSignupData['firstname'] = value!;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          fillColor: const Color(0xFF990009).withOpacity(0.3),
                          filled: true,
                          labelText: 'Firstname',
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
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Lastname',
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
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a lastname';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          userSignupData['lastname'] = value!;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          fillColor: const Color(0xFF990009).withOpacity(0.3),
                          filled: true,
                          labelText: 'Lastname',
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
                        padding: EdgeInsets.only(left: 10),
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
                          userSignupData['email'] = value!;
                        },
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
                          userSignupData['password'] = value!;
                        },
                        obscureText: showPass,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPass ? Icons.visibility_off : Icons.visibility,
                              color: const Color(0xFFd32a2a),
                            ),
                            onPressed: () {
                              setState(() {
                                showPass = !showPass;
                              });
                            },
                          ),
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
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        splashColor: Color.fromARGB(255, 209, 0, 14),
                        child: Ink(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFF990009),
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
                                'Register',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )),
                        onTap: () {
                          handleRegister();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Center(
                child: Text.rich(TextSpan(
                    text: "Already have an account?  ",
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: "Log In",
                          style: const TextStyle(
                              color: Color(0xFF990009),
                              decoration: TextDecoration.underline,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                            })
                    ])),
              )
            ],
          ),
        ),
      ),
    );
  }
  /////////* METHOD TO REGISTER */////////////

  handleRegister() async {
    if (_formKey.currentState!.validate()) {
      print("Form is valid ");
      _formKey.currentState!.save();
      print('User Sign Up Data $userSignupData');
      await controller.signUp(
          userSignupData['email'], userSignupData['password'], userSignupData['firstname'], userSignupData['lastname']);
    }
  }
}
