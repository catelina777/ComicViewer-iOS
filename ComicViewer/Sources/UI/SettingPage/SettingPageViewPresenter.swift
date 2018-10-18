//
//  SettingPageViewPresenter.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/17.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import Foundation
import RealmSwift

protocol SettingPagePresenter: class {
    init(view: SettingPageView)
    func showSelectComic(user: User)
    func validateName(name: String?) -> Bool
    func user(by name: String) -> User
    func user(at index: Int) -> User
    var numOfUsers: Int { get }
    func reloadData()
}

final class SettingPageViewPresenter: SettingPagePresenter {

    private weak var view: SettingPageView?
    lazy var users: Results<User> = {
        let realm = try! Realm()
        let objects = realm.objects(User.self)
        return objects
    }()

    var numOfUsers: Int {
        return users.count
    }

    init(view: SettingPageView) {
        self.view = view
    }
}

extension SettingPageViewPresenter {

    func showSelectComic(user: User) {
        view?.showSelectComic(with: user)
    }

    func validateName(name: String?) -> Bool {
        if name == nil || name == "" {
            return false
        }
        return true
    }

    func user(at index: Int) -> User {
        return users[index]
    }

    func reloadData() {
        view?.reloadData()
    }

    func user(by name: String) -> User {
        var _user: User!
        Realm.executeOnMainThread { realm in
            _user = realm.object(ofType: User.self,
                                 forPrimaryKey: name)
            if _user == nil {
                _user = User(name: name)
                realm.add(_user)
                print("I created because -\(name)- does not exist")
            } else {
                print("I don't create because -\(name)- existed")
            }
        }
        return _user
    }
}
