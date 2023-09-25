//
//  NetworkService.swift
//  TestBS
//
//  Created by Никитин Артем on 25.09.23.
//

import Foundation
import Alamofire

final class NetworkService {
    private let baseURL = "junior.balinasoft.com"

    enum Errors: Error {
        case unknownUrl
    }

    private func makeURLComponents(path: String, queryItems: [URLQueryItem]) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseURL
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        return urlComponents
    }

    private func makeQueryItem(name: String, value: String) -> URLQueryItem {
        return URLQueryItem(name: name, value: value)
    }

    func fetchData(path: String, page: String) async -> PhotoTypeDtoOut? {
        let queryItem = makeQueryItem(name: "page", value: page)
        let urlComponents = makeURLComponents(path: path, queryItems: [queryItem])

        do {
            return try await AF.request(urlComponents)
                .serializingDecodable(PhotoTypeDtoOut.self, decoder: JSONDecoder())
                .value
        } catch {
            return nil
        }
    }

    func getAllImage(url: String) async throws -> Data? {
        guard let url = URL(string: url) else {
            throw Errors.unknownUrl
        }

        let response = try await URLSession.shared.data(from: url)
        let data = response.0
        return data
    }

    func sendPhotoToServer(id: Int, path: String, parameters: [String: Any]) {
        let queryItem = makeQueryItem(name: "id", value: String(id))
        let urlComponents = makeURLComponents(path: path, queryItems: [queryItem])

        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                if let data = value as? Data {
                    multipartFormData.append(data, withName: key, fileName: "photo.jpg", mimeType: "image/jpeg")
                } else if let string = value as? String {
                    multipartFormData.append(string.data(using: .utf8)!, withName: key)
                }
            }
        }, to: urlComponents, method: .post).responseDecodable(of: PhotoUploadDtoOut.self ) { result in
            debugPrint(result)
        }
    }
}
