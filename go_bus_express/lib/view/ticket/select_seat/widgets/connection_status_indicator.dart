import 'package:flutter/material.dart';
import 'package:go_bus_express/core/services/websocket_service.dart';

class ConnectionStatusIndicator extends StatefulWidget {
  final ConnectionStatus status;
  final VoidCallback? onRetry;

  const ConnectionStatusIndicator({
    super.key,
    required this.status,
    this.onRetry,
  });

  @override
  State<ConnectionStatusIndicator> createState() =>
      _ConnectionStatusIndicatorState();
}

class _ConnectionStatusIndicatorState extends State<ConnectionStatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.status) {
      ConnectionStatus.connected => _dot(Colors.green),
      ConnectionStatus.connecting => _labelledDot(Colors.amber, 'Connecting...'),
      ConnectionStatus.disconnected => _labelledDot(Colors.orange, 'Reconnecting...'),
      ConnectionStatus.error => _errorRow(),
    };
  }

  Widget _dot(Color color) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );

  Widget _pulsingDot(Color color) => FadeTransition(
        opacity: _pulse,
        child: _dot(color),
      );

  Widget _labelledDot(Color color, String label) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _pulsingDot(color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: color),
          ),
        ],
      );

  Widget _errorRow() => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _dot(Colors.red),
          const SizedBox(width: 4),
          const Icon(Icons.wifi_off, size: 14, color: Colors.red),
          if (widget.onRetry != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: widget.onRetry,
              child: const Text(
                'Retry',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.red,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ],
      );
}
