//
//  String.swift
//  kuryem
//
//  Created by FFK on 23.02.2026.
//

import UIKit

extension String {
    
    func highlight(
        targetWord: String,
        baseColor: UIColor = AppColor.textSecondary,
        baseFont: UIFont = AppFonts.body.withSize(AppLayout.fontSizeXSmall),
        highlightColor: UIColor = AppColor.primary,
        highlightFont: UIFont = UIFont.boldSystemFont(ofSize: AppLayout.fontSizeXSmall)
    ) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(
            string: self,
            attributes: [.foregroundColor: baseColor, .font: baseFont]
        )
        
        return attributedString.highlight(
            targetWord: targetWord,
            highlightColor: highlightColor,
            highlightFont: highlightFont
        )
    }
}

// MARK: - NSMutableAttributedString Extension
extension NSMutableAttributedString {
    func highlight(
        targetWord: String,
        highlightColor: UIColor = AppColor.primary,
        highlightFont: UIFont = UIFont.boldSystemFont(ofSize: AppLayout.fontSizeXSmall)
    ) -> NSMutableAttributedString {
        
        let range = (self.string as NSString).range(of: targetWord)
        
        if range.location != NSNotFound {
            self.addAttribute(.foregroundColor, value: highlightColor, range: range)
            self.addAttribute(.font, value: highlightFont, range: range)
        }
        
        return self 
    }
}
