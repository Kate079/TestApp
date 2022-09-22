//
//  SecondViewController.swift
//  TestApp
//
//  Created by Kate on 19.09.2022.
//

import UIKit
import CoreData

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

    // MARK: - Private properties

    private var isNextScreenWasShown: Bool = false {
        didSet {
            configureMainButtonHandler(isNextScreenWasShown: isNextScreenWasShown)
        }
    }
    private let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private let pageViewContent: [PageViewModel] = [
        PageViewModel(imageName: "Img01", title: "Boost Productivity", subtitle: "Take your productivity to the next level"),
        PageViewModel(imageName: "Img02", title: "Work Seamlessly", subtitle: "Get your work done seamlessly without interruption"),
        PageViewModel(imageName: "Img03", title: "Achieve Your Goals", subtitle: "Boosted productivity will help you achieve the desired goals")]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        fetchContext()
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

    private func saveContext() {
        let configuration = Configuration(context: managedContext)
        configuration.isTimerWasShown = isNextScreenWasShown

        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("\(error), \(error.userInfo)")
            }
        }
    }

    private func fetchContext() {
        let fetchRequest: NSFetchRequest<Configuration> = Configuration.fetchRequest()
        do {
            let data = try managedContext.fetch(fetchRequest)
            if data.isEmpty {
                saveContext()
            } else {
                isNextScreenWasShown = data.last!.isTimerWasShown
            }

        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
        }
    }

    private func configurePageView() {
        pageView.configureView(with: pageViewContent)
    }

    private func configureMainButton(isLastPage: Bool) {
        if isLastPage {
            mainButton.setMainButtonTitle(TextConstants.continueTitle)
            configureMainButtonHandler(isNextScreenWasShown: isNextScreenWasShown)
        } else {
            mainButton.setMainButtonTitle(TextConstants.next)
            mainButton.buttonAction = { [weak self] in
                self?.pageView.showNextPage()
            }
        }
    }

    private func configureMainButtonHandler(isNextScreenWasShown: Bool) {
        if isNextScreenWasShown {
            mainButton.buttonAction = { [weak self] in
                guard let self = self else { return }
                let alert = self.createAlert(title: TextConstants.alertTitle, message: TextConstants.alertMessage, buttonTitle: TextConstants.ok, buttonHandler: nil)
                self.present(alert, animated: true)
            }
        } else {
            mainButton.buttonAction = { [weak self] in
                let thirdViewController = ThirdViewController()
                thirdViewController.isScreenWasShown = { [weak self] in
                    self?.isNextScreenWasShown = true
                    self?.saveContext()
                }
                thirdViewController.modalPresentationStyle = .overCurrentContext
                thirdViewController.modalTransitionStyle = .crossDissolve
                self?.present(thirdViewController, animated: true)
            }
        }
    }
}

// MARK: - Layout constants

extension SecondViewController {
    private enum Constants {
        static let edgeInset: CGFloat = 16
        static let buttonHeight: CGFloat = 48
    }
}
