import Foundation


class FormattingDate {
    
    static let sharedInstance = FormattingDate()
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter
    } ()
    
}
