//
//  MemoEditViewController.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/09/02.
//

import UIKit

final class MemoEditViewController: BaseViewController {
    
    let editView = MemoEditView()
    let memoViewModel = MemoViewModel()
    var originalModel: Model?
    
    override func loadView() {
        self.view = editView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextView()
    }
    
    func setTextView() {
        guard let originalModel = originalModel else {
            return
        }
        editView.textView.text = "\(originalModel.memoTitle)\(originalModel.memoBody!)"
        title = originalModel.memoTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if originalModel == nil {
            memoViewModel.saveData()
            memoViewModel.context.value = ""
        } else {
            memoViewModel.updateData(originalItem: originalModel!)
            memoViewModel.context.value = ""
        }
        
    }
    
    override func configureViewController() {
        editView.textView.delegate = self
    }
    
    override func setNavigationController() {
       
        navigationController?.navigationBar.tintColor = AppUIColor.darkYellow.color
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setBarbuttonItems() {
        let saveBarButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(saveBarButtonTapped(_:)))
        
        let shareBarButton = UIBarButtonItem(image: AppUIImage.share.image, style: .plain, target: self, action: #selector(shareBarrButtonTapped(_:)))

        navigationItem.rightBarButtonItems = [saveBarButton, shareBarButton]
    }

    //MARK: BindData
    override func bindData() {
        memoViewModel.context.bind { context in
            guard let contexts = self.memoViewModel.setMemotitleAndBody(inputText: context) else { return }
            self.title = contexts[0]
        }
        
        memoViewModel.isEditing.bind { bool in
            
            if bool {
                self.setBarbuttonItems()
            } else {
                self.navigationItem.rightBarButtonItems = nil
            }
            
        }
    }
    
    private func setResponder() {
        editView.textView.becomeFirstResponder()
    }
    
    @objc private func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func shareBarrButtonTapped(_ sender: UIBarButtonItem) {
        showActivityViewController(text: self.editView.textView.text)
    }
    
    private func showActivityViewController(text: String) {
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        self.present(vc, animated: true)
    }
}

// MARK: UITextViewDelegate
extension MemoEditViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.memoViewModel.isEditing.value = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.memoViewModel.context.value = textView.text
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.memoViewModel.isEditing.value = false
        
    }
}