//
//  Repository.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/08/31.
//

import Foundation
import RealmSwift

protocol MemoRepositroyType {
    
    func fetchMemo() -> Results<Model>
    func fetchPinnedMemo() -> Results<Model>
    func fetchSearchedMemo(query: String) -> Results<Model>
    
    func uploadMemo(item: Model)
    
    func updateMemo(item: Model, newTitle: String, newBody: String)
    func updatePin(item: Model)
    
    func deleteMemoItem(item: Model)
}

struct MemoRepositroy: MemoRepositroyType {
    
    private let localRealm = try! Realm()
        
    func fetchMemo() -> Results<Model> {
        return localRealm.objects(Model.self).sorted(byKeyPath: "registerDate", ascending: false)
    }//: fetchMemo() -> Results<Model>
    
    func fetchPinnedMemo() -> Results<Model> {
        return localRealm.objects(Model.self).where { model in
            model.isPinned == true
        }.sorted(byKeyPath: "registerDate", ascending: false)
    }//: fetchPinnedMemo() -> Results<Model>
    
    func fetchSearchedMemo(query: String) -> Results<Model> {
        
        let resultTask = localRealm.objects(Model.self).where { model in
            model.memoTitle.contains(query) || model.memoBody.contains(query)
        }.sorted(byKeyPath: "registerDate", ascending: false)
        
        return resultTask
    }//: fetchSearchedMemo(query: String) -> Results<Model>
    
    func uploadMemo(item: Model) {
        do {
            try localRealm.write {
                localRealm.add(item)
                print(#function, "done")
            }
        } catch let error as NSError {
            print(#function, error)
        }
        
    }//: uploadMemo
    
    func updateMemo(item: Model, newTitle: String, newBody: String) {
        
        do {
            try localRealm.write {
                
                let editedMemo = Model(value: [
                    "uuid": item.uuid,
                    "memoTitle": newTitle,
                    "memoBody": newBody,
                    "isPinned": item.isPinned,
                    "registerDate": item.registerDate
                ])
                
                localRealm.add(editedMemo, update: .modified)
                print(#function, "done")
            }
        } catch let error as NSError {
            print(#function, error)
        }
        
    }//: updateMemo
    
    func updatePin(item: Model) {
        
        do {
            try localRealm.write {
                item.isPinned = !item.isPinned
            }
        } catch let error as NSError {
            print(#function, error)
        }
        
    }//: updatePinn(item: Model)
    
    func deleteMemoItem(item: Model) {
        
        do {
            try localRealm.write {
                localRealm.delete(item)
            }
        } catch let error as NSError {
            print(#function, error)
        }
        
    }//: deleteMemoItem(item: Model)
    
}

