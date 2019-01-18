import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HighscoreList extends StatefulWidget{

  State createState() => new HighscoreListState(); 
}

class HighscoreListState extends State<HighscoreList>{

  Stream<QuerySnapshot> getUsers(){
    var firestore = Firestore.instance;
    Stream<QuerySnapshot> query = firestore.collection("score").snapshots();

    return query;
  }
  
  Widget build(BuildContext context){
    return Scaffold (
      appBar: AppBar(title: Text('Leaderboard'),
      backgroundColor: Colors.green,
    ),
      body: Container(
        child: StreamBuilder(
          stream: getUsers(),
          builder: (_,AsyncSnapshot<QuerySnapshot> snapshot){

            if (snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: Text("Gathering Leaderboard Information..."),
              );

            }else{
                return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Text(snapshot.data.documents[index].data["Username"].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0)),
                          Text("\nFlex Time: ${snapshot.data.documents[index].data["score"].toString()} Seconds",
                          style: TextStyle(fontSize: 16))
                        ],
                      ),
                    ),
                  );
                },
              );
            } 
          },
        )
      )
    );
    }
  }