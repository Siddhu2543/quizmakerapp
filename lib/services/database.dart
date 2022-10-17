import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:quizmaker/helper/constants.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  Future<void> addData(userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      print(e);
    });
  }

  getData() async {
    return await FirebaseFirestore.instance.collection("users").snapshots();
  }

  Future<void> addQuizData(Map<String, dynamic> quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> addQuestionData(quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .add(quizData)
        .catchError((e) {
      print(e);
    });
  }

  addResponseDate(response) async {
    await FirebaseFirestore.instance.collection("Response").add(response).catchError((e){
      print(e);
    });
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getQuizData() async {
    return await FirebaseFirestore.instance.collection("Quiz").snapshots();
  }

  getQuizDataByFaculty() async {
    String email = "";
    await Constants.getUserDetailsSharedPreference().then((value) {
      email = value[1];
    });
    return await FirebaseFirestore.instance.collection("Quiz").where("maker", isEqualTo: email).snapshots();
  }

  getQuizDataByStudent() async {
    String branch = "", semester = "";
    await Constants.getUserDetailsSharedPreference().then((value) {
      branch = value[5];
      semester = value[6];
    });
    return await FirebaseFirestore.instance.collection("Quiz").where("branch", isEqualTo: branch).where("semester", isEqualTo: semester).snapshots();
  }

  getResponseData(email) async {
    return await FirebaseFirestore.instance.collection("Response").where("stdEmail", isEqualTo: email).snapshots();
  }

  getQuizListForFaculty(email) async {
    return await FirebaseFirestore.instance.collection("Quiz").where("maker", isEqualTo: email).snapshots();
  }

  getResponseListForFaculty(quizTitle) async {
    return await FirebaseFirestore.instance.collection("Response").where("quizTitle", isEqualTo: quizTitle).snapshots();
  }

  getQuestionData(String quizId) async {
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserDetails(
      String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
  }

  updateDetails(
      {required String email,
      String? name,
      String? dob,
      String? semester,
      String? rollNo}) async {
    var account = await Constants.getUserDetailsSharedPreference();
    var id = await account[8];
    if (name != null)
      FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .update({"userName": name});
    if (dob != null)
      FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .update({"dob": dob});
    if (rollNo != null)
      FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .update({"rollNo": rollNo});
    if (semester != null)
      FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .update({"semester": semester});
  }
}
