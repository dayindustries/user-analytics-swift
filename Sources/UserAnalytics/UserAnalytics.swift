import Foundation

enum UserAnalyticsError: Error {
    case invalidBody
    case serviceProblem(_ error: Error)
    case badStatusCode(_ statusCode: Int)
}

class UserAnalytics {
    let token: String
    let endpoint: String

    init(token: String, endpoint: String) {
        self.token = token
        self.endpoint = endpoint
    }

    public func post(streamName: String, data: Dictionary<String, Any>, onComplete: @escaping (_ data: Data?, _ error: Error?) -> Void) -> Void {
        let url = URL(string: [self.endpoint, "/streams/", streamName].joined(separator: ""))
        var request = URLRequest(url: url!)
        guard let body = try? JSONSerialization.data(withJSONObject: data, options: []) else {
            return onComplete(nil, UserAnalyticsError.invalidBody)
        }

        request.setValue(self.token, forHTTPHeaderField: "x-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = body
        URLSession.shared.dataTask(with:request) { data, response, error in
            if error != nil {
                return onComplete(data, UserAnalyticsError.serviceProblem(error!))
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode >= 400 {
                return onComplete(data, UserAnalyticsError.badStatusCode(httpStatus.statusCode))
            }

            return onComplete(data, nil)
        }.resume()
    }

    static func toAthenaTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd KK:mm:ss.SSS"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: date)
    }
}
