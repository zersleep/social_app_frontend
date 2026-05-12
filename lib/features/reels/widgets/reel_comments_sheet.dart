import 'package:flutter/material.dart';

class _Comment {
  final String username;
  final String avatar;
  final String text;
  final String time;
  final int    likes;

  const _Comment({
    required this.username,
    required this.avatar,
    required this.text,
    required this.time,
    required this.likes,
  });
}

const _seed = <_Comment>[
  _Comment(username: 'iko',      avatar: 'assets/images/story2.jpg', text: 'This is fire 🔥',                          time: '2h',  likes: 234),
  _Comment(username: 'jules.h',  avatar: 'assets/images/story3.jpg', text: 'Incredible — where is this?? 😍',          time: '3h',  likes: 89),
  _Comment(username: 'mara.s',   avatar: 'assets/images/post2.jpg',  text: 'I need to go here ASAP',                    time: '4h',  likes: 156),
  _Comment(username: 'ona',      avatar: 'assets/images/story1.jpg', text: 'Goals 🙌',                                  time: '5h',  likes: 120),
  _Comment(username: 'lev.p',    avatar: 'assets/images/post5.jpg',  text: 'Dropped everything and booked a flight 😂', time: '6h',  likes: 670),
  _Comment(username: 'danny_k',  avatar: 'assets/images/post4.jpg',  text: 'The lighting here is insane 📸',             time: '8h',  likes: 43),
  _Comment(username: 'raihan',   avatar: 'assets/images/post6.jpg',  text: 'W content as always 👏',                    time: '10h', likes: 312),
];

class ReelCommentsSheet extends StatefulWidget {
  final int commentCount;
  const ReelCommentsSheet({super.key, required this.commentCount});

  @override
  State<ReelCommentsSheet> createState() => _ReelCommentsSheetState();
}

class _ReelCommentsSheetState extends State<ReelCommentsSheet> {
  final _textController = TextEditingController();
  final List<_Comment>  _comments = List.from(_seed);
  final Set<int>        _liked    = {};

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _comments.insert(0, _Comment(
        username: 'you',
        avatar:   'assets/images/story1.jpg',
        text:     text,
        time:     'now',
        likes:    0,
      ));
    });
    _textController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color:        Color(0xFF1C1C1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // ── Handle ───────────────────────────────────────────────────
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color:        Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ── Title ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${widget.commentCount} comments',
                  style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white54, size: 22),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Colors.white12),

          // ── Comments list ─────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding:      const EdgeInsets.symmetric(vertical: 8),
              itemCount:    _comments.length,
              itemBuilder:  (_, i) => _CommentTile(
                comment: _comments[i],
                isLiked: _liked.contains(i),
                onLike: () => setState(() {
                  _liked.contains(i) ? _liked.remove(i) : _liked.add(i);
                }),
              ),
            ),
          ),

          const Divider(height: 1, color: Colors.white12),

          // ── Input ─────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.only(
              left: 16, right: 16, top: 10, bottom: bottomInset + 16,
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('assets/images/story1.jpg'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color:        Colors.white12,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _textController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      onSubmitted: (_) => _submit(),
                      decoration: const InputDecoration(
                        hintText:        'Add a comment...',
                        hintStyle:       TextStyle(color: Colors.white38),
                        contentPadding:  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border:          InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _submit,
                  child: const Icon(Icons.send_rounded, color: Color(0xFF3797F0), size: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Comment tile ─────────────────────────────────────────────────────────────

class _CommentTile extends StatelessWidget {
  final _Comment     comment;
  final bool         isLiked;
  final VoidCallback onLike;

  const _CommentTile({
    required this.comment,
    required this.isLiked,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage(comment.avatar),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.username,
                      style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      comment.time,
                      style: const TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.text,
                  style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Reply',
                  style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),
          GestureDetector(
            onTap: onLike,
            child: Column(
              children: [
                AnimatedScale(
                  duration: const Duration(milliseconds: 150),
                  scale: isLiked ? 1.25 : 1.0,
                  child: Icon(
                    isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: isLiked ? const Color(0xFFFF4D6D) : Colors.white54,
                    size:  18,
                  ),
                ),
                if (comment.likes > 0) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${comment.likes}',
                    style: const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
