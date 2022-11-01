//
//  ReuseIdentifier.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/10/03.
//

import Foundation

protocol ReuseIdentifer: AnyObject {
    
    static var reuseidentifier: String { get set }
    
}

extension ReuseIdentifer {
//    static var reuseidentifier: String { return Self.description}
}
