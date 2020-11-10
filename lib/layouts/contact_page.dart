import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:just_talk/authentication/bloc/authentication_cubit.dart';
import 'package:just_talk/bloc/navbar_cubit.dart';
import 'package:just_talk/models/message.dart';
import 'package:just_talk/services/user_service.dart';

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
          IconButton(icon: const Icon(Icons.search), onPressed: () => {}),
          IconButton(
            icon: const Icon(Icons.build),
            onPressed: () {
              Navigator.of(context).pushNamed('/filters');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Message>>(
          future: userService.getLastMessages(userId),
          builder: (context, messageData) {
            if (messageData.hasData) {
              messages = messageData.data;
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
                              messages[index].contact.name,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          Text(
                            DateFormat('HH:mm dd/MM')
                                .format(messages[index].dateTime.toLocal()),
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          messages[index].message,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      leading: Icon(Icons.account_circle, size: 50),
                    ),
                  );
                },
                itemCount: messages.length,
              );
            }
            return Container();
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
