class IgeGameResponse {
  bool? success;
  Data? data;

  IgeGameResponse({this.success, this.data});

  IgeGameResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Ige? ige;
  String? ipAddress;

  Data({this.ige, this.ipAddress});

  Data.fromJson(Map<String, dynamic> json) {
    ige = json['ige'] != null ? new Ige.fromJson(json['ige']) : null;
    ipAddress = json['ipAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ige != null) {
      data['ige'] = this.ige!.toJson();
    }
    data['ipAddress'] = this.ipAddress;
    return data;
  }
}

class Ige {
  Engines? engines;

  Ige({this.engines});

  Ige.fromJson(Map<String, dynamic> json) {
    engines =
    json['engines'] != null ? new Engines.fromJson(json['engines']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.engines != null) {
      data['engines'] = this.engines!.toJson();
    }
    return data;
  }
}

class Engines {
  LONGALOTTO? lONGALOTTO;

  Engines({this.lONGALOTTO});

  Engines.fromJson(Map<String, dynamic> json) {
    lONGALOTTO = json['LONGALOTTO'] != null
        ? new LONGALOTTO.fromJson(json['LONGALOTTO'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lONGALOTTO != null) {
      data['LONGALOTTO'] = this.lONGALOTTO!.toJson();
    }
    return data;
  }
}

class LONGALOTTO {
  List<Games>? games;
  Params? params;

  LONGALOTTO({this.games, this.params});

  LONGALOTTO.fromJson(Map<String, dynamic> json) {
    if (json['games'] != null) {
      games = <Games>[];
      json['games'].forEach((v) {
        games!.add(new Games.fromJson(v));
      });
    }
    params =
    json['params'] != null ? new Params.fromJson(json['params']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.games != null) {
      data['games'] = this.games!.map((v) => v.toJson()).toList();
    }
    if (this.params != null) {
      data['params'] = this.params!.toJson();
    }
    return data;
  }
}

class Games {
  LoaderImage? loaderImage;
  PrizeSchemes? prizeSchemes;
  int? orderId;
  String? imagePath;
  int? windowHeight;
  String? isHTML5;
  String? isKeyboard;
  String? gameCategory;
  String? gameName;
  int? gameNumber;
  String? gameVersion;
  String? gameDescription;
  String? currencyCode;
  int? windowWidth;
  String? isFlash;
  String? status;
  Null? isImageGeneration;
  Null? isTablet;
  String? gameWinUpto;
  String? jackpotStatus;
  Null? bonusMultiplier;
  Null? setId;
  Null? setName;
  List<int>? betList;
  ProductInfo? productInfo;

  Games(
      {this.loaderImage,
        this.prizeSchemes,
        this.orderId,
        this.imagePath,
        this.windowHeight,
        this.isHTML5,
        this.isKeyboard,
        this.gameCategory,
        this.gameName,
        this.gameNumber,
        this.gameVersion,
        this.gameDescription,
        this.currencyCode,
        this.windowWidth,
        this.isFlash,
        this.status,
        this.isImageGeneration,
        this.isTablet,
        this.gameWinUpto,
        this.jackpotStatus,
        this.bonusMultiplier,
        this.setId,
        this.setName,
        this.betList,
        this.productInfo});

