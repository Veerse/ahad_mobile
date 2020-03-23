
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';


class SearchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 16),
        FormBuilderTextField(
          attribute: 'search',
          initialValue: '',
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.search),
            labelText: 'Taper un titre, un imam ou un thème',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
        ),
        Expanded(
          child: Center(
              child: Image.asset("assets/images/search/soon.png", height: 250.0)
          ),
        )
      ],
    );
  }

}