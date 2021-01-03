import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/authentication/bloc/authentication_cubit.dart';
import 'package:just_talk/bloc/contact_cubit.dart';
import 'package:just_talk/bloc/navbar_cubit.dart';
import 'package:just_talk/layouts/contact_page.dart';
import 'package:just_talk/layouts/home_page.dart';
import 'package:just_talk/layouts/profile_page.dart';
import 'package:just_talk/services/remote_service.dart';
import 'package:just_talk/services/user_service.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  NavbarCubit _navbarCubit;
  final PermissionGroup _permissionGroup = PermissionGroup.storage;

  Future<void> requestPermission(PermissionGroup permission) async {
    final List<PermissionGroup> permissions = <PermissionGroup>[permission];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);
  }

  @override
  void initState() {
    super.initState();
    requestPermission(_permissionGroup);

    _navbarCubit = NavbarCubit();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => SystemNavigator.pop(),
      child: BlocBuilder<NavbarCubit, NavBarState>(
        cubit: _navbarCubit,
        builder: (context, state) {
          switch (state.runtimeType) {
            case HomeState:
              return MultiRepositoryProvider(
                providers: [
                  RepositoryProvider.value(
                    value: RepositoryProvider.of<RemoteService>(context),
                  ),
                  RepositoryProvider.value(
                    value: RepositoryProvider.of<UserService>(context),
                  ),
                ],
                child: HomePage(0, _navbarCubit),
              );
            case ContactState:
              return BlocProvider(
                create: (context) => ContactCubit(
                    userId: BlocProvider.of<AuthenticationCubit>(context)
                        .state
                        .user
                        .id,
                    userService: RepositoryProvider.of<UserService>(context)),
                child: ContactPage(1, _navbarCubit),
              );
            case ProfileState:
              return ProfilePage(
                index: 2,
                navbarCubit: _navbarCubit,
                userService: RepositoryProvider.of<UserService>(context),
              );
            default:
              return HomePage(0, _navbarCubit);
          }
        },
      ),
    );
  }
}
