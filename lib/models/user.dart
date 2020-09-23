import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';


class User extends Equatable {

  const User({
    @required this.id,
    @required this.email,
    @required this.name,
    @required this.photo
    }): assert(email!=null),
        assert(id != null);

  final String id;
  final String email;
  final String name;
  final String photo;

  static const empty = User(email: '', id:'', name:null, photo:null);

  @override
  List<Object> get props => [id, email, name, photo];
}

