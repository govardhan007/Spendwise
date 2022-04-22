
//  Constant.swift


import Foundation

enum TransactionHistoryKeys: String {
    case entityName = "TransactionHitory"
    case title
    case amount
    case image
    case type
    case date
    case category
    
    var value: String {
        return rawValue
    }
}
