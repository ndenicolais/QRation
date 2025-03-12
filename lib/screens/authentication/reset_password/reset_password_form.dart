import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/utils/validator.dart';
import 'package:qration/widgets/custom_textfield.dart';

class ResetPasswordForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final BuildContext context;
  final TextEditingController emailController;

  const ResetPasswordForm({
    super.key,
    required this.context,
    required this.formKey,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          _buildTextField(
            emailController,
            AppLocalizations.of(context)!.reset_password_form_email,
            AppLocalizations.of(context)!.reset_password_form_email_field,
            MingCuteIcons.mgc_mail_fill,
            TextInputType.emailAddress,
            TextCapitalization.none,
            TextInputAction.done,
            (val) => val?.emailValidationError(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint,
    IconData prefixIcon,
    TextInputType keyboardType,
    TextCapitalization textCapitalization,
    TextInputAction textInputAction,
    String? Function(String?) validator,
  ) {
    return SizedBox(
      width: 320.w,
      child: CustomTextField(
        controller: controller,
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization,
        validator: validator,
      ),
    );
  }
}
