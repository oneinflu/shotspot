import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:share_plus/share_plus.dart';

class ShotsReelScreen extends StatefulWidget {
  final List<dynamic> shots;
  final int initialIndex;

  const ShotsReelScreen({
    super.key,
    required this.shots,
    this.initialIndex = 0,
  });

  @override
  State<ShotsReelScreen> createState() => _ShotsReelScreenState();
}

class _ShotsReelScreenState extends State<ShotsReelScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: widget.shots.length,
        itemBuilder: (context, index) {
          return ReelItem(shot: widget.shots[index]);
        },
      ),
    );
  }
}

class ReelItem extends StatefulWidget {
  final dynamic shot;
  const ReelItem({super.key, required this.shot});

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    setState(() {
      _initialized = false;
      _hasError = false;
    });

    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.shot['videoUrl'] ?? 'https://assets.mixkit.co/videos/preview/mixkit-girl-in-neon-lighting-in-the-rain-31350-large.mp4'),
      );
      
      await _controller.initialize();
      if (mounted) {
        setState(() {
          _initialized = true;
          _hasError = false;
        });
        _controller.play();
        _controller.setLooping(true);
      }
    } catch (e) {
      debugPrint('Video init error: $e');
      if (mounted) {
        setState(() {
          _initialized = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (_initialized)
          GestureDetector(
            onTap: () {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
              setState(() {});
            },
            child: VideoPlayer(_controller),
          )
        else if (_hasError)
          _buildErrorUI()
        else
          _buildLoadingUI(),
        
        // Dark Overlay at bottom
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.6),
                ],
                stops: const [0.7, 0.85, 1.0],
              ),
            ),
          ),
        ),

        // Back Button
        Positioned(
          top: 50,
          left: 20,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            ),
          ),
        ),

        // Bottom Info
        Positioned(
          bottom: 40,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '@${widget.shot['artist'].toString().replaceAll(' ', '_').toLowerCase()}',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Follow',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                widget.shot['title'] ?? 'Untitled Shot',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.music_note_rounded, color: Colors.white, size: 14),
                  const SizedBox(width: 5),
                  Text(
                    'Original Audio • ShotSpot',
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Right Actions (Share only)
        Positioned(
          bottom: 40,
          right: 20,
          child: Column(
            children: [
              _buildActionButton(
                Icons.ios_share_rounded,
                'Share',
                () => Share.share('Check out this shot on ShotSpot! ${widget.shot['videoUrl']}'),
              ),
            ],
          ),
        ),

        // Pause/Play Indicator
        if (!_controller.value.isPlaying && _initialized)
          const Center(
            child: Icon(Icons.play_arrow_rounded, color: Colors.white54, size: 80),
          ),
      ],
    );
  }

  Widget _buildLoadingUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFFE91E63),
            strokeWidth: 2,
          ),
          const SizedBox(height: 20),
          Text(
            'Preparing your shot...',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorUI() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, color: Color(0xFFE91E63), size: 40),
            const SizedBox(height: 20),
            Text(
              'Oops! Couldn\'t load video',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Please check your connection and try again',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 25),
            GestureDetector(
              onTap: _initializeController,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFE91E63), Color(0xFFFF5252)]),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'Retry',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
