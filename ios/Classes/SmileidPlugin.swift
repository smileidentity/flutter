import Flutter
import UIKit
import SmileID

public class SmileidPlugin: NSObject, FlutterPlugin, SmileIdApi {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger: FlutterBinaryMessenger = registrar.messenger()
    let api: SmileIdApi & NSObjectProtocol = SmileidPlugin()
    SmileIdApiSetup.setUp(binaryMessenger: messenger, api: api)
  }

  func getPlatformVersion(completion: @escaping (Result<String?, Error>) -> Void) {
    completion(.success("blah " + UIDevice.current.systemVersion))
  }

  func initialize(completion: @escaping (Result<Void, Error>) -> Void) {
    // TODO
    // SmileID.initialize(config: Config())
    completion(.success(()))
  }

  func doEnhancedKycAsync(request: FlutterEnhancedKycRequest,
                          completion: @escaping (Result<FlutterEnhancedKycAsyncResponse?, Error>) -> Void) {
    // TODO
  }
}
