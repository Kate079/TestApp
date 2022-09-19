//
//  MainButton.swift
//  TestApp
//
//  Created by Kate on 19.09.2022.
//

import Foundation
import UIKit

final class MainButton: UIView {
    // MARK: - Subviews

    private lazy var mainButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = Constants.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Public properties

    var isEnable: Bool {
        get {
            mainButton.isEnabled
        }
        set {
            mainButton.isEnabled = newValue
            if mainButton.isEnabled {
                setupMainButtonStyle()
            } else {
                setupMainButtonStyle(backgroundColor: .darkCoral, titleColor: .gray)
            }
        }
    }

    var buttonAction: (() -> Void) = {}

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupMainButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private methods

    private func setupMainButton() {
        addSubview(mainButton)

        NSLayoutConstraint.activate([
            mainButton.topAnchor.constraint(equalTo: topAnchor),
            mainButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        setupMainButtonAction()
        setupMainButtonStyle()
    }

    private func setupMainButtonAction() {
        mainButton.addTarget(self, action: #selector(buttonDidPressed), for: .touchUpInside)
    }

    @objc private func buttonDidPressed() {
        buttonAction()
    }

    // MARK: - Public methods

    func setupMainButtonStyle(backgroundColor: UIColor? = .coral, titleColor: UIColor? = .white) {
        mainButton.backgroundColor = backgroundColor
        mainButton.setTitleColor(titleColor, for: .normal)
    }

    func setMainButtonTitle(_ title: String) {
        mainButton.setTitle(title, for: .normal)
    }
}

// MARK: - Layout constants

extension MainButton {
    private enum Constants {
        static let cornerRadius: CGFloat = 8
    }
}
