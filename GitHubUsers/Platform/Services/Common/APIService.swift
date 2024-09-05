//
//  APIService.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 29/08/2024.
//

import Foundation
import Alamofire
import ObjectMapper
import Combine

class NetworkLogger: EventMonitor {
    
    /// Called when a network request finishes successfully.
    /// - Parameter request: The completed network request.
    func requestDidFinish(_ request: Request) {
        print("Request: \(request)")
    }

    /// Called when a network request fails.
    /// - Parameters:
    ///   - request: The request that failed.
    ///   - error: The error associated with the failed request.
    func requestDidFail(_ request: Request, with error: AFError) {
        print("Request failed: \(request) with error: \(error)")
    }

    /// Called when a network response is received.
    /// - Parameter response: The response data along with any errors.
    func responseDidFinish(_ response: DataResponse<Data, AFError>) {
        print("Response: \(response)")
    }
}

struct NetworkManager {
    
    static let kRequestTimeOut: TimeInterval = 30
    
    static let session: Session = {
        let configuration: URLSessionConfiguration = {
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = kRequestTimeOut
            config.timeoutIntervalForResource = kRequestTimeOut
            config.httpMaximumConnectionsPerHost = 10
            return config
        }()
        let session = Session(configuration: configuration, serverTrustManager: nil, eventMonitors: [NetworkLogger()])
        return session
    }()
    
}

protocol APIServiceType {
    
    /// Sends a request to retrieve an array of objects.
    /// - Parameter input: The input parameters for the API request.
    /// - Returns: A future that resolves to an array of objects conforming to `Mappable`, or an error.
    func requestArray<T: Mappable>(nonBaseResponse input: APIInputBase) -> Future<[T], Error>
    
    /// Sends a request to retrieve a single object.
    /// - Parameter input: The input parameters for the API request.
    /// - Returns: A future that resolves to an object conforming to `Mappable`, or an error.
    func requestObject<T: Mappable>(nonBaseResponse input: APIInputBase) -> Future<T, Error>
}

class APIService: APIServiceType {
    
    private let session = NetworkManager.session
    
    static let shared: APIService = {
        let instance = APIService()
        return instance
    }()
    
    func requestArray<T: Mappable>(nonBaseResponse input: APIInputBase) -> Future<[T], Error> {
        return Future { promise in
            self.session.request(
                input.url,
                method: input.method,
                parameters: input.parameters,
                encoding: input.encoding,
                headers: input.headers)
            .responseData(queue: .global(qos: .background)) { dataRequest in
                switch dataRequest.result {
                case .success(let value):
                    do {
                        let any = try JSONSerialization.jsonObject(with: value)
                        if let array = any as? [[String: Any]] {
                            let json = array.compactMap {T.init(JSON: $0)}
                            if dataRequest.response?.statusCode == 200 {
                                promise(.success(json))
                            }
                            else {
                                promise(.failure(APIError.error(code: dataRequest.response?.statusCode ?? 0, message: "Something wrong, try again!")))
                            }
                        }
                        else {
                            promise(.failure(APIError.invalidResponseData(data: any)))
                        }
                    }
                    catch {
                        promise(.failure(APIError.invalidResponseData(data: value)))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
    func requestObject<T: Mappable>(nonBaseResponse input: APIInputBase) -> Future<T, Error> {
        return Future { promise in
            self.session.request(
                input.url,
                method: input.method,
                parameters: input.parameters,
                encoding: input.encoding,
                headers: input.headers)
            .responseData(queue: .global(qos: .background)) { dataRequest in
                switch dataRequest.result {
                case .success(let value):
                    do {
                        let any = try JSONSerialization.jsonObject(with: value)
                        if let dict = any as? [String: Any], let json = T.init(JSON: dict) {
                            if dataRequest.response?.statusCode == 200 {
                                promise(.success(json))
                            }
                            else {
                                promise(.failure(APIError.error(code: dataRequest.response?.statusCode ?? 0, message: "Something wrong, try again!")))
                            }
                        }
                        else {
                            promise(.failure(APIError.invalidResponseData(data: value)))
                        }
                    }
                    catch {
                        promise(.failure(APIError.invalidResponseData(data: value)))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
}
