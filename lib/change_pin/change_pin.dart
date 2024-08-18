import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:velocity_x/velocity_x.dart';

import '../home/widget/longa_scaffold.dart';
import '../utility/longa_lotto_pos_screens.dart';
import '../utility/rounded_container.dart';
import '../utility/user_info.dart';
import '../utility/widgets/longa_lotto_pos_text_field_underline.dart';
import '../utility/widgets/shake_animation.dart';
import '../utility/widgets/show_snackbar.dart';
import 'bloc/change_pin_bloc.dart';
import 'bloc/change_pin_event.dart';
import 'bloc/change_pin_state.dart';

class ChangePin extends StatefulWidget {
  const ChangePin({Key? key}) : super(key: key);

  @override
  State<ChangePin> createState() => _ChangePinState();
}

final _changePinForm = GlobalKey<FormState>();
var autoValidate = AutovalidateMode.disabled;
ShakeController oldPasswordController = ShakeController();
TextEditingController oldPasswordTextEditController = TextEditingController();

ShakeController newPasswordController = ShakeController();
TextEditingController newPasswordTextEditController = TextEditingController();

ShakeController confirmPasswordController = ShakeController();
TextEditingController confirmPasswordTextEditController =
    TextEditingController();

bool newPassword = true;
bool confirmPassword = true;
bool loading = false;

class _ChangePinState extends State<ChangePin> {
  @override
  Widget build(BuildContext context) {
    var body = Form(
      key: _changePinForm,
      autovalidateMode: autoValidate,
      child: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                _oldPassword(),
                _spacer(),
                _newPassword(),
                _spacer(),
                _confirmPassword(),
                loading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 38),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Container(),
              ],
            ).pOnly(top: 10, left: 10, right: 10, bottom: 10),
            _submitButton(),
          ],
        ),
      ]),
    );
    return BlocListener<ChangePinBloc, ChangePinState>(
        listener: (context, state) {
          setState(() {
            if (state is ChangePinLoading) {
              loading = true;
            } else if (state is ChangePinError) {
              loading = false;
              ShowToast.showToast(context, state.errorMessage.toString(),
                  type: ToastType.ERROR);
            } else if (state is ChangePinSuccess) {
              loading = false;
              ShowToast.showToast(
                  context, context.l10n.password_has_been_changed_successFully,
                  type: ToastType.SUCCESS);
              UserInfo.logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LongaLottoPosScreen.loginScreen,
                  (Route<dynamic> route) => false);
            }
          });
        },
        child: LongaScaffold(
          showAppBar: true,
          resizeToAvoidBottomInset: false,
          appBarTitle: context.l10n.change_pin,
          extendBodyBehindAppBar: true,
          body: RoundedContainer(child: body),
        ));
  }

  _oldPassword() {
    return ShakeWidget(
      controller: oldPasswordController,
      child: LongaLottoPosTextFieldUnderline(
        maxLength: 16,
        inputType: TextInputType.text,
        hintText: context.l10n.old_password,
        controller: oldPasswordTextEditController,
      ),
    );
  }

  _newPassword() {
    return ShakeWidget(
      controller: newPasswordController,
      child: LongaLottoPosTextFieldUnderline(
        maxLength: 16,
        inputType: TextInputType.text,
        hintText: context.l10n.new_password,
        controller: newPasswordTextEditController,
        obscureText: newPassword,
        suffixIcon: IconButton(
          icon: Icon(
            newPassword ? Icons.visibility_off : Icons.remove_red_eye_rounded,
            color: LongaLottoPosColor.black_four,
          ),
          onPressed: () {
            setState(() {
              newPassword = !newPassword;
            });
          },
        ),
      ),
    );
  }

  _confirmPassword() {
    return ShakeWidget(
      controller: confirmPasswordController,
      child: LongaLottoPosTextFieldUnderline(
        maxLength: 16,
        inputType: TextInputType.text,
        hintText: context.l10n.confirm_password,
        controller: confirmPasswordTextEditController,
        obscureText: confirmPassword,
        suffixIcon: IconButton(
          icon: Icon(
            confirmPassword
                ? Icons.visibility_off
                : Icons.remove_red_eye_rounded,
            color: LongaLottoPosColor.black_four,
          ),
          onPressed: () {
            setState(() {
              confirmPassword = !confirmPassword;
            });
          },
        ),
      ),
    );
  }

  _submitButton() {
    return GestureDetector(
      onTap: () {
        if (_changePinForm.currentState!.validate()) {
          var oldPassword = oldPasswordTextEditController.text.trim();
          var newPassword = newPasswordTextEditController.text.trim();
          var confirmPassword = confirmPasswordTextEditController.text.trim();

          BlocProvider.of<ChangePinBloc>(context).add(ChangePinApi(
              context: context,
              oldPassword: oldPassword,
              newPassword: newPassword,
              confirmPassword: confirmPassword));
        } else {
          setState(() {
            autoValidate = AutovalidateMode.onUserInteraction;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 80),
        color: LongaLottoPosColor.tomato,
        width: double.infinity,
        height: 50,
        child: Center(
          child: Text(
            context.l10n.proceed,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: LongaLottoPosColor.white,
            ),
          ),
        ),
      ),
    );
  }

  _spacer() {
    return const SizedBox(height: 10);
  }
}
