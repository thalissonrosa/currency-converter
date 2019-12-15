//
//  Service.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 15/12/19.
//

import UIKit

class Service {
    
    func request<T: Codable>(router: Router, completion: @escaping (Result<T, Error>) -> ()) {
        
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = router.parameters
        
        guard let url = components.url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard response != nil, let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let parsedResponse = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(parsedResponse))
                }
            } catch let parseError {
                completion(.failure(parseError))
            }
        }
        dataTask.resume()
    }
}
