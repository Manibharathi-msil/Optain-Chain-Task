import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:option_chain_price_evaluation_task/bloc/option_chain_state.dart';
import 'package:option_chain_price_evaluation_task/repository/list_resp.dart';

import '../model/list_call_put.dart';
import 'option_chain_event.dart';

class OptionChainBloc extends Bloc<OptionChainEvent, OptionChainState> {
  final Response _optionRepo;

  OptionChainBloc(this._optionRepo) : super(OptionChainInitial()) {
    on<OptionChainEvent>((event, emit) async {
      if (event is FetchPosition) {
        emit(OptionChainblocLoading());
        try {
          var option = Option.fromJson(Response.response);
          int biasPos = 0;
          for (int i = 0 ; i< option.strikes.length ; i++) {
              if( option.strikes.elementAt(i).value.compareTo(event.v) == 0){
                emit(PositionState(pos: i, bias: 0,));
              }
              else {
                if(int.parse(option.strikes.elementAt(i).value ) < int.parse(event.v)){
                  biasPos = i;
                  if(int.parse(option.strikes.elementAt(i+1).value ) > int.parse(event.v)){
                    emit(PositionState(pos: biasPos+1, bias: 10,));
                  }
                }
              }
            }
          emit(PositionState(pos: -1, bias: 0));
        } catch (e) {
          emit(OptionChainError(msg: e.toString()));
        }
      }
    });
  }
}
