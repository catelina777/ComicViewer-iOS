//
//  SettingPageViewController.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/17.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit
import RealmSwift

protocol SettingPageView: class {
    func showSelectComic(with user: User)
}

final class SettingPageViewController: UIViewController, SettingPageView {

    @IBOutlet weak var nameTextField: UITextField!

    lazy var presenter: SettingPagePresenter = SettingPageViewPresenter(view: self)

    @IBOutlet weak var registerButton: UIButton! {
        didSet {
            registerButton.layer.cornerRadius = 8
            registerButton.layer.shadowOffset = CGSize(width: 5, height: 5)
            registerButton.layer.shadowRadius = 10
            registerButton.layer.shadowOpacity = 0.4
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
    }

    @IBAction func didPressRegisterButton(_ sender: Any) {
        if presenter.validateName(name: nameTextField.text) {
            presenter.setUser(by: nameTextField.text!)
            presenter.showSelectComic()
            print("validated")
        } else {
            print("empty")
        }
    }
}

extension SettingPageViewController {

    func showSelectComic(with user: User) {
        let vc = R.storyboard.selectComic.instantiateInitialViewController()!
        vc.set(user: user)
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }

    func prepareNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Settings"
    }
}
