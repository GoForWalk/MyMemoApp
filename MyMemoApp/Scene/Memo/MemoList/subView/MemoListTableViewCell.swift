//
//  MemoListTableViewCell.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/08/31.
//

import UIKit
import SnapKit

class MemoListTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
       let label = UILabel()
        
        label.textColor = AppUIColor.white.color
        label.font = AppUIFont.memoTitle.font
        label.backgroundColor = AppUIColor.clear.color
        label.text = "titleLabel"
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = AppUIColor.lightgray.color
        label.font = AppUIFont.memoDetailFont.font
        label.backgroundColor = AppUIColor.clear.color
        label.text = "bodyLabel"
        return label
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = AppUIColor.gray.color
        configureCell()
        setLayoutConstaint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        self.layoutMargins = UIEdgeInsets.zero
        [titleLabel, bodyLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    func setLayoutConstaint() {
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(8)
            make.top.equalTo(self.snp.top).inset(6)
        }
        
        bodyLabel.snp.makeConstraints { make in
            make.trailing.leading.equalTo(self).inset(8)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.bottom.equalTo(self).inset(6)
        }
    }
    
}
