import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InProgressWidget extends StatelessWidget {
  const InProgressWidget({Key? key}) : super(key: key);

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
                "In progress",
                style:  GoogleFonts.lato(
                    fontSize: 15,
                    color: Colors.black.withOpacity(.9)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

