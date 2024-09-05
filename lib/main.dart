

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:yeni/ana_sayfa.dart';
import 'package:yeni/film_ekle.dart';
import 'package:yeni/intro.dart';

import 'firebase_options.dart';
import 'package:yeni/film_sil.dart';
import 'package:yeni/arama.dart';
import 'kategori.dart';
import 'deneme.dart';
import 'package:yeni/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create a new user with a first and last name

    return MaterialApp(
      title: 'SolidBlood',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Intro(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  final User? user = Auth().currnetUser;
  int selected = 0;
  String photoUrl = '';
//sag ustteki 3 noktanın basınca yapacakları
  void handleClick(String value) {
    switch (value) {
      case 'Film ekle':
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return filmekle();
        }));
        break;
      case 'Film sil':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) {
            return filmsil();
          },
        ));
        break;
      case 'Kategoriler':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext) {
            return kategoriler();
          },
        ));
        break;
      case 'Deneme':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) {
            return deneme();
          },
        ));
    }
  }



  Future<void> SignOut() async {
    await Auth().signOut();
  }

  Widget _signOutButton() {
    return TextButton(
      onPressed: SignOut,
      child: Text(
        'Oturumu Kapat',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.6)),
      ),
    );
  }

  /*Widget MyCard(String photoUrl) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 105,
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                photoUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      );*/

/* just some tests
 final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;//SIL

    User? get currnetUser =>  _firebaseAuth.currentUser;
    String veri='';

    Future<void> inputData(String veri) async {// SIL
  FirebaseAuth.instance
    .authStateChanges()
    .listen((User? user) {
      if (user != null) {
        setState(() {
          veri=user.uid;
        });
      }
    });
}
*/
   
    /* just some tests
    String admin='9HOoNGVbHNPcjMTaMmW0kpjvjZF3';//sonra SIL
    bool creator=false;//SIL
    String get _deneme{
       FirebaseAuth.instance
    .authStateChanges()
    .listen((User? user) {
      if (user != null) {
        setState(() {
          veri=user.uid;
        });
      }
    });

    return veri;
    }
    */
   
   Widget DrawerItems(String secim){
   return ListTile(
                title:  Text(secim),
                onTap: () {handleClick(secim);
                  // Update the state of the app.
                  // ...
                },
              );
}


/* just some tests
  Future<bool> Deli()async{// SONRA SIL
    await inputData(veri);
    if(veri==admin){
      setState(() {
        creator=true;
      });
      
      return creator;
    }
     return false;
  
}
*/
  @override
  Widget build(BuildContext context) {
   
    String movies = 'movies';
    String tv_series = 'tv_series';
    return Scaffold(
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.centerRight,
                    colors: <Color>[
                  Color.fromARGB(255, 0, 0, 0),
                  Color.fromARGB(255, 145, 2, 2)
                ])
                ),
                child: Text('Profiliniz'),
              ),
              
            
            
              

                  Text(' Ayarlar'),
                  DrawerItems('Film ekle'),
                  DrawerItems('Film sil'),
                  DrawerItems('Deneme'),
                  DrawerItems('Kategoriler'),
                  

             
              
                 
                  SizedBox(
                    height: 430,
                  ),
              
             
            
               
                 
                  Align(alignment: AlignmentDirectional.bottomCenter,
                    child: _signOutButton()),
               
            ],
          ),
        ),
        endDrawerEnableOpenDragGesture: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Material(
              //Ink Image?
              child: Image.asset(
                'images/logoo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.centerRight,
                    colors: <Color>[
                  Color.fromARGB(255, 0, 0, 0),
                  Color.fromARGB(255, 145, 2, 2)
                ])),
          ),
          backgroundColor: Colors.black,
          title: Text('Solid Blood'),
          actions: <Widget>[

            //not used anymore
            //bu sagdaki 3 nokta nin secenekleri
           /* PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Film ekle', 'Film sil', 'Kategoriler', 'Deneme'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),*/
          ],
        ),
        body: <Widget>[
          //burası bottomnavigation ı kullanmak için wraplenmiş
          //olaylar burda patlıyor
          ListView(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 300,
                  child: FutureBuilder<Object>(builder: (context, snapshot) {
                    return LastlyAdded();
                  }),
                ),
                
                Text(
                  'Filmler',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 160,
                  child: FutureBuilder<Object>(builder: (context, snapshot) {
                    return WatchSomething(movies);
                  }),
                ),
                Text(
                  'Diziler',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 175,
                  width: double.infinity,
                  child: FutureBuilder<Object>(builder: (context, snapshot) {
                    return WatchSomething(tv_series);
                  }),
                ),
               
              ],
            ),
          ]),

          arama(), //arama classı na geçmek için selected kullanılıyor
        ][selected], //selected bottom navigation bar daki selected ı kullanarak geçis yapıyor

        //alt kısım
        bottomNavigationBar: _createBottomNavigationBar());
  }

  //Gradient eklemek icin bottom navigation bari buna donusturdum
  Widget _createBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 151, 1, 1),
            Color.fromARGB(255, 0, 0, 0)
          ],
          begin: Alignment.centerLeft,
          end: Alignment.topRight,
          stops: [0.0, 0.8],
          tileMode: TileMode.clamp,
        ),
      ),
      child: NavigationBar(
        backgroundColor: Colors.transparent,
        indicatorColor: Colors.white.withOpacity(0.2),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            selected = index;
          });
        },
        selectedIndex: selected,
      ),
    );
  }
}
