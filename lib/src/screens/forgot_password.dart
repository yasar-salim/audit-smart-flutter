import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orison/src/utils/app_config.dart';
import 'package:orison/src/widgets/dashboard_item.dart';
import 'package:orison/src/widgets/round_app_button.dart';
import 'package:orison/src/widgets/title.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageTitle(title: 'Forget Password',),
              SizedBox(
                height: 20,
              ),
              Center(child: SvgPicture.asset('assets/images/lock.svg')),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 20.0),
                child: Text(
                  'Enter your email address and we\'ll send a password reset link to that email id.',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xff707070),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(15.0),
                          ),
                          borderSide: BorderSide(color: AppConfig.textFieldFillColor)
                      ),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(15.0),
                          ),
                          borderSide: BorderSide(color: AppConfig.textFieldFillColor)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(15.0),
                          ),
                          borderSide: BorderSide(color: AppConfig.textFieldFillColor)
                      ),
                      filled: true,
                      hintStyle: new TextStyle(color: AppConfig.hintTextColor.withOpacity(0.5),fontSize: 14),
                      hintText: "Your Email",
                      fillColor: AppConfig.textFieldFillColor,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 15)),
                ),
              ),
              SizedBox(height: 20,),
              RoundAppButton(title: "SEND", onPressed: (){
              },padding: MediaQuery.of(context).size.width*0.35,),
              SizedBox(height: 40,),
              Center(
                child: GestureDetector(
                  onTap: (){
                    if(Navigator.of(context).canPop())
                      Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConfig.hintTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
