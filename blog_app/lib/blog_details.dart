// this file display individual blog details 
//it also provide 2 option for edit and delete the blog
import 'package:blog_app/create_blog.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/services/database_helper.dart';
import 'package:blog_app/home.dart';

class BlogDetails extends StatefulWidget {
  final int id;
  const BlogDetails({required this.id, super.key});

  @override

  BlogDetailsState createState() => BlogDetailsState();
}

class BlogDetailsState extends State<BlogDetails> {
  List<Map<String, dynamic>> _blog = [];
  late List<Map<String, dynamic>> data; 

//this method fetch the blog by id using dataHelper 
  void _refreshBlogs() async {
    final data = await DatabaseHelper().getBlog(widget.id);
    setState(() {
      _blog = data;
    });
  }

//initiate widget state and display fetched data
  @override
  void initState() {
    _refreshBlogs();
    super.initState();
  }

// creating a custom widget that display all the data for the blog record 
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
              ' ${_blog[0]['title']} ', // display title - we only expect 1 blog in list so we use blog[0]
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
                        image: MemoryImage(_blog[0]['picture']), //displaying stored picture
                        fit: BoxFit.cover,
                      ))),
            ),
            const SizedBox(height: 16),
          // below we display the date created and when it was last updated
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
              'By:  ${_blog[0]['authorName']}', // display author name
              style: const TextStyle(fontSize: 17, color: Colors.black),
            ),
            const SizedBox(height: 16),
            const Text(
              'Descrition content:', // display descrition content 
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              '${_blog[0]['desc']}',
              style: const TextStyle(fontSize: 15),
            )
          ],
        );
      },
    );
  }

//building the page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // creating app br similar to the one in the rest of the pages
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
      body: blogsList(), // we are using above created custom widget blogsList
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton.large( 
              key: const Key('edit'), // we are creating a floating button for editing 
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // we are routing to create blog but we pass data to populate the forms in the create blog page
                    builder: (context) => CreateBlog(id: widget.id), 
                  ),
                ).then((_) {
                  initState();
                });
              },
              child: const Icon(Icons.create_outlined),
            ),
            const SizedBox(width: 100),
            FloatingActionButton.large(
              key: const Key('delete'), // we are creating delete floating button 
              onPressed: () {
                showDialog(
                  useSafeArea: true,
                  context: context,
                  // below we are creating allert dialog for the user to confirm if they want to delete the blog
                  builder: (context) => AlertDialog(
                    scrollable: true,
                    title: const Text('Delete Blog'),
                    content: const Text(
                        'Are you sure you want to delete this blog?'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          // we are calling the methot to delete from DB
                          DatabaseHelper().deleteBlog(_blog[0]['id']); 
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              // once deleted we are rerouting to home page and reset state with new DB data
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
