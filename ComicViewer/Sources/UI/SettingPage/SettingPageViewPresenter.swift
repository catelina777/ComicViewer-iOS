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
    func showSelectComic()
    func validateName(name: String?) -> Bool
    func setUser(by name: String)
}

final class SettingPageViewPresenter: SettingPagePresenter {

    private weak var view: SettingPageView?
    private var user: User!

    init(view: SettingPageView) {
        self.view = view
    }
}

extension SettingPageViewPresenter {

    func showSelectComic() {
        view?.showSelectComic(with: self.user)
    }

    func validateName(name: String?) -> Bool {
        if name == nil || name == "" {
            return false
        }
        return true
    }

    func setUser(by name: String) {
        Realm.executeOnMainThread { [weak self] realm in
            guard let me = self else { return }
            me.user = realm.object(ofType: User.self,
                                     forPrimaryKey: name)
            if me.user == nil {
                me.user = User(name: name)
                realm.add(me.user)
                print("I created because -\(name)- does not exist")
            } else {
                print("I don't create because -\(name)- existed")
            }
        }
    }
}
