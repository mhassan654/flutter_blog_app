import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Form(
        key: formkey,
          child: ListView(
            padding: EdgeInsets.all(32),
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: txtEmail,
                validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey))
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                // keyboardType: TextInputType.visiblePassword,
                controller: txtPassword,
                obscureText: true,
                validator: (val) => val!.isEmpty ? 'Password must not be empty' : null,
                decoration: kInputDecoration('Password')
              )
            ],
          )),
    );
  }
}
