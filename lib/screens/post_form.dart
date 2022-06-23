import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blog_app/constants.dart';
import 'package:flutter_blog_app/models/api_response.dart';
import 'package:flutter_blog_app/models/post.dart';
import 'package:flutter_blog_app/services/post_service.dart';
import 'package:flutter_blog_app/services/user_service.dart';
import 'package:image_picker/image_picker.dart';

import 'home.dart';
import 'login.dart';

class PostForm extends StatefulWidget {
  final Post? post;
  final String? title;
  // const PostForm({Key? key}) : super(key: key);
PostForm({
    this.post,
  this.title
});
  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _txtControllerBody = TextEditingController();
  bool _loading = false;

  File? _imageFile;
  final _picker = ImagePicker();

  Future getImage() async{
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _createNewPost() async{
    String? image = _imageFile == null ? null : getStringImage(_imageFile);
    ApiResponse response = await createPost(_txtControllerBody.text, image!);
    
    if(response.error ==null){
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Successfully added new post',
              textAlign: TextAlign.center,
            ),
          ));
    }else if(response.error == unauthorized){
      logout().then((value)=>{
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (context)=>const Login()), (route) => false)
      });

    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              '${response.error}',
              textAlign: TextAlign.center,
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}'),
        centerTitle: true,
      ),
      body: ListView(
      // body: _loading ? const Center(child: CircularProgressIndicator(),) : ListView(
        children: [
          Container(
            padding: EdgeInsets.all(6.0),
            width: MediaQuery.of(context).size.width,
              height: 200,
            decoration: BoxDecoration(
              
              image: _imageFile == null ? null : DecorationImage(
                image: FileImage (_imageFile ?? File('')),
                fit: BoxFit.cover
              )
            ),
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.image,
                size: 50,
                color: Colors.black38,),
                onPressed: () { getImage(); },
              ),
            ),
          ),
          Form(
            key: _formkey,
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _txtControllerBody,
                    keyboardType: TextInputType.multiline,
                    maxLength: 9,
                    validator: (val)=>val!.isEmpty ? 'Post body is required' : null,
                    decoration: const InputDecoration(
                      hintText: "Post body...",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width:1, color: Colors.grey)
                      )
                    ),

                  )
              ),

          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: kTextButton(
                'Post', (){
                  if(_formkey.currentState!.validate())
                    {
                      setState((){
                        _loading = !_loading;
                        _createNewPost();
                      });
                    }
            }),
          )
        ],
      ),
    );
  }
}
