import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/bloc/discovery_state.dart';
import 'package:just_talk/services/discovery_service.dart';
import 'package:just_talk/services/user_service.dart';

class DiscoveryCubit extends Cubit<DiscoveryState> {
  DiscoveryCubit({this.discoveryService, this.userService, this.userId})
      : super(DiscoveryNotFound());

  Future<void> reset() async {
    rooms.cancel();
    await init();
  }

  Future<void> init() async {
    await userService.deleteDiscoveries(userId);
    discoveries = userService.getDiscoveries(userId, sorted: true).listen(
        (QuerySnapshot querySnapshot) => _getDiscoveries(querySnapshot));
  }

  @override
  Future<void> close() {
    if (rooms != null) {
      rooms.cancel();
    }
    if (discoveries != null) {
      discoveries.cancel();
    }
    return super.close();
  }

  void _validateRoom(String roomId) {
    bool connected = false;
    discoveryService.connectUser(roomId, userId);
    Timer timer = Timer(Duration(seconds: 5), () => reset());
    rooms =
        discoveryService.getRoom(roomId).listen((QuerySnapshot querySnapshot) {
      if (!connected) {
        querySnapshot.docs.forEach((element) {
          if (!element.data()['connected']) {
            return;
          }
          emit(DiscoveryFound(room: roomId));
          timer.cancel();
          connected = true;
        });
      } else {
        bool flag = true;
        querySnapshot.docs.forEach((element) {
          FLog.info(
            text:
                "Stream ${element.id} ${element.data()['activated']} - RoomId: $roomId",
            methodName: "validateRoom",
            className: "DiscoveryCubit",
          );

          if (!element.data()['activated']) {
            flag = false;
            return;
          }
        });

        if (flag) {
          emit(DiscoveryReady(room: roomId));
          rooms.cancel();
        }
        return;
      }
    });
  }

  void _getDiscoveries(QuerySnapshot querySnapshot) {
    if (querySnapshot.docChanges.length > 0) {
      List<DocumentChange> documents = querySnapshot.docChanges
          .where((element) => element.type == DocumentChangeType.added)
          .toList();
          
      if (documents.length > 0) {
        discoveries.cancel();
        _validateRoom(documents[0].doc.id);
      }
    }
  }

  void test() {
    emit(DiscoveryFound(room: ''));
  }

  final String userId;
  final DiscoveryService discoveryService;
  final UserService userService;

  StreamSubscription<QuerySnapshot> discoveries;
  StreamSubscription<QuerySnapshot> rooms;
}
