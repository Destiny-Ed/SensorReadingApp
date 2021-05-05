import 'package:flutter/material.dart';
import 'package:flutter_text_form_field/flutter_text_form_field.dart';
import 'package:sensor_app/Provider/authenticate_user.dart';
import 'package:sensor_app/Screen/SensorPage/home.dart';
import 'package:sensor_app/Utils/page_router.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Controllers for text field
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          title: Text("Create an Account"),
        ),
        SliverFillRemaining(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomTextField(
                  nameController,
                  hint: "FullName",
                  password: false,
                  border: Border.all(color: Colors.transparent),
                ),
                CustomTextField(emailController,
                    hint: "email@example.com",
                    password: false,
                    
                    border: Border.all(color: Colors.transparent)),
                CustomTextField(phoneController,
                    hint: "+234 908 321 5332",
                    password: false,
                    border: Border.all(color: Colors.transparent)),
                CustomTextField(weightController,
                    hint: "Enter your weight",
                    password: false,
                    border: Border.all(color: Colors.transparent)),
                CustomTextField(heightController,
                    hint: "Enter your height",
                    password: false,
                    border: Border.all(color: Colors.transparent)),
                CustomTextField(passwordController,
                    hint: "************",
                    obscure: true,
                    border: Border.all(color: Colors.transparent)),
                GestureDetector(
                  onTap: () {
                    //Validate User
                    validateUser(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.blueGrey),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Create Account",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }

  void validateUser(BuildContext context) {
    if (emailController.text.isEmpty ||
        nameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        phoneController.text.isEmpty ||
        weightController.text.isEmpty ||
        heightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please provide the required information")));
    } else {
      AuthClass()
          .createUser(
              email: emailController.text.trim(),
              userName: nameController.text.trim(),
              password: passwordController.text.trim(),
              phone: phoneController.text.trim(),
              weight: weightController.text.trim(),
              height: heightController.text.trim())
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Welcome " + value.toUpperCase())),
        );

        Future.delayed(const Duration(seconds: 2), () {
          PageRouter(ctx: context).nextPageAndRemove(page: Home(value));
        });
      });
    }
  }
}
