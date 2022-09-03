//
//  BaseViewController.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/08/31.
//

import UIKit

class BaseViewController: UIViewController {
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        setNavigationController()
        setFormatterOptions()
        configureViewController()
        bindData()
    }
    
    func setNavigationController() {
        
    }
    
    func configureViewController() {
        
    }
    
    func bindData() {
        
    }
    
    private func setFormatterOptions() {
        formatter.timeZone = TimeZone(identifier: "ko-kr")
    }
    
    func setFormatter(dateFormat: String) {
        formatter.dateFormat = dateFormat
    }
    
}
