import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_app/Models/login.model.dart';
import 'package:user_repository/user_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.LOADING) {
    _loginDefaultUser();
  }

  Account _userAccount;

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is OpenTableDetail) {
      yield _mapOpenTableDetailToState(event, state);
    } else if (event is DoneLoading) {
      yield HomeState.IDLE;
    } else if (event is ErrorLoading) {
      yield HomeState.ERROR;
    }
  }

  HomeState _mapOpenTableDetailToState(
    OpenTableDetail event,
    HomeState state,
  ) {
    return HomeState.IDLE;
    // final username = Username.dirty(event.username);
    // return state.copyWith(
    //   username: username,
    //   status: Formz.validate([state.password, username]),
    // );
  }

  Account getUserAccount() {
    return _userAccount;
  }

  _loginDefaultUser() {
    LoginModel.instance.login('test').then((value) {
      if (value != null) {
        _userAccount = value;
        add(DoneLoading(_userAccount));
      } else {
        add(ErrorLoading());
      }
    }).catchError((onError) {
      add(ErrorLoading());
    });
  }
}
