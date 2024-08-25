import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:rostr_merchant/models/merchant.dart';
import 'package:rostr_merchant/models/merchant_profile.dart';
import 'package:sqflite/sqflite.dart';
import 'package:string_validator/string_validator.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class MerchantForm extends ConsumerStatefulWidget {
  final String relayUrl;
  const MerchantForm({super.key, required this.relayUrl});

  @override
  _MerchantFormState createState() => _MerchantFormState(relayUrl: relayUrl);
}

class _MerchantFormState extends ConsumerState<MerchantForm> {
  final _formKey = GlobalKey<FormState>();
  MerchantProfile? merchantProfile;
  final String relayUrl;

  _MerchantFormState({required this.relayUrl});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    merchantProfile = ref.watch(merchantProfilesProvider).firstWhere(
      (element) => element.relayUrl == relayUrl,
      orElse: () {
        return ref.watch(merchantProfilesProvider).firstWhere(
              (element) => element.relayUrl == 'default_relay',
            );
      },
    );

    Map<String, Object> merchantDetails = {
      'name': merchantProfile?.merchant.name ?? '',
      'description': merchantProfile?.merchant.description ?? '',
      'price': merchantProfile?.merchant.pricing ?? '',
      'phoneNumber': merchantProfile?.merchant.contactDetails ?? '',
      // 'merchantType':
      //     merchantProfile?.merchant.merchantType.map((e) => e.index).toList() ??
      //         [],
    };

    // selectedTypes = merchantProfile?.merchant.merchantType ?? [];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(merchantProfile?.relayUrl ?? "Merchant Profile"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Merchant Name',
                  ),
                  textCapitalization: TextCapitalization.words,
                  onSaved: (String? value) {
                    if (value != null && value.isEmpty == false) {
                      merchantDetails['name'] = value;
                    } else {
                      merchantDetails['name'] = '';
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  initialValue: merchantDetails['name'] as String,
                  maxLength: 30,
                ),
                const SizedBox(height: 25),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  onSaved: (String? value) {
                    if (value != null && value.isEmpty == false) {
                      merchantDetails['description'] = value;
                    } else {
                      merchantDetails['description'] = '';
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  maxLines: null,
                  initialValue: merchantDetails['description'] as String,
                ),
                const SizedBox(height: 25),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                  onSaved: (String? value) {
                    if (value != null &&
                        value.isEmpty == false &&
                        isNumeric(value) == true) {
                      merchantDetails['price'] = int.parse(value);
                    } else {
                      merchantDetails['price'] = 0;
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (isNumeric(value) == false) {
                      return 'Please enter a number';
                    }
                    return null;
                  },
                  initialValue: merchantDetails['price'].toString(),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 25),
                IntlPhoneField(
                  initialCountryCode: "IN",
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  onSaved: (PhoneNumber? number) {
                    if (number != null &&
                        number.completeNumber.isEmpty == false) {
                      merchantDetails['phoneNumber'] = number.completeNumber;
                    } else {
                      merchantDetails['phoneNumber'] = '';
                    }
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                  initialValue: merchantDetails['phoneNumber'] as String,
                ),
                const SizedBox(height: 25),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // final merchantTypeInt =
                      //     merchantDetails['merchantType'] as List<int>;
                      // final merchantTypeList = merchantTypeInt
                      //     .map((e) => MerchantType.values[e])
                      //     .toList();
                      Merchant newMerchant = Merchant(
                        pubkey: merchantDetails['pubkey'] as String,
                        name: merchantDetails['name'] as String,
                        description: merchantDetails['description'] as String,
                        pricing: merchantDetails['price'] as String,
                        contactDetails: merchantDetails['phoneNumber']
                            as Map<String, dynamic>,
                        latitude: 0.0,
                        longitude: 0.0,
                      );
                      setState(() {
                        merchantProfile = MerchantProfile(
                          merchant: newMerchant,
                          relayUrl: relayUrl,
                        );
                      });

                      final updateFuture = ref
                          .read(merchantProfilesProvider.notifier)
                          .addMerchantProfile(
                              merchantProfile: MerchantProfile(
                                  merchant: newMerchant, relayUrl: relayUrl));
                      // var futWidget = FutureBuilder(
                      //   future: updateFuture,
                      //   builder: (context, snapshot) {
                      //     if (snapshot.connectionState !=
                      //         ConnectionState.done) {
                      //       return CircularProgressIndicator();
                      //     }
                      //   },
                      // );
                      // Navigator.pop(context);
                      // Navigator.pushAndRemoveUntil(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => futWidget,
                      //     ),
                      //     (route) => route == '/');
                    } else {}
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



              // MultiSelectDropDown(
              //   onOptionSelected: (selectedOptions) {},
              //   options: <ValueItem>[
              //     ValueItem(label: "Food", value: 0),
              //     ValueItem(label: "Items", value: 1),
              //     ValueItem(label: "Cab", value: 2),
              //   ],
              //   controller: _multiSelectController,
              //   selectionType: SelectionType.multi,
              //   chipConfig: const ChipConfig(wrapType: WrapType.wrap),
              //   dropdownHeight: 150,
              //   optionTextStyle: const TextStyle(fontSize: 16),
              //   hint: "Delivery Type",
              //   hintColor: Colors.black,
              //   hintFontSize: 25.0,
              //   selectedOptionIcon: const Icon(Icons.check_circle),
              // )
              //SizedBox(height: 25),
              //TextFormField(
              //  decoration: InputDecoration(
              //    labelText: 'Phone Number',
              //  ),
              //  onSaved: (String? value) {},
              //  validator: (value) {
              //    return null;
              //  },
              //  initialValue: merchantDetails['phoneNumber'] as String,
              //  keyboardType: TextInputType.phone,
              //),
