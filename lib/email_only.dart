import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'driver.dart';
import 'authenticate.dart';
import 'loading.dart';

class OnlyEmail extends StatefulWidget {
  OnlyEmail({Key? key}) : super(key: key);

  @override
  _OnlyEmailSignInState createState() => _OnlyEmailSignInState();
}
class _OnlyEmailSignInState extends State<OnlyEmail> with WidgetsBindingObserver{
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  bool _success = false;

  void initState(){
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _emailController = TextEditingController();
  }

  void dispose(){
    _emailController.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  String _email = '';

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign In With Just Email"),
        ),
        backgroundColor: Colors.lime.shade400,
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
              width: 400,
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Email cannot be empty';
                  }
                  return null;
                },
              )),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Authenticate().signInOnlyEmail(_emailController.text);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        )
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final PendingDynamicLinkData? data =
      await FirebaseDynamicLinks.instance.getInitialLink();
      if( data?.link != null ) {
        Authenticate().handleLink(data!.link, _email, context);
      }
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData? dynamicLink) async {
            final Uri? deepLink = dynamicLink?.link;
            _success = Authenticate().handleLink(deepLink!, _email, context);
          }, onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      });
      setState(() {
        _success;
        if(_success){
          Navigator.push(context,MaterialPageRoute(builder: (context) => AppDriver()));
        }else{
          Loading();
        }
      });
    }
  }

}