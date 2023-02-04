import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/constants/route_paths.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(FirebaseAuth.instance.currentUser?.email ?? 'Crush'),
            Text(
                'Is email verified? : ${FirebaseAuth.instance.currentUser?.emailVerified}'),
            ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    context.pushReplacementNamed(RoutePaths.root);
                  });
                },
                child: const Text('Logout'))
          ],
        ),
      ),
    );
  }
}
