import Flutter
import UIKit
import SmileID

public class SmileIDPlugin: NSObject, FlutterPlugin, SmileIDApi {
    
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
        
        let enhancedDocumentVerificationFactory = SmileIDEnhancedDocumentVerification.Factory(
            messenger: registrar.messenger()
        )
        registrar.register(
            enhancedDocumentVerificationFactory,
            withId: SmileIDEnhancedDocumentVerification.VIEW_TYPE_ID
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
    
    func setAllowOfflineMode(allowOfflineMode: Bool) {
        SmileID.setAllowOfflineMode(allowOfflineMode: allowOfflineMode)
    }
    
    func getSubmittedJobs() -> [String] {
        SmileID.getSubmittedJobs()
    }
    
    func getUnsubmittedJobs() -> [String] {
        SmileID.getUnsubmittedJobs()
    }
    
    func cleanup(jobId: String) throws {
        try SmileID.cleanup(jobId: jobId)
    }
    
    func cleanupJobs(jobIds: [String]) throws {
        try SmileID.cleanup(jobIds: jobIds)
    }
    
    func submitJob(jobId: String, deleteFilesOnSuccess: Bool) throws {
        try SmileID.submitJob(jobId: jobId, deleteFilesOnSuccess: deleteFilesOnSuccess)
    }
    
    func authenticate(
        request: FlutterAuthenticationRequest,
        completion: @escaping (Result<FlutterAuthenticationResponse, Error>) -> Void
    ) {
        do {
            let response = try await SmileID.api.authenticate(request: request.toRequest())
            completion(.success(response.toResponse()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func prepUpload(
        request: FlutterPrepUploadRequest,
        completion: @escaping (Result<FlutterPrepUploadResponse, Error>) -> Void
    ) {
        do {
            let response = try await SmileID.api.prepUpload(request: request.toRequest())
            completion(.success(response.toResponse()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func upload(
        url: String,
        request: FlutterUploadRequest,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        do {
            try await SmileID.api.upload(zip: try request.toRequest(), to: url)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func doEnhancedKyc(
        request: FlutterEnhancedKycRequest,
        completion: @escaping (Result<FlutterEnhancedKycResponse, Error>) -> Void
    ) {
        do {
            let response = try await SmileID.api.doEnhancedKyc(request: request.toRequest())
            completion(.success(response.toResponse()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func doEnhancedKycAsync(
        request: FlutterEnhancedKycRequest,
        completion: @escaping (Result<FlutterEnhancedKycAsyncResponse, Error>) -> Void
    ) {
        do {
            let response = try await SmileID.api.doEnhancedKycAsync(request: request.toRequest())
            completion(.success(response.toResponse()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func doSmartSelfieEnrollment(
        signature: String,
        timestamp: String,
        selfieImage: String,
        livenessImages: [String],
        userId: String,
        partnerParams: [String? : String?]?,
        callbackUrl: String?,
        sandboxResult: Int64?,
        allowNewEnroll: Bool?,
        completion: @escaping (Result<FlutterSmartSelfieResponse, any Error>) -> Void
    ) {
        do {
            let response = try await SmileID.api.doSmartSelfieEnrollment(
                signature: signature,
                timestamp: timestamp,
                selfieImage: MultipartBody(
                    withImage: getFile(atPath: selfieImage)!,
                    forKey: URL(fileURLWithPath: selfieImage).lastPathComponent,
                    forName: URL(fileURLWithPath: selfieImage).lastPathComponent
                )!,
                livenessImages: livenessImages.map {
                    MultipartBody(
                        withImage: getFile(atPath: $0)!,
                        forKey: URL(fileURLWithPath: $0).lastPathComponent,
                        forName: URL(fileURLWithPath: $0).lastPathComponent
                    )!
                },
                userId: userId,
                partnerParams: convertNullableMapToNonNull(data: partnerParams),
                callbackUrl: callbackUrl,
                sandboxResult: sandboxResult.map { Int($0) },
                allowNewEnroll: allowNewEnroll
            )
            completion(.success(response.toResponse()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func doSmartSelfieAuthentication(
        signature: String,
        timestamp: String,
        selfieImage: String,
        livenessImages: [String],
        userId: String,
        partnerParams: [String? : String?]?,
        callbackUrl: String?,
        sandboxResult: Int64?,
        completion: @escaping (Result<FlutterSmartSelfieResponse, any Error>) -> Void
    ) {
        do {
            let response = try await SmileID.api.doSmartSelfieAuthentication(
                signature: signature,
                timestamp: timestamp,
                userId: userId,
                selfieImage: MultipartBody(
                    withImage: getFile(atPath: selfieImage)!,
                    forKey: URL(fileURLWithPath: selfieImage).lastPathComponent,
                    forName: URL(fileURLWithPath: selfieImage).lastPathComponent
                )!,
                livenessImages: livenessImages.map {
                    MultipartBody(
                        withImage: getFile(atPath: $0)!,
                        forKey: URL(fileURLWithPath: $0).lastPathComponent,
                        forName: URL(fileURLWithPath: $0).lastPathComponent
                    )!
                },
                partnerParams: convertNullableMapToNonNull(data: partnerParams),
                callbackUrl: callbackUrl,
                sandboxResult: sandboxResult.map { Int($0) }
            )
            completion(.success(response.toResponse()))
        } catch {
            completion(.failure(error))
        }
    }

    func getSmartSelfieJobStatus(
        request: FlutterJobStatusRequest,
        completion: @escaping (Result<FlutterSmartSelfieJobStatusResponse, Error>) -> Void
    ) {
        do {
            let response = try await SmileID.api.getJobStatus(request: request.toRequest())
            completion(.success(response.toResponse()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func getDocumentVerificationJobStatus(
        request: FlutterJobStatusRequest,
        completion: @escaping (Result<FlutterDocumentVerificationJobStatusResponse, Error>) -> Void
    ) {
        do {
            let response = try await SmileID.api.getJobStatus(request: request.toRequest())
            completion(.success(response.toResponse()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func getBiometricKycJobStatus(
        request: FlutterJobStatusRequest,
        completion: @escaping (Result<FlutterBiometricKycJobStatusResponse, Error>) -> Void
    ) {
        do {
            let response = try await SmileID.api.getJobStatus(request: request.toRequest())
            completion(.success(response.toResponse()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func getEnhancedDocumentVerificationJobStatus(
        request: FlutterJobStatusRequest,
        completion: @escaping (Result<FlutterEnhancedDocumentVerificationJobStatusResponse, Error>) -> Void
    ) {
        do {
            let response = try await SmileID.api.getJobStatus(request: request.toRequest())
            completion(.success(response.toResponse()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func getProductsConfig(
        request: FlutterProductsConfigRequest,
        completion: @escaping (Result<FlutterProductsConfigResponse, Error>) -> Void
    ) {
        do {
            let response = try await SmileID.api.getProductsConfig(request: request.toRequest())
            completion(.success(response.toResponse()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func getValidDocuments(
        request: FlutterProductsConfigRequest,
        completion: @escaping (Result<FlutterValidDocumentsResponse, Error>) -> Void
    ) {
        do {
            let response = try await SmileID.api.getValidDocuments(request: request.toRequest())
            completion(.success(response.toResponse()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func getServices(
        completion: @escaping (Result<FlutterServicesResponse, Error>) -> Void
    ) {
        do {
            let response = try await SmileID.api.getServices()
            completion(.success(response.toResponse()))
        } catch {
            completion(.failure(error))
        }
    }
    
    
    func pollSmartSelfieJobStatus(
        request: FlutterJobStatusRequest,
        interval: Int64,
        numAttempts: Int64,
        completion: @escaping (Result<FlutterSmartSelfieJobStatusResponse, Error>) -> Void
    ) {
        
        pollJobStatus(
            apiCall: SmileID.api.pollSmartSelfieJobStatus,
            request: request.toRequest(),
            interval: interval,
            numAttempts: numAttempts,
            completion: { result in
                switch result {
                case .success(let response):
                    completion(.success(response.toResponse()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }
    
    func pollDocumentVerificationJobStatus(
        request: FlutterJobStatusRequest,
        interval: Int64,
        numAttempts: Int64,
        completion: @escaping (Result<FlutterDocumentVerificationJobStatusResponse, Error>) -> Void
    ) {
        
        pollJobStatus(
            apiCall: SmileID.api.pollDocumentVerificationJobStatus,
            request: request.toRequest(),
            interval: interval,
            numAttempts: numAttempts,
            completion: { result in
                switch result {
                case .success(let response):
                    completion(.success(response.toResponse()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }
    
    
    func pollBiometricKycJobStatus(
        request: FlutterJobStatusRequest,
        interval: Int64,
        numAttempts: Int64,
        completion: @escaping (Result<FlutterBiometricKycJobStatusResponse, Error>) -> Void
    ) {
        
        pollJobStatus(
            apiCall: SmileID.api.pollBiometricKycJobStatus,
            request: request.toRequest(),
            interval: interval,
            numAttempts: numAttempts,
            completion: { result in
                switch result {
                case .success(let response):
                    completion(.success(response.toResponse()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }
    
    func pollEnhancedDocumentVerificationJobStatus(
        request: FlutterJobStatusRequest,
        interval: Int64,
        numAttempts: Int64,
        completion: @escaping (Result<FlutterEnhancedDocumentVerificationJobStatusResponse, Error>) -> Void
    ) {
        pollJobStatus(
            apiCall: SmileID.api.pollEnhancedDocumentVerificationJobStatus,
            request: request.toRequest(),
            interval: interval,
            numAttempts: numAttempts,
            completion: { result in
                switch result {
                case .success(let response):
                    completion(.success(response.toResponse()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }
    
    func pollJobStatus<RequestType, ResponseType>(
        apiCall: @escaping (RequestType, TimeInterval, Int) async throws -> ResponseType,
        request: RequestType,
        interval: Int64,
        numAttempts: Int64,
        completion: @escaping (Result<ResponseType, Error>) -> Void
    ) {
        let timeInterval = convertToTimeInterval(milliSeconds: interval)
        guard let numAttemptsInt = Int(exactly: numAttempts) else {
            completion(.failure(NSError(domain: "Invalid numAttempts value", code: -1, userInfo: nil)))
            return
        }

        do {
            let response = try await apiCall(request, timeInterval, numAttemptsInt)
            completion(.success(response))
        } catch {
            completion(.failure(error))
        }
    }
    
    func convertToTimeInterval(milliSeconds:Int64) -> TimeInterval {
        let seconds = milliSeconds/1000
        return TimeInterval(seconds)
    }
}
