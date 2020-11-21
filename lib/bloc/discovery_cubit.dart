import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    discoveries = userService.getDiscoveries(userId).listen(
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
    discoveries.cancel();

    roomStream = discoveryService.getRoom(roomId);

    rooms =
        discoveryService.getRoom(roomId).listen((QuerySnapshot querySnapshot) {
      bool flag = true;

      querySnapshot.docs.forEach((element) {
        print("Stream ${element.id} - ${element.data()['activated']}");
      });

      querySnapshot.docs.forEach((element) {
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
    });
  }

  void _getDiscoveries(QuerySnapshot querySnapshot) {
    if (querySnapshot.docChanges.length > 0) {
      List<DocumentChange> documents = [];

      querySnapshot.docChanges.forEach((element) {
        if (element.type == DocumentChangeType.added) {
          documents.add(element);
        }
      });

      if (documents.length > 0) {
        documents.sort((DocumentChange a, DocumentChange b) {
          DateTime aDate = a.doc.data()['time'].toDate();
          DateTime bDate = b.doc.data()['time'].toDate();
          return aDate.compareTo(bDate);
        });

        emit(DiscoveryFound(room: documents[0].doc.id));
        _validateRoom(documents[0].doc.id);
      }
    }
  }

  final String userId;
  final DiscoveryService discoveryService;
  final UserService userService;

  Stream<QuerySnapshot> roomStream;
  StreamSubscription<QuerySnapshot> discoveries;
  StreamSubscription<QuerySnapshot> rooms;
}
