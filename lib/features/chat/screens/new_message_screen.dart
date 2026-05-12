import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../shared/widgets/online_dot.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _Contact {
  final String name;
  final String username;
  final String avatar;
  final bool   isOnline;

  const _Contact({
    required this.name,
    required this.username,
    required this.avatar,
    this.isOnline = false,
  });
}

const _contacts = <_Contact>[
  _Contact(name: 'Raffialdo Bayu', username: 'raffialdo',  avatar: 'assets/images/story3.jpg', isOnline: true),
  _Contact(name: 'Debora Ellaria', username: 'deboraell',  avatar: 'assets/images/post4.jpg',  isOnline: true),
  _Contact(name: 'Iko',            username: 'iko',        avatar: 'assets/images/story2.jpg', isOnline: true),
  _Contact(name: 'Ona',            username: 'ona',        avatar: 'assets/images/story1.jpg', isOnline: true),
  _Contact(name: 'Jules H.',       username: 'jules.h',    avatar: 'assets/images/post3.jpg'),
  _Contact(name: 'Barnaby Chris',  username: 'barnaby_c',  avatar: 'assets/images/post5.jpg'),
  _Contact(name: 'Janice Karyl',   username: 'janice.k',   avatar: 'assets/images/post1.jpg'),
  _Contact(name: 'David Keith',    username: 'dkeith',     avatar: 'assets/images/post2.jpg'),
  _Contact(name: 'Mara S.',        username: 'mara.s',     avatar: 'assets/images/post6.jpg'),
  _Contact(name: 'Lev P.',         username: 'lev.p',      avatar: 'assets/images/post7.jpg'),
  _Contact(name: 'Danny K.',       username: 'danny_k',    avatar: 'assets/images/post8.jpg'),
];

