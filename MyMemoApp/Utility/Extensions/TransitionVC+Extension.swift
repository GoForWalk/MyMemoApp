//
//  TransitionVC+Extension.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/09/03.
//

import UIKit

enum TransitionType {
    case push
    case present
}

extension UIViewController {
    
    func presentVC<T: UIViewController>(viewController: T, transitionType: TransitionType) {
        
        switch transitionType {
        case .push:
            navigationController?.pushViewController(viewController, animated: true)
        case .present:
            present(viewController, animated: true)
        }
        
    }
    
    
    
}
