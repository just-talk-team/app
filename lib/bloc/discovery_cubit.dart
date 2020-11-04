import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/bloc/discovery_state.dart';
import 'package:just_talk/services/discovery_service.dart';
import 'package:just_talk/services/user_service.dart';

class DiscoveryCubit extends Cubit<DiscoveryState> {
  DiscoveryCubit({this.discoveryService, this.userService, this.userId})
      : super(DiscoveryNotFound()) {
    discoveries = userService.getDiscoveries(userId).listen(
        (QuerySnapshot querySnapshot) => _getDiscoveries(querySnapshot));
  }

  void _done() {
    rooms.cancel();
  }

  void _validateRoom(String roomId) {
    discoveries.cancel();
    rooms = discoveryService
        .getRoom(roomId, userId)
        .listen((QuerySnapshot querySnapshot) async {
      if (querySnapshot.docs.length == 0) {
        emit(DiscoveryReady(room: roomId));
        _done();
      }
    });
  }

  void _getDiscoveries(QuerySnapshot querySnapshot) {
    if (querySnapshot.docChanges.length > 0) {
      querySnapshot.docChanges.sort((DocumentChange a, DocumentChange b) {
        DateTime aDate = a.doc.data()['time'].toDate();
        DateTime bDate = b.doc.data()['time'].toDate();
        return aDate.compareTo(bDate);
      });

      emit(DiscoveryFound());
      _validateRoom(querySnapshot.docChanges[0].doc.id);
    }
  }

  final String userId;
  final DiscoveryService discoveryService;
  final UserService userService;
  StreamSubscription<QuerySnapshot> discoveries;
  StreamSubscription<QuerySnapshot> rooms;
}
