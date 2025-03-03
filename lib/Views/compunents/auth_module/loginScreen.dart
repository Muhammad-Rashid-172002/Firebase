import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talk_app/Views/compunents/screen/chattingScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String error = '';
  final formKey = GlobalKey<FormState>();
  bool loading = false;

  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Login',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                  height: 170, child: Image.asset('assets/images/Capture.PNG')),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Enter Email",
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email!';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Enter Password",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                  obscureText: _obscureText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password!';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long!';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 70,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(50)),
                child: OutlinedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                        error = '';
                      });
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Account Created Successfully')),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChattingScreen()),
                        );
                      } on FirebaseAuthException catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${error.message}')),
                        );
                      } finally {
                        setState(() {
                          loading = false;
                        });
                      }
                    }
                  },
                  child: loading
                      ? CircularProgressIndicator()
                      : Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 19),
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
