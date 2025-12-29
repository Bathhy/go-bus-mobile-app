import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onTapTelegram;

  const HomeAppBar({super.key, this.onTap, this.onTapTelegram});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/go_bus_logo.png',
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'GoBus',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
          Row(
            children: [
              XSocialButton(
                icon: Icons.telegram,
                color: Colors.blue,
                onTap: onTapTelegram,
              ),
              const SizedBox(width: 12),
              XSocialButton(
                icon: Icons.phone,
                color: Colors.green,
                onTap: onTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class XSocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const XSocialButton({
    super.key,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
