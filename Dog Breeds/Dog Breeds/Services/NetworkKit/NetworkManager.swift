//
//  NetworkManager.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 19/1/24.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchData<T>(resource: HTTPRequestResource<T>) async throws -> Result<T, NetworkError>
}

final actor NetworkManager: NetworkManagerProtocol {
    private let timeOutInterval: Double
    private let urlSession: URLSession

    init(timeOutInterval: Double = RequestConfig.TIMEOUT) {
        self.timeOutInterval = timeOutInterval
        self.urlSession = URLSession(configuration: URLSessionConfigurationProvider.defaultConfiguration(timeOutInterval: timeOutInterval))
    }

    private func handleResponse<T>(data: Data, response: URLResponse?, resource: HTTPRequestResource<T>) -> Result<T, NetworkError> {
        guard let httpresponse = response as? HTTPURLResponse else { return .failure(.noresponse) }
        if httpresponse.type == .success {
            return .success(resource.parse(data))
        } else {
            return .failure(.requestfailed)
        }
    }

    func fetchData<T>(resource: HTTPRequestResource<T>) async throws -> Result<T, NetworkError> {
        let fullUrlPath = EnvironmentConfig.baseURL + resource.urlPath
        guard let url = URL(string: fullUrlPath) else { return .failure(.urlfailure) }

        var request = URLRequest(url: url)
        request.httpBody = resource.body
        request.httpMethod = resource.method.rawValue
        request.allHTTPHeaderFields = [
            HTTPRequestHeader.content_type_key: HTTPRequestHeader.content_type_value,
        ]

        do {
            let (data, response) = try await urlSession.data(for: request)
            return handleResponse(data: data, response: response, resource: resource)
        } catch {
            return .failure(.noresponse)
        }
    }
}

struct URLSessionConfigurationProvider {
    static func defaultConfiguration(timeOutInterval: Double) -> URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(timeOutInterval)
        config.timeoutIntervalForResource = TimeInterval(timeOutInterval)
        return config
    }
}
