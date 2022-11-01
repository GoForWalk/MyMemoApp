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
    
    var memoData: CustomObservable<Results<Model>?> = CustomObservable(nil)
    var pinnedMemoData: CustomObservable<Results<Model>?> = CustomObservable(nil)
    var searchMemoData: CustomObservable<Results<Model>?> = CustomObservable(nil)
    var searchQuery: CustomObservable<String> = CustomObservable("")
    var isSearching: CustomObservable<Bool> = CustomObservable(false)
    
    var tableType: CustomObservable<TableType> = CustomObservable(.memoOnly)
        
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
        getAllData()
    }
    
    func setpinned(indexPath: IndexPath) {
        
        guard let updateTabel = checkSection(indexpath: indexPath) else { return }
        
        repository.updatePin(item: updateTabel[indexPath.row])
        fetchData(tableType: .pinnedMemo)
    }
    
    private func checkSection(indexpath: IndexPath) -> Results<Model>? {
        
        var tempTable: Results<Model>?
        
        switch tableType.value {
        case .searching:
            return searchMemoData.value
        
        case .memoOnly:
            return memoData.value

        case .memoAndPinnedMemo:
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
        
}
