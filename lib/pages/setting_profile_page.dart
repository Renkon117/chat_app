import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:udemy_chat_app/firestore/user_firestore.dart';
import 'package:udemy_chat_app/models/user.dart';
import 'package:udemy_chat_app/utils/shared_prefs.dart';

class SettingProfilePage extends StatefulWidget {
  const SettingProfilePage({super.key});

  @override
  State<SettingProfilePage> createState() => _SettingProfilePageState();
}

class _SettingProfilePageState extends State<SettingProfilePage> {
  final TextEditingController controller = TextEditingController();
  File? image;
  String imagePath = '';
  final ImagePicker _picker = ImagePicker();

  Future<void> selectImage() async {
    PickedFile? pickedImage =
        await _picker.getImage(source: ImageSource.gallery);
    if (pickedImage == null) return;

    setState(() {
      image = File(pickedImage.path);
    });
  }

  Future<void> uploadImage() async {
    String path = image!.path.substring(image!.path.lastIndexOf('/') + 1);
    final ref = FirebaseStorage.instance.ref(path);
    final storedImage = await ref.putFile(image!);
    imagePath = await storedImage.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('チャットアプリ'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: const [
                  SizedBox(
                    width: 150,
                    child: Text('名前'),
                  ),
                  Expanded(
                    child: TextField(),
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text('プロフィール画像'),
                  ),
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                              onPressed: () async {
                                await selectImage();
                                uploadImage();
                              },
                              child: const Text('画像を選択'))))
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              image == null
                  ? const SizedBox()
                  : SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.file(
                        image!,
                        fit: BoxFit.cover,
                      )),
              const SizedBox(
                height: 150,
              ),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    User newProfile = User(
                        name: controller.text,
                        uid: SharedPrefs.fetchUid()!,
                        imagePath: imagePath);
                    await UserFirestore.updateUser(newProfile);
                  },
                  child: const Text('編集'),
                ),
              )
            ],
          ),
        ));
  }
}
