import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/bloc/login/login_cubit.dart';
import 'package:just_talk/services/authentication_service.dart';
import 'package:formz/formz.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 120.0, horizontal: 40.0),
              alignment: Alignment.center,
              child: BlocProvider(
                create: (context) {
                  return LoginCubit(
                    authenticationService:
                        RepositoryProvider.of<AuthenticationService>(context),
                  );
                },
                child: LoginForm(),
              )),
        ));
  }
}

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text("Authentication failure")),
            );
        }
      },
      child: Column(
        children: [
          Text(
            'Login',
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(
            height: 40.0,
          ),
          UsernameInput(),
          SizedBox(
            height: 30.0,
          ),
          PasswordInput(),
          SizedBox(
            height: 80.0,
          ),
          LoginButtom()
        ],
      ),
    );
  }
}

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('login_password'),
          onChanged: (password) =>
              context.bloc<LoginCubit>().passwordChanged(password),
          style: Theme.of(context).textTheme.bodyText1,
          obscureText: true,
          decoration: InputDecoration(
            hintStyle: Theme.of(context).textTheme.bodyText1,
            hintText: 'Enter your password',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]),
            ),
          ),
        );
      },
    );
  }
}

class UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          key: const Key('login_username'),
          onChanged: (username) =>
              context.bloc<LoginCubit>().usernameChanged(username),
          style: Theme.of(context).textTheme.bodyText1,
          decoration: InputDecoration(
            hintStyle: Theme.of(context).textTheme.bodyText1,
            hintText: 'Enter your email',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]),
            ),
          ),
        );
      },
    );
  }
}

class LoginButtom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : RaisedButton(
                key: const Key('loginButton'),
                child: const Text('Login'),
                color: Theme.of(context).buttonColor,
                onPressed: state.status.isValidated
                    ? () {
                        context.bloc<LoginCubit>().submit();
                      }
                    : null,
              );
      },
    );
  }
}
