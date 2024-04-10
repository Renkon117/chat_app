import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udemy_chat_app/firestore/user_firestore.dart';
import 'package:udemy_chat_app/models/talk_room.dart';
import 'package:udemy_chat_app/models/user.dart';
import 'package:udemy_chat_app/utils/shared_prefs.dart';

class RoomFirestore {
  static final FirebaseFirestore _firebaseFirestoreInstance =
      FirebaseFirestore.instance;
  static final _roomCollection = _firebaseFirestoreInstance.collection('room');
  static final joinedRoomSnapshot = _roomCollection.where(
      'joined_user_ids', arrayContains: SharedPrefs.fetchUid()).snapshots();

  static Future<void> createRoom(String myUid) async {
    try {
      final docs = await UserFirestore.fetchUsers();

      if (docs == null) return;
      docs.forEach((doc) async {
        if (doc.id == myUid) return;
        await _roomCollection.add({
          'joined_user_ids': [doc.id, myUid],
          'created_time': Timestamp.now()
        });
      });
    } catch (e) {
      print('ルームの作成失敗 ===== $e');
    }
  }

  static Future<List<TalkRoom>?> fetchJoinRooms(QuerySnapshot snapshot) async {
    try {
      String myUid = SharedPrefs.fetchUid()!;

      List<TalkRoom> talkRooms = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<dynamic> userIds = data['joined_user_ids'];
        late String talkUserUid;
        for (var id in userIds) {
          if (id == myUid) continue;
          talkUserUid = id;
        }
        User? talkUser = await UserFirestore.fetchMyProfile(talkUserUid);
        if (talkUser == null) return null;
        final talkRoom = TalkRoom(
            roomId: doc.id,
            talkUser: talkUser,
            lastMessage: data['last_message']);
        talkRooms.add(talkRoom);
      }
      print(talkRooms.length);
      return talkRooms;
    } catch (e) {
      print('参加しているルームの取得失敗 ===== $e');
      return null;
    }
  }
}
