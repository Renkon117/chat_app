import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udemy_chat_app/firestore/room_firestore.dart';
import 'package:udemy_chat_app/models/user.dart';
import 'package:udemy_chat_app/utils/shared_prefs.dart';

class UserFirestore {
  static final FirebaseFirestore _firebaseFirestoreInstance =
      FirebaseFirestore.instance;
  static final _userCollection = _firebaseFirestoreInstance.collection('user');

  static Future<String?> insertNewAccount() async {
    try {
      final newDoc = await _userCollection.add({
        'name': '名無し',
        'image_path':
            'https://play-lh.googleusercontent.com/3ImQkiRynf23t3kZ3PMtmGNA0OaozdlzjkH0e2OTV_wmHxUdXglyGpnWuxqmofmMAw'
      });

      print('アカウント作成完了');
      return newDoc.id;
    } catch (e) {
      print('アカウント作成失敗 ====== $e');
      return null;
    }
  }

  static Future<void> createUser() async {
    final myUid = await UserFirestore.insertNewAccount();
    if (myUid != null) {
      await RoomFirestore.createRoom(myUid);
      await SharedPrefs.setUid(myUid);
    }
  }

  static Future<List<QueryDocumentSnapshot>?> fetchUsers() async {
    try {
      final snapshot = await _userCollection.get();
      snapshot.docs.forEach((doc) {
        print('ドキュメントID: ${doc.id} ----- 名前 ${doc.data()['name']}');
      });

      return snapshot.docs;
    } catch (e) {
      print('ユーザー情報の取得失敗 ====== $e');
      return null;
    }
  }

  static Future<void> updateUser(User newProfile) async {
    try {
      await _userCollection.doc(newProfile.uid).update(
          {'name': newProfile.name, 'image_path': newProfile.imagePath});
    } catch (e) {
      print('ユーザー情報の更新失敗 ====== $e');
    }
  }

  static Future<User?> fetchMyProfile(String uid) async {
    try {
      final snapshot = await _userCollection.doc(uid).get();
      User user = User(
          name: snapshot.data()!['name'],
          imagePath: snapshot.data()!['image_path'],
          uid: uid);

      return user;
    } catch (e) {
      print('自分のユーザー情報の取得失敗 ====== $e');
      return null;
    }
  }
}
