import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';

class WalletPayPinDialog extends StatefulWidget {
  final Future<String?> Function(String pin) onPinSubmit;
  final String title;
  final String subtitle;

  const WalletPayPinDialog({
    super.key,
    required this.onPinSubmit,
    required this.title,
    required this.subtitle,
  });

  /// Shows the blur PIN dialog and returns a session token on success, null on cancel.
  static Future<String?> show(
    BuildContext context, {
    required Future<String?> Function(String pin) onPinSubmit,
    String? title,
    String? subtitle,
  }) {
    return showGeneralDialog<String?>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'pin-dialog',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 280),
      transitionBuilder: (ctx, animation, _, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.94, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
      pageBuilder: (ctx, _, __) => WalletPayPinDialog(
        onPinSubmit: onPinSubmit,
        title: title ?? 'wallet_pin'.tr,
        subtitle: subtitle ?? 'enter_pin_to_pay'.tr,
      ),
    );
  }

  @override
  State<WalletPayPinDialog> createState() => _WalletPayPinDialogState();
}

class _WalletPayPinDialogState extends State<WalletPayPinDialog>
    with SingleTickerProviderStateMixin {
  String _pin = '';
  static const int _pinLength = 4;
  bool _isLoading = false;
  String? _errorMessage;

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onTap(String digit) {
    if (_isLoading || _pin.length >= _pinLength) return;
    setState(() {
      _errorMessage = null;
      _pin += digit;
    });
    if (_pin.length == _pinLength) _submit(_pin);
  }

  void _onDelete() {
    if (_isLoading || _pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  Future<void> _submit(String pin) async {
    setState(() => _isLoading = true);
    try {
      final token = await widget.onPinSubmit(pin);
      if (mounted) Navigator.of(context).pop(token);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
          _pin = '';
        });
        _shakeController.forward().then((_) => _shakeController.reset());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          color: Colors.black.withOpacity(0.38),
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: XPadding.extralarge * 1.2),
            child: _buildCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.93),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.7), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 48,
            spreadRadius: 0,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          XPadding.extralarge,
          XPadding.large,
          XPadding.extralarge,
          XPadding.extralarge,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // iOS-style drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: XPadding.extralarge),

            // Lock icon
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: goBusPrimary.withOpacity(0.1),
              ),
              child: Icon(Icons.lock_rounded, size: 32, color: goBusPrimary),
            ),
            SizedBox(height: XPadding.large),

            // Title
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),

            // Subtitle
            Text(
              widget.subtitle,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: XPadding.extralarge),

            // PIN dots with shake
            AnimatedBuilder(
              animation: _shakeAnim,
              builder: (_, child) => Transform.translate(
                offset: Offset(
                  math.sin(_shakeAnim.value * math.pi * 5) * 10,
                  0,
                ),
                child: child,
              ),
              child: _buildDots(),
            ),

            // Error text
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: _errorMessage != null
                  ? Padding(
                      padding: EdgeInsets.only(top: XPadding.medium),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(fontSize: 13, color: errorPrimary),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            SizedBox(height: XPadding.extralarge),

            // Number pad or spinner
            _isLoading
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: XPadding.extralarge),
                    child: CircularProgressIndicator(
                      color: goBusPrimary,
                      strokeWidth: 2.5,
                    ),
                  )
                : _buildNumberPad(),

            SizedBox(height: XPadding.large),

            // Cancel
            if (!_isLoading)
              GestureDetector(
                onTap: () => Navigator.of(context).pop(null),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: XPadding.small),
                  child: Text(
                    'Cancel'.tr,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDots() {
    final hasError = _errorMessage != null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pinLength, (i) {
        final filled = i < _pin.length;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hasError
                ? errorPrimary
                : (filled ? goBusPrimary : Colors.transparent),
            border: Border.all(
              color: hasError
                  ? errorPrimary
                  : (filled ? goBusPrimary : Colors.grey.shade400),
              width: 2,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNumberPad() {
    return Column(
      children: [
        _buildRow(['1', '2', '3']),
        SizedBox(height: XPadding.medium),
        _buildRow(['4', '5', '6']),
        SizedBox(height: XPadding.medium),
        _buildRow(['7', '8', '9']),
        SizedBox(height: XPadding.medium),
        _buildRow(['', '0', 'delete']),
      ],
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((key) {
        if (key.isEmpty) return const SizedBox(width: 68, height: 68);
        if (key == 'delete') {
          return _buildKey(
            onTap: _onDelete,
            child: const Icon(
              Icons.backspace_outlined,
              color: Colors.black54,
              size: 22,
            ),
          );
        }
        return _buildKey(
          onTap: () => _onTap(key),
          child: Text(
            key,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKey({required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade100,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}
