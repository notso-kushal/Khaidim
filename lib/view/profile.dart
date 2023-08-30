import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neww/controllers/authController.dart';
import 'package:neww/view/login.dart';

import '../controllers/data_controller.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  final user = FirebaseAuth.instance.currentUser;
  bool isGoogleSignIn = false;
  final DataController controller = Get.find();
  bool isVerified = false;
  @override
  Widget build(BuildContext context) {
    if (user != null) {
      for (UserInfo userInfo in user!.providerData) {
        if (userInfo.providerId == 'google.com') {
          isGoogleSignIn = true;
          break;
        }
      }
    }

    return Scaffold(
        body: Column(children: [
      Center(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 100, left: 0),
                child: isGoogleSignIn
                    ? CircleAvatar(
                        backgroundColor: Colors.black12,
                        onForegroundImageError: (exception, stackTrace) {
                          const AssetImage("images/404.png");
                        },
                        foregroundImage: NetworkImage("${FirebaseAuth.instance.currentUser!.photoURL!}"),
                        radius: 40,
                      )
                    : Align(
                        alignment: Alignment.center,
                        child:
                            ProfilePicture(name: controller.userProfileData['firstname'], radius: 40, fontsize: 30))),
            const SizedBox(
              height: 10,
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: isGoogleSignIn
                    ? user!.displayName
                    : (controller.userProfileData['firstname'] + ' ' + controller.userProfileData['lastname']) ??
                        'Guest',
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const WidgetSpan(
                  child: SizedBox(
                width: 5,
              )),
              WidgetSpan(
                child: Icon(
                  isVerified ? Icons.verified : Icons.brightness_low_sharp,
                  color: const Color(0xFF179CF0),
                ),
              )
            ])),
            const SizedBox(
              height: 5,
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Icon(Icons.email_rounded, size: 20, color: Color(0xFFa0a0a0)),
                isGoogleSignIn ? Text(" ${user!.email}") : Text("  ${controller.userProfileData['email']}"),
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
      Column(children: [
        ListTile(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    child: SizedBox(
                      height: 400,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: Column(children: [
                          Image(
                            image: AssetImage(
                              'images/AS.png',
                            ),
                            height: 150,
                            alignment: Alignment.center,
                            width: 150,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  text: const TextSpan(children: [
                                WidgetSpan(
                                    child: Icon(
                                  Icons.phone,
                                  size: 18,
                                )),
                                WidgetSpan(
                                    child: SizedBox(
                                  width: 30,
                                )),
                                TextSpan(
                                  text: '9866000765',
                                  style: TextStyle(fontFamily: 'Tiktok', fontSize: 16, color: Color(0xFFa0a0a0)),
                                )
                              ])),
                              const SizedBox(
                                height: 20,
                              ),
                              RichText(
                                  text: const TextSpan(children: [
                                WidgetSpan(
                                    child: Icon(
                                  Icons.email_rounded,
                                  size: 18,
                                )),
                                WidgetSpan(
                                    child: SizedBox(
                                  width: 30,
                                )),
                                TextSpan(
                                  text: 'kushalstha0g@gmail.com',
                                  style: TextStyle(fontFamily: 'Tiktok', fontSize: 16, color: Color(0xFFa0a0a0)),
                                )
                              ])),
                              const SizedBox(
                                height: 20,
                              ),
                              RichText(
                                  text: const TextSpan(children: [
                                WidgetSpan(
                                    child: Icon(
                                  Icons.facebook_rounded,
                                  size: 18,
                                )),
                                WidgetSpan(
                                    child: SizedBox(
                                  width: 30,
                                )),
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'kushal.shrestha.1272',
                                      style: TextStyle(
                                        fontFamily: 'Tiktok',
                                        fontSize: 10,
                                        color: Color(0xFFa0a0a0),
                                      ),
                                    )
                                  ],
                                  text: 'facebook.com/',
                                  style: TextStyle(
                                    fontFamily: 'Tiktok',
                                    fontSize: 16,
                                    color: Color(0xFFa0a0a0),
                                  ),
                                )
                              ])),
                              const SizedBox(
                                height: 20,
                              ),
                              RichText(
                                  text: const TextSpan(children: [
                                WidgetSpan(
                                    child: Icon(
                                  Icons.my_location_rounded,
                                  size: 18,
                                )),
                                WidgetSpan(
                                    child: SizedBox(
                                  width: 30,
                                )),
                                TextSpan(
                                  text: 'Chauuni, Meusem Marg',
                                  style: TextStyle(fontFamily: 'Tiktok', fontSize: 16, color: Color(0xFFa0a0a0)),
                                )
                              ]))
                            ],
                          ),
                        ]),
                      ),
                    ),
                  );
                });
          },
          minLeadingWidth: 0,
          leading: const Icon(
            Icons.contact_phone_rounded,
            color: Color(0xFF990009),
          ),
          title: const Text('Contact Us',
              style: TextStyle(
                fontFamily: 'Tiktok',
              )),
        ),
        ListTile(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    child: SizedBox(
                      height: 600,
                      child: RawScrollbar(
                        padding: const EdgeInsets.only(top: 100, bottom: 100),
                        scrollbarOrientation: ScrollbarOrientation.left,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        thumbColor: const Color(0xFF990009),
                        thickness: 5,
                        child: SingleChildScrollView(
                          child: Column(children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Title(
                              color: Colors.black,
                              child: Text(
                                'Terms and Conditions',
                                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const ListTile(
                              title: Text(
                                '1. By using our app, you agree to these terms and conditions.',
                                style: TextStyle(fontFamily: 'Tiktok', fontSize: 12, color: Color(0xFFa0a0a0)),
                              ),
                            ),
                            const ListTile(
                              title: Text(
                                '2. You must be at least 13 years old to use the app.',
                                style: TextStyle(fontFamily: 'Tiktok', fontSize: 12, color: Color(0xFFa0a0a0)),
                              ),
                            ),
                            const ListTile(
                              title: Text(
                                '3. Use the app responsibly and in compliance with the law.',
                                style: TextStyle(fontFamily: 'Tiktok', fontSize: 12, color: Color(0xFFa0a0a0)),
                              ),
                            ),
                            const ListTile(
                              title: Text(
                                '4. We provide a platform for ordering food from participating restaurants and vendors.',
                                style: TextStyle(fontFamily: 'Tiktok', fontSize: 12, color: Color(0xFFa0a0a0)),
                              ),
                            ),
                            const ListTile(
                              title: Text(
                                '5. Orders are subject to availability and acceptance by the restaurant or vendor.',
                                style: TextStyle(fontFamily: 'Tiktok', fontSize: 12, color: Color(0xFFa0a0a0)),
                              ),
                            ),
                            const ListTile(
                              title: Text(
                                '6. Delivery times are estimated and may vary.',
                                style: TextStyle(fontFamily: 'Tiktok', fontSize: 12, color: Color(0xFFa0a0a0)),
                              ),
                            ),
                            const ListTile(
                              title: Text(
                                '7. Payments must be made through the app.',
                                style: TextStyle(fontFamily: 'Tiktok', fontSize: 12, color: Color(0xFFa0a0a0)),
                              ),
                            ),
                            const ListTile(
                              title: Text(
                                '8. We do our best to provide accurate information about food and allergens, but we cannot guarantee it.',
                                style: TextStyle(fontFamily: 'Tiktok', fontSize: 12, color: Color(0xFFa0a0a0)),
                              ),
                            ),
                            const ListTile(
                              title: Text(
                                '9. You are responsible for verifying and managing any food allergies or dietary restrictions.',
                                style: TextStyle(fontFamily: 'Tiktok', fontSize: 12, color: Color(0xFFa0a0a0)),
                              ),
                            ),
                            const ListTile(
                              title: Text(
                                "10. The app's content is our intellectual property and cannot be used without permission.",
                                style: TextStyle(fontFamily: 'Tiktok', fontSize: 12, color: Color(0xFFa0a0a0)),
                              ),
                            ),
                            const ListTile(
                              title: Text(
                                '11. We are not liable for any damages or losses resulting from your use of the app.',
                                style: TextStyle(fontFamily: 'Tiktok', fontSize: 12, color: Color(0xFFa0a0a0)),
                              ),
                            ),
                            const ListTile(
                              title: Text(
                                '12. These terms and conditions are governed by the laws.',
                                style: TextStyle(fontFamily: 'Tiktok', fontSize: 12, color: Color(0xFFa0a0a0)),
                              ),
                            ),
                            const ListTile(
                              title: Text(
                                '13. We may update the terms and conditions at any time.',
                                style: TextStyle(fontFamily: 'Tiktok', fontSize: 12, color: Color(0xFFa0a0a0)),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  );
                });
          },
          minLeadingWidth: 0,
          leading: const Icon(Icons.document_scanner_outlined, color: Color(0xFF990009)),
          title: const Text('Terms and Condition',
              style: TextStyle(
                fontFamily: 'Tiktok',
              )),
        ),
        ListTile(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    'Are you sure to logout?',
                    style: TextStyle(
                      fontFamily: 'Tiktok',
                    ),
                  ),
                  content: const Text(
                    'Logging out from the app with sign you out from app and redirect to login screen',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: 'Tiktok',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        AuthController().signOutWithGoogle().then((value) => Navigator.pop(context));
                        handleLogOut();
                      },
                      child: const Text('Yes', style: TextStyle(color: Colors.white, fontFamily: 'Tiktok')),
                      style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xFF4CB051))),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('No', style: TextStyle(color: Colors.white, fontFamily: 'Tiktok')),
                        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red))),
                  ],
                );
              },
            );
          },
          minLeadingWidth: 0,
          leading: const Icon(
            Icons.directions_run_sharp,
            color: Color(0xFF990009),
          ),
          title: const Text('Logout',
              style: TextStyle(
                fontFamily: 'Tiktok',
              )),
        )
      ]),
    ]));
  }

  handleLogOut() {
    AuthController().logout();
    Get.off(() => const Login());
  }
}
