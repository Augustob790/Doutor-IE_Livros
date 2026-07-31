import 'package:doutor_ie_test/base_routes.dart';
import 'package:doutor_ie_test/core/i18n/i18n_loader.dart';
import 'package:doutor_ie_test/core/i18n/strings_pt.dart';
import 'package:doutor_ie_test/core/utils/app_validators.dart';
import 'package:doutor_ie_test/modules/auth/auth_string_keys.dart';
import 'package:doutor_ie_test/modules/auth/string_pt.dart';
import 'package:doutor_ie_test/modules/auth/ui/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _i18n = I18nLoader(<String, Map<String, String>>{
    'pt': <String, String>{...stringsPt, ...authStringsPt},
  });
  final form = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!form.currentState!.validate()) return;
    final ok = await widget.viewModel.login(email.text, password.text);
    if (ok && mounted) context.go(AppRoutesPath.books);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: form,
                    child: ListenableBuilder(
                      listenable: widget.viewModel,
                      builder: (context, _) {
                        final vm = widget.viewModel;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(_i18n.getText(AuthStringKeys.appTitle),
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: email,
                              decoration: InputDecoration(
                                  labelText:
                                      _i18n.getText(AuthStringKeys.email)),
                              validator: (value) => AppValidators.email(value,
                                  message: _i18n
                                      .getText(AuthStringKeys.invalidEmail)),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: password,
                              obscureText: true,
                              decoration: InputDecoration(
                                  labelText:
                                      _i18n.getText(AuthStringKeys.password)),
                              validator: AppValidators.password,
                            ),
                            if (vm.errorMessage != null)
                              Text(vm.errorMessage!,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error)),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: vm.isLoading ? null : submit,
                              child: Text(vm.isLoading
                                  ? _i18n.getText(AuthStringKeys.signingIn)
                                  : _i18n.getText(AuthStringKeys.signIn)),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