  Games.fromJson(Map<String, dynamic> json) {
    loaderImage = json['loaderImage'] != null
        ? new LoaderImage.fromJson(json['loaderImage'])
        : null;
    prizeSchemes = json['prizeSchemes'] != null
        ? new PrizeSchemes.fromJson(json['prizeSchemes'])
        : null;
    orderId = json['orderId'];
    imagePath = json['imagePath'];
    windowHeight = json['windowHeight'];
    isHTML5 = json['isHTML5'];
    isKeyboard = json['isKeyboard'];
    gameCategory = json['gameCategory'];
    gameName = json['gameName'];
    gameNumber = json['gameNumber'];
    gameVersion = json['gameVersion'];
    gameDescription = json['gameDescription'];
    currencyCode = json['currencyCode'];
    windowWidth = json['windowWidth'];
    isFlash = json['isFlash'];
    status = json['status'];
    isImageGeneration = json['isImageGeneration'];
    isTablet = json['isTablet'];
    gameWinUpto = json['gameWinUpto'];
    jackpotStatus = json['jackpotStatus'];
    bonusMultiplier = json['bonusMultiplier'];
    setId = json['setId'];
    setName = json['setName'];
    betList = json['betList'].cast<int>();
    productInfo = json['productInfo'] != null
        ? new ProductInfo.fromJson(json['productInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.loaderImage != null) {
      data['loaderImage'] = this.loaderImage!.toJson();
    }
    if (this.prizeSchemes != null) {
      data['prizeSchemes'] = this.prizeSchemes!.toJson();
    }
    data['orderId'] = this.orderId;
    data['imagePath'] = this.imagePath;
    data['windowHeight'] = this.windowHeight;
    data['isHTML5'] = this.isHTML5;
    data['isKeyboard'] = this.isKeyboard;
    data['gameCategory'] = this.gameCategory;
    data['gameName'] = this.gameName;
    data['gameNumber'] = this.gameNumber;
    data['gameVersion'] = this.gameVersion;
    data['gameDescription'] = this.gameDescription;
    data['currencyCode'] = this.currencyCode;
    data['windowWidth'] = this.windowWidth;
    data['isFlash'] = this.isFlash;
    data['status'] = this.status;
    data['isImageGeneration'] = this.isImageGeneration;
    data['isTablet'] = this.isTablet;
    data['gameWinUpto'] = this.gameWinUpto;
    data['jackpotStatus'] = this.jackpotStatus;
    data['bonusMultiplier'] = this.bonusMultiplier;
    data['setId'] = this.setId;
    data['setName'] = this.setName;
    data['betList'] = this.betList;
    if (this.productInfo != null) {
      data['productInfo'] = this.productInfo!.toJson();
    }
    return data;
  }
}

class LoaderImage {
  String? s960;
  String? s1777;

  LoaderImage({this.s960, this.s1777});

  LoaderImage.fromJson(Map<String, dynamic> json) {
    s960 = json['960'];
    s1777 = json['1777'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['960'] = this.s960;
    data['1777'] = this.s1777;
    return data;
  }
}

class PrizeSchemes {
  int? i101;

  PrizeSchemes({this.i101});

  PrizeSchemes.fromJson(Map<String, dynamic> json) {
    i101 = json['101'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['101'] = this.i101;
    return data;
  }
}

class ProductInfo {
  List<Donation>? donation;

  ProductInfo({this.donation});

  ProductInfo.fromJson(Map<String, dynamic> json) {
    if (json['donation'] != null) {
      donation = <Donation>[];
      json['donation'].forEach((v) {
        donation!.add(new Donation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.donation != null) {
      data['donation'] = this.donation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Donation {
  String? image;
  String? title;

  Donation({this.image, this.title});

  Donation.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['title'] = this.title;
    return data;
  }
}

class Params {
  String? root;
  String? repo;
  String? merchantCode;
  int? merchantKey;
  String? secureKey;
  String? domainName;
  String? lang;
  List<String>? currencyCode;
  String? vendorType;

  Params(
      {this.root,
        this.repo,
        this.merchantCode,
        this.merchantKey,
        this.secureKey,
        this.domainName,
        this.lang,
        this.currencyCode,
        this.vendorType});

  Params.fromJson(Map<String, dynamic> json) {
    root = json['root'];
    repo = json['repo'];
    merchantCode = json['merchantCode'];
    merchantKey = json['merchantKey'];
    secureKey = json['secureKey'];
    domainName = json['domainName'];
    lang = json['lang'];
    currencyCode = json['currencyCode'].cast<String>();
    vendorType = json['vendorType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['root'] = this.root;
    data['repo'] = this.repo;
    data['merchantCode'] = this.merchantCode;
    data['merchantKey'] = this.merchantKey;
    data['secureKey'] = this.secureKey;
    data['domainName'] = this.domainName;
    data['lang'] = this.lang;
    data['currencyCode'] = this.currencyCode;
    data['vendorType'] = this.vendorType;
    return data;
  }
}
