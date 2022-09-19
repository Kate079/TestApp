//
//  ThirdViewController.swift
//  TestApp
//
//  Created by Kate on 19.09.2022.
//

import UIKit

final class ThirdViewController: UIViewController {
    // MARK: - Subviews

    private lazy var modalView: ModalView = {
        let modalView = ModalView()
        modalView.translatesAutoresizingMaskIntoConstraints = false
        modalView.timerExpiredCompletion = { [weak self] in
            self?.configureModalViewButton()
        }
        return modalView
    }()

    // MARK: - Public properties

    // MARK: - Private properties

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        startTimer()
    }

    // MARK: - Private methods

    private func configureUI() {
        view.addSubview(modalView)

        NSLayoutConstraint.activate([
            modalView.topAnchor.constraint(equalTo: view.topAnchor),
            modalView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modalView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            modalView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func startTimer() {
        modalView.configureTimer(for: 60)
    }

    private func configureModalViewButton() {
        modalView.updateButton(isEnable: true) { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    // MARK: - Public methods
}

// MARK: - Layout constants

extension ThirdViewController {
    private enum Constants {
    }
}
