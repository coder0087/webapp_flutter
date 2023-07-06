import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Future<List> fetchWpPostsCh() async {
  var numPage = 1;
  var perPage = 50;
  var convertDatatoJson;
  var isCacheExit = await APICacheManager().isAPICacheKeyExist("Home_API_Ch");

  if (!isCacheExit) {
    var url = 'https://mtnewstoday.com/ch/wp-json/wp/v2/posts?_embed&page=$numPage&per_page=$perPage';
        // 'https://click4pdf.org/wp-json/wp/v2/posts?_embed&page=$numPage&per_page=$perPage';
    //'https://click4pdf.org/wp-json/wp/v2/posts?per_page=100'; // https://click4pdf.org/wp-json/wp/v2/posts?_embed&per_page=100
    var response = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});

        // await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json',
        //   'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsIm5hbWUiOiJhZG1pbiIsImlhdCI6MTY1OTE4OTkwOCwiZXhwIjoxODE2ODY5OTA4fQ.g2i7XtFysCXVy-64WNAYiePahKO5WwowjA2oiQiECTg'});
    convertDatatoJson = jsonDecode(response.body);
    var gg = response.body;
    // var ff='';
    // if (kDebugMode) {
    //   print("URL hit");
    // }
    var jJ = response.headers;
    String? aA = jJ['x-wp-totalpages'];
    int totalPage = int.parse(aA!);
    // int toTo = totalPost~/perPage;
    // int totalLoop= toTo+1;
    // if (kDebugMode) {
    //   print("GO => $totalPage");
    //   print(totalPage.runtimeType);
    // }
    APICacheDBModel cacheDBModel = APICacheDBModel(
      key: "Home_API_Ch",
      syncData: gg,
    );
    await APICacheManager().addCacheData(cacheDBModel);
    for (numPage = 2; numPage <= totalPage; numPage++) {
      var url = 'https://mtnewstoday.com/ch/wp-json/wp/v2/posts?_embed&page=$numPage&per_page=$perPage';
      var response = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
      // var url =
      //     'https://click4pdf.org/wp-json/wp/v2/posts?_embed&page=$numPage&per_page=$perPage';
      // var response = await http
      //     .get(Uri.parse(url), headers: {'Content-Type': 'application/json',
      //   'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsIm5hbWUiOiJhZG1pbiIsImlhdCI6MTY1OTE4OTkwOCwiZXhwIjoxODE2ODY5OTA4fQ.g2i7XtFysCXVy-64WNAYiePahKO5WwowjA2oiQiECTg'});
      convertDatatoJson += jsonDecode(response.body);
      // ff = "$ff,${response.body}";
    }
    // var cacheResponse = "";
    // if(ff != ''){
    //   cacheResponse = "$gg$ff";
    //   APICacheDBModel cacheDBModel = APICacheDBModel(
    //     key: "Home_API",
    //     syncData: cacheResponse,
    //   );
    //   await APICacheManager().addCacheData(cacheDBModel);
    // }else{
    //   APICacheDBModel cacheDBModel = APICacheDBModel(
    //     key: "Home_API",
    //     syncData: gg,
    //   );
    //   await APICacheManager().addCacheData(cacheDBModel);
    // }

    return convertDatatoJson;
  } else {
    var cacheData = await APICacheManager().getCacheData("Home_API_Ch");
    // if (kDebugMode) {
    //   print("Cache hit");
    // }
    return json.decode(cacheData.syncData);
  }
}

//   var isCacheExit = await APICacheManager().isAPICacheKeyExist("Home_API");
//   if (!isCacheExit) {
//     var numPage = 1;
//     var url =
//         'https://click4pdf.org/wp-json/wp/v2/posts?page=$numPage&per_page=10';
//     var response =
//         await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
//     var jJ = response.headers;
//     String? aA = jJ['x-wp-totalpages'];
//     int totalPages = int.parse(aA!);
//
//     // String? aA = jJ['x-wp-total'];
//     // int one = int.parse(aA!);
//     // int bB = 10;
//     // int cntPosts = (one ~/bB);
//     // print(cntPosts);
//     var convertDatatoJson = jsonDecode(response.body);
//     for (numPage = 2; numPage <= totalPages; numPage++) {
//       var url =
//           'https://click4pdf.org/wp-json/wp/v2/posts?page=$numPage&per_page=10';
//       var response = await http
//           .get(Uri.parse(url), headers: {"Accept": "application/json"});
//
//       convertDatatoJson += jsonDecode(response.body);
//     }
//     //Response aa = convertDatatoJson;
//     //var strList = response.body;
//     APICacheDBModel cacheDBModel = APICacheDBModel(
//         key: "Home_API",
//         syncData: response.body ,
//     );
//     await APICacheManager().addCacheData(cacheDBModel);
//     if (kDebugMode) {
//       print("URL hit");
//       // print(convertDatatoJson.runtimeType); // List<dynamic>
//       //print(strList.runtimeType);
//     }
//     return jsonDecode(response.body);
//   } else {
//     var cacheData = await APICacheManager().getCacheData("Home_API");
//     if (kDebugMode) {
//       print("Cache hit");
//     }
//     //var target_list_2 = List<dynamic>.from(cacheData.syncData);
//     return json.decode(cacheData.syncData);
//   }
// }

// final response = await http.get(Uri.parse('https://flutternerd.com/index.php/wp-json/wp/v2/posts'), headers: {"Accept": "application/json"});
// var convertDatatoJson = jsonDecode(response.body);

Future fetchWpPostImageUrl(href) async {
  final response =
      await http.get(Uri.parse(href), headers: {"Accept": "application/json"});
  return jsonDecode(response.body);

  // var isCacheExit = await APICacheManager().isAPICacheKeyExist("HomeImage_API");
  // if (!isCacheExit){
  //   final response =
  //   await http.get(Uri.parse(href), headers: {"Accept": "application/json"});
  //   // var convertDatatoJson = jsonDecode(response.body);
  //   APICacheDBModel cacheDBModel = APICacheDBModel(
  //       key: "HomeImage_API",
  //       syncData: response.body ,
  //   );
  //   await APICacheManager().addCacheData(cacheDBModel);
  //   if (kDebugMode) {
  //     print("URL_Image hit");
  //   }
  //   return jsonDecode(response.body);
  // }else{
  //   var cacheData = await APICacheManager().getCacheData("HomeImage_API");
  //   if (kDebugMode) {
  //     print("Cache_Image hit");
  //   }
  //   return json.decode(cacheData.syncData);
  // }
}
