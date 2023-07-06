import 'package:flutter/material.dart';
import 'package:wordpress1/uiView/home-eng.dart';
import 'package:wordpress1/uiView/post.dart';
import 'package:html/parser.dart';
import '../api-autoCategory-ch.dart';
import '../api-autoCategory-eng.dart';
import '../api-response-ch.dart';
import '../api-response-eng.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'categoryHome-Ch.dart';
import 'categoryHome-Eng.dart';
import 'home.dart';
import 'dart:io';
import 'package:api_cache_manager/api_cache_manager.dart';

class HomeCh extends StatefulWidget {
  @override
  State<HomeCh> createState() => _HomeChState();
}

class _HomeChState extends State<HomeCh> {
  // String removeAllHtmlTags(String htmlText) {
  //   RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  //
  //   return htmlText.replaceAll(exp, '');
  // }
  late String href_url;
  String? hh;
  late Future<List> fetchAlbum;
  late Future connectionCheck;

  Future checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isEmpty && result[0].rawAddress.isEmpty) {
        setState(() {fetchAlbum = fetchWpPostsCh();});

      } else {
        setState(() {APICacheManager().deleteCache("Home_API_Ch");
        fetchAlbum = fetchWpPostsCh();});

      }
    } on SocketException catch (_) {
      setState(() {fetchAlbum = fetchWpPostsCh();});

      // connectionCheck = checkConnection();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAlbum = fetchWpPostsCh();
    connectionCheck = checkConnection();
  }

  List<Map<String, dynamic>> _categories = [
    {
      'name': 'Articles',
      'icon': Icons.article,
    },
    {
      'name': 'Daily News',
      'icon': Icons.wb_sunny,
    },
    {
      'name': 'Economic',
      'icon': Icons.business_center,
    },
    {
      'name': 'English Version',
      'icon': Icons.language,
    },
    {
      'name': 'Entertainment',
      'icon': Icons.beach_access,
    },
    {
      'name': 'Health',
      'icon': Icons.health_and_safety,
    },
    {
      'name': 'International News',
      'icon': Icons.public,
    },
    {
      'name': 'Interview',
      'icon': Icons.mic_external_on,
    },
    {
      'name': 'Local News',
      'icon': Icons.newspaper,
    },
    {
      'name': 'Politics',
      'icon': Icons.policy,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[400],
        title: Text(
          'MYANMAR TRANSPARENCY NEWS',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions:  [
          PopUpMen(
            menuList: [
              PopupMenuItem(
                textStyle: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                onTap: () => Future(
                      () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => Home())
                  ),
                ),
                child: const Text("Myanmar Version"),
              ),
              PopupMenuItem(
                textStyle: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                onTap: () => Future(
                      () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => HomeEng())
                  ),
                ),
                child: const Text("English Version"),
              ),
            ],
            icon: Icon(
              Icons.language,
              color: Colors.white,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        width: 250.0,
        child: FutureBuilder(
          future: fetchCategoryTitlesCh(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else {
              return ListView(
                  children: List.generate(
                snapshot.data.length,
                (index) {
                  Map wwCategory = snapshot.data[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.only(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                wwCategory['name'],
                                style: const TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              trailing: Icon(
                                Icons.arrow_right_outlined,
                                color: Colors.blue,
                              ),
                              leading: Icon(
                                _categories[index]['icon'],
                                // Icons.slideshow,
                                color: Colors.green,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CategoryHomeCh(
                                            id: wwCategory['id'],
                                            titleCategory:
                                                wwCategory['name'])));
                              },
                            ),
                          ]),
                    ),
                  );
                },
              ));
            }
          },
        ),
      ),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.green,
        onRefresh: () {
          setState(() {connectionCheck = checkConnection();});
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        child: FutureBuilder(
            future: fetchWpPostsCh(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  {
                    return Center(child: CircularProgressIndicator());
                  }
                default:
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, int index) {
                        Map wwpost = snapshot.data[index];
                        try {
                          hh = wwpost['_embedded']['wp:featuredmedia'][0]
                          ['source_url'];
                          // if (kDebugMode) {
                          //   print("print $hh");
                          // }
                          if (hh != null) {
                            href_url = hh!;
                          } else if (hh == null) {
                            href_url =
                            "https://www.mtnewstoday.com/wp-content/uploads/2022/09/deafult_image.jpg";
                            // href_url = "https://drive.google.com/file/d/19NXftN2Q9E18CwDYmKjt4SC1fwG3WYQ6/view?usp=sharing";
                            // "https://scontent.fmdl4-4.fna.fbcdn.net/v/t39.30808-6/304810951_116450397845877_5765285709452256322_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=e3f864&_nc_ohc=JMtP4lB3ZzkAX8se9Sq&_nc_ht=scontent.fmdl4-4.fna&oh=00_AT9jBaFhy5HlAhcw5KJmJo3N2ONOv7KwbixN8_bpREBwbQ&oe=631EF287";
                            // href_url = "https://www.mtnewstoday.com/en/wp-content/uploads/2022/09/300598950_116839547806962_4121818743033315343_n-1.jpg";
                          }
                        } catch (hh) {
                          href_url =
                          "https://www.mtnewstoday.com/wp-content/uploads/2022/09/deafult_image.jpg";
                        }
                        return Card(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  // Image.network(imageurl),
                                  PostTileEng(
                                    // href: wwpost['_links']['wp:featuredmedia'][0]
                                    // ['href'],
                                    href: href_url,
                                    title: wwpost['title']['rendered']
                                        .replaceAll("&#8217;", "'"),
                                    desc: (parse((wwpost['excerpt']['rendered'])
                                            .toString())
                                        .documentElement
                                        ?.text),
                                    content: wwpost['content']['rendered'],
                                    // content: removeAllHtmlTags(wwpost['content']
                                    //         ['rendered']
                                    //     .replaceAll("#8217;", "")),
                                  )
                                ],
                              )),
                        );
                      },
                    );
                  }
                  return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}

