import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ============================================================================
// Flutter - Home work Lesson 27
// ============================================================================
// 1) Learn: Why BLoC (events -> states, predictability).
//    - Mini example + notes.
// 2) Learn: Cubit as a simpler entry to BLoC.
//    - Mini example + notes.
// 3) Learn: BlocProvider, BlocBuilder, BlocListener.
//    - Mini example + notes.
// 4) Learn: State pattern: loading / success / error.
//    - Mini example + notes.
// 5) Practice:
//    - Cubit: counter + last 10 actions history + clear state.
//    - Bloc: login form with validation and loading/success/error.
//    - Data loading screen with Retry and 3 states.
//    - Edge cases: empty list, long text, load/save error.
//    - Split UI into small widgets and use BlocBuilder/BlocSelector precisely.

class Day27BlocCubitApp extends StatefulWidget {
  const Day27BlocCubitApp({super.key});

  @override
  State<Day27BlocCubitApp> createState() => _Day27BlocCubitAppState();
}

class _Day27BlocCubitAppState extends State<Day27BlocCubitApp>
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
        title: const Text('Day 27 · flutter_bloc (BLoC/Cubit)'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 38, 64, 84),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          indicatorColor: Colors.white,
          isScrollable: true,
          tabs: const [
            Tab(text: '🧠 BLoC'),
            Tab(text: '🧩 Cubit'),
            Tab(text: '🧱 Provider'),
            Tab(text: '🚦 States'),
            Tab(text: '🧪 Practice'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _BlocConceptTab(),
          _CubitConceptTab(),
          _ProviderConceptTab(),
          _StatePatternTab(),
          _PracticeTab(),
        ],
      ),
    );
  }
}

class _BlocConceptTab extends StatelessWidget {
  const _BlocConceptTab();

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      title: 'Why BLoC: events → states',
      notes:
          'What it is:\n'
          '• BLoC turns user/system events into states.\n'
          '• Predictable flow makes UI easy to test and debug.\n\n'
          'When to use:\n'
          '• Medium/large apps with complex state changes.\n'
          '• When you need clear separation of UI and logic.\n\n'
          'Typical mistakes/pitfalls:\n'
          '• Putting UI logic inside Bloc.\n'
          '• Emitting too many states for tiny changes.',
      miniTitle: 'Mini example: login with events and states',
      child: const _LoginBlocDemo(),
      definitions: const [
        'BLoC = events in → states out.\nUI reacts to states only.',
        'Predictability = one source of truth for state.\nEasy to test.',
        'Events describe intent; states describe UI snapshot.',
      ],
      checklist: const [
        'Use BLoC when many events affect the same UI.',
        'Use BLoC when you need testable business logic.',
        'Avoid BLoC for small, local widget state.',
      ],
      questions: const [
        _SelfCheck(
          question: 'Why is BLoC predictable?',
          answer:
              'Because all changes flow from events to states in one place.',
        ),
        _SelfCheck(
          question: 'What should be inside Bloc vs UI?',
          answer: 'Bloc holds logic; UI listens and renders.',
        ),
      ],
    );
  }
}

class _CubitConceptTab extends StatelessWidget {
  const _CubitConceptTab();

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      title: 'Cubit: simpler BLoC',
      notes:
          'What it is:\n'
          '• Cubit exposes methods that emit states directly.\n'
          '• Less boilerplate than Bloc events.\n\n'
          'When to use:\n'
          '• Simple flows: counters, toggles, form fields.\n\n'
          'Typical mistakes/pitfalls:\n'
          '• Mixing UI code into Cubit methods.\n'
          '• Not limiting state size or history.',
      miniTitle: 'Mini example: counter + history (last 10)',
      child: const _CounterCubitDemo(),
      definitions: const [
        'Cubit is BLoC without events.\nYou call methods directly.',
        'Great starting point before full Bloc.',
      ],
      checklist: const [
        'Use Cubit for local, simple business logic.',
        'Upgrade to Bloc when events become complex.',
      ],
      questions: const [
        _SelfCheck(
          question: 'When should I switch from Cubit to Bloc?',
          answer: 'When you need multiple event types or complex flows.',
        ),
      ],
    );
  }
}

