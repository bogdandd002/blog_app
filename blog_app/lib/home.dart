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
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.only(top: 24),
        itemCount: _blogs.length,
        itemBuilder: (context, index) {
          return BlogTile(
            author: _blogs[index]['authorName'],
            title: _blogs[index]['title'],
            desc: _blogs[index]['desc'],
            imgUrl:
                ('https://www.shutterstock.com/image-photo/woman-working-home-office-hand-on-370595594'),
          );
        },
      ),
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
                );
              },
              child: const Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imgUrl, title, desc, author;
  BlogTile(
      {required this.author,
      required this.desc,
      required this.imgUrl,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24, right: 16, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Image.network(
                imgUrl,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(fontSize: 17),
          ),
          SizedBox(height: 2),
          Text(
            '$desc - By $author',
            style: TextStyle(fontSize: 14),
          )
        ],
      ),
    );
  }
}
