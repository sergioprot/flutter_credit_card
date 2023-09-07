import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({
    Key? key,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    this.obscureCvv = false,
    this.obscureNumber = false,
    required this.onCreditCardModelChange,
    required this.themeColor,
    this.textColor = Colors.black,
    this.cursorColor,
    this.cardHolderDecoration = const InputDecoration(
      labelText: 'Card holder',
    ),
    this.cardNumberDecoration = const InputDecoration(
      labelText: 'Card number',
      hintText: 'XXXX XXXX XXXX XXXX',
    ),
    this.expiryDateDecoration = const InputDecoration(
      labelText: 'Expired Date',
      hintText: 'MM/YY',
    ),
    this.cvvCodeDecoration = const InputDecoration(
      labelText: 'CVV',
      hintText: 'XXX',
    ),
    required this.formKey,
    this.cardNumberKey,
    this.cardHolderKey,
    this.expiryDateKey,
    this.cvvCodeKey,
    this.cvvValidationMessage = 'Please input a valid CVV',
    this.dateValidationMessage = 'Please input a valid date',
    this.numberValidationMessage = 'Please input a valid number',
    this.isHolderNameVisible = true,
    this.isCardNumberVisible = true,
    this.isExpiryDateVisible = true,
    this.enableCvv = true,
    this.autovalidateMode,
    this.cardNumberValidator,
    this.expiryDateValidator,
    this.cvvValidator,
    this.cardHolderValidator,
    this.onFormComplete,
    this.disableCardNumberAutoFillHints = false,
    this.labelStyle,
    this.cardNumberLabel,
    this.expiryDateLabel,
    this.cvvCodeLabel,
    this.cardHolderLabel,
    this.inputVerticalPadding = 16.0,
    this.horizontalPaddingBetweenInputs = 32.0,
    this.labelPadding = 8.0,
    this.inputTextStyle,
  }) : super(key: key);

  /// A string indicating card number in the text field.
  final String cardNumber;

  /// A string indicating expiry date in the text field.
  final String expiryDate;

  /// A string indicating card holder name in the text field.
  final String cardHolderName;

  /// A string indicating cvv code in the text field.
  final String cvvCode;

  /// Error message string when invalid cvv is entered.
  final String cvvValidationMessage;

  /// Error message string when invalid expiry date is entered.
  final String dateValidationMessage;

  /// Error message string when invalid credit card number is entered.
  final String numberValidationMessage;

  /// Provides callback when there is any change in [CreditCardModel].
  final void Function(CreditCardModel) onCreditCardModelChange;

  /// Color of the theme of the credit card form.
  final Color themeColor;

  /// Color of text in the credit card form.
  final Color textColor;

  /// Cursor color in the credit card form.
  final Color? cursorColor;

  /// When enabled cvv gets hidden with obscuring characters. Defaults to
  /// false.
  final bool obscureCvv;

  /// When enabled credit card number get hidden with obscuring characters.
  /// Defaults to false.
  final bool obscureNumber;

  /// Allow editing the holder name by enabling this in the credit card form.
  /// Defaults to true.
  final bool isHolderNameVisible;

  /// Allow editing the credit card number by enabling this in the credit
  /// card form. Defaults to true.
  final bool isCardNumberVisible;

  /// Allow editing the cvv code by enabling this in the credit card form.
  /// Defaults to true.
  final bool enableCvv;

  /// Allows editing the expiry date by enabling this in the credit
  /// card form. Defaults to true.
  final bool isExpiryDateVisible;

  /// A form state key for this credit card form.
  final GlobalKey<FormState> formKey;

  /// Provides a callback when text field provides callback in
  /// [onEditingComplete].
  final Function? onFormComplete;

  /// A FormFieldState key for card number text field.
  final GlobalKey<FormFieldState<String>>? cardNumberKey;

  /// A FormFieldState key for card holder text field.
  final GlobalKey<FormFieldState<String>>? cardHolderKey;

  /// A FormFieldState key for expiry date text field.
  final GlobalKey<FormFieldState<String>>? expiryDateKey;

  /// A FormFieldState key for cvv code text field.
  final GlobalKey<FormFieldState<String>>? cvvCodeKey;

  /// Provides decoration to card number text field.
  final InputDecoration cardNumberDecoration;

  /// Provides decoration to card holder text field.
  final InputDecoration cardHolderDecoration;

  /// Provides decoration to expiry date text field.
  final InputDecoration expiryDateDecoration;

  /// Provides decoration to cvv code text field.
  final InputDecoration cvvCodeDecoration;

  /// Used to configure the auto validation of [FormField] and [Form] widgets.
  final AutovalidateMode? autovalidateMode;

  final TextStyle? labelStyle;
  final String? cardNumberLabel;
  final String? expiryDateLabel;
  final String? cvvCodeLabel;
  final String? cardHolderLabel;

  /// A validator for card number text field.
  final String? Function(String?)? cardNumberValidator;

  /// A validator for expiry date text field.
  final String? Function(String?)? expiryDateValidator;

  /// A validator for cvv code text field.
  final String? Function(String?)? cvvValidator;

  /// A validator for card holder text field.
  final String? Function(String?)? cardHolderValidator;

  /// Setting this flag to true will disable autofill hints for Credit card
  /// number text field. Flutter has a bug when auto fill hints are enabled for
  /// credit card numbers it shows keyboard with characters. But, disabling
  /// auto fill hints will show correct keyboard.
  ///
  /// Defaults to false.
  ///
  /// You can follow the issue here
  /// [https://github.com/flutter/flutter/issues/104604](https://github.com/flutter/flutter/issues/104604).
  final bool disableCardNumberAutoFillHints;

  final double inputVerticalPadding;
  final double horizontalPaddingBetweenInputs;
  final double labelPadding;
  final TextStyle? inputTextStyle;

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  late String cardNumber;
  late String expiryDate;
  late String cardHolderName;
  late String cvvCode;
  bool isCvvFocused = false;
  late Color themeColor;

  late void Function(CreditCardModel) onCreditCardModelChange;
  late CreditCardModel creditCardModel;

  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '0000');

  FocusNode cvvFocusNode = FocusNode();
  FocusNode expiryDateNode = FocusNode();
  FocusNode cardHolderNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel.isCvvFocused = cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    cardNumber = widget.cardNumber;
    expiryDate = widget.expiryDate;
    cardHolderName = widget.cardHolderName;
    cvvCode = widget.cvvCode;

    creditCardModel = CreditCardModel(
        cardNumber, expiryDate, cardHolderName, cvvCode, isCvvFocused);
  }

  @override
  void initState() {
    super.initState();

    createCreditCardModel();

    _cardNumberController.text = widget.cardNumber;
    _expiryDateController.text = widget.expiryDate;
    _cardHolderNameController.text = widget.cardHolderName;
    _cvvCodeController.text = widget.cvvCode;

    onCreditCardModelChange = widget.onCreditCardModelChange;

    cvvFocusNode.addListener(textFieldFocusDidChange);
  }

  @override
  void dispose() {
    cardHolderNode.dispose();
    cvvFocusNode.dispose();
    expiryDateNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: themeColor.withOpacity(0.8),
        primaryColorDark: themeColor,
      ),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: <Widget>[
            Visibility(
              visible: widget.isCardNumberVisible,
              child: Container(
                // padding: const EdgeInsets.symmetric(vertical: 8.0),
                // margin: const EdgeInsets.only(left: 0, top: 16, right: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (widget.cardNumberLabel != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: widget.labelPadding),
                        child: Text(
                          widget.cardNumberLabel!,
                          style: widget.labelStyle,
                        ),
                      ),
                    TextFormField(
                      key: widget.cardNumberKey,
                      obscureText: widget.obscureNumber,
                      controller: _cardNumberController,
                      onChanged: (String value) {
                        setState(() {
                          cardNumber = _cardNumberController.text;
                          creditCardModel.cardNumber = cardNumber;
                          onCreditCardModelChange(creditCardModel);
                        });
                        if (value.length == 19) {
                          FocusScope.of(context).requestFocus(cardHolderNode);
                        }
                      },
                      cursorColor: widget.cursorColor ?? themeColor,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(cardHolderNode);
                      },
                      style: widget.inputTextStyle,
                      decoration: widget.cardNumberDecoration,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      autofillHints: widget.disableCardNumberAutoFillHints
                          ? null
                          : const <String>[AutofillHints.creditCardNumber],
                      autovalidateMode: widget.autovalidateMode,
                      validator: widget.cardNumberValidator ??
                          (String? value) {
                            // Validate less that 13 digits +3 white spaces
                            if (value!.isEmpty || value.length < 16) {
                              return widget.numberValidationMessage;
                            }
                            return null;
                          },
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: widget.isHolderNameVisible,
              child: Container(
                // padding: const EdgeInsets.symmetric(vertical: 8.0),
                margin: EdgeInsets.only(
                    left: 0, top: widget.inputVerticalPadding, right: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (widget.cardHolderLabel != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: widget.labelPadding),
                        child: Text(
                          widget.cardHolderLabel!,
                          style: widget.labelStyle,
                        ),
                      ),
                    TextFormField(
                      key: widget.cardHolderKey,
                      controller: _cardHolderNameController,
                      onChanged: (String value) {
                        setState(() {
                          cardHolderName = _cardHolderNameController.text;
                          creditCardModel.cardHolderName = cardHolderName;
                          onCreditCardModelChange(creditCardModel);
                        });
                      },
                      cursorColor: widget.cursorColor ?? themeColor,
                      focusNode: cardHolderNode,
                      style: widget.inputTextStyle,
                      decoration: widget.cardHolderDecoration,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      autofillHints: const <String>[
                        AutofillHints.creditCardName
                      ],
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(expiryDateNode);
                        onCreditCardModelChange(creditCardModel);
                      },
                      validator: widget.cardHolderValidator,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Visibility(
                  visible: widget.isExpiryDateVisible,
                  child: Expanded(
                    child: Container(
                      // padding: const EdgeInsets.symmetric(vertical: 8.0),
                      margin: EdgeInsets.only(
                        left: 0,
                        top: widget.inputVerticalPadding,
                        right: widget.horizontalPaddingBetweenInputs / 2,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (widget.expiryDateLabel != null)
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: widget.labelPadding),
                              child: Text(
                                widget.expiryDateLabel!,
                                style: widget.labelStyle,
                              ),
                            ),
                          TextFormField(
                            key: widget.expiryDateKey,
                            controller: _expiryDateController,
                            onChanged: (String value) {
                              if (_expiryDateController.text
                                  .startsWith(RegExp('[2-9]'))) {
                                _expiryDateController.text =
                                    '0' + _expiryDateController.text;
                              }
                              setState(() {
                                expiryDate = _expiryDateController.text;
                                creditCardModel.expiryDate = expiryDate;
                                onCreditCardModelChange(creditCardModel);
                              });
                              if (value.length >= 5) {
                                FocusScope.of(context)
                                    .requestFocus(cvvFocusNode);
                              }
                            },
                            cursorColor: widget.cursorColor ?? themeColor,
                            focusNode: expiryDateNode,
                            onEditingComplete: () {
                              FocusScope.of(context).requestFocus(cvvFocusNode);
                            },
                            style: widget.inputTextStyle,
                            decoration: widget.expiryDateDecoration,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            autofillHints: const <String>[
                              AutofillHints.creditCardExpirationDate
                            ],
                            validator: widget.expiryDateValidator ??
                                (String? value) {
                                  if (value!.isEmpty) {
                                    return widget.dateValidationMessage;
                                  }
                                  final DateTime now = DateTime.now();
                                  final List<String> date =
                                      value.split(RegExp(r'/'));
                                  final int month = int.parse(date.first);
                                  final int year = int.parse('20${date.last}');
                                  final int lastDayOfMonth = month < 12
                                      ? DateTime(year, month + 1, 0).day
                                      : DateTime(year + 1, 1, 0).day;
                                  final DateTime cardDate = DateTime(year,
                                      month, lastDayOfMonth, 23, 59, 59, 999);

                                  if (cardDate.isBefore(now) ||
                                      month > 12 ||
                                      month == 0) {
                                    return widget.dateValidationMessage;
                                  }
                                  return null;
                                },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    // padding: const EdgeInsets.symmetric(vertical: 8.0),
                    margin: EdgeInsets.only(
                      left: widget.horizontalPaddingBetweenInputs / 2,
                      top: widget.inputVerticalPadding,
                      right: 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (widget.cvvCodeLabel != null)
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: widget.labelPadding),
                            child: Text(
                              widget.cvvCodeLabel!,
                              style: widget.labelStyle,
                            ),
                          ),
                        TextFormField(
                          key: widget.cvvCodeKey,
                          obscureText: widget.obscureCvv,
                          focusNode: cvvFocusNode,
                          controller: _cvvCodeController,
                          cursorColor: widget.cursorColor ?? themeColor,
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                            onCreditCardModelChange(creditCardModel);
                            if (widget.onFormComplete != null) {
                              widget.onFormComplete!();
                            }
                          },
                          style: widget.inputTextStyle,
                          decoration: widget.cvvCodeDecoration,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          autofillHints: const <String>[
                            AutofillHints.creditCardSecurityCode
                          ],
                          onChanged: (String text) {
                            setState(() {
                              cvvCode = text;
                              creditCardModel.cvvCode = cvvCode;
                              onCreditCardModelChange(creditCardModel);
                            });
                            if (text.length >= 3) {
                              FocusScope.of(context).unfocus();
                              onCreditCardModelChange(creditCardModel);
                              if (widget.onFormComplete != null) {
                                widget.onFormComplete!();
                              }
                            }
                          },
                          validator: widget.cvvValidator ??
                              (String? value) {
                                if (value!.isEmpty || value.length < 3) {
                                  return widget.cvvValidationMessage;
                                }
                                return null;
                              },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
