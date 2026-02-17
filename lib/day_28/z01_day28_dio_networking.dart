import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// ============================================================================
// Flutter - Home work Lesson 28
// ============================================================================
// 1) Learn: Dio client with baseUrl, timeouts, logging interceptors.
//    - Mini example + notes.
// 2) Learn: Error handling for different HTTP status codes.
//    - Mini example + notes.
// 3) Learn: CancelToken for request cancellation on dispose.
//    - Mini example + notes.
// 4) Learn: Retry mechanism for network errors.
//    - Mini example + notes.
// 5) Practice:
//    - Dio client setup with interceptors.
//    - Error handling: 400/401/500 and network errors.
//    - Request cancellation with CancelToken.
//    - Optional: Retry logic and file upload with progress.

class Day28DioNetworkingApp extends StatefulWidget {
  const Day28DioNetworkingApp({super.key});

  @override
  State<Day28DioNetworkingApp> createState() => _Day28DioNetworkingAppState();
}

class _Day28DioNetworkingAppState extends State<Day28DioNetworkingApp>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
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
        title: const Text('Day 28 · Dio Networking'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 38, 64, 84),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          isScrollable: true,
          tabs: const [
            Tab(text: '🌐 Dio Setup'),
            Tab(text: '⚠️ Errors'),
            Tab(text: '❌ Cancel'),
            Tab(text: '🔄 Retry'),
            Tab(text: '📤 Upload'),
            Tab(text: '🧪 Practice'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _DioSetupTab(),
          _ErrorHandlingTab(),
          _CancelTokenTab(),
          _RetryTab(),
          _FileUploadTab(),
          _PracticeTab(),
        ],
      ),
    );
  }
}

// ============================================================================
// Tab 1: Dio Setup with interceptors
// ============================================================================

class _DioSetupTab extends StatelessWidget {
  const _DioSetupTab();

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      title: 'Dio Client Setup',
      notes:
          'What it is:\n'
          '• Dio is a powerful HTTP client for Dart/Flutter.\n'
          '• Supports interceptors, timeouts, cancellation, file upload/download.\n\n'
          'When to use:\n'
          '• Advanced HTTP features: interceptors, retry, progress.\n'
          '• Better error handling and logging.\n\n'
          'Typical mistakes/pitfalls:\n'
          '• Not setting timeouts → app hangs on slow networks.\n'
          '• Not handling errors properly → poor UX.\n'
          '• Not canceling requests on dispose → memory leaks.',
      codeSnippet: _dioSetupCode,
      demo: const _DioSetupDemo(),
    );
  }
}

const _dioSetupCode = '''
// Create Dio client with configuration
Dio createDioClient() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add logging interceptor
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      compact: true,
    ),
  );

  // Custom interceptor for auth tokens
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token to requests
        // options.headers['Authorization'] = 'Bearer \$token';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Process responses
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        // Global error handling
        return handler.next(e);
      },
    ),
  );

  return dio;
}
''';

class _DioSetupDemo extends StatefulWidget {
  const _DioSetupDemo();

  @override
  State<_DioSetupDemo> createState() => _DioSetupDemoState();
}

class _DioSetupDemoState extends State<_DioSetupDemo> {
  late final Dio _dio;
  String _result = 'Tap "Fetch Data" to make a request';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _dio = _createDioClient();
  }

  Dio _createDioClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
      ),
    );

    return dio;
  }

  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
      _result = 'Loading...';
    });

    try {
      final response = await _dio.get('/posts/1');
      setState(() {
        _result = 'Success!\n\n'
            'Title: ${response.data['title']}\n\n'
            'Body: ${response.data['body']}';
      });
    } on DioException catch (e) {
      setState(() {
        _result = 'Error: ${e.message}';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _loading ? null : _fetchData,
          icon: const Icon(Icons.cloud_download),
          label: const Text('Fetch Data'),
        ),
        const SizedBox(height: 16),
        if (_loading) const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(_result),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// Tab 2: Error Handling
// ============================================================================

class _ErrorHandlingTab extends StatelessWidget {
  const _ErrorHandlingTab();

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      title: 'Error Handling',
      notes:
          'What it is:\n'
          '• Handle different HTTP status codes (400, 401, 500, etc.).\n'
          '• Show user-friendly messages for each error type.\n'
          '• Handle network errors (no internet, timeout).\n\n'
          'When to use:\n'
          '• Always! Good error handling improves UX.\n\n'
          'Typical mistakes/pitfalls:\n'
          '• Showing technical error messages to users.\n'
          '• Not handling network errors separately.\n'
          '• Not showing retry options.',
      codeSnippet: _errorHandlingCode,
      demo: const _ErrorHandlingDemo(),
    );
  }
}

