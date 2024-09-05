import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Firestore'dan belge listesini görüntülemek için
class filmsil extends StatefulWidget {
   filmsil({super.key});

  @override
  State<filmsil> createState() => _filmsilState();
}

class _filmsilState extends State<filmsil> {
  

// Belirli bir belgeyi silmek için
void deleteDocument(String documentId) async {
  await FirebaseFirestore.instance
      .collection('movies')
      .doc(documentId)
      .delete();
}

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('Film Sil'),),

      body:  StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('movies').snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text('Hata: ${snapshot.error}');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      }

      return ListView.builder(
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (BuildContext context, int index) {
          DocumentSnapshot document = snapshot.data!.docs[index];
          return ListTile(
            title: Text((document.data() as Map<String, dynamic>)['name'] ?? 'No Title'),

            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deleteDocument(document.id);
              },
            ),
          );
        },
      );
    },
  )



// Firestore'dan belge listesini görüntülemek için

    );
  }
}