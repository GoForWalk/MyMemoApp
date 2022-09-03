//
//  WalkthroughView.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/09/04.
//

import UIKit
import SnapKit

final class WalkThroughView: BaseViewController {
    
    lazy var mainView: UIView = {
        let view = UIView()
        
        view.backgroundColor = AppUIColor.gray.color
        view.layer.cornerRadius = AppUILayer.walkThroughConerRadius
        view.clipsToBounds = true
        
        return view
    }()
    
    let welcomeLabel1: UILabel = {
        let label = UILabel()
        
        label.text = WalkThroughConstant.message1
        label.numberOfLines = 2
        label.textColor = AppUIColor.white.color
        label.backgroundColor = AppUIColor.clear.color
        label.font = AppUIFont.largeTitle.font
        
        return label
    }()
    
    let welcomeLabel2: UILabel = {
        let label = UILabel()
        
        label.text = WalkThroughConstant.message2
        label.numberOfLines = 2
        label.textColor = AppUIColor.white.color
        label.backgroundColor = AppUIColor.clear.color
        label.font = AppUIFont.largeTitle.font
        
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = AppUILayer.walkThroughConerRadius
        button.clipsToBounds = true
        button.setTitle("확인", for: .normal)
        button.setTitleColor(AppUIColor.white.color, for: .normal)
        button.backgroundColor = AppUIColor.darkYellow.color
        button.titleLabel?.font = AppUIFont.largeTitle.font
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayoutConstraint()
    }
    
    override func configureViewController() {
        self.view.backgroundColor = AppUIColor.black.color.withAlphaComponent(0.7)
        
        self.view.addSubview(mainView)
        
        [button, welcomeLabel1, welcomeLabel2].forEach {
            mainView.addSubview($0)
        }
        
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    private func setLayoutConstraint() {
        
        mainView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self.view)
            make.width.equalTo(self.view).multipliedBy(0.72)
            make.height.equalTo(mainView.snp.width)
        }
        
        welcomeLabel1.snp.makeConstraints { make in
            make.leading.top.equalTo(mainView).inset(20)
            make.height.equalTo(mainView).multipliedBy(0.25)
        }
        
        welcomeLabel2.snp.makeConstraints { make in
            make.leading.equalTo(mainView).inset(20)
            make.top.equalTo(welcomeLabel1.snp.bottom).offset(8)
        }
        
        button.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(mainView).inset(20)
            make.height.equalTo(mainView).multipliedBy(0.20)
            make.top.equalTo(welcomeLabel2.snp.bottom).offset(-12)
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        self.dismiss(animated: true) {
            print("set true")
//            UserDefaults.standard.set(true, forKey: WalkThroughConstant.userDefaultKey)
        }
    }
    
    
}