class PopUpMen extends StatelessWidget {
  final List<PopupMenuEntry> menuList;
  final Widget? icon;
  const PopUpMen({Key? key, required this.menuList, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      itemBuilder: ((context) => menuList),
      icon: icon,
    );
  }
}

class PostTileEng extends StatefulWidget {
  final String? href, title, desc, content;
  PostTileEng({this.content, this.desc, this.href, this.title});

  @override
  State<PostTileEng> createState() => _PostTileEngState();
}

class _PostTileEngState extends State<PostTileEng> {
  var imageUrl = "";
  // Widget shortDescriptionView(){
  //   return Html(data: widget.desc);
  // }

  @override
  Widget build(BuildContext context) {
    // return GestureDetector(
    //   onTap: (){
    // Navigator.push(context, MaterialPageRoute(
    //   builder: (context) => Post(
    //     imageurl: imageurl,
    //     title: widget.title,
    //     content: widget.content,
    //   )));
    // },
    //   return Container(
    //     padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         FutureBuilder(
    //           future: fetchWpPostImageUrl(widget.href),
    //           builder: (BuildContext context, AsyncSnapshot snapshot) {
    //             switch (snapshot.connectionState) {
    //               case ConnectionState.waiting:
    //                 return Center(child: CircularProgressIndicator());
    //               default:
    //                 if (!snapshot.hasData)
    //                   return Center(child: CircularProgressIndicator());
    //                 else if (snapshot.hasData) {
    //                   imageurl = snapshot.data['guid']['rendered'];
    //                   return Image.network(snapshot.data['guid']['rendered']);
    //                 }
    //                 return CircularProgressIndicator();
    //             }
    //           },
    //         ),
    //         SizedBox(height: 8),
    //         Text(
    //           widget.title!,
    //           style: TextStyle(
    //             fontSize: 18,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //         SizedBox(height: 4),
    //         Text(
    //           widget.desc!,
    //           style: TextStyle(
    //             fontSize: 12,
    //           ),
    //         ),
    //       ],
    //     ),
    // );
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CachedNetworkImage(
                imageUrl: widget.href!,
                // height: 200,
                // width: 450,
                fit: BoxFit.fill,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                // errorWidget: (context, url, error) => const Center(child: Text('Check Internet Connection')),
                errorWidget: (context, url, error) => Image.asset('images/deafult_image.jpg'),
                    // const Icon(Icons.network_check),
              ),
            ),
            // FutureBuilder(
            //   future: fetchWpPostImageUrl(widget.href),
            //   builder: (BuildContext context, AsyncSnapshot snapshot) {
            //     if (snapshot.hasData) {
            //       imageUrl = snapshot.data['guid']['rendered'];
            //       return CachedNetworkImage(imageUrl: imageUrl);
            //       // return Image.network(imageUrl);
            //     }
            //       return const Center(child: CircularProgressIndicator());
            //   },
            // ),
            SizedBox(height: 8),
            Text(
              widget.title!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              widget.desc!,
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Post(
                      // imageUrl: imageUrl,
                      imageUrl: widget.href!,
                      title: widget.title!,
                      content: widget.content!,
                    )));
      },
    );
  }
}
