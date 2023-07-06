import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Future<List> fetchWpPosts() async {
  var numPage = 1;
  var perPage = 50;
  var convertDatatoJson;


  var isCacheExit = await APICacheManager().isAPICacheKeyExist("Home_API");
  if (!isCacheExit) {
    //var url = 'https://mtnewstoday.com/wp-json/wp/v2/posts?_embed&page=$numPage&per_page=$perPage';
    var url = 'https://mmdbnchannel.com/wp-json/wp/v2/posts?_embed&page=$numPage&per_page=$perPage';
    // var url =
    //     'https://click4pdf.org/wp-json/wp/v2/posts?_embed&page=$numPage&per_page=$perPage';
    // 'https://click4pdf.org/wp-json/wp/v2/posts?per_page=100'; // https://click4pdf.org/wp-json/wp/v2/posts?_embed&per_page=100

    var response = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    // var response = await http.get(Uri.parse(url), headers: {
    //   'Content-Type': 'application/json',
    //   'Authorization':
    //       'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsIm5hbWUiOiJhZG1pbiIsImlhdCI6MTY1OTE4OTkwOCwiZXhwIjoxODE2ODY5OTA4fQ.g2i7XtFysCXVy-64WNAYiePahKO5WwowjA2oiQiECTg'
    // });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // return Album.fromJson(jsonDecode(response.body));
      convertDatatoJson = jsonDecode(response.body);
      var gg = response.body;
      // if (kDebugMode) {
      //   print("URL hit");
      // }
      APICacheDBModel cacheDBModel = APICacheDBModel(
        key: "Home_API",
        syncData: gg,
      );
      await APICacheManager().addCacheData(cacheDBModel);
      var jJ = response.headers;
      String? aA = jJ['x-wp-totalpages'];
      int totalPage = int.parse(aA!);
      for (numPage = 2; numPage <= totalPage; numPage++) {
        var url = 'https://mtnewstoday.com/wp-json/wp/v2/posts?_embed&page=$numPage&per_page=$perPage';
        var response = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
        // var url =
        //     'https://click4pdf.org/wp-json/wp/v2/posts?_embed&page=$numPage&per_page=$perPage';
        // var response = await http.get(Uri.parse(url), headers: {
        //   'Content-Type': 'application/json',
        //   'Authorization':
        //       'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsIm5hbWUiOiJhZG1pbiIsImlhdCI6MTY1OTE4OTkwOCwiZXhwIjoxODE2ODY5OTA4fQ.g2i7XtFysCXVy-64WNAYiePahKO5WwowjA2oiQiECTg'
        // });
        convertDatatoJson += jsonDecode(response.body);
        // ff = "$ff,${response.body}";
      }
      // this.items = [];
      // setState((){
      //    convertDatatoJson;
      //   // for(var i=0; i<convertDatatoJson.length; i++){
      //   //   this.items.add(convertDatatoJson[i]['_embedded']['wp:featuredmedia'][0]['source_url']);
      //   // }
      // });
      return convertDatatoJson;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  } else {
    var cacheData = await APICacheManager().getCacheData("Home_API");
    // if (kDebugMode) {
    //   print("Cache hit");
    // }
    return json.decode(cacheData.syncData); //}
  }
}
// Future<List> fetchWpPosts() async {
//   var numPage = 1;
//   var perPage = 100;
//   var convertDatatoJson;
//   var isCacheExit = await APICacheManager().isAPICacheKeyExist("Home_API");
//
//   if (!isCacheExit) {
//     // var url = 'https://mtnewstoday.com/wp-json/wp/v2/posts?_embed&page=$numPage&per_page=$perPage';
//     var url =
//         'https://click4pdf.org/wp-json/wp/v2/posts?_embed&page=$numPage&per_page=$perPage';
//     // 'https://click4pdf.org/wp-json/wp/v2/posts?per_page=100'; // https://click4pdf.org/wp-json/wp/v2/posts?_embed&per_page=100
//     // var response = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
//     var response = await http.get(Uri.parse(url), headers: {
//       'Content-Type': 'application/json',
//       'Authorization':
//           'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsIm5hbWUiOiJhZG1pbiIsImlhdCI6MTY1OTE4OTkwOCwiZXhwIjoxODE2ODY5OTA4fQ.g2i7XtFysCXVy-64WNAYiePahKO5WwowjA2oiQiECTg'
//     });
//     convertDatatoJson = jsonDecode(response.body);
//     var gg = response.body;
//     // var ff='';
//     if (kDebugMode) {
//       print("URL hit");
//     }
//     var jJ = response.headers;
//     String? aA = jJ['x-wp-totalpages'];
//     int totalPage = int.parse(aA!);
//     // int toTo = totalPost~/perPage;
//     // int totalLoop= toTo+1;
//     // if (kDebugMode) {
//     //   print("GO => $totalPage");
//     //   print(totalPage.runtimeType);
//     // }
//     APICacheDBModel cacheDBModel = APICacheDBModel(
//       key: "Home_API",
//       syncData: gg,
//     );
//     await APICacheManager().addCacheData(cacheDBModel);
//     for (numPage = 2; numPage <= totalPage; numPage++) {
//       // var url = 'https://mtnewstoday.com/wp-json/wp/v2/posts?_embed&page=$numPage&per_page=$perPage';
//       // var response = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
//       var url =
//           'https://click4pdf.org/wp-json/wp/v2/posts?_embed&page=$numPage&per_page=$perPage';
//       var response = await http.get(Uri.parse(url), headers: {
//         'Content-Type': 'application/json',
//         'Authorization':
//             'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsIm5hbWUiOiJhZG1pbiIsImlhdCI6MTY1OTE4OTkwOCwiZXhwIjoxODE2ODY5OTA4fQ.g2i7XtFysCXVy-64WNAYiePahKO5WwowjA2oiQiECTg'
//       });
//       convertDatatoJson += jsonDecode(response.body);
//       // ff = "$ff,${response.body}";
//     }
//
//     return convertDatatoJson;
//   } else {
//     var cacheData = await APICacheManager().getCacheData("Home_API");
//     if (kDebugMode) {
//       print("Cache hit");
//     }
//     return json.decode(cacheData.syncData); //}
//   }
// }

