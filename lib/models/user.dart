import 'package:firebase_database/firebase_database.dart';

class CurrentUser{
  String fullName;
  String email;
  String phone;
  String id;

  CurrentUser({
    this.fullName,
    this.email,
    this.phone,
    this.id
});
  CurrentUser.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    phone = snapshot.value["phone"];
    email = snapshot.value["email"];
    fullName = snapshot.value["fullName"];
  }
}