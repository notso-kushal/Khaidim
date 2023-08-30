import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neww/controllers/authController.dart';
import 'package:neww/view/orders.dart';

import 'package:neww/view/profile.dart';
import 'package:neww/view/wishlist.dart';
import '../controllers/data_controller.dart';
import 'home.dart';

class landing extends StatefulWidget {
  const landing({
    super.key,
  });

  @override
  State<landing> createState() => _landingState();
}

class _landingState extends State<landing> {
  int selectedIndex = 0;
  List<Widget> pages = <Widget>[home(), const wishlist(), Orders(), const profile()];

  final DataController controller = Get.find();
  AuthController logController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.shifting,
          selectedFontSize: 16,
          unselectedItemColor: Colors.grey,
          selectedItemColor: const Color(0xFFd32a2a),

          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Tiktok',
          ),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Tiktok',
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_rounded),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],

          currentIndex: selectedIndex, //New
          onTap: _onItemTapped,
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
