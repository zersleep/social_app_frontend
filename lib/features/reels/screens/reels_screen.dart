import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/reel_model.dart';
import '../widgets/reel_item.dart';
import 'reel_camera_screen.dart';

// ─── Mock data ────────────────────────────────────────────────────────────────

const _forYouReels = <ReelModel>[
  ReelModel(
    id:           'fy1',
    videoPath:    'assets/videos/reel1.mp4',
    username:     'm.a.a.m.e',
    profileImage: 'assets/images/story1.jpg',
    caption:      'Living my best life ✨ no plan, no map, just vibes',
    audioTitle:   'Original audio · m.a.a.m.e',
    likeCount:    5200,
    commentCount: 348,
    shareCount:   1200,
  ),
  ReelModel(
    id:           'fy2',
    videoPath:    'assets/videos/reel2.mp4',
    username:     'travel',
    profileImage: 'assets/images/story2.jpg',
    caption:      'Beautiful sunset vibes 🌅 nothing beats this view',
    audioTitle:   'Sunset Feelings · Lofi Mix',
    likeCount:    12400,
    commentCount: 892,
    shareCount:   3100,
    isFollowing:  true,
  ),
  ReelModel(
    id:           'fy3',
    videoPath:    'assets/videos/reel3.mp4',
    username:     'football',
    profileImage: 'assets/images/story3.jpg',
    caption:      'Beach vibes ⚽ game of the season right here',
    audioTitle:   'Champion · Trending',
    likeCount:    8700,
    commentCount: 512,
    shareCount:   2200,
  ),
];

const _friendsReels = <ReelModel>[
  ReelModel(
    id:           'fr1',
    videoPath:    'assets/videos/reel2.mp4',
    username:     'jules.h',
    profileImage: 'assets/images/story3.jpg',
    caption:      'Paris calling 🗼 spontaneous weekend, zero regrets',
    audioTitle:   'La Vie en Rose · Edit',
    likeCount:    1840,
    commentCount: 123,
    shareCount:   340,
    isFollowing:  true,
  ),
  ReelModel(
    id:           'fr2',
    videoPath:    'assets/videos/reel3.mp4',
    username:     'iko',
    profileImage: 'assets/images/story2.jpg',
    caption:      'Cap Ferret golden hour 🌊 film never looked this good',
    audioTitle:   'Original audio · iko',
    likeCount:    924,
    commentCount: 67,
    shareCount:   180,
    isFollowing:  true,
  ),
  ReelModel(
    id:           'fr3',
    videoPath:    'assets/videos/reel1.mp4',
    username:     'mara.s',
    profileImage: 'assets/images/post2.jpg',
    caption:      'Morning run energy 🏃‍♀️ best way to start the day',
    audioTitle:   'Run The World · Edit',
    likeCount:    560,
    commentCount: 34,
    shareCount:   90,
    isFollowing:  true,
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  int _tab          = 0; // 0 = For You  |  1 = Friends
  int _currentIndex = 0;

  List<ReelModel> get _reels => _tab == 0 ? _forYouReels : _friendsReels;

  void _switchTab(int tab) {
    if (tab == _tab) return;
    setState(() {
      _tab          = tab;
      _currentIndex = 0;
    });
  }

  void _openCamera() => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const ReelCameraScreen()),
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor:            Colors.transparent,
      statusBarIconBrightness:   Brightness.light,
      statusBarBrightness:       Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Reel PageView — ValueKey(_tab) forces a fresh view on tab switch
          PageView.builder(
            key:             ValueKey(_tab),
            scrollDirection: Axis.vertical,
            itemCount:       _reels.length,
            onPageChanged:   (i) => setState(() => _currentIndex = i),
            itemBuilder:     (_, i) => ReelItem(
              reel:     _reels[i],
              isActive: i == _currentIndex,
            ),
          ),

          // Floating top bar (overlaid above video)
          _TopBar(
            tab:         _tab,
            onTabChange: _switchTab,
            onCreate:    _openCamera,
          ),
        ],
      ),
    );
  }
}

// ─── Top bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final int               tab;
  final ValueChanged<int> onTabChange;
  final VoidCallback      onCreate;

  const _TopBar({
    required this.tab,
    required this.onTabChange,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Create
            GestureDetector(
              onTap: onCreate,
              child: const Icon(Icons.add_box_outlined, color: Colors.white, size: 28),
            ),
            const Spacer(),

            // Tabs
            _TabBtn(
              label:    'For You',
              selected: tab == 0,
              onTap:    () => onTabChange(0),
            ),
            const SizedBox(width: 20),
            _TabBtn(
              label:    'Friends',
              selected: tab == 1,
              onTap:    () => onTabChange(1),
            ),

            const Spacer(),
            const Icon(Icons.search_rounded, color: Colors.white, size: 26),
          ],
        ),
      ),
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String       label;
  final bool         selected;
  final VoidCallback onTap;

  const _TabBtn({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color:      selected ? Colors.white : Colors.white60,
              fontSize:   selected ? 17 : 15,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width:  selected ? 20 : 0,
            height: 2,
            decoration: BoxDecoration(
              color:        Colors.white,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }
}
