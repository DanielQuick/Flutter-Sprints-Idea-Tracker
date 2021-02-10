import 'package:flutter/material.dart';
import 'package:idea_tracker/controller/page/landing_page_controller.dart';
import 'package:idea_tracker/view/widget/password.dart';
import 'package:idea_tracker/view/widget/state_management/base_view.dart';

class Register extends StatelessWidget {
  final String email;
  final String userName;
  final String password;
  final String verifyPassword;

  Register({
    Key key,
    this.userName,
    this.password,
    this.verifyPassword,
    @required this.email,
  })
      : assert(email.contains('@'), 'email must contain @ symbol'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final onSuccess = (String content) {
      Navigator.pop(context);

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(content),
      ));
    };

    return BaseView<LandingController>(
        onControllerReady: (controller) {},
        builder: (context, controller, child) {
          return Scaffold(appBar: AppBar(bottom: TabBar(
            unselectedLabelColor: Colors.deepPurpleAccent[200],
            labelColor: Colors.purple[200],
            tabs: [
              Tab(icon: Icon(Icons.download_rounded), text: 'Sign In',),
              Tab(icon: Icon(Icons.upload_rounded), text: 'Sign Up',),
              Tab(icon: Icon(Icons.lock_open_rounded), text: 'Forgot?',),
              Tab(icon: Icon(Icons.autorenew_rounded), text: 'Reset',),
            ],
            controller: controller.tabController,
            indicatorSize: TabBarIndicatorSize.tab,
          ),),
              body: TabBarView(
                children: [
                  signIn(controller),
                  signUp(controller),
                  forgotPassword(controller),
                ],
              ));
        }

    );
  }

  Widget signIn(LandingController controller) {
    return Column(children: [
      Text('Sign In'),
      Card(
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.purple[200],
                  fontFamily: 'OpenSans',
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.only(top: 14.0),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.purple[200],
                  ),
                  hintText: 'Enter your Email',
                ),
                onChanged: (value) => controller.email,
              ),
              SizedBox(
                height: 20,
              ),
              PasswordField(
                fieldKey: key,
                labelText: 'Password',
                helperText: 'must be 8 characters',
                onFieldSubmitted: (value)=> controller.pwd,
              ),
              RaisedButton(
                shape: StadiumBorder(),
                onPressed: () => {controller.signIn()},
              ),
            ],
          ),
        ),),
    ],
    );
  }

  Widget signUp(LandingController controller) {
    return Column(children: [
      Text('Sign Up'),
      Card(
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.purple[200],
                  fontFamily: 'OpenSans',
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.only(top: 14.0),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.purple[200],
                  ),
                  labelText: 'User Name',
                  hintText: 'This will be your name displayed',
                ),
                onFieldSubmitted: (value) => {controller.userName = value},
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.purple[200],
                  fontFamily: 'OpenSans',
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.only(top: 14.0),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.purple[200],
                  ),
                  labelText: 'Email',
                  hintText: 'Enter your Email',
                ),
                //validator: ,
                onFieldSubmitted: (value) => {controller.email = value},
              ),
              SizedBox(
                height: 20,
              ),
              PasswordField(
                fieldKey: key,
                labelText: 'Password',
                helperText: 'must be 8 characters',
                onFieldSubmitted: (value) => {controller.pwd = value},
              ),
              SizedBox(
                height: 20,
              ),
              PasswordField(
                fieldKey: key,
                labelText: 'Verify Password',
                helperText: 'must match the other password',
                onFieldSubmitted: (value) => {controller.pwdVerify = value},
              ),
              RaisedButton(
                shape: StadiumBorder(),
                onPressed: () => {controller.signUp()},
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  forgotPassword(LandingController controller) {
    return Column(children: [
      Text('Sign Up'),
      Card(
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.purple[200],
                  fontFamily: 'OpenSans',
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.only(top: 14.0),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.purple[200],
                  ),
                  labelText: 'Email',
                  hintText: 'Enter your Email',
                ),
                //validator: ,
                onFieldSubmitted: (value) => {controller.email = value},
              ),
              RaisedButton(
                shape: StadiumBorder(),
                onPressed: () => {controller.forgotPassword()},
              ),
            ],
          ),
        ),
      ),
    ]);
  }

}
