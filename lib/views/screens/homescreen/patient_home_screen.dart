import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  final String name = "Besmala";

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBackgroundDecoration,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Icon(
            Icons.arrow_back_ios_new,
            color: greyColor,
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello ${widget.name}!',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 20),
                        
                        
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

}
