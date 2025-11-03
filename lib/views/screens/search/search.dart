import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/search_text_fields.dart';


class SearchScreen extends StatefulWidget {
  final userName = "Imene";
  const SearchScreen ({super.key});

   @override
  State<SearchScreen> createState() => _SearchScreenState();
}


class _SearchScreenState extends State<SearchScreen> {
  bool showFiltering = true;

  @override
  Widget build(BuildContext context)
  {
    return Container(
      decoration: gradientBackgroundDecoration,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: ListTile(
            title: Text(
              "Hello, ${widget.userName}!" ,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            trailing: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                 color: whiteColor,
                 borderRadius: BorderRadius.circular(20)
              ),
              child: Icon(Icons.notifications_active),
            ),

          )
          
        ),
        body: Container(
          padding: EdgeInsets.only(top: 70, right: 20, left: 20),
          child: Column(
            children: [
              SearchTextField(hint: "Start typing", onChanged: (value) {
                showFiltering = false;
                setState(() {});
              }
              ),
              SizedBox(height: 20),
              Visibility(
                visible: showFiltering,
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Icon(
                        Icons.import_export,
                        size: 25,
                        color: greyColor,
                        ),
                    ),
                    SizedBox(width: 6),
                    Text("By Location"),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Icon(
                        Icons.tune,
                        size: 25,
                        color: greyColor,
                        ),
                    ),
                    SizedBox(width: 20)
                  ],
                )
              )
            ]
          ),
        )
      )
      );
  
  }
  
}