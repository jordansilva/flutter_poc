import 'package:trixie/domain/Feed.dart';
import 'package:trixie/repository/DBHelper.dart';

class FeedRepository extends DBHelper<Feed> {

  FeedRepository() : super("feed");

  @override
  Feed fromMap(Map map) {
    var feed = new Feed.empty();
    feed.id = map["id"];
    feed.title = map["title"];
    feed.description = map["description"];
    feed.image = map["image"];
    
    return feed;
  }

}