//
//  MemoEditViewController.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/09/02.
//

import UIKit

final class MemoEditViewController: BaseViewController {
    
    let editView = MemoEditView()
    let memoEditViewModel = MemoEditViewModel()
    var originalModel: Model?
    var isSearching = false
    
    override func loadView() {
        self.view = editView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextView()
    }
    
    private func setTextView() {
        guard let originalModel = originalModel else {
            return
        }
        editView.textView.text = "\(originalModel.memoTitle)\(originalModel.memoBody!)"
        title = originalModel.memoTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .never
        setBackbuttonTitle()
        setResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if originalModel != nil {
            memoEditViewModel.updateData(originalItem: originalModel!)
            memoEditViewModel.context.value = ""
            
        } else {
            memoEditViewModel.saveData()
            memoEditViewModel.context.value = ""
        }
        
    }
    
    override func configureViewController() {
        editView.textView.delegate = self
    }
    
    override func setNavigationController() {
       
        navigationController?.navigationBar.tintColor = AppUIColor.darkYellow.color
    }
    
    private func setBarbuttonItems() {
        let saveBarButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(saveBarButtonTapped(_:)))
        
        let shareBarButton = UIBarButtonItem(image: AppUIImage.share.image, style: .plain, target: self, action: #selector(shareBarrButtonTapped(_:)))

        navigationItem.rightBarButtonItems = [saveBarButton, shareBarButton]
    }

    //MARK: BindData
    override func bindData() {
        memoEditViewModel.context.bind { context in
            guard let contexts = self.memoEditViewModel.setMemotitleAndBody(inputText: context) else { return }
            self.title = contexts[0]
        }
        
        memoEditViewModel.isEditing.bind { bool in
            
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
    
    private func setBackbuttonTitle() {
                
        if self.isSearching == true {
            self.navigationController?.navigationBar.topItem?.title = "검색"
            return
        }
        self.navigationController?.navigationBar.topItem?.title = "메모"
    }
}

// MARK: UITextViewDelegate
extension MemoEditViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.memoEditViewModel.isEditing.value = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.memoEditViewModel.context.value = textView.text
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.memoEditViewModel.isEditing.value = false
        
    }
}
