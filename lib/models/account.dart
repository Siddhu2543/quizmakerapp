import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizmaker/services/database.dart';

class Account {
  String id = "",
      name = "",
      email = "",
      dob = "",
      role = "",
      userId = "",
      branch = "";
  String semester, rollNo;

  Account(
      {this.id = "",
      this.name = "",
      this.email = "",
      this.dob = "",
      this.role = "",
      this.userId = "",
      this.branch = "",
      this.semester = "",
      this.rollNo = ""});

  List<String> toList() {
    return <String>[
      name,
      email,
      dob,
      role,
      userId,
      branch,
      semester,
      rollNo,
      id
    ];
  }

  static Future<Account> getAccountFromEmail(String email) async {
    DatabaseService databaseService = DatabaseService(uid: "");
    var accountDetails = await databaseService.getUserDetails(email);
    var docs = accountDetails.docs;
    var data = docs[0].data();
    var id = docs[0].id;
    if (data["role"] == "Student") {
      Account account = await Account(
          id: id,
          name: data["userName"],
          email: data["email"],
          dob: data["dob"],
          role: data["role"],
          userId: data["userId"],
          branch: data["branch"],
          semester: data["semester"],
          rollNo: data["rollNo"]);
      return account;
    } else {
      Account account = await Account(
          id: id,
          name: data["userName"],
          email: data["email"],
          dob: data["dob"],
          role: data["role"],
          userId: data["userId"],
          branch: data["branch"],
          semester: "",
          rollNo: "");
      return account;
    }
  }
}
