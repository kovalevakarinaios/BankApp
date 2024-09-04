//
//  NetworkManager.swift
//  BankApp
//
//  Created by Karina Kovaleva on 27.05.24.
//

import Foundation

protocol NetworkManagerProtocol {
    func makeURL() -> Result<URL, DataError.NetworkError>
    func fetchData(completion: @escaping ((Result<ATMData, DataError.NetworkError>) -> Void))
}


enum DataError {
    enum NetworkError: Error {
        case wrongURL
        case invalidResponse
        case decodingError
        case noInternetConnection
        case networkFailure(Error)
        case unexpectedStatusCode(Int)
    }
}

class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    
    func makeURL() -> Result<URL, DataError.NetworkError> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "belarusbank.by"
        components.path = "/open-banking/v1.0/atms"
        
        guard let url = components.url else {
            return .failure(.wrongURL)
        }
        
        return .success(url)
    }
    
    func fetchData(completion: @escaping ((Result<ATMData, DataError.NetworkError>) -> Void))  {

        switch makeURL() {
        case .success(let url):
            let urlRequest = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in

                if let error = error as? URLError {
                    switch error.code {
                    case .networkConnectionLost, .notConnectedToInternet:
                        completion(.failure(.noInternetConnection))
                    default:
                        completion(.failure(.networkFailure(error)))
                    }
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(.unexpectedStatusCode(httpResponse.statusCode)))
                    return
                }
                
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(ATMData.self, from: data)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(.decodingError))
                    }
                } else {
                    completion(.failure(.invalidResponse))
                }
               
            }
            task.resume()
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
