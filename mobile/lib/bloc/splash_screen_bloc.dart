import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:my_flutter_parking_app/bloc/bloc.dart';
import 'bloc.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  @override
  SplashScreenState get initialState => InitialSplashScreenState();

  @override
  Stream<SplashScreenState> mapEventToState(
    SplashScreenEvent event,
  ) async* {
    if(event is LaunchingApplication) {
      yield InitialSplashScreenState();
      await delay();
      yield DoneSplashScreenState();
    }
    // TODO: Add Logic
  }

  Future delay() async{
    await new Future.delayed(new Duration(milliseconds: 1500), ()
    {
    });
  }
}
