//
//  OnboardingCell.swift
//  kuryem
//
//  Created by FFK on 20.02.2026.
//

import UIKit

final class OnboardingCell: UICollectionViewCell {
    
    static let reuseIdentifier = CellConstants.reuseIdentifier

    // MARK: - UI Components
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.h3
        label.textColor = AppColor.textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.bodySmall
        label.textColor = AppColor.textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: AppLayout.Spacing.xxLarge),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 375),
            imageView.heightAnchor.constraint(equalToConstant: 250),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: AppLayout.Spacing.xLarge),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: AppLayout.Spacing.xSmall),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -AppLayout.Spacing.xSmall),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: AppLayout.Spacing.small),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: AppLayout.Spacing.xSmall),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -AppLayout.Spacing.xSmall),
        ])
    }

    // MARK: - Configuration
    func configure(with page: OnboardingPage) {
        imageView.image = UIImage(named: page.imageName)
        titleLabel.text = page.title
        descriptionLabel.text = page.description
    }
}
