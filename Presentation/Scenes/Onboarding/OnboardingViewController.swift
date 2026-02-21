//
//  ViewController.swift
//  kuryem
//
//  Created by FFK on 19.02.2026.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: OnboardingViewModel
    private var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
            updateButtonTitle()
        }
    }
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: OnboardingCell.reuseIdentifier)
        return collectionView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = AppColor.primary
        pageControl.pageIndicatorTintColor = AppColor.border
        pageControl.isUserInteractionEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var nextButton: PrimaryButton = {
        let button = PrimaryButton(title: Localized.Onboarding.next)
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCylce
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupCollectionView()
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.backgroundColor = AppColor.background
        
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        
        pageControl.numberOfPages = viewModel.pages.count
    }
    
    private func setupConstraints() {
    NSLayoutConstraint.activate([
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        collectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -AppLayout.spacingLarge),
            
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -AppLayout.spacingXLarge),
            
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppLayout.paddingHorizontal),
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppLayout.paddingHorizontal),
        nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -AppLayout.spacingXLarge),
        nextButton.heightAnchor.constraint(equalToConstant: AppLayout.buttonHeight)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: OnboardingCell.reuseIdentifier)
    }
    
    private func updateButtonTitle() {
        let isLastPage = currentPage == (viewModel.pages.count - 1)
        
        let title = isLastPage ? Localized.Onboarding.getStarted : Localized.Onboarding.next
        
        UIView.transition(with: nextButton, duration: 0.3, options: .transitionCrossDissolve) {
            self.nextButton.setTitle(title, for: .normal)
        }
    }
    
    // MARK: - Actions
    @objc private func nextButtonTapped() {
        if currentPage < viewModel.pages.count - 1 {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            viewModel.didTapNext()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCell.reuseIdentifier,for: indexPath) as? OnboardingCell else {
            return UICollectionViewCell()
        }
        
        let page = viewModel.pages[indexPath.item]
        cell.configure(with: page)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

// MARK: - UIScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        guard width > 0 else { return }
        
        let page = Int(round(scrollView.contentOffset.x / width))
        
        if currentPage != page {
            currentPage = page
            pageControl.currentPage = page
        }
    }
}
