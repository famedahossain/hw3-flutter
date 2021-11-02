import 'package:flutter/material.dart';
import 'authenticate.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'chat.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  String id = Authenticate().user();
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  String age = '';
  String bio = '';
  String img = '';
  String hometown ='';
  String name = '';

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lime.shade400,
        title: Text("Home Page"),
          actions: <Widget>[
            FlatButton(
                onPressed: (){
                  userImageChoice(true);
                },
                child: const Icon(Icons.add)
            )
          ]
      ),
      body: Chat(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.lime.shade400,
        unselectedItemColor: Colors.blue,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        type: BottomNavigationBarType.fixed,
        items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          title: Text("Chats"),
          ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group_work),
          title: Text("Channels"),
          ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box),
          title: Text("Profile"),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Authenticate().signOut(context);
        },
        tooltip: 'Log Out',
        child: const Icon(Icons.logout),
      ),
    );
  }

  Future userImageChoice(bool gallery) async {
    ImagePicker imagePicker = ImagePicker();
    XFile image;
    if(gallery) {
      image = (await imagePicker.pickImage(
          source: ImageSource.gallery,imageQuality: 50))!;
    }
    else{
      image = (await imagePicker.pickImage(
          source: ImageSource.camera,imageQuality: 50))!;
    }
    setState(() {
      _image = File(image.path);
      uploadImage(_image);
    });
  }

  Future<void> uploadImage(img) async {
    User user = Authenticate().authorizedUser();
    String id = user.uid;
    var storage = FirebaseStorage.instance;
    TaskSnapshot snapshot = await storage
        .ref()
        .child(id)
        .putFile(img);
    if (snapshot.state == TaskState.success) {
      final String downloadUrl =
      await snapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection("user")
          .doc(id)
          .update({"url": downloadUrl});
      setState(() {
      });
    }
  }
}

class UserView extends StatefulWidget{
  final String age, img, name, bio, hometown;
  UserView(this.age,this.img,this.name,this.bio,this.hometown);

  @override
  State<StatefulWidget> createState() { return new UserViewState();}
}

class UserViewState extends State<UserView>{
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("User Home"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: Text( widget.name,
                  style: const TextStyle(
                      fontSize: 45.0)),
              padding: EdgeInsets.all(20),
            ),
            Container(
              child: widget.img.length > 1 ?
              Image.network(widget.img, height: 200, width: 200,) :
              Image.asset('assets/defaultUserPicture.png', height: 200, width: 200,),
            ),
            Container(
              child: Text("Bio: " + widget.bio,
                  style: const TextStyle(
                      fontSize: 20.0)),
              padding: EdgeInsets.all(20),
            ),
            Container(
              child: Text("Age: " + widget.age,
                  style: const TextStyle(
                      fontSize: 20.0)),
              padding: EdgeInsets.all(20),
            ),
            Container(
              child: Text("Hometown: " + widget.hometown,
                  style: const TextStyle(
                      fontSize: 20.0)),
              padding: EdgeInsets.all(20),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Authenticate().signOut(context);
        },
        tooltip: 'Log Out',
        child: const Icon(Icons.logout),
      ),
    );

  }

}