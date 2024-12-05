import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../di/injection.dart';
import '../../model/user.dart';
import '../../utils/export_utils.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/snackbar_widget.dart';
import '../../widgets/text_field_widget.dart';
import '../home/home_screen.dart';
import '../register/register_screen.dart';
import 'cubit/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool _isHidePassword = true;
  late final LoginCubit _cubit;
  late final LoadingDialog _loadingDialog;

  @override
  void initState() {
    _cubit = getIt<LoginCubit>();
    _loadingDialog = getIt<LoadingDialog>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        Constants.appName,
        showBackButton: false,
      ),
      body: BlocListener<LoginCubit, LoginState>(
        bloc: _cubit,
        listener: (BuildContext context, LoginState state) {
          logger.d('LoginState: $state');
          _loadingDialog.show(context, state.isLoading);

          if (state.isSuccess) {
            AppRoute.clearAll(const HomeScreen());
          }

          if (state.isError) {
            context.snackbar.showSnackBar(SnackbarWidget(
              state.message,
              context,
              state: SnackbarState.error,
            ));
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  width: context.mediaSize.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w700),
                      ),
                      Text.rich(TextSpan(children: <InlineSpan>[
                        const TextSpan(
                          text: "Don't have an account? ",
                        ),
                        TextSpan(
                            text: 'Sign Up.',
                            style: const TextStyle(
                              color: Colors.blue,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap =
                                  () => AppRoute.to(const RegisterScreen())),
                      ]))
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFieldWidget(
                          'email',
                          label: 'Email',
                          textInputAction: TextInputAction.next,
                          validators: <String? Function(String? p1)>[
                            FormBuilderValidators.required(),
                            FormBuilderValidators.email()
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFieldWidget(
                          'password',
                          label: 'Password',
                          obscureText: _isHidePassword,
                          textInputAction: TextInputAction.go,
                          suffixIcon: IconButton(
                            onPressed: () => setState(
                                () => _isHidePassword = !_isHidePassword),
                            icon: Icon(
                              _isHidePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          onSubmitted: (String? value) => _onLogin(),
                          validators: <String? Function(String? p1)>[
                            FormBuilderValidators.required()
                          ],
                        ),
                        const SizedBox(height: 32),
                        FilledButton(
                          onPressed: _onLogin,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                          ),
                          child: const Text('Login'),
                        )
                      ],
                    )),
              ))
            ],
          ),
        ),
      ),
    );
  }

  void _onLogin() {
    final FormBuilderState? formKeyState = _formKey.currentState;
    if (formKeyState == null || !formKeyState.validate()) return;
    formKeyState.save();

    User user = User.fromJson(formKeyState.value);
    user = user.copyWith(username: user.username?.toLowerCase());

    logger.d(user);
    _cubit.login(user);
  }
}
