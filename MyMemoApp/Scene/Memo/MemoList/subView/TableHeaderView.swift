//
//  TableHeaderView.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/08/31.
//

import UIKit
import SnapKit

class TableHeaderView: UITableViewHeaderFooterView {
    
    let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppUIFont.largeTitle.font
        label.textColor = AppUIColor.white.color
        label.backgroundColor = .clear
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureUI()
        layoutConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.addSubview(headerTitleLabel)
    }

    func layoutConstraint() {
        headerTitleLabel.snp.makeConstraints { make in
            make.trailing.top.equalTo(self)
            make.bottom.equalTo(self).inset(6)
            make.leading.equalTo(self).inset(8)
        }
    }
    
}
