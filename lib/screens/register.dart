import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/api_response.dart';
import 'package:flutter_blog_app/models/user.dart';
import 'package:flutter_blog_app/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'home.dart';
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
      _saveAndRedirectToHome(response.data as User);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
        backgroundColor: Colors.green,
          content: Text(
              'Successfully registered',
            textAlign: TextAlign.center,
          ),
          ));
    }else{
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
          content: Text(
              '${response.error}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,

            ),
          )
          ),
      );
    }
  }

  void _saveAndRedirectToHome(User user) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (context)=>const Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              height: 150,
              decoration:const BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(80, 50),
                // bottomRight: Radius.circular()
                // border: Border(
                //     left: BorderSide(width: 3)
                ),
                // borderRadius:
              ),
            ),
           // const SizedBox(height: 10,),
            Container(
              decoration:const BoxDecoration(
                // color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.only(
                    topRight: Radius.elliptical(80, 50),
                    // bottomRight: Radius.elliptical(15, -10)
                  // border: Border(
                  //     left: BorderSide(width: 3)
                ),
                // borderRadius:
              ),
              child: Expanded(
                child: Form(
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
                            controller: passwordConfirmationController,
                            obscureText: true,
                            validator: (val) => val != passwordController ? 'Confirm password does not match' : null,
                            decoration: kInputDecoration('Confirm Password')
                        ),
                        const SizedBox(height:10),
                        loading? const Center(child: CircularProgressIndicator(),) :
                        kTextButton('Register',
                                (){  if(formkey.currentState!.validate()) {
                              setState((){
                                loading = true;
                                _registerUser();
                              });
                            }
                            }),

                        const SizedBox(height: 10),
                        kLoginRegisterHint('Already have an account?', 'Login', (){
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Login()), (route)=>false);
                        })
                      ]),
                ),
              ),
            ),
          ],
        ));
  }
}
