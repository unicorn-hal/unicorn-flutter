import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseFirestoreService {
  late FirebaseFirestore _instance;

  FirebaseFirestoreService({String databaseId = '(default)'}) {
    _instance = FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      databaseId: databaseId,
    );
  }

  Future<void> addData(String collection, Map<String, dynamic> data) async {
    await _instance.collection(collection).add(data);
  }

  Future<void> updateData(
      String collection, String id, Map<String, dynamic> data) async {
    await _instance.collection(collection).doc(id).update(data);
  }

  Future<void> deleteData(String collection, String id) async {
    await _instance.collection(collection).doc(id).delete();
  }

  Future<DocumentSnapshot> getData(String collection, String id) async {
    return await _instance.collection(collection).doc(id).get();
  }

  Future<List<DocumentSnapshot>> getCollectionData(String collection) async {
    final snapshot = await _instance.collection(collection).get();
    return snapshot.docs;
  }

  Stream<QuerySnapshot> streamData(String collection) {
    return _instance.collection(collection).snapshots(
        includeMetadataChanges: true, source: ListenSource.defaultSource);
  }

  void dispose() async {
    _instance.terminate();
    await _instance.clearPersistence();
    await _instance.disableNetwork();
    await _instance.enableNetwork();
  }
}
