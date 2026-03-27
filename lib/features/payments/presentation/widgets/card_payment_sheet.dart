import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/buttons/custom_button.dart';
import '../../../../core/widgets/text/app_text.dart';

enum _CardBrand { unknown, visa, mastercard, verve }

class CardPaymentSheet extends StatefulWidget {
  const CardPaymentSheet({
    super.key,
    required this.amount,
    required this.email,
    required this.reference,
    required this.publicKey,
  });

  final double amount;
  final String email;
  final String reference;
  final String publicKey;

  /// Shows the bottom sheet. Returns `true` when payment succeeds.
  static Future<bool> show(
    BuildContext context, {
    required double amount,
    required String email,
    required String reference,
    required String publicKey,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CardPaymentSheet(
        amount: amount,
        email: email,
        reference: reference,
        publicKey: publicKey,
      ),
    );
    return result == true;
  }

  @override
  State<CardPaymentSheet> createState() => _CardPaymentSheetState();
}

class _CardPaymentSheetState extends State<CardPaymentSheet> {
  final _formKey = GlobalKey<FormState>();
  final _numberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _expiryFocus = FocusNode();
  final _cvvFocus = FocusNode();
  final _nameFocus = FocusNode();
  final _plugin = PaystackPlugin();

  bool _isProcessing = false;
  String? _error;
  _CardBrand _brand = _CardBrand.unknown;

  @override
  void initState() {
    super.initState();
    _plugin.initialize(publicKey: widget.publicKey);
    _numberCtrl.addListener(_detectBrand);
  }

