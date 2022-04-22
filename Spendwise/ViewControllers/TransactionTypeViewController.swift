//
//  TransactionTypeViewController.swift

import UIKit

protocol TransactionCategoryControllerDelegate: AnyObject {
    func didSelectTransactionCategory(title: String?)
}

class TransactionCategoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: TransactionCategoryViewModelProtocol?
    weak var delegate: TransactionCategoryControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetting()
    }

    private func initialSetting() {
        viewModel = TransactionCategoryViewModel()
        tableView.register(UINib(nibName: TitleCell.identifier, bundle: nil), forCellReuseIdentifier: TitleCell.identifier)
    }
}

extension TransactionCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleCell.identifier) as? TitleCell else {
            return UITableViewCell()
        }
        
        let index = indexPath.row
        cell.lblTitle.text = viewModel?.titleForRow(index: index)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel?.heightForRow ?? 0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = viewModel?.titleForRow(index: indexPath.row)
        delegate?.didSelectTransactionCategory(title: title)
        navigationController?.popViewController(animated: true)
    }
}
