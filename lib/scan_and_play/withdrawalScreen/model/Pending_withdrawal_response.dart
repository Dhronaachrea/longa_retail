class PendingWithdrawalResponse {
  int? errorCode;
  String? errorMsg;
  List<Data>? data;

  PendingWithdrawalResponse({this.errorCode, this.errorMsg, this.data});

  PendingWithdrawalResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? requestId;
  int? batchId;
  int? paymentAccId;
  int? createdAt;
  int? podmId;
  int? providerId;
  int? paymentTypeId;
  int? subTypeId;
  int? merchantId;
  int? domainId;
  int? aliasId;
  int? merchantTxnId;
  int? merchantChargesTxnId;
  int? tpProviderTxnId;
  int? userTxnId;
  String? providerTxnId;
  String? userType;
  int? userId;
  double? amount;
  double? processCharges;
  double? exchangeCharges;
  double? netAmount;
  String? status;
  String? firstApproverRemark;
  String? secondApproverRemark;
  String? finalApproverRemark;
  String? firstApproverDocument;
  String? secondApproverDocument;
  String? finalApproverDocument;
  String? device;
  int? requestedBy;
  int? cancelledBy;
  String? finalApprovalAt;
  String? cancelReason;
  int? firstApprover;
  int? secondApprover;
  int? finalApprover;
  int? paidBy;
  int? updatedAt;
  String? secondApprovalAt;
  String? firstApprovalAt;
  String? verificationCode;
  int? resendCount;
  int? retryCount;
  String? otpExpiry;
  String? otpVerified;
  String? verifiedAt;

  Data(
      {this.requestId,
        this.batchId,
        this.paymentAccId,
        this.createdAt,
        this.podmId,
        this.providerId,
        this.paymentTypeId,
        this.subTypeId,
        this.merchantId,
        this.domainId,
        this.aliasId,
        this.merchantTxnId,
        this.merchantChargesTxnId,
        this.tpProviderTxnId,
        this.userTxnId,
        this.providerTxnId,
        this.userType,
        this.userId,
        this.amount,
        this.processCharges,
        this.exchangeCharges,
        this.netAmount,
        this.status,
        this.firstApproverRemark,
        this.secondApproverRemark,
        this.finalApproverRemark,
        this.firstApproverDocument,
        this.secondApproverDocument,
        this.finalApproverDocument,
        this.device,
        this.requestedBy,
        this.cancelledBy,
        this.finalApprovalAt,
        this.cancelReason,
        this.firstApprover,
        this.secondApprover,
        this.finalApprover,
        this.paidBy,
        this.updatedAt,
        this.secondApprovalAt,
        this.firstApprovalAt,
        this.verificationCode,
        this.resendCount,
        this.retryCount,
        this.otpExpiry,
        this.otpVerified,
        this.verifiedAt});

  Data.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    batchId = json['batchId'];
    paymentAccId = json['paymentAccId'];
    createdAt = json['createdAt'];
    podmId = json['podmId'];
    providerId = json['providerId'];
    paymentTypeId = json['paymentTypeId'];
    subTypeId = json['subTypeId'];
    merchantId = json['merchantId'];
    domainId = json['domainId'];
    aliasId = json['aliasId'];
    merchantTxnId = json['merchantTxnId'];
    merchantChargesTxnId = json['merchantChargesTxnId'];
    tpProviderTxnId = json['tpProviderTxnId'];
    userTxnId = json['userTxnId'];
    providerTxnId = json['providerTxnId'];
    userType = json['userType'];
    userId = json['userId'];
    amount = json['amount'];
    processCharges = json['processCharges'];
    exchangeCharges = json['exchangeCharges'];
    netAmount = json['netAmount'];
    status = json['status'];
    firstApproverRemark = json['firstApproverRemark'];
    secondApproverRemark = json['secondApproverRemark'];
    finalApproverRemark = json['finalApproverRemark'];
    firstApproverDocument = json['firstApproverDocument'];
    secondApproverDocument = json['secondApproverDocument'];
    finalApproverDocument = json['finalApproverDocument'];
    device = json['device'];
    requestedBy = json['requestedBy'];
    cancelledBy = json['cancelledBy'];
    finalApprovalAt = json['finalApprovalAt'];
    cancelReason = json['cancelReason'];
    firstApprover = json['firstApprover'];
    secondApprover = json['secondApprover'];
    finalApprover = json['finalApprover'];
    paidBy = json['paidBy'];
    updatedAt = json['updatedAt'];
    secondApprovalAt = json['secondApprovalAt'];
    firstApprovalAt = json['firstApprovalAt'];
    verificationCode = json['verificationCode'];
    resendCount = json['resendCount'];
    retryCount = json['retryCount'];
    otpExpiry = json['otpExpiry'];
    otpVerified = json['otpVerified'];
    verifiedAt = json['verifiedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestId'] = this.requestId;
    data['batchId'] = this.batchId;
    data['paymentAccId'] = this.paymentAccId;
    data['createdAt'] = this.createdAt;
    data['podmId'] = this.podmId;
    data['providerId'] = this.providerId;
    data['paymentTypeId'] = this.paymentTypeId;
    data['subTypeId'] = this.subTypeId;
    data['merchantId'] = this.merchantId;
    data['domainId'] = this.domainId;
    data['aliasId'] = this.aliasId;
    data['merchantTxnId'] = this.merchantTxnId;
    data['merchantChargesTxnId'] = this.merchantChargesTxnId;
    data['tpProviderTxnId'] = this.tpProviderTxnId;
    data['userTxnId'] = this.userTxnId;
    data['providerTxnId'] = this.providerTxnId;
    data['userType'] = this.userType;
    data['userId'] = this.userId;
    data['amount'] = this.amount;
    data['processCharges'] = this.processCharges;
    data['exchangeCharges'] = this.exchangeCharges;
    data['netAmount'] = this.netAmount;
    data['status'] = this.status;
    data['firstApproverRemark'] = this.firstApproverRemark;
    data['secondApproverRemark'] = this.secondApproverRemark;
    data['finalApproverRemark'] = this.finalApproverRemark;
    data['firstApproverDocument'] = this.firstApproverDocument;
    data['secondApproverDocument'] = this.secondApproverDocument;
    data['finalApproverDocument'] = this.finalApproverDocument;
    data['device'] = this.device;
    data['requestedBy'] = this.requestedBy;
    data['cancelledBy'] = this.cancelledBy;
    data['finalApprovalAt'] = this.finalApprovalAt;
    data['cancelReason'] = this.cancelReason;
    data['firstApprover'] = this.firstApprover;
    data['secondApprover'] = this.secondApprover;
    data['finalApprover'] = this.finalApprover;
    data['paidBy'] = this.paidBy;
    data['updatedAt'] = this.updatedAt;
    data['secondApprovalAt'] = this.secondApprovalAt;
    data['firstApprovalAt'] = this.firstApprovalAt;
    data['verificationCode'] = this.verificationCode;
    data['resendCount'] = this.resendCount;
    data['retryCount'] = this.retryCount;
    data['otpExpiry'] = this.otpExpiry;
    data['otpVerified'] = this.otpVerified;
    data['verifiedAt'] = this.verifiedAt;
    return data;
  }
}
