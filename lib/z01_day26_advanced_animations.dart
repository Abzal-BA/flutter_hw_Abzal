import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ============================================================================
// Flutter - Home work Lesson 26
// ============================================================================
// 1) Learn: Staggered animations with Interval (sequential effects).
//    - Create a mini example in a separate file/widget.
//    - Write notes: what it is, when to use it, and 1–2 common pitfalls.
// 2) Learn: Hero animations between screens.
//    - Create a mini example in a separate file/widget.
//    - Write notes: what it is, when to use it, and 1–2 common pitfalls.
// 3) Learn: List animations: AnimatedList, item insert/remove effects.
//    - Create a mini example in a separate file/widget.
//    - Write notes: what it is, when to use it, and 1–2 common pitfalls.
// 4) Learn: Packages: Lottie / Rive (when to use).
//    - Create a mini example in a separate file/widget.
//    - Write notes: what it is, when to use it, and 1–2 common pitfalls.
// 5) Practice:
//    - 2 screens + Hero transition for image + smooth details fade-in.
//    - Hero animation between list and details.
//    - Onboarding: 3 screens with PageView + animated indicators.
//    - Connect a package (Lottie) and show loading/success animation.
//    - Use AnimatedSwitcher with custom transitionBuilder.

class Day26AdvancedAnimationsApp extends StatefulWidget {
  const Day26AdvancedAnimationsApp({super.key});

  @override
  State<Day26AdvancedAnimationsApp> createState() =>
      _Day26AdvancedAnimationsAppState();
}

class _Day26AdvancedAnimationsAppState extends State<Day26AdvancedAnimationsApp>
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
        title: const Text('Day 26 · Advanced Animations'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 38, 64, 84),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          indicatorColor: Colors.white,
          isScrollable: true,
          tabs: const [
            Tab(text: '⏳ Staggered'),
            Tab(text: '🧲 Hero'),
            Tab(text: '🧾 AnimatedList'),
            Tab(text: '🎬 Lottie/Rive'),
            Tab(text: '🧪 Practice'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStaggeredTab(),
          _buildHeroTab(),
          _buildAnimatedListTab(),
          _buildLottieTab(),
          _buildPracticeTab(),
        ],
      ),
    );
  }

  // Task 1: Staggered animations + mini example + notes.
  Widget _buildStaggeredTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Staggered animations with Interval'),
          const SizedBox(height: 12),
          _buildNoteCard(
            title: 'Notes',
            content: 'What it is:\n'
                '• Staggered animation runs multiple effects sequentially via Interval.\n'
                '• One controller drives several animations with different time slices.\n\n'
                'When to use:\n'
                '• Step‑by‑step UI reveals, onboarding panels, and dashboards.\n\n'
                'Typical mistakes/pitfalls:\n'
                '• Overlapping intervals that fight each other.\n'
                '• Too long total duration makes UI feel slow.',
          ),
          const SizedBox(height: 16),
          _buildMiniExampleTitle('Mini example: interval sequence'),
          const SizedBox(height: 12),
          const _StaggeredDemo(),
        ],
      ),
    );
  }

  // Task 2: Hero animations + mini example + notes.
  Widget _buildHeroTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Hero animations between screens'),
          const SizedBox(height: 12),
          _buildNoteCard(
            title: 'Notes',
            content: 'What it is:\n'
                '• Hero animates a shared widget between routes.\n\n'
                'When to use:\n'
                '• List → details transitions, gallery → preview, avatar → profile.\n\n'
                'Typical mistakes/pitfalls:\n'
                '• Duplicate Hero tags on the same route.\n'
                '• Heavy images without placeholders cause jank.',
          ),
          const SizedBox(height: 16),
          _buildMiniExampleTitle('Mini example: hero card'),
          const SizedBox(height: 12),
          const _HeroListDemo(),
        ],
      ),
    );
  }

  // Task 3: AnimatedList + mini example + notes.
  Widget _buildAnimatedListTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('AnimatedList for insert/remove'),
          const SizedBox(height: 12),
          _buildNoteCard(
            title: 'Notes',
            content: 'What it is:\n'
                '• AnimatedList animates items on insert and remove.\n\n'
                'When to use:\n'
                '• Dynamic lists like tasks, chat, cart, and notifications.\n\n'
                'Typical mistakes/pitfalls:\n'
                '• Not keeping list data in sync with AnimatedListState.\n'
                '• Reusing keys incorrectly, causing flicker.',
          ),
          const SizedBox(height: 16),
          _buildMiniExampleTitle('Mini example: add/remove items'),
          const SizedBox(height: 12),
          const _AnimatedListDemo(),
        ],
      ),
    );
  }

  // Task 4: Lottie/Rive + mini example + notes.
  Widget _buildLottieTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Lottie / Rive packages'),
          const SizedBox(height: 12),
          _buildNoteCard(
            title: 'Notes',
            content: 'What it is:\n'
                '• Lottie/Rive are vector animation formats with runtime playback.\n\n'
                'When to use:\n'
                '• Loading states, empty states, onboarding, and micro‑interactions.\n\n'
                'Typical mistakes/pitfalls:\n'
                '• Large files without caching or fallbacks.\n'
                '• Relying on animations for critical UX without a static backup.',
          ),
          const SizedBox(height: 16),
          _buildMiniExampleTitle('Mini example: Lottie loading/success'),
          const SizedBox(height: 12),
          const _LottieDemo(),
        ],
      ),
    );
  }

  // Task 5: Practice requirements.
  Widget _buildPracticeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Practice: combined tasks'),
          const SizedBox(height: 12),
          _buildNoteCard(
            title: 'Notes',
            content: 'Includes:\n'
                '• 2 screens with Hero image + fade‑in details.\n'
                '• Hero transition from list to details.\n'
                '• Onboarding with PageView + animated indicators.\n'
                '• Lottie loading/success animation.\n'
                '• AnimatedSwitcher with custom transitionBuilder.',
          ),
          const SizedBox(height: 16),
          _buildMiniExampleTitle('Practice screen: Hero + details'),
          const SizedBox(height: 12),
          const _HeroListDemo(),
          const SizedBox(height: 24),
          _buildMiniExampleTitle('Onboarding with animated indicators'),
          const SizedBox(height: 12),
          const _OnboardingDemo(),
          const SizedBox(height: 24),
          _buildMiniExampleTitle('AnimatedSwitcher content swap'),
          const SizedBox(height: 12),
          const _AnimatedSwitcherDemo(),
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

