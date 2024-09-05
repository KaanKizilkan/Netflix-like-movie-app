import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//this class not used anymore its just for some tests
class deneme extends StatefulWidget {
  @override
  _denemeState createState() => _denemeState();
}

class _denemeState extends State<deneme> {
  File? _selectedPhoto;
  String _uploadedImageUrl = '';
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  Future<void> _pickAndUploadPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedPhoto = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadPhoto() async {
    if (_selectedPhoto != null) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = FirebaseStorage.instance.ref().child('photos/$fileName.jpg');
      UploadTask uploadTask = reference.putFile(_selectedPhoto!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _uploadedImageUrl = downloadUrl;
      });

      await FirebaseFirestore.instance.collection('movies').add({
        'photo': downloadUrl,
        'movies': _titleController.text,
        'type': _descriptionController.text,
        "no":'https://firebasestorage.googleapis.com/v0/b/solid-9cc07.appspot.com/o/photos%2Fempty.png?alt=media&token=b52737ff-fbfc-4826-81d9-da5c553471db'
      });

      _titleController.clear();
      _descriptionController.clear();
      _selectedPhoto = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fotoğraf Yükle'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedPhoto != null)
              Image.file(
                _selectedPhoto!,
                width: 200,
                height: 200,
              ),
            ElevatedButton(
              onPressed: _pickAndUploadPhoto,
              child: Text('Fotoğraf Seç'),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Başlık',
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Açıklama',
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadPhoto,
              child: Text('Fotoğrafı Yükle'),
            ),
            if (_uploadedImageUrl.isNotEmpty)
              Text(
                'Yüklenen Fotoğraf: $_uploadedImageUrl',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 16),
            Text(
              'Diğer Alanlarla Liste Örneği:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
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
                      String photoUrl = ((document.data() as Map<String, dynamic>)['photo'] ?? 'No Title');

                      return ListTile(
                        leading: photoUrl.isNotEmpty
                            ? Image.network(
                                photoUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.image),
                        title: Text((document.data() as Map<String, dynamic>)['movies'] ?? 'No Title'),
                        subtitle: Text((document.data() as Map<String, dynamic>)['type'] ?? 'No Title'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: deneme(),
    );
  }
}
