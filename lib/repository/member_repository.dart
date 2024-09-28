import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/committee_type.dart';
import '../models/member.dart';
import '../utils/keys.dart';

class MemberRepository {
  MemberRepository._internal();

  static final MemberRepository _instance = MemberRepository._internal();

  factory MemberRepository() => _instance;

  final CollectionReference<Map<String, dynamic>> _ref = FirebaseFirestore.instance.collection('members');

  Future<Member?> findByUsername(String username) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _ref.where(Keys.username, isEqualTo: username).get();
    if (querySnapshot.size == 0) {
      log('Member Not Found with Username: $username');
      return null;
    }

    final QueryDocumentSnapshot<Map<String, dynamic>> snapshot = querySnapshot.docs.first;
    if (!snapshot.exists) {
      log('Member Not Found with Username: $username');
      return null;
    }

    return Member.fromMap(snapshot.data());
  }

  Future<List<Member>> findMembersByCommitteeType(CommitteeType committeeType) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _ref
        .where(Filter(
          Keys.committeeType,
          whereIn: [committeeType.value, CommitteeType.both.value],
        ))
        .get();
    return _getMemberList(querySnapshot);
  }

  Future<List<Member>> findMembersByArea(String area, int pageSize, List<Member>? lastResult) async {
    final Query<Map<String, dynamic>> query = _ref
        .where(
          Keys.area,
          isEqualTo: area,
        )
        .orderBy(Keys.name)
        .limit(pageSize);
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        lastResult != null ? await query.startAfter(lastResult).get() : await query.get();
    return _getMemberList(querySnapshot);
  }

  Future<List<Member>> findMembersByNativePlace(String nativePlace, int pageSize, List<Member>? lastResult) async {
    final Query<Map<String, dynamic>> query = _ref
        .where(
          Keys.nativePlace,
          isEqualTo: nativePlace,
        )
        .orderBy(Keys.name)
        .limit(pageSize);
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        lastResult != null ? await query.startAfter(lastResult).get() : await query.get();
    return _getMemberList(querySnapshot);
  }

  Future<List<Member>> findUsersByParams(String? name, String? area, String? nativePlace) async {
    if (name == null && area == null && nativePlace == null) {
      throw Exception('Invalid Search Criteria!!');
    }

    Query<Map<String, dynamic>> query = _ref;
    if (name != null) {
      query = query
          .where(
            Keys.name,
            isGreaterThan: name,
          )
          .where(Keys.name, isLessThan: '${name}z');
    }
    if (area != null) {
      query = query.where(Keys.area, isEqualTo: area);
    }
    if (nativePlace != null) {
      query = query.where(Keys.nativePlace, isEqualTo: nativePlace);
    }

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await query
        .orderBy(
          Keys.name,
        )
        .get();
    return _getMemberList(querySnapshot);
  }

  Future<List<Member>> findMembersByFamilyId(String familyId) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _ref.where(Keys.familyId, isEqualTo: familyId).get();
    return _getMemberList(querySnapshot);
  }

  Future<void> removeById(String uid) async => await _ref.doc(uid).delete();

  Future<Member> save(Member member) async {
    if (member.uid.trim().isEmpty) {
      DocumentReference<Map<String, dynamic>> memberRef = _ref.doc();
      member.uid = memberRef.id;
      if (member.canLogin()) {
        member.familyId = memberRef.id;
        member.familyOrder = 0;
      }

      await memberRef.set(member.toMap());
      return member;
    } else {
      member.lastUpdated = DateTime.now().microsecondsSinceEpoch;
      await _ref.doc(member.uid).update(member.toMap());
      return member;
    }
  }

  /// private methods
  List<Member> _getMemberList(QuerySnapshot<Map<String, dynamic>> querySnapshot) {
    List<Member> members = [];
    for (QueryDocumentSnapshot<Map<String, dynamic>> snapshot in querySnapshot.docs) {
      if (snapshot.exists) {
        members.add(Member.fromMap(snapshot.data()));
      }
    }
    debugPrint('Members List: ${members.length}');
    return members;
  }
}