// Future<List> fetchWpPosts() async {
//   var numPage = 1;
//   var perPage = 100;
//   var convertDatatoJson;
//   // var url = 'https://mtnewstoday.com/wp-json/wp/v2/posts?_embed&page=$numPage&per_page=$perPage';
//   var url =
//       'https://click4pdf.org/wp-json/wp/v2/posts?_embed&page=$numPage&per_page=$perPage';
//   // 'https://click4pdf.org/wp-json/wp/v2/posts?per_page=100'; // https://click4pdf.org/wp-json/wp/v2/posts?_embed&per_page=100
//
//   // var response = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
//   var response = await http.get(Uri.parse(url), headers: {
//     'Content-Type': 'application/json',
//     'Authorization':
//         'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsIm5hbWUiOiJhZG1pbiIsImlhdCI6MTY1OTE4OTkwOCwiZXhwIjoxODE2ODY5OTA4fQ.g2i7XtFysCXVy-64WNAYiePahKO5WwowjA2oiQiECTg'
//   });
//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     // return Album.fromJson(jsonDecode(response.body));
//     convertDatatoJson = jsonDecode(response.body);
//     var jJ = response.headers;
//     if (kDebugMode) {
//       print(jJ);
//     }
//     String? aA = jJ['x-wp-totalpages'];
//     int totalPage = int.parse(aA!);
//     for (numPage = 2; numPage <= totalPage; numPage++) {
//       // var url = 'https://mtnewstoday.com/wp-json/wp/v2/posts?_embed&page=$numPage&per_page=$perPage';
//       // var response = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
//       var url =
//           'https://click4pdf.org/wp-json/wp/v2/posts?_embed&page=$numPage&per_page=$perPage';
//       var response = await http.get(Uri.parse(url), headers: {
//         'Content-Type': 'application/json',
//         'Authorization':
//         'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsIm5hbWUiOiJhZG1pbiIsImlhdCI6MTY1OTE4OTkwOCwiZXhwIjoxODE2ODY5OTA4fQ.g2i7XtFysCXVy-64WNAYiePahKO5WwowjA2oiQiECTg'
//       });
//       convertDatatoJson += jsonDecode(response.body);
//       // ff = "$ff,${response.body}";
//     }
//     return convertDatatoJson;
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load');
//   }
//
// }

// class Album {
//   final String href;
//   final String title;
//   final String desc;
//   final String content;
//
//   const Album({
//     required this.href,
//     required this.title,
//     required this.desc,
//     required this.content,
//   });
//
//   factory Album.fromJson(Map<String, dynamic> json) {
//     if (json['_embedded']['wp:featuredmedia'][0]['source_url'] != null) {
//       return Album(
//         href: json['_embedded']['wp:featuredmedia'][0]['source_url'],
//         title: json['title']['rendered'],
//         desc: json['excerpt']['rendered'],
//         content: json['content']['rendered'],
//       );
//     } else {
//       throw Exception();
//     }
//   }
// }

Future fetchWpPostImageUrl(href) async {
  final response =
      await http.get(Uri.parse(href), headers: {"Accept": "application/json"});
  return jsonDecode(response.body);
}
