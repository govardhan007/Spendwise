
import UIKit

enum AlertActionType {
    case ok
    case cancel
    case delete
    case confirm
    case settings
    case doNotCancel
    case none
    
    var title: String {
        switch self {
        case .ok:
            return "Ok"
        case .cancel:
            return "Cancel"
        case .delete:
            return "Delete"
        case .confirm:
            return "Confirm"
        case .doNotCancel:
            return "Don't Cancel"
        case .settings:
            return "Settings"
        case .none:
            return "Ok"
        }
    }
    
    var style: UIAlertAction.Style {
        switch self {
        case .ok, .confirm, .delete, .none, .settings:
            return .default
        case .cancel, .doNotCancel:
            return .cancel
        }
    }
}

struct AlertModel {
    let title: String
    let message: String
    let style: UIAlertController.Style
    let types: [AlertActionType]
}
