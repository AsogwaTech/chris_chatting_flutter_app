import 'package:flutter/material.dart';


AppBar mainAppBar(BuildContext context){
  return AppBar(
    title: const Text('Asogwa Chat'),
    centerTitle: true,
    elevation: 0,
  );
}

InputDecoration textFieldInputDecoration(String hintText){
  return  InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: Colors.white54),
    focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white)
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  );
}


TextStyle textStyle(){
  return const TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
}