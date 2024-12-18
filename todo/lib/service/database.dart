import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/service/constants.dart';

class DatabaseMethods {
  Future<List<Map<String, dynamic>>> getdata(String id) async {
    try {
      final data =
          await FirebaseFirestore.instance.collection('Task').doc(id).get();
      List<Map<String, dynamic>> taskList = [];
      if (data.data() == null) {
        return taskList;
      }
      taskList = List<Map<String, dynamic>>.from(data.data()!['data']);
      return taskList;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<void> updateTask(
      List<Map<String, dynamic>> taskList, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('Task')
          .doc(id)
          .set({'data': taskList});
    } catch (e) {
      debugPrint(e.toString());
    }
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
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
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
