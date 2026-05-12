import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/online_dot.dart';
import '../chat_models.dart';
import '../mock_chats.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_message_tile.dart';
import '../widgets/chat_search_bar.dart';
import '../widgets/chat_stories.dart';

// ─── Static mock data used by the overlay ────────────────────────────────────

class _Person {
  final String name;
  final String username;
  final String avatar;
  final bool   isOnline;
  const _Person({required this.name, required this.username, required this.avatar, this.isOnline = false});
}

const _suggested = <_Person>[
  _Person(name: 'Iko',            username: 'iko',       avatar: 'assets/images/story2.jpg', isOnline: true),
  _Person(name: 'Jules H.',       username: 'jules.h',   avatar: 'assets/images/post3.jpg'),
  _Person(name: 'Mara S.',        username: 'mara.s',    avatar: 'assets/images/post6.jpg'),
  _Person(name: 'Ona',            username: 'ona',       avatar: 'assets/images/story1.jpg', isOnline: true),
  _Person(name: 'Lev P.',         username: 'lev.p',     avatar: 'assets/images/post7.jpg'),
  _Person(name: 'Danny K.',       username: 'danny_k',   avatar: 'assets/images/post8.jpg'),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  // Search state
  final _searchController = TextEditingController();
  final _searchFocus      = FocusNode();
  bool   _searchActive    = false;
  String _query           = '';

  // Recent searches (mutable)
  final List<String> _recents = ['Iko', 'jules.h', 'Raffialdo'];

  // Animation
  late final AnimationController _animCtrl;
  late final Animation<double>   _fadeAnim;
  late final Animation<Offset>   _slideAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 280),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));

    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  // ── Search lifecycle ─────────────────────────────────────────────────────────

  void _activateSearch() {
    if (_searchActive) return;
    setState(() => _searchActive = true);
    _animCtrl.forward();
    _searchFocus.requestFocus();
  }

  void _cancelSearch() {
    _searchFocus.unfocus();
    _searchController.clear();
    _animCtrl.reverse().whenComplete(() {
      if (mounted) setState(() { _searchActive = false; _query = ''; });
    });
  }

  void _submitSearch(String term) {
    if (term.trim().isEmpty) return;
    setState(() {
      _recents.remove(term);
      _recents.insert(0, term);
      if (_recents.length > 8) _recents.removeLast();
    });
  }

  void _removeRecent(String term) => setState(() => _recents.remove(term));
  void _clearAllRecents()          => setState(() => _recents.clear());

  // ── Filtered results ─────────────────────────────────────────────────────────

  List<ChatMessage> get _filteredMessages => _query.isEmpty
      ? []
      : mockMessages
          .where((m) => m.name.toLowerCase().contains(_query))
          .toList();

  List<_Person> get _filteredPeople => _query.isEmpty
      ? []
      : _suggested
          .where((p) =>
              p.name.toLowerCase().contains(_query) ||
              p.username.toLowerCase().contains(_query))
          .toList();

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // ── Main chat content ────────────────────────────────────────
            _ChatBody(
              searchController: _searchController,
              searchFocus:      _searchFocus,
              searchActive:     _searchActive,
              onSearchTap:      _activateSearch,
              onSearchCancel:   _cancelSearch,
            ),

            // ── Search overlay ───────────────────────────────────────────
            if (_searchActive)
              _SearchOverlay(
                fadeAnim:       _fadeAnim,
                slideAnim:      _slideAnim,
                query:          _query,
                recents:        _recents,
                filteredMsg:    _filteredMessages,
                filteredPeople: _filteredPeople,
                onRemoveRecent: _removeRecent,
                onClearAll:     _clearAllRecents,
                onRecentTap: (term) {
                  _searchController.text = term;
                  _searchController.selection = TextSelection.fromPosition(
                    TextPosition(offset: term.length),
                  );
                },
                onPersonTap: (person) {
                  _submitSearch(person.name);
                  Get.toNamed(AppRoutes.chatView, parameters: {'name': person.name});
                },
                onMessageTap: (msg) {
                  _submitSearch(msg.name);
                  Get.toNamed(AppRoutes.chatView, parameters: {'name': msg.name});
                },
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Main chat body ───────────────────────────────────────────────────────────

class _ChatBody extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode             searchFocus;
  final bool                  searchActive;
  final VoidCallback          onSearchTap;
  final VoidCallback          onSearchCancel;

  const _ChatBody({
    required this.searchController,
    required this.searchFocus,
    required this.searchActive,
    required this.onSearchTap,
    required this.onSearchCancel,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: ChatAppBar()),

        SliverToBoxAdapter(
          child: ChatSearchBar(
            controller: searchController,
            focusNode:  searchFocus,
            isActive:   searchActive,
            onTap:      onSearchTap,
            onCancel:   onSearchCancel,
          ),
        ),

        SliverToBoxAdapter(
          child: ChatStoriesSection(stories: mockStories),
        ),

        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 14, 20, 6),
            child: Text(
              'Messages',
              style: TextStyle(
                fontSize:      20,
                fontWeight:    FontWeight.w800,
                color:         Colors.black,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ),

        SliverList.builder(
          itemCount:   mockMessages.length,
          itemBuilder: (_, i) => ChatMessageTile(message: mockMessages[i]),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }
}

// ─── Search overlay ───────────────────────────────────────────────────────────

class _SearchOverlay extends StatelessWidget {
  final Animation<double> fadeAnim;
  final Animation<Offset> slideAnim;
  final String            query;
  final List<String>      recents;
  final List<ChatMessage> filteredMsg;
  final List<_Person>     filteredPeople;
  final void Function(String)      onRemoveRecent;
  final VoidCallback               onClearAll;
  final void Function(String)      onRecentTap;
  final void Function(_Person)     onPersonTap;
  final void Function(ChatMessage) onMessageTap;

  const _SearchOverlay({
    required this.fadeAnim,
    required this.slideAnim,
    required this.query,
    required this.recents,
    required this.filteredMsg,
    required this.filteredPeople,
    required this.onRemoveRecent,
    required this.onClearAll,
    required this.onRecentTap,
    required this.onPersonTap,
    required this.onMessageTap,
  });

  @override
  Widget build(BuildContext context) {
    // Offset from top: app bar (~56) + search bar (~58)
    const topOffset = 114.0;

    return Positioned(
      top:   topOffset,
      left:  0,
      right: 0,
      bottom: 0,
      child: FadeTransition(
        opacity: fadeAnim,
        child: SlideTransition(
          position: slideAnim,
          child: Container(
            color: Colors.white,
            child: query.isEmpty
                ? _IdleContent(
                    recents:        recents,
                    suggested:      _suggested,
                    onRemoveRecent: onRemoveRecent,
                    onClearAll:     onClearAll,
                    onRecentTap:    onRecentTap,
                    onPersonTap:    onPersonTap,
                    fadeAnim:       fadeAnim,
                  )
                : _ResultsContent(
                    query:          query,
                    messages:       filteredMsg,
                    people:         filteredPeople,
                    onMessageTap:   onMessageTap,
                    onPersonTap:    onPersonTap,
                  ),
          ),
        ),
      ),
    );
  }
}

// ─── Idle overlay (recent + suggested) ───────────────────────────────────────

class _IdleContent extends StatelessWidget {
  final List<String>           recents;
  final List<_Person>          suggested;
  final void Function(String)  onRemoveRecent;
  final VoidCallback           onClearAll;
  final void Function(String)  onRecentTap;
  final void Function(_Person) onPersonTap;
  final Animation<double>      fadeAnim;

  const _IdleContent({
    required this.recents,
    required this.suggested,
    required this.onRemoveRecent,
    required this.onClearAll,
    required this.onRecentTap,
    required this.onPersonTap,
    required this.fadeAnim,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // ── Recent searches ────────────────────────────────────────────
        if (recents.isNotEmpty) ...[
          _OverlayHeader(
            label:    'Recent',
            trailing: GestureDetector(
              onTap: onClearAll,
              child: const Text(
                'Clear all',
                style: TextStyle(color: Color(0xFF0095F6), fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          ...recents.asMap().entries.map((e) {
            final delay = e.key * 0.06;
            return _StaggerItem(
              animation: fadeAnim,
              delay:     delay,
              child: _RecentTile(
                term:     e.value,
                onTap:    () => onRecentTap(e.value),
                onRemove: () => onRemoveRecent(e.value),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],

        // ── Suggested ─────────────────────────────────────────────────
        _OverlayHeader(label: 'Suggested'),
        ...suggested.asMap().entries.map((e) {
          final delay = (recents.length + e.key) * 0.05;
          return _StaggerItem(
            animation: fadeAnim,
            delay:     delay,
            child: _PersonTile(
              person:  e.value,
              onTap:   () => onPersonTap(e.value),
            ),
          );
        }),

        const SizedBox(height: 40),
      ],
    );
  }
}

// ─── Results overlay (query active) ──────────────────────────────────────────

class _ResultsContent extends StatelessWidget {
  final String            query;
  final List<ChatMessage> messages;
  final List<_Person>     people;
  final void Function(ChatMessage) onMessageTap;
  final void Function(_Person)     onPersonTap;

  const _ResultsContent({
    required this.query,
    required this.messages,
    required this.people,
    required this.onMessageTap,
    required this.onPersonTap,
  });

  @override
  Widget build(BuildContext context) {
    final empty = messages.isEmpty && people.isEmpty;

    if (empty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 52, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              'No results for "$query"',
              style: TextStyle(color: Colors.grey[500], fontSize: 15),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        if (people.isNotEmpty) ...[
          _OverlayHeader(label: 'People'),
          ...people.map((p) => _PersonTile(person: p, onTap: () => onPersonTap(p))),
        ],
        if (messages.isNotEmpty) ...[
          _OverlayHeader(label: 'Messages'),
          ...messages.map((m) => _MessageResultTile(message: m, onTap: () => onMessageTap(m))),
        ],
        const SizedBox(height: 40),
      ],
    );
  }
}

// ─── Stagger animation wrapper ────────────────────────────────────────────────

class _StaggerItem extends StatefulWidget {
  final Animation<double> animation;
  final double            delay;
  final Widget            child;

  const _StaggerItem({required this.animation, required this.delay, required this.child});

  @override
  State<_StaggerItem> createState() => _StaggerItemState();
}

class _StaggerItemState extends State<_StaggerItem> {
  late CurvedAnimation _interval;

  @override
  void initState() {
    super.initState();
    _interval = CurvedAnimation(
      parent: widget.animation,
      curve:  Interval(
        widget.delay.clamp(0, 0.9),
        (widget.delay + 0.4).clamp(0.0, 1.0),
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _interval.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _interval,
      builder: (_, child) => Opacity(
        opacity: _interval.value,
        child:   Transform.translate(
          offset: Offset(0, 16 * (1 - _interval.value)),
          child:  child,
        ),
      ),
      child: widget.child,
    );
  }
}

// ─── Shared section header ────────────────────────────────────────────────────

class _OverlayHeader extends StatelessWidget {
  final String  label;
  final Widget? trailing;
  const _OverlayHeader({required this.label, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 6),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black54),
          ),
          const Spacer(),
          ?trailing,
        ],
      ),
    );
  }
}

// ─── Recent search tile ───────────────────────────────────────────────────────

class _RecentTile extends StatelessWidget {
  final String       term;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  const _RecentTile({required this.term, required this.onTap, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Row(
          children: [
            Container(
              width:  38,
              height: 38,
              decoration: BoxDecoration(
                color:        Colors.grey[100],
                shape:        BoxShape.circle,
              ),
              child: const Icon(Icons.history_rounded, color: Colors.black54, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                term,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            GestureDetector(
              onTap: onRemove,
              child: Icon(Icons.close_rounded, size: 18, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Suggested person tile ────────────────────────────────────────────────────

class _PersonTile extends StatelessWidget {
  final _Person      person;
  final VoidCallback onTap;
  const _PersonTile({required this.person, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(radius: 22, backgroundImage: AssetImage(person.avatar)),
                if (person.isOnline)
                  const Positioned(right: 1, bottom: 1, child: OnlineDot()),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(person.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  Text('@${person.username}', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

// ─── Message result tile ──────────────────────────────────────────────────────

class _MessageResultTile extends StatelessWidget {
  final ChatMessage  message;
  final VoidCallback onTap;
  const _MessageResultTile({required this.message, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(radius: 22, backgroundImage: AssetImage(message.avatar)),
                if (message.isOnline)
                  const Positioned(right: 1, bottom: 1, child: OnlineDot()),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  Text(
                    message.lastMessage,
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(message.time, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
