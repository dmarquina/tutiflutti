import 'package:firebase_database/firebase_database.dart';

class FirebaseReference {

  static DatabaseReference getReference(String child){
    return FirebaseDatabase.instance.reference().child(child);
  }
}