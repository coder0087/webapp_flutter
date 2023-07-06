import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';

import '../api-response-noti.dart';

class SecondPage extends StatefulWidget {
  final int postId;
  const SecondPage({Key? key, required this.postId}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  late String href_url;
  String? hh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[400],
        title: const Text(
          'MYANMAR TRANSPARENCY NEWS',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: FutureBuilder(
          future: fetchAPINoti(widget.postId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return const Center(
                      child: Text(
                        'Check Your Connection!',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ));
                  // return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  // if (kDebugMode) {
                  //   print("Snap ${snapshot.data}");
                  //   print("Shot ${snapshot.data[0]}");
                  //   print("Data ${snapshot.data['_embedded']['wp:featuredmedia'][0]}");
                  // }
                  try {
                    hh = snapshot.data['_embedded']['wp:featuredmedia'][0]
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
                  return SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image.network(widget.imageUrl!),
                          CachedNetworkImage(
                            imageUrl: href_url,
                            height: 200,
                            width: 450,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            // errorWidget: (context, url, error) => const Center(child: Text('Check Internet Connection')),
                            errorWidget: (context, url, error) =>
                                Image.asset('images/deafult_image.jpg'),
                            // const Icon(Icons.network_check),
                          ),
                          SizedBox(height: 8),
                          Text(
                            snapshot.data['title']['rendered']
                                .replaceAll("&#8217;", "'"),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          // Text(widget.content!),
                          Html(data: snapshot.data['content']['rendered']),
                        ],
                      ),
                    ),
                  );
                }
                return CircularProgressIndicator();
            }
          }),
    );
  }
}
