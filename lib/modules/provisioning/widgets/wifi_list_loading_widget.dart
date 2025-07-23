import 'package:flutter/material.dart';

class WifiListLoadingWidget extends StatelessWidget {
  const WifiListLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Scanning wifi networks',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            child: CircularProgressIndicator(),
            width: 24,
            height: 24,
          ),
        ],
      ),
    );
  }
}
