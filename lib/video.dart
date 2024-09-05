import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


//this class not used anymore its used for some tests
/// Stateful widget to fetch and then display video content.
class Video extends StatefulWidget {
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset('images/logo.mp4');
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
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Move the video outside of the screen bounds using Transform and FractionalTranslation
         
                  Transform.scale(
            scaleX: 0.5,
            scaleY:  0.5,
            child: FractionalTranslation(
              translation: Offset(0.0, 1.0),
              child: AspectRatio(
                aspectRatio:1,
                child: VideoPlayer(_videoPlayerController),
              ),
            ),
          ),
        ],
      ),
    );
  }
  }
