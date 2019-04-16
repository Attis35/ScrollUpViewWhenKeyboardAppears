import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        textInputField.delegate = self
        hideKeyboardWhenTappedAround()
    }
    
// Remove notification observers when view disappears
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        removeObservers()
    }
    
    // Add observers - screen scrolling, if keyboard appears
    private func addObservers() {
        print("Observers added")
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppearance(_:)), name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppearance(_:)), name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    // Remove observers
    private func removeObservers() {
        print("Observers removed")
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
    }
    // Handle screen scroll up and down when keyboard appears
    @objc private func handleKeyboardAppearance(_ notification: Notification) {
        switch notification.name {
            case UIResponder.keyboardWillShowNotification:
                // Keyboard appears
                if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    self.view.frame.origin.y -= (keyboardSize.height - CGFloat((self.tabBarController?.tabBar.frame.height)!)) // Keyboard + Tab bar height
            }
            case UIResponder.keyboardWillHideNotification:
                // Keyboard disappears
                if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    self.view.frame.origin.y += (keyboardSize.height - CGFloat((self.tabBarController?.tabBar.frame.height)!))
            }
            default: break
        }
    }    
    
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
