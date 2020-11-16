import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_talk/services/discovery_service.dart';

class StreamService {
  DiscoveryService discoveryService;
  StreamSubscription streamSubscription;

  StreamService({this.discoveryService});

  void init(String id) {
    streamSubscription =
        discoveryService.getRoom(id).listen((QuerySnapshot querySnapshot) {
       querySnapshot.docChanges.forEach((element) {
        print("Future ${element.doc.id} - ${element.doc.data()['activated']} - ${element.type} -${element.doc.metadata.isFromCache}");
      });
    });
  }

  Future<void> dispose() async {
    await streamSubscription.cancel();
    streamSubscription = null;
  }
}
