//
//  MemoViewModel.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/09/01.
//

import Foundation
import RealmSwift

final class MemoViewModel {
    
    private let repository: MemoRepositroyType = MemoRepositroy()
    
    var searchQuery: Observable<String> = Observable("")
    var navTitle: Observable<String> = Observable("")
    var memoData: Observable<Results<Model>?> = Observable(nil)
    var pinnedMemoData: Observable<Results<Model>?> = Observable(nil)
    var searchMemoData: Observable<Results<Model>?> = Observable(nil)
    
    var isSearching: Observable<Bool> = Observable(false)
    var isEditing: Observable<Bool> = Observable(false)
    
    var context: Observable<String> = Observable("")
        
    func getAllData() {
        fetchData(tableType: .memo)
        fetchData(tableType: .pinnedMemo)
        fetchData(tableType: .searchingMemo, searchQuery: searchQuery.value)
    }
        
    func fetchData(tableType: TableType, searchQuery: String = "") {
        switch tableType {
        case .pinnedMemo:
            pinnedMemoData.value = repository.fetchPinnedMemo()
        case .memo:
            memoData.value = repository.fetchMemo()
        case .searchingMemo:
            searchMemoData.value = repository.fetchSearchedMemo(query: searchQuery)
        }
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
    
    func saveData() {
        guard !context.value.isEmpty, let contents = setMemotitleAndBody(inputText: context.value) else { return }
        
        self.repository.uploadMemo(item: Model(memoTitle: contents[0], memoBody: contents[1], registerDate: Date()))
        fetchData(tableType: .memo)
    }
    
    func deleteData(indexpath: IndexPath) {
        
        guard let deleteTable = checkSection(indexpath: indexpath) else { return }
        
        repository.deleteMemoItem(item: deleteTable[indexpath.row])
        fetchData(tableType: .memo)
    }
    
    func setpinned(indexPath: IndexPath) {
        
        guard let updateTabel = checkSection(indexpath: indexPath) else { return }
        
        repository.updatePin(item: updateTabel[indexPath.row])
        fetchData(tableType: .pinnedMemo)
    }
    
    func checkSection(indexpath: IndexPath) -> Results<Model>? {
        
        var tempTable: Results<Model>?
        
        if isSearching.value {
            return searchMemoData.value
        }
        
        if pinnedMemoData.value?.count == 0 {
            return memoData.value
        }
        
        switch indexpath.section {
        case TableType.pinnedMemo.rawValue:
            tempTable = pinnedMemoData.value
            
        case TableType.memo.rawValue:
            tempTable = memoData.value
            
        default:
            tempTable = nil
        }
        return tempTable
    }
    
    func updateData(originalItem: Model) {
        
        if context.value.isEmpty { return }
        guard let tempContexts = setMemotitleAndBody(inputText: context.value) else { return }
        repository.updateMemo(item: originalItem, newTitle: tempContexts[0], newBody: tempContexts[1])
    }
    
}
