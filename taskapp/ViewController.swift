//
//  ViewController.swift
//  taskapp
//
//  Created by 西島菜穂子 on 2019/03/07.
//  Copyright © 2019 nahoko.nishijima. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {//A
    
    @IBOutlet weak var tableView: UITableView!
    var categoryItems : [Task]? = []

    //Realmのインスタンスを取得する
    let realm = try! Realm()

    
    
    //ここから不明
    //検索フィールドとアウトレットで繋げた
    @IBOutlet weak var searchText: UISearchBar!

    //検索
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    let realm = try! Realm()
        var categoryItems :<Task>? = []
    if searchText.isEmpty {
        categoryItems = realm.objects(Task)
    } else {
    categoryItems = realm.objects(Task)
    .filter("name BEGINSWITH %@", searchText)
    }

    tableView.reloadData()
    }
    //ここまで不明



    //DB内のタスクが格納されるリスト
    //日付近い順でソート：降順
    //以降内容をアップデートするとリスト内は自動的に更新される
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false)
    
    
    override func viewDidLoad() {//B
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
    }//B
    
    
    
    //UITableViewDatasource
    //データの数(=セルの数)を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {//C
        return taskArray.count
    }//C
    
    
    //各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//D
        //再利用可能なcellを得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //Cellに値を設定する
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.title
        
        //日付
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: task.date) 
        cell.detailTextLabel?.text = dateString
        
        return cell
    }//D
    
    
    
    //UITableViewDelegate
    //各セルを選択したときに実行されるメソッド
    //タスク入力画面に遷移させる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {//E
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }//E
    
    
    
    //セルの削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {//F
        return .delete
    }//F
    
    
    
    //Deleteボタンが押されたときに呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {//●
        if editingStyle == .delete {//G
            //削除するタスクを取得する
            let task = self.taskArray[indexPath.row]
            
            //ローカル通知をキャンセルする
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])
            
            //データベースから削除する
            try! realm.write {//I
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }//I
            
            //未通知のローカル通知一覧をログし出力
            center.getPendingNotificationRequests{//H
                (requests: [UNNotificationRequest]) in
                for request in requests {//J
                    print("/--------------")
                    print (request)
                    print("---------------/")
                }//J
            }//H
        }//G
    }//●
    
    //segueで画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {//K
        let inputViewController:InputViewController = segue.destination as!  InputViewController
        
        if segue.identifier == "cellSegue" {//L
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        } else {//M
            let task = Task()
            task.date = Date()
            
            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0 {//N
                task.id = allTasks.max(ofProperty: "id")! + 1
            }//N
            
            inputViewController.task = task
        }//M
    }//K
    
    //入力画面から戻ってきたときにTableViewを更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}
