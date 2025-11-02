import 'package:flutter/material.dart';

class XLocationTitle extends StatelessWidget {
  final String localtion;
  const XLocationTitle({super.key, this.localtion = "NA"});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.location_on, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              localtion,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
