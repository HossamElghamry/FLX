import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HighscoreList extends StatefulWidget{

  State createState() => new HighscoreListState(); 
}

class HighscoreListState extends State<HighscoreList>{

  Future getUsers() async{
    var firestore = Firestore.instance;
    QuerySnapshot query = await firestore.collection("score").getDocuments();

    return query.documents;
  }
  // List<int> _data = [1, 2, 5, 9,5,6,7,78,8,89,9,90,0,0,0];
    // _data.sort();
    // _data = _data.reversed.toList();
  Widget build(BuildContext context){
    return Scaffold (
      appBar: AppBar(title: Text('Leaderboard'),
      backgroundColor: Colors.green,
    ),
      body: Container(
        child: FutureBuilder(
          future: getUsers(),
          builder: (_,snapshot){

            if (snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: Text("Gathering Leaderboard Information..."),
              );

            }else{
                return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Text(snapshot.data[index].data["Username"].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0)),
                          Text("\nFlex Time: ${snapshot.data[index].data["score"].toString()} Seconds",
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