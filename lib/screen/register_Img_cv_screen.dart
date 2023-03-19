import 'dart:io';
import 'package:elvtr/common/utils_common.dart';
import 'package:elvtr/controller/edit_controller.dart';
import 'package:elvtr/controller/image_upload_controller.dart';
import 'package:elvtr/screen/dashboard_aftershowcase_screen.dart';
import 'package:elvtr/screen/sign_in.screen.dart';
import 'package:elvtr/service/dashboard.service.dart';
import 'package:elvtr/service/network.service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class RegisterCVImage extends StatefulWidget {

  static const name = "/addCVAndImage";
  const RegisterCVImage({Key? key}) : super(key: key);

  @override
  State<RegisterCVImage> createState() => _RegisterCVImageState();
}

class _RegisterCVImageState extends State<RegisterCVImage> {

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
  String? Checkid = "";
  String? CheckcvName= "";
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                              Text("CV Upload ",
                                textAlign: TextAlign.start,
                                style:  GoogleFonts.lato(
                                    fontWeight:  FontWeight.bold,
                                    fontSize: 25,
                                    color: Colors.white.withOpacity(.9)
                                ),).marginOnly(top: 25, left: 2, right: 40),),
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child:  Text("Please Upload New Cv File ",
                                    textAlign: TextAlign.start,
                                    style:  GoogleFonts.lato(
                                        fontSize: 15,
                                        color: Colors.white.withOpacity(.9)
                                    ),).marginOnly(top: 10, left: 2, right: 30),),
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
                                                  TextButton.icon(
                                                      onPressed: (){
                                                        Get.offNamed(SignInScreen.name);
                                                      },
                                                      label:Text("Skip",style: GoogleFonts.lato(color: Colors.black,),),
                                                    icon: Icon(Icons.skip_next),
                                                  ).marginOnly(top: 1, left: 250, right: 1),
                                                  Center(
                                                      child: Container(
                                                        width: size.width * 10/5,
                                                        margin: EdgeInsets.only(
                                                          top: size.height* 10/700,
                                                        ),
                                                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 6),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(12)),
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            const SizedBox(height: 40),
                                                            /*if (_dashboardService.selectedFile.value != null)
                                                              Text('Selected File: ${_dashboardService.pickedfile?.name}'),*/
                                                            const SizedBox(height: 5),
                                                            const SizedBox(height: 10),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                              /*  IconButton(onPressed: () {
                                                                  _.getSelectedFile();
                                                                }, icon: Icon(Icons.attach_file)),*/
                                                                Container(
                                                                  child: ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      padding: const EdgeInsets.all(0.0),
                                                                      elevation: 5,
                                                                    ),
                                                                    onPressed: () async {
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
                                                                ),
                                                                if (_dashboardService.selectedFile.value != null)
                                                                Container(
                                                                  child: ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      padding: const EdgeInsets.all(0.0),
                                                                      elevation: 5,
                                                                    ),
                                                                    onPressed: () async {
                                                                    //  _.uploadSelectedFile();
                                                                      final response1 = await _dashboardService.uploadFile();
                                                                      CheckcvName = "${response1}";
                                                                      print("Check CV Name  $response1");
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
                                                              ],
                                                            ),
                                                            const SizedBox(width: 30),
                                                            const SizedBox(height: 30),
                                                            Container(
                                                              padding: const EdgeInsets.symmetric(),
                                                              child: Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                                                                      .image) : Image(image: Image.file(File("${firstImage?.path}").absolute)
                                                                                      .image)
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
                                                                                      .image) : Image(image: Image.file(File("${secondImage?.path}").absolute)
                                                                                      .image)
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
                                                            const SizedBox(height : 20),
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
                                                            const SizedBox(height : 10),
                                                            const SizedBox(height : 10),
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
                                                                    Get.to(DashboardScreenPostShowCase());
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
                                                                const SizedBox(height: 10),
                                                                ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    padding: const EdgeInsets.all(0.0),
                                                                    elevation: 5,
                                                                  ),
                                                                  onPressed: () {
                                                                    _.uploadUserCVAndProfile("${CheckcvName}", imagePath1, imagePath2);
                                                                    print("Check Id:-"+"${CheckcvName}");
                                                                    print("Check Name:-"+"${_.imagePath1}");
                                                                    print("Check Name:-"+"${_.imagePath2}");
                                                                   /* _.uploadcvwithAuditionId("${Checkid}", "${_.resume}"); */
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
                                                              ],
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
