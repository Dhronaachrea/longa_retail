class ChangePinModel {
  String? confirmNewPassword;
  String? newPassword;
  String? oldPassword;

  ChangePinModel(
      {required this.confirmNewPassword,
      required this.newPassword,
      required this.oldPassword});

  ChangePinModel.fromJson(Map<String, dynamic> json) {
    confirmNewPassword = json['confirmNewPassword'];
    newPassword = json['newPassword'];
    oldPassword = json['oldPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['confirmNewPassword'] = this.confirmNewPassword;
    data['newPassword'] = this.newPassword;
    data['oldPassword'] = this.oldPassword;
    return data;
  }
}
