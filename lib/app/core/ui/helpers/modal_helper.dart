import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_routes.dart';

class ModalHelper extends StatefulWidget {
  const ModalHelper({super.key});

  @override
  State<ModalHelper> createState() => _ModalHelperState();
}

_showDialog(BuildContext context){
  showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Title',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.3,
              color: Colors.redAccent[700],
            ),
          ),
          children: <Widget>[
            SimpleDialogOption(child: Column(
              children: <Widget>[
                Image.asset('assets/modal-error.png', height: 140, fit: BoxFit.contain,), // Your image here
                SizedBox(height: 10,), // Optional to give some extra space
                Text('Image 1'),
              ],
            ),onPressed: () {
              Get.offAllNamed(Routes.HOME);
            },),
          ],
        );
      }
  );
}

class _ModalHelperState extends State<ModalHelper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            _showDialog(context),
          ],
        ),
      ),
    );
  }
}