const _errorHandlingCode = '''
String _getErrorMessage(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'Connection timeout. Please check your internet.';
      
    case DioExceptionType.connectionError:
      return 'No internet connection. Please try again.';
      
    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      switch (statusCode) {
        case 400:
          return 'Bad request. Please check your input.';
        case 401:
          return 'Unauthorized. Please login again.';
        case 403:
          return 'Access forbidden.';
        case 404:
          return 'Resource not found.';
        case 500:
        case 502:
        case 503:
          return 'Server error. Please try again later.';
        default:
          return 'Request failed: \$statusCode';
      }
      
    case DioExceptionType.cancel:
      return 'Request was cancelled.';
      
    default:
      return 'An unexpected error occurred.';
  }
}

// Usage
try {
  await dio.get('/endpoint');
} on DioException catch (e) {
  final message = _getErrorMessage(e);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
''';

class _ErrorHandlingDemo extends StatefulWidget {
  const _ErrorHandlingDemo();

  @override
  State<_ErrorHandlingDemo> createState() => _ErrorHandlingDemoState();
}

class _ErrorHandlingDemoState extends State<_ErrorHandlingDemo> {
  late final Dio _dio;
  String _result = 'Try different error scenarios';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );
  }

  String _getErrorMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return '⏱️ Connection timeout. Please check your internet.';

      case DioExceptionType.connectionError:
        return '📡 No internet connection. Please try again.';

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        switch (statusCode) {
          case 400:
            return '❌ Bad request (400). Please check your input.';
          case 401:
            return '🔒 Unauthorized (401). Please login again.';
          case 403:
            return '🚫 Access forbidden (403).';
          case 404:
            return '🔍 Resource not found (404).';
          case 500:
          case 502:
          case 503:
            return '🔥 Server error ($statusCode). Please try again later.';
          default:
            return '⚠️ Request failed: $statusCode';
        }

      case DioExceptionType.cancel:
        return '🛑 Request was cancelled.';

      default:
        return '💥 An unexpected error occurred.';
    }
  }

  Future<void> _makeRequest(String url, String label) async {
    setState(() {
      _loading = true;
      _result = 'Loading $label...';
    });

    try {
      final response = await _dio.get(url);
      setState(() {
        _result = '✅ $label Success!\n\n'
            'Status: ${response.statusCode}\n'
            'Data: ${response.data.toString().substring(0, 100)}...';
      });
    } on DioException catch (e) {
      final message = _getErrorMessage(e);
      setState(() {
        _result = '$label Error:\n\n$message';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _loading
                  ? null
                  : () => _makeRequest('/posts/1', 'Valid Request'),
              child: const Text('✅ 200 OK'),
            ),
            ElevatedButton(
              onPressed: _loading
                  ? null
                  : () => _makeRequest('/posts/99999', '404 Error'),
              child: const Text('🔍 404'),
            ),
            ElevatedButton(
              onPressed: _loading
                  ? null
                  : () => _makeRequest(
                        'https://httpstat.us/500?sleep=1000',
                        '500 Error',
                      ),
              child: const Text('🔥 500'),
            ),
            ElevatedButton(
              onPressed: _loading
                  ? null
                  : () => _makeRequest(
                        'https://httpstat.us/401',
                        '401 Error',
                      ),
              child: const Text('🔒 401'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_loading) const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(_result),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _dio.close();
    super.dispose();
  }
}

// ============================================================================
// Tab 3: CancelToken
// ============================================================================

class _CancelTokenTab extends StatelessWidget {
  const _CancelTokenTab();

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      title: 'Request Cancellation',
      notes:
          'What it is:\n'
          '• CancelToken allows canceling ongoing requests.\n'
          '• Essential when user navigates away from a page.\n'
          '• Prevents memory leaks and unnecessary work.\n\n'
          'When to use:\n'
          '• Always cancel requests in dispose().\n'
          '• When user explicitly cancels an action.\n\n'
          'Typical mistakes/pitfalls:\n'
          '• Not canceling requests → memory leaks.\n'
          '• Not handling cancel errors → app crashes.',
      codeSnippet: _cancelTokenCode,
      demo: const _CancelTokenDemo(),
    );
  }
}

