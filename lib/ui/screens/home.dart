import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
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
            Text(fire_auth.FirebaseAuth.instance.currentUser?.email ?? 'Crush'),
            ElevatedButton(
                onPressed: () {
                  fire_auth.FirebaseAuth.instance
                      .signOut()
                      .then((value) => context.go(RoutePaths.root));
                },
                child: const Text('Logout'))
          ],
        ),
      ),
    );
  }
}
