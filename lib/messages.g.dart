// Autogenerated from Pigeon (v10.1.6), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

enum FlutterJobType {
  enhancedKyc,
}

///  Custom values specific to partners can be placed in [extras]
class FlutterPartnerParams {
  FlutterPartnerParams({
    this.jobType,
    required this.jobId,
    required this.userId,
    this.extras,
  });

  FlutterJobType? jobType;

  String jobId;

  String userId;

  Map<String?, String?>? extras;

  Object encode() {
    return <Object?>[
      jobType?.index,
      jobId,
      userId,
      extras,
    ];
  }

  static FlutterPartnerParams decode(Object result) {
    result as List<Object?>;
    return FlutterPartnerParams(
      jobType: result[0] != null
          ? FlutterJobType.values[result[0]! as int]
          : null,
      jobId: result[1]! as String,
      userId: result[2]! as String,
      extras: (result[3] as Map<Object?, Object?>?)?.cast<String?, String?>(),
    );
  }
}

/// The Auth Smile request. Auth Smile serves multiple purposes:
///
/// - It is used to fetch the signature needed for subsequent API requests
/// - It indicates the type of job that will being performed
/// - It is used to fetch consent information for the partner
///
/// [jobType] The type of job that will be performed
/// [country] The country code of the country where the job is being performed. This value is
/// required in order to get back consent information for the partner
/// [idType] The type of ID that will be used for the job. This value is required in order to
/// get back consent information for the partner
/// [updateEnrolledImage] Whether or not the enrolled image should be updated with image
/// submitted for this job
/// [jobId] The job ID to associate with the job. Most often, this will correspond to a unique
/// Job ID within your own system. If not provided, a random job ID will be generated
/// [userId] The user ID to associate with the job. Most often, this will correspond to a unique
/// User ID within your own system. If not provided, a random user ID will be generated
class FlutterAuthenticationRequest {
  FlutterAuthenticationRequest({
    required this.jobType,
    this.country,
    this.idType,
    this.updateEnrolledImage,
    this.jobId,
    this.userId,
  });

  FlutterJobType jobType;

  String? country;

  String? idType;

  bool? updateEnrolledImage;

  String? jobId;

  String? userId;

  Object encode() {
    return <Object?>[
      jobType.index,
      country,
      idType,
      updateEnrolledImage,
      jobId,
      userId,
    ];
  }

  static FlutterAuthenticationRequest decode(Object result) {
    result as List<Object?>;
    return FlutterAuthenticationRequest(
      jobType: FlutterJobType.values[result[0]! as int],
      country: result[1] as String?,
      idType: result[2] as String?,
      updateEnrolledImage: result[3] as bool?,
      jobId: result[4] as String?,
      userId: result[5] as String?,
    );
  }
}

/// [consentInfo] is only populated when a country and ID type are provided in the
/// [FlutterAuthenticationRequest]. To get information about *all* countries and ID types instead,
///  [SmileIDService.getProductsConfig]
///
/// [timestamp] is *not* a [DateTime] because technically, any arbitrary value could have been
/// passed to it. This applies to all other timestamp fields in the SDK.
class FlutterAuthenticationResponse {
  FlutterAuthenticationResponse({
    required this.success,
    required this.signature,
    required this.timestamp,
    required this.partnerParams,
    this.callbackUrl,
    this.consentInfo,
  });

  bool success;

  String signature;

  String timestamp;

  FlutterPartnerParams partnerParams;

  String? callbackUrl;

  FlutterConsentInfo? consentInfo;

  Object encode() {
    return <Object?>[
      success,
      signature,
      timestamp,
      partnerParams.encode(),
      callbackUrl,
      consentInfo?.encode(),
    ];
  }

  static FlutterAuthenticationResponse decode(Object result) {
    result as List<Object?>;
    return FlutterAuthenticationResponse(
      success: result[0]! as bool,
      signature: result[1]! as String,
      timestamp: result[2]! as String,
      partnerParams: FlutterPartnerParams.decode(result[3]! as List<Object?>),
      callbackUrl: result[4] as String?,
      consentInfo: result[5] != null
          ? FlutterConsentInfo.decode(result[5]! as List<Object?>)
          : null,
    );
  }
}