const _suggested = <_Contact>[
  _Contact(name: 'Iko',            username: 'iko',       avatar: 'assets/images/story2.jpg', isOnline: true),
  _Contact(name: 'Jules H.',       username: 'jules.h',   avatar: 'assets/images/post3.jpg'),
  _Contact(name: 'Mara S.',        username: 'mara.s',    avatar: 'assets/images/post6.jpg'),
  _Contact(name: 'Ona',            username: 'ona',       avatar: 'assets/images/story1.jpg', isOnline: true),
  _Contact(name: 'Danny K.',       username: 'danny_k',   avatar: 'assets/images/post8.jpg'),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class NewMessageScreen extends StatefulWidget {
  const NewMessageScreen({super.key});

  @override
  State<NewMessageScreen> createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  final _searchController = TextEditingController();
  final _searchFocus      = FocusNode();

  bool              _isGroupMode = false;
  String            _query       = '';
  final Set<String> _selected    = {};   // contact usernames

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  List<_Contact> get _filtered => _query.isEmpty
      ? _contacts
      : _contacts.where((c) =>
            c.name.toLowerCase().contains(_query) ||
            c.username.toLowerCase().contains(_query))
          .toList();

  _Contact? _contactByUsername(String username) =>
      _contacts.where((c) => c.username == username).firstOrNull;

  void _toggleSelect(_Contact c) {
    setState(() {
      _selected.contains(c.username)
          ? _selected.remove(c.username)
          : _selected.add(c.username);
    });
  }

  void _onContactTap(_Contact c) {
    if (_isGroupMode) {
      _toggleSelect(c);
    } else {
      // Direct message — open chat immediately
      Get.toNamed(AppRoutes.chatView, parameters: {'name': c.name});
    }
  }

  void _onNext() {
    if (_selected.isEmpty) return;

    if (_isGroupMode && _selected.length >= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Group created with ${_selected.length} members'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    } else if (!_isGroupMode && _selected.length == 1) {
      final c = _contactByUsername(_selected.first);
      if (c != null) Get.toNamed(AppRoutes.chatView, parameters: {'name': c.name});
    } else {
      // Single person in group mode → treat as DM
      final c = _contactByUsername(_selected.first);
      if (c != null) Get.toNamed(AppRoutes.chatView, parameters: {'name': c.name});
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final hasSelection = _selected.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── App bar ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      _isGroupMode ? 'New Group' : 'New Message',
                      style: const TextStyle(
                        fontSize:   20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity:  hasSelection ? 1 : 0.35,
                    child: TextButton(
                      onPressed: hasSelection ? _onNext : null,
                      child: Text(
                        _isGroupMode ? 'Create' : 'Chat',
                        style: const TextStyle(
                          color:      Color(0xFF0095F6),
                          fontWeight: FontWeight.w700,
                          fontSize:   15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── "To:" chip field ──────────────────────────────────────────
            _ToField(
              selected:   _selected,
              contacts:   _contacts,
              controller: _searchController,
              focusNode:  _searchFocus,
              onRemove:   (username) => setState(() => _selected.remove(username)),
            ),

            const Divider(height: 1, thickness: 0.5),

            // ── Body ─────────────────────────────────────────────────────
            Expanded(
              child: ListView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  // Create a group row
                  _CreateGroupTile(
                    isActive: _isGroupMode,
                    onTap: () => setState(() {
                      _isGroupMode = !_isGroupMode;
                      _selected.clear();
                    }),
                  ),

                  // Suggested section (hide when searching)
                  if (_query.isEmpty) ...[
                    const _SectionHeader(label: 'Suggested'),
                    _SuggestedStrip(
                      contacts:      _suggested,
                      selected:      _selected,
                      isGroupMode:   _isGroupMode,
                      onTap:         _onContactTap,
                    ),
                    const Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16),
                    const SizedBox(height: 8),
                  ],

                  // Contact list
                  ..._filtered.map(
                    (c) => _ContactTile(
                      contact:    c,
                      isSelected: _selected.contains(c.username),
                      groupMode:  _isGroupMode,
                      onTap:      () => _onContactTap(c),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── To: field ────────────────────────────────────────────────────────────────

class _ToField extends StatelessWidget {
  final Set<String>          selected;
  final List<_Contact>       contacts;
  final TextEditingController controller;
  final FocusNode            focusNode;
  final ValueChanged<String> onRemove;

  const _ToField({
    required this.selected,
    required this.contacts,
    required this.controller,
    required this.focusNode,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 180),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 120),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          child: Wrap(
            spacing:     8,
            runSpacing:  8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // "To:" label
              const Text(
                'To:',
                style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
              ),

              // Chips
              ...selected.map((username) {
                final contact = contacts.where((c) => c.username == username).firstOrNull;
                if (contact == null) return const SizedBox.shrink();
                return _Chip(
                  contact:  contact,
                  onRemove: () => onRemove(username),
                );
              }),

              // Input
              IntrinsicWidth(
                child: TextField(
                  controller:  controller,
                  focusNode:   focusNode,
                  style:       const TextStyle(fontSize: 15),
                  decoration:  const InputDecoration(
                    hintText:       'Search...',
                    hintStyle:      TextStyle(color: Colors.grey),
                    border:         InputBorder.none,
                    isDense:        true,
                    contentPadding: EdgeInsets.symmetric(vertical: 6),
                    constraints:    BoxConstraints(minWidth: 80),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final _Contact     contact;
  final VoidCallback onRemove;
  const _Chip({required this.contact, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 4, 8, 4),
      decoration: BoxDecoration(
        color:        const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 12, backgroundImage: AssetImage(contact.avatar)),
          const SizedBox(width: 6),
          Text(
            contact.name.split(' ').first,
            style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0095F6),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close_rounded, size: 15, color: Color(0xFF0095F6)),
          ),
        ],
      ),
    );
  }
}

// ─── Create group tile ────────────────────────────────────────────────────────

class _CreateGroupTile extends StatelessWidget {
  final bool         isActive;
  final VoidCallback onTap;
  const _CreateGroupTile({required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color:        isActive ? const Color(0xFF0095F6) : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.group_add_rounded,
                color: isActive ? Colors.white : Colors.black87,
                size:  26,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isActive ? 'Cancel group' : 'Create a group',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  isActive ? 'Select 2 or more people' : 'Chat with multiple friends at once',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Section header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize:   14,
          color:      Colors.black54,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ─── Suggested horizontal strip ───────────────────────────────────────────────

class _SuggestedStrip extends StatelessWidget {
  final List<_Contact> contacts;
  final Set<String>    selected;
  final bool           isGroupMode;
  final void Function(_Contact) onTap;

  const _SuggestedStrip({
    required this.contacts,
    required this.selected,
    required this.isGroupMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding:         const EdgeInsets.symmetric(horizontal: 16),
        itemCount:       contacts.length,
        itemBuilder: (_, i) {
          final c          = contacts[i];
          final isSelected = selected.contains(c.username);

          return GestureDetector(
            onTap: () => onTap(c),
            child: Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      // Avatar
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: const Color(0xFF0095F6), width: 2.5)
                              : null,
                        ),
                        child: CircleAvatar(
                          radius:          28,
                          backgroundImage: AssetImage(c.avatar),
                        ),
                      ),
                      if (c.isOnline)
                        const Positioned(right: 2, bottom: 2, child: OnlineDot()),
                      // Check badge
                      if (isSelected)
                        Positioned(
                          right: 0, bottom: 0,
                          child: Container(
                            width: 20, height: 20,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0095F6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check_rounded, color: Colors.white, size: 13),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 60,
                    child: Text(
                      c.name.split(' ').first,
                      textAlign: TextAlign.center,
                      overflow:  TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize:   12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color:      isSelected ? const Color(0xFF0095F6) : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Contact list tile ────────────────────────────────────────────────────────

class _ContactTile extends StatelessWidget {
  final _Contact     contact;
  final bool         isSelected;
  final bool         groupMode;
  final VoidCallback onTap;

  const _ContactTile({
    required this.contact,
    required this.isSelected,
    required this.groupMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Avatar + online dot
            Stack(
              children: [
                CircleAvatar(
                  radius:          26,
                  backgroundImage: AssetImage(contact.avatar),
                ),
                if (contact.isOnline)
                  const Positioned(right: 1, bottom: 1, child: OnlineDot()),
              ],
            ),
            const SizedBox(width: 14),

            // Name + username
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '@${contact.username}',
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                ],
              ),
            ),

            // Selection indicator (group mode) or chevron (DM mode)
            if (groupMode)
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width:  26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? const Color(0xFF0095F6) : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF0095F6) : Colors.grey[350]!,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                    : null,
              )
            else
              Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
