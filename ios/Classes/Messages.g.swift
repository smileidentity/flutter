// Autogenerated from Pigeon (v10.1.4), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)"
  ]
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

enum FlutterJobType: Int {
  case biometricKyc = 0
}

/// Generated class from Pigeon that represents data sent in messages.
struct FlutterPartnerParams {
  var jobType: FlutterJobType
  var jobId: String
  var userId: String
  var extras: [String?: String?]

  static func fromList(_ list: [Any?]) -> FlutterPartnerParams? {
    let jobType = FlutterJobType(rawValue: list[0] as! Int)!
    let jobId = list[1] as! String
    let userId = list[2] as! String
    let extras = list[3] as! [String?: String?]

    return FlutterPartnerParams(
      jobType: jobType,
      jobId: jobId,
      userId: userId,
      extras: extras
    )
  }
  func toList() -> [Any?] {
    return [
      jobType.rawValue,
      jobId,
      userId,
      extras,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct FlutterEnhancedKycRequest {
  var country: String
  var idType: String
  var idNumber: String
  var firstName: String
  var middleName: String
  var lastName: String
  var dob: String
  var phoneNumber: String
  var bankCode: String
  var callbackUrl: String
  var partnerParams: FlutterPartnerParams
  var partnerId: String
  var sourceSdk: String
  var sourceSdkVersion: String
  var timestamp: String
  var signature: String

  static func fromList(_ list: [Any?]) -> FlutterEnhancedKycRequest? {
    let country = list[0] as! String
    let idType = list[1] as! String
    let idNumber = list[2] as! String
    let firstName = list[3] as! String
    let middleName = list[4] as! String
    let lastName = list[5] as! String
    let dob = list[6] as! String
    let phoneNumber = list[7] as! String
    let bankCode = list[8] as! String
    let callbackUrl = list[9] as! String
    let partnerParams = FlutterPartnerParams.fromList(list[10] as! [Any?])!
    let partnerId = list[11] as! String
    let sourceSdk = list[12] as! String
    let sourceSdkVersion = list[13] as! String
    let timestamp = list[14] as! String
    let signature = list[15] as! String

    return FlutterEnhancedKycRequest(
      country: country,
      idType: idType,
      idNumber: idNumber,
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      dob: dob,
      phoneNumber: phoneNumber,
      bankCode: bankCode,
      callbackUrl: callbackUrl,
      partnerParams: partnerParams,
      partnerId: partnerId,
      sourceSdk: sourceSdk,
      sourceSdkVersion: sourceSdkVersion,
      timestamp: timestamp,
      signature: signature
    )
  }
  func toList() -> [Any?] {
    return [
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
      partnerParams.toList(),
      partnerId,
      sourceSdk,
      sourceSdkVersion,
      timestamp,
      signature,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct FlutterEnhancedKycAsyncResponse {
  var success: Bool

  static func fromList(_ list: [Any?]) -> FlutterEnhancedKycAsyncResponse? {
    let success = list[0] as! Bool

    return FlutterEnhancedKycAsyncResponse(
      success: success
    )
  }
  func toList() -> [Any?] {
    return [
      success,
    ]
  }
}

private class SmileIdApiCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
      case 128:
        return FlutterEnhancedKycAsyncResponse.fromList(self.readValue() as! [Any?])
      case 129:
        return FlutterEnhancedKycRequest.fromList(self.readValue() as! [Any?])
      case 130:
        return FlutterPartnerParams.fromList(self.readValue() as! [Any?])
      default:
        return super.readValue(ofType: type)
    }
  }
}

private class SmileIdApiCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? FlutterEnhancedKycAsyncResponse {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else if let value = value as? FlutterEnhancedKycRequest {
      super.writeByte(129)
      super.writeValue(value.toList())
    } else if let value = value as? FlutterPartnerParams {
      super.writeByte(130)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class SmileIdApiCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return SmileIdApiCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return SmileIdApiCodecWriter(data: data)
  }
}

class SmileIdApiCodec: FlutterStandardMessageCodec {
  static let shared = SmileIdApiCodec(readerWriter: SmileIdApiCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol SmileIdApi {
  func getPlatformVersion(completion: @escaping (Result<String?, Error>) -> Void)
  func initialize(completion: @escaping (Result<Void, Error>) -> Void)
  func doEnhancedKycAsync(request: FlutterEnhancedKycRequest, completion: @escaping (Result<FlutterEnhancedKycAsyncResponse?, Error>) -> Void)
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class SmileIdApiSetup {
  /// The codec used by SmileIdApi.
  static var codec: FlutterStandardMessageCodec { SmileIdApiCodec.shared }
  /// Sets up an instance of `SmileIdApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: SmileIdApi?) {
    let getPlatformVersionChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.smileid.SmileIdApi.getPlatformVersion", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getPlatformVersionChannel.setMessageHandler { _, reply in
        api.getPlatformVersion() { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      getPlatformVersionChannel.setMessageHandler(nil)
    }
    let initializeChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.smileid.SmileIdApi.initialize", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      initializeChannel.setMessageHandler { _, reply in
        api.initialize() { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      initializeChannel.setMessageHandler(nil)
    }
    let doEnhancedKycAsyncChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.smileid.SmileIdApi.doEnhancedKycAsync", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      doEnhancedKycAsyncChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let requestArg = args[0] as! FlutterEnhancedKycRequest
        api.doEnhancedKycAsync(request: requestArg) { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      doEnhancedKycAsyncChannel.setMessageHandler(nil)
    }
  }
}
