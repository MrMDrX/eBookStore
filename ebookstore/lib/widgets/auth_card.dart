import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../shared/dimensions.dart';
import '../shared/http_exception.dart';
import '../shared/strings.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  @override
  State createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {'email': '', 'password': ''};

  final _passwordController = TextEditingController();

  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  //Confirm password for signup mode animation
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;
  late AnimationController _animationController;

  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1.5), end: const Offset(0, 0))
            .animate(CurvedAnimation(
                parent: _animationController, curve: Curves.fastOutSlowIn));

    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    super.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceScreen = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          //card - login & signup
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: Dimens.ELEVATION,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              height: _authMode == AuthMode.Signup
                  ? Dimens.SIGNUP_HEIGHT
                  : Dimens.LOGIN_HEIGHT,
              constraints: BoxConstraints(
                  minHeight: _authMode == AuthMode.Signup
                      ? Dimens.SIGNUP_HEIGHT
                      : Dimens.LOGIN_HEIGHT),
              width: deviceScreen.width * 0.75,
              padding: const EdgeInsets.all(Dimens.PADDING_16),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      //email input
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: Strings.EMAIL_HINT),
                        keyboardType: TextInputType.emailAddress,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return Strings.INVALID_EMAIL_ERROR;
                          }
                        },
                        onSaved: (value) {
                          _authData['email'] = value!;
                        },
                      ),
                      //password input
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: Strings.PASSWORD_HINT),
                        obscureText: true,
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        onFieldSubmitted: (value) {
                          if (_authMode == AuthMode.Signup) {
                            FocusScope.of(context)
                                .requestFocus(_confirmPasswordFocusNode);
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty || value.length < 5) {
                            return Strings.SHORT_PASSWORD_ERROR;
                          }
                        },
                        onSaved: (value) {
                          _authData['password'] = value!;
                        },
                      ),
                      //confirm password for signup
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        constraints: BoxConstraints(
                            minHeight: _authMode == AuthMode.Signup ? 40 : 0,
                            maxHeight: _authMode == AuthMode.Signup
                                ? 60
                                : 0), //BoxConstraints
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  labelText: Strings.CONFIRM_PASSWORD_HINT),
                              obscureText: true,
                              focusNode: _confirmPasswordFocusNode,
                              validator: _authMode == AuthMode.Signup
                                  ? (value) {
                                      if (value != _passwordController.text) {
                                        return Strings
                                            .UNMATCHED_PASSWORDS_ERROR;
                                      }
                                    }
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      //some space
                      const SizedBox(height: Dimens.CUSTOM_HEIGHT_10),
                      //if loading, show indicator, otherwise, show login/signup based on the chosen mode
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else
                        ElevatedButton(
                            style: (ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 8.0),
                              primary: Theme.of(context).colorScheme.primary,
                            )),
                            //textColor: Colors.grey,),
                            onPressed: _submit,
                            child: Text(_authMode == AuthMode.Login
                                ? Strings.LOGIN_LABEL
                                : Strings.SIGNUP_LABEL)),
                      //some space
                      const SizedBox(height: Dimens.CUSTOM_HEIGHT_10),
                      //sign up or login instead action button
                      ElevatedButton(
                        onPressed: _switchAuthMode,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 2),
                          primary: Theme.of(context).colorScheme.primary,
                          //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          '${_authMode == AuthMode.Login ? Strings.SIGNUP_LABEL : Strings.LOGIN_LABEL} instead',
                        ),
                      )
                    ],
                  )),
            ),
          ),

          //some space
          const SizedBox(height: Dimens.CUSTOM_HEIGHT_10),
          //social media area
          Container(
            child: Column(
              children: <Widget>[
                Text(
                  Strings.CONTINUE_WITH,
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: Dimens.MARGIN_16),
                _signInWithGoogle()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _signInWithGoogle() {
    return ElevatedButton(
      // style: TextStyle(color:  Theme.of(context).primaryColor),
      onPressed: () async {
        await Provider.of<Auth>(context, listen: false)
            .signInWithGoogle()
            .then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      },
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      //highlightElevation: 0,

      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Image(
                image: AssetImage("assets/images/google_logo.png"),
                height: 28.0),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                Strings.SIGNEGGL,
                style: TextStyle(
                  fontSize: 16,
                  //color: Colors.blue,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // switch between login and signup
  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _animationController.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _animationController.reverse();
    }
  }

  // submit data for login or signup
  Future<void> _submit() async {
    //.validate returns true if there is no errors during validation
    if (!_formKey.currentState!.validate()) {
      //invalid input data
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .login(email: _authData['email'], password: _authData['password']);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signup(email: _authData['email'], password: _authData['password']);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authenticate failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }

      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(context: context, builder: (ctx) => _alertDialog(message));
  }

  Widget _alertDialog(String message) {
    if (Platform.isAndroid) {
      return AlertDialog(
        title: const Text(Strings.ERROR),
        content: Text(message),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(Strings.OK))
        ],
      );
    } else {
      return AlertDialog(
        title: const Text(Strings.ERROR),
        content: Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(Strings.OK))
        ],
      );
    }
  }
}










/*
class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
            _authData['email'] ?? 'test@test.com',
            _authData['password'] ?? 'test1234');
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
            _authData['email'] ?? 'test@test.com',
            _authData['password'] ?? 'test1234');
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
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
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 380 : 300,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 380 : 300),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                          }
                        : null,
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                      onPressed: _submit,
                      style: (ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        primary: Theme.of(context).primaryColor,
                      )),
                      //textColor: Colors.grey,),
                      child: Text(
                          _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP')),
                TextButton(
                  onPressed: _switchAuthMode,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 4),
                    primary: Theme.of(context).primaryColor,
                    //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


*/