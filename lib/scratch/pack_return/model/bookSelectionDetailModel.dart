class BookSelectionDetailModel {
  String? bookNumber;
  bool? isSelected;

  BookSelectionDetailModel({this.bookNumber, this.isSelected});

  BookSelectionDetailModel.fromJson(Map<String, dynamic> json) {
    bookNumber = json['bookNumber'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookNumber'] = this.bookNumber;
    data['isSelected'] = this.isSelected;
    return data;
  }
}
