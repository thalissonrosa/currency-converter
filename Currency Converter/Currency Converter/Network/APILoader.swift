//
//  APILoader.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 15/12/19.
//

import UIKit

typealias APIHandler = RequestHandler & ResponseHandler

class APILoader<T: APIHandler> {
    
    //MARK: Variables
    private let apiRequest: T
    private let urlSession: NetworkingSession
    
    //MARK: Init
    init(apiRequest: T, urlSession: NetworkingSession = URLSession.shared) {
        self.apiRequest = apiRequest
        self.urlSession = urlSession
    }
    
    //MARK: Public functions
    func request(router: Router, completion: @escaping (Result<T.ResponseDataType, Error>) -> ()) {
        do {
            let urlRequest = try apiRequest.makeRequest(from: router)
            urlSession.loadData(with: urlRequest) { data, response, error in
                guard let data = data else {
                    completion(.failure(ServiceError.noData))
                    return
                }
                do {
                    let parsedResponse = try self.apiRequest.parseResponse(data: data)
                    DispatchQueue.main.async {
                        completion(.success(parsedResponse))
                    }
                } catch {
                    completion(.failure(ServiceError.invalidData))
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }
}
