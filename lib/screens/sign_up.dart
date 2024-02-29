
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/auth_service.dart';
import '../utils/validator.dart';
import 'login.dart';

class Signupform extends StatefulWidget {
  const Signupform({super.key});
  @override
  State<Signupform> createState() => _SignupformState();
}

class _SignupformState extends State<Signupform> {
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();

  final usernamecontroller = TextEditingController();

  final emailcontroller = TextEditingController();

  final phonecontroller = TextEditingController();

  final passwordcontroller = TextEditingController();
  final repasswordcontroller = TextEditingController();

  var authservc=AuthService();
  var isloader=false;



  Future<void> _submitf() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isloader = true;
      });

      var data = {
        "username": usernamecontroller.text,
        "email": emailcontroller.text,
        "password": passwordcontroller.text,
        "phone": phonecontroller.text,
        "balance": 0.0,
        "totalc": 0.0,
        "totald": 0.0
      };

      try {
        // Create user in Firebase Authentication
        await authservc.createuser(data, context);



        setState(() {
          isloader = false;
        });
      } catch (e) {
        // Handle any errors that occur during user creation or email verification
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create account: $e'),
          ),
        );

        setState(() {
          isloader = false;
        });
      }
    }
  }

  bool _isPasswordVisible = false;
  final appvalidator=Appvalidator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF252634),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formkey,
              child:Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    child: Text(
                      'Create New Account',
                      style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                      controller: usernamecontroller,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: const TextStyle(color: Colors.white),
                      decoration: _buildid("Username", Icons.person),
                      validator: appvalidator.uservalid
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                      controller: emailcontroller,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: _buildid("Email", Icons.email),
                      validator: appvalidator.validemail
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                      controller: phonecontroller,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.white),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: _buildid("Phone Number", Icons.call),
                      validator: appvalidator.phonevalid
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: passwordcontroller,
                    style: const TextStyle(color: Colors.white),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildid("Password", Icons.lock),
                    validator: appvalidator.passvalid,
                    obscureText: !_isPasswordVisible,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: repasswordcontroller,
                    style: const TextStyle(color: Colors.white),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildid("Re Enter Password", Icons.lock),
                    validator: (value) {
                      if (value != passwordcontroller.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    obscureText: !_isPasswordVisible,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: const Color(0xFF949494),
                        ),
                        SizedBox(width: 8), // Add some spacing between icon and text
                        Text(
                          _isPasswordVisible ? 'Hide Password' : 'Show Password',
                          style: TextStyle(color: const Color(0xFF949494)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){
                        isloader ? "" : _submitf();
                      },
                      style: ElevatedButton.styleFrom(
                        shape:
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        backgroundColor: const Color.fromARGB(255, 241, 89, 0),
                      ),
                      child: isloader ? const Center(child: CircularProgressIndicator()):
                      const Text('Create Account',style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account',style: TextStyle(color: Colors.white),),
                      TextButton(
                          onPressed: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Login()));

                          },
                          child: Text('Login',style: TextStyle(color: Color.fromARGB(255, 241, 89, 0),decoration: TextDecoration.underline,decorationColor: Color.fromARGB(255, 241, 89, 0)),)
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildid(String label, IconData suinc){
    return InputDecoration(
        fillColor: const Color(0xAA494A59),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x35949494))
        ),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)
        ),
        filled: true,
        labelStyle: const TextStyle(color: Color(0xFF949494)),
        labelText: label,
        suffixIcon: Icon(suinc,color: const Color(0xFF949494),),
        border: OutlineInputBorder(borderRadius:BorderRadius.circular(10))
    );
  }
}
