import 'package:aby/widgets/languages/language.dart';
import 'package:aby/widgets/project_chars.dart';
import 'package:flutter/material.dart';

List<String> testPrjNames = ['aaa', 'bbb', 'ccc', 'asas'];

String findIconChars(String stringVal) {
  String reVal;
  RegExp regex = new RegExp(r'[A-Z]{2,}');
  if (regex.hasMatch(stringVal)) {
    regex = new RegExp(r'[A-Z]');
    var chars = regex.allMatches(stringVal).toList();
    reVal = '${chars[0].group(0)}${chars[1].group(0)}';
  } else {
    var words = stringVal.split(' ');
    if (words.length >= 2 && words[1].length > 0) {
      reVal = '${words[0][0]}${words[1][0]}';
    } else if (stringVal.length >= 2)
      reVal = '${stringVal[0]}${stringVal[1]}';
    else
      reVal = stringVal;
  }
  return reVal;
}

class NewProject {
  String name = '';
  String chars = 'xx';
  int langIdOrig = 17;
  List<int> langIdsTrans = [];

  Map<String, dynamic> get project {
    return {
      'name': name,
      'icon_chars': chars,
      'lang_orig': langIdOrig,
      'lang_trans': langIdsTrans,
    };
  }
}

class AddProjectScreen extends StatefulWidget {
  @override
  _AddProjectScreenState createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  NewProject _project = NewProject();
  int _step = 1;

  final _crProjectFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _charsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    _nameController.addListener(_handleNameChange);
    _charsController.addListener(_handCharsChange);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _nameController.dispose();
    _charsController.dispose();
    super.dispose();
  }

  void _handlePrev() {
    if (_step > 1) setState(() => _step -= 1);
  }

  void _handleNext() {
    if (_step == 1) {
      if (_crProjectFormKey.currentState.validate()) {
        _step += 1;
        _project.name = _nameController.text.toString();
        _project.chars = _charsController.text.toString();
      }
    } else if (_step == 2) {
      _step += 1;
    } else
      print("FINISH $_step");
    setState(() {});
  }

  void _handleNameChange() {
    String text = _nameController.text.toString();
    if (text == null) return;
    _charsController.text = findIconChars(text);
    // _charsController..text = findIconChars(text);
    setState(() {});
  }

  void _handCharsChange() {
    setState(() {
      // print('SET TEXT TO CHAR ${_charsController.text}');
      // _project.chars = _charsController.text.length > 0 ? _charsController.text : 'xx';
    });
  }

  Widget stepOne() {
    return Form(
      key: _crProjectFormKey,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.next,
            validator: (name) {
              Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
              RegExp regex = new RegExp(pattern);
              if (!regex.hasMatch(name))
                return 'Invalid project name';
              else
                return null;
            },
            autofocus: true,
            controller: _nameController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.title),
              labelText: "Project name",
              // errorText: context.select((AuthUser user) => user.error),
              helperText: "Enter your project name here",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: const SizedBox(),
              ),
              ProjectIconChars(
                iChars: _charsController.text.length > 0 ? _charsController.text : 'xx',
                size: 60,
              ),
              Expanded(
                flex: 2,
                child: const SizedBox(),
              ),
              Expanded(
                flex: 4,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.done,
                  validator: (chars) {
                    Pattern pattern = r'^[A-Za-z0-9]{1,2}$';
                    RegExp regex = new RegExp(pattern);
                    if (!regex.hasMatch(chars))
                      return 'Invalid icon chars';
                    else
                      return null;
                  },
                  controller: _charsController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20.0),
                    // prefixIcon: Icon(Icons.check_box_outline_blank),
                    prefixText: "Letters for icon: ",
                    // labelText: "Chars for icon",
                    helperText: "Enter 2 letters for project icon",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 50.0),
      child: Container(
        width: 600,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(blurRadius: 8.0, spreadRadius: 0.5, offset: Offset(2.0, 1.0))],
          borderRadius: BorderRadius.circular(16.0),
          color: Theme.of(context).primaryColor,
        ),
        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _HeaderProgress(step: _step),
            _step == 1
                ? stepOne()
                : Column(
                    children: [
                      LanguageNameIcon(),
                      LanguageNameIcon(),
                      LanguageNameIcon(),
                      Text("NNNasdasdasdasNN"),
                    ],
                  ),
            const SizedBox(height: 12),
            ButtonBar(
              // buttonMinWidth: 100.0,
              // buttonHeight: 50.0,
              // buttonPadding: EdgeInsets.symmetric(horizontal: 12.0),
              children: [
                if (_step > 1)
                  RaisedButton(
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    onPressed: _handlePrev,
                    child: Text('Previous', style: Theme.of(context).textTheme.headline5),
                  ),
                RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  onPressed: _handleNext,
                  child: Text(_step < 3 ? 'Next' : 'Finish', style: Theme.of(context).textTheme.headline5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderProgress extends StatelessWidget {
  const _HeaderProgress({Key key, @required int step})
      : _step = step,
        super(key: key);
  static const List<String> _stepNames = ['', 'Project naming', 'Project localize', 'Summary'];

  final int _step;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Create new project cloud storage', style: Theme.of(context).textTheme.headline4),
        const SizedBox(height: 24.0),
        Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                  value: 0.25 * _step,
                ),
                SizedBox(height: 22.0),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StepIcon(name: 'Naming', filled: _step > 0, icon: Icons.assignment_outlined),
                _StepIcon(name: 'Language', filled: _step > 1, icon: Icons.language),
                _StepIcon(name: 'Finish', filled: _step > 2, icon: Icons.library_add_check_outlined),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_stepNames[_step], style: Theme.of(context).textTheme.headline6),
            Text('Step: $_step', style: Theme.of(context).textTheme.headline6),
          ],
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}

class _StepIcon extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool filled;

  const _StepIcon({Key key, this.name, this.icon, this.filled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          borderRadius: BorderRadius.circular(30.0),
          elevation: 12,
          color: filled ? Colors.deepPurple : Colors.grey[1],
          child: SizedBox(
            width: 60.0,
            height: 60.0,
            child: Icon(icon, size: 40.0),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(name, style: Theme.of(context).textTheme.subtitle1),
      ],
    );
  }
}
