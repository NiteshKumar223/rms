import 'package:flutter/material.dart';

import 'custom_colors.dart';

class UiHelper {
  // custom appbar
  static PreferredSizeWidget customAppbar(String title){
    return AppBar(
      backgroundColor: Ccolor.primarycolor,
      title: Text(
        title,
        style: TextStyle(
            color: Ccolor.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 0.8),
      ),
      centerTitle: true,
      iconTheme: IconThemeData(color: Ccolor.white, size: 25.0),
    );
  }
  // custom textfield
  static Widget CustomTextField(
      TextEditingController controller,
      String text,
      TextInputType inputType,
      {String? Function(String?)? validator,
        bool isMultiline = false
      }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 65,
        child: TextFormField(
          controller: controller,
          keyboardType: inputType,
          validator: validator,
          maxLines: isMultiline ? 3 : 1,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            labelText: text,
            hintText: text,
            labelStyle: const TextStyle(fontSize: 14),
            hintStyle: const TextStyle(fontSize: 14),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(width: 2.0, color: Ccolor.primarycolor)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(width: 2.0, color: Ccolor.primarycolor)),
          ),
        ),
      ),
    );
  }

  // custom textfield
  static customLoginSignupTextField(TextEditingController controller,
      String text, bool toHide, IconData iconData, TextInputType? inputType,
      {String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 65,
        child: TextFormField(
          controller: controller,
          obscureText: toHide,
          keyboardType: inputType,
          validator: validator,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            suffixIcon: Icon(iconData),
            labelText: text,
            hintText: text,
            labelStyle: const TextStyle(fontSize: 16),
            hintStyle: const TextStyle(fontSize: 16),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(width: 2.0, color: Ccolor.primarycolor)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(width: 2.0, color: Ccolor.primarycolor)),
          ),
        ),
      ),
    );
  }

  // custom button
  static CustomButton(VoidCallback voidcallback, String text) {
    return ElevatedButton(
      onPressed: () {
        voidcallback();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Ccolor.primarycolor,
        fixedSize: const Size(250, 50),
        elevation: 5.0,
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  // custom alert box
  static CustomAlertBox(BuildContext context, String text) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title:
                Text(text, style: TextStyle(fontSize: 16, color: Ccolor.red)),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Ccolor.primarycolor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "OK",
                  style: TextStyle(fontSize: 14, color: Ccolor.white),
                ),
              ),
            ],
          );
        });
  }

  // custom calculator
  static customCalculator(VoidCallback ontap, String btnName,Color bcolor) {

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: ontap,
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          fixedSize: const Size(300, 40),
          backgroundColor: bcolor,
        ),
        child: Text(btnName,
            style: TextStyle(fontSize: 16, color: Ccolor.white)),
      ),
    );
  }

  // custom rowdata collection
  static customRowData(String collTitle, String collData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(collTitle,
            style: TextStyle(fontSize: 12, color: Ccolor.primarycolor)),
        Text(collData, style: TextStyle(fontSize: 12, color: Ccolor.black)),
      ],
    );
  }

  // custom dropdown
  static Widget CustomDropdown({
    required List<String> items,
    required String hintText,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 65,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Ccolor.primarycolor, width: 2.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
              hint: Text(
                hintText,
                style: const TextStyle(fontSize: 16),
              ),
              onChanged: (value) {
                onChanged(value);
              },
              validator: validator,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 40,
              iconEnabledColor: Ccolor.primarycolor,
            ),
          ),
        ),
      ),
    );
  }
}
