import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:udemy_chat_app/firestore/room_firestore.dart';
import 'package:udemy_chat_app/models/talk_room.dart';
import 'package:udemy_chat_app/models/user.dart';
import 'package:udemy_chat_app/pages/setting_profile_page.dart';
import 'package:udemy_chat_app/pages/talk_room_page.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('チャットアプリ'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingProfilePage()));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: RoomFirestore.joinedRoomSnapshot,
          builder: (context, streamSnapshot) {
            if (streamSnapshot.hasData) {
              return FutureBuilder<List<TalkRoom>?>(
                  future: RoomFirestore.fetchJoinRooms(streamSnapshot.data!),
                  builder: (context, futureSnapshot) {
                    List<TalkRoom> talkRooms = futureSnapshot.data!;
                    if(futureSnapshot.connectionState == ConnectionState.waiting){
                      return Center(child: const CircularProgressIndicator());
                    } else {
                      if (futureSnapshot.hasData) {
                        return ListView.builder(
                            itemCount: talkRooms.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TalkRoomPage(
                                              talkRooms[index].talkUser.name)));
                                },
                                child: SizedBox(
                                  height: 70,
                                  child: Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: talkRooms[index]
                                              .talkUser
                                              .imagePath ==
                                              null
                                              ? null
                                              : NetworkImage(talkRooms[index]
                                              .talkUser
                                              .imagePath!)),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          talkRooms[index].talkUser.name,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          talkRooms[index].lastMessage ?? '',
                                          style:
                                          const TextStyle(color: Colors.grey),
                                        )
                                      ],
                                    )
                                  ]),
                                ),
                              );
                            });
                      } else {
                        return Center(child: const Text('トークの取得に失敗しました'));
                      }
                    }
                  });
            } else {
              return Center(child: const CircularProgressIndicator());
            }
          }),
    );
  }
}