class _StaggeredDemo extends StatefulWidget {
  const _StaggeredDemo();

  @override
  State<_StaggeredDemo> createState() => _StaggeredDemoState();
}

class _StaggeredDemoState extends State<_StaggeredDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );
    _scale = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOutBack),
      ),
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
              return Opacity(
                opacity: _fade.value,
                child: Transform.translate(
                  offset: _slide.value,
                  child: Transform.scale(scale: _scale.value, child: child),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'Staggered Card',
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

class _HeroListDemo extends StatelessWidget {
  const _HeroListDemo();

  @override
  Widget build(BuildContext context) {
    final List<_HeroItem> items = <_HeroItem>[
      const _HeroItem(
        id: 'hero-1',
        title: 'Sunset Lake',
        subtitle: 'Tap to open details',
        color: Colors.orange,
      ),
      const _HeroItem(
        id: 'hero-2',
        title: 'City Lights',
        subtitle: 'Smooth transition',
        color: Colors.deepPurple,
      ),
    ];

    return _DemoCard(
      child: Column(
        children: items
            .map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Hero(
                  tag: item.id,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: item.color,
                    child: const Icon(Icons.image, color: Colors.white),
                  ),
                ),
                title: Text(item.title),
                subtitle: Text(item.subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => _HeroDetailsScreen(item: item),
                    ),
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class _HeroDetailsScreen extends StatefulWidget {
  final _HeroItem item;

  const _HeroDetailsScreen({required this.item});

  @override
  State<_HeroDetailsScreen> createState() => _HeroDetailsScreenState();
}

class _HeroDetailsScreenState extends State<_HeroDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _HeroItem item = widget.item;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 38, 64, 84),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: item.id,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.image, size: 88, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            FadeTransition(
              opacity: _fade,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Smooth details appear after Hero transition.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This page uses a FadeTransition controlled by an '
                    'AnimationController to softly reveal the details.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroItem {
  final String id;
  final String title;
  final String subtitle;
  final Color color;

  const _HeroItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class _AnimatedListDemo extends StatefulWidget {
  const _AnimatedListDemo();

  @override
  State<_AnimatedListDemo> createState() => _AnimatedListDemoState();
}

class _AnimatedListDemoState extends State<_AnimatedListDemo> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _items = <String>['Task 1', 'Task 2'];
  int _counter = 3;

  void _insertItem() {
    final int index = _items.length;
    _items.add('Task $_counter');
    _counter++;
    _listKey.currentState?.insertItem(index);
  }

  void _removeItem(int index) {
    final String removed = _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildListTile(removed, animation),
    );
  }

  Widget _buildListTile(String item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: ListTile(
        title: Text(item),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            final int index = _items.indexOf(item);
            if (index >= 0) {
              _removeItem(index);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: Column(
        children: [
          AnimatedList(
            key: _listKey,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            initialItemCount: _items.length,
            itemBuilder: (context, index, animation) {
              return _buildListTile(_items[index], animation);
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _insertItem,
            icon: const Icon(Icons.add),
            label: const Text('Add item'),
          ),
        ],
      ),
    );
  }
}

class _LottieDemo extends StatefulWidget {
  const _LottieDemo();

  @override
  State<_LottieDemo> createState() => _LottieDemoState();
}

class _LottieDemoState extends State<_LottieDemo> {
  bool _success = false;

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: Column(
        children: [
          SizedBox(
            height: 140,
            child: Lottie.network(
              _success
                  ? 'https://assets2.lottiefiles.com/packages/lf20_jbrw3hcz.json'
                  : 'https://assets2.lottiefiles.com/packages/lf20_usmfx6bp.json',
              repeat: !_success,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => setState(() => _success = !_success),
            child: Text(_success ? 'Show loading' : 'Show success'),
          ),
        ],
      ),
    );
  }
}

class _OnboardingDemo extends StatefulWidget {
  const _OnboardingDemo();

  @override
  State<_OnboardingDemo> createState() => _OnboardingDemoState();
}

class _OnboardingDemoState extends State<_OnboardingDemo> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<_OnboardPage> pages = <_OnboardPage>[
      const _OnboardPage(
        title: 'Welcome',
        subtitle: 'Discover new experiences',
        color: Colors.deepPurple,
      ),
      const _OnboardPage(
        title: 'Learn',
        subtitle: 'Track progress smoothly',
        color: Colors.indigo,
      ),
      const _OnboardPage(
        title: 'Start',
        subtitle: 'Ready to begin',
        color: Colors.teal,
      ),
    ];

    return _DemoCard(
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (value) => setState(() => _index = value),
              itemBuilder: (context, index) {
                final _OnboardPage page = pages[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: page.color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        page.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        page.subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _index == index ? 28 : 10,
                decoration: BoxDecoration(
                  color: _index == index ? Colors.indigo : Colors.grey[400],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardPage {
  final String title;
  final String subtitle;
  final Color color;

  const _OnboardPage({
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class _AnimatedSwitcherDemo extends StatefulWidget {
  const _AnimatedSwitcherDemo();

  @override
  State<_AnimatedSwitcherDemo> createState() => _AnimatedSwitcherDemoState();
}

class _AnimatedSwitcherDemoState extends State<_AnimatedSwitcherDemo> {
  bool _showSuccess = false;

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) {
              final Animation<Offset> slide = Tween<Offset>(
                begin: const Offset(0.2, 0),
                end: Offset.zero,
              ).animate(animation);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: slide, child: child),
              );
            },
            child: _showSuccess
                ? Container(
                    key: const ValueKey('success'),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.green[600],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Success state',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Container(
                    key: const ValueKey('loading'),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.orange[600],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Loading state',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => setState(() => _showSuccess = !_showSuccess),
            child: const Text('Switch content'),
          ),
        ],
      ),
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
