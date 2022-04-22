//
//  DashboardHeaderView.swift
//  Spendwise
//
//  Created by ONS on 21/04/22.
//

import UIKit

class DashboardHeaderView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lblTotalBalance: UILabel!
    @IBOutlet weak var lblTotalExpense: UILabel!
    @IBOutlet weak var lblTotalIncome: UILabel!
    
    var totalIncome: Double = 0 {
        didSet {
            lblTotalIncome.text = "$\(String(format: "%.2f", totalIncome))"
            getTotalBalance()
        }
    }
    
    var totalExpense: Double = 0 {
        didSet {
            lblTotalExpense.text = "$\(String(format: "%.2f", totalExpense))"
            getTotalBalance()
        }
    }

    init(width: Double, text: String) {
        let rect = CGRect(x: 0.0, y: 0.0, width: width, height: 300)
        super.init(frame: rect)
        initialSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetting() {
        Bundle.main.loadNibNamed("DashboardHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func getTotalBalance() {
        let totalBalance = totalIncome - totalExpense
        lblTotalBalance.text = "$\(String(format: "%.2f", totalBalance))"
    }
}
