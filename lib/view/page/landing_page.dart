import 'package:flutter/material.dart';
import 'package:idea_tracker/controller/page/landing_page_controller.dart';
import 'package:idea_tracker/view/widget/password.dart';
import 'package:idea_tracker/view/widget/state_management/base_view.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> with SingleTickerProviderStateMixin {
  TabController _tabController;
  final _focusNode = FocusNode();

  void _onFieldSubmitted(String value) {
    _focusNode.requestFocus();
  }

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final onAuthorization = (String content) {
      Navigator.popAndPushNamed(context, '/main');

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(content),
      ));
    };
    return BaseView<LandingController>(onControllerReady: (controller) {
      controller.onAuthorization = onAuthorization;
    }, builder: (context, controller, child) {
      return Scaffold(
          body: Container(
              child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Center(
                child: Image.asset(
              'assets/images/creativeIdea.png',
              fit: BoxFit.contain,
            )),
          ),
          tabBar(controller, context),
          Expanded(child: tabBarViews(controller, context))
        ],
      )));
    });
  }

  ///shows tabs and calls the other functions to build the authentication forms
  ///
  Widget tabBar(LandingController controller, BuildContext context) {
    return TabBar(
      controller: _tabController,
      labelColor: Colors.purple[200],
      unselectedLabelColor: Colors.grey,
      tabs: [
        Tab(
          icon: Icon(
            Icons.download_rounded,
            color: Colors.purple[200],
          ),
          text: 'Sign In',
        ),
        Tab(
          icon: Icon(
            Icons.upload_rounded,
            color: Colors.purple[200],
          ),
          text: 'Sign Up',
        ),
        Tab(
          icon: Icon(
            Icons.lock_open_rounded,
            color: Colors.purple[200],
          ),
          text: 'Forgot?',
        ),
      ],
      indicatorSize: TabBarIndicatorSize.tab,
    );
  }

  Widget tabBarViews(LandingController controller, BuildContext context) {
    return TabBarView(
      controller: _tabController,
      children: [
        signIn(controller, context),
        signUp(controller, context),
        forgotPassword(controller, context)
      ],
    );
  }

  Widget signIn(LandingController controller, BuildContext context) {
    String email;
    String pwd;
    Key _formKey;
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
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
                    onChanged: (value) => email,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  PasswordField(
                    fieldKey: _formKey,
                    labelText: 'Password',
                    helperText: 'must be 8 characters',
                    color: Colors.purple[200],
                    onFieldSubmitted: (value) => pwd,
                  ),
                  RaisedButton(
                    shape: StadiumBorder(),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onPressed: () => {controller.signIn(email, pwd)},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget signUp(LandingController controller, BuildContext context) {
    String userName;
    String email;
    String pwd;
    String pwdVerify;
    Key _formKey;
    return SingleChildScrollView(
      child: Column(children: [
        Card(
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.userNameController,
                  style: TextStyle(
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
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: controller.emailController,
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
                ),
                SizedBox(
                  height: 10,
                ),
                PasswordField(
                  fieldKey: _formKey,
                  labelText: 'Password',
                  helperText: 'must be 8 characters',
                  onFieldSubmitted: (value) => pwd,
                ),
                SizedBox(
                  height: 10,
                ),
                PasswordField(
                  fieldKey: _formKey,
                  labelText: 'Verify Password',
                  helperText: 'must match the other password',
                  onFieldSubmitted: (value) => pwdVerify,
                ),
                RaisedButton(
                  shape: StadiumBorder(),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onPressed: () => {
                    controller.signUp(controller.userNameController.text,
                        controller.emailController.text, pwd, pwdVerify)
                  },
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  forgotPassword(LandingController controller, BuildContext context) {
    String email;
    return Column(children: [
      Text('Forgot Password? Reset it here through email.'),
      SizedBox(
        height: 20,
      ),
      Card(
        child: Form(
          child: Column(
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
                controller: controller.emailController,
                onFieldSubmitted: (value) => email,
              ),
              RaisedButton(
                shape: StadiumBorder(),
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () => {controller.forgotPassword(email)},
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
