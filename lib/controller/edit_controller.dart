import 'dart:io';
import 'dart:math';

import 'package:elvtr/common/utils_common.dart';
import 'package:elvtr/controller/image_upload_controller.dart';
import 'package:elvtr/data/user_info_doc_data.dart';
import 'package:elvtr/model/edit_profile_model.dart';
import 'package:elvtr/screen/dashboard.screen.dart';
import 'package:elvtr/screen/dashboard_aftershowcase_screen.dart';
import 'package:elvtr/screen/edit_profile_screen.dart';
import 'package:elvtr/screen/edit_user_profile_screen.dart';
import 'package:elvtr/screen/onboard_dope_screen.dart';
import 'package:elvtr/screen/sign_in.screen.dart';
import 'package:elvtr/service/auth.service.dart';
import 'package:elvtr/service/dashboard.service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../common/api_common.dart';
import '../screen/blankPage_screen.dart';
import '../service/network.service.dart';


class EditController extends GetxController {

  final DashBoardService _dashBoardService = Get.find();
  final AuthService _authService = Get.find();
  final NetworkService networkService = Get.find();
  final formKey = GlobalKey<FormState>();

  final _autovalidateMode = AutovalidateMode.disabled.obs;

  AutovalidateMode get autovalidateMode => _autovalidateMode.value;
  set autovalidateMode(AutovalidateMode value) =>
      _autovalidateMode.value = value;

  File? uploadedImage;
  File? secondImage;
  String? imagePath1="";
  String? imagePath2="";
  String url="";

  @override
  void onInit() {
    super.onInit();
  }

  Future uploadFirstPicture(ImageSource source) async {
    await _dashBoardService.imagePicker
        .pickImage(source: source)
        .then((value) async {
      if (value != null) {
        uploadedImage = File(value.path);
        //   image.getUserInfoDetailsForEditProfileByUserID();
        final response = await _dashBoardService.uploadUserProfilePicByUserID(value);
        if(response != null) {
          imagePath1 = response;
        }
      }
    }
    );
  }

  getUserInfoDetailsForEditProfileByUserID() async {
//    showLoadingDialog();
    final response = await _dashBoardService.getUserInfoByUserID();
    if(response != null) {
      //    removeDialog();
      print("Response Data :--- " + response.toJson().toString());
      Get.dialog(EditUserProfileScreen(userInfoDataModel: response));
    }
    else {
      return null;
    }
  }

  UserInfoDocumentData userInfoDocumentData = UserInfoDocumentData();
  uploadUserCVAndProfile(String? cvName, String? image1,String? image2) async {
    userInfoDocumentData.id = networkService.userId;
    userInfoDocumentData.cv = cvName;
    userInfoDocumentData.image1 = image1;
    userInfoDocumentData.image2 = image2;
    print("USer Info Document Data Model " + "${userInfoDocumentData.id}");
    print("USer Info Document Data Model " + "${userInfoDocumentData.cv}");
    print("USer Info Document Data Model " + "${userInfoDocumentData.image2}");
    final response = await _authService.uploadUserDocumentsAfterRegistration(userInfoDocumentData);
    if(response != null) {
      print("Response Data :--- " + response.toString());
      await showAlertDialog(
          title: "Success",
          content: "Full Registration Now Successful.");
      Get.offAll(const SignInScreen());
    }
    else {
      return null;
    }
  }

  /*EditProfileModel editProfileDataModel = EditProfileModel();

   editUserProfile(String? imagePath1, String? imagePath2, String? firstImgName, String? secondImgName,
       String? uploadedFile, String? existingCVName) async {

      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
      } else {
        autovalidateMode = AutovalidateMode.onUserInteraction;
        return;
      }

      if(imagePath1 != null) {
        print("Hiii");
        editProfileDataModel.image1 = imagePath1;
      }
      else {
        editProfileDataModel.image1 = firstImgName;
      }

      if(imagePath2 != null) {
        print("Hiii Edit");
        editProfileDataModel.image2 = imagePath2;
      }
      else {
        editProfileDataModel.image2 = secondImgName;
      }

      print( " firstImgName ==== 1111=====" + firstImgName.toString());
      print("imagePath1==== 1111=====" +imagePath1.toString());
      print("imagePath2==== 1111=====" +imagePath2.toString());

      *//*if(firstImgName != null && imagePath1.toString().isEmpty) {
        print("Hiii 2" );
        editProfileDataModel.image1 = firstImgName;
      }
      else {
        editProfileDataModel.image2 = imagePath2;
      }*//*
      if (imagePath1 != null && imagePath1.isNotEmpty) {
        editProfileDataModel.image1 = imagePath1;
      } else if (firstImgName != null) {
        editProfileDataModel.image1 = firstImgName;
      }

      print("editProfileDataModel==== 111=====" +editProfileDataModel.toJson().toString());
      print( " firstImgName ==== 222=====" + secondImgName.toString());
      print("imagePath1==== 222=====" +imagePath1.toString());
      print("imagePath2==== 222=====" +imagePath2.toString());

      if (imagePath2 != null && imagePath2.isNotEmpty) {
        editProfileDataModel.image2 = imagePath2;
      } else if (secondImgName != null) {
        editProfileDataModel.image2 = secondImgName;
      }
      *//*if(secondImgName != null && imagePath2.toString().isEmpty) {
        print("Hiii 3");
        editProfileDataModel.image2 = secondImgName;
      }
      else {
        editProfileDataModel.image1 = imagePath1;
      }*//*
      print( " CV ==== 222=====" + uploadedFile.toString());

      print( " CV Uploaded File" + uploadedFile.toString());
   //   print( " CV Existing Name" + existingCVName.toString());

      if(uploadedFile.toString().isNotEmpty) {
        editProfileDataModel.cv = uploadedFile;
      }
      if(existingCVName.toString().isNotEmpty && uploadedFile.toString().trim().isEmpty) {
        editProfileDataModel.cv = existingCVName;
      }*/
// updated code
  EditProfileModel editProfileDataModel = EditProfileModel();

