import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'authenticate.dart';
import 'users.dart';
import 'convo.dart';

class Chat extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

String id = Authenticate().user();
CollectionReference users = FirebaseFirestore.instance.collection('users');

class _ChatPageState extends State<Chat> {
  List<Users> chatUsers = [
    Users(name: "Jeon Jungkook", messageText: "I know name, but not movie", imageURL: "https://kpopping.com/documents/94/3/2000/batch_LIV_4178-copy.jpeg", time: "Now"),
    Users(name: "Kim Seokjin", messageText: "Hilarious!", imageURL: "https://i.pinimg.com/474x/3d/cc/81/3dcc81ff5f9612640c6da87c80b4b791.jpg", time: "Yesterday"),
    Users(name: "Min Yoongi", messageText: "What is a lil meow meow?", imageURL: "https://filmdaily.co/wp-content/uploads/2020/09/HotSuga-7-A-pretty-boy-if-there-ever-was-one72.jpg", time: "31 Oct"),
    Users(name: "Kim Taehyung", messageText: "Do you know purple?", imageURL: "https://pbs.twimg.com/media/EgE6DoLXsAEowLk.jpg", time: "23 Oct"),
    Users(name: "Park Jimin", messageText: "You nice, keep going.", imageURL: "http://images6.fanpop.com/image/photos/41400000/X-DISPATCH-FOR-Jimin-5TH-ANNIVERSARY-bts-41419921-422-588.png", time: "12 Oct"),
    Users(name: "Jung Hoseok", messageText: "But can you even dance though?", imageURL: "https://cdn-contents.magazine.weverse.io/upload/img/202011/20201124i8Jw6N7LT9o0.jpg", time: "22 Sept"),
    Users(name: "Kim Namjoon", messageText: "Have you seen my bonsai tree recently?", imageURL: "https://pbs.twimg.com/media/EA92mW2UEAcvhXX.jpg", time: "1 Sept"),
    Users(name: "Bang Sihyuk", messageText: "What are the newest money making schemes?",imageURL: "https://pbs.twimg.com/profile_images/671753737065652225/y8-36RNE_400x400.jpg", time: "16 Aug"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16,right: 16,top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Conversations",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
                    Container(
                      padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lime,
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.add,color: Colors.blue,size: 20,),
                          SizedBox(width: 2,),
                          Text("Add New",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16,left: 16,right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey.shade100
                      )
                  ),
                ),
              ),
            ),
              ListView.builder(
                itemCount: chatUsers.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 16),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){
                  return Conversation(
                  name: chatUsers[index].name,
                  messageText: chatUsers[index].messageText,
                  imageUrl: chatUsers[index].imageURL,
                  time: chatUsers[index].time,
                  isMessageRead: (index == 0 || index == 3)?true:false,
                );
              },
            ),
          ],
        ),
      ),
    );

  }
}