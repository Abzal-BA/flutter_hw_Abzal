import 'package:flutter/material.dart';

// ============================================================================
// Flutter - Home work Lesson 24
// ============================================================================
// 1) Learn: What is animation in Flutter and where it is used.
//    - Create a mini example in a separate file/widget.
//    - Write notes: what it is, when to use it, and 1–2 common pitfalls.
// 2) Learn: Implicit animations: AnimatedContainer, AnimatedOpacity, AnimatedAlign.
//    - Create a mini example in a separate file/widget.
//    - Write notes: what it is, when to use it, and 1–2 common pitfalls.
// 3) Learn: Duration and Curve: how they affect the “feel” of animation.
//    - Create a mini example in a separate file/widget.
//    - Write notes: what it is, when to use it, and 1–2 common pitfalls.
// 4) Learn: UI state animations (pressed / loading / parameter changes).
//    - Create a mini example in a separate file/widget.
//    - Write notes: what it is, when to use it, and 1–2 common pitfalls.

class Day24AnimationsApp extends StatefulWidget {
  const Day24AnimationsApp({super.key});

  @override
  State<Day24AnimationsApp> createState() => _Day24AnimationsAppState();
}

class _Day24AnimationsAppState extends State<Day24AnimationsApp>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Day 24 · Flutter Animations'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 38, 64, 84),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: '🎬 Animation'),
            Tab(text: '✨ Implicit'),
            Tab(text: '⏱️ Duration/Curve'),
            Tab(text: '🟢 UI State'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAnimationBasicsTab(),
          _buildImplicitAnimationsTab(),
          _buildDurationCurveTab(),
          _buildUiStateTab(),
        ],
      ),
    );
  }

  Widget _buildAnimationBasicsTab() {
    // Task 1: What is animation in Flutter + mini example + notes.
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('What is animation in Flutter'),
          const SizedBox(height: 12),
          _buildNoteCard(
            title: 'Notes',
            content: 'What it is:\n'
                '• Animation is a smooth change of values (position, size, color, opacity) over time.\n'
                '• In Flutter, animations are built around animatable values (Tween) and time (Duration/Curve).\n\n'
                'When to use:\n'
                '• Screen transitions, expanding/collapsing UI, and feedback after user actions.\n'
                '• Improve perceived quality and clarity of interactions.\n\n'
                'Typical mistakes/pitfalls:\n'
                '• Too many animations make the UI feel noisy.\n'
                '• Heavy animations without optimization can cause jank.',
          ),
          const SizedBox(height: 16),
          _buildMiniExampleTitle('Mini example: explicit animation (AnimationController)'),
          const SizedBox(height: 12),
          const _ExplicitRotationDemo(),
        ],
      ),
    );
  }

  Widget _buildImplicitAnimationsTab() {
    // Task 2: Implicit animations + mini example + notes.
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Implicit animations'),
          const SizedBox(height: 12),
          _buildNoteCard(
            title: 'Notes',
            content: 'What it is:\n'
                '• Implicit animations are widgets that animate parameter changes automatically.\n'
                '• Examples: AnimatedContainer, AnimatedOpacity, AnimatedAlign.\n\n'
                'When to use:\n'
                '• Simple state transitions without manual AnimationController.\n'
                '• Quick UX improvements with minimal code.\n\n'
                'Typical mistakes/pitfalls:\n'
                '• Rebuilding too often without actual parameter changes.\n'
                '• Inconsistent Duration/Curve between elements, causing jerky motion.',
          ),
          const SizedBox(height: 16),
          _buildMiniExampleTitle('Mini example: AnimatedContainer + AnimatedOpacity + AnimatedAlign'),
          const SizedBox(height: 12),
          const _ImplicitAnimationsDemo(),
        ],
      ),
    );
  }

  Widget _buildDurationCurveTab() {
    // Task 3: Duration and Curve + mini example + notes.
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Duration and Curve'),
          const SizedBox(height: 12),
          _buildNoteCard(
            title: 'Notes',
            content: 'What it is:\n'
                '• Duration controls the animation length (e.g., 200–600 ms).\n'
                '• Curve defines speed over time (linear, ease, acceleration).\n\n'
                'When to use:\n'
                '• Duration for tempo and responsiveness.\n'
                '• Curve for natural feel, e.g., easeOut for soft stopping.\n\n'
                'Typical mistakes/pitfalls:\n'
                '• Too long Duration makes the UI feel slow.\n'
                '• Overly dramatic curves (e.g., bounce) in the wrong context.',
          ),
          const SizedBox(height: 16),
          _buildMiniExampleTitle('Mini example: Duration/Curve comparison'),
          const SizedBox(height: 12),
          const _DurationCurveDemo(),
        ],
      ),
    );
  }

  Widget _buildUiStateTab() {
    // Task 4: UI state animations + mini example + notes.
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('UI state animations'),
          const SizedBox(height: 12),
          _buildNoteCard(
            title: 'Notes',
            content: 'What it is:\n'
                '• State animations provide visual feedback for UI changes (pressed, loading, parameter changes).\n'
                '• They clarify that an action started and completed.\n\n'
                'When to use:\n'
                '• Buttons: pressed feedback and loading states.\n'
                '• Cards/panels: smooth color, size, or position changes.\n\n'
                'Typical mistakes/pitfalls:\n'
                '• Not blocking repeated taps while loading.\n'
                '• Abrupt state changes without animation make UI feel broken.',
          ),
          const SizedBox(height: 16),
          _buildMiniExampleTitle('Mini example: pressed + loading + parameter changes'),
          const SizedBox(height: 12),
          const _UiStateAnimationsDemo(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildMiniExampleTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildNoteCard({required String title, required String content}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[800],
              height: 1.6,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

class _ExplicitRotationDemo extends StatefulWidget {
  const _ExplicitRotationDemo();

  @override
  State<_ExplicitRotationDemo> createState() => _ExplicitRotationDemoState();
}

class _ExplicitRotationDemoState extends State<_ExplicitRotationDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 6.283,
                child: child,
              );
            },
            child: const Icon(Icons.flutter_dash, size: 72, color: Colors.blue),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _toggleAnimation,
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            label: Text(_isPlaying ? 'Stop' : 'Play'),
          ),
        ],
      ),
    );
  }
}

