import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blog_app/services/database_helper.dart';

class CreateBlog extends StatefulWidget {
  const CreateBlog({super.key});

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  String authorName = '', title = '', desc = '';
  List<Map<String, dynamic>> _blogs = [];

  bool _isLoading = true;

  final TextEditingController _authorNameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  File? _selectedImage;
  final ImagePicker imgpicker = ImagePicker();
  Future getImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
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

  void _refresBlogs() async {
    final data = await DatabaseHelper.getAllBlogs();
    setState(() {
      _blogs = data;
      _isLoading = false;
    });
  }

  Future<void> _addItem() async {
    await DatabaseHelper.addBlog(
        _authorNameController.text,
        _titleController.text,
        _descController.text,
        _selectedImage!.readAsBytesSync());
    print('Blog added');
    print('..number of items ${_blogs.length}');
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
            GestureDetector(
              onTap: () {
                getImage();
              },
              child: _selectedImage != null
                  ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6)),
                      width: MediaQuery.of(context).size.width,
                      child: Image.file(_selectedImage!))
                  : Container(
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
                        // if (id == null) {
                        await _addItem();
                        // }

                        // if (id != null) {
                        //   await DatabaseHelper.updateBlog(id);
                        // }

                        // _authorNameController.text = ' ';

                        Navigator.of(context).pop();
                        setState(() {});
                      },
                      child: Text('Add Blog')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
