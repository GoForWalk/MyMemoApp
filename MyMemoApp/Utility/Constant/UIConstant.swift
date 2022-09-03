//
//  UIConstants.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/08/31.
//

import UIKit

enum AppUIColor {
    case black
    case white
    case yellow
    case red
    case gray
    case darkYellow
    case lightgray
    case clear
}

extension AppUIColor {
    
    var color: UIColor {
        switch self {
        case .black:
            return .black
        case .white:
            return .white
        case .yellow:
            return .systemYellow
        case .red:
            return .systemRed
        case .gray:
            return #colorLiteral(red: 0.1137255058, green: 0.1137255058, blue: 0.1137255058, alpha: 1)
        case .darkYellow:
            return #colorLiteral(red: 0.9986920953, green: 0.7267438769, blue: 0.01910800487, alpha: 1)
        case .lightgray:
            return .lightGray
        case .clear:
            return .clear
        }
    }
    
}

enum AppUIFont {
    case largeTitle
    case memoTitle
    case memoDetailFont
    case memoEditFont
}

extension AppUIFont {
    
    var font: UIFont {
        switch self {
        case .largeTitle:
            return .systemFont(ofSize: 24, weight: .bold)
        case .memoTitle:
            return .systemFont(ofSize: 16, weight: .semibold)
        case .memoDetailFont:
            return .systemFont(ofSize: 13, weight: .regular)
        case .memoEditFont:
            return .systemFont(ofSize: 14, weight: .regular)
        }
    }
}

enum AppUILayer {
    
    static let customConerRadius: CGFloat = 8
    static let walkThroughConerRadius: CGFloat = 16
}

enum AppUIImage {
    case editImage
    case delete
    case pin
    case pinCross
    case share
}

extension AppUIImage {
    var image: UIImage {
        switch self {
        case .editImage:
            return UIImage(systemName: "square.and.pencil")!
        case .delete:
            return UIImage(systemName: "trash.fill")!
        case .pin:
            return UIImage(systemName: "pin.fill")!
        case .pinCross:
            return UIImage(systemName: "pin.slash.fill")!
        case .share:
            return UIImage(systemName: "square.and.arrow.up")!
        }
    }
}

enum AppToastMessage {
    static let message = """
    고정된 메세지가 너무 많아요 :(
    (5개 까지 표시됩니다)
    """
}

enum WalkThroughConstant {
    static let message1 = "처음 오셨군요!\n환영합니다 :)"
    static let message2 = "당신만의 메모를 작성하고\n관리해보세요!"
    static let userDefaultKey = "hadOpend"
}
