import Foundation

extension String {
    
    func convetToDate() -> Date? {
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = .current
        
        return df.date(from: self)
        
    }
    
    func convertToDisplayFormat() -> String {
        guard let date = convetToDate() else {return "N/A"};
        return date.convertToMonthYearFormat();
    }
}
