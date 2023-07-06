// https://click4pdf.org/wp-json/wp/v2/categories
// https://click4pdf.org/wp-json/wp/v2/posts?categories=9
// https://click4pdf.org/wp-json/wp/v2/categories/4
// https://click4pdf.org/wp-json/wp/v2/categories/12
// https://click4pdf.org/wp-json/wp/v2/categories/14
// https://click4pdf.org/wp-json/wp/v2/categories/6
// https://click4pdf.org/wp-json/wp/v2/categories/8
// https://click4pdf.org/wp-json/wp/v2/categories/1
// https://click4pdf.org/wp-json/wp/v2/categories/20
// https://click4pdf.org/wp-json/wp/v2/categories/5
// https://click4pdf.org/wp-json/wp/v2/categories/57
// https://click4pdf.org/wp-json/wp/v2/posts?categories=9&page=1&per_page=1

// $.get( 'http://demo.wp-api.org/wp-json/wp/v2/posts', function( data, status, request ) {
//   numPosts = request.getResponseHeader('x-wp-total');
//   console.log( numPosts ); //outputs number of posts to console
// });

// import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';

Future<List> fetchWpPostsBusiness(int? id) async {
  var numPage = 1;
  var perPage = 50 ;
  var convertDatatoJson;
  var isCacheExit = await APICacheManager().isAPICacheKeyExist("allCategory_API$id");

  if (!isCacheExit) {
    // var url = 'https://click4pdf.org/wp-json/wp/v2/posts?_embed&categories=$id&page=$numPage&per_page=$perPage';
    var url = 'https://mmdbnchannel.com/wp-json/wp/v2/posts?_embed&categories=$id&page=$numPage&per_page=$perPage';
    var response = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    // var response =
    // await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json',
    //   'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsIm5hbWUiOiJhZG1pbiIsImlhdCI6MTY1OTE4OTkwOCwiZXhwIjoxODE2ODY5OTA4fQ.g2i7XtFysCXVy-64WNAYiePahKO5WwowjA2oiQiECTg'});
    convertDatatoJson = jsonDecode(response.body);
    var jJ = response.headers;
    String? aA = jJ['x-wp-totalpages'];
    int totalPages = int.parse(aA!);
    String? bB = jJ['x-wp-total'];
    int totalPosts = int.parse(bB!);
    // if (kDebugMode) {
    //   print("Cache hit $totalPosts");
    // }
    APICacheDBModel cacheDBModel = APICacheDBModel(
      key: "allCategory_API$id",
      syncData: response.body,
    );
    await APICacheManager().addCacheData(cacheDBModel);

    if(totalPosts>perPage){
      for(numPage = 2 ; numPage<=totalPages; numPage++){
        var url = 'https://mtnewstoday.com/wp-json/wp/v2/posts?_embed&categories=$id&page=$numPage&per_page=$perPage';
        var response = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
        // var url = 'https://click4pdf.org/wp-json/wp/v2/posts?_embed&categories=$id&page=$numPage&per_page=$perPage';
        // var response =
        // await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json',
        //   'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsIm5hbWUiOiJhZG1pbiIsImlhdCI6MTY1OTE4OTkwOCwiZXhwIjoxODE2ODY5OTA4fQ.g2i7XtFysCXVy-64WNAYiePahKO5WwowjA2oiQiECTg'});
        convertDatatoJson += jsonDecode(response.body);
      }
    }
    return convertDatatoJson;
  }else {
    var cacheData = await APICacheManager().getCacheData("allCategory_API$id");
    // if (kDebugMode) {
    //   print("Cache hit");
    // }
    return json.decode(cacheData.syncData);
  }
}



// Future fetchWpPostsBusinessImageUrl(href) async {
//   final response = await http.get(Uri.parse(href), headers: {"Accept": "application/json"});
//   var convertDatatoJson = jsonDecode(response.body);
//   return convertDatatoJson;
// }
