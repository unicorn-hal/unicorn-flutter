import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addData(String collection, Map<String, dynamic> data) async {
    await _firestore.collection(collection).add(data);
  }

  Future<void> updateData(
      String collection, String id, Map<String, dynamic> data) async {
    await _firestore.collection(collection).doc(id).update(data);
  }

  Future<void> deleteData(String collection, String id) async {
    await _firestore.collection(collection).doc(id).delete();
  }

  Future<DocumentSnapshot> getData(String collection, String id) async {
    return await _firestore.collection(collection).doc(id).get();
  }

  Stream<QuerySnapshot> streamData(String collection) {
    return _firestore.collection(collection).snapshots();
  }
}
