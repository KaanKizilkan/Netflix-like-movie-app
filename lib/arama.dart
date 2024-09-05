import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:yeni/information.dart';
import 'package:yeni/sonuc.dart';

class arama extends StatefulWidget {
  @override
  _aramaState createState() => _aramaState();
}

class _aramaState extends State<arama> {
  String photoUrl = '';
  String searchTerm = '';
/* its just tests
// Kategorinin fonkisyonu DENme  ama bunu SİL sonra bu kod su an kullanılmıyor !!!!!!!!!
  void searchMoviesByGenre(String genre) {
    Stream<QuerySnapshot> stream;

    // Film türüne göre filmleri getir
    stream = FirebaseFirestore.instance
        .collection('movies')
        .where('type', isEqualTo: genre)
        .snapshots();

    // Sonuçları dinleyen bir StreamBuilder kullanarak filmleri listeleyin
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StreamBuilder<QuerySnapshot>(
          stream: stream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              body: ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(
                  width: 5,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  String photoUrl =
                      ((document.data() as Map<String, dynamic>)['photo'] ??
                          (document.data() as Map<String, dynamic>)['no']);
                  String Film_adi =
                      ((document.data() as Map<String, dynamic>)['name'] ??
                          'No Title');
                  String Trailer =
                      ((document.data() as Map<String, dynamic>)['trailer'] ??
                          'No Title');
                  ;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 6,
                      ),
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
              ),
            );
          },
        ),
      ),
    );
  }

  */

  @override
  Widget build(BuildContext context) {
    Widget Tus(String text) {
      return Container(
        padding: EdgeInsets.all(5),
     
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 99, 12, 6),
          ),
          onPressed: () {
            setState(() {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return sonuc(text);
              }));
            });
          },
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    String bilim_kurgu = 'Bilim Kurgu';
    String aksiyon = 'Aksiyon';
    String drama = 'Drama';
    String anime = 'Anime';

    Widget buildSearchResults() {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('movies')
            .where('name', isGreaterThanOrEqualTo: searchTerm)
            .where('name', isLessThan: searchTerm + 'z')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Hata: ${snapshot.error}');
          }
          //yükleme ekrani
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(height: 20, child: CircularProgressIndicator()),
            );
          }
          if (searchTerm.isEmpty) {
            Text('Nopeeeee');
          } else {
            return SizedBox(
              width: double.infinity,
              height: 500,
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      snapshot.data!.docs[index];
                  String photoUrl = ((documentSnapshot.data()
                          as Map<String, dynamic>)['photo'] ??
                      'No Title');
                  String Film_adi = ((documentSnapshot.data()
                          as Map<String, dynamic>)['name'] ??
                      'No Title');
                  String Trailer = ((documentSnapshot.data()
                          as Map<String, dynamic>)['trailer'] ??
                      'No Title');
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: SizedBox(
                      child: IntrinsicHeight(
                        child: ListTile(
                          leading: photoUrl.isNotEmpty
                              ? Image.network(
                                  photoUrl,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.image),
                          title: Text(documentSnapshot['name']),
                          subtitle: Text(documentSnapshot['type']),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => Info(
                                    Film_adi: Film_adi, Trailer: Trailer)));
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 6,
            crossAxisSpacing: 10,
            childAspectRatio: 3 / 1,
            children: [
              Tus(bilim_kurgu),
              Tus(aksiyon),
              Tus(drama),
              Tus(anime),
            ],
          );
        },
      );
    }

    return Scaffold(
      
      body: Stack(
        children:[
          Container(
  height: MediaQuery.of(context).size.height,
  width: MediaQuery.of(context).size.width,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.bottomCenter,
      colors: [Color.fromARGB(255, 0, 0, 0),  Color.fromARGB(255, 4, 0, 53)]
    ),
  ),
),
          Column(
          children: [
            SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
              },
              decoration: InputDecoration(
               filled: true,
               hintStyle: TextStyle(color: Colors.yellow),
                hintText: 'aramam sormam',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35.0)),
                ),
                labelText: 'Arama Terimi',
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: buildSearchResults(),
            ),
          ],
        ),] 
      ),
    );
  }
}
//this is just a experiment and used anymore
// bu benim denemelerden Card a resim koyuzo (SIL)istersen
/*
Widget BuildImageCard(String photo) {
  return Card(
    child: Stack(
      children: [
        ListTile(
          leading: Ink.image(
            image: NetworkImage(photo),
            height: 200,
            fit: BoxFit.cover,
          ),
        )
      ],
    ),
  );
}
*/