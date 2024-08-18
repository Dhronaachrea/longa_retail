class BlinkerDataClass {
  bool? blinker;

  BlinkerDataClass({this.blinker});

  BlinkerDataClass.fromJson(Map<String, dynamic> json) {
    blinker = json['blinker'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['blinker'] = this.blinker;
    return data;
  }
}
