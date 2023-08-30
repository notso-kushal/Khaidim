import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/cartmodel.dart';
import '../notifiers/cart.dart';

class SearchBarDelegate extends SearchDelegate<String> {
  final List<dynamic> filteredData;

  final cartController = Get.put(ProductController());
  SearchBarDelegate(this.filteredData);

  @override
  appBarTheme(BuildContext context) {
    return ThemeData(
      inputDecorationTheme:
          const InputDecorationTheme(focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none)),
      hintColor: Colors.white,
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontFamily: 'Tiktok'),
      ),
      appBarTheme: const AppBarTheme(
        toolbarHeight: 80,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(50), bottomLeft: Radius.circular(50))),
        backgroundColor: Color(0xFF990009),
        elevation: 10,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(right: 20),
        child: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            query = '';
          },
        ),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestions = filteredData.where((foods) {
      String name = foods['title'].toString().toLowerCase();
      String searchValue = query.toLowerCase();

      return name.contains(searchValue);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        String ratingString = suggestions[index]['rating'].toString();
        double rating = double.tryParse(ratingString) ?? 0.0;
        return ListTile(
          contentPadding: const EdgeInsets.only(left: 30),
          title: Text(
            suggestions[index]['title'].toString(),
            style: const TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Tiktok'),
          ),
          onTap: () {
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) {
                return Dialog(
                  insetAnimationCurve: Curves.easeIn,
                  insetAnimationDuration: const Duration(milliseconds: 200),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  child: SingleChildScrollView(
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
                              foregroundImage: NetworkImage(suggestions[index]['image'].toString()),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(suggestions[index]['title'].toString().toUpperCase(),
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
                                      style:
                                          TextStyle(fontSize: 16, fontFamily: 'Tiktok', fontWeight: FontWeight.bold)),
                                  TextSpan(
                                    text: suggestions[index]['difficulty'],
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
                                      style:
                                          TextStyle(fontSize: 16, fontFamily: 'Tiktok', fontWeight: FontWeight.bold)),
                                  TextSpan(
                                    text: suggestions[index]['description'],
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
                                    text: suggestions[index]['price'].toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Tiktok',
                                      color: Color(0xFF1FB141),
                                    ),
                                  ),
                                ])),
                                trailing: Obx(() {
                                  final isItemInCart = cartController.isItemInCart(filteredData[index]);
                                  return ElevatedButton(
                                    style: const ButtonStyle(
                                        backgroundColor: MaterialStatePropertyAll(Color(0xFF990009)),
                                        padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
                                        shape: MaterialStatePropertyAll(ContinuousRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(20))))),
                                    onPressed: () {
                                      cartController.toggleCartItem(Product(
                                        rating: filteredData[index]['rating'].toString(),
                                        title: filteredData[index]['title'],
                                        image: filteredData[index]['image'].toString(),
                                        price: filteredData[index]['price'],
                                      ));
                                      final snackBar = SnackBar(
                                        dismissDirection: DismissDirection.vertical,
                                        duration: const Duration(seconds: 2),
                                        backgroundColor: const Color(0xFF990009),
                                        content: isItemInCart
                                            ? const Text('Removed From Cart')
                                            : const Text('Gladly Added To Cart'),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    },
                                    child: isItemInCart
                                        ? const Text(
                                            'Remove To Cart',
                                            style: TextStyle(
                                                fontFamily: 'Tiktok', fontSize: 10, fontWeight: FontWeight.bold),
                                          )
                                        : const Text(
                                            'Add To Cart',
                                            style: TextStyle(
                                                fontFamily: 'Tiktok', fontSize: 10, fontWeight: FontWeight.bold),
                                          ),
                                  );
                                }))
                          ],
                        ),
                      ]),
                    ),
                  ),
                );
              },
            );
          },
          enabled: true,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = filteredData.where((foods) {
      String name = foods['title'].toString().toLowerCase();
      String searchValue = query.toLowerCase();

      return name.contains(searchValue);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        String ratingString = suggestions[index]['rating'].toString();
        double rating = double.tryParse(ratingString) ?? 0.0;
        return ListTile(
          contentPadding: const EdgeInsets.only(left: 30),
          title: Text(
            suggestions[index]['title'].toString(),
            style: const TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Tiktok'),
          ),
          onTap: () {
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) {
                return Dialog(
                  insetAnimationCurve: Curves.easeIn,
                  insetAnimationDuration: const Duration(milliseconds: 200),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  child: SingleChildScrollView(
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
                              foregroundImage: NetworkImage(suggestions[index]['image'].toString()),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(suggestions[index]['title'].toString().toUpperCase(),
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
                                      style:
                                          TextStyle(fontSize: 16, fontFamily: 'Tiktok', fontWeight: FontWeight.bold)),
                                  TextSpan(
                                    text: suggestions[index]['difficulty'],
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
                                      style:
                                          TextStyle(fontSize: 16, fontFamily: 'Tiktok', fontWeight: FontWeight.bold)),
                                  TextSpan(
                                    text: suggestions[index]['description'],
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
                                    text: suggestions[index]['price'].toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Tiktok',
                                      color: Color(0xFF1FB141),
                                    ),
                                  ),
                                ])),
                                trailing: Obx(() {
                                  final isItemInCart = cartController.isItemInCart(filteredData[index]);
                                  return ElevatedButton(
                                    style: const ButtonStyle(
                                        backgroundColor: MaterialStatePropertyAll(Color(0xFF990009)),
                                        padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
                                        shape: MaterialStatePropertyAll(ContinuousRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(20))))),
                                    onPressed: () {
                                      cartController.toggleCartItem(Product(
                                        rating: filteredData[index]['rating'].toString(),
                                        title: filteredData[index]['title'],
                                        image: filteredData[index]['image'].toString(),
                                        price: filteredData[index]['price'],
                                      ));
                                      final snackBar = SnackBar(
                                        dismissDirection: DismissDirection.vertical,
                                        duration: const Duration(seconds: 2),
                                        backgroundColor: const Color(0xFF990009),
                                        content: isItemInCart
                                            ? const Text('Removed From Cart')
                                            : const Text('Gladly Added To Cart'),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    },
                                    child: isItemInCart
                                        ? const Text(
                                            'Remove To Cart',
                                            style: TextStyle(
                                                fontFamily: 'Tiktok', fontSize: 10, fontWeight: FontWeight.bold),
                                          )
                                        : const Text(
                                            'Add To Cart',
                                            style: TextStyle(
                                                fontFamily: 'Tiktok', fontSize: 10, fontWeight: FontWeight.bold),
                                          ),
                                  );
                                }))
                          ],
                        ),
                      ]),
                    ),
                  ),
                );
              },
            );
          },
          enabled: true,
        );
      },
    );
  }
}
