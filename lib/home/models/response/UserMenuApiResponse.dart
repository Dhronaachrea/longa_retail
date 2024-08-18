class UserMenuApiResponse {
  int? responseCode;
  String? responseMessage;
  ResponseData? responseData;

  UserMenuApiResponse(
      {this.responseCode, this.responseMessage, this.responseData});

  UserMenuApiResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    responseData = json['responseData'] != null
        ? ResponseData.fromJson(json['responseData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    if (this.responseData != null) {
      data['responseData'] = this.responseData!.toJson();
    }
    return data;
  }
}

class ResponseData {
  List<ModuleBeanLst>? moduleBeanLst;
  int? statusCode;
  String? message;

  ResponseData({this.moduleBeanLst, this.statusCode, this.message});

  ResponseData.fromJson(Map<String, dynamic> json) {
    if (json['moduleBeanLst'] != null) {
      moduleBeanLst = <ModuleBeanLst>[];
      json['moduleBeanLst'].forEach((v) {
        moduleBeanLst!.add( ModuleBeanLst.fromJson(v));
      });
    }
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.moduleBeanLst != null) {
      data['moduleBeanLst'] =
          this.moduleBeanLst!.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class ModuleBeanLst {
  int? moduleId;
  String? moduleCode;
  int? sequence;
  String? displayName;
  List<MenuBeanList>? menuBeanList;

  ModuleBeanLst(
      {this.moduleId,
        this.moduleCode,
        this.sequence,
        this.displayName,
        this.menuBeanList});

  ModuleBeanLst.fromJson(Map<String, dynamic> json) {
    moduleId = json['moduleId'];
    moduleCode = json['moduleCode'];
    sequence = json['sequence'];
    displayName = json['displayName'];
    if (json['menuBeanList'] != null) {
      menuBeanList = <MenuBeanList>[];
      json['menuBeanList'].forEach((v) {
        menuBeanList!.add( MenuBeanList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['moduleId'] = this.moduleId;
    data['moduleCode'] = this.moduleCode;
    data['sequence'] = this.sequence;
    data['displayName'] = this.displayName;
    if (this.menuBeanList != null) {
      data['menuBeanList'] = this.menuBeanList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MenuBeanList {
  int? menuId;
  String? menuCode;
  String? caption;
  int? sequence;
  int? checkForPermissions;
  String? basePath;
  String? relativePath;
  String? apiDetails;
  List<String>? permissionCodeList;

  MenuBeanList(
      {this.menuId,
        this.menuCode,
        this.caption,
        this.sequence,
        this.checkForPermissions,
        this.basePath,
        this.relativePath,
        this.apiDetails,
        this.permissionCodeList});

  MenuBeanList.fromJson(Map<String, dynamic> json) {
    menuId = json['menuId'];
    menuCode = json['menuCode'];
    caption = json['caption'];
    sequence = json['sequence'];
    checkForPermissions = json['checkForPermissions'];
    basePath = json['basePath'];
    relativePath = json['relativePath'];
    apiDetails = json['apiDetails'];
    permissionCodeList = json['permissionCodeList'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['menuId'] = this.menuId;
    data['menuCode'] = this.menuCode;
    data['caption'] = this.caption;
    data['sequence'] = this.sequence;
    data['checkForPermissions'] = this.checkForPermissions;
    data['basePath'] = this.basePath;
    data['relativePath'] = this.relativePath;
    data['apiDetails'] = this.apiDetails;
    data['permissionCodeList'] = this.permissionCodeList;
    return data;
  }
}
