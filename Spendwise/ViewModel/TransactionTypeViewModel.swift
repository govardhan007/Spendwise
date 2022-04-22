//
//  TransactionTypeViewModel.swift


import Foundation
import UIKit

protocol TransactionCategoryViewModelProtocol: AnyObject {
    var numberOfRows: Int { get }
    var heightForRow: Double { get }
    var transactionDate: Date? { get set }
    var transactionImage: UIImage? { get set }
    var transactionTitle: String? { get set }
    var transactionAmount: String? { get set }
    
    func titleForRow(index: Int) -> String?
}

class TransactionCategoryViewModel: TransactionCategoryViewModelProtocol {
    private var categories = ["Utilities", "Tax", "Rent", "Lottery", "Salary", "Food", "Bill"].sorted()
    
    var transactionTitle: String?
    var transactionAmount: String?
    var transactionDate: Date?
    var transactionImage: UIImage?
    
    init() {
        categories.append("Other")
    }
    
    var numberOfRows: Int {
        return categories.count
    }
    
    var heightForRow: Double {
        return 54
    }
    
    func titleForRow(index: Int) -> String? {
        return categories[index]
    }
}
