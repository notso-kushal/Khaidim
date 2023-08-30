import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:neww/APi%20calls/Forall.dart';
import 'package:neww/controllers/authController.dart';
import 'package:neww/model/famousFoodProviders.dart';
import 'package:neww/view/sebar.dart';
import 'package:page_transition/page_transition.dart';
import '../controllers/data_controller.dart';
import '../model/cartmodel.dart';
import '../model/foodCategories.dart';
import '../model/wishlistmodel.dart';
import '../notifiers/cart.dart';
import '../notifiers/wishlistnotifiers.dart';

final allwishlistProvider = StateNotifierProvider<Nofier, List<WishList>>((ref) => Nofier());

// ignore: must_be_immutable, camel_case_types
class home extends ConsumerWidget {
  home({super.key});
  List<dynamic> filteredData = [];
  final DataController dcontroller = Get.put(DataController());
  final DataController controller = Get.find();
  AuthController logController = Get.put(AuthController());
  final successful = AssetLottie('images/success.json');
  TextEditingController searchController = TextEditingController();

  void initState() {
    getALL();
    DataController();
    AuthController();
  }

  final cartController = Get.put(ProductController());
  final user = FirebaseAuth.instance.currentUser;
  bool isGoogleSignIn = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (user != null) {
      for (UserInfo userInfo in user!.providerData) {
        if (userInfo.providerId == 'google.com') {
          isGoogleSignIn = true;
          break;
        }
      }
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 40,
          toolbarHeight: 80,
          backgroundColor: const Color(0xFF990009),
          leadingWidth: 100,
          leading: isGoogleSignIn
              ? CircleAvatar(
                  backgroundColor: Color(0xFF990009),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      progressIndicatorBuilder: (context, url, progress) {
                        return CircularProgressIndicator(
                          color: Color(0xFF990009),
                        );
                      },
                      imageUrl: "${FirebaseAuth.instance.currentUser!.photoURL}",
                      width: 50,
                      height: 50,
                    ),
                  ),
                )
              : CircleAvatar(
                  backgroundColor: Color(0xFF990009),
                  child: ClipOval(
                    child: ProfilePicture(
                      name: controller.userProfileData['firstname'],
                      fontsize: 20,
                      radius: 25,
                    ),
                  ),
                ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 10),
              child: IconButton(
                icon: Icon(Ionicons.search_outline, size: 30),
                onPressed: () {
                  showSearchBar(context);
                },
              ),
            ),
          ],
          title: ListTile(
            title: Text(
              isGoogleSignIn
                  ? "Welcome ${user!.displayName?.split(" ").elementAt(0)}"
                  : "Welcome ${controller.userProfileData['firstname'] ?? 'Guest'}",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            subtitle: Text(
              greetingMessage(),
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Tiktok',
                fontSize: 16,
              ),
            ),
          ),
          titleSpacing: -10,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 120,
                width: 400,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.bottomToTop,
                                    child: itemClass[i],
                                    duration: const Duration(milliseconds: 200)));
                          },
                          // splashFactory: NoSplash.splashFactory,
                          child: SizedBox(
                            height: 80,
                            width: 90,
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 6,
                              child: Column(children: [
                                Image.asset(
                                  images[i],
                                  height: 50,
                                  width: 50,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(items[i],
                                    style: const TextStyle(color: Color(0xFF990009), fontWeight: FontWeight.bold))
                              ]),
                            ),
                          ),
                        ));
                  },
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: 'Popular Foods',
                            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          const TextSpan(
                            text: '\nSome Popular Foods',
                            style: TextStyle(fontSize: 12, fontFamily: 'Tiktok', color: Color(0xFFa0a0a0)),
                          ),
                        ])),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: 200,
                      child: FutureBuilder(
                          future: getALL(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              filteredData = snapshot.data.toList();
                              return GridView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 6,
                                itemBuilder: (_, index) {
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
                                                        foregroundImage:
                                                            NetworkImage(filteredData[index]['image'].toString()),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(filteredData[index]['title'].toString().toUpperCase(),
                                                          textAlign: TextAlign.center,
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                                fontSize: 16, fontWeight: FontWeight.bold),
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
                                                          visualDensity:
                                                              const VisualDensity(horizontal: 0, vertical: -1),
                                                          title: Text.rich(TextSpan(children: [
                                                            const TextSpan(
                                                                text: 'Difficulty: ',
                                                                style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontFamily: 'Tiktok',
                                                                    fontWeight: FontWeight.bold)),
                                                            TextSpan(
                                                              text: filteredData[index]['difficulty'],
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily: 'Tiktok',
                                                                  overflow: TextOverflow.fade),
                                                            )
                                                          ]))),
                                                      ListTile(
                                                          dense: true,
                                                          visualDensity:
                                                              const VisualDensity(horizontal: 0, vertical: -4),
                                                          title: Text.rich(TextSpan(children: [
                                                            const TextSpan(
                                                                text: 'Description: ',
                                                                style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontFamily: 'Tiktok',
                                                                    fontWeight: FontWeight.bold)),
                                                            TextSpan(
                                                              text: filteredData[index]['description'],
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily: 'Tiktok',
                                                                  overflow: TextOverflow.fade),
                                                            ),
                                                          ]))),
                                                      ListTile(
                                                          dense: true,
                                                          visualDensity:
                                                              const VisualDensity(horizontal: 0, vertical: -4),
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
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 10,
                                          left: 10,
                                        ),
                                        child: Card(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          elevation: 6,
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        final wishListNotifier = ref.read(allwishlistProvider.notifier);
                                                        final wishList = ref.read(allwishlistProvider);
                                                        final item = WishList(
                                                            rating: '$rating',
                                                            title: filteredData[index]['title'].toString(),
                                                            image: filteredData[index]['image'].toString(),
                                                            price: filteredData[index]['price']);

                                                        if (wishList.contains(item)) {
                                                          wishListNotifier.removeFromWishList(item);
                                                        } else {
                                                          wishListNotifier.addwishList(item);
                                                        }
                                                      },
                                                      child: Icon(
                                                        ref.watch(allwishlistProvider).contains(
                                                                  WishList(
                                                                      price: filteredData[index]['price'],
                                                                      rating: '$rating',
                                                                      title: filteredData[index]['title'].toString(),
                                                                      image: filteredData[index]['image'].toString()),
                                                                )
                                                            ? Icons.favorite
                                                            : Icons.favorite_border,
                                                      ),
                                                    ),
                                                    Obx(() {
                                                      final isItemInCart =
                                                          cartController.isItemInCart(filteredData[index]);

                                                      return GestureDetector(
                                                        onTap: () {
                                                          // Toggle cart item and wishlist item
                                                          print('pressed');
                                                          cartController.toggleCartItem(Product(
                                                            rating: filteredData[index]['rating'].toString(),
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
                                                          isItemInCart
                                                              ? Icons.shopping_bag
                                                              : Icons.shopping_bag_outlined,
                                                        ),
                                                      );
                                                    }),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 100,
                                                height: 100,
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
                                                height: 5,
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
                                    ),
                                  );
                                },
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.8,
                                  crossAxisCount: 1,
                                ),
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
                          }))
                ],
              ),
              Align(
                alignment: const Alignment(-0.7, 1),
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: 'Popular Food Providers',
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const TextSpan(
                    text: '\nExplore Some Popular Food Chains',
                    style: TextStyle(fontSize: 12, fontFamily: 'Tiktok', color: Color(0xFFa0a0a0)),
                  )
                ])),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: foodProviders.length,
                itemBuilder: (c, ind) {
                  return InkWell(
                    splashColor: const Color(0xFF990009),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => foodClass[ind]));
                    },
                    child: Card(
                      child: Row(children: [
                        Image.asset(
                          foodProviderImages[ind],
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(
                          foodProviders[ind],
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ]),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String greetingMessage() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return '🌤️ Good Morning dada';
    }
    if (hour < 17) {
      return '☀️ Good Afternoon dada';
    }
    if (hour < 20) {
      return '🌘 Good Evening dada';
    }
    return '🌚 Good Night dada';
  }

  showSearchBar(BuildContext context) async {
    await showSearch(
      context: context,
      delegate: SearchBarDelegate(filteredData),
    );
  }
}