const _cancelTokenCode = '''
class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late final Dio _dio;
  CancelToken? _cancelToken;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    _loadData();
  }

  Future<void> _loadData() async {
    // Create cancel token for this request
    _cancelToken = CancelToken();
    
    try {
      final response = await _dio.get(
        '/data',
        cancelToken: _cancelToken,
      );
      // Process response
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        print('Request cancelled');
      } else {
        // Handle other errors
      }
    }
  }

  void _cancelRequest() {
    _cancelToken?.cancel('User cancelled');
  }

  @override
  void dispose() {
    // Cancel ongoing request when page is disposed
    _cancelToken?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: _cancelRequest,
        child: Icon(Icons.cancel),
      ),
    );
  }
}
''';

class _CancelTokenDemo extends StatefulWidget {
  const _CancelTokenDemo();

  @override
  State<_CancelTokenDemo> createState() => _CancelTokenDemoState();
}

class _CancelTokenDemoState extends State<_CancelTokenDemo> {
  late final Dio _dio;
  CancelToken? _cancelToken;
  String _result = 'Start a long request and try canceling it';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _dio = Dio(BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
    ));
  }

  Future<void> _startLongRequest() async {
    setState(() {
      _loading = true;
      _result = 'Loading data... (this will take 10 seconds)';
    });

    _cancelToken = CancelToken();

    try {
      // Simulate long request with delay parameter
      final response = await _dio.get(
        'https://httpbin.org/delay/10',
        cancelToken: _cancelToken,
      );
      setState(() {
        _result = '✅ Request completed!\n\n${response.data}';
      });
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        setState(() {
          _result = '🛑 Request was cancelled by user';
        });
      } else {
        setState(() {
          _result = '❌ Error: ${e.message}';
        });
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _cancelRequest() {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel('User pressed cancel button');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cancelling request...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _loading ? null : _startLongRequest,
              icon: const Icon(Icons.cloud_download),
              label: const Text('Start Long Request'),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _loading ? _cancelRequest : null,
              icon: const Icon(Icons.cancel),
              label: const Text('Cancel'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[100],
                foregroundColor: Colors.red[900],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_loading) const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(_result),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _cancelToken?.cancel();
    _dio.close();
    super.dispose();
  }
}

// ============================================================================
// Tab 4: Retry Mechanism
// ============================================================================

class _RetryTab extends StatelessWidget {
  const _RetryTab();

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      title: 'Retry Mechanism',
      notes:
          'What it is:\n'
          '• Automatically retry failed requests.\n'
          '• Useful for network errors or temporary server issues.\n'
          '• Use exponential backoff for better UX.\n\n'
          'When to use:\n'
          '• Network errors that might be temporary.\n'
          '• Critical requests that must succeed.\n\n'
          'Typical mistakes/pitfalls:\n'
          '• Retrying too many times → poor UX.\n'
          '• Not using backoff → server overload.\n'
          '• Retrying 4xx errors (client errors).',
      codeSnippet: _retryCode,
      demo: const _RetryDemo(),
    );
  }
}

const _retryCode = '''
// Retry interceptor
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;

  RetryInterceptor({required this.dio, this.maxRetries = 3});

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final extra = err.requestOptions.extra;
    final retries = extra['retries'] ?? 0;

    // Only retry on network errors, not client errors
    if (retries < maxRetries && _shouldRetry(err)) {
      await Future.delayed(Duration(seconds: retries + 1));
      
      final options = err.requestOptions;
      options.extra['retries'] = retries + 1;
      
      try {
        final response = await dio.fetch(options);
        return handler.resolve(response);
      } catch (e) {
        return super.onError(err, handler);
      }
    }
    
    return super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.connectionError ||
           (err.response?.statusCode ?? 0) >= 500;
  }
}

// Usage
final dio = Dio();
dio.interceptors.add(RetryInterceptor(dio: dio, maxRetries: 2));
''';

class _RetryDemo extends StatefulWidget {
  const _RetryDemo();

  @override
  State<_RetryDemo> createState() => _RetryDemoState();
}

class _RetryDemoState extends State<_RetryDemo> {
  late final Dio _dio;
  String _result = 'Try the retry mechanism';
  bool _loading = false;
  final List<String> _retryLog = [];

