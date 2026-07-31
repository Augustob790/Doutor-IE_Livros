import 'package:doutor_ie_test/base_routes.dart';
import 'package:doutor_ie_test/core/i18n/i18n_loader.dart';
import 'package:doutor_ie_test/core/i18n/strings_pt.dart';
import 'package:doutor_ie_test/core/iod.dart';
import 'package:doutor_ie_test/core/navigator/app_navigator.dart';
import 'package:doutor_ie_test/core/utils/app_validators.dart';
import 'package:doutor_ie_test/core/widgets/app_brand.dart';
import 'package:doutor_ie_test/modules/auth/auth_string_keys.dart';
import 'package:doutor_ie_test/modules/auth/string_pt.dart';
import 'package:doutor_ie_test/modules/auth/ui/login_viewmodel.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AppNavigator _navigator = IoD.instance.get<AppNavigator>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final I18nLoader _i18n = I18nLoader(<String, Map<String, String>>{
    'pt': <String, String>{...stringsPt, ...authStringsPt},
  });
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    widget.viewModel.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final bool authenticated = await widget.viewModel.login(
      _emailController.text,
      _passwordController.text,
    );
    if (authenticated && mounted) _navigator.go(AppRoutesPath.books);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              colors.primaryContainer.withValues(alpha: 0.7),
              Theme.of(context).scaffoldBackgroundColor,
              colors.secondaryContainer.withValues(alpha: 0.5),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool expanded = constraints.maxWidth >= 820;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: expanded ? 40 : 16,
                  vertical: expanded ? 48 : 24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - (expanded ? 96 : 48),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1040),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 10,
                        shadowColor: colors.shadow.withValues(alpha: 0.12),
                        child: IntrinsicHeight(
                          child: Row(
                            children: <Widget>[
                              if (expanded)
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(48),
                                    decoration: BoxDecoration(
                                      color: colors.primary,
                                      backgroundBlendMode: BlendMode.srcOver,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.local_library_rounded,
                                          size: 58,
                                          color: colors.onPrimary,
                                        ),
                                        const SizedBox(height: 32),
                                        Text(
                                          _i18n.getText(
                                              AuthStringKeys.welcomeTitle),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                                  color: colors.onPrimary),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          _i18n.getText(
                                              AuthStringKeys.welcomeSubtitle),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                color: colors.onPrimary
                                                    .withValues(alpha: 0.78),
                                                height: 1.5,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.all(expanded ? 48 : 24),
                                  child: _buildForm(context, expanded),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, bool expanded) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (BuildContext context, Widget? child) {
            final LoginViewModel viewModel = widget.viewModel;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                AppBrand(
                  title: _i18n.getText(AuthStringKeys.appTitle),
                  centered: !expanded,
                ),
                SizedBox(height: expanded ? 38 : 30),
                Text(
                  _i18n.getText(AuthStringKeys.accessTitle),
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: expanded ? TextAlign.start : TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _i18n.getText(AuthStringKeys.accessSubtitle),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                  textAlign: expanded ? TextAlign.start : TextAlign.center,
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _emailController,
                  enabled: !viewModel.isLoading,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const <String>[AutofillHints.username],
                  decoration: InputDecoration(
                    labelText: _i18n.getText(AuthStringKeys.email),
                    hintText: _i18n.getText(AuthStringKeys.emailHint),
                    prefixIcon: const Icon(Icons.mail_outline_rounded),
                  ),
                  validator: (String? value) => AppValidators.email(
                    value,
                    message: _i18n.getText(AuthStringKeys.invalidEmail),
                    requiredMessage:
                        _i18n.getText(AuthStringKeys.requiredEmail),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  enabled: !viewModel.isLoading,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  autofillHints: const <String>[AutofillHints.password],
                  onFieldSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: _i18n.getText(AuthStringKeys.password),
                    hintText: _i18n.getText(AuthStringKeys.passwordHint),
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      tooltip: _i18n.getText(AuthStringKeys.password),
                      onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  validator: (String? value) => AppValidators.password(
                    value,
                    requiredMessage:
                        _i18n.getText(AuthStringKeys.requiredPassword),
                    minLengthMessage:
                        _i18n.getText(AuthStringKeys.shortPassword),
                  ),
                ),
                if (viewModel.errorMessage != null) ...<Widget>[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.errorContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.error_outline,
                            color: colors.onErrorContainer),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            viewModel.errorMessage!,
                            style: TextStyle(color: colors.onErrorContainer),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: viewModel.isLoading ? null : _submit,
                  child: viewModel.isLoading
                      ? SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.onPrimary,
                          ),
                        )
                      : Text(_i18n.getText(AuthStringKeys.signIn)),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.shield_outlined,
                        size: 16, color: colors.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        _i18n.getText(AuthStringKeys.securityCaption),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
