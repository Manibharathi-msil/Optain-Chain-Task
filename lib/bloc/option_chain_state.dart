import 'package:equatable/equatable.dart';
import '../model/list_call_put.dart';

abstract class OptionChainState extends Equatable {
  const OptionChainState();

  @override
  List<Strike> get props => [];
}
class OptionChainInitial extends OptionChainState {}

class OptionChainblocLoading extends OptionChainState {}

class PositionState extends OptionChainState {
  int pos;
  int bias;
  PositionState({required this.pos,required this.bias});
}

class OptionChainError extends OptionChainState {
  String msg;
  OptionChainError({required this.msg});
}

