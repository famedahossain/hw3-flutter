import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'phone.dart';
import 'authenticate.dart';
import 'driver.dart';
import 'email_only.dart';
import 'register.dart';
import 'package:flutter/material.dart';
import 'loading.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController, _passwordController, _phoneNumberController;

  get model => null;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  bool _loading = false;
  String _email = "";
  String _password = "";
  String _phone = "";

  @override
  Widget build(BuildContext context) {

    final emailInput = TextFormField(
      autocorrect: false,
      controller: _emailController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      decoration: const InputDecoration(
          labelText: "Email Address",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          hintText: 'Enter Email'),
    );

    final passwordInput = TextFormField(
      autocorrect: false,
      controller: _passwordController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter Password';
        }
        return null;
      },
      obscureText: true,
      decoration: const InputDecoration(
        labelText: "Password",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        hintText: 'Enter Password',
        suffixIcon: Padding(
          padding: EdgeInsets.all(15), // add padding to adjust icon
          child: Icon(Icons.lock),
        ),
      ),
    );

    final submitButton = OutlinedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Processing Data')));
          _email = _emailController.text;
          _password = _passwordController.text;

          _emailController.clear();
          _passwordController.clear();

          setState(() {
            _loading = true;
            Authenticate().signInWithEmailAndPassword(_email, _password, context);
          });
        }
      },
      child: const Text('Submit'),
    );

    final registerButton = Container(
        width: 250.0,
        child: OutlinedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (con) => const RegisterPage()));
          },
          child: const Text('Register'),
    ));

    final justEmail = Container(
        width: 250.0,
        child: OutlinedButton(
          onPressed:(){
            Navigator.push(
                context,MaterialPageRoute(builder: (con) => OnlyEmail()));
          }, child:Text("Sign In With Only Email"),
    ));

    final google = Container(
      width: 250.0,
      child : OutlinedButton.icon(
        icon: Image.asset('assets/googleicon.png', height: 20, width: 20,),
        label: const Text("Sign in With Google"),
        onPressed: (){
          Authenticate().googleSignIn(context);
        } ));

    final facebook = Container(
        width: 250.0,
        child: OutlinedButton.icon(
        icon: Image.asset('assets/facebook.png', height: 20, width: 20,),
        label: const Text("Sign in With Facebook"),
        onPressed: (){
          Authenticate().facebookSignIn(context);
        } ));

    final phone = Container(
        width: 250.0,
        child: OutlinedButton(
        onPressed:(){
          Navigator.push(
              context,MaterialPageRoute(builder: (con) => const PhoneSignIn()));},
        child: Text("Sign in with Phone Number"),
    ));

    final anon = Container(
      width: 250.0,
      child: OutlinedButton(
        onPressed: (){
          Authenticate().anonSignIn(context);},
        child:Text("Sign in Anonymously"),
    ));

    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  emailInput,
                  passwordInput,
                  submitButton,
                  justEmail,
                  phone,
                  google,
                  facebook,
                  anon,
                  registerButton,
                ],
              ),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
