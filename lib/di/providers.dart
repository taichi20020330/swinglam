import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:swinglam/data_models/location.dart';
import 'package:swinglam/models/db/databese_manager.dart';
import 'package:swinglam/models/location/location_manager.dart';
import 'package:swinglam/models/repositories/post_repository.dart';
import 'package:swinglam/view_models/login_view_model.dart';

import '../models/repositories/user_repository.dart';
import '../view_models/post_view_model.dart';

List<SingleChildWidget> globalProviders = [
  ...independentModels,
  ...dependentModels,
  ...viewModels
];

List<SingleChildWidget> independentModels = [
  Provider<DatabaseManager>(
      create: (_) => DatabaseManager()),
  Provider<LocationManager>(
      create: (_) => LocationManager())

];

List<SingleChildWidget> dependentModels = [
  ProxyProvider<DatabaseManager, UserRepository>(
      update: (_, dbManager, repo) => UserRepository(dbManager:dbManager),
  ),
  ProxyProvider2<DatabaseManager, LocationManager, PostRepository>(
    update: (_, dbManager, locationManager, repo) => PostRepository(
      dbManager: dbManager,
        locationManager: locationManager
    ),
  ),
];

List<SingleChildWidget> viewModels = [
  ChangeNotifierProvider<LoginViewModel>(
      create: (context) => LoginViewModel(
      userRepository: context.read<UserRepository>()
  ),
  ),
  ChangeNotifierProvider<PostViewModel>(
    create: (context) => PostViewModel(
      userRepository: context.read<UserRepository>(),
      postRepository: context.read<PostRepository>(),
    ),
  ),
];