import 'package:flutter/material.dart';

// ============================================================================
// Flutter - Home work Lesson 25
// ============================================================================
// 1) Learn: Implicit vs explicit animations: why control is needed.
//    - Create a mini example in a separate file/widget.
//    - Write notes: what it is, when to use it, and 1–2 common pitfalls.
// 2) Learn: AnimationController: forward, reverse, repeat, stop, dispose.
//    - Create a mini example in a separate file/widget.
//    - Write notes: what it is, when to use it, and 1–2 common pitfalls.
// 3) Learn: Tween and CurvedAnimation: range and speed tuning.
//    - Create a mini example in a separate file/widget.
//    - Write notes: what it is, when to use it, and 1–2 common pitfalls.
// 4) Learn: AnimatedBuilder and repaint optimization.
//    - Create a mini example in a separate file/widget.
//    - Write notes: what it is, when to use it, and 1–2 common pitfalls.
// 5) Practice: animate offset and scale with start/stop/reverse buttons.
//    - Create a separate practice screen and connect it in navigation.
//    - Check edge cases (empty list, long text, load/save errors) and clean code.

class Day25ExplicitAnimationsApp extends StatefulWidget {
  const Day25ExplicitAnimationsApp({super.key});

  @override
  State<Day25ExplicitAnimationsApp> createState() =>
      _Day25ExplicitAnimationsAppState();
}

class _Day25ExplicitAnimationsAppState extends State<Day25ExplicitAnimationsApp>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
        title: const Text('Day 25 · Explicit Animations'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 38, 64, 84),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          indicatorColor: Colors.white,
          isScrollable: true,
          tabs: const [
            Tab(text: '🎯 Control'),
            Tab(text: '🎛️ Controller'),
            Tab(text: '🧭 Tween/Curve'),
            Tab(text: '⚙️ Builder'),
            Tab(text: '🧪 Practice'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildImplicitVsExplicitTab(),
          _buildControllerTab(),
          _buildTweenCurveTab(),
          _buildAnimatedBuilderTab(),
          _buildPracticeTab(),
        ],
      ),
    );
  }

  // Task 1: Implicit vs explicit animations + mini example + notes.
  Widget _buildImplicitVsExplicitTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Implicit vs explicit animations'),
          const SizedBox(height: 12),
          _buildNoteCard(
            title: 'Notes',
            content: 'What it is:\n'
                '• Implicit animations animate widget properties automatically.\n'
                '• Explicit animations give full control over timing and state.\n\n'
                'When to use:\n'
                '• Implicit: simple UI transitions (size, color, opacity).\n'
                '• Explicit: complex sequences, precise timing, or user‑driven control.\n\n'
                'Typical mistakes/pitfalls:\n'
                '• Using explicit animations for simple cases (over‑engineering).\n'
                '• Overusing implicit animations where precise control is needed.',
          ),
          const SizedBox(height: 16),
          _buildMiniExampleTitle('Mini example: implicit vs explicit'),
          const SizedBox(height: 12),
          const _ImplicitVsExplicitDemo(),
        ],
      ),
    );
  }

  // Task 2: AnimationController methods + mini example + notes.
  Widget _buildControllerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('AnimationController basics'),
          const SizedBox(height: 12),
          _buildNoteCard(
            title: 'Notes',
            content: 'What it is:\n'
                '• AnimationController drives explicit animations with time.\n'
                '• Key methods: forward(), reverse(), repeat(), stop(), dispose().\n\n'
                'When to use:\n'
                '• When you need play/pause/reverse controls or sync with events.\n\n'
                'Typical mistakes/pitfalls:\n'
                '• Forgetting dispose() → memory leaks.\n'
                '• Calling forward() repeatedly without stopping or checking state.',
          ),
          const SizedBox(height: 16),
          _buildMiniExampleTitle('Mini example: controller actions'),
          const SizedBox(height: 12),
          const _ControllerActionsDemo(),
        ],
      ),
    );
  }

  // Task 3: Tween + CurvedAnimation + mini example + notes.
  Widget _buildTweenCurveTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Tween and CurvedAnimation'),
          const SizedBox(height: 12),
          _buildNoteCard(
            title: 'Notes',
            content: 'What it is:\n'
                '• Tween maps controller values to a target range (e.g., 0→1 to 50→200).\n'
                '• CurvedAnimation changes the speed profile over time.\n\n'
                'When to use:\n'
                '• Tween for size, color, offset ranges.\n'
                '• Curves for natural motion (easeIn, easeOut, etc.).\n\n'
                'Typical mistakes/pitfalls:\n'
                '• Using the wrong range (e.g., negative sizes or off‑screen values).\n'
                '• Using dramatic curves where subtle motion is expected.',
          ),
          const SizedBox(height: 16),
          _buildMiniExampleTitle('Mini example: range + curve tuning'),
          const SizedBox(height: 12),
          const _TweenCurveDemo(),
        ],
      ),
    );
  }

  // Task 4: AnimatedBuilder optimization + mini example + notes.
  Widget _buildAnimatedBuilderTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('AnimatedBuilder and repaint optimization'),
          const SizedBox(height: 12),
          _buildNoteCard(
            title: 'Notes',
            content: 'What it is:\n'
                '• AnimatedBuilder rebuilds only a small part of the widget tree.\n'
                '• It reduces unnecessary rebuilds for better performance.\n\n'
                'When to use:\n'
                '• Complex widgets where only a small piece is animating.\n\n'
                'Typical mistakes/pitfalls:\n'
                '• Animating an entire subtree when only one widget changes.\n'
                '• Not using the child parameter for static parts.',
          ),
          const SizedBox(height: 16),
          _buildMiniExampleTitle('Mini example: optimized rebuild'),
          const SizedBox(height: 12),
          const _AnimatedBuilderDemo(),
        ],
      ),
    );
  }

  // Task 5: Practice screen + edge cases.
  Widget _buildPracticeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Practice: offset + scale controls'),
          const SizedBox(height: 12),
          _buildNoteCard(
            title: 'Notes',
            content: 'Goal:\n'
                '• Animate widget offset and scale with Start/Stop/Reverse buttons.\n\n'
                'Edge cases checked:\n'
                '• Empty list preview.\n'
                '• Long text wrapping.\n'
                '• Simulated load/save error states.',
          ),
          const SizedBox(height: 16),
          _buildMiniExampleTitle('Practice screen'),
          const SizedBox(height: 12),
          const _PracticeAnimationDemo(),
          const SizedBox(height: 24),
          _buildMiniExampleTitle('Edge cases preview'),
          const SizedBox(height: 12),
          const _EdgeCasesPreview(),
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

