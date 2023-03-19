import 'package:elvtr/data/user_info_model_data.dart';
import 'package:elvtr/screen/edit_profile_screen.dart';
import 'package:elvtr/service/dashboard.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../common/utils_common.dart';

class ImageUploadController {

  final DashBoardService dashboardService = Get.find();


  getUserInfoDetailsForEditProfileByUserID() async {
  //  showLoadingDialog();
    final response = await dashboardService.getUserInfoByUserID();
    if(response != null) {
  //    removeDialog();
      print("Response Data :--- " + response.toJson().toString());
      Get.dialog(EditProfileScreen(userInfoDataModel: response));
    }
    else {
      return null;
    }
  }
}