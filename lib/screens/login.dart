import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/api_response.dart';
import 'package:flutter_blog_app/models/user.dart';
import 'package:flutter_blog_app/screens/register.dart';
import 'package:flutter_blog_app/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  void _loginUser() async{
    ApiResponse response = await login(txtEmail.text, txtPassword.text);
    if(response.error ==null){
      _saveAndRedirectToHome(response.data as User);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }
  void _saveAndRedirectToHome(User user) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Home()), (route)=>false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Form(
        key: formkey,
          child: ListView(
            padding: const EdgeInsets.all(32),
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: txtEmail,
                validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
                decoration: kInputDecoration('Email')
              ),
              const SizedBox(height: 10),
              TextFormField(
                // keyboardType: TextInputType.visiblePassword,
                controller: txtPassword,
                obscureText: true,
                validator: (val) => val!.isEmpty ? 'Password must not be empty' : null,
                decoration: kInputDecoration('Password')
              ),

              const SizedBox(height: 10),

              TextButton(
                child: const Text('Login', style: TextStyle(color: Colors.white),),
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                  padding: MaterialStateProperty.resolveWith((states) => const EdgeInsets.symmetric(vertical: 10))
                ),
                onPressed: (){
                  if(formkey.currentState!.validate()){
                    _loginUser();
                  }
                },
              ),
              const SizedBox(height: 10),

              kLoginRegisterHint('Dont have an account', 'Register', (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Register()), (route)=>false);
              })
            ],
          )),
    );
  }
}
