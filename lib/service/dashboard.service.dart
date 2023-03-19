import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:elvtr/common/api_common.dart';
import 'package:elvtr/controller/showvideo.controller.dart';
import 'package:elvtr/data/user_info_model_data.dart';
import 'package:elvtr/model/edit_profile_model.dart';
import 'package:elvtr/service/network.service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart' as io;
import 'dart:convert';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import '../common/utils_common.dart';
import '../data/cvwithaudtionid.data.dart';
import '../model/jobRole.data.dart';
import '../data/videolist.data.dart';
import '../model/transaction.model.dart';

class DashBoardService extends GetxService {
  final NetworkService _networkService = Get.find();
  late VideoPlayerController videoPlayerController;
  ShowVideoController? ssc;
  ChewieController? chewieController;

  //File? videoFile;
  ImagePicker imagePicker = ImagePicker();

  final _loading = false.obs;
  set loading(value) => _loading.value = value;
  bool get loading => _loading.value;

  String? get vehicleNumber => _networkService.jobrole;
  set vehicleNumber(String? value) => _networkService.jobrole = value;

  Future<List<JobRoleUserModel>?> getJobRole() async {
    String? ab = _networkService.accessToken;
    try {
      //final phone = _networkService.userPhone;
      final response = await _networkService.dio.get(jobRoleUrl,options: Options(/*contentType: Headers.jsonContentType*/
        headers: {
          "Content-Type": "application/json"
        },
      ));
      print(response.data['payload']);
      print(jobRoleFromJson(jsonEncode(response.data['payload'])));
      return jobRoleFromJson(jsonEncode(response.data['payload']));
    } catch (e) {
      print("121");
      return null;
    }
  }
  String? valueid = "";
  var trim = "";
  Future<List<VideoList>?> previewVideo(XFile video, String aid/*, String cid*/) async {
    String url = addAuditionVideoUrl;
    final user = _networkService.userId;
    String? ab = _networkService.accessToken;
    /*print("Hell0 cid:-"+cid);*/

    print(video.path);

    var formData = FormData.fromMap({
      'auditionID': aid,
      'userID': user,
      'file': await MultipartFile.fromFile(video.path,
          contentType: MediaType("video", "mp4")),
    });

    try {
      showVideoLoadingDialog();
//      showToast("Response not shared");
      print("Hiii Before Response here");

      final response = await _networkService.dio.post(url, data: formData, options: Options(
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $ab"
        },
      ));
      print("Hiii Response here");

      if (response.statusCode == 200) {
        removeDialog();
        print("Hiii Response here after status code 200");
        showVideoLoadingDialog();
        print("check response$response");
        //getCompress(video);
        //print(buildVideoCompress());
        //Get.offAll(() => const AccountScreen());
        //   Get.offAllNamed(DashboardScreenPostShowCase.name);
        //ssc?.getVideo();
        valueid = "${response.data["payload"]}";
        valueid =  "${valueid?.replaceAll("{id:", "")}";
        valueid =  "${valueid?.replaceAll("}", "")}";
        valueid = "${valueid?.trim()}";
        //     trim =  "${valueid?.replaceAll("}", "")}";
        print("Check trimid:-$trim");
        print("Check valueid:-$valueid");
        //   showToast("Video Sent Successfully");
        await getUserAuditionVideo();
        removeDialog();
        return response.data["respData"];
      }
    } on DioError catch (e) {
      if (e.response?.data != null) {
        //      showToast("${e.response?.data["errors"]?["message"]}");
        showToast("Audition ID is " + aid);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  /* Future<MediaInfo?> getCompress(XFile video) async {
    final s = VideoCompress.compressVideo(
      video.path,
      quality: VideoQuality.HighestQuality,
      includeAudio: true,
      frameRate: 30
    );
      print(s);
      try {
      await VideoCompress.setLogLevel(0);
      print(s);
      return s;
    } catch (e) {
        showLoadingDialog();
      VideoCompress.cancelCompression();
    }
  }*/

  // User Audition Video List API with category ID
  Future<List<ShowVideoModel>?> getVideoApi() async {
    String url = showVideo;
    final phone = _networkService.userId;
    String? ab = _networkService.accessToken;
    print("userid:-"+phone!);
    url = url + phone;
    try {
      print(url);
      final response = await _networkService.dio.get(url,options: Options(
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader:  "Bearer $ab"
        },
      ));
      print(response.data);
      return showVideoModelFromJson(jsonEncode(response.data["payload"]));
    } catch (e) {
      return null;
    }
  }


  // Upload Profile Picture for User Profile
  Future<String?> uploadUserProfilePicByUserID(XFile uploadedImage) async {
    String url = uploadUserProfilePicUrl;
    final userID = _networkService.userId;
    String? ab = _networkService.accessToken;
    print("User ID :----- " + userID!);
    print("URL of uploadUserProfilePicByUserID:----- " + url);
    print("Path of Image :---- " + uploadedImage.path);

    var formData = FormData.fromMap({
      'uid': userID,
      'file': await MultipartFile.fromFile(uploadedImage.path,
          contentType: MediaType("uploadedImage", "jpg/png")),
    });
    try{
      // showLoadingDialog();
      final response = await _networkService.dio.post(url, data: formData,options: Options(
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader:  "Bearer $ab"
        },
      ));
      //   removeDialog();
      showToast("Profile Picture Uploaded Successfully !!!");
      //   Get.offAllNamed(EditProfileScreen.name);
      return response.data["payload"];

    }
    on DioError catch (e) {
      if (e.response?.data != null) {
        showToast("${e.response?.data["errors"]?["message"]}");
      }
    }
    catch (e) {
      return null;
    }
    return null;
  }




