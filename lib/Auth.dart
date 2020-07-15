import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'sign_in.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );

@JsonSerializable()
class Auth {
  final String authId;
  final String email;

  Auth(this.authId, this.email);

  Auth.fromJson(Map<String, dynamic> json)
      : authId = json['authId'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
        'authId': authId,
        'email': email,
      };
}
