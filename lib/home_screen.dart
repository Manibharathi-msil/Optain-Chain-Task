import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:option_chain_price_evaluation_task/bloc/option_chain_event.dart';
import 'package:option_chain_price_evaluation_task/bloc/option_chain_state.dart';
import 'package:option_chain_price_evaluation_task/constants/constant.dart';
import 'package:option_chain_price_evaluation_task/repository/list_resp.dart';
import 'package:option_chain_price_evaluation_task/widget/option_chain_widget.dart';
import 'bloc/option_chain_bloc.dart';
import 'model/list_call_put.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int positionIndex= -1;
  var searchedValue='';
  bool onfirstScroll = true;
  double height = 0;
  OptionChainBloc optionChainBloc = OptionChainBloc(Response());
  ValueNotifier<int> firstVisibleItem = ValueNotifier<int>(0);
  ValueNotifier<int> lastVisibleItem = ValueNotifier<int>(0);
  ValueNotifier<int> strikeIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    // TODO: implement initState
    optionChainBloc.add(FetchOptionChainData());
    _controller.addListener(scrollListenerWithItemCount);
    super.initState();
  }

  var option = Option.fromJson(Response.response);
  final ScrollController _controller = ScrollController();

  //In currentIndex we are adding 3 values
  List<Widget> _buildCells(Color bg, Option option, String type,
      int currentIndex) {
    List<String> values = [];
    if (type == Strings.put) {
      values.add(option.strikes.elementAt(currentIndex).put.change);
      values.add(option.strikes.elementAt(currentIndex).put.oi);
      values.add(option.strikes.elementAt(currentIndex).put.ltp);
    } else if (type == Strings.call) {
      values.add(option.strikes.elementAt(currentIndex).call.ltp);
      values.add(option.strikes.elementAt(currentIndex).call.oi);
      values.add(option.strikes.elementAt(currentIndex).call.change);
    } else {
      option.strikes.forEach((element) {
        values.add(element.value);
      });
    }


    return List.generate(
      values.length, (index) =>
         Stack(
           children: [
             Container(
               alignment: Alignment.center,
               width: MediaQuery.of(context).size.width / 5,
               height: 60.0,
               color: bg,
               child: Text(values.elementAt(index),
                   style: const TextStyle(color: Colors.white)),
             ),
             if (type == Strings.strike)
             index == positionIndex ? Visibility(
               visible: searchedValue.isNotEmpty,
               child: Container(
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(30.0),
                         color: Colors.grey),
                     alignment: Alignment.center,
                     width: MediaQuery.of(context).size.width /5,
                     height: 40.0,
                     child: Text(values.elementAt(index),
                         style: const TextStyle(color: Colors.white)),
                   ),
             ):Container(),
           ],
         ),
    );

  }

  //Generating values of entire length of rows
  List<Widget> _buildRows(Color bg, Option option, String type) {
    return List.generate(
      option.strikes.length,
          (index) =>
          Row(
            children: _buildCells(bg, option, type, index ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => optionChainBloc,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(widget.title),
          bottom: AppBar(
            toolbarHeight: 50,
            title: Column(
              children: [
                Container(
                    width: double.infinity,
                    height: 40,
                    color: Colors.white,
                    child: Center(
                      child: BlocBuilder<OptionChainBloc, OptionChainState>(
                          builder: (context, state) {
                            double pos = 60;
                            if (state is PositionState) {
                              pos = pos * state.pos;
                              positionIndex = state.pos;
                              if (pos != -1) {
                                _controller.animateTo(
                                  pos + state.bias,
                                  curve: Curves.easeOut,
                                  duration: const Duration(milliseconds: 300),
                                );
                              }
                            }
                            return TextField(
                              onSubmitted: (value) {
                                searchedValue = value;
                                optionChainBloc.add(FetchPosition(v: value));
                              },
                              decoration: const InputDecoration(
                                  hintText: Strings.search,
                                  suffixIcon: Icon(Icons.search)),
                            );
                          }),
                    ))
              ],
            ),
          ),
        ),
        body: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 39),
                    child: _buildContentWidget()
                  ),
                  const OptionChainTitle(),
                  Align(
                    alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: spotPriceTopView(),
                      )),
                  Align(alignment : Alignment.bottomCenter,
                      child: spotPriceBottomView())
                ],
               )
                  ));
  }

  scrollListenerWithItemCount() {
    int itemCount = option.strikes.length;
    double? scrollOffset = _controller.position.pixels;
    double? viewportHeight = _controller.position.viewportDimension;
    double? scrollRange = (_controller.position.maxScrollExtent) -
        (_controller.position.minScrollExtent);
    lastVisibleItem.value = (((scrollOffset) + (viewportHeight)) /
        (scrollRange + (viewportHeight)) * itemCount).floor();
    firstVisibleItem.value =
        (((scrollOffset)) / (scrollRange + (viewportHeight)) * itemCount)
            .floor();
    if (onfirstScroll) {
      _controller.animateTo(
          (height *
              (strikeIndex.value -
                  (((firstVisibleItem.value + lastVisibleItem.value) / 2))))
              .toDouble(),
          duration: const Duration(seconds: 1),
          curve: Curves.easeInExpo);
      onfirstScroll = false;
    }
  }


  Widget _buildContentWidget() {
  return Column(
    children: [
      Expanded(
          child: SingleChildScrollView(
        controller: _controller,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  _buildRows(Colors.black, option, Strings.put),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              _buildCells(Colors.green, option, Strings.strike, 0),
            ),
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  _buildRows(Colors.black, option, Strings.call),
                ),
              ),
            )
          ],
        ),
      ),
      )
    ],
  );
}
  ValueListenableBuilder<int> spotPriceBottomView() {
    return ValueListenableBuilder<int>(
        valueListenable: lastVisibleItem,
        builder: (context, value, _) {
          if (value < positionIndex && value !=0) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.grey),
              alignment: Alignment.center,
              width: (MediaQuery.of(context).size.width / 5)*1.5,
              height: 40.0,
              child: Text(searchedValue,
                  style: const TextStyle(color: Colors.white)),
            );
          } else {
            return Container();
          }
        });
  }

  ValueListenableBuilder<int> spotPriceTopView() {
    return ValueListenableBuilder<int>(
        valueListenable: firstVisibleItem,
        builder: (context, value, _) {
          if (value >= positionIndex && value != 0 && positionIndex != -1) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.grey),
              alignment: Alignment.center,
              width: (MediaQuery.of(context).size.width / 5)*1.5,
              height: 40.0,
              child: Text(searchedValue,
                  style: const TextStyle(color: Colors.white)),
            );
          } else {
            return Container();
          }
        });
  }
  @override
  void dispose() {
    _controller.removeListener(scrollListenerWithItemCount);
    super.dispose();
  }

}
