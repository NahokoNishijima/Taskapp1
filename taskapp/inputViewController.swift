//
//  inputViewController.swift
//  taskapp
//
//  Created by 西島菜穂子 on 2019/03/08.
//  Copyright © 2019 nahoko.nishijima. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!//追加
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let realm = try! Realm()
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景をタップしたらdismissKeyboardnメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        categoryTextField.text = task.category //追加
        contentsTextView.text = task.contents
        datePicker.date = task.date
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.category = self.categoryTextField.text!//追加
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.realm.add(self.task, update: true)
        }
        
        setNotification(task: task)
        
        super.viewWillDisappear(animated)
    }
    
    
    @objc func dismissKeyboard() {
        //キーボードを閉じる
        view.endEditing(true)
    }
    
    //タスクのローカル通知を登録する
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        //タイトルと内容を設定
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if task.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default
        
        //ローカル通帳が発動するtriggerを作成
        let calender = Calendar.current
        let dateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        //ローカル通知を作成
        let request = UNNotificationRequest.init(identifier: String(task.id), content: content, trigger: trigger)
        
        //ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request){//C
            (error) in
            print(error ?? "ローカル通知登録　OK")
        }//C
        
        //未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests{//B
            (requests: [UNNotificationRequest]) in
            for request in requests {//A
                print("/---------------")
                print(request)
                print("/---------------/")
            }//A
        }//B
    }//?
    
}

