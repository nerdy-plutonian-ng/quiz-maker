import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_maker/data/constants/route_paths.dart';
import 'package:quiz_maker/ui/utilities/app_extensions.dart';
import 'package:quiz_maker/ui/utilities/messager.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final registerObject = <String, String>{
    'displayName': '',
    'email': '',
    'password': '',
    'confirmPassword': ''
  };
  var isSubmitting = false;

  register() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSubmitting = true;
      });
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: registerObject['email']!,
              password: registerObject['password']!)
          .then((userCredential) {
        final user = userCredential.user;
        if (user != null) {
          user
              .updateDisplayName(registerObject['displayName']?.toLowerCase())
              .then((value) {
            user.sendEmailVerification().then((_) {
              setState(() {
                isSubmitting = false;
              });
              Messager.showSnackBar(
                context: context,
                message:
                    'You have been signed up! Check your mail to verify your email.',
              );
              context.goNamed(RoutePaths.signIn);
            });
          }).catchError((error) {
            setState(() {
              isSubmitting = false;
            });
            Messager.showSnackBar(
                context: context,
                message: error.toString().split(']')[1],
                isError: true);
          });
        }
      }).catchError((error) {
        setState(() {
          isSubmitting = false;
        });
        Messager.showSnackBar(
            context: context,
            message: error.toString().split(']')[1],
            isError: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Register',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Row(
                  children: [
                    Text(
                      'Already have an account?',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    TextButton(
                        onPressed: () {
                          context.go(RoutePaths.signIn);
                        },
                        child: const Text('Sign In'))
                  ],
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Display Name',
                    suffixIcon: Icon(Icons.person),
                  ),
                  onChanged: (text) {
                    registerObject['displayName'] = text;
                  },
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    suffixIcon: Icon(Icons.alternate_email),
                  ),
                  onChanged: (text) {
                    registerObject['email'] = text.toLowerCase().trim();
                  },
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    suffixIcon: Icon(Icons.password),
                  ),
                  onChanged: (text) {
                    registerObject['password'] = text;
                  },
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Required';
                    }
                    if (text.length < 8) {
                      return 'Password must be 8 or more characters';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    suffixIcon: Icon(Icons.password),
                  ),
                  onChanged: (text) {
                    registerObject['confirmPassword'] = text;
                  },
                  validator: (text) {
                    if (text == null || text != registerObject['password']) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                if (isSubmitting) const LinearProgressIndicator(),
                16.vSpace(),
                FilledButton(
                    onPressed: isSubmitting ? null : register,
                    child: const Text('Register'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
