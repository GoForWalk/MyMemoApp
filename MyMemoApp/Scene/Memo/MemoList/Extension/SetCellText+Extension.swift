//
//  Calender+Extension.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/09/03.
//

import UIKit

extension MemoListViewController {
    
    func setCellContext(searchQuery: String, memo: Model) -> NSMutableAttributedString? {
        
        guard var body = memo.memoBody else { return nil }
        
        if body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            body = "(내용없음)"
        }
        
        let bodyString = "\(setDate(memo: memo))   \(body.trimmingCharacters(in: .whitespacesAndNewlines))"
        
        let ranges = bodyString.ranges(of: searchQuery)
        
        let nsRanges = ranges.map {
            return NSRange($0, in: bodyString)
        }
        
        let mutableAttributedString = NSMutableAttributedString.init(string: bodyString)
       
        nsRanges.forEach {
            mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppUIColor.darkYellow.color, range:     $0)
        }
        
        return mutableAttributedString
    }
    
    func setCellTitle(searchQuery: String, memo: Model) -> NSMutableAttributedString? {
        
        let title = memo.memoTitle

        let ranges = title.ranges(of: searchQuery)

        let nsRanges = ranges.map {
            return NSRange($0, in: title)
        }
        
        let mutableAttributedString = NSMutableAttributedString.init(string: title)

        nsRanges.forEach {
            mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppUIColor.darkYellow.color, range: $0)
        }
        return mutableAttributedString
    }
    
    func setDate(memo: Model) -> String {
        
        let date = memo.registerDate
        
        if Calendar.current.isDateInToday(date) {
            setFormatter(dateFormat: "a hh시 mm분")
            return formatter.string(from: date)
        } else if Calendar.current.isDateInThisWeek(date) {
            setFormatter(dateFormat: "EEEE")
            return formatter.string(from: date)
        } else {
            setFormatter(dateFormat: "yyyy.MM.dd a hh:mm")
            return formatter.string(from: date)
        }
        
    }
    
}
