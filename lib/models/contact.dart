import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Contact extends Equatable {
  const Contact({@required this.id, @required this.name, @required this.photo});

  const Contact.test()
      : id = '0',
        name = 'Jose',
        photo = '';

  final String id;
  final String name;
  final String photo;

  static const empty = Contact(id: null, name: null, photo: null);

  @override
  List<Object> get props => [id, name, photo];
}
