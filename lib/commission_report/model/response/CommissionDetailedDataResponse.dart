class CommissionDetailedDataResponse {
  int? responseCode;
  String? responseMessage;
  ResponseData? responseData;

  CommissionDetailedDataResponse(
      {this.responseCode, this.responseMessage, this.responseData});

  CommissionDetailedDataResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    responseData = json['responseData'] != null
        ? new ResponseData.fromJson(json['responseData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    if (this.responseData != null) {
      data['responseData'] = this.responseData!.toJson();
    }
    return data;
  }
}

class ResponseData {
  String? message;
  int? statusCode;
  int? wagerAmt;
  int? winningAmt;
  String? commOn;
  String? setStartingDate;
  String? setEndingDate;
  List<Data>? data;

  ResponseData.copy(
      {this.message,
        this.statusCode,
        this.wagerAmt,
        this.winningAmt,
        this.commOn,
        this.setStartingDate,
        this.setEndingDate,
        this.data});


  ResponseData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    wagerAmt = json['wagerAmt'];
    winningAmt = json['winningAmt'];
    commOn = json['commOn'];
    setStartingDate = json['setStartingDate'];
    setEndingDate = json['setEndingDate'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    data['wagerAmt'] = this.wagerAmt;
    data['winningAmt'] = this.winningAmt;
    data['commOn'] = this.commOn;
    data['setStartingDate'] = this.setStartingDate;
    data['setEndingDate'] = this.setEndingDate;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? setName;
  int? setId;
  String? isMergedSlab;
  String? chainType;
  List<SlabsInfo>? slabsInfo;
  String? config;
  int? amount;

  Data(
      {this.setName,
        this.setId,
        this.isMergedSlab,
        this.chainType,
        this.slabsInfo,
        this.config});

  Data.fromJson(Map<String, dynamic> json) {
    setName = json['setName'];
    setId = json['setId'];
    isMergedSlab = json['isMergedSlab'];
    chainType = json['chainType'];
    if (json['slabsInfo'] != null) {
      slabsInfo = <SlabsInfo>[];
      json['slabsInfo'].forEach((v) {
        slabsInfo!.add(new SlabsInfo.fromJson(v));
      });
    }
    config = json['config'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['setName'] = this.setName;
    data['setId'] = this.setId;
    data['isMergedSlab'] = this.isMergedSlab;
    data['chainType'] = this.chainType;
    if (this.slabsInfo != null) {
      data['slabsInfo'] = this.slabsInfo!.map((v) => v.toJson()).toList();
    }
    data['config'] = this.config;
    return data;
  }
}

class SlabsInfo {
  String? orgTypeCode;
  List<Slabs>? slabs;

  SlabsInfo({this.orgTypeCode, this.slabs});

  SlabsInfo.fromJson(Map<String, dynamic> json) {
    orgTypeCode = json['orgTypeCode'];
    if (json['slabs'] != null) {
      slabs = <Slabs>[];
      json['slabs'].forEach((v) {
        slabs!.add(new Slabs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orgTypeCode'] = this.orgTypeCode;
    if (this.slabs != null) {
      data['slabs'] = this.slabs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slabs {
  String? rangeTo;
  String? commRate;
  String? rangeFrom;

  Slabs({this.rangeTo, this.commRate, this.rangeFrom});

  Slabs.fromJson(Map<String, dynamic> json) {
    rangeTo = json['rangeTo'];
    commRate = json['commRate'];
    rangeFrom = json['rangeFrom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rangeTo'] = this.rangeTo;
    data['commRate'] = this.commRate;
    data['rangeFrom'] = this.rangeFrom;
    return data;
  }
}
