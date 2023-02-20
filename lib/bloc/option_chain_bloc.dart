import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:option_chain_price_evaluation_task/bloc/option_chain_state.dart';
import 'package:option_chain_price_evaluation_task/repository/list_resp.dart';

import '../model/list_call_put.dart';
import 'option_chain_event.dart';


class OptionChainBloc extends Bloc<OptionChainEvent, OptionChainState> {
  final Response _contactRepo;

  OptionChainBloc(this._contactRepo) : super(OptionChainInitial()) {
    on<OptionChainEvent>((event, emit) async {
      if (event is FetchPosition) {
        emit(OptionChainblocLoading());
        try {
          var option = Option.fromJson(Response.response);
          for (int i = 0 ; i< option.strikes.length ; i++) {
              if( option.strikes.elementAt(i).value.compareTo(event.v) == 0){
                emit(PositionState(pos: i));
              }
            }
          emit(PositionState(pos: -1));
        } catch (e) {
          emit(OptionChainError(msg: e.toString()));
        }
      }
    });
  }
}
