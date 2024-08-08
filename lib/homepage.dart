import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart'as http;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  ChatUser myself= ChatUser(id: '1',firstName: 'vansh');
  ChatUser Bot= ChatUser(id: '2',firstName: 'Robo');
  
  List<ChatMessage> allmessage=[];
  List<ChatUser> type=[];  // for typing indicator

  final oururl='https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=Yourapikey';
  

  final header ={
    
    'Content-Type': 'application/json'
  };

  getdata(ChatMessage m) async{
    type.add(Bot);

    allmessage.insert(0, m);  // for my or user purpose
    setState(() {
      
    });
     var data={"contents":[{"parts":[{"text":m.text}]}]};

    await http.post(Uri.parse(oururl),headers: header,body:jsonEncode(data))
    .then((value){

      if(value.statusCode==200){

        var result = jsonDecode(value.body);
        print (result['candidates'][0]['content']['parts'][0]['text']);

        ChatMessage m1=ChatMessage(  // for bot purpose
          text:result['candidates'][0]['content']['parts'][0]['text'] ,
            user: Bot,
            createdAt: DateTime.now());

        allmessage.insert(0, m1);
        setState(() {

        });
      }
      else{
        print("error occured");
      }
    })
        .catchError((e){});

    type.remove(Bot);
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('AI CHAT BOT',style:
          TextStyle(
         fontStyle: FontStyle.italic,
            fontWeight:FontWeight.bold ,
            color:  Colors.lightGreenAccent,
            fontSize: 24,
          ),
        ),
      ),

      body: DashChat(       // by this package it can doisplay all the thimg
        typingUsers: type,
        currentUser: myself ,
        onSend: (ChatMessage m){
          getdata(m);
        },
        messages: allmessage,


      ),
    );
  }
}
