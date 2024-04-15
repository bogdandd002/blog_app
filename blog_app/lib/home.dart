import 'package:blog_app/blog_details.dart';
import 'package:blog_app/create_blog.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/services/database_helper.dart';
import 'package:flutter/rendering.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _blogs = [];
  List<Map<String, dynamic>> filteredBlogs = [];
  bool _isLoading = true;
  bool _selectionFlag = false;
  List<int> blogIdList = List.empty(growable: true);
  late String nrSelectedblogs;

  void refreshBlogs() async {
    final data = await DatabaseHelper().getAllBlogs();
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

  void longPress() {
    setState(() {
      if (blogIdList.isEmpty) {
        _selectionFlag = false;
      } else {
        _selectionFlag = true;
        nrSelectedblogs = blogIdList.length.toString();
      }
    });
  }

  @override
  void initState() {
    refreshBlogs();
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
          created: filteredBlogs[index]['dateCreated'],
          callback: (int id) {
            id--;
            if (blogIdList.contains(filteredBlogs[id]['id'])) {
              blogIdList.remove(filteredBlogs[id]['id']);
            } else {
              blogIdList.add(filteredBlogs[id]['id']);
            }
            print(blogIdList);
            longPress();
          },
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
            _selectionFlag == false
                ? FloatingActionButton.large(
                    tooltip: 'Add blog',
                    backgroundColor: Colors.greenAccent,
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
                : FloatingActionButton.large(
                    tooltip: 'Delete',
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    elevation: 12,
                    onPressed: () {
                      showDialog(
                        useSafeArea: true,
                        context: context,
                        builder: (context) => AlertDialog(
                          scrollable: true,
                          title: blogIdList.length == 1
                              ? const Text('Delete blog')
                              : const Text('Delete multiple blogs'),
                          content: blogIdList.length == 1
                              ? const Text(
                                  'Are you sure you want to delete this blog?')
                              : const Text(
                                  'Are you sure you want to delete this multiple blogs?'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                DatabaseHelper().deleteBlogs(blogIdList);
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
                              child: Text('No'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.delete_outline,
                            size: 40,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            nrSelectedblogs,
                            style: const TextStyle(fontSize: 40),
                          ),
                        ])),
          ],
        ),
      ),
    );
  }
}

// Crating a blog tile widget
// ignore: must_be_immutable
class BlogTile extends StatefulWidget {
  final String title, desc, author;
  MemoryImage imgUrl;
  int id;
  final Function callback;
  String created;

  BlogTile(
      {super.key,
      required this.id,
      required this.author,
      required this.desc,
      required this.imgUrl,
      required this.title,
      required this.created,
      required this.callback});

  @override
  // ignore: library_private_types_in_public_api
  _BlogTileState createState() => _BlogTileState();
}

class _BlogTileState extends State<BlogTile> {
  bool _selected = false;

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
                        image: DecorationImage(
                      image: widget.imgUrl,
                      fit: BoxFit.cover,
                    ))),
              ),
              Column(
                children: [
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: _selected == false
                            ? Colors.white
                            : Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.50,
                            40), // Make it responsive
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        textStyle: const TextStyle(fontSize: 14)),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlogDetails(id: widget.id),
                        ),
                      ).then((_) {});
                    },
                    onLongPress: () {
                      setState(() {
                        _selected = !_selected;
                      });
                      widget.callback(widget.id);
                    },
                    child: Text(
                      widget.title,
                      style: const TextStyle(fontSize: 17, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 2),
                  Text(
                    'By ${widget.author}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  // Text(
                  //   widget.desc,
                  //   style: const TextStyle(fontSize: 14),
                  // )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
