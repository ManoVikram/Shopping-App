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

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    "email": "",
    "password": "",
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

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
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
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
      child: Container(
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
                if (_authMode == AuthMode.SignUp)
                  TextFormField(
                    enabled: _authMode == AuthMode.SignUp,
                    decoration: InputDecoration(labelText: "Confirm Password"),
                    obscureText: true, // Input is masked(not shown to the user)
                    validator: _authMode == AuthMode.SignUp
                        ? (value) {
                            if (value != _passwordController.text) {
                              return "Passwords didn't match.";
                            }
                          }
                        : null,
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
