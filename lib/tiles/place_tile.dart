import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  PlaceTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 100,
            child: Image.network(
              snapshot.data['image'],
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  snapshot.data['title'],
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                Text(
                  snapshot.data['address'],
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  launch('https://www.google.com/maps/search/?api=1&query=${snapshot.data['lat']},${snapshot.data['long']}');
                },
                child: Text('Ver no Mapa'),
                textColor: Colors.white,
              ),
              SizedBox(width: 10,),
              FlatButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  launch('tel:${snapshot.data['phone']}'); // abrir o telefone
                },
                child: Text('Ligar'),
                textColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
