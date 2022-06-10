import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/api_response.dart';
import 'package:flutter_blog_app/services/user_service.dart';

import '../constants.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController = TextEditingController();
  bool loading = false;

  void _registerUser() async{
    ApiResponse response = await register(nameController.text, emailController.text,
        passwordController.text);
    if(response.error ==null){

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          centerTitle: true,
        ),
        body: Form(
          key: formkey,
          child: ListView(
              padding: const EdgeInsets.all(32),
              children: [
                TextFormField(
                    keyboardType: TextInputType.text,
                    controller: nameController,
                    validator: (val) => val!.isEmpty ? 'Name field is required' : null,
                    decoration: kInputDecoration('Name')
                ),
                const SizedBox(height: 10),

                TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
                    decoration: kInputDecoration('Email')
                ),
                const SizedBox(height: 10),
                TextFormField(
                  // keyboardType: TextInputType.visiblePassword,
                    controller: passwordController,
                    obscureText: true,
                    validator: (val) => val!.isEmpty ? 'Password must not be empty' : null,
                    decoration: kInputDecoration('Password')
                ),
                const SizedBox(height: 10),
                TextFormField(
                  // keyboardType: TextInputType.visiblePassword,
                    controller: passwordController,
                    obscureText: true,
                    validator: (val) => val!.isEmpty ? 'Passwords do not match' : null,
                    decoration: kInputDecoration('Confirm Password')
                ),
                const SizedBox(height:10),
                loading? const Center(child: CircularProgressIndicator(),) :
                kTextButton('Register',
                        (){  if(formkey.currentState!.validate()) {
                      setState((){
                        loading = true;
                        // _loginUser();
                      });
                    }
                    }),

                const SizedBox(height: 10),
                kLoginRegisterHint('Already have an account?', 'Login', (){
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Login()), (route)=>false);
                })
              ]),
        ));
  }
}
