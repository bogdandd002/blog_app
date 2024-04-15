import 'package:blog_app/blog_details.dart';
import 'package:blog_app/create_blog.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/services/database_helper.dart';
import 'package:blog_app/home.dart';

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
    final data = await DatabaseHelper().getBlog(widget.id);
    setState(() {
      _blog = data;
      // _isLoading = false;
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
                  width: MediaQuery.of(context).size.width * 0.80,
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
              'Created on: ${_blog[0]['dateCreated']}',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 6),
            Text(
              'Last updated: ${_blog[0]['lastUpdated']}',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),
            Text(
              'By:  ${_blog[0]['authorName']}',
              style: const TextStyle(fontSize: 17, color: Colors.black),
            ),  
            const SizedBox(height: 16),
            const Text('Descrition content:', 
            style: TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(height:5),
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
                    builder: (context) => CreateBlog(id: widget.id),
                ),).then((_) {
                  initState();
                });
              },
              child: const Icon(Icons.create_outlined),
            ),
            const SizedBox(width: 100),
            FloatingActionButton.large(
              onPressed: () {
                showDialog(
                  useSafeArea: true,
                  context: context,
                  builder: (context) => AlertDialog(
                    scrollable: true,
                    title: const Text('Delete Blog'),
                    content: const Text('Are you sure you want to delete this blog?'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          DatabaseHelper().deleteBlog(_blog[0]['id']);
                          // Navigator.of(context).pop();
                          // setState(() {});
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        },
                        child: const Text('Yes'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('No'),
                      ),
                    ],
                  ),
                );
              },
              child: const Icon(Icons.delete_outlined),
            )
          ],
        ),
      ),
    );
  }
}