/// [canAccess] Whether or not the ID type is enabled for the partner
/// [consentRequired] Whether or not consent is required for the ID type
class FlutterConsentInfo {
  FlutterConsentInfo({
    required this.canAccess,
    required this.consentRequired,
  });

  bool canAccess;

  bool consentRequired;

  Object encode() {
    return <Object?>[
      canAccess,
      consentRequired,
    ];
  }

  static FlutterConsentInfo decode(Object result) {
    result as List<Object?>;
    return FlutterConsentInfo(
      canAccess: result[0]! as bool,
      consentRequired: result[1]! as bool,
    );
  }
}

/// [timestamp] is *not* a [DateTime] because technically, any arbitrary value could have been
/// passed to it. This applies to all other timestamp fields in the SDK.
class FlutterEnhancedKycRequest {
  FlutterEnhancedKycRequest({
    required this.country,
    required this.idType,
    required this.idNumber,
    this.firstName,
    this.middleName,
    this.lastName,
    this.dob,
    this.phoneNumber,
    this.bankCode,
    this.callbackUrl,
    required this.partnerParams,
    required this.timestamp,
    required this.signature,
  });

  String country;

  String idType;

  String idNumber;

  String? firstName;

  String? middleName;

  String? lastName;

  String? dob;

  String? phoneNumber;

  String? bankCode;

  String? callbackUrl;

  FlutterPartnerParams partnerParams;

  String timestamp;

  String signature;

  Object encode() {
    return <Object?>[
      country,
      idType,
      idNumber,
      firstName,
      middleName,
      lastName,
      dob,
      phoneNumber,
      bankCode,
      callbackUrl,
      partnerParams.encode(),
      timestamp,
      signature,
    ];
  }

  static FlutterEnhancedKycRequest decode(Object result) {
    result as List<Object?>;
    return FlutterEnhancedKycRequest(
      country: result[0]! as String,
      idType: result[1]! as String,
      idNumber: result[2]! as String,
      firstName: result[3] as String?,
      middleName: result[4] as String?,
      lastName: result[5] as String?,
      dob: result[6] as String?,
      phoneNumber: result[7] as String?,
      bankCode: result[8] as String?,
      callbackUrl: result[9] as String?,
      partnerParams: FlutterPartnerParams.decode(result[10]! as List<Object?>),
      timestamp: result[11]! as String,
      signature: result[12]! as String,
    );
  }
}

class FlutterEnhancedKycAsyncResponse {
  FlutterEnhancedKycAsyncResponse({
    required this.success,
  });

  bool success;

  Object encode() {
    return <Object?>[
      success,
    ];
  }

  static FlutterEnhancedKycAsyncResponse decode(Object result) {
    result as List<Object?>;
    return FlutterEnhancedKycAsyncResponse(
      success: result[0]! as bool,
    );
  }
}

class _SmileIDApiCodec extends StandardMessageCodec {
  const _SmileIDApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is FlutterAuthenticationRequest) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is FlutterAuthenticationResponse) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is FlutterConsentInfo) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is FlutterEnhancedKycAsyncResponse) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else if (value is FlutterEnhancedKycRequest) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else if (value is FlutterPartnerParams) {
      buffer.putUint8(133);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return FlutterAuthenticationRequest.decode(readValue(buffer)!);
      case 129: 
        return FlutterAuthenticationResponse.decode(readValue(buffer)!);
      case 130: 
        return FlutterConsentInfo.decode(readValue(buffer)!);
      case 131: 
        return FlutterEnhancedKycAsyncResponse.decode(readValue(buffer)!);
      case 132: 
        return FlutterEnhancedKycRequest.decode(readValue(buffer)!);
      case 133: 
        return FlutterPartnerParams.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class SmileIDApi {
  /// Constructor for [SmileIDApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  SmileIDApi({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;
  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _SmileIDApiCodec();

  Future<void> initialize() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.smileid.SmileIDApi.initialize', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<FlutterAuthenticationResponse> authenticate(FlutterAuthenticationRequest arg_request) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.smileid.SmileIDApi.authenticate', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_request]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as FlutterAuthenticationResponse?)!;
    }
  }

  Future<FlutterEnhancedKycAsyncResponse> doEnhancedKycAsync(FlutterEnhancedKycRequest arg_request) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.smileid.SmileIDApi.doEnhancedKycAsync', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_request]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as FlutterEnhancedKycAsyncResponse?)!;
    }
  }
}
