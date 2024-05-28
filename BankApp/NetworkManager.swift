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
                if let data = data {
                    do {
                        let data = try JSONDecoder().decode(ATMData.self, from: data)
                        completion(.success(data))
                    } catch {
                        completion(.failure(.decodingError))
                    }
                }
            }
            task.resume()
        case .failure(let error):
            print("Wrong URL")
        }
        
    }
}
