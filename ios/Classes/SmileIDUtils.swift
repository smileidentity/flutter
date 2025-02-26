import Foundation

extension String {
    func isValidUrl() -> Bool {
        if let url = URL(string: self) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}

func getCurrentIsoTimestamp() -> String {
    let pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    let formatter = DateFormatter()
    formatter.dateFormat = pattern
    formatter.locale = Locale(identifier: "en_US")
    formatter.timeZone = TimeZone(identifier: "UTC")
    return formatter.string(from: Date())
}