  @override
  void initState() {
    super.initState();
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ));
    _dio.interceptors.add(_RetryInterceptor(dio: _dio));
  }

  Future<void> _makeUnstableRequest() async {
    setState(() {
      _loading = true;
      _result = 'Making request with retry...';
      _retryLog.clear();
    });

    try {
      // Simulating unstable endpoint (50% success rate)
      await _dio.get(
        'https://httpbin.org/status/200,500',
      );
      setState(() {
        _result = '✅ Success after ${_retryLog.length} attempts!\n\n'
            'Log:\n${_retryLog.join('\n')}';
      });
    } on DioException catch (e) {
      setState(() {
        _result = '❌ Failed after ${_retryLog.length} attempts\n\n'
            'Log:\n${_retryLog.join('\n')}\n\n'
            'Error: ${e.message}';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _loading ? null : _makeUnstableRequest,
          icon: const Icon(Icons.refresh),
          label: const Text('Try Unstable Request'),
        ),
        const SizedBox(height: 16),
        if (_loading) const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(_result),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _dio.close();
    super.dispose();
  }
}

// Retry Interceptor Implementation
class _RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;

  _RetryInterceptor({required this.dio, this.maxRetries = 3});

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final extra = err.requestOptions.extra;
    final retries = extra['retries'] ?? 0;

    if (retries < maxRetries && _shouldRetry(err)) {
      debugPrint('🔄 Retry attempt ${retries + 1}/$maxRetries');
      
      await Future.delayed(Duration(seconds: retries + 1));

      final options = err.requestOptions;
      options.extra['retries'] = retries + 1;

      try {
        final response = await dio.fetch(options);
        return handler.resolve(response);
      } catch (e) {
        return super.onError(err, handler);
      }
    }

    return super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode ?? 0) >= 500;
  }
}

// ============================================================================
// Tab 5: File Upload with Progress
// ============================================================================

class _FileUploadTab extends StatelessWidget {
  const _FileUploadTab();

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      title: 'File Upload with Progress',
      notes:
          'What it is:\n'
          '• Upload files with progress tracking.\n'
          '• Show progress indicator to user.\n'
          '• Use FormData for multipart uploads.\n\n'
          'When to use:\n'
          '• Uploading images, videos, or documents.\n'
          '• Any large file upload requiring progress.\n\n'
          'Typical mistakes/pitfalls:\n'
          '• Not showing progress → poor UX.\n'
          '• Not handling upload cancellation.\n'
          '• Not validating file size before upload.',
      codeSnippet: _fileUploadCode,
      demo: const _FileUploadDemo(),
    );
  }
}

const _fileUploadCode = '''
Future<void> uploadFile(File file) async {
  final dio = Dio();
  
  // Create FormData
  final formData = FormData.fromMap({
    'file': await MultipartFile.fromFile(
      file.path,
      filename: file.path.split('/').last,
    ),
    'description': 'My uploaded file',
  });

  try {
    final response = await dio.post(
      'https://api.example.com/upload',
      data: formData,
      onSendProgress: (sent, total) {
        final progress = (sent / total * 100).toStringAsFixed(0);
        print('Upload progress: \$progress%');
        // Update UI with progress
      },
    );
    
    print('Upload complete: \${response.data}');
  } on DioException catch (e) {
    print('Upload failed: \${e.message}');
  }
}

// Download with progress
Future<void> downloadFile(String url, String savePath) async {
  final dio = Dio();
  
  await dio.download(
    url,
    savePath,
    onReceiveProgress: (received, total) {
      if (total != -1) {
        final progress = (received / total * 100).toStringAsFixed(0);
        print('Download progress: \$progress%');
      }
    },
  );
}
''';

class _FileUploadDemo extends StatefulWidget {
  const _FileUploadDemo();

  @override
  State<_FileUploadDemo> createState() => _FileUploadDemoState();
}

class _FileUploadDemoState extends State<_FileUploadDemo> {
  late final Dio _dio;
  double _uploadProgress = 0.0;
  double _downloadProgress = 0.0;
  bool _uploading = false;
  bool _downloading = false;
  String _result = 'Simulate file upload/download with progress';

  @override
  void initState() {
    super.initState();
    _dio = Dio();
  }

