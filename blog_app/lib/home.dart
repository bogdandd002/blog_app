//this is our home page that is displayed when the app start first time

import 'package:blog_app/blog_details.dart';
import 'package:blog_app/create_blog.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/services/database_helper.dart';

//below we are creating a statefull widget which will host our app
class HomePage extends StatefulWidget {
  
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _blogs = []; //is storing data fetched from DB
  List<Map<String, dynamic>> filteredBlogs = []; // store the filtered blogs
  bool _selectionFlag = false; //store if a blog tile has been selected by long press
  List<int> blogIdList = List.empty(growable: true); // store a list of id's that need to be deleted
  late String nrSelectedblogs;

  void refreshBlogs() async {
    final data = await DatabaseHelper().getAllBlogs(); //fetching all blogs from DB 
    setState(() {
      _blogs = data;
      filteredBlogs = _blogs;
    });
  }

//method below si filtering the blogs from our list based on what we enter in the search box
//setState is called every time we type in so the results are displayed instantly
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

//method below is flaging if we are selecting blog tiles by long pressing on them
//it also increment/decrement a count which is displayed next to the trash icon
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

//init state function and we are also caling refreshBlogs to refres the list from DB
  @override
  void initState() {
    refreshBlogs();
    super.initState();
  }

//custom widget to display the list
  Widget blogsList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 24),
      itemCount: filteredBlogs.length,
      itemBuilder: (context, index) {
        /*we are using our own custom widget called BlogTile
        we are passing all the data from filteredBlogs so it is displayed only what we ar tiping in the 
        search bar. We are also passing a callback function which add the selected blogs to a list
        so we can delete multiple blogs at once  */ 
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
            //we are calling method below to count selection 
            longPress();
          },
        );
      },
    );
  }

//below we start displaying the tiles and elements
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //creating app bar 
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
    //creating body 
      body: Column(
        children: [
          //inserting search bar
          TextFormField(
            onChanged: filterBlogs,
            decoration: const InputDecoration(
              hintText: "Search here",
              prefixIcon: Icon(Icons.search),
            ),
          ),

          //we are displaiyng the custom made above blogList widget in here
          Expanded(child: blogsList())
        ],
      ),
    
    /* we are creating a floating action button below which it looks like an add button
    but it change the state to a red trash button once the blog tile is long pressed (selected)
    */
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _selectionFlag == false
                ? FloatingActionButton.large(
                  key: const Key('add blog'),
                    tooltip: 'Add blog',
                    backgroundColor: Colors.greenAccent,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateBlog(id: 0), //we are directing the user to CreateBlog page in here
                        ),
                      ).then((_) {
                        initState();
                      });
                    },
                    child: const Icon(Icons.add),
                  )
                  //delete button is displayed only if blog tile is selected
                : FloatingActionButton.large(
                    tooltip: 'Delete',
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    elevation: 12,
                    onPressed: () {
                      showDialog(
                        useSafeArea: true,
                        context: context,
                        //we are implementing an alert box once the delete button is pressed
                        builder: (context) => AlertDialog(
                          scrollable: true,
                          title: blogIdList.length == 1
                              ? const Text('Delete blog') // if a single blog tile is selected
                              : const Text('Delete multiple blogs'), //if multiple blog tiles are selected
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
                                    builder: (context) => const HomePage(), //once deleted we are redirecting to home page an reset state with new list 
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

// Crating a blog tile widget to be used in blogList
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
                  //we making the title of the blocg clickable 
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
                          builder: (context) => BlogDetails(id: widget.id), //redirecting user to blog detail once pressed
                        ),
                      ).then((_) {});
                    },
                    onLongPress: () { //function for on long press on the title
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
