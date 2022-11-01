//
//  Observable.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/09/01.
//

import Foundation

final class CustomObservable<T> {
    
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            print("didset: ", value)
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}
