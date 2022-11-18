import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:note/src/padding.dart';

import '../Login.dart';
import '../service/auth_servis.dart';
import '../src/colors.dart';
import '../src/string.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String dropdownValue = "🤩";

  bool _isVisible = true;
  var items = [
    SelfText.gozleriYildiz,
    SelfText.gulensurat,
    SelfText.aglayan,
    SelfText.boring,
    SelfText.dilsurat,
    SelfText.esneyen,
    SelfText.uykulu
  ];
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: ProjectPadding.pagehorizontal,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "SIGN UP",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ],
                    ),
                    Padding(
                      padding: ProjectPadding.pagebottom,
                      child: _usernameRow(),
                    ),
                    _emailRow(),
                    SizedBox(
                      height: 20,
                    ),
                    _passRow(),
                    SizedBox(
                      width: 50,
                      height: 60,
                    ),
                    Text(SelfText.hangiemoji),
                    _dropEmoji(),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: ProjectPadding.pagebottom3,
                      child: _signUpButton(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton _signUpButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontSize: 24),
        maximumSize: Size.fromHeight(46),
        shape: StadiumBorder(),
        backgroundColor: Colors.white.withOpacity(.5),
      ),
      child: isLoading
          ? CircularProgressIndicator(color: SelfColors.orange)
          : Text(SelfText.signup),
      onPressed: () {
        registerOnTap();
        if (isLoading) return;
        setState(() => isLoading = true);
      },
    );
  }

  DropdownButton<String> _dropEmoji() {
    return DropdownButton(
        borderRadius: BorderRadius.circular(20),
        isExpanded: true,
        iconEnabledColor: Colors.orange,
        value: dropdownValue,
        items: items.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            dropdownValue = value!;
          });
        });
  }

  Row _passRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: ProjectPadding.pageright,
          child: Icon(
            Icons.lock,
            color: SelfColors.kPrimaryColor,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: _passTextField(),
        ),
      ],
    );
  }

  Row _emailRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: ProjectPadding.pageright,
          child: Icon(
            Icons.alternate_email,
            color: SelfColors.kPrimaryColor,
          ),
        ),
        Expanded(
          child: _emailTextField(),
        ),
      ],
    );
  }

  Row _usernameRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: ProjectPadding.pageright,
          child: Icon(
            Icons.person,
            color: SelfColors.kPrimaryColor,
          ),
        ),
        Expanded(
          child: _usernameTextField(),
        )
      ],
    );
  }

  TextField _usernameTextField() {
    return TextField(
      controller: usernameController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: SelfText.username,
      ),
    );
  }

  TextField _emailTextField() {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: SelfText.email,
      ),
    );
  }

  TextField _passTextField() {
    return TextField(
      controller: passwordController,
      obscureText: _isVisible ? true : false,
      decoration: InputDecoration(
        suffixIcon: InkWell(
          onTap: () {
            if (_isVisible) {
              setState(() {
                _isVisible = false;
              });
            } else {
              setState(() {
                _isVisible = false;
              });
              _isVisible = true;
            }
          },
          child: _isVisible
              ? Icon(
                  Icons.remove_red_eye,
                  color: Colors.orange,
                )
              : Icon(
                  Icons.remove_red_eye_outlined,
                  color: Colors.orange,
                ),
        ),
        hintText: SelfText.password,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void registerOnTap() {
    if (usernameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      _auth
          .createPerson(
        usernameController.text,
        emailController.text,
        passwordController.text,
        dropdownValue,
      )
          .then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
            (route) => false);
      }).catchError((error) {
        _warningToast(SelfText.errorText);
      }).whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
    } else {
      _warningToast(SelfText.emptyText);
    }
  }

  Future<bool?> _warningToast(String text) {
    return Fluttertoast.showToast(
        msg: text,
        timeInSecForIosWeb: 2,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14);
  }
}
