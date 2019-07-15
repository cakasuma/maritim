import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maritim/bloc/authentication/bloc.dart';
import 'package:maritim/bloc/user_repository.dart';
import 'package:maritim/main_bloc_delegate.dart';
import 'package:maritim/pages/splash_screen.dart';
import 'package:maritim/pages/home_screen.dart';

main() {
  BlocSupervisor.delegate = MainBlocDelegate();
  runApp(MaritimApp());
}

class MaritimApp extends StatefulWidget {
  @override
  _MaritimAppState createState() => _MaritimAppState();
}

class _MaritimAppState extends State<MaritimApp> {
  final UserRepository _userRepository = UserRepository();
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    _authenticationBloc.dispatch(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        builder: (BuildContext context) => _authenticationBloc,
        child: MaterialApp(
            home: BlocBuilder(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is Uninitialized) {
              return SplashScreen();
            }

            if (state is Authenticated) {
              return HomeScreen(email: state.displayEmail);
            }

            return Container();
          },
        )));
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    super.dispose();
  }
}
