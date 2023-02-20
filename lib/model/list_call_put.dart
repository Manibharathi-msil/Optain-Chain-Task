class Option {
  Option({
    required this.strikes,
  });

  List<Strike> strikes;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    strikes:
    List<Strike>.from(json["strikes"].map((x) => Strike.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "strikes": List<dynamic>.from(strikes.map((x) => x.toJson())),
  };
}

class Strike {
  Strike({
    required this.value,
    required this.put,
    required this.call,
  });

  String value;
  Call put;
  Call call;

  factory Strike.fromJson(Map<String, dynamic> json) => Strike(
    value: json["value"],
    put: Call.fromJson(json["put"]),
    call: Call.fromJson(json["call"]),
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "put": put.toJson(),
    "call": call.toJson(),
  };
}

class Call {
  Call({
    required this.ltp,
    required this.oi,
    required this.change,
  });

  String ltp;
  String oi;
  String change;

  factory Call.fromJson(Map<String, dynamic> json) => Call(
    ltp: json["LTP"],
    oi: json["OI"],
    change: json["Change"],
  );

  Map<String, dynamic> toJson() => {
    "LTP": ltp,
    "OI": oi,
    "Change": change,
  };
}