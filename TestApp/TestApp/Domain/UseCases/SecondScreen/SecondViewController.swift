//
//  SecondViewController.swift
//  TestApp
//
//  Created by Kate on 19.09.2022.
//

import UIKit

final class SecondViewController: UIViewController {
    // MARK: - Subviews

    private lazy var mainButton: MainButton = {
        let button = MainButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var pageView: PageView = {
        let pageView = PageView()
        pageView.translatesAutoresizingMaskIntoConstraints = false
        pageView.isLastPageSelectedCompletion = { [weak self] isLastPage in
            self?.configureMainButton(isLastPage: isLastPage)
        }
        return pageView
    }()

    // MARK: - Public properties

    // MARK: - Private properties

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configurePageView()
        configureMainButton(isLastPage: false)
    }

    // MARK: - Private methods

    private func configureUI() {
        view.backgroundColor = .customGray
        view.addSubview(mainButton)
        view.addSubview(pageView)

        NSLayoutConstraint.activate([
            mainButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.edgeInset),
            mainButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(Constants.edgeInset)),
            mainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(Constants.edgeInset)),
            mainButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),

            pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.edgeInset),
            pageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(Constants.edgeInset)),
            pageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.edgeInset),
            pageView.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -(Constants.edgeInset))
        ])
    }

    private func configurePageView() {
        pageView.configureView(with: [
            HorizontalCollectionViewCell.Configuration(
                imageName: "Img01",
                title: "Boost Productivity",
                subtitle: "Take your productivity to the next level"),
            HorizontalCollectionViewCell.Configuration(
                imageName: "Img02",
                title: "Work Seamlessly",
                subtitle: "Get your work done seamlessly without interruption"),
            HorizontalCollectionViewCell.Configuration(
                imageName: "Img03",
                title: "Achieve Your Goals",
                subtitle: "Boosted productivity will help you achieve the desired goals")])
    }

    private func configureMainButton(isLastPage: Bool) {
        if isLastPage {
            mainButton.setMainButtonTitle("Continue")
            mainButton.buttonAction = { [weak self] in
                let thirdViewController = ThirdViewController()
                thirdViewController.modalPresentationStyle = .overCurrentContext
                thirdViewController.modalTransitionStyle = .crossDissolve
                self?.present(thirdViewController, animated: true)
            }
        } else {
            mainButton.setMainButtonTitle("Next")
            mainButton.buttonAction = { [weak self] in
                self?.pageView.showNextPage()
            }
        }
    }

    // MARK: - Public methods
}

// MARK: - Layout constants

extension SecondViewController {
    private enum Constants {
        static let edgeInset: CGFloat = 16
        static let buttonHeight: CGFloat = 48
    }
}
