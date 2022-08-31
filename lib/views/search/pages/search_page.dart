import 'package:flutter/material.dart';
import 'package:swinglam/constants.dart';
import 'package:swinglam/views/profile/screens/profile_screen.dart';
import 'package:swinglam/views/search/components/search_user_delegate.dart';

import '../../../style.dart';

class SearchPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: Icon(Icons.search),
        title: InkWell(
          child: Text("検索", style: searchAppbarTextStyle),
          onTap: () => _searchTextField(context),
          splashColor: Colors.white30,
        ),
      ),
      body: Center(
      ),
    );
  }

  _searchTextField(BuildContext context) async {
    final selectedUser = await showSearch(
        context: context,
        delegate: SearchUserDelegate()
    );
    if ( selectedUser != null ) {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ProfileScreen(
              profileMode: ProfileOpenMode.OTHER,
            selectedUser: selectedUser,
          ))
      );
    }
  }



}
