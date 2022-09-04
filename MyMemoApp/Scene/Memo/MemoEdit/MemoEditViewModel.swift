//
//  MemoEditViewModel.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/09/05.
//

import Foundation
import RealmSwift

final class MemoEditViewModel {
    
    private let repository: MemoRepositroyType = MemoRepositroy()

    var isEditing: Observable<Bool> = Observable(false)
    var context: Observable<String> = Observable("")

    func saveData() {
        guard !context.value.isEmpty, let contents = setMemotitleAndBody(inputText: context.value) else { return }
        
        self.repository.uploadMemo(item: Model(memoTitle: contents[0], memoBody: contents[1], registerDate: Date()))
    }

    func updateData(originalItem: Model) {
        
        if context.value.isEmpty { return }
        guard let tempContexts = setMemotitleAndBody(inputText: context.value) else { return }
        repository.updateMemo(item: originalItem, newTitle: tempContexts[0], newBody: tempContexts[1])
    }

    func setMemotitleAndBody(inputText: String) -> [String]? {
        var inputText = inputText
        
        let title = inputText.components(separatedBy: "\n").first
        
        guard let title = title else { return nil }
        
        title.forEach { _ in
            inputText.removeFirst()
        }
        return [title, inputText]
    }

}
