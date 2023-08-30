import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:neww/notifiers/cart.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final ProductController cartController = Get.put(ProductController());
  final ProductController controller = Get.find();

  Map<int, int> quantities = {};

  double total = 0;

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    for (int index = 0; index < cartController.count; index++) {
      int itemPrice = cartController.cartItem[index].price;
      int quantity = quantities[index] ?? 1; // Get the selected quantity or default to 1
      totalPrice += itemPrice * quantity; // Calculate total price for this item
    }

    double totalDiscount = 0.1 * totalPrice;
    total = totalPrice - totalDiscount;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF990009),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
      ),
      body: Container(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: SingleChildScrollView(
                // controller: ScrollController(),
                scrollDirection: Axis.vertical,
                child: Column(children: [
                  ListView.builder(
                      itemCount: cartController.count,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        String ratingString = cartController.cartItem[index].rating.toString();
                        double rating = double.tryParse(ratingString) ?? 0.0;
                        int itemPrice = cartController.cartItem[index].price * (quantities[index] ?? 1);

                        return Card(
                          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: Column(
                            children: [
                              ListTile(
                                leading: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.elliptical(10, 10)),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: "images/1.png",
                                    image: cartController.cartItem[index].image.toString(),
                                    imageErrorBuilder: (context, error, stackTrace) {
                                      return const Image(image: AssetImage('images/404.png'));
                                    },
                                  ),
                                ),
                                title: Text(cartController.cartItem[index].title,
                                    style: const TextStyle(
                                        fontSize: 14, fontFamily: 'Tiktok', fontWeight: FontWeight.bold)),
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
                                    cartController.removefromCart(cartController.cartItem[index]);
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.delete_rounded,
                                    color: Color(0xFF990009),
                                  ),
                                ),
                              ),
                              Align(
                                  alignment: const Alignment(0.7, 0),
                                  child: Text.rich(TextSpan(children: [
                                    const TextSpan(
                                        text: 'रु. ',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontFamily: 'Tiktok',
                                            color: Color(0xFF1FB141),
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                      text: itemPrice.toString(),
                                      // cartController.cartItem[index].price.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Tiktok',
                                        color: Color(0xFF1FB141),
                                      ),
                                    ),
                                    const WidgetSpan(
                                        child: SizedBox(
                                      width: 110,
                                    )),
                                    WidgetSpan(
                                        child: Text.rich(TextSpan(children: [
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () {
                                            //Increase the item quantity when "+" button is pressed
                                            increaseQuantity(index);
                                          },
                                          child: const CircleAvatar(
                                            backgroundColor: Color(0xFF990009),
                                            radius: 10,
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const WidgetSpan(
                                          child: SizedBox(
                                        width: 10,
                                      )),
                                      TextSpan(
                                        text: quantities.containsKey(index) ? quantities[index].toString() : '1',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Tiktok',
                                          fontWeight: FontWeight.bold,
                                          // color: Colors.white,
                                        ),
                                      ),
                                      const WidgetSpan(
                                          child: SizedBox(
                                        width: 10,
                                      )),
                                      WidgetSpan(
                                          child: GestureDetector(
                                        onTap: () {
                                          decreaseQuantity(index);
                                        },
                                        child: const CircleAvatar(
                                          backgroundColor: Color(0xFF990009),
                                          radius: 10,
                                          child: Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ))
                                    ])))
                                  ]))),
                            ],
                          ),
                        );
                      }),
                ]),
              ),
            ),
            DraggableScrollableSheet(
              snap: true,
              snapSizes: [0.36],
              snapAnimationDuration: const Duration(milliseconds: 100),
              initialChildSize: 0.04,
              minChildSize: 0.04,
              maxChildSize: 0.36,
              builder: (BuildContext context, ScrollController scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.drag_handle_rounded),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Sub Total: ',
                                      style:
                                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Tiktok')),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Discount: ',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Tiktok'),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Total: ',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Tiktok'),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text.rich(TextSpan(children: [
                                    TextSpan(
                                      text: 'रु. ',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Tiktok',
                                            // color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    TextSpan(
                                      text: totalPrice.toString(),
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Tiktok',
                                          // color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ])),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  Text(
                                    '10%',
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text.rich(TextSpan(children: [
                                    TextSpan(
                                        text: 'रु. ',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Tiktok',
                                              color: Color(0xFF1FB141),
                                              fontWeight: FontWeight.bold),
                                        )),
                                    TextSpan(
                                        text: total.toString(),
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Tiktok',
                                            color: Color(0xFF1FB141),
                                          ),
                                        )),
                                  ])),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            payWithKhaltiInApp();
                          },
                          style: ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(Colors.white),
                              elevation: const MaterialStatePropertyAll(5),
                              fixedSize: const MaterialStatePropertyAll(Size(300, 50)),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              )),
                          child: Wrap(direction: Axis.horizontal, alignment: WrapAlignment.center, children: [
                            Text(
                              softWrap: true,
                              'Pay  via',
                              style: GoogleFonts.poppins(
                                  fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF5C2D91)),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Image(
                              image: AssetImage(
                                'images/khalti.png',
                              ),
                              height: 30,
                            )
                          ]),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void increaseQuantity(index) {
    setState(() {
      quantities[index] = ((quantities[index] ?? 1) + 1);
    });
  }

  void decreaseQuantity(index) {
    setState(() {
      if (quantities[index] != null && quantities[index]! > 1) {
        quantities[index] = (quantities[index] ?? 0) - 1;
      } else {
        // Remove the item from the cart if quantity is less than or equal to 1
        cartController.removefromCart(cartController.cartItem[index]);
        quantities.remove(index); // Remove the quantity mapping
      }
    });
  }

  void payWithKhaltiInApp() {
    KhaltiScope.of(context).pay(
        config: PaymentConfig(
          amount: (total * 100).toInt(),
          productIdentity: "productIdentity",
          productName: "productName",
        ),
        onSuccess: onSuccess,
        onFailure: onFailure,
        preferences: [
          PaymentPreference.khalti,
          PaymentPreference.connectIPS,
          PaymentPreference.eBanking,
          PaymentPreference.mobileBanking,
        ],
        onCancel: onCancel);
  }

  void onSuccess(PaymentSuccessModel success) {
    cartController.clearCart();
    quantities.clear();
    setState(() {});
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Lottie.asset("images/success.json"),
          content: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              'Payment Successful',
              style: TextStyle(fontFamily: 'Tiktok', fontWeight: FontWeight.bold, fontSize: 14),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OK.',
                style: TextStyle(
                    fontFamily: 'Tiktok', fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1FB141)),
              ),
            )
          ]),
        );
      },
    );
  }

  void onFailure(PaymentFailureModel failure) {
    debugPrint(failure.toString());
  }

  void onCancel() {
    debugPrint('Canceled');
  }
}
