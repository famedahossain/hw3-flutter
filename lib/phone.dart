import 'package:flutter/material.dart';
import 'authenticate.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PhoneSignIn extends StatefulWidget {
  const PhoneSignIn({Key? key}) : super(key: key);

  @override
  _PhoneSignInState createState() => _PhoneSignInState();
}
class _PhoneSignInState extends State<PhoneSignIn> {
  final SmsAutoFill _autoFill = SmsAutoFill();
  late TextEditingController _phoneController, _smsController;

  void initState(){
    super.initState();
    _phoneController = TextEditingController();
    _smsController = TextEditingController();
  }

  void dispose(){
    _phoneController.dispose();
    _smsController.dispose();
    super.dispose();
  }

  String _phone = '';
  String _sms = '';

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In With Your Phone Number"),
      ),
      backgroundColor: Colors.lime.shade400,
      body: Padding(padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Enter In Your Phone Number (+1 XXX-XXX-XXXX)'),
              ),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: Text("Verify Your Number"),
                  onPressed: () async {
                    Authenticate().phoneSignIn(_phoneController.text, context);
                  },
                ),
              ),
              TextFormField(
                controller: _smsController,
                decoration: const InputDecoration(labelText: 'Enter In Your Verification code'),
              ),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: () async {
                      Authenticate().signInPhone(_smsController.text, context);
                    },
                    child: Text("Sign In")),
              ),
            ],
          ),
      ),
    );
  }
}