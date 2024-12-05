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
import 'cubit/register_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool _isHidePassword = true;
  late final RegisterCubit _cubit;
  late final LoadingDialog _loadingDialog;

  @override
  void initState() {
    _cubit = getIt<RegisterCubit>();
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
      body: BlocListener<RegisterCubit, RegisterState>(
        bloc: _cubit,
        listener: (BuildContext context, RegisterState state) {
          logger.d('RegisterState: $state');
          final RegisterState(:String message) = state;
          _loadingDialog.show(context, state.isLoading);

          if (state.isSuccess) {
            _formKey.currentState?.reset();
            context.snackbar.showSnackBar(
                SnackbarWidget(message, context, state: SnackbarState.success));
            AppRoute.back();
          }

          if (state.isError) {
            context.snackbar.showSnackBar(
                SnackbarWidget(message, context, state: SnackbarState.error));
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
                        'Register',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w700),
                      ),
                      Text.rich(TextSpan(children: <InlineSpan>[
                        const TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'Login.',
                          style: const TextStyle(
                            color: Colors.blue,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => AppRoute.back(),
                        ),
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
                          'username',
                          label: 'Username',
                          textInputAction: TextInputAction.next,
                          validators: <String? Function(String? p1)>[
                            FormBuilderValidators.required(),
                            FormBuilderValidators.username()
                          ],
                        ),
                        const SizedBox(height: 16),
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
                            FormBuilderValidators.required(),
                            FormBuilderValidators.password(
                                minUppercaseCount: 0, minSpecialCharCount: 0)
                          ],
                        ),
                        const SizedBox(height: 32),
                        FilledButton(
                          onPressed: _onLogin,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                          ),
                          child: const Text('Register'),
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
    _cubit.register(user);
  }
}
