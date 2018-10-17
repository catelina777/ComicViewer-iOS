//
//  SettingPageViewDatasource.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/10/17.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

final class SettingPageViewDatasource: NSObject {

    let presenter: SettingPagePresenter

    init(presenter: SettingPagePresenter) {
        self.presenter = presenter
    }
}

extension SettingPageViewDatasource {

    func prepare(with tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SettingPageViewDatasource: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let user = presenter.user(at: indexPath.row)
        presenter.showSelectComic(user: user)
    }
}

extension SettingPageViewDatasource: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return presenter.numOfUsers
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = presenter.user(at: indexPath.row).name
        return cell
    }
}
