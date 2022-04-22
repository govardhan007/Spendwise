//
//  TransactionViewModel.swift

import Foundation
import UIKit

protocol TransactionViewModelProtocol: AnyObject {
    var numberOfRows: Int { get }
    var heightForRow: Double { get }
    
    func titleForRow(index: Int) -> String?
    func colorForRow(index: Int) -> UIColor
}

class TransactionViewModel: TransactionViewModelProtocol {
    private var types = ["Income", "Expense"]
    
    var numberOfRows: Int {
        return types.count
    }
    
    var heightForRow: Double {
        return 54
    }
    
    func titleForRow(index: Int) -> String? {
        return types[index]
    }
    
    func colorForRow(index: Int) -> UIColor {
        return index == 0 ? UIColor(red: 0, green: 144/255, blue: 81/255, alpha: 1) : .red
    }
}
