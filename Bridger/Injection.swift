import UIKit

extension UIViewController { //5

    #if DEBUG //1
    @objc func injected() { //2
        for subview in self.view.subviews { //3
            subview.removeFromSuperview()
        }

        viewDidLoad() //4
    }
    #endif
}
