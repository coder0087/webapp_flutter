import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';


class Post extends StatefulWidget {

  final String? imageUrl, title, content;
  Post({this.content, this.imageUrl, this.title});
  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image.network(widget.imageUrl!),
              CachedNetworkImage(
                imageUrl: widget.imageUrl!,
                height: 200,
                width: 450,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
                // errorWidget: (context, url, error) => const Center(child: Text('Check Internet Connection')),
                errorWidget: (context, url, error) => const Icon(Icons.network_check),
              ),
              SizedBox(height: 8),
              Text(
                widget.title!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              // Text(widget.content!),
              Html(data: widget.content),
            ],
          ),
        ),
      ),
    );
  }
}