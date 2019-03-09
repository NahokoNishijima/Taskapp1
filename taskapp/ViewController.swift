//
//  ViewController.swift
//  taskapp
//
//  Created by 西島菜穂子 on 2019/03/07.
//  Copyright © 2019 nahoko.nishijima. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
    }
    //UITableViewDatasource
    //データの数(=セルの数)を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    //各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //再利用可能なcellを得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell
    }
    
    //UITableViewDelegate
    //各セルを選択したときに実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
    //セルの削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
}

