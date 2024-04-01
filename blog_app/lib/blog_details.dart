import 'package:blog_app/blog_details.dart';
import 'package:blog_app/create_blog.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/services/database_helper.dart';

class BlogDetails extends StatefulWidget {
  final int id;
  const BlogDetails({required this.id, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BlogDetailsState createState() => _BlogDetailsState();
}

class _BlogDetailsState extends State<BlogDetails> {
  List<Map<String, dynamic>> _blog = [];
  bool _isLoading = true;

  void _refreshBlogs() async {
    final data = await DatabaseHelper.getBlog(widget.id);
    setState(() {
      _blog = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _refreshBlogs();
    super.initState();
  }

  Widget blogsList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 24),
      itemCount: _blog.length,
      itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              ' ${_blog[0]['title']} - ${_blog[0]['id']}',
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: Container(
                  width: double.maxFinite,
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      image: DecorationImage(
                        image: MemoryImage(_blog[0]['picture']),
                        fit: BoxFit.cover,
                      ))),
            ),
            const SizedBox(height: 16),
            Text(
              'By:  ${_blog[0]['authorName']}',
              style: const TextStyle(fontSize: 17, color: Colors.black),
            ),
            const SizedBox(height: 16),
            Text(
              '${_blog[0]['desc']}',
              style: const TextStyle(fontSize: 15),
            )
          ],
        );
        // _blog[0]['id'];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Flutter",
              style: TextStyle(fontSize: 22),
            ),
            Text(
              "Blog",
              style: TextStyle(fontSize: 22, color: Colors.blue),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: blogsList(),
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton.large(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateBlog(),
                  ),
                ).then((_) {
                  initState();
                });
              },
              child: const Icon(Icons.create_outlined),
            ),
            const SizedBox(width: 100),
            FloatingActionButton.large(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateBlog(),
                  ),
                ).then((_) {
                  initState();
                });
              },
              child: const Icon(Icons.delete_outlined),
            )
          ],
        ),
      ),
    );
  }
}

// Crating a blog tile widget
// ignore: must_be_immutable
class BlogTile extends StatelessWidget {
  final String title, desc, author;
  MemoryImage imgUrl;
  int id;
  BlogTile(
      {super.key,
      required this.id,
      required this.author,
      required this.desc,
      required this.imgUrl,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24, right: 16, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        image: DecorationImage(
                          image: imgUrl,
                          fit: BoxFit.cover,
                        ))),
              ),
              Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 17, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 2),
                  Text(
                    '$desc - By $author',
                    style: const TextStyle(fontSize: 14),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
