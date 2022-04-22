//
//  AddTransactionViewController.swift


import UIKit

class AddTransactionViewController: UIViewController {
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var buttonAddTransaction: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblTransactionType: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel: AddTransactionProtocol?
    
    let pickerController: UIImagePickerController = {
        let pickerController = UIImagePickerController()
        pickerController.allowsEditing = false
        pickerController.sourceType = .photoLibrary
        return pickerController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let viewModel = viewModel, let _ = viewModel.updateRecord {
            txtTitle.text = viewModel.transactionTitle
            txtAmount.text = viewModel.transactionAmount
            lblCategory.text = viewModel.transactionCategory
            lblTransactionType.text = viewModel.transactionType
            imageView.image = viewModel.transactionImage
            datePicker.date = viewModel.transactionDate ?? Date()
        }
    }
    
    private func initialSetting() {
        datePicker.date = Date()
        datePicker.maximumDate = Date()
        if viewModel == nil {
            viewModel = AddTransactionViewModel()
        }
        
        pickerController.delegate = self
        if let viewModel = viewModel, let _ = viewModel.updateRecord {
            title = "Update Transaction"
        } else {
            title = "Add Transaction"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TransactionViewControllerSegue",
           let viewController = segue.destination as? TransactionViewController {
            viewController.delegate = self
        } else if segue.identifier == "TransactionTypeViewControllerSegue",
                  let viewController = segue.destination as? TransactionCategoryViewController {
                viewController.delegate = self
        }
    }
    
    @IBAction func didClickOnAddImage(_ sender: Any) {
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func didClickOnAddTransaction(_ sender: Any) {
        view.endEditing(true)
        viewModel?.transactionDate = datePicker.date
        if viewModel?.updateRecord != nil {
            updateTransaction()
        } else {
            addNewTransaction()
        }
    }
    
    private func addNewTransaction() {
        if viewModel?.validateData() ?? false,
            viewModel?.saveTransactionRecord() ?? false {
            self.showAlert(alertModel: AlertModel(title: "Success", message: "Transaction record added.", style: .alert, types: [.ok])) { actionType in
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.showAlert(title: "Wait!!", message: "Please fill all the fields", actionName: "Ok")
        }
    }
    
    private func updateTransaction() {
        if viewModel?.validateData() ?? false,
            viewModel?.update() ?? false {
            self.showAlert(alertModel: AlertModel(title: "Success", message: "Transaction record updated.", style: .alert, types: [.ok])) { actionType in
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.showAlert(title: "Wait!!", message: "Please fill all the fields", actionName: "Ok")
        }
    }
}

extension AddTransactionViewController: TransactionViewControllerDelegate {
    func didSelectTransactionType(title: String?) {
        viewModel?.transactionType = title
        lblTransactionType.text = title
    }
}

extension AddTransactionViewController: TransactionCategoryControllerDelegate {
    func didSelectTransactionCategory(title: String?) {
        viewModel?.transactionCategory = title
        lblCategory.text = title
    }
}
 
extension AddTransactionViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        imageView.image = image
        viewModel?.transactionImage = image
        dismiss(animated: true, completion: nil)
    }
}

extension AddTransactionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtTitle {
            viewModel?.transactionTitle = textField.text
        } else {
            viewModel?.transactionAmount = textField.text
        }
    }
}

extension AddTransactionViewController {
    static func instantiateWithController(viewModel: AddTransactionProtocol) -> AddTransactionViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let dashboardViewController = storyboard.instantiateViewController(withIdentifier: "AddTransactionViewController") as? AddTransactionViewController else {
           return nil
        }
        
        dashboardViewController.viewModel = viewModel
        return dashboardViewController
    }
}

