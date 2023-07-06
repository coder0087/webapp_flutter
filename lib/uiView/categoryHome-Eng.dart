import 'dart:io';

import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:wordpress1/uiView/post.dart';
import '../api-Category-eng.dart';
import '../api-Category.dart';
import 'package:cached_network_image/cached_network_image.dart';



class CategoryHomeEng extends StatefulWidget {
  final String? titleCategory;
  final int? id;
  CategoryHomeEng({this.id,this.titleCategory});
  @override
  State<CategoryHomeEng> createState() => _CategoryHomeEngState();
}

class _CategoryHomeEngState extends State<CategoryHomeEng> {
  late String href_url;
  String? hh;
  late Future<List> fetchAlbum;
  late Future connectionCheck;
  Future checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isEmpty && result[0].rawAddress.isEmpty) {
        setState(() {fetchAlbum = fetchWpPostsBusinessEng(widget.id!);});

      } else {
        setState(() {APICacheManager().deleteCache("allCategory_API_Eng${widget.id!}");
        fetchAlbum = fetchWpPostsBusinessEng(widget.id!);});

      }
    } on SocketException catch (_) {
      setState(() {fetchAlbum = fetchWpPostsBusinessEng(widget.id!);});

      // connectionCheck = checkConnection();
    }
  }
  @override
  void initState() {
    super.initState();
    fetchAlbum = fetchWpPostsBusinessEng(widget.id!);
    connectionCheck = checkConnection();
  }
  @override
  Widget build(BuildContext context) {
    String categoryTitle = widget.titleCategory!;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent[400],
          title: Text(
            '$categoryTitle',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
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
              future: fetchWpPostsBusinessEng(widget.id!),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
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
                                    //Image.network(imageurl),
                                    PostTailBusiness(
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
        )
    );
  }
}

class PostTailBusiness extends StatefulWidget {
  const PostTailBusiness({Key? key, this.href, this.title, this.desc, this.content}) : super(key: key);
  final String? href, title, desc, content;
  @override
  State<PostTailBusiness> createState() => _PostTailBusinessState();
}

class _PostTailBusinessState extends State<PostTailBusiness> {
  var imageUrl = "";
  @override
  Widget build(BuildContext context) {
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
            //   future: fetchWpPostsBusinessImageUrl(widget.href),
            //   builder: (BuildContext context, AsyncSnapshot snapshot) {
            //     if (snapshot.hasData) {
            //       imageUrl = snapshot.data['guid']['rendered'];
            //       return Image.network(snapshot.data['guid']['rendered']);
            //     }
            //     return Center(child: CircularProgressIndicator());
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
            context, MaterialPageRoute(builder: (context) => Post(
          // imageUrl: imageUrl,
          imageUrl: widget.href!,
          title: widget.title!,
          content: widget.content!,
        )));
      },
    );
  }
}


