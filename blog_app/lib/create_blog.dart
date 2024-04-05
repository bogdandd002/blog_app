import 'dart:io';
import 'dart:typed_data';
import 'package:blog_app/blog_details.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blog_app/services/database_helper.dart';
import 'package:blog_app/home.dart';

class CreateBlog extends StatefulWidget {
  final int id;
  const CreateBlog({required this.id, super.key});

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  String authorName = '', title = '', desc = '';
  List<Map<String, dynamic>> _blogs = [];

  bool _isLoading = true;

  var _authorNameController = TextEditingController();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  File? _selectedImage;
  final ImagePicker imgpicker = ImagePicker();
  List<Map<String, dynamic>> _blog = [];
  dynamic _picture, pictureParam;

  void _refreshBlogs() async {
    final data = await DatabaseHelper.getBlog(widget.id);
    setState(() {
      _blog = data;
      if (widget.id != 0) {
        _authorNameController.text = _blog[0]['authorName'];
        _titleController.text = _blog[0]['title'];
        _descController.text = _blog[0]['desc'];
        _picture = _blog[0]['desc'];
      }
      // _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshBlogs();
  }

  Future getImage(int select) async {
    try {
      dynamic pickedFile;
      if (select == 0) {
        pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      } else if (select == 1) {
        pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      }

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile!.path);
        });
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking image.");
    }
  }

  // void _refresBlogs() async {
  //   final data = await DatabaseHelper.getAllBlogs();
  //   setState(() {
  //     _blogs = data;
  //     _isLoading = false;
  //   });
  // }

  Future<void> _addItem() async {
    await DatabaseHelper.addBlog(
        _authorNameController.text,
        _titleController.text,
        _descController.text,
        _selectedImage!.readAsBytesSync());
  }

  Future<void> _updateBlog() async {
    if (_selectedImage != null) {
      pictureParam = _selectedImage;
    } else {
      pictureParam = _picture;
    }
    await DatabaseHelper.updateBlog(widget.id, _authorNameController.text,
        _titleController.text, _descController.text, _picture);
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
        actions: <Widget>[
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(Icons.file_upload))
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            _selectedImage == null && widget.id == 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          getImage(0);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: 70,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6)),
                          width: 70,
                          child: const Icon(
                            Icons.add_a_photo,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          getImage(1);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: 70,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6)),
                          width: 70,
                          child: const Icon(
                            Icons.perm_media,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: widget.id == 0
                        ? Image.file(_selectedImage!)
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                image: DecorationImage(
                                  image: MemoryImage(_blog[0]['picture']),
                                  fit: BoxFit.cover,
                                )))),
            _selectedImage != null || widget.id != 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          getImage(0);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: 70,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6)),
                          width: 70,
                          child: const Icon(
                            Icons.add_a_photo,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          getImage(1);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: 70,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6)),
                          width: 70,
                          child: const Icon(
                            Icons.perm_media,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(
                    height: 1,
                  ),
            const SizedBox(
              height: 8,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _authorNameController,
                    decoration: const InputDecoration(hintText: "Author Name"),
                    onChanged: (value) {
                      authorName = value;
                    },
                  ),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: "Title"),
                    onChanged: (value) {
                      title = value;
                    },
                  ),
                  TextField(
                    controller: _descController,
                    decoration: const InputDecoration(hintText: "Desc"),
                    onChanged: (value) {
                      desc = value;
                    },
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (widget.id == 0) {
                          _addItem();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        } else {
                          _updateBlog();
                          setState(() {});

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        }

                        // if (id != null) {
                        //   await DatabaseHelper.updateBlog(id);
                        // }

                        // _authorNameController.text = ' ';

                        // Navigator.of(context).pop();
                        // setState(() {});
                      },
                      child: widget.id == 0
                          ? const Text('Add Blog')
                          : const Text('Save changes')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