class _ProviderConceptTab extends StatelessWidget {
  const _ProviderConceptTab();

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      title: 'BlocProvider, BlocBuilder, BlocListener',
      notes:
          'What it is:\n'
          '• BlocProvider creates and exposes a Bloc/Cubit.\n'
          '• BlocBuilder rebuilds UI on state changes.\n'
          '• BlocListener reacts once (snackbar, navigation).\n\n'
          'When to use:\n'
          '• Provider at screen root, Builder for UI, Listener for side‑effects.\n\n'
          'Typical mistakes/pitfalls:\n'
          '• Using BlocBuilder for navigation/side‑effects.\n'
          '• Rebuilding large trees without BlocSelector.',
      miniTitle: 'Mini example: listener + selector',
      child: const _ProviderDemo(),
      definitions: const [
        'Builder = UI; Listener = side effects.',
        'Selector = rebuild only when selected state changes.',
      ],
      checklist: const [
        'Use Listener for snackbars/navigation.',
        'Use Selector to avoid heavy rebuilds.',
      ],
      questions: const [
        _SelfCheck(
          question: 'Why use BlocSelector?',
          answer:
              'To rebuild only widgets that need a specific slice of state.',
        ),
      ],
    );
  }
}

class _StatePatternTab extends StatelessWidget {
  const _StatePatternTab();

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      title: 'Loading / Success / Error states',
      notes:
          'What it is:\n'
          '• A common state pattern for async work.\n'
          '• UI shows progress, data, or error with retry.\n\n'
          'When to use:\n'
          '• Network requests, database calls, file IO.\n\n'
          'Typical mistakes/pitfalls:\n'
          '• Not handling empty data separately.\n'
          '• Forgetting retry/refresh paths.',
      miniTitle: 'Mini example: data load screen',
      child: const _LoadStateDemo(),
      definitions: const [
        'Loading = show spinner; Success = show data; Error = show retry.',
      ],
      checklist: const [
        'Always handle empty and error states.',
        'Provide a retry action for errors.',
      ],
      questions: const [
        _SelfCheck(
          question: 'What UI should appear on Error state?',
          answer: 'A clear message and a retry button.',
        ),
      ],
    );
  }
}

class _PracticeTab extends StatelessWidget {
  const _PracticeTab();

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      title: 'Practice result',
      notes:
          'Includes:\n'
          '• Cubit counter + history + clear.\n'
          '• Bloc login with validation and loading/success/error.\n'
          '• Data loading screen with Retry and edge cases.',
      miniTitle: 'Practice screen: load data with edge cases',
      child: const _LoadStateDemo(showControls: true),
      definitions: const [
        'Edge cases: empty list, long text, load/save error.',
      ],
      checklist: const [
        'Check empty data rendering.',
        'Check long text wrapping.',
        'Check error/retry flow.',
      ],
      questions: const [
        _SelfCheck(
          question: 'How to avoid rebuilds of the whole screen?',
          answer:
              'Split into widgets and use BlocSelector/BlocBuilder precisely.',
        ),
      ],
    );
  }
}

class _TabScaffold extends StatelessWidget {
  final String title;
  final String notes;
  final String miniTitle;
  final Widget child;
  final List<String> definitions;
  final List<String> checklist;
  final List<_SelfCheck> questions;

  const _TabScaffold({
    required this.title,
    required this.notes,
    required this.miniTitle,
    required this.child,
    required this.definitions,
    required this.checklist,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title),
          const SizedBox(height: 12),
          _NoteCard(title: 'Notes', content: notes),
          const SizedBox(height: 16),
          _SectionTitle('Definitions (own words)'),
          const SizedBox(height: 8),
          _BulletCard(items: definitions),
          const SizedBox(height: 16),
          _SectionTitle('Checklist: when to use'),
          const SizedBox(height: 8),
          _BulletCard(items: checklist),
          const SizedBox(height: 16),
          _SectionTitle('Self‑check Q&A'),
          const SizedBox(height: 8),
          _QuestionCard(items: questions),
          const SizedBox(height: 16),
          _SectionTitle(miniTitle),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final String title;
  final String content;

  const _NoteCard({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

class _BulletCard extends StatelessWidget {
  final List<String> items;

  const _BulletCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('• $item', style: const TextStyle(fontSize: 13)),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final List<_SelfCheck> items;

  const _QuestionCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Q: ${item.question}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'A: ${item.answer}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SelfCheck {
  final String question;
  final String answer;

  const _SelfCheck({required this.question, required this.answer});
}

// --------------------------------- Cubit demo

class CounterState {
  final int value;
  final List<String> history;

  const CounterState({required this.value, required this.history});

  CounterState copyWith({int? value, List<String>? history}) {
    return CounterState(
      value: value ?? this.value,
      history: history ?? this.history,
    );
  }
}

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterState(value: 0, history: []));

  void increment() => _addEvent('Increment', state.value + 1);
  void decrement() => _addEvent('Decrement', state.value - 1);
  void reset() => emit(const CounterState(value: 0, history: []));

  void clearHistory() {
    emit(state.copyWith(history: []));
  }

  void _addEvent(String label, int nextValue) {
    final List<String> updated = <String>[
      '$label → $nextValue',
      ...state.history,
    ];
    emit(state.copyWith(value: nextValue, history: updated.take(10).toList()));
  }
}

class _CounterCubitDemo extends StatelessWidget {
  const _CounterCubitDemo();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const _CounterCubitView(),
    );
  }
}

