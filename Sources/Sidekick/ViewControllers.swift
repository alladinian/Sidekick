//
//  File.swift
//  
//
//  Created by Vasilis Akoinoglou on 13/3/20.
//

#if canImport(UIKit)
import UIKit

extension UIViewController {
    func enforceEmptyBackItem() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
}
#endif
