//
//  BaseView.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/08/31.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        layoutConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        backgroundColor = AppUIColor.gray.color
    }
    
    func layoutConstraint() {
        
    }

    
}
