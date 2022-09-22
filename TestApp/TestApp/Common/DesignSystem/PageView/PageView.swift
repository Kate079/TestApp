//
//  PageView.swift
//  TestApp
//
//  Created by Kate on 19.09.2022.
//

import UIKit

final class PageView: UIView {
    // MARK: - Subviews

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = false
        collectionView.isPagingEnabled = true
        collectionView.register(
            HorizontalCollectionViewCell.self,
            forCellWithReuseIdentifier: HorizontalCollectionViewCell.reuseIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    // MARK: - Public properties

    var isLastPageSelectedCompletion: ((Bool) -> Void)?

    // MARK: - Private properties

    private var configurationData: [PageViewModel]?
    private(set) var currentPage = 0 {
        didSet {
            guard let configurationData = configurationData else { return }
            pageControl.currentPage = currentPage
            if currentPage == configurationData.count - 1 {
                isLastPageSelectedCompletion?(true)
            } else {
                isLastPageSelectedCompletion?(false)
            }
        }
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private methods

    private func configureUI() {
        backgroundColor = .customGray
        addSubview(collectionView)
        addSubview(pageControl)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.edgeInset),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.edgeInset),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(Constants.edgeInset)),
            collectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -(Constants.edgeInset)),

            pageControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.edgeInset),
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(Constants.edgeInset)),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(Constants.edgeInset)),
            pageControl.heightAnchor.constraint(equalToConstant: Constants.pageControlHeight)
        ])
    }

    // MARK: - Public methods

    func configureView(with data: [PageViewModel]) {
        configurationData = data
        pageControl.numberOfPages = data.count
    }

    func showNextPage() {
        currentPage += 1
        let indexPath = IndexPath(item: currentPage, section: 0)
        
        collectionView.isPagingEnabled = false
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionView.isPagingEnabled = true
    }
}

// MARK: - UICollectionViewDataSource

extension PageView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return configurationData?.count ?? 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HorizontalCollectionViewCell.reuseIdentifier,
            for: indexPath) as? HorizontalCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        if let configurationData = configurationData {
            cell.configure(configurationData[indexPath.item])
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension PageView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}

// MARK: - Layout constants

extension PageView {
    private enum Constants {
        static let edgeInset: CGFloat = 16
        static let pageControlHeight: CGFloat = 24
    }
}