class _ImplicitVsExplicitDemo extends StatefulWidget {
  const _ImplicitVsExplicitDemo();

  @override
  State<_ImplicitVsExplicitDemo> createState() => _ImplicitVsExplicitDemoState();
}

class _ImplicitVsExplicitDemoState extends State<_ImplicitVsExplicitDemo>
    with SingleTickerProviderStateMixin {
  bool _implicitToggled = false;
  late final AnimationController _controller;
  late final Animation<double> _explicitScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _explicitScale = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 54,
                  decoration: BoxDecoration(
                    color: _implicitToggled ? Colors.teal : Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Implicit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedBuilder(
                  animation: _explicitScale,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.8 + (_explicitScale.value * 0.4),
                      child: child,
                    );
                  },
                  child: Container(
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Explicit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() {
                    _implicitToggled = !_implicitToggled;
                  }),
                  child: const Text('Toggle implicit'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_controller.isCompleted) {
                      _controller.reverse();
                    } else {
                      _controller.forward();
                    }
                  },
                  child: const Text('Play explicit'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ControllerActionsDemo extends StatefulWidget {
  const _ControllerActionsDemo();

  @override
  State<_ControllerActionsDemo> createState() => _ControllerActionsDemoState();
}

class _ControllerActionsDemoState extends State<_ControllerActionsDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -12 + 24 * _controller.value),
                child: child,
              );
            },
            child: const Icon(Icons.airplanemode_active,
                size: 48, color: Colors.blue),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: _controller.forward,
                child: const Text('Forward'),
              ),
              OutlinedButton(
                onPressed: _controller.reverse,
                child: const Text('Reverse'),
              ),
              OutlinedButton(
                onPressed: () => _controller.repeat(reverse: true),
                child: const Text('Repeat'),
              ),
              OutlinedButton(
                onPressed: _controller.stop,
                child: const Text('Stop'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TweenCurveDemo extends StatefulWidget {
  const _TweenCurveDemo();

  @override
  State<_TweenCurveDemo> createState() => _TweenCurveDemoState();
}

class _TweenCurveDemoState extends State<_TweenCurveDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scale = Tween<double>(begin: 0.9, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _offset = Tween<Offset>(
      begin: const Offset(-16, 0),
      end: const Offset(16, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: _offset.value,
                child: Transform.scale(scale: _scale.value, child: child),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'Tween + Curve',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              if (_controller.isCompleted) {
                _controller.reverse();
              } else {
                _controller.forward();
              }
            },
            child: const Text('Play'),
          ),
        ],
      ),
    );
  }
}

