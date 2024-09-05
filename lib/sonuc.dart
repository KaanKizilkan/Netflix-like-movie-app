import 'package:flutter/material.dart';
import 'package:yeni/information.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Widget sonuc(String genre) {
  Stream<QuerySnapshot> stream;
  Widget film_or_dizi(secim) {
    if (secim == 'movies') {
      stream = FirebaseFirestore.instance
          .collection('movies')
          .where('type', isEqualTo: genre)
          .where('model', isEqualTo: secim)
          .snapshots();
      return filmdizi(stream);
    } else {
      stream = FirebaseFirestore.instance
          .collection('movies')
          .where('type', isEqualTo: genre)
          .where('model', isEqualTo: secim)
          .snapshots();
    }

    return filmdizi(stream);
  }

  return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      title: Text(genre),
    ),
    body: Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text(
        'Filmler',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(
        height: 160,
        child: film_or_dizi('movies'),
      ),
      Text(
        'Diziler',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(
        height: 160,
        child: film_or_dizi('tv_series'),
      )
    ]),
  );
}

Widget filmdizi(Stream<QuerySnapshot> stream) {
  return SizedBox(
    height: 160,
    child: StreamBuilder(
      stream: stream,
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
              String Film_adi = ((documentSnapshot.data()
                      as Map<String, dynamic>)['name'] ??
                  'No Title');
              String Trailer = ((documentSnapshot.data()
                      as Map<String, dynamic>)['trailer'] ??
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
                                builder: (BuildContext context) => Info(
                                    Film_adi: Film_adi, Trailer: Trailer)));
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
    ),
  );
}
