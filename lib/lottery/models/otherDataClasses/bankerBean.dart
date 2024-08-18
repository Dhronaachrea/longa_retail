class BankerBean {
  String? number;
  String? color;
  int? index;
  bool? isSelectedInUpperLine;

  BankerBean({this.number,  this.color,  this.index, this.isSelectedInUpperLine});

  BankerBean.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    color = json['color'];
    index = json['index'];
    isSelectedInUpperLine = json['isSelectedInUpperLine'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['color'] = color;
    data['index'] = index;
    data['isSelected'] = isSelectedInUpperLine;
    return data;
  }
}
