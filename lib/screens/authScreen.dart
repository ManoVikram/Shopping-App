import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import '../models/httpException.dart';

enum AuthMode {
  SignUp,
  Login,
}

class AuthScreen extends StatelessWidget {
  static const routeName = "/auth";

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 65,
                      ),
                      transform: Matrix4.rotationZ(-10 * pi / 180)
                        ..translate(-10.0),
                      // 'translate()' returns 'void'. But, 'transform' requires an object of type 'Matrix4'
                      // The '..' operator makes the 'void' returned by 'translate()' into the type 'Matrix4'
                      // Basically, '..' operator converts the current return type of the later method
                      // into return type of the former method.
                      // '..' is called as Cascade operator.
                      // transform: transformConfig,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        // color: Colors.deepOrange.shade900,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        "User Login",
                        style: TextStyle(
                          color:
                              Theme.of(context).accentTextTheme.bodyText1.color,
                          fontSize: 44,
                          fontFamily: "Cantarell",
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: AuthCard(),
                    flex: deviceSize.width > 600 ? 2 : 1,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    "email": "",
    "password": "",
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController _controller;
  // 'AnimationController' helps in starting and controlling the animation.
  Animation<Size> _heightAnimation;
  // 'Animation' is a generic class
  // Both 'Animation' and 'Size' are classes provided by Flutter.
  // Manages the heavy lifting of managing the height.
  Animation<double> _opacityAnimation;
  Animation<Offset> _slideAnimation;

  /* Flutter updates the screen 60 times per second. */

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    // 'vsync' - Holds the pointer to the widget that needs to be animated
    // and it is visible on the screen.
    // Needs 'SingleTickerProviderStateMixin' mixin to work. Provided by 'material.dart'.

    _heightAnimation = Tween(
      begin: Size(double.infinity, 260),
      end: Size(double.infinity, 320),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
        // 'curve:' argument defines how the animation needs to be changed from begin to end.
        // Here, the animation changes linearly.
      ),
    );
    // 'Tween()' has the information on how to animate between 2 values.
    // '.animate()' helps in animating it.

    /* _heightAnimation.addListener(() => setState(() {})); */
    // setState() needs to be called when the screen is updated.
    // 'AnimatedBuilder()' is used to avoid setting up listeners manually.

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticInOut,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    // Controller and Listener are disposed.
  }

  void _showErrorDialog(String message) {
    // 'context' is available everywhere in the State class.
    showDialog(
      context: context,
      builder: (contxt) => AlertDialog(
        title: Text(
          "Error occurred!!",
        ),
        content: Text(
          message,
        ),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Close",
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid
      return;
    }

    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        // TODO: Log user in
        await Provider.of<Auth>(context, listen: false).logIn(
          _authData["email"],
          _authData["password"],
        );
      } else {
        // TODO: Sign user up
        await Provider.of<Auth>(context, listen: false).signUp(
          _authData["email"],
          _authData["password"],
        );
      }
    } on HttpException catch (error) {
      var errorMessage = "Authentication failed!!";

      if (error.toString().contains("EMAIL_EXISTS")) {
        errorMessage = "Email already exists.";
      } else if (error.toString().contains("INVALID_EMAIL")) {
        errorMessage = "Enter a valid Email ID.";
      } else if (error.toString().contains("WEAK_PASSWORD")) {
        errorMessage = "Password is so weak. Enter a strong password.";
      } else if (errorMessage.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = "Email isn't registered. Try Signing Up.";
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "Invalid password.";
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          "Couldn't authenticate the user. Please try again later.";
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
      _controller.forward(); // Starts the animation.
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller
          .reverse(); // Animation is played in the reverse mode when the mode changes.
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10,
      child:
          /* AnimatedBuilder(
        animation: _heightAnimation,
        builder: (contxt, childArg) => Container(
          // height: _authMode == AuthMode.SignUp ? 320 : 260,
          height: _heightAnimation.value.height,
          // constraints: BoxConstraints(
          //   minHeight: _authMode == AuthMode.SignUp ? 320 : 260,
          constraints: BoxConstraints(
            minHeight: _heightAnimation.value.height,
          ),
          width: deviceSize.width * 0.75,
          padding: EdgeInsets.all(16),
          child: childArg,
        ), */
          // 'child' argument of builder method will not be re-built. - "child: Form(...)"
          AnimatedContainer(
        duration: Duration(
          milliseconds: 400,
        ),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.SignUp ? 320 : 260,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.SignUp ? 320 : 260,
        ),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "E-Mail",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    // This validator is just for the app.
                    // Firebase does it's own validations when the data is sent to the server.
                    // Firebase denies invalid data.
                    if (value.isEmpty || !value.contains("@")) {
                      return "Invalid E-Mail address.";
                    }
                  },
                  onSaved: (value) {
                    _authData["email"] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                  obscureText: true, // Input isn't shown to the user.
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 6) {
                      return "Password must be atleast 6 characters long.";
                    }
                  },
                  onSaved: (value) {
                    _authData["password"] = value;
                  },
                ),
                // if (_authMode == AuthMode.SignUp)
                /* 
                More animation = Less speed 
                Animation and Speed are inversely proportional to each other.
                */
                AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                    maxHeight: _authMode == AuthMode.SignUp ? 120 : 0,
                  ),
                  duration: Duration(
                    milliseconds: 400,
                  ),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.SignUp,
                        decoration:
                            InputDecoration(labelText: "Confirm Password"),
                        obscureText:
                            true, // Input is masked(not shown to the user)
                        validator: _authMode == AuthMode.SignUp
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return "Passwords didn't match.";
                                }
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    onPressed: _submit,
                    child: Text(
                      _authMode == AuthMode.Login ? "Login" : "SignUp",
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    "Try ${_authMode == AuthMode.Login ? 'Signing Up' : 'Logging In'}",
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 5,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  // Shrinks the size of the button when tapped.
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
