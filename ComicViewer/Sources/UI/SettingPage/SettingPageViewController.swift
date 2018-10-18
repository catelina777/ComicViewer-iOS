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
    func reloadData()
}

final class SettingPageViewController: UIViewController, SettingPageView {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    lazy var presenter: SettingPagePresenter = SettingPageViewPresenter(view: self)
    lazy var dataSource: SettingPageViewDatasource = SettingPageViewDatasource(presenter: self.presenter)

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
        dataSource.prepare(with: tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }

    @IBAction func didPressRegisterButton(_ sender: Any) {
        if presenter.validateName(name: nameTextField.text) {
            let user = presenter.user(by: nameTextField.text!)
            presenter.showSelectComic(user: user)
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
        nameTextField.endEditing(true)
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }

    func reloadData() {
        tableView.reloadData()
    }

    func prepareNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Settings"
    }
}
