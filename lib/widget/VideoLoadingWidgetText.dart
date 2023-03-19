import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoLoadingWidget extends StatelessWidget {
  const VideoLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                "Video Upload In progress",
                style:  GoogleFonts.lato(
                    fontSize: 15,
                    color: Colors.white.withOpacity(.9)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

