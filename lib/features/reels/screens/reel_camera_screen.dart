import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum _RecordMode { video, photo, text, live }

class ReelCameraScreen extends StatefulWidget {
  const ReelCameraScreen({super.key});

  @override
  State<ReelCameraScreen> createState() => _ReelCameraScreenState();
}

class _ReelCameraScreenState extends State<ReelCameraScreen>
    with SingleTickerProviderStateMixin {
  _RecordMode _mode      = _RecordMode.video;
  bool        _isRecording = false;
  bool        _flashOn   = false;

  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) _stopRecording();
      });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _startRecording() {
    setState(() => _isRecording = true);
    _progressController.forward();
  }

  void _stopRecording() {
    _progressController.stop();
    _progressController.reset();
    setState(() => _isRecording = false);
  }

  void _toggleRecord() => _isRecording ? _stopRecording() : _startRecording();

  Future<void> _pickFromGallery() async {
    final file = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (file != null && mounted) Navigator.pop(context);
  }

  Future<void> _capturePhoto() async {
    final file = await ImagePicker().pickImage(source: ImageSource.camera);
    if (file != null && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview placeholder
          Container(color: const Color(0xFF0D0D0D)),

          // Subtle grid overlay
          IgnorePointer(
            child: CustomPaint(
              size: Size.infinite,
              painter: _GridPainter(),
            ),
          ),

          // Top bar
          _TopBar(
            flashOn: _flashOn,
            onClose: () => Navigator.pop(context),
            onFlash: () => setState(() => _flashOn = !_flashOn),
          ),

          // Right-side option column
          const _SideOptions(),

          // Recording progress arc
          if (_isRecording)
            Positioned(
              bottom: bottomPad + 96,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, _) => SizedBox(
                    width: 90,
                    height: 90,
                    child: CircularProgressIndicator(
                      value:           _progressController.value,
                      strokeWidth:     4,
                      color:           const Color(0xFFFF4D6D),
                      backgroundColor: Colors.white24,
                    ),
                  ),
                ),
              ),
            ),

          // Bottom controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Mode tabs
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _RecordMode.values.map((m) {
                    final label    = m.name[0].toUpperCase() + m.name.substring(1);
                    final selected = m == _mode;
                    return GestureDetector(
                      onTap: () => setState(() => _mode = m),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              label,
                              style: TextStyle(
                                color:      selected ? Colors.white : Colors.white54,
                                fontSize:   selected ? 15 : 13,
                                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 4),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width:  selected ? 18 : 0,
                              height: 2,
                              color:  Colors.white,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Record row
                Padding(
                  padding: EdgeInsets.only(
                    left: 40, right: 40, bottom: bottomPad + 28,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Gallery picker
                      GestureDetector(
                        onTap: _pickFromGallery,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white38),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.photo_library_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),

                      // Record / shutter button
                      GestureDetector(
                        onTap: _mode == _RecordMode.photo
                            ? _capturePhoto
                            : _toggleRecord,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 140),
                          width:  _isRecording ? 66 : 76,
                          height: _isRecording ? 66 : 76,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 140),
                              width:  _isRecording ? 28 : 58,
                              height: _isRecording ? 28 : 58,
                              decoration: BoxDecoration(
                                color:        const Color(0xFFFF4D6D),
                                borderRadius: _isRecording
                                    ? BorderRadius.circular(8)
                                    : BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Flip camera
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color:  Colors.white12,
                            shape:  BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.flip_camera_ios_rounded,
                            color: Colors.white,
                            size:  22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Top bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final bool         flashOn;
  final VoidCallback onClose;
  final VoidCallback onFlash;

  const _TopBar({
    required this.flashOn,
    required this.onClose,
    required this.onFlash,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          children: [
            _TopBtn(icon: Icons.close, onTap: onClose),
            const Spacer(),
            _TopBtn(
              icon: flashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
              onTap: onFlash,
            ),
            const SizedBox(width: 12),
            _TopBtn(icon: Icons.timer_outlined, onTap: () {}),
            const SizedBox(width: 12),
            _TopBtn(icon: Icons.music_note_rounded, onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class _TopBtn extends StatelessWidget {
  final IconData     icon;
  final VoidCallback onTap;
  const _TopBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          color: Colors.white12,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

// ─── Right-side options ───────────────────────────────────────────────────────

class _SideOptions extends StatelessWidget {
  const _SideOptions();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 12,
      top: 0,
      bottom: 0,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            _SideBtn(icon: Icons.speed_rounded,              label: 'Speed'),
            _SideBtn(icon: Icons.auto_fix_high_rounded,      label: 'Filter'),
            _SideBtn(icon: Icons.face_retouching_natural,    label: 'Beauty'),
            _SideBtn(icon: Icons.flip_camera_ios_rounded,    label: 'Flip'),
            _SideBtn(icon: Icons.grid_on_rounded,            label: 'Grid'),
          ],
        ),
      ),
    );
  }
}

class _SideBtn extends StatelessWidget {
  final IconData icon;
  final String   label;
  const _SideBtn({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

// ─── Grid painter ─────────────────────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 0.8;
    // 3×3 rule lines
    for (final x in [size.width / 3, size.width * 2 / 3]) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (final y in [size.height / 3, size.height * 2 / 3]) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter _) => false;
}
