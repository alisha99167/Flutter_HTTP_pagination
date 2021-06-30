import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_assignment/model.user.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String url = "https://reqres.in/api/users?page=";
  bool _loading=false;
  ScrollController? _scrollController;
  int page=0;
  bool hasMoreData=true;
  List<User> users=[];

  @override
  void initState() {
    _fetch(0);
    _scrollController = new ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Users"),),
      body: _body(),
    );
  }


  _body(){
    if(_loading && users.isEmpty) return Center(child: CupertinoActivityIndicator(),);
    return ListView.separated(
      controller: _scrollController,
      separatorBuilder: (context,index){
        return Container(height: 70);
      },
      itemCount: users.length+(_loading && users.isNotEmpty?1:0),
      itemBuilder: (context,index){
        if(_loading && users.isNotEmpty && index==users.length){
          return CupertinoActivityIndicator();
        }
       return ListTile(
         leading: CircleAvatar(backgroundImage: NetworkImage(users[index].avatar!),),
         title: Text(users[index].first_name!+" "+users[index].last_name!),
         subtitle: Text(users[index].email!),
       );
      }
    );
  }


  _fetch(int page) async{
    if(hasMoreData && !_loading){
      setState(() {
        _loading=true;
      });
      try{
        Response response = await get(Uri.parse(url+page.toString()));
        Map<String,dynamic> decoded=json.decode(response.body);

        if(decoded['data']?.length==0){
          hasMoreData=false;
        }else{
          setState(() {
            this.page++;
            decoded['data'].forEach((item)=>users.add(User.fromJson(item)));
          });
        }
      }catch(e){
        print(e.toString());
      }
      setState(() {
        _loading=false;
      });
    }
  }

  _loadMore() async{
    await _fetch(page);
  }


  void _scrollListener() {
    if ((_scrollController?.position.extentAfter ?? 500) < 500) {
      _loadMore();
    }
  }
}
