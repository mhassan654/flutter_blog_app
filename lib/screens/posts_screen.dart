import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/api_response.dart';
import 'package:flutter_blog_app/models/post.dart';
import 'package:flutter_blog_app/services/post_service.dart';
import 'package:flutter_blog_app/services/user_service.dart';

import '../constants.dart';
import 'login.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<dynamic> _postArray = [];
  int userId = 0;
  bool _loading = true;

  // get all posts
  Future<void> retrievePosts() async{
    userId = await getUserId();
    ApiResponse response = await getPosts();

    if(response.error == null){
      setState((){
        _postArray = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });

    }else if(response.error == unauthorized){
      logout().then((value)=>{
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (context)=> const Login()), (route) => false)
      });

    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              '${response.error}',
              textAlign: TextAlign.center,
            ),
          ));
    }

  }

  @override
  void initState() {
    retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading ? const Center(child: CircularProgressIndicator()) :
    RefreshIndicator(
      onRefresh: (){
       return retrievePosts();
      },
      child: ListView.builder(
        itemCount: _postArray.length,
          itemBuilder: (BuildContext context, int index){
          Post post = _postArray[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Row(

                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              image: post.user!.image != null ?
                                  DecorationImage(
                                      image: NetworkImage('${post.user!.image}'),
                                  )
                                  : null,
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.amber
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Text('${post.user!.name}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                              fontSize: 17
                          ),)
                        ],

                      ),
                    ),
                    post.user!.id == userId ?
                    PopupMenuButton(
                      child: const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.more_vert, color: Colors.black,),
                      ),
                        itemBuilder: (context)=>[
                          const PopupMenuItem(
                            child: Text('Edit'),
                            value: 'edit',
                          ),
                          const PopupMenuItem(
                            child: Text('Delete'),
                            value: 'delete',
                          ),
                        ],
                      onSelected: (val){
                        if(val == 'edit'){
                          //edit
                      }else{
                          //delete
                        }
                      },
                    ) : const SizedBox(),
                  ],
                ),
                const SizedBox(height: 12),
                Text('${post.body}'),
                post.image !=null ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: 180,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('${post.image}'),
                      fit: BoxFit.cover
                    )
                  ),
                ): SizedBox(height: post.image != null ? 0 : 10,),

                Row(
                  children: <Widget>[
                    kLikeAndComment(
                        post.likesCount ?? 0,
                        post.selfLiked == true ? Icons.favorite : Icons.favorite_outline,
                        post.selfLiked == true ? Colors.red : Colors.black54,
                        (){

                        }),

                    Container(
                      height: 25,
                        width: 0.5,
                      color: Colors.black38,
                    ),
                    kLikeAndComment(
                        post.commentsCount ?? 0,
                        Icons.sms_outlined,
                        Colors.black54,
                            (){

                            },
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 0.5,
                  color: Colors.black26,
                )
              ],
            ),
          );
        }),
    );
  }
}
