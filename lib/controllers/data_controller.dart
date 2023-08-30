import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'authController.dart';

class DataController extends GetxController {
  final firebaseInstance = FirebaseFirestore.instance;
  Map userProfileData = {'firstname': '', 'joinDate': '', 'email': '', 'lastname': ''};
  AuthController authController = AuthController();

  void onReady() {
    super.onReady();
    getUserProfileData();
    update();
  }

  Future<void> getUserProfileData() async {
    try {
      var response = await firebaseInstance.collection('userslist').get();
      if (response.docs.length > 0) {
        userProfileData['firstname'] = response.docs[0]['first_name'];
        userProfileData['lastname'] = response.docs[0]['last_name'];
        userProfileData['joinDate'] = response.docs[0]['joinDate'];
        userProfileData['email'] = response.docs[0]['email'];
        userProfileData['image'] = response.docs[0]['image'];
      }
      print("CCCCCCC ${userProfileData}");
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }
}