class _ImplicitAnimationsDemo extends StatefulWidget {
  const _ImplicitAnimationsDemo();

  @override
  State<_ImplicitAnimationsDemo> createState() => _ImplicitAnimationsDemoState();
}

class _ImplicitAnimationsDemoState extends State<_ImplicitAnimationsDemo> {
  bool _toggled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            height: _toggled ? 120 : 80,
            width: _toggled ? 220 : 140,
            decoration: BoxDecoration(
              color: _toggled ? Colors.indigo : Colors.orange,
              borderRadius: BorderRadius.circular(16),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              alignment: _toggled ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: AnimatedOpacity(
                  opacity: _toggled ? 0.4 : 1,
                  duration: const Duration(milliseconds: 400),
                  child: const Icon(Icons.star, color: Colors.white, size: 32),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(() => _toggled = !_toggled),
            child: const Text('Toggle'),
          ),
        ],
      ),
    );
  }
}

class _DurationCurveDemo extends StatefulWidget {
  const _DurationCurveDemo();

  @override
  State<_DurationCurveDemo> createState() => _DurationCurveDemoState();
}

class _DurationCurveDemoState extends State<_DurationCurveDemo> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.linear,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: _expanded ? 160 : 80,
                ),
              ),
              const SizedBox(width: 12),
              const Text('250ms · linear'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeInOutCubic,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: _expanded ? 160 : 80,
                ),
              ),
              const SizedBox(width: 12),
              const Text('900ms · easeInOut'),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(() => _expanded = !_expanded),
            child: const Text('Compare'),
          ),
        ],
      ),
    );
  }
}

class _UiStateAnimationsDemo extends StatefulWidget {
  const _UiStateAnimationsDemo();

  @override
  State<_UiStateAnimationsDemo> createState() => _UiStateAnimationsDemoState();
}

class _UiStateAnimationsDemoState extends State<_UiStateAnimationsDemo> {
  bool _pressed = false;
  bool _loading = false;
  bool _active = false;

  Future<void> _handleTap() async {
    if (_loading) {
      return;
    }
    setState(() {
      _loading = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (!mounted) {
      return;
    }

    setState(() {
      _loading = false;
      _active = !_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = _loading ? Colors.grey : Colors.teal;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
            width: _active ? 220 : 140,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: _active ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _active ? 'Completed' : 'Idle',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedScale(
            duration: const Duration(milliseconds: 90),
            scale: _pressed ? 0.96 : 1,
            child: Material(
              color: buttonColor,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _loading ? null : _handleTap,
                onTapDown: (_) => setState(() => _pressed = true),
                onTapUp: (_) => setState(() => _pressed = false),
                onTapCancel: () => setState(() => _pressed = false),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _loading
                        ? const SizedBox(
                            key: ValueKey('loading'),
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Submit',
                            key: ValueKey('text'),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
