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
            body = "내용 없음"
        }
        
        let bodyString = "\(setDate(memo: memo))\t\(body.trimmingCharacters(in: .whitespacesAndNewlines))"
        
        let stringToColor = searchQuery
        
        let range = (bodyString as NSString).range(of: stringToColor)
        
        let mutableAttributedString = NSMutableAttributedString.init(string: bodyString)
        
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppUIColor.darkYellow.color, range: range)
        
        return mutableAttributedString
    }
    
    func setCellTitle(searchQuery: String, memo: Model) -> NSMutableAttributedString? {
        
        let title = memo.memoTitle
        
//        guard title.contains(searchQuery) else { return nil }
        
        let stringToColor = searchQuery
        
        let range = (title as NSString).range(of: stringToColor)
        
        let mutableAttributedString = NSMutableAttributedString.init(string: title)
        
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppUIColor.darkYellow.color, range: range)
        
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