class _CounterCubitView extends StatelessWidget {
  const _CounterCubitView();

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: Column(
        children: [
          BlocSelector<CounterCubit, CounterState, int>(
            selector: (state) => state.value,
            builder: (context, value) {
              return Text(
                'Count: $value',
                style: const TextStyle(fontSize: 18),
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.read<CounterCubit>().decrement(),
                  child: const Text('-1'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.read<CounterCubit>().increment(),
                  child: const Text('+1'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.read<CounterCubit>().reset(),
                  child: const Text('Reset'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _HistoryHeader(
            onClear: () => context.read<CounterCubit>().clearHistory(),
          ),
          const SizedBox(height: 8),
          const _HistoryList(),
        ],
      ),
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  final VoidCallback onClear;

  const _HistoryHeader({required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Last 10 actions',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        TextButton(onPressed: onClear, child: const Text('Clear')),
      ],
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterCubit, CounterState>(
      buildWhen: (previous, current) => previous.history != current.history,
      builder: (context, state) {
        if (state.history.isEmpty) {
          return const Text('No actions yet.', style: TextStyle(fontSize: 12));
        }
        return Column(
          children: state.history
              .map(
                (entry) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(entry, style: const TextStyle(fontSize: 12)),
                  leading: const Icon(Icons.history, size: 16),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

// --------------------------------- Login Bloc demo

enum FormStatus { idle, loading, success, error }

class LoginState {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final FormStatus status;
  final String? message;

  const LoginState({
    required this.email,
    required this.password,
    this.emailError,
    this.passwordError,
    this.status = FormStatus.idle,
    this.message,
  });

  bool get isValid => emailError == null && passwordError == null;

  LoginState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    FormStatus? status,
    String? message,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError,
      passwordError: passwordError,
      status: status ?? this.status,
      message: message,
    );
  }
}

abstract class LoginEvent {
  const LoginEvent();
}

class EmailChanged extends LoginEvent {
  final String value;

  const EmailChanged(this.value);
}

class PasswordChanged extends LoginEvent {
  final String value;

  const PasswordChanged(this.value);
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState(email: '', password: '')) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        email: event.value,
        emailError: _validateEmail(event.value),
        status: FormStatus.idle,
        message: null,
      ),
    );
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        password: event.value,
        passwordError: _validatePassword(event.value),
        status: FormStatus.idle,
        message: null,
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final String? emailError = _validateEmail(state.email);
    final String? passwordError = _validatePassword(state.password);

    if (emailError != null || passwordError != null) {
      emit(
        state.copyWith(
          emailError: emailError,
          passwordError: passwordError,
          status: FormStatus.error,
          message: 'Fix validation errors.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: FormStatus.loading, message: null));
    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (state.password == '123456') {
      emit(
        state.copyWith(
          status: FormStatus.error,
          message: 'Weak password detected.',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: FormStatus.success,
          message: 'Login successful.',
        ),
      );
    }
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Invalid email';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Min 6 characters';
    }
    return null;
  }
}

class _LoginBlocDemo extends StatelessWidget {
  const _LoginBlocDemo();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: const _LoginBlocView(),
    );
  }
}

class _LoginBlocView extends StatelessWidget {
  const _LoginBlocView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) => previous.message != current.message,
      listener: (context, state) {
        if (state.message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message!)));
        }
      },
      child: _DemoCard(
        child: Column(
          children: [
            const _EmailField(),
            const SizedBox(height: 12),
            const _PasswordField(),
            const SizedBox(height: 12),
            const _SubmitButton(),
          ],
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LoginBloc, LoginState, String?>(
      selector: (state) => state.emailError,
      builder: (context, error) {
        return TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: error,
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) =>
              context.read<LoginBloc>().add(EmailChanged(value)),
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LoginBloc, LoginState, String?>(
      selector: (state) => state.passwordError,
      builder: (context, error) {
        return TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: error,
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) =>
              context.read<LoginBloc>().add(PasswordChanged(value)),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        final bool isLoading = state.status == FormStatus.loading;
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () => context.read<LoginBloc>().add(const LoginSubmitted()),
            child: isLoading
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Login'),
          ),
        );
      },
    );
  }
}

class _ProviderDemo extends StatelessWidget {
  const _ProviderDemo();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const _ProviderView(),
    );
  }
}

