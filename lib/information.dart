import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Info extends StatefulWidget {
  final String Film_adi;
  final String Trailer;

  const Info({Key? key, required this.Film_adi, required this.Trailer})
      : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  late VideoPlayerController _videoPlayerController;
  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.Trailer));
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      await _videoPlayerController.initialize();
      _videoPlayerController.play();
      _videoPlayerController.setLooping(false);
    } catch (error) {
      // Handle video initialization errors if any.
    }
  }

  @override
  void dispose() {
    _videoPlayerController.pause();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 17, 17, 17),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 99, 12, 6),
      ),
      body: Column(children: [
        Container(
          height: 250,
          child: VideoPlayer(_videoPlayerController),
        ),
        Expanded(
          child: Text(widget.Film_adi,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        )
      ]),
    );
  }
}
