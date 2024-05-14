//
//  APIProvider.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/10/24.
//

import Moya
import RxSwift
import SwiftyBeaver
import Alamofire

let logger = SwiftyBeaver.self

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

class APIProvider {

    static let shared = APIProvider()
    let provider: MoyaProvider<NetworkAPI>
    var authenticationToken = ""
    init(endpointClosure: @escaping MoyaProvider<NetworkAPI>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
         stubClosure: MoyaProvider<NetworkAPI>.StubClosure? = nil) {
        var plugins: [Moya.PluginType] = []
        let requestPlugin = RequestPlugin()
        let networkLoggerPlugin: NetworkLoggerPlugin = NetworkLoggerPlugin(verbose: true, cURL: true , responseDataFormatter: JSONResponseDataFormatter)


        plugins.append(networkLoggerPlugin)
        plugins.append(requestPlugin)
        let defaultStubClosure = { (target: TargetType) -> Moya.StubBehavior in
            guard let _ = target as? NetworkAPI else { return .never }
            return .immediate
        }
        let _ = stubClosure ?? defaultStubClosure
        // Inject plugin here
        self.provider = MoyaProvider<NetworkAPI>(plugins: plugins)
    }
}

/// Logs network activity (outgoing requests and incoming responses).
public final class NetworkLoggerPlugin: Moya.PluginType {
    fileprivate let loggerId = "Moya_Logger"
    fileprivate let dateFormatString = "dd/MM/yyyy HH:mm:ss"
    fileprivate let dateFormatter = DateFormatter()
    fileprivate let separator = ", "
    fileprivate let terminator = "\n"
    fileprivate let cURLTerminator = "\\\n"
    fileprivate let output: (_ separator: String, _ terminator: String, _ items: Any...) -> Void
    fileprivate let requestDataFormatter: ((Data) -> (String))?
    fileprivate let responseDataFormatter: ((Data) -> (Data))?

    /// A Boolean value determing whether response body data should be logged.
    public let isVerbose: Bool
    public let cURL: Bool

    /// Initializes a Plugin.
    public init(verbose: Bool = true,
                cURL: Bool = true, output: ((_ separator: String, _ terminator: String, _ items: Any...) -> Void)? = nil, requestDataFormatter: ((Data) -> (String))? = nil, responseDataFormatter: ((Data) -> (Data))? = nil) {
        self.cURL = cURL
        self.isVerbose = verbose
        self.output = output ?? NetworkLoggerPlugin.reversedPrint
        self.requestDataFormatter = requestDataFormatter
        self.responseDataFormatter = responseDataFormatter
    }

    public func willSend(_ request: RequestType, target: TargetType) {
        guard let api = target as? NetworkAPI else { return }

        if let request = request as? CustomDebugStringConvertible, cURL {
            output(separator, terminator, request.debugDescription)
            return
        }
        if cURL {
            _ = request.cURLDescription { description in
                logger.info(description)
            }
        }

        outputItems(logNetworkRequest(request.request as URLRequest?, shouldLogBody: api.isLogable))
    }

    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: Moya.TargetType) {
        if case let .success(response) = result {
            outputItems(logNetworkResponse(response.response, data: response.data, target: target))
        } else {
            outputItems(logNetworkResponse(nil, data: nil, target: target))
        }
    }

    fileprivate func outputItems(_ items: [String]) {
        if isVerbose {
            items.forEach { output(separator, terminator, $0) }
        } else {
            output(separator, terminator, items)
        }
        logger.verbose(items)
    }
}

private extension NetworkLoggerPlugin {

    var date: String {
        dateFormatter.dateFormat = dateFormatString
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: Date())
    }

    func format(_ loggerId: String, date: String, identifier: String, message: String) -> String {
        return "\(loggerId): [\(date)] \(identifier): \(message) \n"
    }

    func logNetworkRequest(_ request: URLRequest?, shouldLogBody: Bool) -> [String] {
        var output = [String]()

        output += [format(loggerId, date: date, identifier: "Request", message: request?.description ?? "(invalid request)")]

        if let headers = request?.allHTTPHeaderFields {
            output += [format(loggerId, date: date, identifier: "Request Headers", message: headers.description)]
        }

        if shouldLogBody, let bodyStream = request?.httpBodyStream {
            output += [format(loggerId, date: date, identifier: "Request Body Stream", message: bodyStream.description)]
        }

        if let httpMethod = request?.httpMethod {
            output += [format(loggerId, date: date, identifier: "HTTP Request Method", message: httpMethod)]
        }

        if shouldLogBody, let body = request?.httpBody, let stringOutput = requestDataFormatter?(body) ?? String(data: body, encoding: .utf8), isVerbose {
            output += [format(loggerId, date: date, identifier: "Request Body", message: stringOutput)]
        }
        output += [terminator]
        return output
    }

    func logNetworkResponse(_ response: HTTPURLResponse?, data: Data?, target: TargetType) -> [String] {
        guard let response = response else {
            return [format(loggerId, date: date, identifier: "Response", message: "Received empty network response for \(target).")]
        }

        /// Checking if API is in black list and success, print empty
        if let api = target as? NetworkAPI, !api.isLogable && (200 <= response.statusCode && response.statusCode < 300) {
            return []
        }

        var output = [String]()

        output += [format(loggerId, date: date, identifier: "Response", message: response.description)]

        if let data = data, let stringData = String(data: responseDataFormatter?(data) ?? data, encoding: String.Encoding.utf8), isVerbose {
            output += [stringData]
        }
        output += [terminator]
        return output
    }
}

fileprivate extension NetworkLoggerPlugin {
    static func reversedPrint(_ separator: String, terminator: String, items: Any...) {
        for item in items {
            logger.info(item)
        }
    }
}
