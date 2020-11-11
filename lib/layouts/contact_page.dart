import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:just_talk/authentication/bloc/authentication_cubit.dart';
import 'package:just_talk/bloc/contact_cubit.dart';
import 'package:just_talk/bloc/contact_state.dart';
import 'package:just_talk/bloc/navbar_cubit.dart';
import 'package:just_talk/models/contact.dart';
import 'package:just_talk/models/message.dart';
import 'package:just_talk/services/user_service.dart';

Widget contactList(List<Contact> contacts) {
  return ListView.separated(
    shrinkWrap: true,
    separatorBuilder: (BuildContext context, int index) => Divider(
      thickness: 1,
      color: Colors.black,
    ),
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ListTile(
          onTap: () {},
          title: Row(
            children: [
              Expanded(
                child: Text(
                  contacts[index].name,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Text(
                DateFormat('HH:mm dd/MM')
                    .format(contacts[index].lastMessageTime.toLocal()),
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              contacts[index].lastMessage,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          leading: Icon(Icons.account_circle, size: 50),
        ),
      );
    },
    itemCount: contacts.length,
  );
}

class Search extends SearchDelegate {
  Search(this.contactCubit);
  ContactCubit contactCubit;

  bool validate(String element, String query) {
    if (element.length < query.length) {
      return false;
    }
    for (int i = 0; i < query.length; ++i) {
      if (query[i] != element[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  String get searchFieldLabel => 'Buscar contacto';

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      iconSize: 30,
      icon: Icon(Icons.keyboard_arrow_left),
      color: Colors.black,
      onPressed: () async {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {}

  @override
  Widget buildSuggestions(BuildContext context) {
    ContactsState contactState = contactCubit.state;
    if (contactState.runtimeType == ContactsResult) {
      List<Contact> contacts = (contactState as ContactsResult).contacts;
      return contactList(
          contacts.where((element) => validate(element.name, query)));
    }
    return Container();
  }
}

class ContactPage extends StatefulWidget {
  ContactPage(this._index, this._navbarCubit);
  final int _index;
  final NavbarCubit _navbarCubit;

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Message> messages = [];
  UserService userService;
  String userId;

  @override
  void initState() {
    super.initState();
    userService = RepositoryProvider.of<UserService>(context);
    userId = BlocProvider.of<AuthenticationCubit>(context).state.user.id;
    BlocProvider.of<ContactCubit>(context).init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            child: Container(
              color: Colors.grey,
              height: 2,
            ),
            preferredSize: Size.fromHeight(0)),
        title: Text(
          'Amigos',
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: Search(BlocProvider.of<ContactCubit>(context)));
              }),
          IconButton(
            icon: const Icon(Icons.build),
            onPressed: () {
              Navigator.of(context).pushNamed('/filters');
            },
          ),
        ],
      ),
      body: BlocBuilder<ContactCubit, ContactsState>(builder: (context, state) {
        switch (state.runtimeType) {
          case ContactsEmpty:
            return Container();
          case ContactsResult:
            return contactList((state as ContactsResult).contacts);
          default:
            return Container();
        }
      }),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sentiment_satisfied),
            title: Text('Just Talk'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text('Amigos'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Mi perfil'),
          ),
        ],
        currentIndex: widget._index,
        onTap: (index) {
          switch (index) {
            case 0:
              widget._navbarCubit.toHome();
              break;
            case 1:
              widget._navbarCubit.toContacts();
              break;
            case 2:
              widget._navbarCubit.toProfile();
              break;
          }
        },
      ),
    );
  }
}
