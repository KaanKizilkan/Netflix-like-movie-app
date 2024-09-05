import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class kategoriler extends StatefulWidget {
  
  @override
  _kategorilerState createState() => _kategorilerState();
}

class _kategorilerState extends State<kategoriler> {
  void searchMoviesByGenre(String genre){
    Stream<QuerySnapshot> stream;

  if (genre == 'Tümü') {
    // Tüm filmleri getir
    stream = FirebaseFirestore.instance.collection('movies').snapshots();
  } else {
    // Film türüne göre filmleri getir
    stream = FirebaseFirestore.instance
        .collection('movies')
        .where('type', isEqualTo: genre)
        .snapshots();
  }

  // Sonuçları dinleyen bir StreamBuilder kullanarak filmleri listeleyin
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Hata: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('Film Listesi - $genre'),
            ),
            body: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                return ListTile(
                  title: Text((document.data() as Map<String, dynamic>)['movies'] ?? 'No Title'),
                  subtitle: Text((document.data() as Map<String, dynamic>)['type'] ?? 'No Title')
                );
              },
            ),
          );
        },
      ),
    ),
  );
  }
  String selectedGenre = 'Tümü';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Film Türü Seçimi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedGenre,
              onChanged: (String? newValue) {
                setState(() {
                  selectedGenre = newValue!;
                  searchMoviesByGenre(selectedGenre);
                });
              },
              items: <String>['Tümü', 'Aksiyon', 'Drama', 'Komedi', 'Bilim Kurgu', 'Gerilim','Anime']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                // Firestore arama işlemini gerçekleştir ve sonuçları listele
                searchMoviesByGenre(selectedGenre);
              },
              child: Text('Filmleri Listele'),
            ),
          ],
        ),
      ),
    );
  }
}
