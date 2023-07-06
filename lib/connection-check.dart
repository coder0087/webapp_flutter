// import 'dart:io';
// import 'package:wordpress1/api-response.dart';
// import 'package:flutter/foundation.dart';
// import 'package:api_cache_manager/api_cache_manager.dart';
//
// Future checkConnection() async {
//   try {
//     final result = await InternetAddress.lookup('google.com');
//     if (result.isEmpty && result[0].rawAddress.isEmpty) {
//       // hasConnection = true;
//       // await APICacheManager().getCacheData("Home_API");
//       if (kDebugMode) {
//         print("connection loss");
//       }
//       setState(() {});
//       // futureAlbum;
//       fetchWpPosts();
//     }else {
//       if (kDebugMode) {
//         print("connection get");
//       }
//       setState(() {});
//       APICacheManager().deleteCache("Home_API");
//       // futureAlbum;
//       fetchWpPosts();
//     }
//   } on SocketException catch (_) {
//     if (kDebugMode) {
//       print("connection SocketException");
//     }
//     setState(() {});
//     // futureAlbum;
//     fetchWpPosts();
//   }
// }

// Future<bool> checkConnection() async {
//   Future<bool> hasConnection = Future<bool>.value(false);
//   // return Future<bool>.value(true);
//   try {
//     final result = await InternetAddress.lookup('google.com');
//     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//       hasConnection = Future<bool>.value(true);
//     }else {
//       hasConnection = Future<bool>.value(false);
//     }
//   } on SocketException catch (_) {
//     hasConnection = Future<bool>.value(false);
//   }
//   return hasConnection;
// }
