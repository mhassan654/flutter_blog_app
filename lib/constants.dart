import 'package:flutter/material.dart';

const baseURL = "http://sites.flutter_blog_api.test/api/";
const loginURL = baseURL + '/login';
const registerURL = baseURL + '/register';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/user';
const postsURL = baseURL + '/posts';
const commentsURL = baseURL + '/comments';

// ---------- Errors -----------
const serverError = 'Server Error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again';

// ------input decoration
InputDecoration kInputDecoration(String label){
  return InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.all(10),
      border: OutlineInputBorder(borderSide: const BorderSide(width: 1, color: Colors.grey))
  );
}