  @override
  void dispose() {
    _numberCtrl.removeListener(_detectBrand);
    _numberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _nameCtrl.dispose();
    _expiryFocus.dispose();
    _cvvFocus.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  void _detectBrand() {
    final digits = _numberCtrl.text.replaceAll(' ', '');
    if (digits.isEmpty) {
      setState(() => _brand = _CardBrand.unknown);
      return;
    }
    setState(() {
      switch (digits[0]) {
        case '4':
          _brand = _CardBrand.visa;
        case '5':
          _brand = _CardBrand.mastercard;
        case '6':
          _brand = _CardBrand.verve;
        default:
          _brand = _CardBrand.unknown;
      }
    });
  }

  Future<void> _pay() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isProcessing = true;
      _error = null;
    });

    try {
      final number = _numberCtrl.text.replaceAll(' ', '');
      final expParts = _expiryCtrl.text.split('/');
      final month = int.tryParse(expParts.first.trim()) ?? 0;
      final year = expParts.length > 1
          ? (int.tryParse(expParts.last.trim()) ?? 0)
          : 0;

      final charge = Charge()
        ..amount = (widget.amount * 100).toInt()
        ..email = widget.email
        ..reference = widget.reference
        ..card = PaymentCard(
          number: number,
          cvc: _cvvCtrl.text.trim(),
          expiryMonth: month,
          expiryYear: year,
        );

      final response = await _plugin.chargeCard(context, charge: charge);
      if (!mounted) return;

      if (response.status) {
        Navigator.pop(context, true);
      } else {
        setState(() {
          _isProcessing = false;
          _error = response.message.isNotEmpty
              ? response.message
              : 'Payment was not completed';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _error = 'Payment failed. Please check your card details and try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: inset),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXLarge),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.spacing24,
                AppDimensions.spacing8,
                AppDimensions.spacing24,
                AppDimensions.spacing24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHandle(),
                  _buildHeader(),
                  const SizedBox(height: AppDimensions.spacing20),
                  _buildCardPreview(),
                  const SizedBox(height: AppDimensions.spacing24),
                  _buildCardNumberField(),
                  const SizedBox(height: AppDimensions.spacing16),
                  Row(
                    children: [
                      Expanded(child: _buildExpiryField()),
                      const SizedBox(width: AppDimensions.spacing12),
                      Expanded(child: _buildCvvField()),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  _buildNameField(),
                  if (_error != null) ...[
                    const SizedBox(height: AppDimensions.spacing12),
                    _buildErrorBanner(),
                  ],
                  const SizedBox(height: AppDimensions.spacing24),
                  CustomButton.secondary(
                    text:
                        '${AppStrings.payNow}  ${CurrencyFormatter.format(widget.amount)}',
                    onPressed: _pay,
                    isLoading: _isProcessing,
                  ),
                  const SizedBox(height: AppDimensions.spacing12),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_outlined,
                          size: AppDimensions.iconSmall,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppDimensions.spacing4),
                        AppText(
                          AppStrings.securePayment,
                          fontSize: AppTypography.fontSize12,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: AppDimensions.spacing40,
        height: AppDimensions.spacing4,
        margin: const EdgeInsets.only(bottom: AppDimensions.spacing20),
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacing10),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(20),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock_outline_rounded,
            color: AppColors.primary,
            size: AppDimensions.iconSmall20,
          ),
        ),
        const SizedBox(width: AppDimensions.spacing12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              AppStrings.payWithCard,
              fontSize: AppTypography.fontSize16,
              fontWeight: AppTypography.weightBold,
              color: AppColors.textPrimary,
            ),
            AppText(
              AppStrings.securePayment,
              fontSize: AppTypography.fontSize12,
              color: AppColors.textSecondary,
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing12,
            vertical: AppDimensions.spacing6,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          child: AppText(
            CurrencyFormatter.format(widget.amount),
            fontSize: AppTypography.fontSize14,
            fontWeight: AppTypography.weightBold,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildCardPreview() {
    final rawNum = _numberCtrl.text.replaceAll(' ', '');
    final masked = rawNum.padRight(16, '•');
    final parts = [
      masked.substring(0, 4),
      masked.substring(4, 8),
      masked.substring(8, 12),
      masked.substring(12, 16),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacing20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF1A3A6B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(80),
            blurRadius: AppDimensions.spacing16,
            offset: const Offset(0, AppDimensions.spacing8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.contactless_outlined,
                color: AppColors.white,
                size: AppDimensions.spacing28,
              ),
              _BrandBadge(brand: _brand),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing16),
          AppText(
            parts.join('  '),
            fontSize: AppTypography.fontSize18,
            fontWeight: AppTypography.weightSemiBold,
            color: AppColors.white,
            letterSpacing: 1.5,
          ),
          const SizedBox(height: AppDimensions.spacing12),
          Row(
            children: [
              _CardPreviewLabel(
                label: 'CARD HOLDER',
                value: _nameCtrl.text.isEmpty
                    ? '—'
                    : _nameCtrl.text.toUpperCase(),
              ),
              const SizedBox(width: AppDimensions.spacing24),
              _CardPreviewLabel(
                label: 'EXPIRES',
                value:
                    _expiryCtrl.text.isEmpty ? '—/—' : _expiryCtrl.text,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardNumberField() {
    return _CardField(
      controller: _numberCtrl,
      label: AppStrings.cardNumber,
      hint: AppStrings.cardNumberHint,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _CardNumberFormatter(),
      ],
      maxLength: 19,
      textInputAction: TextInputAction.next,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_expiryFocus),
      suffix: _brand != _CardBrand.unknown
          ? _BrandBadge(brand: _brand, small: true)
          : const Icon(
              Icons.credit_card,
              color: AppColors.textLight,
              size: AppDimensions.iconSmall20,
            ),
      validator: (v) {
        if ((v ?? '').replaceAll(' ', '').length < 16) {
          return 'Enter a valid 16-digit card number';
        }
        return null;
      },
    );
  }

  Widget _buildExpiryField() {
    return _CardField(
      controller: _expiryCtrl,
      focusNode: _expiryFocus,
      label: AppStrings.expiryDate,
      hint: AppStrings.expiryHint,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _ExpiryFormatter(),
      ],
      maxLength: 5,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).requestFocus(_cvvFocus),
      validator: (v) {
        if ((v ?? '').length < 5) return 'Invalid expiry';
        final parts = v!.split('/');
        final month = int.tryParse(parts.first) ?? 0;
        if (month < 1 || month > 12) return 'Invalid month';
        return null;
      },
    );
  }

  Widget _buildCvvField() {
    return _CardField(
      controller: _cvvCtrl,
      focusNode: _cvvFocus,
      label: AppStrings.cvv,
      hint: AppStrings.cvvHint,
      keyboardType: TextInputType.number,
      obscureText: true,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: 4,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).requestFocus(_nameFocus),
      validator: (v) {
        if ((v ?? '').length < 3) return 'Invalid CVV';
        return null;
      },
    );
  }

  Widget _buildNameField() {
    return _CardField(
      controller: _nameCtrl,
      focusNode: _nameFocus,
      label: AppStrings.cardholderName,
      hint: AppStrings.cardholderNameHint,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.characters,
      textInputAction: TextInputAction.done,
      onEditingComplete: _pay,
      validator: (v) {
        if ((v ?? '').trim().isEmpty) return 'Name is required';
        return null;
      },
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing12),
      decoration: BoxDecoration(
        color: AppColors.error.withAlpha(15),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.error.withAlpha(60)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: AppDimensions.iconSmall20,
          ),
          const SizedBox(width: AppDimensions.spacing8),
          Expanded(
            child: AppText(
              _error!,
              fontSize: AppTypography.fontSize13,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

}

// ── Supporting widgets ────────────────────────────────────────────────────────

class _CardPreviewLabel extends StatelessWidget {
  const _CardPreviewLabel({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          fontSize: AppTypography.fontSize10,
          color: AppColors.white.withAlpha(160),
          letterSpacing: 0.5,
        ),
        AppText(
          value,
          fontSize: AppTypography.fontSize13,
          fontWeight: AppTypography.weightSemiBold,
          color: AppColors.white,
        ),
      ],
    );
  }
}

class _BrandBadge extends StatelessWidget {
  const _BrandBadge({required this.brand, this.small = false});
  final _CardBrand brand;
  final bool small;

  @override
  Widget build(BuildContext context) {
    if (brand == _CardBrand.unknown) return const SizedBox.shrink();
    final w = small ? AppDimensions.spacing40 : AppDimensions.spacing52;
    final h = w * 0.6;

    return Container(
      width: w,
      height: h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusTiny),
      ),
      child: brand == _CardBrand.mastercard
          ? _MastercardStack(size: w)
          : Text(
              _label,
              style: TextStyle(
                color: Colors.white,
                fontSize: w * 0.22,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.3,
              ),
            ),
    );
  }

  Color get _bgColor => switch (brand) {
        _CardBrand.visa => const Color(0xFF1A1F71),
        _CardBrand.mastercard => const Color(0xFF252525),
        _CardBrand.verve => const Color(0xFF009A44),
        _ => AppColors.border,
      };

  String get _label => switch (brand) {
        _CardBrand.visa => 'VISA',
        _CardBrand.verve => 'VERVE',
        _ => '',
      };
}

class _MastercardStack extends StatelessWidget {
  const _MastercardStack({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    final r = size * 0.38;
    return SizedBox(
      width: size * 0.7,
      height: r,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: r,
              height: r,
              decoration: const BoxDecoration(
                color: Color(0xFFEB001B),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              width: r,
              height: r,
              decoration: BoxDecoration(
                color: const Color(0xFFF79E1B).withAlpha(220),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardField extends StatelessWidget {
  const _CardField({
    required this.controller,
    required this.label,
    required this.hint,
    this.focusNode,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.inputFormatters,
    this.maxLength,
    this.textInputAction,
    this.onEditingComplete,
    this.suffix,
    this.validator,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final Widget? suffix;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          fontSize: AppTypography.fontSize13,
          fontWeight: AppTypography.weightMedium,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: AppDimensions.spacing6),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          textInputAction: textInputAction,
          onEditingComplete: onEditingComplete,
          validator: validator,
          style: TextStyle(
            fontFamily: AppTypography.defaultFontFamily,
            fontSize: AppTypography.fontSize15,
            fontWeight: AppTypography.weightMedium,
            color: AppColors.textPrimary,
            letterSpacing: 1.0,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: AppTypography.defaultFontFamily,
              fontSize: AppTypography.fontSize14,
              color: AppColors.textLight,
              letterSpacing: 0,
            ),
            suffixIcon: suffix != null
                ? Padding(
                    padding: const EdgeInsets.only(
                        right: AppDimensions.spacing12),
                    child: suffix,
                  )
                : null,
            suffixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            counterText: '',
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing16,
              vertical: AppDimensions.spacing14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              borderSide:
                  const BorderSide(color: AppColors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Input Formatters ──────────────────────────────────────────────────────────

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(' ', '');
    if (digits.length > 16) return oldValue;
    final buf = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buf.write(' ');
      buf.write(digits[i]);
    }
    final text = buf.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll('/', '');
    if (digits.length > 4) digits = digits.substring(0, 4);
    final text = digits.length > 2
        ? '${digits.substring(0, 2)}/${digits.substring(2)}'
        : digits;
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
