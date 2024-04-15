import 'package:flutter/material.dart';

import 'custom_raised_button.dart';

class BottomDialogue extends StatelessWidget {
  final Function downloadFunction;
  final Function clearFunction;

  BottomDialogue({required this.downloadFunction, required this.clearFunction});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background page
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // Close dialog on background tap
            },
            child: Container(
              color: Colors.black.withOpacity(0.5), // Semi-transparent background
            ),
          ),
        ),
        // Dialog
        Positioned(
          bottom: 16.0, // Adjust this value to position the dialog vertically
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CustomRaisedButton(
                        borderRadius: 4,
                        onpressed: () {
                          if (downloadFunction != null) {
                            downloadFunction();
                            Navigator.pop(context);

                            // Call download function if provided
                          }

                        },
                        text: 'Save',
                        color: Colors.grey,
                        size: 14,
                        sidecolor: Colors.grey,
                        height: 35,
                        width: 50,
                      ),
                      SizedBox(width: 20,),
                      Padding(
                        padding: const EdgeInsets.all(7),
                        child: CustomRaisedButton(
                          borderRadius: 4,
                          onpressed: () {
                            if (downloadFunction != null) {
                              downloadFunction();
                              Navigator.pop(context);
                            }
                          },
                          icon: Icon(Icons.download, color: Colors.white),
                          color: Colors.grey,
                          size: 14,
                          sidecolor: Colors.grey,
                          height: 20,
                          width: 50,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      CustomRaisedButton(
                        borderRadius: 4,
                        onpressed: () {
                          if(clearFunction != null){
                            Navigator.pop(context);

                            clearFunction();
                          }
                        },
                        text: 'clear',
                        color: Colors.grey,
                        size: 14,
                        sidecolor: Colors.grey,
                        height: 35,
                        width: 50,
                      ),
                      SizedBox(width: 20,),
                      Padding(
                        padding: const EdgeInsets.all(7),
                        child: CustomRaisedButton(
                          borderRadius: 4,
                          onpressed: () {
                            if(clearFunction != null){
                              Navigator.pop(context);
                              clearFunction();
                            }
                          },
                          icon: Icon(Icons.cancel, color: Colors.white),
                          color: Colors.grey,
                          size: 14,
                          sidecolor: Colors.grey,
                          height: 20,
                          width: 50,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
