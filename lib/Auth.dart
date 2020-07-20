import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Auth {
  final String authId;
  final String email;

  Auth(this.authId, this.email);

  Auth.fromJson(Map<String, dynamic> json)
      : authId = json['authId'],
        email = json['email'];

  Map<String, String> toJson() => {
        'authId': authId,
        'email': email,
      };
}
