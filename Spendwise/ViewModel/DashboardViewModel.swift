//
//  DashboardViewModel.swift


import UIKit
import CoreData

protocol DashboardViewModelProtocol: AnyObject {
    var numberOfRows: Int { get }
    var heightForRow: Double { get }
    var totalIncome: Double { get }
    var totalExpense: Double { get }
    
    func retrieveTransactionHistory() -> Bool
    func getRecordFor(index: Int) -> NSManagedObject?
    func deleteData(index: Int) -> Bool
}

class DashboardViewModel: DashboardViewModelProtocol {
    private var transactionHistory = [NSManagedObject]()
    
    init() {
        let _ = retrieveTransactionHistory()
    }
    
    var numberOfRows: Int {
        return transactionHistory.count
    }
    
    var heightForRow: Double {
        return 90
    }
    
    var totalIncome: Double {
        var incomes = 0.0
        for record in transactionHistory {
            guard let type = record.value(forKey: TransactionHistoryKeys.type.value) as? Int,
                  type == 1,
                  let amount = record.value(forKey: TransactionHistoryKeys.amount.value) as? Double else {
                      continue
                  }
            
            incomes += amount
        }
        
        return incomes
    }
    
    var totalExpense: Double {
        var expenses = 0.0
        for record in transactionHistory {
            guard let type = record.value(forKey: TransactionHistoryKeys.type.value) as? Int,
                  type != 1,
                  let amount = record.value(forKey: TransactionHistoryKeys.amount.value) as? Double else {
                      continue
                  }
            
            expenses += amount
        }
        
        return expenses
    }
    
    func retrieveTransactionHistory() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: TransactionHistoryKeys.entityName.value)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            guard let results = result as? [NSManagedObject] else {
                return false
            }
            
            transactionHistory = results
        } catch {
            return false
        }
        
        return true
    }
    
    func deleteData(index: Int) -> Bool {
        guard transactionHistory.count > index,
              let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                  return false
              }
        
        let record = transactionHistory[index]
        let title = record.value(forKey: TransactionHistoryKeys.title.value) as? String
        guard let title = title else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: TransactionHistoryKeys.entityName.value)
        
        fetchRequest.predicate = NSPredicate(format: "\(TransactionHistoryKeys.title.value) = %@", "\(title)")
        do {
            let records = try managedContext.fetch(fetchRequest)
            guard records.count > 0,
                  let recordToDelete = records[0] as? NSManagedObject else {
                      return false
                  }
            
            managedContext.delete(recordToDelete)
            do {
                try managedContext.save()
            } catch {
                return false
            }
        } catch {
            return false
        }
        
        transactionHistory.remove(at: index)
        return true
    }
    
    func getRecordFor(index: Int) -> NSManagedObject? {
        guard transactionHistory.count > index else {
            return nil
        }
        
        return transactionHistory[index]
    }
}
