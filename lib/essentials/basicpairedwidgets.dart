import 'package:flutter/material.dart';

class BasicPairedWidgets {
  static Widget textFormFieldWithText({
    required BuildContext context,
    required TextEditingController controller,
    required String? Function(String? value) validator,
    double width = 0,
    String text = "",
    String hint = "",
    bool border = false,
    TextInputType? keyboardType,
    bool obscrueText = false,
  }) =>
      Container(
        margin: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 15,
        ),
        width: MediaQuery.sizeOf(context).width - width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
              ),
              child: TextFormField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                keyboardType: keyboardType,
                style: Theme.of(context).textTheme.displaySmall,
                decoration: InputDecoration(
                  enabledBorder: border == true
                      ? const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        )
                      : null,
                  focusedBorder: border == true
                      ? const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        )
                      : null,
                  fillColor: Colors.black,
                  hintText: hint,
                  border: InputBorder.none,
                ),
                controller: controller,
                validator: validator,
                obscureText: obscrueText,
              ),
            ),
          ],
        ),
      );
}
