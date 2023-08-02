import Flutter
import UIKit
import SmileID
import Combine

public class SmileIDPlugin: NSObject, FlutterPlugin, SmileIDApi {
  private var subscribers = Set<AnyCancellable>()
  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger: FlutterBinaryMessenger = registrar.messenger()
    let api: SmileIdApi & NSObjectProtocol = SmileIDPlugin()
    SmileIdApiSetup.setUp(binaryMessenger: messenger, api: api)
  }

  func getPlatformVersion(completion: @escaping (Result<String?, Error>) -> Void) {
    completion(.success("blah " + UIDevice.current.systemVersion))
  }

  func initialize(completion: @escaping (Result<Void, Error>) -> Void) {
    SmileID.initialize()
    completion(.success(()))
  }

  func doEnhancedKycAsync(request: FlutterEnhancedKycRequest,
                          completion: @escaping (Result<FlutterEnhancedKycAsyncResponse?, Error>) -> Void) {
      SmileID.api.doEnhancedKycAsync(request: request.toRequest())
          .sink(receiveCompletion: { status in
              switch status {
              case .failure(let error):
                  completion(.failure(error))
              default:
                  break
              }
          }, receiveValue: { response in
              completion(.success(response.toFlutterResponse()))
          }).store(in: &subscribers)
  }
}
