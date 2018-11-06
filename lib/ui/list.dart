import 'package:flutter/material.dart';
import 'package:trixie/domain/Feed.dart';
import 'package:trixie/repository/FeedRepository.dart';
import 'package:trixie/ui/feed/listItem.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";
import "package:cached_network_image/cached_network_image.dart";

FeedRepository _feedRepository;

class ListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _feedRepository = FeedRepository();

    return Scaffold(
        appBar: AppBar(
          title: Text("Title"),
        ),
        body: FeedHome());
  }
}

class FeedHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeedHomeState();
  }
}

class _FeedHomeState extends State<FeedHome> {
  bool showButtons = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return showButtons ? new Stack(
      children: <Widget>[
        _buttonsView(context),
        Positioned(
          child: isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                  color: Colors.white.withOpacity(0.8),
                )
              : Container(),
        ),
      ],
    ) : new Container(child: FeedList());
  }

  Widget _buttonsView(BuildContext context) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FlatButton(
            child: const Text("INSERT ITEMS"),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              _insertItems(context);
            }),
        FlatButton(
            child: const Text("INSERT BATCH ITEMS"),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              _insertBatchItems(context);
            }),
        FlatButton(
            child: const Text("LIST ITEMS"),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              _listItems(context);
            }),
      ],
    ));
  }

  void _insertBatchItems(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final items = List<Feed>.generate(
        2000,
        (i) => new Feed(
            "Title $i",
            "$i Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam vitae viverra justo, nec ullamcorper risus. Vestibulum at urna eget odio sollicitudin aliquam.",
            "https://picsum.photos/600/200?queryId=$i"));

    await _feedRepository.clear();
    await _feedRepository.insertAll(items);

    setState(() {
      isLoading = false;
    });

    Scaffold.of(context).showSnackBar(SnackBar(
      content: const Text("Items inserted!"),
      backgroundColor: Colors.greenAccent,
    ));
  }

  void _insertItems(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final items = List<Feed>.generate(
        2000,
        (i) => new Feed(
            "Title $i",
            "$i Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam vitae viverra justo, nec ullamcorper risus. Vestibulum at urna eget odio sollicitudin aliquam.",
            "https://picsum.photos/600/200?queryId=$i"));

    await _feedRepository.clear();
    for (var item in items) {
      await _feedRepository.insert(item);
    }

    setState(() {
      isLoading = false;
    });

    Scaffold.of(context).showSnackBar(SnackBar(
      content: const Text("Items inserted!"),
      backgroundColor: Colors.greenAccent,
    ));
  }

  void _listItems(BuildContext context) async {
    setState(() {
      showButtons = false;
    });
  }
}

class FeedList extends StatefulWidget {

  @override
  FeedListState createState() => new FeedListState();
}

class FeedListState extends State<FeedList> {
  SmartRefresher _smartRefresher;

  List<Feed> feedItems = <Feed>[];

  @override
  void initState() {
    super.initState();
    _feedRepository.getAll().then((result) {
      setState(() { feedItems = result; });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onOffsetChange: _onOffsetCallback,
        child: ListView.builder(
            itemCount: feedItems.length,
            itemBuilder: (context, index) {
              final item = feedItems[index];

              if (index % 6 == 0) {
                return createCard(index, item.title, item.description, 1);
              } else {
                return createCard(index, item.title, item.description, 2);
              }
            }));

  }

  void _onRefresh(bool up) {
    //headerIndicator callback
    new Future.delayed(const Duration(milliseconds: 2000)).then((val) {
      _smartRefresher.controller.sendBack(up, RefreshStatus.completed);
    });
  }

  Widget createCard(int index, String body, String sender, int type) {
    return new Card(
      elevation: 3.0,
      margin: EdgeInsets.all(6.0),
      clipBehavior: Clip.antiAlias,
      child: Column(
          children: (type == 1)
              ? createType1(index, body)
              : createType2(index, body, sender)),
    );
  }

  List<Widget> createType1(int index, String body) {
    var url = "https://picsum.photos/600/200?queryId=$index";
    var _controller = TextEditingController();
    return <Widget>[
      _imageViewTitle(url, body, ""),
      TextField(
        controller: _controller,
        maxLines: 1,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.send,
        style: TextStyle(fontSize: 14.0, color: Colors.black),
        onSubmitted: (value) {
          postComment(index, value);
        },
        decoration: InputDecoration(
            filled: true,
            hintText: "Comment here...",
            border: UnderlineInputBorder(),
            prefixIcon: Icon(Icons.comment),
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                postComment(index, _controller.text);
                _controller.clear();
              },
            ),
            hintStyle: TextStyle(height: 1.3)),
      ),
    ];
  }

  void postComment(int id, String comment) {
    print(comment);
    // FocusScope.of(context).requestFocus(new FocusNode());
    // Scaffold.of(context).showSnackBar(SnackBar(
    //   content: const Text("Sending comment"),
    //   action: SnackBarAction(label: "UNDO", onPressed: () {}),
    // ));
  }

  List<Widget> createType2(int index, String body, String sender) {
    var url = "https://picsum.photos/600/200?queryId=$index";

    return <Widget>[
      _imageViewTitle(url, body, sender),
      ButtonTheme.bar(
        child: ButtonBar(children: _bottomButtons()),
      ),
    ];
  }

  Widget _imageViewTitle(String url, String title, String body) {
    return Column(
      children: <Widget>[
        Stack(children: <Widget>[
          new CachedNetworkImage(
              imageUrl: url,
              placeholder: CircularProgressIndicator(),
              errorWidget: new Icon(Icons.error),
              fadeOutDuration: new Duration(milliseconds: 300),
              fadeInDuration: new Duration(milliseconds: 300)),
          Positioned(
              bottom: 2.0,
              left: 6.0,
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    decorationStyle: TextDecorationStyle.wavy),
              ))
        ]),
        Container(
            margin: EdgeInsets.all(6.0),
            child: Text(body, maxLines: 3, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  List<Widget> _bottomButtons() {
    return <Widget>[
      FlatButton(child: const Text('BUY TICKETS'), onPressed: () {}),
      FlatButton(child: const Text('LISTEN'), onPressed: () {})
    ];
  }

  void _onOffsetCallback(bool up, double offset) {}
}
