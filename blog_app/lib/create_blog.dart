//this class allow user to create a new blog model and stor it in data base
//it take id as parameter and if id == 0 is treated as a new blog 

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blog_app/services/database_helper.dart';
import 'package:blog_app/home.dart';

class CreateBlog extends StatefulWidget {
   final int id;
   const CreateBlog({required this.id, super.key});

  @override
  State<CreateBlog> createState() => CreateBlogState();
}

class CreateBlogState extends State<CreateBlog> {
  String authorName = '', title = '', desc = '';
 
// alocating form variables 
  final _authorNameController = TextEditingController();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  File? _selectedImage; // is used for edit to pull image from DB
  final ImagePicker imgpicker = ImagePicker(); //used for new records to pick image
  List<Map<String, dynamic>> _blog = [];
  dynamic pictureParam;

//method below is fetching blog by id from DB and set state by prepopulating fields is record exist
  void _refreshBlogs() async {
    final data = await DatabaseHelper().getBlog(widget.id);
    setState(() {
      _blog = data;
      //prepopulating fields if we are in edit mode (if != 0)
      if (widget.id != 0) {
        _authorNameController.text = _blog[0]['authorName'];
        _titleController.text = _blog[0]['title'];
        _descController.text = _blog[0]['desc'];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshBlogs();
  }

//method below is picking the image from media or camera 
//take a select as parameter depend of what icon we click (0 for camera or 1 to select from gallery)
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
          //fetching selected file path so we can convert in to Uint8byte data
          _selectedImage = File(pickedFile!.path); 
        });
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking image.");
    }
  }

//method below add new item to the database by calling databaseHelper
//image is sent as bytes to be stored in blob
  Future<void> _addItem() async {
   
      await DatabaseHelper().addBlog(
        _authorNameController.text,
        _titleController.text,
        _descController.text,
        _selectedImage!.readAsBytesSync());
  }

/*method below update blog. If user decide to not change the picture the old picture is pulled
from database displayed and restored otherwhise the path of the new selected image is processed and sored instead */
  Future<void> _updateBlog() async {
    if (_selectedImage != null) {
      pictureParam = _selectedImage!.readAsBytesSync();
    } else {
      pictureParam = _blog[0]['picture'];
    }
    await DatabaseHelper().updateBlog(widget.id, _authorNameController.text,
        _titleController.text, _descController.text, pictureParam);
  }

//below we are building the elements of the page by returning a Scaffold
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  // creating app bar similar to home page
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
      /*below we are displaying  2 icons (camera for taking photos or gallery to pick from gallery
      in case of a new record. If we are in edit mode (id!=0) the picture of the record is pulled from DB 
      and displayed toghether with 2 option for chnging the image (by taking photo or gallery)*/ 
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          _selectedImage == null && widget.id == 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      key: const Key('add photo icon'),
                      onTap: () {
                        getImage(0); // calling camera mode
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
                      key: const Key('perm media icon'),
                      onTap: () {
                        getImage(1); // calling gallery mode to pull picture
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
                //below we are displaiyng image from DB asociated with the record if we are in edit mode
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
                        child: _selectedImage == null ?  Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                image: DecorationImage(
                                  image: MemoryImage(_blog[0]['picture']),
                                  fit: BoxFit.cover,
                                ))) : 
                                
                                   Image.file(_selectedImage!),
                                
                      ),),
          // we are displaiyng 2 icons below the image: one for change the picture by taking new photo
          //2: by change the picture by selecting new one from the gallery
          _selectedImage != null || widget.id != 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        getImage(0); //calling method to take new photo
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
                        getImage(1); //calling method to pick from gallery
                        setState(() {
                          
                        });
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

          // Text form fields are displayed below and are prepopulated if we are in edit mode
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: <Widget>[
                TextFormField(
                  key: const Key('author'),
                  controller: _authorNameController,
                  decoration: const InputDecoration(hintText: "Author Name"),
                  onChanged: (value) {
                    authorName = value;
                  },
                ),
                TextFormField(
                  key: const Key('title'),
                  controller: _titleController,
                  decoration: const InputDecoration(hintText: "Title"),
                  onChanged: (value) {
                    title = value;
                  },
                ),
                TextFormField(
                  key: const Key('desc'),
                  controller: _descController,
                  validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a valid Desc';
                      }
                      return null;
                    },
                  decoration: const InputDecoration(hintText: "Desc"),
                  onChanged: (value) {
                    desc = value;
                  },
                ),

                //add button displayed below - this change value to save changes if we are in edit mode
                ElevatedButton(
                  key: const Key('button'),
                    onPressed: () async {
                      // if we create new elements we are adding to DB by calling _addItem
                      if (widget.id == 0) {
                        _addItem();
      
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                        // if we are in edit mode we are updating record by calling _updateBlog
                      } else {
                        _updateBlog();
                        setState(() {});
      
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      }
                      //Both from above redirect the user back to home page an reset state with new listof blogs.
                    },
                    child: widget.id == 0
                        ? const Text('Add Blog')
                        : const Text('Save changes')),
              ],
            ),
          )
        ],
      ),
    );
  }
}
