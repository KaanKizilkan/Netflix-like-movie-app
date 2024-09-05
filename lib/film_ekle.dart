import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class filmekle extends StatefulWidget {
  @override
  _filmekleState createState() => _filmekleState();
}

class _filmekleState extends State<filmekle> {
  String? errorMassege = '';
  bool clicked = false;
  String? get _errorText {
    // at any time, we can get the text from _controller.value.text
    final text = _controller.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (clicked == true) {
      if (text.isEmpty) {
        return 'Can\'t be empty';
      }
    }

    // return null if the text is valid
    return null;
  }

  void isclicked() {
    setState(() {
      clicked = true;
    });
    return null;
  }

  final _controller = TextEditingController();

  final db = FirebaseFirestore.instance;
  String name = '';
  String model = 'movies';
  String cast = '';
  String type = '';
  String resim = '';
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void >bilgileriKaydet()async {
    // Create a new user with a first and last name
    final user = <String, dynamic>{
      "name": name,
      "model": model,
      "cast": cast,
      "type": type,
      "no":
          'https://firebasestorage.googleapis.com/v0/b/solid-9cc07.appspot.com/o/photos%2Fempty.png?alt=media&token=b52737ff-fbfc-4826-81d9-da5c553471db',
      "time": Timestamp.now(),
      "photo": resim,
    };

// Add a new document with a generated ID


       await db.collection("movies").add(user).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));

    print('Film adı: $name');
    print('Oyuncu Adı: $cast');
    print('Türü: $type');
  
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title:  Text(errorMassege=='' ? 'Başarılı':'Basarisiz'),
          content:  Text('Filminiz başarıyla eklenmiştir'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    
  }

  Future<String> pickAndUploadPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File photo = File(pickedFile.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference =
          FirebaseStorage.instance.ref().child('photos/$fileName.jpg');
      UploadTask uploadTask = reference.putFile(photo);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        resim = downloadUrl;
      });
      return resim;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Film Ekleme'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text('Film ya da Dizi seçimi:      '),
                DropdownButton<String>(
                  value: model,
                  items: const [
                    DropdownMenuItem<String>(
                        value: 'movies', child: Text('Film')),
                    DropdownMenuItem<String>(
                        value: 'tv_series', child: Text('Dizi'))
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      model = newValue!;
                    });
                  },
                ),
              ],
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Film Adı',
                errorText: _errorText,
              ),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            TextFormField(
              
              decoration: InputDecoration(
                  labelText: 'Oyuncu Adı', errorText: _errorText),
              onChanged: (value) {
                setState(() {
                  cast = value;
                });
              },
            ),
            TextFormField(
    
              decoration:
                  InputDecoration(labelText: 'Türü', errorText: _errorText),
              obscureText: false,
              onChanged: (value) {
                setState(() {
                  type = value;
                });
              },
            ),
            Row(
              children: [
                Text('Filmk Kapağı resmini seç:            '),
                IconButton(
                    onPressed: pickAndUploadPhoto, icon: Icon(Icons.upload)),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _controller.value.text.isNotEmpty
                  ? bilgileriKaydet
                  : isclicked,
                  
              child: Text('Bilgileri Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
