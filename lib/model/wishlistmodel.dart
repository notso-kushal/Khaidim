class WishList {
  final String title;
  final String rating;
  final int price;
  final String image;

  WishList(
      {required this.title,
      required this.price,
      required this.rating,
      required this.image});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WishList &&
        this.title == other.title &&
        this.price == other.price &&
        this.rating == other.rating &&
        this.image == other.image;
  }

  @override
  int get hashCode =>
      title.hashCode ^ price.hashCode ^ rating.hashCode ^ image.hashCode;
}
