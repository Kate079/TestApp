//
//  ModalView.swift
//  TestApp
//
//  Created by Kate on 19.09.2022.
//

import UIKit

final class ModalView: UIView {
    // MARK: - Subviews

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .customGray
        view.layer.cornerRadius = Constants.cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var mainButton: MainButton = {
        let button = MainButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setMainButtonTitle(TextConstants.continueTitle)
        button.isEnable = false
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 64, weight: .semibold)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .coral
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()

    // MARK: - Public properties

    var timerExpiredCompletion: (() -> Void)?

    // MARK: - Private properties

    private(set) var scheduledTimeInSeconds = 0 {
        didSet {
            startTimer(seconds: scheduledTimeInSeconds)
        }
    }
    private var currentTime = 0

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
        setInitialValue()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private methods

    private func configureUI() {
        backgroundColor = .black.withAlphaComponent(0.75)

        addSubview(containerView)
        containerView.addSubview(mainButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(progressView)

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            progressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.edgeInset),
            progressView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.edgeInset),
            progressView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -(Constants.edgeInset)),
            progressView.heightAnchor.constraint(equalToConstant: Constants.progressViewHeight),

            mainButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.edgeInset),
            mainButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -(Constants.edgeInset)),
            mainButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -(Constants.edgeInset)),
            mainButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }

    private func setInitialValue() {
        titleLabel.text = makeTimeString(min: 0, sec: 0)
    }

    private func startTimer(seconds: Int) {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }

            if self.currentTime == seconds {
                timer.invalidate()
                self.timerExpiredCompletion?()
            } else {
                self.currentTime += 1
                let time = self.secondsToMinutesSeconds(self.currentTime)
                let timeString = self.makeTimeString(min: time.0, sec: time.1)

                self.titleLabel.text = timeString
                self.progressView.setProgress(Float(self.currentTime) / Float(self.scheduledTimeInSeconds), animated: true)
            }
        }
    }

    private func secondsToMinutesSeconds(_ seconds: Int) -> (Int, Int) {
        let min = seconds / 60
        let sec = seconds % 60
        return (min, sec)
    }

    private func makeTimeString(min: Int, sec: Int) -> String {
        return String(format: "%02d:%02d", min, sec)
    }

    // MARK: - Public methods

    func configureTimer(for scheduledTimeInSeconds: Int) {
        self.scheduledTimeInSeconds = scheduledTimeInSeconds
    }

    func updateButton(isEnable: Bool, buttonAction: @escaping (() -> Void)) {
        mainButton.isEnable = isEnable
        mainButton.buttonAction = buttonAction
    }
}

// MARK: - Layout constants

extension ModalView {
    private enum Constants {
        static let cornerRadius: CGFloat = 24
        static let edgeInset: CGFloat = 32
        static let buttonHeight: CGFloat = 48
        static let progressViewHeight: CGFloat = 8
    }
}
