import 'dart:convert';
import 'package:flutter_blog_app/constants.dart';
import 'package:flutter_blog_app/models/api_response.dart';
import 'package:flutter_blog_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// login
Future<ApiResponse> login (String email, String password) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    final response = await http.post(
        Uri.parse(loginURL),
    headers: {'Accept': 'application/json'},
    body:{'email':email, 'password': password}
    );
    // print(response.body);

    if(response.statusCode == 200){
      apiResponse.data = User.fromJson(jsonDecode(response.body));
      // print(apiResponse.data);
    }
    if(response.statusCode == 422){
      final errors = jsonDecode(response.body)['errors'];
      apiResponse.error = errors[errors.keys.elementAt(0)][0];
    }
    if(response.statusCode == 403){
      apiResponse.error = jsonDecode(response.body)['message'];
    }
    else{
      print(apiResponse.error);
      // apiResponse.error = somethingWentWrong;
    }
  }catch(e){
    apiResponse.error = serverError;
    // print(e);
  }

  return apiResponse;
}

// register
Future<ApiResponse> register (String name, String email, String password) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    final response = await http.post(
        Uri.parse(registerURL),
        headers: {'Accept': 'application/json'},
        body:{
          'name':name,
          'email': email,
          'password': password,
          'password_confirmation': password
        }
    );

    if(response.statusCode == 200){
      apiResponse.data = User.fromJson(jsonDecode(response.body));
    }
    if(response.statusCode == 422){
      final errors = jsonDecode(response.body)['errors'];
      apiResponse.error = errors[errors.keys.elementAt(0)][0];
    }
    if(response.statusCode == 403){
      apiResponse.error = jsonDecode(response.body)['message'];
    }
    else{
      apiResponse.error = somethingWentWrong;
    }
  }catch(e){ apiResponse.error = serverError;}

  return apiResponse;
}

// user
Future<ApiResponse> getUserDetails () async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.post(
        Uri.parse(userURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    if(response.statusCode == 200){
      apiResponse.data = User.fromJson(jsonDecode(response.body));
    }
    if(response.statusCode == 401){
      apiResponse.error = unauthorized;
    }
    else{
      apiResponse.error = somethingWentWrong;
    }
  }catch(e){ apiResponse.error = serverError;}

  return apiResponse;
}

// get token
Future<String> getToken() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// get user id
Future<int> getUserId() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

// logout
Future<bool> logout() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}