import 'package:http/http.dart' as http;
import 'dart:convert';

Future fetchAPINoti(int? id) async {
  var convertDatatoJson;
  // var url = 'https://click4pdf.org/wp-json/wp/v2/posts/$id?_embed';
  var url = 'https://mmdbnchannel.com/wp-json/wp/v2/posts/$id?_embed';
  var response = await http
      .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
  // var response =
  // await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json',
  //   'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsIm5hbWUiOiJhZG1pbiIsImlhdCI6MTY1OTE4OTkwOCwiZXhwIjoxODE2ODY5OTA4fQ.g2i7XtFysCXVy-64WNAYiePahKO5WwowjA2oiQiECTg'});
  if (response.statusCode == 200){
    convertDatatoJson = jsonDecode(response.body);
    return convertDatatoJson;
  }else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Check Your Connection!');
  }

}