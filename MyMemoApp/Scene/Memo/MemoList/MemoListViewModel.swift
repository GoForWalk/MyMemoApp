//
//  MemoViewModel.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/09/01.
//

import Foundation
import RealmSwift

final class MemoListViewModel {
    
    private let repository: MemoRepositroyType = MemoRepositroy()
    
    var memoData: Observable<Results<Model>?> = Observable(nil)
    var pinnedMemoData: Observable<Results<Model>?> = Observable(nil)
    var searchMemoData: Observable<Results<Model>?> = Observable(nil)
    var searchQuery: Observable<String> = Observable("")
    var isSearching: Observable<Bool> = Observable(false)
    
    var tableType: Observable<TableType> = Observable(.memoOnly)
        
    func getAllData() {
        fetchData(tableType: .memo)
        fetchData(tableType: .pinnedMemo)
        fetchData(tableType: .searchingMemo, searchQuery: searchQuery.value)
    }
        
    func fetchData(tableType: TableSectionType, searchQuery: String = "") {
        switch tableType {
        case .pinnedMemo:
            pinnedMemoData.value = repository.fetchPinnedMemo()
        case .memo:
            memoData.value = repository.fetchMemo()
        case .searchingMemo:
            searchMemoData.value = repository.fetchSearchedMemo(query: searchQuery)
        }
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
    
    private func checkSection(indexpath: IndexPath) -> Results<Model>? {
        
        var tempTable: Results<Model>?
        
        if isSearching.value {
            return searchMemoData.value
        }
        
        if pinnedMemoData.value?.count == 0 {
            return memoData.value
        }
        
        switch indexpath.section {
        case TableSectionType.pinnedMemo.rawValue:
            tempTable = pinnedMemoData.value
            
        case TableSectionType.memo.rawValue:
            tempTable = memoData.value
            
        default:
            tempTable = nil
        }
        return tempTable
    }
        
}
