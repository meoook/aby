import 'package:aby/model/user.dart';
import 'package:aby/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

// Create a Form widget.
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Abyss localize"),
      ),
      drawer: width < 600.0 ? MenuDrawer() : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Expanded(
                child: SizedBox(),
                flex: 1,
              ),
              Container(
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: LoginForm(),
              ),
              Expanded(
                child: SizedBox(),
                flex: 3,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    // _usernameController.addListener(_checkValue);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState.validate()) {
      context.read<AuthUser>().login(
          username: _usernameController.text,
          password: _passwordController.text);
      // Provider.of<AuthUser>(context, listen: false).login(
      //     username: _usernameController.text,
      //     password: _passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Try to login...')),
      );
    }
  }

  // void fieldFocusChange(
  //     BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  //   currentFocus.unfocus();
  //   FocusScope.of(context).requestFocus(nextFocus);
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 200,
            child: RiveLogo(),
          ),
          const SizedBox(height: 60),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.next,
            validator: (name) {
              Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
              RegExp regex = new RegExp(pattern);
              if (!regex.hasMatch(name))
                return 'Invalid username';
              else
                return null;
            },
            autofocus: true,
            // validator: (value) {
            //   if (value.isEmpty) return 'Username can\'t be empty';
            //   return null;
            // },
            controller: _usernameController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_outline_rounded),
              labelText: "Username",
              errorText: context.select((AuthUser user) => user.error),
              helperText: "Enter your username or email here",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            textInputAction: TextInputAction.done,
            validator: (password) {
              Pattern pattern = r'^.*$';
              // r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
              RegExp regex = new RegExp(pattern);
              if (!regex.hasMatch(password))
                return 'Invalid password';
              else
                return null;
            },
            controller: _passwordController,
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(20.0),
              prefixIcon: Icon(Icons.lock_outline_rounded),
              labelText: "Password",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
          ),
          const SizedBox(height: 12),
          ButtonBar(
            buttonMinWidth: 100.0,
            buttonHeight: 40.0,
            // buttonPadding: EdgeInsets.all(12.0),
            children: [
              FlatButton(
                child: Text('Forgot password ?'),
                onPressed: () => {},
                padding: EdgeInsets.all(16.0),
              ),
              // OutlineButton(
              //   child: new Text('Register'),
              //   onPressed: () => {},
              // ),
              RaisedButton(
                autofocus: true,
                onPressed: _onLogin,
                child: Text('Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RiveLogo extends StatefulWidget {
  @override
  _RiveLogoState createState() => _RiveLogoState();
}

class _RiveLogoState extends State<RiveLogo> {
  final riveFileName = 'assets/rive/logo.riv';
  Artboard _artBoard;

  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  // loads a Rive file
  void _loadRiveFile() async {
    final bytes = await rootBundle.load(riveFileName);
    final file = RiveFile();

    if (file.import(bytes)) {
      // Select an animation by its name
      setState(() =>
          _artBoard = file.mainArtboard..addController(SimpleAnimation('go')));
    }
  }

  /// Show the rive file, when loaded
  @override
  Widget build(BuildContext context) {
    return _artBoard != null
        ? Rive(
            // useIntrinsicSize: true,
            artboard: _artBoard,
            fit: BoxFit.contain,
          )
        : const SizedBox();
  }
}
