//
//  Model.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/08/31.
//

import Foundation
import RealmSwift

protocol ModelType: AnyObject {
    var memoTitle: String { get set }
    var memoBody: String? { get set }
    var registerDate: Date { get set }
    var isPinned: Bool { get set }
    var uuid: ObjectId { get set }
}

final class Model: Object, ModelType {
    
    @Persisted var memoTitle: String
    @Persisted var memoBody: String?
    @Persisted(indexed: true) var registerDate: Date
    @Persisted var isPinned: Bool
    
    @Persisted(primaryKey: true) var uuid: ObjectId
    
    convenience init(memoTitle: String, memoBody: String?, registerDate: Date) {
        self.init()
        self.memoTitle = memoTitle
        self.memoBody = memoBody
        self.registerDate = registerDate
        self.isPinned = false
    }
}
