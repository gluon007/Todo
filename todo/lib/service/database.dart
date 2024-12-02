import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/service/constants.dart';

class DatabaseMethods {
  // create user
  Future<String> createMyUser(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('Task')
          .doc(id)
          .set({'data': []});
      return success;
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<dynamic>> getdata(String id) async {
    try {
      print('start');
      final data =
          await FirebaseFirestore.instance.collection('Task').doc(id).get();

      print('end');
      print("data.data() ${data.data()}");

      return data.data()!['data'] as List<dynamic>;
    } catch (e) {
      print('error: $e');
      return [];
    }
  }

  Future<void> addNewTask(List<dynamic> taskList, String id) async {
    return await FirebaseFirestore.instance
        .collection('Task')
        .doc(id)
        .update({"data": taskList});
  }

  Future<String> forgot(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return success;
    } on FirebaseAuthException catch (e) {
      return "error:${e.code}";
    } catch (e) {
      return "error:$e";
    }
  }

  Future<String> signup(String email, String password) async {
    try {
      final user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await createMyUser(user.user!.uid);
      return success;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> auth(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user == null
          ? "error: user not found"
          : credential.user!.uid;
    } on FirebaseAuthException catch (e) {
      return "error:${e.code}";
    } catch (e) {
      return "error:$e";
    }
  }

  Future<String> signout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return success;
    } catch (e) {
      return "error: $e";
    }
  }
}
