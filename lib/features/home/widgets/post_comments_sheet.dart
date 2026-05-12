import 'package:flutter/material.dart';

import '../models/post_model.dart';

// ─── Mock data ────────────────────────────────────────────────────────────────

class _Comment {
  final String username;
  final String avatar;
  final String text;
  final String time;
  final int    likes;
  final List<_Comment> replies;

  const _Comment({
    required this.username,
    required this.avatar,
    required this.text,
    required this.time,
    this.likes   = 0,
    this.replies = const [],
  });
}

const _seed = <_Comment>[
  _Comment(
    username: 'jules.h',
    avatar:   'assets/images/story3.jpg',
    text:     'This is absolutely stunning 😍',
    time:     '2h',
    likes:    124,
    replies: [
      _Comment(
        username: 'iko',
        avatar:   'assets/images/story2.jpg',
        text:     'Right?? The light is insane',
        time:     '1h',
        likes:    14,
      ),
    ],
  ),
  _Comment(
    username: 'mara.s',
    avatar:   'assets/images/post2.jpg',
    text:     'Where is this place?? Need the location 🗺️',
    time:     '3h',
    likes:    56,
  ),
  _Comment(
    username: 'ona',
    avatar:   'assets/images/story1.jpg',
    text:     'Goals 🙌 dropping everything',
    time:     '4h',
    likes:    89,
  ),
  _Comment(
    username: 'lev.p',
    avatar:   'assets/images/post5.jpg',
    text:     'The colours in this shot are 🔥',
    time:     '5h',
    likes:    203,
    replies: [
      _Comment(
        username: 'mara.s',
        avatar:   'assets/images/post2.jpg',
        text:     'Shot on film too, makes it even better',
        time:     '4h',
        likes:    31,
      ),
    ],
  ),
  _Comment(
    username: 'danny_k',
    avatar:   'assets/images/post4.jpg',
    text:     'Already saving up for this trip 😤',
    time:     '7h',
    likes:    17,
  ),
];

const _emojis = ['❤️', '🙌', '🔥', '😂', '😮', '😢', '😡'];

// ─── Sheet ────────────────────────────────────────────────────────────────────

class PostCommentsSheet extends StatefulWidget {
  final PostModel post;
  const PostCommentsSheet({super.key, required this.post});

  @override
  State<PostCommentsSheet> createState() => _PostCommentsSheetState();
}

class _PostCommentsSheetState extends State<PostCommentsSheet> {
  final _textController = TextEditingController();
  final _focusNode      = FocusNode();
  final List<_Comment>  _comments   = List.from(_seed);
  final Set<int>        _liked      = {};
  final Set<int>        _expanded   = {};
  bool                  _hasText    = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      final has = _textController.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
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
      ));
    });
    _textController.clear();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bottomPad   = MediaQuery.of(context).padding.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: Column(
        children: [
          // ── Handle ───────────────────────────────────────────────────
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color:        Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Header ───────────────────────────────────────────────────
          const SizedBox(height: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              const Text(
                'Comments',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              Positioned(
                right: 4,
                child: IconButton(
                  icon:      const Icon(Icons.close, size: 22),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          const Divider(height: 1, thickness: 0.5),

          // ── Comments list ─────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding:     const EdgeInsets.only(top: 4, bottom: 8),
              itemCount:   _comments.length,
              itemBuilder: (_, i) {
                return _CommentTile(
                  comment:    _comments[i],
                  isLiked:    _liked.contains(i),
                  isExpanded: _expanded.contains(i),
                  onLike: () => setState(() {
                    _liked.contains(i) ? _liked.remove(i) : _liked.add(i);
                  }),
                  onToggleReplies: _comments[i].replies.isEmpty
                      ? null
                      : () => setState(() {
                            _expanded.contains(i)
                                ? _expanded.remove(i)
                                : _expanded.add(i);
                          }),
                  onReply: () {
                    _focusNode.requestFocus();
                    _textController.text = '@${_comments[i].username} ';
                    _textController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _textController.text.length),
                    );
                  },
                );
              },
            ),
          ),

          const Divider(height: 1, thickness: 0.5),

          // ── Emoji row ─────────────────────────────────────────────────
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:         const EdgeInsets.symmetric(horizontal: 16),
              itemCount:       _emojis.length,
              itemBuilder: (_, i) => GestureDetector(
                onTap: () {
                  _textController.text += _emojis[i];
                  _focusNode.requestFocus();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Text(_emojis[i], style: const TextStyle(fontSize: 22)),
                ),
              ),
            ),
          ),

          // ── Input row ─────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.only(
              left: 14, right: 14, bottom: bottomInset > 0 ? bottomInset + 8 : bottomPad + 12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('assets/images/story1.jpg'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color:        Colors.grey[100],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller:  _textController,
                      focusNode:   _focusNode,
                      maxLines:    null,
                      style:       const TextStyle(fontSize: 14),
                      decoration:  const InputDecoration(
                        hintText:       'Add a comment...',
                        hintStyle:      TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border:         InputBorder.none,
                      ),
                    ),
                  ),
                ),
                if (_hasText) ...[
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _submit,
                    child: const Text(
                      'Post',
                      style: TextStyle(
                        color:      Color(0xFF0095F6),
                        fontWeight: FontWeight.w700,
                        fontSize:   14,
                      ),
                    ),
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

// ─── Comment tile ─────────────────────────────────────────────────────────────

class _CommentTile extends StatelessWidget {
  final _Comment     comment;
  final bool         isLiked;
  final bool         isExpanded;
  final VoidCallback onLike;
  final VoidCallback onReply;
  final VoidCallback? onToggleReplies;

  const _CommentTile({
    required this.comment,
    required this.isLiked,
    required this.isExpanded,
    required this.onLike,
    required this.onReply,
    this.onToggleReplies,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(comment, isLiked: isLiked, onLike: onLike, onReply: onReply),

          // "View replies" toggle
          if (onToggleReplies != null)
            Padding(
              padding: const EdgeInsets.only(left: 48, top: 8),
              child: GestureDetector(
                onTap: onToggleReplies,
                child: Row(
                  children: [
                    Container(
                      width: 22, height: 1,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isExpanded
                          ? 'Hide replies'
                          : 'View ${comment.replies.length} ${comment.replies.length == 1 ? 'reply' : 'replies'}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize:   12,
                        color:      Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Replies
          if (isExpanded)
            ...comment.replies.map(
              (r) => Padding(
                padding: const EdgeInsets.only(left: 48, top: 10),
                child: _buildRow(r, isLiked: false, onLike: () {}, onReply: onReply),
              ),
            ),
        ],
      ),
    );
  }

  static Widget _buildRow(
    _Comment c, {
    required bool isLiked,
    required VoidCallback onLike,
    required VoidCallback onReply,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(radius: 18, backgroundImage: AssetImage(c.avatar)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 14, height: 1.45),
                  children: [
                    TextSpan(
                      text:  '${c.username} ',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: c.text),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(c.time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  if (c.likes > 0) ...[
                    const SizedBox(width: 14),
                    Text(
                      '${c.likes} likes',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.grey),
                    ),
                  ],
                  const SizedBox(width: 14),
                  GestureDetector(
                    onTap: onReply,
                    child: const Text(
                      'Reply',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onLike,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 150),
            scale: isLiked ? 1.25 : 1.0,
            child: Icon(
              isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              size:  16,
              color: isLiked ? const Color(0xFFFF4D6D) : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
