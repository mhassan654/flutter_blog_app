import 'package:flutter/material.dart';

const baseURL = "http://10.0.2.2:8000/api/";
const loginURL = baseURL + 'login';
const registerURL = baseURL + 'register';
const logoutURL = baseURL + 'logout';
const userURL = baseURL + 'user';
const postsURL = baseURL + 'posts';
const commentsURL = baseURL + 'comments';

// ---------- Errors -----------
const serverError = 'Server Error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again';

// ------input decoration
InputDecoration kInputDecoration(String label){
  return InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.all(10),
      border: const OutlineInputBorder(borderSide: BorderSide(
          width: 1, color: Colors.grey))
  );
}

// button
TextButton kTextButton(String label, Function onPressed){
  return TextButton(
    child: Text(label, style: const TextStyle(color: Colors.white),),
    style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
        padding: MaterialStateProperty.resolveWith((states) =>
        const EdgeInsets.symmetric(vertical: 10))
    ),
    onPressed: ()=> onPressed(),
  );
}


// loginRegisterHint
Row kLoginRegisterHint(String text, String label, Function onTap){
  return Row(
    children: [
      Text(text),
      GestureDetector(
        child: Text(
            label, style: const TextStyle(color: Colors.blue)),
        onTap: ()=>onTap(),
      )
    ],
  );

}

Expanded kLikeAndComment(int value, IconData icon, Color color, Function onTap)
{
  return Expanded(
    child: Material(
      child: InkWell(
        onTap: ()=>onTap(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width:4),
              Text('$value')
            ],
          ),
        ),

      ),
    )
  );
}