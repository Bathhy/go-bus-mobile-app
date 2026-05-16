import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/x_widget/TextComponent.dart';

class WalletPinScaffold extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool isLoading;
  final String? errorMessage;
  final Function(String pin) onPinComplete;
  final VoidCallback? onErrorCleared;

  const WalletPinScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPinComplete,
    this.isLoading = false,
    this.errorMessage,
    this.onErrorCleared,
  });

  @override
  State<WalletPinScaffold> createState() => _WalletPinScaffoldState();
}

class _WalletPinScaffoldState extends State<WalletPinScaffold>
    with SingleTickerProviderStateMixin {
  String _pin = '';
  static const int _pinLength = 4;

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(WalletPinScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorMessage != null &&
        widget.errorMessage != oldWidget.errorMessage) {
      _shakeController.forward().then((_) => _shakeController.reset());
      setState(() => _pin = '');
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onNumberTap(String number) {
    if (widget.isLoading || _pin.length >= _pinLength) return;
    if (widget.errorMessage != null) widget.onErrorCleared?.call();
    setState(() => _pin += number);
    if (_pin.length == _pinLength) widget.onPinComplete(_pin);
  }

  void _onDelete() {
    if (widget.isLoading || _pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.isLoading,
      child: Scaffold(
        backgroundColor: primaryBgColor,
        appBar: AppBar(
          backgroundColor: primaryBgColor,
          elevation: 0,
          leading: widget.isLoading
              ? const SizedBox.shrink()
              : IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Navigator.of(context).pop(),
                ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: goBusPrimary.withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.lock_outline,
                        size: 40,
                        color: goBusPrimary,
                      ),
                    ),
                    SizedBox(height: XPadding.extralarge),
                    XTextLarge(
                      label: widget.title,
                      colortext: black,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: XPadding.medium),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: XPadding.extralarge,
                      ),
                      child: Text(
                        widget.subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: XPadding.extralarge * 2),
                    AnimatedBuilder(
                      animation: _shakeAnimation,
                      builder: (context, child) {
                        final offset =
                            math.sin(_shakeAnimation.value * math.pi * 5) * 10;
                        return Transform.translate(
                          offset: Offset(offset, 0),
                          child: child,
                        );
                      },
                      child: _buildPinDots(),
                    ),
                    if (widget.errorMessage != null) ...[
                      SizedBox(height: XPadding.large),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: XPadding.extralarge,
                        ),
                        child: Text(
                          widget.errorMessage!,
                          style: TextStyle(
                            fontSize: 14,
                            color: errorPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (widget.isLoading)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: XPadding.extralarge * 4,
                  ),
                  child: CircularProgressIndicator(color: goBusPrimary),
                )
              else ...[
                _buildNumberPad(),
                SizedBox(height: XPadding.extralarge),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinDots() {
    final hasError = widget.errorMessage != null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pinLength, (index) {
        final filled = index < _pin.length;
        final color = hasError
            ? errorPrimary
            : (filled ? goBusPrimary : Colors.grey[300]!);
        return Container(
          margin: EdgeInsets.symmetric(horizontal: XPadding.medium),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(
              color: hasError
                  ? errorPrimary
                  : (filled ? goBusPrimary : Colors.grey[400]!),
              width: 2,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNumberPad() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: XPadding.extralarge),
      child: Column(
        children: [
          _buildRow(['1', '2', '3']),
          SizedBox(height: XPadding.large),
          _buildRow(['4', '5', '6']),
          SizedBox(height: XPadding.large),
          _buildRow(['7', '8', '9']),
          SizedBox(height: XPadding.large),
          _buildRow(['', '0', 'delete']),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        if (key.isEmpty) return const SizedBox(width: 70, height: 70);
        if (key == 'delete') {
          return _buildKey(
            child: const Icon(
              Icons.backspace_outlined,
              color: Colors.black87,
              size: 28,
            ),
            onTap: _onDelete,
          );
        }
        return _buildKey(
          child: XTextLarge(
            label: key,
            colortext: black,
            fontWeight: FontWeight.w600,
          ),
          onTap: () => _onNumberTap(key),
        );
      }).toList(),
    );
  }

  Widget _buildKey({required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
