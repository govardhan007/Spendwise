//
//  AddTransactionViewModel.swift

import Foundation
import UIKit
import CoreData

protocol AddTransactionProtocol: AnyObject {
    var transactionDate: Date? { get set }
    var transactionImage: UIImage? { get set }
    var transactionTitle: String? { get set }
    var transactionAmount: String? { get set }
    var transactionType: String? { get set }
    var transactionCategory: String? { get set }
    
    var updateRecord: NSManagedObject? { get }
    
    func validateData() -> Bool
    func saveTransactionRecord() -> Bool
    func update() -> Bool
}

class AddTransactionViewModel: AddTransactionProtocol {
    var transactionTitle: String?
    var transactionAmount: String?
    var transactionDate: Date?
    var transactionImage: UIImage?
    var transactionType: String?
    var transactionCategory: String?
    var updateRecord: NSManagedObject? {
        didSet {
            guard let updateRecord = updateRecord else {
                return
            }
            
            transactionTitle = updateRecord.value(forKey:  TransactionHistoryKeys.title.value) as? String
            transactionAmount = "\(updateRecord.value(forKey:  TransactionHistoryKeys.amount.value) as? Double ?? 0.0)"
            transactionCategory = updateRecord.value(forKey:  TransactionHistoryKeys.category.value) as? String
            let type = updateRecord.value(forKey:  TransactionHistoryKeys.type.value) as? Int ?? 1
            transactionType = type == 1 ? "Income" : "Expense"
            if let data = updateRecord.value(forKey:  TransactionHistoryKeys.image.value) as? Data {
                transactionImage = UIImage(data: data)
            }
            
            transactionDate = updateRecord.value(forKey:  TransactionHistoryKeys.date.value) as? Date
        }
    }
        
    func validateData() -> Bool {
        guard let transactionTitle = transactionTitle,
              !transactionTitle.isEmpty,
              let transactionAmount = transactionAmount,
              !transactionAmount.isEmpty,
              let transactionType = transactionType,
              !transactionType.isEmpty,
              let transactionCategory = transactionCategory,
              !transactionCategory.isEmpty,
              let _ = transactionDate else {
            return false
        }
        
        return true
    }
    
    func saveTransactionRecord() -> Bool {
        guard let transactionTitle = transactionTitle,
              !transactionTitle.isEmpty,
              let transactionAmount = transactionAmount,
              !transactionAmount.isEmpty,
              let transactionAmountValue = Double(transactionAmount),
              transactionAmountValue > 0,
              let transactionType = transactionType,
              !transactionType.isEmpty,
              let transactionCategory = transactionCategory,
              !transactionCategory.isEmpty,
              let transactionDate = transactionDate else {
            return false
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let userEntity = NSEntityDescription.entity(forEntityName: TransactionHistoryKeys.entityName.value, in: managedContext) else {
            return false
        }
        
        let transactionTypeIntValue = transactionType == "Income" ? 1 : 0
        
        let record = NSManagedObject(entity: userEntity, insertInto: managedContext)
        record.setValue(transactionTitle, forKeyPath: TransactionHistoryKeys.title.value)
        record.setValue(transactionAmountValue, forKeyPath: TransactionHistoryKeys.amount.value)
        record.setValue(transactionTypeIntValue, forKeyPath: TransactionHistoryKeys.type.value)
        record.setValue(transactionCategory, forKeyPath: TransactionHistoryKeys.category.value)
        record.setValue(transactionDate, forKeyPath: TransactionHistoryKeys.date.value)
        
        if let image = transactionImage, let imageData = image.jpegData(compressionQuality: 0.75) {
            record.setValue(imageData, forKeyPath: TransactionHistoryKeys.image.value)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
        
        return true
    }
    
    func update() -> Bool {
        guard let transactionTitle = transactionTitle,
              !transactionTitle.isEmpty,
              let transactionAmount = transactionAmount,
              !transactionAmount.isEmpty,
              let transactionAmountValue = Double(transactionAmount),
              transactionAmountValue > 0,
              let transactionType = transactionType,
              !transactionType.isEmpty,
              let transactionCategory = transactionCategory,
              !transactionCategory.isEmpty,
              let transactionDate = transactionDate else {
            return false
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let record = updateRecord else {
                  return false
        }
        
        let transactionTypeIntValue = transactionType == "Income" ? 1 : 0
        let managedContext = appDelegate.persistentContainer.viewContext
        record.setValue(transactionTitle, forKeyPath: TransactionHistoryKeys.title.value)
        record.setValue(transactionAmountValue, forKeyPath: TransactionHistoryKeys.amount.value)
        record.setValue(transactionTypeIntValue, forKeyPath: TransactionHistoryKeys.type.value)
        record.setValue(transactionCategory, forKeyPath: TransactionHistoryKeys.category.value)
        record.setValue(transactionDate, forKeyPath: TransactionHistoryKeys.date.value)
        
        if let image = transactionImage, let imageData = image.jpegData(compressionQuality: 0.75) {
            record.setValue(imageData, forKeyPath: TransactionHistoryKeys.image.value)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
        
        return true
    }
}

