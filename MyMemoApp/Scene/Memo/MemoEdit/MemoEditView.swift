//
//  MemoEditView.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/09/02.
//

import UIKit
import SnapKit

final class MemoEditView: BaseView {
    
    let textView: UITextView = {
        let textView = UITextView()
        
        textView.backgroundColor = AppUIColor.clear.color
        textView.textColor = AppUIColor.white.color
        textView.font = AppUIFont.memoEditFont.font
        
        return textView
    }()
    
    override func configureUI() {
        backgroundColor = AppUIColor.black.color
        
        self.addSubview(textView)
    }
    
    override func layoutConstraint() {
        textView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(8)
        }
    }
    
}
