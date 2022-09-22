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

    var isScreenWasShown: (() -> Void)?

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
            self?.isScreenWasShown?()
            self?.dismiss(animated: true)
        }
    }
}
