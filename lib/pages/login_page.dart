import 'package:flutter/material.dart';
import 'package:recepies_app/services/auth_service.dart';
import 'package:status_alert/status_alert.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _loginFormKey = GlobalKey();

  String? Username, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Login",
        ),
      ),
      body: SafeArea(
        child: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _tittle(),
          _loginform(),
          _loginButton(),
        ],
      ),
    );
  }

  Widget _tittle() {
    return const Text(
      "Recip Book",
      style: TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _loginform() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.90,
      height: MediaQuery.sizeOf(context).height * 0.30,
      child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                initialValue: "emilys",
                onSaved: (value) {
                  setState(() {
                    Username = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter a Username";
                  }
                },
                decoration: InputDecoration(
                  hintText: "Username",
                ),
              ),
              TextFormField(
                initialValue: "emilyspass",
                obscureText: true,
                onSaved: (value) {
                  setState(() {
                    password = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.length < 5) {
                    return "Enter a valid password";
                  }
                },
                decoration: const InputDecoration(
                  hintText: "password",
                ),
              ),
            ],
          )),
    );
  }

  Widget _loginButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.60,
      child: ElevatedButton(
        onPressed: () async {
          if (_loginFormKey.currentState?.validate() ?? false) {
            _loginFormKey.currentState?.save();
            if (Username == null || password == null) {
              StatusAlert.show(
                context,
                duration: const Duration(seconds: 2),
                title: "Login Failed",
                subtitle: "Username or Password cannot be empty",
                configuration: const IconConfiguration(
                  icon: Icons.error,
                ),
                maxWidth: 260,
              );
              return;
            }

            // Debugging logs
            print("Username: $Username, Password: $password");

            bool result = await AuthService().login(
              Username ?? "",
              password ?? "",
            );

            if (result) {
              Navigator.pushReplacementNamed(context, "/home");
            } else {
              StatusAlert.show(
                context,
                duration: const Duration(seconds: 2),
                title: "Login Failed",
                subtitle: "Please try again",
                configuration: const IconConfiguration(
                  icon: Icons.error,
                ),
                maxWidth: 260,
              );
            }
          }
        },
        child: const Text(
          "Login",
        ),
      ),
    );
  }
}
