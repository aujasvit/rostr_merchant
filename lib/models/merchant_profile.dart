import 'package:rostr_merchant/models/merchant.dart';

class MerchantProfile {
  Merchant merchant;
  String relayUrl;
  MerchantProfile({required this.merchant, required this.relayUrl});

  factory MerchantProfile.fromJSON(Map<String, Object?> json) {
    final merchant = Merchant(
      name: json[nameColumn] as String,
      latitude: json[latitudeColumn] as double,
      longitude: json[longitudeColumn] as double,
      description: json[descriptionColumn] as String,
      pricing: json[priceColumn] as String,
      contactDetails: json[contactDetailColumn] as Map<String, dynamic>,
      pubkey: json[pubkeyColumn] as String,
    );

    return MerchantProfile(
      merchant: merchant,
      relayUrl: json['relayUrl'] as String,
    );
  }

  @override
  String toString() {
    return "MerchantProfile, merchant: ${merchant.toString()}, relayUrl: $relayUrl";
  }

  @override
  bool operator ==(covariant MerchantProfile other) {
    return relayUrl == other.relayUrl;
  }

  @override
  int get hashCode {
    return relayUrl.hashCode;
  }

  Map<String, Object?> toJSON() {
    return {
      nameColumn: merchant.name,
      latitudeColumn: merchant.latitude,
      longitudeColumn: merchant.longitude,
      descriptionColumn: merchant.description,
      priceColumn: merchant.pricing,
      contactDetailColumn: merchant.contactDetails,
      relayUrlColumn: relayUrl,
    };
  }
}

const String relayUrlColumn = 'relayUrl';
const String urlColumn = 'url';
const String nameColumn = 'name';
const String latminColumn = 'latmin';
const String longminColumn = 'longmin';
const String latmaxColumn = 'latmax';
const String longmaxColumn = 'longmax';
const String descriptionColumn = 'description';
const String statusColumn = 'status';
const String contactDetailColumn = 'contactDetail';
const String latitudeColumn = 'latitude';
const String longitudeColumn = 'longitude';
const String priceColumn = 'price';
const String merchantTypeColumn = 'merchantType';
