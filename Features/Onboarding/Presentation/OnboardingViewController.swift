//
//  OnboardingViewController.swift
//  kuryem
//
//  Created by FFK on 23.04.2026.
//

import UIKit
 
final class OnboardingViewController: UIViewController {
 
    // MARK: - Dependencies
    private let viewModel: OnboardingViewModel
 
    // MARK: - State
    private var currentPage: Int = 0
 
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
 
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(OnboardingCell.self, forCellWithReuseIdentifier: OnboardingCell.reuseIdentifier)
        return cv
    }()
 
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = AppColor.primary
        pc.pageIndicatorTintColor = AppColor.border
        pc.isUserInteractionEnabled = false
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
 
    private lazy var nextButton: PrimaryButton = {
        let button = PrimaryButton(title: Localized.Onboarding.next)
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
 
    // MARK: - Init
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
    }
 
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = AppColor.background
        setupHierarchy()
        setupConstraints()
    }
 
    private func setupHierarchy() {
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
            collectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -AppLayout.Spacing.large),
 
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -AppLayout.Spacing.xLarge),
 
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -AppLayout.Spacing.xLarge),
        ])
    }
 
    private func setupCollectionView() {
        collectionView.delegate   = self
        collectionView.dataSource = self
    }
 
    // MARK: - Page Management
    private func updatePage(to page: Int) {
        guard page != currentPage else { return }
        currentPage = page
        pageControl.currentPage = currentPage
        updateButtonTitle()
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
            let next = currentPage + 1
            let indexPath = IndexPath(item: next, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            updatePage(to: next)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCell.reuseIdentifier, for: indexPath) as? OnboardingCell else { return UICollectionViewCell() }
        cell.configure(with: viewModel.pages[indexPath.item])
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
        guard scrollView.isDragging || scrollView.isDecelerating else { return }
        let width = scrollView.frame.width
        guard width > 0 else { return }
        let page = Int(round(scrollView.contentOffset.x / width))
        updatePage(to: page)
    }
}
