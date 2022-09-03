//
//  ReusableProtocol.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/08/31.
//

import Foundation
import UIKit

protocol ReusableProtocol: AnyObject {
    static var reusableIdentifier: String { get }
}

extension ReusableProtocol {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: ReusableProtocol { }

extension UIView: ReusableProtocol { }
