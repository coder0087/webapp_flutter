

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List> fetchCategoryTitles() async {
  var convertDatatoJson;
  var isCacheExit =
  await APICacheManager().isAPICacheKeyExist("CategoryList_API");
  if (!isCacheExit) {
    //var url = 'https://mtnewstoday.com/wp-json/wp/v2/categories?_fields=name,id';
    var url = 'https://mmdbnchannel.com/wp-json/wp/v2/categories?_fields=name,id';
    var response = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    // var url = 'https://click4pdf.org/wp-json/wp/v2/categories?_fields=name,id';
    // var response = await http.get(Uri.parse(url), headers: {
    //   'Content-Type': 'application/json',
    //   'Authorization':
    //   'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsIm5hbWUiOiJhZG1pbiIsImlhdCI6MTY1OTE4OTkwOCwiZXhwIjoxODE2ODY5OTA4fQ.g2i7XtFysCXVy-64WNAYiePahKO5WwowjA2oiQiECTg'
    // });
    if (response.statusCode == 200) {
      convertDatatoJson = jsonDecode(response.body);
      APICacheDBModel cacheDBModel = APICacheDBModel(
        key: "CategoryList_API",
        syncData: response.body,
      );
      await APICacheManager().addCacheData(cacheDBModel);
      return convertDatatoJson;
    } else {
      // if (kDebugMode) {
      //   print("Error Fetching Data");
      // }
      return convertDatatoJson;
    }
  } else {
    var cacheData = await APICacheManager().getCacheData("CategoryList_API");
    // if (kDebugMode) {
    //   print("Cache hit");
    // }
    return json.decode(cacheData.syncData);
  }
}
