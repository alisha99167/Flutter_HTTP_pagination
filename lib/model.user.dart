class User{
  int? id;
  String? email;
  String? first_name;
  String? last_name;
  String? avatar;

  User.fromJson(Map<String,dynamic> data){
    id=data['id'];
    email=data['email'];
    first_name=data['first_name'];
    last_name=data['last_name'];
    avatar=data['avatar'];
  }
}