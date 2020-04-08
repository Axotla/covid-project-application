import 'package:covidapp/src/blocs/authentication/authentication_base.dart';
import 'package:covidapp/src/blocs/sign_up/sign_up_form_bloc.dart';
import 'package:covidapp/src/core/custom_localization.dart';
import 'package:covidapp/src/ui/screens/legal/legal_screen.dart';
import 'package:covidapp/src/ui/widgets/app_raised_rounded_button/app_raised_rounded_button_widget.dart';
import 'package:covidapp/src/ui/widgets/app_snack_bar/app_sback_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class SignUpFormWidget extends StatelessWidget {
  SignUpFormWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppSnackBarHandler appSnackBarHandler = AppSnackBarHandler(context);
    final SignUpFormBloc signUpFormBloc = BlocProvider.of<SignUpFormBloc>(context);

    final double widthTextField = MediaQuery.of(context).size.width / 6.0;
    final double heightSpace = ((MediaQuery.of(context).size.height / 5.0) * 2.0) / 18.0;
    final double heightButton = ((MediaQuery.of(context).size.height / 5.0) * 2.0) / 6.0;
    final double sizeContainer = MediaQuery.of(context).size.width - widthTextField;

    return Builder(
      builder: (context) {
        return FormBlocListener<SignUpFormBloc, String, String>(
          onSubmitting: (context, state) {
            appSnackBarHandler.showSnackBar(AppSnackBarWidget.load(
              text: CustomLocalization.of(context).translate(
                  'sign_up_snackbar_loading'),
            ));
          },
          onSuccess: (context, state) {
            BlocProvider.of<AuthenticationBloc>(context)
                .add(AuthenticationEvent.AuthenticationLoggedIn);
            Navigator.of(context).pop();
          },
          onFailure: (context, state) {
            appSnackBarHandler.showSnackBar(AppSnackBarWidget.failure(
                text: CustomLocalization.of(context).translate(
                    state.failureResponse),
            ));
          },
          child: Form(
            child: Column(
              children: <Widget>[
                Container(
                  width: sizeContainer,
                  child: TextFieldBlocBuilder(
                    textFieldBloc: signUpFormBloc.email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: CustomLocalization.of(context).translate(
                          'sign_in_placeholder_email'),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ),
                SizedBox(height: heightSpace),
                Container(
                  width: sizeContainer,
                  child: TextFieldBlocBuilder(
                    textFieldBloc: signUpFormBloc.password,
                    suffixButton: SuffixButton.obscureText,
                    decoration: InputDecoration(
                      labelText: CustomLocalization.of(context).translate(
                          'sign_in_placeholder_password'),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                ),
                SizedBox(height: heightSpace),
                Container(
                  width: sizeContainer,
                  child: InkWell(
                    child: Text(CustomLocalization.of(context).translate(
                        'sign_up_label_read_terms_and_conditions'),
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return LegalScreen();
                        }));
                    },
                  ),
                ),
                SizedBox(height: heightSpace),
                Container(
                  width: sizeContainer,
                  child: CheckboxFieldBlocBuilder(
                    booleanFieldBloc: signUpFormBloc.accepted,
                    body: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(CustomLocalization.of(context).translate(
                          'sign_up_label_accept_terms_and_conditions')),
                    ),
                  ),
                ),
                SizedBox(height: heightSpace),
                AppRaisedRoundedButtonWidget(
                  text: CustomLocalization.of(context).translate(
                      'sign_up_button_sign_up'),
                  height: heightButton,
                  width: sizeContainer,
                  onPressed: signUpFormBloc.submit,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}