import Alamofire
import Foundation

public final class Logger: EventMonitor {
    private static let taskDurationFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 4
        return formatter
    }()

    public init() { }

    // Event called when any type of Request is resumed.
    public func requestDidResume(_ request: Request) {
        guard let url = request.request?.url?.absoluteString else { return }

        let requestFormatted = [
            "[", Date().description, "]",
            " ⬆️ ", request.request?.httpMethod ?? "UNDEFINED",
            " '", url, "'"
        ]
        print(requestFormatted.joined(separator: ""))

        printHeaders(request.request?.allHTTPHeaderFields)
        printBody(request.request?.httpBody)
    }

    // Event called whenever a DataRequest has parsed a response.
    public func request<Value>(_ request: Alamofire.DataRequest, didParseResponse response: Alamofire.DataResponse<Value, AFError>) {
        guard let url = request.request?.url?.absoluteString else { return }

        let interval = response.metrics
            .map(\.taskInterval.duration)
            .map(NSNumber.init(value:))
            .flatMap(Logger.taskDurationFormatter.string(from:))

        let responseFormatted: [String?] = [
            "[", Date().description, "]",
            " ⬇️ ", request.request?.httpMethod ?? "UNDEFINED",
            " '", url, "'",
            response.response.map { " " + formattedStatusCode($0.statusCode) },
            interval.map { " [\($0) s]" }
        ]
        print(responseFormatted.compactMap { $0 }.joined(separator: ""))

        printHeaders(response.response?.allHeaderFields)
        printBody(response.data)
    }

    private func printHeaders<Key: Hashable, Value>(_ headers: [Key: Value]?) {
        if let headers, !headers.isEmpty {
            print("Headers: [")
            headers.forEach { key, value in
                print("    \(key): \(value)")
            }
            print("]")
        }
    }

    private func printBody(_ body: Data?) {
        guard let body else { return }

        if
            let json = try? JSONSerialization.jsonObject(with: body, options: []),
            let prettyData = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]),
            let prettyString = String(data: prettyData, encoding: .utf8)
        {
            print("Body:", prettyString)
        } else if let jsonString = String(data: body, encoding: .utf8) {
            print("Body:", jsonString)
        }
    }

    private func formattedStatusCode(_ statusCode: Int) -> String {
        var formatted = "("

        if
            let firstDigit = String(statusCode).compactMap(\.wholeNumberValue).first,
            let icon = statusIcons[firstDigit]
        {
            formatted.append(icon + " ")
        }

        formatted.append(String(statusCode))

        if let message = statusStrings[statusCode] {
            formatted.append(" " + message)
        }

        return formatted.appending(")")
    }
}

fileprivate let statusIcons = [
    1: "ℹ️",
    2: "✅",
    3: "⤴️",
    4: "⛔️",
    5: "❌"
]

fileprivate let statusStrings = [
    // 1xx (Informational)
    100: "Continue",
    101: "Switching Protocols",
    102: "Processing",

    // 2xx (Success)
    200: "OK",
    201: "Created",
    202: "Accepted",
    203: "Non-Authoritative Information",
    204: "No Content",
    205: "Reset Content",
    206: "Partial Content",
    207: "Multi-Status",
    208: "Already Reported",
    226: "IM Used",

    // 3xx (Redirection)
    300: "Multiple Choices",
    301: "Moved Permanently",
    302: "Found",
    303: "See Other",
    304: "Not Modified",
    305: "Use Proxy",
    306: "Switch Proxy",
    307: "Temporary Redirect",
    308: "Permanent Redirect",

    // 4xx (Client Error)
    400: "Bad Request",
    401: "Unauthorized",
    402: "Payment Required",
    403: "Forbidden",
    404: "Not Found",
    405: "Method Not Allowed",
    406: "Not Acceptable",
    407: "Proxy Authentication Required",
    408: "Request Timeout",
    409: "Conflict",
    410: "Gone",
    411: "Length Required",
    412: "Precondition Failed",
    413: "Request Entity Too Large",
    414: "Request-URI Too Long",
    415: "Unsupported Media Type",
    416: "Requested Range Not Satisfiable",
    417: "Expectation Failed",
    418: "I'm a teapot",
    420: "Enhance Your Calm",
    422: "Unprocessable Entity",
    423: "Locked",
    424: "Method Failure",
    425: "Unordered Collection",
    426: "Upgrade Required",
    428: "Precondition Required",
    429: "Too Many Requests",
    431: "Request Header Fields Too Large",
    451: "Unavailable For Legal Reasons",

    // 5xx (Server Error)
    500: "Internal Server Error",
    501: "Not Implemented",
    502: "Bad Gateway",
    503: "Service Unavailable",
    504: "Gateway Timeout",
    505: "HTTP Version Not Supported",
    506: "Variant Also Negotiates",
    507: "Insufficient Storage",
    508: "Loop Detected",
    509: "Bandwidth Limit Exceeded",
    510: "Not Extended",
    511: "Network Authentication Required"
]
