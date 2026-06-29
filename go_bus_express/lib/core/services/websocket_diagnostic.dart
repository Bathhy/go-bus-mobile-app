import 'dart:async';
import 'dart:developer' as dev;
import 'package:web_socket_channel/web_socket_channel.dart';

/// Diagnostic tool to test WebSocket connectivity
class WebSocketDiagnostic {
  static Future<DiagnosticResult> testConnection(String url) async {
    final startTime = DateTime.now();
    
    try {
      dev.log('[WS Diagnostic] Testing connection to: $url');
      
      final uri = Uri.parse(url);
      final channel = WebSocketChannel.connect(uri);
      
      await channel.ready.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Connection timeout after 10 seconds');
        },
      );
      
      final duration = DateTime.now().difference(startTime);
      dev.log('[WS Diagnostic] Connected in ${duration.inMilliseconds}ms');
      
      await channel.sink.close();
      
      return DiagnosticResult(
        success: true,
        message: 'Connected successfully in ${duration.inMilliseconds}ms',
        duration: duration,
      );
    } catch (e) {
      final duration = DateTime.now().difference(startTime);
      dev.log('[WS Diagnostic] Failed: $e');
      
      return DiagnosticResult(
        success: false,
        message: 'Connection failed: $e',
        duration: duration,
        error: e.toString(),
      );
    }
  }
  
  static void printConnectionInfo(String url) {
    dev.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    dev.log('WebSocket Connection Info');
    dev.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    dev.log('URL: $url');
    
    try {
      final uri = Uri.parse(url);
      dev.log('Scheme: ${uri.scheme}');
      dev.log('Host: ${uri.host}');
      dev.log('Port: ${uri.port}');
      dev.log('Path: ${uri.path}');
    } catch (e) {
      dev.log('Invalid URL format: $e');
    }
    
    dev.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }
}

class DiagnosticResult {
  final bool success;
  final String message;
  final Duration duration;
  final String? error;
  
  DiagnosticResult({
    required this.success,
    required this.message,
    required this.duration,
    this.error,
  });
  
  @override
  String toString() {
    return 'DiagnosticResult(success: $success, message: $message, duration: ${duration.inMilliseconds}ms)';
  }
}
