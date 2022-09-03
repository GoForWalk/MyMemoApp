//
//  Alert+Extension.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/09/04.
//

import UIKit

extension BaseViewController {
    
    func showAlert(title: String?, message: String?, onOK: @escaping (UIAlertAction) -> Void) {
        
        let alertVc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .destructive, handler: onOK)
        
        let cancel = UIAlertAction(title: "취소", style: .default)
        
        alertVc.addAction(ok)
        alertVc.addAction(cancel)
        
        present(alertVc, animated: true)
    }
}
