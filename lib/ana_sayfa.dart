import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:list_wheel_scroll_view_nls/list_wheel_scroll_view_nls.dart';
import 'package:yeni/information.dart';
import 'package:firebase_auth/firebase_auth.dart';



Widget WatchSomething(String value) {
  final CollectionReference _movies =
      FirebaseFirestore.instance.collection('movies');

  return StreamBuilder(
    stream: _movies.where('model', isEqualTo: value).snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapShot) {
      if (streamSnapShot.hasData) {
        return ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
            width: 5,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: streamSnapShot.data!.docs.length,
          itemBuilder: (context, index) {
            final DocumentSnapshot documentSnapshot =
                streamSnapShot.data!.docs[index];
            String photoUrl =
                ((documentSnapshot.data() as Map<String, dynamic>)['photo'] ??
                    (documentSnapshot.data() as Map<String, dynamic>)['no']);
            String Film_adi =
                ((documentSnapshot.data() as Map<String, dynamic>)['name'] ??
                    'No Title');
            String Trailer =
                ((documentSnapshot.data() as Map<String, dynamic>)['trailer'] ??
                    'No Title');
            ;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 105,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Material(
                      //Ink Image?
                      child: Ink.image(
                        image: NetworkImage(photoUrl),
                        fit: BoxFit.cover,
                        child: InkWell(onTap: () {
                          //tiklayinca Info Widgetina gidiyor
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  Info(Film_adi: Film_adi, Trailer: Trailer)));
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

Widget LastlyAdded() {
  final CollectionReference _movies =
      FirebaseFirestore.instance.collection('movies');

  return StreamBuilder(
    stream: _movies.orderBy('time',descending: true).limit(5).snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapShot) {
      if (streamSnapShot.hasData) {
        
        return ListWheelScrollViewX.useDelegate(
          scrollDirection: Axis.horizontal,
          
          itemExtent: 200,
          squeeze: 1.5,
          perspective: 0.003,
          
          
          childDelegate: ListWheelChildBuilderDelegate(childCount: streamSnapShot.data!.docs.length,
          builder:  (context, index) {
            final DocumentSnapshot documentSnapshot =
                streamSnapShot.data!.docs[index];
            String photoUrl =
                ((documentSnapshot.data() as Map<String, dynamic>)['photo'] ??
                    (documentSnapshot.data() as Map<String, dynamic>)['no']);
            String Film_adi =
                ((documentSnapshot.data() as Map<String, dynamic>)['name'] ??
                    'No Title');
            String Trailer =
                ((documentSnapshot.data() as Map<String, dynamic>)['trailer'] ??
                    'No Title');
                    String logo =
                ((documentSnapshot.data() as Map<String, dynamic>)['logo'] ??
                    'No Title');
            ;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  height: 175,
                  
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Material(
                      //Ink Image?
                      child: Ink.image(
                        image: NetworkImage(photoUrl),
                        fit: BoxFit.cover,
                        child: InkWell(onTap: () {
                          //tiklayinca Info Widgetina gidiyor
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  Info(Film_adi: Film_adi, Trailer: Trailer)));
                        }),
                      ),
                    ),
                  ),
                ),
                Container	(height: 75,
                
                width: 125,
                
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Material(
                      color: Colors.transparent,
                      //Ink Image?
                      child: Ink.image(
                        image: NetworkImage(logo),
                        fit: BoxFit.contain,
                        
                      ),
                    ),
                  ),)
              ],
            );
          }),
          
          
        );
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}



final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currnetUser => _firebaseAuth.currentUser;



