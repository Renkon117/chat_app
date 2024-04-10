class User {
  String name;
  String uid;
  String? imagePath;
  String lastMessage;

  User({
    required this.name,
    required this.uid,
    required this.imagePath,
    this.lastMessage = '',
  });
}
