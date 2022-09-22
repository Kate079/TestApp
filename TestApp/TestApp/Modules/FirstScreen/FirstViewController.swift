//
//  FirstViewController.swift
//  TestApp
//
//  Created by Kate on 19.09.2022.
//

import UIKit

final class FirstViewController: UIViewController {
    // MARK: - Subviews

    private lazy var mainButton: MainButton = {
        let button = MainButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setMainButtonTitle(TextConstants.start)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureMainButton()
    }

    // MARK: - Private methods

    private func configureUI() {
        view.backgroundColor = .customGray
        view.addSubview(mainButton)

        NSLayoutConstraint.activate([
            mainButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            mainButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            mainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func configureMainButton() {
        mainButton.buttonAction = { [weak self] in
            let secondViewController = SecondViewController()
            secondViewController.modalPresentationStyle = .fullScreen
            self?.present(secondViewController, animated: true)
        }
    }
}

// MARK: - Layout constants

extension FirstViewController {
    private enum Constants {
        static let buttonHeight: CGFloat = 48
    }
}
