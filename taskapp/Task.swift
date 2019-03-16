//
//  Task.swift
//  taskapp
//
//  Created by 西島菜穂子 on 2019/03/09.
//  Copyright © 2019 nahoko.nishijima. All rights reserved.
//

import RealmSwift

class Task: Object {
    //管理用　ID, プライマリーキー
    @objc dynamic var id = 0
    
    //タイトル
    @objc dynamic var title = ""
    
    //内容
    @objc dynamic var contents = ""
    
    //日時
    @objc dynamic var date = Date()
    
    //カテゴリー
    @objc dynamic var category = ""//追加
    
    //idをプライマリーキープとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
