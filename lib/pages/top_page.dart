import 'package:flutter/material.dart';
import 'package:udemy_chat_app/models/user.dart';
import 'package:udemy_chat_app/pages/setting_profile_page.dart';
import 'package:udemy_chat_app/pages/talk_room_page.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  List<User> userList = [
    User(
        name: '田中',
        uid: 'abc',
        imagePath:
            'https://play-lh.googleusercontent.com/3ImQkiRynf23t3kZ3PMtmGNA0OaozdlzjkH0e2OTV_wmHxUdXglyGpnWuxqmofmMAw',
        lastMessage: 'こんにちは'),
    User(
        name: '佐藤',
        uid: 'bca',
        imagePath:
            'https://play-lh.googleusercontent.com/3ImQkiRynf23t3kZ3PMtmGNA0OaozdlzjkH0e2OTV_wmHxUdXglyGpnWuxqmofmMAw',
        lastMessage: 'Thank you'),
  ];

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
      body: ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TalkRoomPage(userList[index].name)));
              },
              child: SizedBox(
                height: 70,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CircleAvatar(
                        radius: 30,
                        backgroundImage: userList[index].imagePath == null
                            ? null
                            : NetworkImage(userList[index].imagePath!)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userList[index].name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        userList[index].lastMessage,
                        style: const TextStyle(color: Colors.grey),
                      )
                    ],
                  )
                ]),
              ),
            );
          }),
    );
  }
}
