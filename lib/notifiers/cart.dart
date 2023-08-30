import 'package:get/get.dart';
import '../model/cartmodel.dart';

class ProductController extends GetxController {
  RxList cartItem = [].obs;

  @override
  void onInit() {
    super.onInit();

    update();
  }

  void clearCart() {
    cartItem.clear();
    update();
  }

  void addtoCart(Product item) {
    print("calling addtoCart");
    cartItem.add(item);

    update(); // Notify GetX that the state has changed
  }

  // Remove an item from the cart
  void removefromCart(Product item) {
    cartItem.remove(item);
    update(); // Notify GetX that the state has changed
  }

  void incrementCounter(Product price) {
    print("calling counter");
    cartItem.add(price);

    update(); // Notify GetX that the state has changed
  }

  bool isItemInCart(Map<String, dynamic> itemData) {
    // Check if the item is in the cart based on its attributes
    return cartItem.any((item) => item.title == itemData['title']);
  }

  bool toggleCartItem(Product newItem) {
    // Check if the item is already in the cart
    final index = cartItem.indexWhere((item) => item.title == newItem.title);

    if (index != -1) {
      // Item already in the cart, remove it
      cartItem.removeAt(index);
      return false;
    } else {
      // Item not in the cart, add it
      cartItem.add(newItem);
      return true;
    }
  }

  // double get totalPrice => cartItem.fold(0, (sum, item) => sum + item.price);
  int get count => cartItem.length;
}
