import 'package:trixie/domain/DomainBase.dart';

class Feed extends DomainBase {
  String title;
  String description;
  String image;

  Feed(this.title, this.description, this.image);
  Feed.empty();

  @override
  Map toMap() {
    var map = <String, dynamic>{
      "title": title,
      "description": description,
      "image": image
    };

    if (id != null) map["id"] = id;

    return map;
  }
}
