import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseReference {

  static DatabaseReference getReference(String child){
    return FirebaseDatabase.instance.reference().child(child);
  }
}