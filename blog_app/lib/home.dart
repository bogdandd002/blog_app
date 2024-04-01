import 'package:blog_app/blog_details.dart';
import 'package:blog_app/create_blog.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/services/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _blogs = [];
  bool _isLoading = true;

  void _refreshBlogs() async {
    final data = await DatabaseHelper.getAllBlogs();
    setState(() {
      _blogs = data;
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
      itemCount: _blogs.length,
      itemBuilder: (context, index) {
        return BlogTile(
            id: _blogs[index]['id'],
            author: _blogs[index]['authorName'],
            title: _blogs[index]['title'],
            desc: _blogs[index]['desc'],
            imgUrl: MemoryImage(_blogs[index]['picture']));
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
            FloatingActionButton(
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
              child: const Icon(Icons.add),
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
  final HomePage home = const HomePage();
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
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlogDetails(id: id),
                        ),
                      ).then((_) {
                        
                      });
                    },
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 17, color: Colors.black),
                    ),
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
