import 'package:flutter/material.dart';
import 'package:go_bus_express/core/services/websocket_diagnostic.dart';
import 'package:go_bus_express/data/network/network_constant.dart';

/// Debug view to test WebSocket connectivity
class WebSocketTestView extends StatefulWidget {
  const WebSocketTestView({super.key});

  @override
  State<WebSocketTestView> createState() => _WebSocketTestViewState();
}

class _WebSocketTestViewState extends State<WebSocketTestView> {
  DiagnosticResult? _result;
  bool _testing = false;
  final _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _urlController.text = NetworkConstant.wsBaseUrl;
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _runTest() async {
    setState(() {
      _testing = true;
      _result = null;
    });

    final result = await WebSocketDiagnostic.testConnection(_urlController.text);

    setState(() {
      _result = result;
      _testing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSocket Diagnostic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'WebSocket URL:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'ws://host:port/path',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _testing ? null : _runTest,
              child: _testing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Test Connection'),
            ),
            const SizedBox(height: 24),
            if (_result != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _result!.success
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  border: Border.all(
                    color: _result!.success ? Colors.green : Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _result!.success ? Icons.check_circle : Icons.error,
                          color: _result!.success ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _result!.success ? 'Success' : 'Failed',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _result!.success ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Message: ${_result!.message}'),
                    const SizedBox(height: 8),
                    Text('Duration: ${_result!.duration.inMilliseconds}ms'),
                    if (_result!.error != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Error: ${_result!.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Troubleshooting Tips:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildTip('1. Check if the WebSocket server is running'),
            _buildTip('2. Verify the URL format (ws:// or wss://)'),
            _buildTip('3. Ensure the host and port are correct'),
            _buildTip('4. Check firewall/network settings'),
            _buildTip('5. Look at the logs in the console'),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 16, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
