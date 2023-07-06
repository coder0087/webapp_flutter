import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:wordpress1/uiView/post.dart';
import 'package:wordpress1/api-response.dart';
import 'package:html/parser.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../api-autoCategory.dart';
// import '../api-response-noti.dart';
import '../exit-popup.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'categoryHome.dart';
import 'home-ch.dart';
import 'home-eng.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:wordpress1/globals.dart' as globals;
import 'noti-page.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // String removeAllHtmlTags(String htmlText) {
  //   RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  //
  //   return htmlText.replaceAll(exp, '');
  // }

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  late String href_url;
  String? hh;
  late Future<List> fetchAlbum;
  late Future connectionCheck;
  static final String oneSignalAppId = "06da8f70-8043-4c41-bf11-eaf67897f090";

  Future checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isEmpty && result[0].rawAddress.isEmpty) {
        setState(() {fetchAlbum = fetchWpPosts();});

      } else {
        setState(() {APICacheManager().deleteCache("Home_API");
        fetchAlbum = fetchWpPosts();});

      }
    } on SocketException catch (_) {
      setState(() {fetchAlbum = fetchWpPosts();});

      // connectionCheck = checkConnection();
    }
  }

  Future<void> initPlatformState() async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId(
      oneSignalAppId,
    );
    OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {});
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
            (OSNotificationReceivedEvent event) {
          /// Display Notification, send null to not display, send notification to display
          event.complete(event.notification);
          // event.notification.smallIcon;
        });
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // a notification has been opened
      var data = result.notification.additionalData;

      globals.appNavigator.currentState?.push(MaterialPageRoute(
        builder: (context) => SecondPage(
          postId: data!["post_id"],
        ),
      ));
    });
  }

  // Future<void> hhhh() async {
  //   var result = await FlutterNotificationChannel.registerNotificationChannel(
  //     description: 'News',
  //     id: '182d53d8-71e4-4a56-928d-b908a1a87c40',
  //     importance: NotificationImportance.IMPORTANCE_HIGH,
  //     name: 'Miscellaneous',
  //     // visibility: OSNotification(json),
  //     allowBubbles: true,
  //     enableVibration: true,
  //     enableSound: true,
  //     showBadge: true,
  //   );
  //   print(result);
  // }



  @override
  void initState() {
    super.initState();
    fetchAlbum = fetchWpPosts();
    connectionCheck = checkConnection();
    initPlatformState();
    // hhhh();

    // FirebaseMessaging.instance.getInitialMessage();
    //
    // FirebaseMessaging.onMessage.listen((message) {
    //   if(message.notification != null){
    //     print(message.notification!.body);
    //     print(message.notification!.title);
    //   }
    // });
    //
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   final routeFromMessage = message.data["route"];
    //   print(routeFromMessage);
    // });

  }

  List<Map<String, dynamic>> _categories = [
    {
      'name': 'Daily News',
      'icon': Icons.wb_sunny,
    },
    {
      'name': 'English Version',
      'icon': Icons.language,
    },
    {
      'name': 'Uncategorized',
      'icon': Icons.map,
    },
    {
      'name': 'ကျန်းမာရေး',
      'icon': Icons.health_and_safety,
    },
    {
      'name': 'စီးပွားရေး',
      'icon': Icons.business_center,
    },
    {
      'name': 'ဆောင်းပါး',
      'icon': Icons.article,
    },
    {
      'name': 'နိုင်ငံတကာသတင်း',
      'icon': Icons.public,
    },
    {
      'name': 'နိုင်ငံရေး',
      'icon': Icons.policy,
    },
    {
      'name': 'ပြည်တွင်းသတင်း',
      'icon': Icons.newspaper,
    },
    {
      'name': 'ဖျော်ဖြေရေး',
      'icon': Icons.beach_access,
    },
  ];
  @override
  Widget build(BuildContext context) {
    // var futureBuilder = FutureBuilder(
    //     future: fetchWpPosts(),
    //     builder: (BuildContext context, AsyncSnapshot snapshot) {
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.none:
    //         case ConnectionState.waiting:
    //           return Center(child: Text('loading...'));
    //         default:
    //           if (snapshot.hasError)
    //             return new Text('Error: ${snapshot.error}');
    //           else {
    //             return ListView.builder(
    //               // physics: const AlwaysScrollableScrollPhysics(),
    //               itemCount: snapshot.data.length,
    //               itemBuilder: (context, int index) {
    //                 Map wwpost = snapshot.data[index];
    //
    //                 try {
    //                   hh = wwpost['_embedded']['wp:featuredmedia'][0]
    //                       ['source_url'];
    //                   if (kDebugMode) {
    //                     print("print $hh");
    //                   }
    //                   if (hh != null) {
    //                     href_url = hh!;
    //                   } else if (hh == null) {
    //                     href_url =
    //                         "https://www.mtnewstoday.com/wp-content/uploads/2022/09/deafult_image.jpg";
    //                     // href_url = "https://drive.google.com/file/d/19NXftN2Q9E18CwDYmKjt4SC1fwG3WYQ6/view?usp=sharing";
    //                     // "https://scontent.fmdl4-4.fna.fbcdn.net/v/t39.30808-6/304810951_116450397845877_5765285709452256322_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=e3f864&_nc_ohc=JMtP4lB3ZzkAX8se9Sq&_nc_ht=scontent.fmdl4-4.fna&oh=00_AT9jBaFhy5HlAhcw5KJmJo3N2ONOv7KwbixN8_bpREBwbQ&oe=631EF287";
    //                     // href_url = "https://www.mtnewstoday.com/en/wp-content/uploads/2022/09/300598950_116839547806962_4121818743033315343_n-1.jpg";
    //                   }
    //                 } catch (hh) {
    //                   href_url =
    //                       "https://www.mtnewstoday.com/wp-content/uploads/2022/09/deafult_image.jpg";
    //                 }
    //                 return RefreshIndicator(
    //                   color: Colors.white,
    //                   backgroundColor: Colors.green,
    //                   onRefresh: () {
    //                     setState(() {});
    //                     // APICacheManager().deleteCache("Home_API");
    //                     // return fetchWpPosts();
    //                     connectionCheck = checkConnection();
    //                     return Future<void>.delayed(const Duration(seconds: 5));
    //                   },
    //                   // notificationPredicate: (ScrollNotification notification) {
    //                   //   return notification.depth == 1;
    //                   // },
    //                   child: Card(
    //                     child: Padding(
    //                         padding: const EdgeInsets.all(8.0),
    //                         child: Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: <Widget>[
    //                             // Image.network(imageurl),
    //                             PostTile(
    //                               // href: wwpost['_links']['wp:featuredmedia'][0]
    //                               // ['href'],
    //                               href: href_url,
    //                               title: wwpost['title']['rendered']
    //                                   .replaceAll("&#8217;", "'"),
    //                               desc: (parse((wwpost['excerpt']['rendered'])
    //                                       .toString())
    //                                   .documentElement
    //                                   ?.text),
    //                               content: wwpost['content']['rendered'],
    //                               // content: removeAllHtmlTags(wwpost['content']
    //                               //         ['rendered']
    //                               //     .replaceAll("#8217;", "")),
    //                             )
    //                           ],
    //                         )),
    //                   ),
    //                 );
    //               },
    //             );
    //           }
    //       }
    //       return Center(child: CircularProgressIndicator());
    //     });
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          shadowColor: Colors.transparent,
          title: const Text(
            'MYANMAR TRANSPARENCY NEWS',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            PopUpMen(
              menuList: [
                PopupMenuItem(
                  textStyle: const TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                  onTap: () => Future(
                    () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => HomeEng())),
                  ),
                  child: const Text("English Version"),
                ),
                PopupMenuItem(
                  textStyle: const TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                  onTap: () => Future(
                    () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => HomeCh())),
                  ),
                  child: const Text("Chinese Version"),
                ),
              ],
              icon: Icon(
                Icons.search_rounded,
                color: Colors.white,
              ),
            ),
          ],
        ),
        drawer: Drawer(
          width: 250.0,
          child: FutureBuilder(
            future: fetchCategoryTitles(),
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
                                          builder: (context) => BusinessHome(
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
        // body: futureBuilder,
        body: RefreshIndicator(
          color: Colors.white,
          backgroundColor: Colors.green,
          onRefresh: () {
            setState(() {connectionCheck = checkConnection();});
            // APICacheManager().deleteCache("Home_API");
            // return fetchWpPosts();

            return Future<void>.delayed(const Duration(seconds: 3));
          },
          // notificationPredicate: (ScrollNotification notification) {
          //   return notification.depth == 1;
          // },
          child: FutureBuilder(
              future: fetchWpPosts(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: const CircularProgressIndicator());
                    // return Center(child: Text('loading...'));
                  default:
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return ListView.builder(
                        // physics: const AlwaysScrollableScrollPhysics(),
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
                                    PostTile(
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
                }
                return Center(child: CircularProgressIndicator());
              }),
        ),
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

class PostTile extends StatefulWidget {
  final String? href, title, desc, content;
  PostTile({this.content, this.desc, this.href, this.title});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
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
              child:
              // Image.network(widget.href!,)
            CachedNetworkImage(
                imageUrl: widget.href!,
                // imageBuilder: (context, imageProvider) => Container(
                //   decoration: BoxDecoration(
                //     image: DecorationImage(
                //         image: NetworkImage(widget.href!),
                //         fit: BoxFit.fitWidth,
                //         colorFilter:
                //         ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
                //   ),
                // ),
                // height: 200,
                // width: 450,
                fit: BoxFit.fill,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                // errorWidget: (context, url, error) => const Center(child: Text('Check Internet Connection')),
                errorWidget: (context, url, error) =>
                    Image.asset('images/deafult_image.jpg'),
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
