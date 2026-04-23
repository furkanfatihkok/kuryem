//
//  OrDividerView.swift
//  kuryem
//
//  Created by FFK on 23.02.2026.
//

import UIKit

final class OrDividerView: UIView {
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        let leftLine = UIView()
        leftLine.backgroundColor = AppColor.border
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        
        let rightLine = UIView()
        rightLine.backgroundColor = AppColor.border
        rightLine.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "or"
        label.font = AppFonts.caption
        label.textColor = AppColor.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(leftLine)
        addSubview(rightLine)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            leftLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftLine.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftLine.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -AppLayout.Spacing.xSmall),
            leftLine.heightAnchor.constraint(equalToConstant: AppLayout.Border.regular),
            
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            rightLine.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: AppLayout.Spacing.xSmall),
            rightLine.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightLine.heightAnchor.constraint(equalToConstant: AppLayout.Border.regular),
            
            heightAnchor.constraint(equalToConstant: AppLayout.iconContainer.radius)
        ])
    }
}
