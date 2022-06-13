import 'dart:convert';

import 'package:flutter_blog_app/constants.dart';
import 'package:flutter_blog_app/models/api_response.dart';
import 'package:flutter_blog_app/models/post.dart';
import 'package:flutter_blog_app/services/user_service.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getPosts() async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.get(Uri.parse(postsURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['posts'].map(
              (post)=> Post.fromJson(post)).toList();
      // we get list of posts, so we need to map each item to post model
      apiResponse.data as List<dynamic>;
    }
    if(response.statusCode == 401){
      apiResponse.error = unauthorized;
    }
    else{
      print(apiResponse.error);
      // apiResponse.error = somethingWentWrong;
    }
  }catch(e){
    apiResponse.error = e as String?;
  }

  return apiResponse;
}

Future<ApiResponse> createPost (
    String body, String image
    ) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.post(Uri.parse(postsURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
        body: image !=null ? {
          'image':image,
          'body':body
        } : {
           'body': body
        }
    );

    // print(response.body);

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body);
    }
    if(response.statusCode == 422){
      final errors = jsonDecode(response.body)['errors'];
      apiResponse.error = errors[errors.keys.elementAt(0)][0];
    }
    if(response.statusCode == 403){
      // print(apiResponse.error);
      apiResponse.error = jsonDecode(response.body)['message'];
    }
    else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }
  }catch(e){
    // print(apiResponse.error);
    apiResponse.error = serverError;
  }

  return apiResponse;
}