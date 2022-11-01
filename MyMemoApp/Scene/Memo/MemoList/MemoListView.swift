//
//  MemoListView.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/08/31.
//

import UIKit
import SnapKit


final class MemoListViewUI: BaseView  {
    
    let safeAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = AppUIColor.black.color
        return view
    }()
    
    lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: 100, height: 100))

        let appearance = UIToolbarAppearance()
        appearance.backgroundColor = AppUIColor.black.color
        toolbar.compactAppearance = appearance
        toolbar.standardAppearance = appearance
        
        if #available(iOS 15, *) {
            toolbar.scrollEdgeAppearance = appearance
        }
        
        return toolbar
    }()
        
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 330, height: 300), style: .insetGrouped)
        tableView.sectionHeaderHeight = 60
        tableView.register(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: TableHeaderView.description())
        
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        tableView.layer.cornerRadius = AppUILayer.customConerRadius
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = AppUIColor.black.color.cgColor
        tableView.clipsToBounds = true
        tableView.backgroundColor = AppUIColor.clear.color
        
        return tableView
    }()
        
    override func configureUI() {
        super.configureUI()
        
        [tableView].forEach {
            safeAreaView.addSubview($0)
        }
        
        [safeAreaView, toolbar].forEach {
            self.addSubview($0)
        }
        
    }
    
    override func layoutConstraint() {
        
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaView).inset(8)
            make.bottom.equalTo(safeAreaView).inset(8)
        }
        
        safeAreaView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        toolbar.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
    }//: layoutConstraint
    
}