class _ProviderView extends StatelessWidget {
  const _ProviderView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CounterCubit, CounterState>(
      listenWhen: (previous, current) => previous.value != current.value,
      listener: (context, state) {
        if (state.value == 3) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Count reached 3')));
        }
      },
      child: _DemoCard(
        child: Column(
          children: [
            BlocSelector<CounterCubit, CounterState, int>(
              selector: (state) => state.value,
              builder: (context, value) {
                return Text('Value: $value');
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.read<CounterCubit>().increment(),
              child: const Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------------------- Load state demo

enum LoadMode { success, empty, longText, error }

enum LoadStatus { loading, success, error }

class LoadState {
  final LoadStatus status;
  final List<String> items;
  final String? errorMessage;

  const LoadState({
    required this.status,
    this.items = const [],
    this.errorMessage,
  });

  LoadState copyWith({
    LoadStatus? status,
    List<String>? items,
    String? errorMessage,
  }) {
    return LoadState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }
}

class LoadCubit extends Cubit<LoadState> {
  LoadCubit() : super(const LoadState(status: LoadStatus.loading));

  Future<void> load(LoadMode mode) async {
    emit(state.copyWith(status: LoadStatus.loading, errorMessage: null));
    await Future<void>.delayed(const Duration(milliseconds: 700));

    switch (mode) {
      case LoadMode.success:
        emit(
          state.copyWith(
            status: LoadStatus.success,
            items: const ['Alpha', 'Beta', 'Gamma'],
          ),
        );
        break;
      case LoadMode.empty:
        emit(state.copyWith(status: LoadStatus.success, items: const []));
        break;
      case LoadMode.longText:
        emit(
          state.copyWith(
            status: LoadStatus.success,
            items: const [
              'Very long text item that should wrap properly and not overflow '
                  'the layout. It demonstrates how the UI handles long content.',
            ],
          ),
        );
        break;
      case LoadMode.error:
        emit(
          state.copyWith(
            status: LoadStatus.error,
            errorMessage: 'Failed to load data. Please retry.',
          ),
        );
        break;
    }
  }
}

class _LoadStateDemo extends StatelessWidget {
  final bool showControls;

  const _LoadStateDemo({this.showControls = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoadCubit()..load(LoadMode.success),
      child: _DemoCard(
        child: Column(
          children: [
            if (showControls) const _LoadControls(),
            const SizedBox(height: 8),
            const _LoadView(),
          ],
        ),
      ),
    );
  }
}

class _LoadControls extends StatelessWidget {
  const _LoadControls();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        OutlinedButton(
          onPressed: () => context.read<LoadCubit>().load(LoadMode.success),
          child: const Text('Load success'),
        ),
        OutlinedButton(
          onPressed: () => context.read<LoadCubit>().load(LoadMode.empty),
          child: const Text('Load empty'),
        ),
        OutlinedButton(
          onPressed: () => context.read<LoadCubit>().load(LoadMode.longText),
          child: const Text('Load long text'),
        ),
        OutlinedButton(
          onPressed: () => context.read<LoadCubit>().load(LoadMode.error),
          child: const Text('Load error'),
        ),
      ],
    );
  }
}

class _LoadView extends StatelessWidget {
  const _LoadView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadCubit, LoadState>(
      builder: (context, state) {
        switch (state.status) {
          case LoadStatus.loading:
            return const _LoadingState();
          case LoadStatus.error:
            return _ErrorState(message: state.errorMessage ?? 'Unknown error');
          case LoadStatus.success:
            if (state.items.isEmpty) {
              return const _EmptyState();
            }
            return _SuccessState(items: state.items);
        }
      },
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text('Loading data...'),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(message, style: const TextStyle(color: Colors.red)),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => context.read<LoadCubit>().load(LoadMode.success),
          child: const Text('Retry'),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Text('No data available.');
  }
}

class _SuccessState extends StatelessWidget {
  final List<String> items;

  const _SuccessState({required this.items});

  @override
  Widget build(BuildContext context) {
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
