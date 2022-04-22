
import UIKit

extension UIViewController {
    typealias AlertCompletionHandler = (_ actionType: AlertActionType) -> Void
    
    func showAlert(alertModel: AlertModel, handler: @escaping AlertCompletionHandler) {
        let alert = UIAlertController(title: alertModel.title, message: alertModel.message, preferredStyle: alertModel.style)
        
        alertModel.types.forEach { type in
            let title = type.title
            let action = UIAlertAction(title: title, style: type.style) { _ in
                handler(type)
            }
            
            alert.addAction(action)
        }
        
        self.present(alert, animated: true)
    }
    
    @objc func showAlert(title: String, message: String, actionName: String) {
        let alertModel = AlertModel(title: title, message: message, style: .alert, types: [.ok])
        showAlert(alertModel: alertModel) { (type) in }
    }
}