  editUserProfile(String? imagePath1, String? imagePath2, String? firstImgName, String? secondImgName,
      String? uploadedFile, String? existingCVName) async {

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
    } else {
      autovalidateMode = AutovalidateMode.onUserInteraction;
      return;
    }

    if(imagePath1 != null) {
      print("Hiii");
      editProfileDataModel.image1 = imagePath1;
    }
    else {
      editProfileDataModel.image1 = firstImgName;
    }

    if(imagePath2 != null) {
      print("Hiii Edit");
      editProfileDataModel.image2 = imagePath2;
    }
    else {
      editProfileDataModel.image2 = secondImgName;
    }

    if (imagePath1 != null && imagePath1.isNotEmpty) {
      editProfileDataModel.image1 = imagePath1;
    } else if (firstImgName != null) {
      editProfileDataModel.image1 = firstImgName;
    }

    if (imagePath2 != null && imagePath2.isNotEmpty) {
      editProfileDataModel.image2 = imagePath2;
    } else if (secondImgName != null) {
      editProfileDataModel.image2 = secondImgName;
    }

    if(uploadedFile != null && uploadedFile.isNotEmpty) {
      editProfileDataModel.cv = uploadedFile;
    }
    if(existingCVName != null && existingCVName.isNotEmpty && uploadedFile.toString().trim().isEmpty) {
      editProfileDataModel.cv = existingCVName;
    }

    print("editProfileDataModel==== 222=====" +editProfileDataModel.toJson().toString());

    showLoadingDialog();
    final response = await _dashBoardService.editUserProfileByUserID(editProfileDataModel);
    if(response != false) {
      removeDialog();
      showToast("Profile Edited Successfully");
      print(networkService.auditionCountCheck);
      String count="0";
      if(networkService.auditionCountCheck.toString().compareTo(count) == true) {
        Get.offAll(() => const OnBoardDopeScreen());
      }
      else {
        Get.offAll(() => const DashboardScreenPostShowCase());
      }

      return true;
    }
    return true;
  }

  getSelectedFile() async {
    showLoadingDialog();
    final response = await _dashBoardService.pickFile();
    if(response !=null){
      print("Check 1");
      removeDialog();
      showToast("File is ready Please upload");
      //  return true;
    }else{
      print("Check 2");
      removeDialog();
      Get.back();
    }
    return response;
  }
  String? selectedFile = "";
  uploadSelectedFile()  async {
    showLoadingDialog();
    final response =  await _dashBoardService.uploadFile();
    if(response !=null) {
      removeDialog();
      //  showLoadingDialog();
      showToast(response+"File is Uploaded Please submit");
      //   showToast("If Completed with the Edit Profile Screen Please proceed to press Submit to Complete the process");
      selectedFile = response;
      print("signup:-$selectedFile$response");
      return selectedFile;
    }else{
      removeDialog();
      showToast("No File Present");

    }
  }

  String? resumeforregister = "";
  uploadSeletcedFileForRegister()  async{
    showLoadingDialog();
    final response =  await _dashBoardService.uploadFileForRegister();
    if(response !=null) {
      removeDialog();
      //  showLoadingDialog();
      showToast(response+"File is Uploaded Please submit");
      //   showToast("If Completed with the Edit Profile Screen Please proceed to press Submit to Complete the process");
      selectedFile = response;
    }else{
      removeDialog();
      showToast("No File Present");

    }

  }
  String? sendcvname = "";
  Future uploadcvwithAuditionId(String id, String cvname) async{
    showLoadingDialog();
    final response = await _dashBoardService.cvwithAudtionID(id, cvname);
    print("Checkresponsecvaud:-"+"${response?.cvname}");
    if(response != null) {
      removeDialog();

    }else{
      removeDialog();
      showToast("File is Uploaded ");
      sendcvname = response.toString();
      print("Check response cv aud:-$response");
      Get.to(BalnkPage());
      final confirm1 = await showConfirmationDialogAfterSucessRecord(title: '  Video Uploaded Successfully', content: '');
      if (!(confirm1 ?? false)) {
        return ;
      }
      Get.to(DashboardScreenPostShowCase());
    }
  }

}