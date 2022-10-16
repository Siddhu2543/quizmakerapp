import 'package:cloud_firestore/cloud_firestore.dart';
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

  getQuizData() async {
    return await FirebaseFirestore.instance.collection("Quiz").snapshots();
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
