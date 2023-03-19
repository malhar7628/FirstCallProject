import 'dart:io';
import 'dart:math';

import 'package:elvtr/common/api_common.dart';
import 'package:elvtr/common/utils_common.dart';
import 'package:elvtr/controller/edit_controller.dart';
import 'package:elvtr/controller/image_upload_controller.dart';
import 'package:elvtr/data/user_info_model_data.dart';
import 'package:elvtr/service/dashboard.service.dart';
import 'package:elvtr/service/network.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {

  static const name = "/editUserProfile";
  final UserInfoDataModel userInfoDataModel;
  const EditProfileScreen({Key? key, required this.userInfoDataModel}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final NetworkService networkService = Get.find();
  final DashBoardService _dashboardService = Get.find();
  EditController editController = EditController();

  late ImageUploadController _imageUploadController = ImageUploadController();

  ImageUploadController get imageUploadController => _imageUploadController;

  set imageUploadController(ImageUploadController imageUploadController) {
    _imageUploadController = imageUploadController;
  }

  File? firstImage;
  File? secondImage;
  String? imagePath1="";
  String? imagePath2="";
  String url="";


  Future uploadFirstPicture(ImageSource source) async {
    await _dashboardService.imagePicker
        .pickImage(source: source)
        .then((value) async {
      if (value != null) {
        showLoadingDialog();
        firstImage = File(value.path);
        setState(() {
        });
        showLoadingDialog();
        final response = await _dashboardService.uploadUserProfilePicByUserID(value);
        print("response 1:-"+response.toString());
        removeDialog();
        if(response != null) {
          print("response 1:-"+response.toString());
          showLoadingDialog();
          removeDialog();
          imagePath1 = response;
          removeDialog();
          print("response Image " + imagePath1.toString());

        }
      }
    }
    );
  }

  Future uploadSecondImage(ImageSource source) async {
    await _dashboardService.imagePicker
        .pickImage(source: source)
        .then((value) async {
      if (value != null) {
        showLoadingDialog();
        secondImage = File(value.path);
        setState(() {
        });
        showLoadingDialog();
        final response = await _dashboardService.uploadUserProfilePicByUserID(value);
        removeDialog();
        print("response 2:-"+response.toString());
        if(response != null) {
          print("response 2:-"+response.toString());
          showLoadingDialog();
          removeDialog();
          imagePath2 = response;
          removeDialog();
          print("response " + imagePath2.toString());
        }
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final quote = "${widget.userInfoDataModel.copyurl}";
    return GetX<EditController>(
      init: EditController(),
      builder: (_) {
        return Scaffold(

          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics:  const BouncingScrollPhysics(parent: NeverScrollableScrollPhysics()),
                  child: Column(
                    children: [
                      Container(
                        decoration:  BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              const Color(0x1E96CA).withOpacity(0.9),
                              const Color(0x1E96CA).withOpacity(0.9),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child:
                              Text("Profile",
                                textAlign: TextAlign.start,
                                style:  GoogleFonts.lato(
                                    fontWeight:  FontWeight.bold,
                                    fontSize: 25,
                                    color: Colors.white.withOpacity(.9)
                                ),).marginOnly(top: 10, left: 2, right: 40),),
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child:  Text("Fill the form below to change your profile details",
                                    textAlign: TextAlign.start,
                                    style:  GoogleFonts.lato(
                                        fontSize: 15,
                                        color: Colors.white.withOpacity(.9)
                                    ),).marginOnly(top: 4, left: 2, right: 30),),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: Get.height * 265 / 300,
                                      margin: const EdgeInsets.fromLTRB(2, 20, 2, 2),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Get.theme.cardColor.withOpacity(0.9),
                                          boxShadow: [
                                            BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 8.0)
                                          ],
                                          borderRadius:  const BorderRadius.only(topLeft:Radius.circular(20),topRight: Radius.circular(20))
                                      ),
                                      child: Center(
                                        child: Container(
                                          height: Get.height * 185 / 200,
                                          margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: Get.theme.cardColor.withOpacity(0.9),
                                              boxShadow: [
                                                BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 8.0)
                                              ],
                                              borderRadius:  const BorderRadius.only(
                                                  topLeft:Radius.circular(20),
                                                  topRight: Radius.circular(20),
                                                  bottomLeft: Radius.circular(20),
                                                  bottomRight: Radius.circular(20)
                                              )),
                                          child: Stack(
                                            children: [
                                              const SizedBox(height: 10),
                                              ListView(
                                                children: [
                                                  Center(
                                                      child: Container(
                                                        width: size.width * 10/5,
                                                        margin: EdgeInsets.only(
                                                          top: size.height* 1/700,
                                                        ),
                                                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 6),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(12)),
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Form(
                                                              key: _.formKey,
                                                              autovalidateMode: _.autovalidateMode,
                                                              child: Column(
                                                                children: [
                                                                  /* ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                          padding: const EdgeInsets.all(0.0),
                                                                          elevation: 1,
                                                                        ),
                                                                        onPressed: () {
                                                                       if (quote != null) {
                                                                       showToast("✓ Copied to Clipboard");
                                                                       }
                                                                        Clipboard.setData(ClipboardData(text: quote));

                                                                        },
                                                                        child: Ink(
                                                                          decoration: BoxDecoration(
                                                                            gradient: LinearGradient(colors: [  const Color(0x001e96ca).withOpacity(0.9),
                                                                              const Color(0x00007238).withOpacity(0.9),]),
                                                                            //   borderRadius: BorderRadius.circular(90),
                                                                          ),
                                                                          child: Container(
                                                                            padding: const EdgeInsets.all(10),
                                                                            constraints: const BoxConstraints(minWidth: 88.0),
                                                                            child: const Text('Copy Url', textAlign: TextAlign.center),
                                                                          ),
                                                                        ),
                                                                      ).marginOnly(top: 1, left: 200, right: 1, bottom:5),*/
                                                                  TextFormField(
                                                                    initialValue: widget.userInfoDataModel.userfname,
                                                                    onSaved: (value) {
                                                                      print("Value "+ "${value}");
                                                                      _.editProfileDataModel.userfname = value!.trim();
                                                                    },
                                                                    decoration:  InputDecoration(
                                                                        enabledBorder:  UnderlineInputBorder(
                                                                          borderSide: BorderSide(color:Color(0x3DC1E0).withOpacity(0.9),), //<-- SEE HERE
                                                                        ),
                                                                        label:  Text("First Name",
                                                                          style: GoogleFonts.lato(
                                                                            color: Get.theme.primaryColor,
                                                                          ),)
                                                                    ),
                                                                  ),
                                                                  TextFormField(
                                                                    initialValue: widget.userInfoDataModel.userlname,
                                                                    onSaved: (value) {
                                                                      print("Value "+ "${value}");
                                                                      _.editProfileDataModel.userlname = value!.trim();
                                                                    },
                                                                    decoration:  InputDecoration(
                                                                        enabledBorder:  UnderlineInputBorder(
                                                                          borderSide: BorderSide(color:Color(0x3DC1E0).withOpacity(0.9),), //<-- SEE HERE
                                                                        ),
                                                                        label:  Text("Last Name",
                                                                          style: GoogleFonts.lato(
                                                                            color: Get.theme.primaryColor,
                                                                          ),)
                                                                    ),
                                                                  ),
                                                                  TextFormField(
                                                                    initialValue: widget.userInfoDataModel.email,
                                                                    enabled: false,
                                                                    onSaved: (value) {
                                                                      print("Value "+ "${value}");
                                                                      _.editProfileDataModel.email = value!.trim();
                                                                    },
                                                                    decoration:  InputDecoration(enabledBorder:  UnderlineInputBorder(
                                                                      borderSide: BorderSide(color:Color(0x3DC1E0).withOpacity(0.9),), //<-- SEE HERE
                                                                    ),
                                                                        label:  Text("Email ID",style: GoogleFonts.lato(
                                                                          color: Get.theme.primaryColor,
                                                                        ),)
                                                                    ),
                                                                  ),
                                                                  TextFormField(
                                                                    textInputAction: TextInputAction.done,
                                                                    initialValue: widget.userInfoDataModel.mobilenumber,
                                                                    decoration:  InputDecoration(
                                                                        enabledBorder:  UnderlineInputBorder(
                                                                          borderSide: BorderSide(color:Color(0x3DC1E0).withOpacity(0.9),), //<-- SEE HERE
                                                                        ),
                                                                        label:  Text("Mobile Number",style: GoogleFonts.lato(
                                                                          color: Get.theme.primaryColor,
                                                                        ),)
                                                                    ),
                                                                    inputFormatters: [
                                                                      FilteringTextInputFormatter.singleLineFormatter,
                                                                      LengthLimitingTextInputFormatter(13),
                                                                      /*TextInputFormatter.withFunction((oldValue, newValue) {
                                                                            final text = '+1 ${newValue.text}';
                                                                            return text.length <= 13 ? newValue.copyWith(text: text) : oldValue;
                                                                          })*/
                                                                    ],
                                                                    validator: (value) {
                                                                      if (value!.trim().isEmpty) {
                                                                        return "Phone is required";
                                                                      } else if (value.trim().length != 13) {
                                                                        return "Enter a valid phone number";
                                                                      }
                                                                      return null;
                                                                    },
                                                                    onSaved: (value) {
                                                                      print("Value "+ "${value}");
                                                                      _.editProfileDataModel.mobilenumber = value!.trim();
                                                                    },
                                                                  ),
                                                                  const SizedBox(height: 25),

                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: const EdgeInsets.symmetric(),
                                                              child: Row(
/*                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment: MainAxisAlignment.center,*/
                                                                  children: [
                                                                    // Image 1
                                                                    Stack(
                                                                      children :[
                                                                        Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              width: 100,
                                                                              height: 100,
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(80),
                                                                                child: firstImage != null ? Image(image: Image.file(File("${firstImage?.path}").absolute)
                                                                                    .image) : Image(
                                                                                    image: Image.network
                                                                                      (getProfilePicUrl+networkService.userId!.toString()+"/1?"+Random().nextInt(100).toString()).image),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Positioned(
                                                                            bottom: 0,
                                                                            right: 0,
                                                                            child: GestureDetector(
                                                                              child: Container(
                                                                                width: 35,
                                                                                height: 35,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(100),
                                                                                  color: Colors.grey,
                                                                                ),
                                                                                child: const Icon(Icons.add_a_photo),
                                                                              ),
                                                                              onTap: () {
                                                                                showLoadingDialog();
                                                                                uploadFirstPicture(ImageSource.gallery);
                                                                                removeDialog();
                                                                              },
                                                                            )
                                                                        ),

                                                                      ],
                                                                    ),
                                                                    // Image 2
                                                                    const SizedBox(width: 70),
                                                                    Stack(
                                                                      children :[
                                                                        Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              width: 100,
                                                                              height: 100,
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(80),
                                                                                child: secondImage != null ? Image(image: Image.file(File("${secondImage?.path}").absolute)
                                                                                    .image) : Image(
                                                                                    image: Image.network(
                                                                                        getProfilePicUrl+networkService.userId!.toString()+"/2?"+Random().nextInt(100).toString()).image),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Positioned(
                                                                            bottom: 0,
                                                                            right: 0,
                                                                            child: GestureDetector(
                                                                              child: Container(
                                                                                width: 35,
                                                                                height: 35,
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.grey),
                                                                                child: const Icon(Icons.add_a_photo),
                                                                              ),
                                                                              onTap: () {
                                                                                uploadSecondImage(ImageSource.gallery);
                                                                              },
                                                                            )
                                                                        ),
                                                                        const SizedBox(width: 30),
                                                                      ],
                                                                    ),
                                                                  ]
                                                              ),
                                                            ),
                                                            Row(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                Text('Upload Image 1',
                                                                    textAlign: TextAlign.center,
                                                                    style: GoogleFonts.lato(
                                                                      color: Get.theme.primaryColor,
                                                                    )
                                                                ),
                                                                const SizedBox(height: 10),
                                                                Text('Upload Image 2',
                                                                    textAlign: TextAlign.center,
                                                                    style: GoogleFonts.lato(
                                                                      color: Get.theme.primaryColor,
                                                                    )
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(height: 40),
                                                            if (_dashboardService.selectedFile.value != null)
                                                              Text('Selected File: ${_dashboardService.pickedfile?.name}'),
                                                            const SizedBox(height: 5),
                                                            if(widget.userInfoDataModel.cvname != "null" && widget.userInfoDataModel.cvname != "")
                                                              Text('Uploaded File: ${widget.userInfoDataModel.cvname}'),
                                                            //   SizedBox(width: 150),
                                                            const SizedBox(height: 10),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                /* IconButton(onPressed: () {
                                                                    _.getSelectedFile();
                                                                    }, icon: Icon(Icons.attach_file)),*/
                                                                if(widget.userInfoDataModel.cvname == "")/*|| (_dashboardService.selectedFile.value).isBlank)*/
                                                                  ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      padding: const EdgeInsets.all(0.0),
                                                                      elevation: 5,
                                                                    ),
                                                                    onPressed: () {
                                                                      _.getSelectedFile();
                                                                    },
                                                                    child: Ink(
                                                                      decoration: BoxDecoration(

                                                                        gradient: LinearGradient(colors: [  const Color(0x001e96ca).withOpacity(0.9),
                                                                          const Color(0x00007238).withOpacity(0.9),]),
                                                                        //   borderRadius: BorderRadius.circular(90),
                                                                      ),
                                                                      child: Container(
                                                                        padding: const EdgeInsets.all(10),
                                                                        constraints: const BoxConstraints(minWidth: 88.0),
                                                                        child: const Text('Select CV', textAlign: TextAlign.center),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                if(widget.userInfoDataModel.cvname != "")
                                                                  ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      padding: const EdgeInsets.all(0.0),
                                                                      elevation: 5,
                                                                    ),
                                                                    onPressed: () {
                                                                      _.getSelectedFile();
                                                                    },
                                                                    child: Ink(
                                                                      decoration: BoxDecoration(

                                                                        gradient: LinearGradient(colors: [  const Color(0x001e96ca).withOpacity(0.9),
                                                                          const Color(0x00007238).withOpacity(0.9),]),
                                                                        //   borderRadius: BorderRadius.circular(90),
                                                                      ),
                                                                      child: Container(
                                                                        padding: const EdgeInsets.all(10),
                                                                        constraints: const BoxConstraints(minWidth: 88.0),
                                                                        child: const Text('Update CV', textAlign: TextAlign.center),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                if (_dashboardService.selectedFile.value != null)
                                                                  Container(
                                                                    child: ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                        padding: const EdgeInsets.all(0.0),
                                                                        elevation: 5,
                                                                      ),
                                                                      onPressed: () {
                                                                        _.uploadSelectedFile();
                                                                      },
                                                                      child: Ink(
                                                                        decoration: BoxDecoration(

                                                                          gradient: LinearGradient(colors: [  const Color(0x001e96ca).withOpacity(0.9),
                                                                            const Color(0x00007238).withOpacity(0.9),]),
                                                                          //   borderRadius: BorderRadius.circular(90),
                                                                        ),
                                                                        child: Container(
                                                                          padding: const EdgeInsets.all(10),
                                                                          constraints: const BoxConstraints(minWidth: 88.0),
                                                                          child: const Text('Upload CV', textAlign: TextAlign.center),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                // if(widget.userInfoDataModel.cvname == null)
                                                              ],
                                                            ),
                                                            const SizedBox(width: 30),
                                                            const SizedBox(height: 13),
                                                            Row(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    padding: const EdgeInsets.all(0.0),
                                                                    elevation: 5,
                                                                  ),
                                                                  onPressed: () {
                                                                    Get.back();
                                                                  },
                                                                  child: Ink(
                                                                    decoration: BoxDecoration(
                                                                      gradient: LinearGradient(colors: [  const Color(0x001e96ca).withOpacity(0.9),
                                                                        const Color(0x00007238).withOpacity(0.9),]),
                                                                      //   borderRadius: BorderRadius.circular(90),
                                                                    ),
                                                                    child: Container(
                                                                      padding: const EdgeInsets.all(10),
                                                                      constraints: const BoxConstraints(minWidth: 88.0),
                                                                      child: const Text('Cancel', textAlign: TextAlign.center),
                                                                    ),
                                                                  ),
                                                                ),
                                                                //   const SizedBox(height: 5),
                                                                // ElevatedButton(
                                                                //     onPressed: () {
                                                                //       _.editUserProfile(imagePath1, imagePath2,
                                                                //       widget.userInfoDataModel.image1name, widget.userInfoDataModel.image2name);
                                                                //     },
                                                                //     child: const Text(
                                                                //         "SAVE",
                                                                //         style: TextStyle(fontSize: 10))
                                                                // ),
                                                                ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    padding: const EdgeInsets.all(0.0),
                                                                    elevation: 5,
                                                                  ),
                                                                  onPressed: () {
                                                                    _.editUserProfile(imagePath1, imagePath2,
                                                                        widget.userInfoDataModel.image1name, widget.userInfoDataModel.image2name,
                                                                        _.selectedFile, widget.userInfoDataModel.cvname);
                                                                    print("Check Name:-"+"${_.selectedFile}");
                                                                  },
                                                                  child: Ink(
                                                                    decoration: BoxDecoration(

                                                                      gradient: LinearGradient(colors: [  const Color(0x001e96ca).withOpacity(0.9),
                                                                        const Color(0x00007238).withOpacity(0.9),]),
                                                                      //   borderRadius: BorderRadius.circular(90),
                                                                    ),
                                                                    child: Container(
                                                                      padding: const EdgeInsets.all(10),
                                                                      constraints: const BoxConstraints(minWidth: 88.0),
                                                                      child: const Text('Submit', textAlign: TextAlign.center),
                                                                    ),
                                                                  ),
                                                                ),
                                                                /*ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    padding: const EdgeInsets.all(0.0),
                                                                    elevation: 5,
                                                                  ),
                                                                  onPressed: () {
                                                                    widget.userInfoDataModel.cv;
                                                                    print("Check Name:-"+"${widget.userInfoDataModel.cv}");
                                                                  },
                                                                  child: Ink(
                                                                    decoration: BoxDecoration(

                                                                      gradient: LinearGradient(colors: [  const Color(0x001e96ca).withOpacity(0.9),
                                                                        const Color(0x00007238).withOpacity(0.9),]),
                                                                      //   borderRadius: BorderRadius.circular(90),
                                                                    ),
                                                                    child: Container(
                                                                      padding: const EdgeInsets.all(10),
                                                                      constraints: const BoxConstraints(minWidth: 88.0),
                                                                      child: const Text('downloadcv', textAlign: TextAlign.center),
                                                                    ),
                                                                  ),
                                                                ),*/
                                                              ],
                                                            ),
                                                            Container(
                                                              padding: const EdgeInsets.all(10),
                                                              constraints: const BoxConstraints(minWidth: 88.0),
                                                              child:  Text('You can access your profile from the web browser.Please use the web browser to enrich your profile',
                                                                  textAlign: TextAlign.center,
                                                                  style: GoogleFonts.lato(
                                                                    color: Get.theme.primaryColor,
                                                                  )
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                  )
                                                ],

                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
