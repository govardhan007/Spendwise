//
//  DashboardHistoryCell.swift
//  Spendwise
//
//  Created by Govardhan on 04/19/22.
//

import UIKit
import CoreData

class DashboardHistoryCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgView: UIImageView!

    var record: NSManagedObject? {
        didSet {
            guard let record = record else {
                return
            }
            
            guard let title = record.value(forKey: TransactionHistoryKeys.title.value) as? String,
                  let amount = record.value(forKey: TransactionHistoryKeys.amount.value) as? Double,
                  let category = record.value(forKey: TransactionHistoryKeys.category.value) as? String,
                  let date = record.value(forKey: TransactionHistoryKeys.date.value) as? Date,
                  let type = record.value(forKey: TransactionHistoryKeys.type.value) as? Int else {
                      return
                  }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
            let dateInString = dateFormatter.string(from: date)
            
            lblTitle.text = title
            lblSubTitle.text = category
            lblPrice.text = "$\(String(format: "%.2f", amount))"
            lblDate.text = dateInString
            lblPrice.textColor = type == 1 ? UIColor(red: 0, green: 144/255, blue: 81/255, alpha: 1) : .red

            if let imageData = record.value(forKey: TransactionHistoryKeys.image.value) as? Data {
                imgView.image = UIImage(data: imageData)
            }
        }
    }
}

extension DashboardHistoryCell {
    static let identifier = "DashboardHistoryCell"
}
