import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        let df = DateFormatter()
        df.dateFormat = "MMM yyyy"
        return df.string(from: self)
    }
}
