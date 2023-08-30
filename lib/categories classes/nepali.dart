import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:neww/model/cartmodel.dart';
import 'package:neww/model/wishlistmodel.dart';
import 'package:neww/notifiers/cart.dart';
import 'package:neww/view/orders.dart';
import 'package:page_transition/page_transition.dart';
import '../APi calls/nepaliFoods.dart';
import '../notifiers/wishlistnotifiers.dart';

final nepwishlistProvider = StateNotifierProvider<Nofier, List<WishList>>((ref) => Nofier());

// ignore: must_be_immutable
class Nepali extends ConsumerWidget {
  Nepali({super.key});
  List<dynamic> filteredData = [];
  List cartItems = [];

  void initState() {
    getNepFoods();
  }

  final cartController = Get.put(ProductController());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF990009),
          // leading: Icon(
          //   Icons.arrow_back_ios_new_rounded,
          // ),
          automaticallyImplyLeading: true,
          title: Text(
            'Nepali Foods',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
          child: FutureBuilder(
            future: getNepFoods(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                filteredData = snapshot.data.toList();

                return GridView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    String ratingString = filteredData[index]['rating'].toString();
                    double rating = double.tryParse(ratingString) ?? 0.0;

                    return GridTile(
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                child: SizedBox(
                                  height: 550,
                                  child: Column(children: [
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        CircleAvatar(
                                          radius: 60,
                                          backgroundImage: const AssetImage("images/404.png"),
                                          foregroundImage: NetworkImage(filteredData[index]['image'].toString()),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(filteredData[index]['title'].toString().toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            )),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                    ListView(
                                      shrinkWrap: true,
                                      children: [
                                        Align(
                                          alignment: const Alignment(-0.85, 0),
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
                                        ListTile(
                                            dense: true,
                                            visualDensity: const VisualDensity(horizontal: 0, vertical: -1),
                                            title: Text.rich(TextSpan(children: [
                                              const TextSpan(
                                                  text: 'Difficulty: ',
                                                  style: TextStyle(
                                                      fontSize: 16, fontFamily: 'Tiktok', fontWeight: FontWeight.bold)),
                                              TextSpan(
                                                text: filteredData[index]['difficulty'],
                                                style: const TextStyle(
                                                    fontSize: 14, fontFamily: 'Tiktok', overflow: TextOverflow.fade),
                                              )
                                            ]))),
                                        ListTile(
                                            dense: true,
                                            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                            title: Text.rich(TextSpan(children: [
                                              const TextSpan(
                                                  text: 'Description: ',
                                                  style: TextStyle(
                                                      fontSize: 16, fontFamily: 'Tiktok', fontWeight: FontWeight.bold)),
                                              TextSpan(
                                                text: filteredData[index]['description'],
                                                style: const TextStyle(
                                                    fontSize: 14, fontFamily: 'Tiktok', overflow: TextOverflow.fade),
                                              ),
                                            ]))),
                                        ListTile(
                                            dense: true,
                                            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                            title: Text.rich(TextSpan(children: [
                                              const TextSpan(
                                                  text: 'रु. ',
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      fontFamily: 'Tiktok',
                                                      color: Color(0xFF1FB141),
                                                      fontWeight: FontWeight.bold)),
                                              TextSpan(
                                                text: filteredData[index]['price'].toString(),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'Tiktok',
                                                  color: Color(0xFF1FB141),
                                                ),
                                              ),
                                            ])))
                                      ],
                                    ),
                                  ]),
                                ),
                              );
                            },
                          );
                        },
                        splashColor: const Color(0xFF990009),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        final wishListNotifier = ref.read(nepwishlistProvider.notifier);
                                        final wishList = ref.read(nepwishlistProvider);
                                        final item = WishList(
                                            price: filteredData[index]['price'],
                                            rating: '$rating',
                                            title: filteredData[index]['title'],
                                            image: filteredData[index]['image'].toString());

                                        if (wishList.contains(item)) {
                                          wishListNotifier.removeFromWishList(item);
                                        } else {
                                          wishListNotifier.addwishList(item);
                                        }
                                      },
                                      child: Icon(
                                        ref.watch(nepwishlistProvider).contains(
                                                  WishList(
                                                      price: filteredData[index]['price'],
                                                      rating: '$rating',
                                                      title: filteredData[index]['title'],
                                                      image: filteredData[index]['image'].toString()),
                                                )
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                      ),
                                    ),
                                    Obx(() {
                                      final isItemInCart = cartController.isItemInCart(filteredData[index]);

                                      return GestureDetector(
                                        onTap: () {
                                          // Toggle cart item and wishlist item

                                          cartController.toggleCartItem(Product(
                                            rating: filteredData[index]['rating'],
                                            title: filteredData[index]['title'],
                                            image: filteredData[index]['image'].toString(),
                                            price: filteredData[index]['price'],
                                          ));

                                          // final snackBar = SnackBar(
                                          //   content: const Text('Yay! A SnackBar!'),
                                          // );
                                          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                          // Item added to cart
                                          // Show snackbar or other UI feedback
                                        },
                                        child: Icon(
                                          isItemInCart ? Icons.shopping_bag : Icons.shopping_bag_outlined,
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: ClipOval(
                                  child: FadeInImage.assetNetwork(
                                    placeholder: "images/1.png",
                                    image: filteredData[index]['image'].toString(),
                                    imageErrorBuilder: (context, error, stackTrace) {
                                      return const Image(image: AssetImage('images/404.png'));
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(filteredData[index]['title'].toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Tiktok',
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 0.8, crossAxisCount: 2),
                );
              } else {
                return const Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 80,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballRotateChase,
                        colors: [Colors.black],
                      ),
                    ));
              }
            },
          ),
        ),
        floatingActionButton: Align(
          alignment: Alignment(1, 1),
          child: CircleAvatar(
            backgroundColor: Color(0xFF990009),
            radius: 30,
            child: Obx(() {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Orders(), type: PageTransitionType.scale, alignment: Alignment.bottomCenter));
                },
                child: Badge(
                  backgroundColor: Colors.red,
                  textStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tiktok'),
                  label: Text(
                    cartController.count.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  child: Icon(
                    Icons.shopify_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              );
            }),
          ),
        ));
  }
}
