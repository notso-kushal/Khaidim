import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/wishlistmodel.dart';

class Nofier extends StateNotifier<List<WishList>> {
  Nofier() : super([]);

  void addwishList(WishList item) {
    state = [...state, item];
  }

  void removeFromWishList(WishList item) {
    state = state.where((wishlistItem) => wishlistItem != item).toList();
  }
}
