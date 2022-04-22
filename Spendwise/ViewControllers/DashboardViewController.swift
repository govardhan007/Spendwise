
//  HomeViewController.swift


import UIKit

class DashboardViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var viewModel: DashboardViewModelProtocol?
    var headerView: DashboardHeaderView?
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let isSuccess = viewModel?.retrieveTransactionHistory() ?? false
        if isSuccess, viewModel?.numberOfRows ?? 0 > 0 {
            setTableData()
        }
    }

    private func initialSetting() {
        viewModel = DashboardViewModel()
        tableView.register(UINib(nibName: DashboardHistoryCell.identifier, bundle: nil), forCellReuseIdentifier: DashboardHistoryCell.identifier)
        
        headerView = DashboardHeaderView(width: tableView.frame.size.width, text: "")
        tableView.tableHeaderView = headerView
    }
    
    private func setTableData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.headerView?.totalExpense = self.viewModel?.totalExpense ?? 0.0
            self.headerView?.totalIncome = self.viewModel?.totalIncome ?? 0.0
        }
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DashboardHistoryCell.identifier) as? DashboardHistoryCell else {
            return UITableViewCell()
        }
        
        cell.record = viewModel?.getRecordFor(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel?.heightForRow ?? 0)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let isSuccess = viewModel?.deleteData(index: indexPath.row) ?? false
            if isSuccess {
                tableView.deleteRows(at: [indexPath], with: .fade)
                setTableData()
            }
        } 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = AddTransactionViewModel()
        viewModel.updateRecord = self.viewModel?.getRecordFor(index: indexPath.row)
        guard let viewController = AddTransactionViewController.instantiateWithController(viewModel: viewModel) else {
            return
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension DashboardViewController {
    static func instantiateWithController(viewModel: DashboardViewModelProtocol) -> DashboardViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let dashboardViewController = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController else {
           return nil
        }
        
        dashboardViewController.viewModel = viewModel
        return dashboardViewController
    }
}