  Future<void> _simulateUpload() async {
    setState(() {
      _uploading = true;
      _uploadProgress = 0.0;
      _result = 'Starting upload...';
    });

    try {
      // Simulate upload to httpbin
      final data = List.generate(1000, (i) => 'data_$i').join(',');
      
      await _dio.post(
        'https://httpbin.org/post',
        data: data,
        onSendProgress: (sent, total) {
          setState(() {
            _uploadProgress = sent / total;
            _result = 'Uploading... ${(_uploadProgress * 100).toStringAsFixed(1)}%';
          });
        },
      );

      setState(() {
        _result = '✅ Upload complete! 100%';
      });
    } on DioException catch (e) {
      setState(() {
        _result = '❌ Upload failed: ${e.message}';
      });
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

  Future<void> _simulateDownload() async {
    setState(() {
      _downloading = true;
      _downloadProgress = 0.0;
      _result = 'Starting download...';
    });

    try {
      // Download a sample image
      await _dio.get(
        'https://picsum.photos/2000/2000',
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = received / total;
              _result = 'Downloading... ${(_downloadProgress * 100).toStringAsFixed(1)}%';
            });
          }
        },
      );

      setState(() {
        _result = '✅ Download complete! 100%';
      });
    } on DioException catch (e) {
      setState(() {
        _result = '❌ Download failed: ${e.message}';
      });
    } finally {
      setState(() {
        _downloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text('Upload Progress', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: LinearProgressIndicator(
            value: _uploadProgress,
            minHeight: 10,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
        const SizedBox(height: 8),
        Text('${(_uploadProgress * 100).toStringAsFixed(0)}%'),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _uploading ? null : _simulateUpload,
          icon: const Icon(Icons.upload),
          label: const Text('Simulate Upload'),
        ),
        const SizedBox(height: 32),
        const Text('Download Progress', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: LinearProgressIndicator(
            value: _downloadProgress,
            minHeight: 10,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ),
        const SizedBox(height: 8),
        Text('${(_downloadProgress * 100).toStringAsFixed(0)}%'),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _downloading ? null : _simulateDownload,
          icon: const Icon(Icons.download),
          label: const Text('Simulate Download'),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(_result),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _dio.close();
    super.dispose();
  }
}

// ============================================================================
// Tab 6: Practice - Complete Example
// ============================================================================

class _PracticeTab extends StatelessWidget {
  const _PracticeTab();

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      title: 'Complete Practice',
      notes:
          'Complete Dio Client Example:\n'
          '• ✅ Custom Dio client with baseUrl and timeouts\n'
          '• ✅ Logging interceptor for requests/responses\n'
          '• ✅ Error handling for 400/401/500 and network errors\n'
          '• ✅ CancelToken for request cancellation\n'
          '• ✅ Retry mechanism for network errors\n'
          '• ✅ File upload/download with progress\n\n'
          'Best Practices:\n'
          '• Always set timeouts to prevent hanging.\n'
          '• Always cancel requests in dispose().\n'
          '• Show user-friendly error messages.\n'
          '• Use retry carefully (only for network errors).\n'
          '• Track progress for large uploads/downloads.',
      codeSnippet: '',
      demo: const _CompletePracticeDemo(),
    );
  }
}

class _CompletePracticeDemo extends StatefulWidget {
  const _CompletePracticeDemo();

  @override
  State<_CompletePracticeDemo> createState() => _CompletePracticeDemoState();
}

class _CompletePracticeDemoState extends State<_CompletePracticeDemo> {
  late final Dio _dio;
  final List<Map<String, dynamic>> _posts = [];
  bool _loading = false;
  String? _error;
  CancelToken? _cancelToken;

  @override
  void initState() {
    super.initState();
    _dio = _createDioClient();
    _loadPosts();
  }

  Dio _createDioClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
        error: true,
        compact: true,
      ),
    );

    dio.interceptors.add(_RetryInterceptor(dio: dio, maxRetries: 2));

    return dio;
  }

  Future<void> _loadPosts() async {
    setState(() {
      _loading = true;
      _error = null;
      _posts.clear();
    });

    _cancelToken = CancelToken();

    try {
      // Make a real API call to demonstrate Dio in action
      await _dio.get(
        '/posts',
        queryParameters: {'_limit': 10},
        cancelToken: _cancelToken,
      );

      // Use readable English data instead of Lorem Ipsum
      final List<Map<String, dynamic>> englishPosts = [
        {
          'id': 1,
          'title': 'Getting Started with Dio HTTP Client',
          'body': 'Learn how to make HTTP requests efficiently using Dio. This powerful package provides many features like interceptors, request cancellation, and automatic retry.',
        },
        {
          'id': 2,
          'title': 'Understanding Error Handling',
          'body': 'Different HTTP status codes mean different things. Learn how to handle 400, 401, 500 errors and provide better user experience with meaningful error messages.',
        },
        {
          'id': 3,
          'title': 'Request Cancellation Best Practices',
          'body': 'Always cancel pending requests when user navigates away. Use CancelToken to prevent memory leaks and improve app performance.',
        },
        {
          'id': 4,
          'title': 'Implementing Retry Logic',
          'body': 'Network errors happen. Implement smart retry mechanisms with exponential backoff to handle temporary failures gracefully.',
        },
        {
          'id': 5,
          'title': 'File Upload with Progress Tracking',
          'body': 'Show users real-time upload progress. Use onSendProgress callback to update UI and provide better feedback during file uploads.',
        },
        {
          'id': 6,
          'title': 'Interceptors for Logging',
          'body': 'Debug your API calls effectively. Use interceptors to log requests, responses, and errors. PrettyDioLogger makes debugging easier.',
        },
        {
          'id': 7,
          'title': 'Setting Timeouts Properly',
          'body': 'Configure connection, send, and receive timeouts to prevent your app from hanging on slow networks. Always set reasonable timeout values.',
        },
        {
          'id': 8,
          'title': 'BaseURL Configuration',
          'body': 'Centralize your API configuration by setting a baseUrl. Makes it easy to switch between development and production environments.',
        },
        {
          'id': 9,
          'title': 'Authentication with Interceptors',
          'body': 'Automatically attach authentication tokens to every request using interceptors. Handle token refresh and unauthorized errors globally.',
        },
        {
          'id': 10,
          'title': 'Download Files Efficiently',
          'body': 'Download large files with progress tracking using onReceiveProgress. Show users download status and allow cancellation if needed.',
        },
      ];

      setState(() {
        _posts.addAll(englishPosts);
        _loading = false;
      });
    } on DioException catch (e) {
      if (e.type != DioExceptionType.cancel) {
        setState(() {
          _error = _getErrorMessage(e);
          _loading = false;
        });
      }
    }
  }

  String _getErrorMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please try again.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        switch (statusCode) {
          case 400:
            return 'Bad request. Please check your input.';
          case 401:
            return 'Unauthorized. Please login again.';
          case 500:
          case 502:
          case 503:
            return 'Server error. Please try again later.';
          default:
            return 'Request failed: $statusCode';
        }
      default:
        return 'An unexpected error occurred.';
    }
  }

  Future<void> _createPost() async {
    try {
      final response = await _dio.post(
        '/posts',
        data: {
          'title': 'New Post ${DateTime.now().second}',
          'body': 'This is a test post created with Dio',
          'userId': 1,
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Post created! ID: ${response.data['id']}')),
        );
      }
    } on DioException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_getErrorMessage(e))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _loadPosts,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _createPost,
                  icon: const Icon(Icons.add),
                  label: const Text('Create Post'),
                ),
              ),
            ],
          ),
        ),
        if (_loading)
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  '❌ $_error',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _loadPosts,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: _posts.length,
            itemBuilder: (context, index) {
              final post = _posts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${post['id']}'),
                  ),
                  title: Text(
                    post['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    post['body'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _cancelToken?.cancel();
    _dio.close();
    super.dispose();
  }
}

// ============================================================================
// Reusable Tab Scaffold
// ============================================================================

class _TabScaffold extends StatelessWidget {
  final String title;
  final String notes;
  final String codeSnippet;
  final Widget demo;

  const _TabScaffold({
    required this.title,
    required this.notes,
    required this.codeSnippet,
    required this.demo,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: codeSnippet.isEmpty ? 2 : 3,
      child: Column(
        children: [
          Container(
            color: Colors.grey[200],
            child: TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black54,
              tabs: [
                const Tab(text: '📝 Notes'),
                if (codeSnippet.isNotEmpty) const Tab(text: '💻 Code'),
                const Tab(text: '🎮 Demo'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _NotesView(title: title, notes: notes),
                if (codeSnippet.isNotEmpty) _CodeView(code: codeSnippet),
                demo,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesView extends StatelessWidget {
  final String title;
  final String notes;

  const _NotesView({required this.title, required this.notes});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(notes, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class _CodeView extends StatelessWidget {
  final String code;

  const _CodeView({required this.code});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: SelectableText(
          code,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
