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
  List<Map<String, dynamic>> filteredBlogs = [];
  bool _isLoading = true;

  void _refreshBlogs() async {
    final data = await DatabaseHelper.getAllBlogs();
    setState(() {
      _blogs = data;
      filteredBlogs = _blogs;
      _isLoading = false;
    });
  }

  void filterBlogs(String query) {
    setState(() {
      filteredBlogs = _blogs
          .where((item) =>
              item['desc'].toLowerCase().contains(query.toLowerCase()) ||
              item['authorName'].toLowerCase().contains(query.toLowerCase()) ||
              item['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
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
      itemCount: filteredBlogs.length,
      itemBuilder: (context, index) {
        return BlogTile(
          id: filteredBlogs[index]['id'],
          author: filteredBlogs[index]['authorName'],
          title: filteredBlogs[index]['title'],
          desc: filteredBlogs[index]['desc'],
          imgUrl: MemoryImage(filteredBlogs[index]['picture']),
        );
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
      body: Column(
        children: [
          TextFormField(
            onChanged: filterBlogs,
            decoration: const InputDecoration(
              hintText: "Search here",
              prefixIcon: Icon(Icons.search),
            ),
          ),
          Expanded(child: blogsList())
        ],
      ),
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
                    builder: (context) => const CreateBlog(id: 0),
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
  final String title, desc, author;
  MemoryImage imgUrl;
  int id;
  BlogTile({
    super.key,
    required this.id,
    required this.author,
    required this.desc,
    required this.imgUrl,
    required this.title,
  });

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
                      ).then((_) {});
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
