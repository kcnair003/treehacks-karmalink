import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../ui/widgets/my_app_bar.dart';
import '../../../colors.dart';
import '../../../text_styles.dart';
import 'email_password_sign_in_model.dart';
import '../../../../common_widgets/form_submit_button.dart';
import '../../../../common_widgets/platform_alert_dialog.dart';
import '../../../../common_widgets/platform_exception_alert_dialog.dart';
import '../../../../constants/strings.dart';
import '../../../../services/auth_service.dart';
import '../../../../utility/transition.dart';

class EmailPasswordSignInPage extends StatefulWidget {
  const EmailPasswordSignInPage._(
      {Key key, @required this.model, this.onSignedIn})
      : super(key: key);
  final EmailPasswordSignInModel model;
  final VoidCallback onSignedIn;

  static Future<void> show(BuildContext context,
      {VoidCallback onSignedIn}) async {
    await Navigator.of(context).push(Transition.none(
        next: EmailPasswordSignInPage.create(context, onSignedIn: onSignedIn)));
  }

  static Widget create(BuildContext context, {VoidCallback onSignedIn}) {
    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    return ChangeNotifierProvider<EmailPasswordSignInModel>(
      create: (_) => EmailPasswordSignInModel(auth: auth),
      child: Consumer<EmailPasswordSignInModel>(
        builder: (_, EmailPasswordSignInModel model, __) =>
            EmailPasswordSignInPage._(model: model, onSignedIn: onSignedIn),
      ),
    );
  }

  @override
  _EmailPasswordSignInPageState createState() =>
      _EmailPasswordSignInPageState();
}

class _EmailPasswordSignInPageState extends State<EmailPasswordSignInPage> {
  final FocusScopeNode _node = FocusScopeNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  EmailPasswordSignInModel get model => widget.model;

  @override
  void dispose() {
    _node.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _showSignInError(
      EmailPasswordSignInModel model, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: model.errorAlertTitle,
      exception: exception,
    ).show(context);
  }

  Future<void> _submit() async {
    try {
      final bool success = await model.submit();
      if (success) {
        if (model.formType == EmailPasswordSignInFormType.forgotPassword) {
          await PlatformAlertDialog(
            title: Strings.resetLinkSentTitle,
            content: Strings.resetLinkSentMessage,
            defaultActionText: Strings.ok,
          ).show(context);
        } else {
          if (widget.onSignedIn != null) {
            widget.onSignedIn();
          }
        }
      }
    } on PlatformException catch (e) {
      _showSignInError(model, e);
    }
  }

  void _nameEditingComplete() {
    if (model.canSubmitName) {
      _node.nextFocus();
    }
  }

  void _emailEditingComplete() {
    if (model.canSubmitEmail) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete() {
    if (!model.canSubmitEmail) {
      _node.previousFocus();
      return;
    }
    _submit();
  }

  void _updateFormType(EmailPasswordSignInFormType formType) {
    model.updateFormType(formType);
    _emailController.clear();
    _passwordController.clear();
    _nameController.clear();
  }

  Widget _buildNameField() {
    return TextField(
      key: Key('name'),
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Name',
        labelStyle: TextStyles.roboto(14, pureBlack),
        errorText: model.emailErrorText,
        enabled: !model.isLoading,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: yellow3),
        ),
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.name,
      keyboardAppearance: Brightness.light,
      onChanged: model.updateName,
      onEditingComplete: _nameEditingComplete,
    );
  }

  Widget _buildEmailField() {
    return TextField(
      key: Key('email'),
      controller: _emailController,
      decoration: InputDecoration(
        labelText: Strings.emailLabel,
        labelStyle: TextStyles.roboto(14, pureBlack),
        hintText: Strings.emailHint,
        errorText: model.emailErrorText,
        enabled: !model.isLoading,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: yellow3),
        ),
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      keyboardAppearance: Brightness.light,
      onChanged: model.updateEmail,
      onEditingComplete: _emailEditingComplete,
      inputFormatters: <TextInputFormatter>[
        model.emailInputFormatter,
      ],
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      key: Key('password'),
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: model.passwordLabelText,
        labelStyle: TextStyles.roboto(14, pureBlack),
        errorText: model.passwordErrorText,
        enabled: !model.isLoading,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: yellow3),
        ),
      ),
      obscureText: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      keyboardAppearance: Brightness.light,
      onChanged: model.updatePassword,
      onEditingComplete: _passwordEditingComplete,
    );
  }

  Widget _buildContent() {
    return FocusScope(
      node: _node,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (model.formType == EmailPasswordSignInFormType.register) ...[
            SizedBox(height: 8.0),
            _buildNameField(),
          ],
          SizedBox(height: 8.0),
          _buildEmailField(),
          if (model.formType !=
              EmailPasswordSignInFormType.forgotPassword) ...<Widget>[
            SizedBox(height: 8.0),
            _buildPasswordField(),
          ],
          SizedBox(height: 24),
          FormSubmitButton(
            key: Key('primary-button'),
            text: model.primaryButtonText,
            loading: model.isLoading,
            onPressed: model.isLoading ? null : _submit,
          ),
          SizedBox(height: 8.0),
          FlatButton(
            key: Key('secondary-button'),
            child: Text(
              model.secondaryButtonText,
              style: TextStyles.roboto(16, pureBlack),
            ),
            onPressed: model.isLoading
                ? null
                : () => _updateFormType(model.secondaryActionFormType),
          ),
          if (model.formType == EmailPasswordSignInFormType.signIn)
            FlatButton(
              key: Key('tertiary-button'),
              child: Text(
                Strings.forgotPasswordQuestion,
                style: TextStyles.roboto(16, pureBlack),
              ),
              onPressed: model.isLoading
                  ? null
                  : () => _updateFormType(
                      EmailPasswordSignInFormType.forgotPassword),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        onBack: () => Navigator.pop(context),
        titleText: model.title,
        color: orange3,
      ),
      backgroundColor: backgroundGrey,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: _buildContent(),
        ),
      ),
    );
  }
}