  String? getImagePath(String profileImagePath) {
    print("Image Path :---$profileImagePath");
    return profileImagePath;
  }

  // Get Uploaded Profile Image By User ID and Image ID
  Future<File?> getUploadedProfileImageByUserIDAndImageID() async {
    String url = getUploadedUserProfilePicUrl;
    final userID = _networkService.userId;
    String? ab = _networkService.accessToken;
    print("User ID :------ "+userID!);
    url = url + userID + "/1";
    print("URL for getUploadedProfileImageByUserIDAndImageID :-- " + url);
    try {
      final response = await _networkService.dio.get(url,options: Options(
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader:  "Bearer $ab"
        },
      ));
      print(response.data);
      if(response.statusCode == 200) {
        return response.data;
      }
    }
    on DioError catch (e) {
      e.printInfo();
      if (e.response?.data != null) {
        showToast("${e.response?.data["errors"]?["message"]}");
      }
    }
    catch (e) {
      e.printInfo();
      return null;
    }
  }

  // Get User Info For Edit Profile By User ID
  Future<UserInfoDataModel?> getUserInfoByUserID() async {
    String url = getUserInfoDetailsByUserIDUrl;
    final userID = _networkService.userId;
    String? ab = _networkService.accessToken;
    print("User ID :------ "+userID!);
    url = url + userID;
    try {
      print(url);
       showLoadingDialog();
      final response = await _networkService.dio.get(url,
          options: Options(
            headers: {
              "Content-Type": "application/json",
              HttpHeaders.authorizationHeader:  "Bearer $ab"
            },
          ));
      if(response.statusCode == 200) {
            removeDialog();
        print(response.data);
        print(jsonEncode(response.data["payload"]));
        print(jsonEncode(response.data["payload"]));
        return userInfoDataModelFromJson(jsonEncode(response.data["payload"]));
      }

    } catch (e) {
      e.printInfo();
      return null;
    }
  }

  // Edit User Profile on Save Button
  Future<bool?> editUserProfileByUserID(EditProfileModel editProfileDataModel) async {
    String? ab = _networkService.accessToken;
    try {
      editProfileDataModel.email = _networkService.userEmail;
      final data = editProfileDataModel.toJson();
      print("Edit Up Data :- " + data.toString());
      String url = editUserProfileUrl;
      print("URL editUserProfileUrl:----- " + url);
      print("accessToken:-"+ab.toString());
      final response = await _networkService.dio.post(url, data: data,
          options: Options(
            headers: {
              "Content-Type": "application/json",
              HttpHeaders.authorizationHeader:  "Bearer $ab"
            },
          ));
      print("Data :---- " +response.data);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioError catch (e) {
      if (e.response?.data != null) {
        showToast("${e.response?.data["errors"]?["message"]}");
      }
      return null;
    } catch (e) {
      e.printInfo();
      return null;
    }
  }


  /*void pickFile() async {
    final file = await FilePicker.platform.pickFiles();
    if (file != null) {
      selectedFile.value = File(file.files.single.path!);
      selectedFileName.value = path.basename(selectedFile.value!.path);
    }
  }*/
  Rx<File?> selectedFile = Rx<File?>(null);
  PlatformFile? pickedfile ;
  RxString selectedFileName = ''.obs;

  Future<FilePickerResult?> pickFile() async {
    //  final file = await FilePicker.platform.pickFiles();
    final file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf','docx'],
        allowMultiple: false
    );
    showLoadingDialog();
    if (file != null) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${Uri.file(file.files.single.path!).pathSegments.last}';
      pickedfile = file.files.first;
      print("Filename:-$file");
      final newFile = await File(file.files.single.path!).copy(filePath);
      selectedFile.value = newFile;
      selectedFileName.value = Uri.file(newFile.path).pathSegments.last;
      //   selectedFileName.value = path.basename(selectedFile.value!.path);
      removeDialog();
    }
    return file;
  }
  String? cvfile = "";
  Future<String?> uploadFile() async {
    String url = uploadCVUrl;
    final userID = _networkService.userId;
    print("User ID :-----" + userID!);
    //  url = url + userID;
    print("UploadCV:-$url");
    if (selectedFile.value == null) {
      return null;
    }
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(selectedFile.value!.path),
        'uid': userID,
      });
      print("formData:-"+formData.toString());
      showLoadingDialog();
      final response = await  _networkService.dio.post(url, data: formData,);
      print("User ID 33 :-----" + "${selectedFile.value = null}");
      print("User ID 2 :-----" + "${selectedFileName.value = ''}");
      selectedFile.value = null;
      selectedFileName.value = '';
      if (response.statusCode == 200) {
        removeDialog();
        print("Hiii Response here after status code 200");
        showLoadingDialog();
        print(response);
        removeDialog();
        cvfile = response.data["payload"];
        print("Check cvfile:-$cvfile");
        return response.data["payload"];
      }
      print(response.data);
    } on DioError catch (e) {
      if (e.response?.data != null) {
        showToast("${e.response?.data["errors"]?["message"]}");
      }
      return null;
    } catch (e) {
      e.printInfo();
    }
  }
  String? cvfileregister = "";
  Future<String?> uploadFileForRegister() async {
    String url = uploadCVUrl;
    final userID = _networkService.userId;
    // print("User ID :----- " + userID!);
    //  url = url + userID;
    print("UploadCV:-$url");
    if (selectedFile.value == null) {
      return null;
    }
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(selectedFile.value!.path),
        'uid': userID,
      });
      print("formData:-"+formData.toString());
      showLoadingDialog();
      final response = await  _networkService.dio.post(url, data: formData,);
      if (response.statusCode == 200) {
        removeDialog();
        print("Hiii Response here after status code 200");
        showLoadingDialog();
        print(response);
        removeDialog();
        cvfile = response.data["payload"];
        print("Check cvfile:-$cvfile");
        return response.data["payload"];
      }
      print(response.data);
    } on DioError catch (e) {
      if (e.response?.data != null) {
        showToast("${e.response?.data["errors"]?["message"]}");
      }
      return null;
    } catch (e) {
      e.printInfo();
    }
  }
  List elements = [];
  var videoList = <ShowVideoModel>[].obs;
  // API without category ID
  Future<List<ShowVideoModel>?> getUserAuditionVideo() async {
    String url = showUserAuditionListUrl;
    final userID = _networkService.userId;
    print("User ID :----- " + userID!);
    url = url + userID;
    String? ab = _networkService.accessToken;
    try{
      print(url);
      print("Object Token:-${_networkService.accessToken}");
      final response = await _networkService.dio.get(url,options: Options(
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader:  "Bearer $ab"
        },
      ));
      print(response.data);
      elements = response.data["payload"];
      print("Element " +elements.toString());
      videoList.value = showVideoModelFromJson(jsonEncode(response.data["payload"]));
      return videoList;
    }
    on DioError catch (e) {
      if (e.response?.data != null) {
        showToast("${e.response?.data["errors"]?["message"]}");
      }
    }
    catch (e) {
      return null;
    }
  }


  Future<List<VideoList>?> getVideoListApi() async {
    String url = InterviewQuestionCategorgyUrl;
    print(url);
    try {
      final response = await _networkService.dio.get(url, options: Options(
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${_networkService.accessToken}"
        },
      ));
      return VideoListFromJson(jsonEncode(response.data["payload"]));
    } catch (e) {
      return null;
    }
  }

  Future<bool?> deleteVideoApi(String unid) async {
    String url = DeleteVideoUrl;
    url = url + unid;
    try {
      print(url);
      final response = await _networkService.dio.put(url);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<bool?> CopylinkApi(String copyUrl, String unId) async {
    String url = copyLinkUrl;
    url = url + unId;
    try {
      print(url);
      final response = await _networkService.dio.get(url);
      if (response.statusCode == 200) {
        //print(response.data["payload"]);
        return response.data["payload"];
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<bool?> shareStatusApi(String unid) async {
    String url = shareStatusUrl;
    //   final phone = _networkService.userId;
    // url = "$url${phone.toString()}${"/"}${id}";
    url = url+unid;
    print(url);
    try {
      final response = await _networkService.dio.put(url);
      if (response.statusCode == 200) {
        //  print(response.data["payload"]);
        return response.data["payload"];
      }
    }
    catch (e) {
      return null;
    }
  }

  Future<bool?> verifyAuditionID(String auditionID) async {
    String url = verifyAuditionIDAndDeadlineUrl;
    url="$url${auditionID}";
    String? ab = _networkService.accessToken;
    print("URL For verify Audition ID :---" + url.toString());
    try{
      print("TOKEN:-"+ab.toString());
      final response = await _networkService.dio.get(url,
          options: Options(
            headers: {
              "Content-Type": "application/json",
              HttpHeaders.authorizationHeader:  "Bearer $ab"
            },
          ));
      if(response.statusCode == 200) {
        return response.data["payload"];
      }
    }
    on DioError catch (e) {
      if (e.response?.data != null) {
        showToast("${e.response?.data["errors"]?["message"]}");
      }
    }
    catch(e) {
      return null;
    }
    return null;
  }

  Future<CvwithaudtionId?> cvwithAudtionID(String id, String cvname) async{
    String url = CvWithAuditionIdUrl;
    var body = {"id": id, "cvname": cvname};
    print("Check Body:-$body");
    try{
      // print("TOKEN:-"+ab.toString());
      if(body!=null) {
        final response = await _networkService.dio.put(url, data: body /*  options: Options(
            headers: {
              "Content-Type": "application/json",
              HttpHeaders.authorizationHeader:  "Bearer $ab"
            },
          )*/);
        if (response.statusCode == 200) {
          return response.data["payload"];
        }
      }
    }
    on DioError catch (e) {
      if (e.response?.data != null) {
        showToast("${e.response?.data["errors"]?["message"]}");
      }
    }
    catch(e) {
      return null;
    }
    return null;
  }


}
/*
}*/

/*class pickleVideo extends StatefulWidget {
  const pickleVideo({Key? key}) : super(key: key);

  @override
  State<pickleVideo> createState() => _pickleVideoState();
}*/

/*class _pickleVideoState extends State<pickleVideo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            style: TextButton.styleFrom(primary: Colors.white),
            onPressed: clearScreen,
            child: const Text('Clear'),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 4),
          if(fileVideo == null)
            ListTile(
              leading: const Icon(FontAwesomeIcons.exchangeAlt),
              iconColor: Colors.black,
              title: const Text("Compress Video"),
              onTap: () {
                pickVideo();
              },)
          else
            Column(
              children: [
                buildThumbnail(),
                buildVideoInfo(),
                const SizedBox(height: 8),
                buildVideoCompress(),
                const SizedBox(height: 8),
                *//*ElevatedButton(onPressed:
                //compressVideo,
                  child: const Text(
                    'Compress Video',
                  ),),*//*
              ],
              //print(buildVideoCompress()),
              // buildThumbnail(),
              // const SizedBox(height: 4),
            )
        ],
      ),
    );
  }*/

/*Widget buildThumbnail() =>
      thumbnailBytes == null ?
      const CircularProgressIndicator() :
      Image.memory(thumbnailBytes!, height: 100,);

  Widget buildVideoInfo() {
    if (VideoSize == null)
      return Container();
    final size = VideoSize! / 1000;
    return Column(
      children: [
        const Text(
          'Orignal Video Info',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Size: $size KB',
          style: const TextStyle(fontSize: 20),
        )
      ],
    );
  }*/

/*Widget buildVideoCompress() {
    if (compressMediaInfo == null)
      return Container();
    final size = compressMediaInfo!.filesize! / 1000;
    return Column(
      children: [
        const Text(
          'Compress Video Info',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Size: $size KB',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 8),
        Text(
          "${compressMediaInfo!.path}",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void clearScreen() =>
      setState(() {
        compressMediaInfo = null;
        fileVideo = null;
      }
      );

*//*
  buildThumbnail() =>
      thumbnailBytes == null ?
      const CircularProgressIndicator() :
      Image.memory(thumbnailBytes!, height: 100);
*//*

*//*}*//*
  final DashBoardService _dashboardService = Get.find();
  final _loading = false.obs;
  XFile? fileVideo;
  Uint8List? thumbnailBytes;
  int? VideoSize;


  set loading(value) => _loading.value = value;

  bool get loading => _loading.value;


  *//*Future compressVideo() async {
    loading = true;
    final info = await _dashboardService.getCompress(viideo!);
    loading = false;
    return compressMediaInfo = info;
  }*//*

  Future pickVideo(*//*String id*//*) async {
    *//*final pickedFile =  await _dashboardService. imagePicker
        .pickVideo(source: ImageSource.camera,maxDuration: const Duration(seconds: 60))*//*
    final picker = ImagePicker();
    final pickedFile = await picker.getVideo(source: ImageSource.camera);
    *//*.then((value) async {*//*
    getVideoSize(fileVideo);
    *//*if (value != null) {
        loading = true;
        await _dashboardService.previewVideo(value,id);
        //buildVideoCompress();
        // compressVideo();
        //Get.offAll(()=>DashBoardService());
        loading = false;
      } else {
        Get.back();
      }*//*
    *//*});*//*
    *//*  if (pickedFile == null) return;
    final file = XFile(pickedFile.path);
    setState(() => fileVideo = file);
    generateThumbnail(fileVideo);
  }*//*

    *//* Future generateThumbnail(fileVideo) async {
    final thumbnailBytes = await VideoCompress.getByteThumbnail(fileVideo.path);
    setState(() => this.thumbnailBytes = thumbnailBytes);
  }*//*

    Future getVideoSize(fileVideo) async {
      final size = await fileVideo.length();
      setState(() => VideoSize = size);
    }

    *//* Future compressVideo() async{
    showDialog(
      context: context,
      builder: (BuildContext context) =>
      const Dialog(child: ProgressDialogWidget()),
    );
    final info = await _dashboardService.getCompress(fileVideo!);
    setState(() {
      compressMediaInfo = info;
    });
    Navigator.of(context).pop();
  }*//*
  }*/