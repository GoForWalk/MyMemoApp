//
//  TableType.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/09/03.
//

import Foundation

enum TableSectionType: Int {
    case pinnedMemo
    case memo
    case searchingMemo
    
    var sectionTitle: String {
        switch self {
        case .pinnedMemo:
            return "고정된 메모"
        case .memo:
            return "메모"
        case .searchingMemo:
            return "0개 찾음"
        }
    }
    
    var backButtonTitle: String {
        switch self {
        case .pinnedMemo, .memo:
            return "메모"
        case .searchingMemo:
            return "검색"
        }
    }
}
