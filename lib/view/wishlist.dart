import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neww/categories%20classes/burgerking.dart';
import 'package:neww/categories%20classes/chinses.dart';
import 'package:neww/categories%20classes/indian.dart';
import 'package:neww/categories%20classes/mexican.dart';
import 'package:neww/categories%20classes/nepali.dart';
import 'package:neww/categories%20classes/pizzahut.dart';
import 'package:neww/categories%20classes/sluttyvegan.dart';
import 'package:neww/categories%20classes/spanish.dart';
import '../categories classes/7thhea.dart';
import '../categories classes/italian.dart';
import '../categories classes/kfc.dart';
import '../categories classes/wofb.dart';
import 'home.dart';

class wishlist extends ConsumerWidget {
  const wishlist({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chiwishlistList = ref.watch(chiwishlistProvider);
    final chiwishListNotifier = ref.read(chiwishlistProvider.notifier);
    final indwishlistList = ref.watch(indwishlistProvider);
    final indwishListNotifier = ref.read(indwishlistProvider.notifier);
    final itawishlistList = ref.watch(itawishlistProvider);
    final itawishListNotifier = ref.read(itawishlistProvider.notifier);
    final nepwishlistList = ref.watch(nepwishlistProvider);
    final nepwishListNotifier = ref.read(nepwishlistProvider.notifier);
    final spawishlistList = ref.watch(spawishlistProvider);
    final spawishListNotifier = ref.read(spawishlistProvider.notifier);
    final mexiwishlistList = ref.watch(mexiwishlistProvider);
    final mexiwishListNotifier = ref.read(mexiwishlistProvider.notifier);
    final kfcwishlistList = ref.watch(kfcwishlistProvider);
    final kfcwishListNotifier = ref.read(kfcwishlistProvider.notifier);
    final bkingwishlistList = ref.watch(bkingwishlistProvider);
    final bkingwishListNotifier = ref.read(bkingwishlistProvider.notifier);
    final phutwishlistList = ref.watch(phutwishlistProvider);
    final phutwishListNotifier = ref.read(phutwishlistProvider.notifier);
    final worldofbwishlistList = ref.watch(worldofbwishlistProvider);
    final worldofbwishListNotifier = ref.read(worldofbwishlistProvider.notifier);
    final sluttywishlistList = ref.watch(sluttywishlistProvider);
    final sluttywishListNotifier = ref.read(sluttywishlistProvider.notifier);
    final sheawishlistList = ref.watch(sheawishlistProvider);
    final sheawishListNotifier = ref.read(sheawishlistProvider.notifier);
    final allwishlistList = ref.watch(allwishlistProvider);
    final allwishListNotifier = ref.read(allwishlistProvider.notifier);

    final combinedList = [
      ...chiwishlistList,
      ...indwishlistList,
      ...itawishlistList,
      ...nepwishlistList,
      ...spawishlistList,
      ...mexiwishlistList,
      ...kfcwishlistList,
      ...bkingwishlistList,
      ...phutwishlistList,
      ...worldofbwishlistList,
      ...sluttywishlistList,
      ...sheawishlistList,
      ...allwishlistList
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wishlist',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF990009),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          // controller: ScrollController(),
          scrollDirection: Axis.vertical,
          child: Column(children: [
            ListView.builder(
                itemCount: combinedList.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  String ratingString = combinedList[index].rating.toString();
                  double rating = double.tryParse(ratingString) ?? 0.0;

                  return Card(
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.elliptical(10, 10)),
                            child: FadeInImage.assetNetwork(
                              placeholder: "images/1.png",
                              image: combinedList[index].image.toString(),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image(image: AssetImage('images/404.png'));
                              },
                            ),
                          ),
                          title: Text(combinedList[index].title,
                              style: const TextStyle(fontSize: 14, fontFamily: 'Tiktok', fontWeight: FontWeight.bold)),
                          subtitle: RichText(
                              text: TextSpan(children: [
                            WidgetSpan(
                              child: RatingBar.builder(
                                itemSize: 18,
                                ignoreGestures: true,
                                initialRating: rating,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {},
                              ),
                            ),
                          ])),
                          trailing: IconButton(
                            onPressed: () {
                              // Remove the item from the combined list
                              chiwishListNotifier.removeFromWishList(combinedList[index]);
                              indwishListNotifier.removeFromWishList(combinedList[index]);
                              itawishListNotifier.removeFromWishList(combinedList[index]);
                              nepwishListNotifier.removeFromWishList(combinedList[index]);
                              spawishListNotifier.removeFromWishList(combinedList[index]);
                              mexiwishListNotifier.removeFromWishList(combinedList[index]);
                              kfcwishListNotifier.removeFromWishList(combinedList[index]);
                              bkingwishListNotifier.removeFromWishList(combinedList[index]);
                              phutwishListNotifier.removeFromWishList(combinedList[index]);
                              worldofbwishListNotifier.removeFromWishList(combinedList[index]);
                              sluttywishListNotifier.removeFromWishList(combinedList[index]);
                              sheawishListNotifier.removeFromWishList(combinedList[index]);
                              allwishListNotifier.removeFromWishList(combinedList[index]);
                            },
                            icon: const Icon(
                              Icons.delete_rounded,
                              color: Color(0xFF990009),
                            ),
                          ),
                        ),
                        Align(
                            alignment: const Alignment(-0.435, 0),
                            child: Text.rich(TextSpan(children: [
                              const TextSpan(
                                  text: 'रु. ',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: 'Tiktok',
                                      color: Color(0xFF1FB141),
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: combinedList[index].price.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Tiktok',
                                  color: Color(0xFF1FB141),
                                ),
                              ),
                            ]))),
                      ],
                    ),
                  );
                }),
          ]),
        ),
      ),
    );
  }
}