class _AnimatedBuilderDemo extends StatefulWidget {
  const _AnimatedBuilderDemo();

  @override
  State<_AnimatedBuilderDemo> createState() => _AnimatedBuilderDemoState();
}

class _AnimatedBuilderDemoState extends State<_AnimatedBuilderDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _rotation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _rotation,
            child: const Icon(Icons.sync, size: 44, color: Colors.teal),
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotation.value * 6.283,
                child: child,
              );
            },
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Only the icon rotates; the text stays static.',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _PracticeAnimationDemo extends StatefulWidget {
  const _PracticeAnimationDemo();

  @override
  State<_PracticeAnimationDemo> createState() => _PracticeAnimationDemoState();
}

class _PracticeAnimationDemoState extends State<_PracticeAnimationDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offset;
  late final Animation<double> _scale;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _offset = Tween<Offset>(
      begin: const Offset(-24, 0),
      end: const Offset(24, -16),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _scale = Tween<double>(begin: 0.9, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _start() {
    setState(() => _isRunning = true);
    _controller.forward();
  }

  void _stop() {
    _controller.stop();
    setState(() => _isRunning = false);
  }

  void _reverse() {
    setState(() => _isRunning = true);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: Center(
              child: AnimatedBuilder(
                animation: _controller,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Move + Scale',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                builder: (context, child) {
                  return Transform.translate(
                    offset: _offset.value,
                    child: Transform.scale(scale: _scale.value, child: child),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: _start,
                child: const Text('Start'),
              ),
              OutlinedButton(
                onPressed: _isRunning ? _stop : null,
                child: const Text('Stop'),
              ),
              OutlinedButton(
                onPressed: _reverse,
                child: const Text('Reverse'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EdgeCasesPreview extends StatefulWidget {
  const _EdgeCasesPreview();

  @override
  State<_EdgeCasesPreview> createState() => _EdgeCasesPreviewState();
}

class _EdgeCasesPreviewState extends State<_EdgeCasesPreview> {
  bool _showEmpty = true;
  bool _simulateError = false;

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SwitchListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Empty list'),
                  value: _showEmpty,
                  onChanged: (value) => setState(() => _showEmpty = value),
                ),
              ),
              Expanded(
                child: SwitchListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Load/Save error'),
                  value: _simulateError,
                  onChanged: (value) => setState(() => _simulateError = value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_simulateError)
            _buildErrorBanner()
          else
            _buildListPreview(),
        ],
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700]),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Failed to save changes. Please try again.',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListPreview() {
    final List<String> items = _showEmpty
        ? <String>[]
        : <String>[
            'Short item',
            'Very long text item that should wrap across multiple lines to '
                'test layout and overflow behavior in the list tile widget.',
          ];

    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.orange[200]!),
        ),
        child: const Text(
          'No items available yet.',
          style: TextStyle(fontSize: 13),
        ),
      );
    }

    return Column(
      children: items
          .map(
            (item) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(item, style: const TextStyle(fontSize: 13)),
              leading: const Icon(Icons.check_circle_outline, size: 18),
            ),
          )
          .toList(),
    );
  }
}

class _DemoCard extends StatelessWidget {
  final Widget child;

  const _DemoCard({required this.child});

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
      child: child,
    );
  }
}
