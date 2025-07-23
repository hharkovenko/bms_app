import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.push('/provisioning/');
          },
          child: Text("Start wifi provisioning"),
        ),
      ),
    );
  }
}
