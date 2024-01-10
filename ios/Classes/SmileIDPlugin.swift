import Flutter
import UIKit
import SmileID
import Combine

public class SmileIDPlugin: NSObject, FlutterPlugin, SmileIDApi {
    private var subscribers = Set<AnyCancellable>()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger: FlutterBinaryMessenger = registrar.messenger()
        let api: SmileIDApi & NSObjectProtocol = SmileIDPlugin()
        SmileIDApiSetup.setUp(binaryMessenger: messenger, api: api)

        let documentVerificationFactory = SmileIDDocumentVerification.Factory(
            messenger: registrar.messenger()
        )
        registrar.register(
            documentVerificationFactory,
            withId: SmileIDDocumentVerification.VIEW_TYPE_ID
        )

        let smartSelfieEnrollmentFactory = SmileIDSmartSelfieEnrollment.Factory(
            messenger: registrar.messenger()
        )
        registrar.register(
            smartSelfieEnrollmentFactory,
            withId: SmileIDSmartSelfieEnrollment.VIEW_TYPE_ID
        )

        let smartSelfieAuthenticationFactory = SmileIDSmartSelfieAuthentication.Factory(
            messenger: registrar.messenger()
        )
        registrar.register(
            smartSelfieAuthenticationFactory,
            withId: SmileIDSmartSelfieAuthentication.VIEW_TYPE_ID
        )
        
        let biometricKYCFactory = SmileIDBiometricKYC.Factory(
            messenger: registrar.messenger()
        )
        registrar.register(
            biometricKYCFactory,
            withId: SmileIDBiometricKYC.VIEW_TYPE_ID
        )
        
    }

    func initialize() {
        SmileID.initialize()
    }

    func setEnvironment(useSandbox: Bool) {
        SmileID.setEnvironment(useSandbox: useSandbox)
    }

    func setCallbackUrl(callbackUrl: String) {
        SmileID.setCallbackUrl(url: URL(string: callbackUrl))
    }

    func authenticate(
        request: FlutterAuthenticationRequest,
        completion: @escaping (Result<FlutterAuthenticationResponse, Error>) -> Void
    ) {
        SmileID.api.authenticate(request: request.toRequest())
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error):
                    completion(.failure(error))
                default:
                    break
                }
            }, receiveValue: { response in
                completion(.success(response.toResponse()))
            })
            .store(in: &subscribers)
    }

    func prepUpload(
        request: FlutterPrepUploadRequest,
        completion: @escaping (Result<FlutterPrepUploadResponse, Error>) -> Void
    ) {
        SmileID.api.prepUpload(request: request.toRequest())
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error):
                    completion(.failure(error))
                default:
                    break
                }
            }, receiveValue: { response in
                completion(.success(response.toResponse()))
            })
            .store(in: &subscribers)
    }

    func upload(
        url: String,
        request: FlutterUploadRequest,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        do {
            SmileID.api.upload(zip: try request.toRequest(), to: url)
                .sink(receiveCompletion: { status in
                    switch status {
                    case .failure(let error):
                        completion(.failure(error))
                    case .finished:
                        completion(.success(()))
                    }
                }, receiveValue: { _ in })
                .store(in: &subscribers)
        } catch {
            completion(.failure(error))
        }
    }

    func doEnhancedKyc(
        request: FlutterEnhancedKycRequest,
        completion: @escaping (Result<FlutterEnhancedKycResponse, Error>) -> Void
    ) {
        SmileID.api.doEnhancedKyc(request: request.toRequest())
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error):
                    completion(.failure(error))
                default:
                    break
                }
            }, receiveValue: { response in
                completion(.success(response.toResponse()))
            })
            .store(in: &subscribers)
    }

    func doEnhancedKycAsync(
        request: FlutterEnhancedKycRequest,
        completion: @escaping (Result<FlutterEnhancedKycAsyncResponse, Error>) -> Void
    ) {
        SmileID.api.doEnhancedKycAsync(request: request.toRequest())
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error):
                    completion(.failure(error))
                default:
                    break
                }
            }, receiveValue: { response in
                completion(.success(response.toResponse()))
            })
            .store(in: &subscribers)
    }

    func getSmartSelfieJobStatus(
        request: FlutterJobStatusRequest,
        completion: @escaping (Result<FlutterSmartSelfieJobStatusResponse, Error>) -> Void
    ) {
        SmileID.api.getJobStatus(request: request.toRequest())
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error):
                    completion(.failure(error))
                default:
                    break
                }
            }, receiveValue: { response in
                completion(.success(response.toResponse()))
            })
            .store(in: &subscribers)
    }

    func getDocumentVerificationJobStatus(
        request: FlutterJobStatusRequest,
        completion: @escaping (Result<FlutterDocumentVerificationJobStatusResponse, Error>) -> Void
    ) {
        SmileID.api.getJobStatus(request: request.toRequest())
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error):
                    completion(.failure(error))
                default:
                    break
                }
            }, receiveValue: { response in
                completion(.success(response.toResponse()))
            })
            .store(in: &subscribers)
    }

    func getBiometricKycJobStatus(
        request: FlutterJobStatusRequest,
        completion: @escaping (Result<FlutterBiometricKycJobStatusResponse, Error>) -> Void
    ) {
        SmileID.api.getJobStatus(request: request.toRequest())
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error):
                    completion(.failure(error))
                default:
                    break
                }
            }, receiveValue: { response in
                completion(.success(response.toResponse()))
            })
            .store(in: &subscribers)
    }

    func getEnhancedDocumentVerificationJobStatus(
        request: FlutterJobStatusRequest,
        completion: @escaping (Result<FlutterEnhancedDocumentVerificationJobStatusResponse, Error>) -> Void
    ) {
        SmileID.api.getJobStatus(request: request.toRequest())
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error):
                    completion(.failure(error))
                default:
                    break
                }
            }, receiveValue: { response in
                completion(.success(response.toResponse()))
            })
            .store(in: &subscribers)
    }

    func getProductsConfig(
        request: FlutterProductsConfigRequest,
        completion: @escaping (Result<FlutterProductsConfigResponse, Error>) -> Void
    ) {
        SmileID.api.getProductsConfig(request: request.toRequest())
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error):
                    completion(.failure(error))
                default:
                    break
                }
            }, receiveValue: { response in
                completion(.success(response.toResponse()))
            })
            .store(in: &subscribers)
    }

    func getValidDocuments(
        request: FlutterProductsConfigRequest,
        completion: @escaping (Result<FlutterValidDocumentsResponse, Error>) -> Void
    ) {
        SmileID.api.getValidDocuments(request: request.toRequest())
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error):
                    completion(.failure(error))
                default:
                    break
                }
            }, receiveValue: { response in
                completion(.success(response.toResponse()))
            })
            .store(in: &subscribers)
    }

    func getServices(
        completion: @escaping (Result<FlutterServicesResponse, Error>) -> Void
    ) {
        SmileID.api.getServices()
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error):
                    completion(.failure(error))
                default:
                    break
                }
            }, receiveValue: { response in
                completion(.success(response.toResponse()))
            })
            .store(in: &subscribers)
    }
}
