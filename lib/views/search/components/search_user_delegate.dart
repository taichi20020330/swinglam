import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/view_models/search_view_model.dart';
import 'package:swinglam/views/commons/components/user_card.dart';

import '../../../data_models/user.dart';

class SearchUserDelegate extends SearchDelegate<User?> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () => query = "",
          icon: Icon(Icons.close)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchViewModel = context.read<SearchViewModel>();
    searchViewModel.searchUsers(query);
   return _buildResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResults(context);
  }

  Widget _buildResults(BuildContext context) {
    return Consumer<SearchViewModel>(
        builder: (context, model, child) => ListView.builder(
          itemCount: model.soughtUsers.length,
          itemBuilder: (context, int index){
            final user = model.soughtUsers[index];
            return UserCard(
                imageUrl: user.photoUrl,
                title: user.inAppUserName,
                subTitle: user.bio,
              onTap: () => close(context, user),
            );
          },

        )
    );
  }
  
}