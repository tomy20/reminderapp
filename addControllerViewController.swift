//
//  addControllerViewController.swift
//  ourReminder02
//
//  Created by Yoshito Hasegawa on 2020/06/22.
//  Copyright © 2020 Yoshito Hasegawa. All rights reserved.
//

import UIKit
var ContentsOfTodoList1 = [String]()
var DeadLineOfTasks1 = [String]()
var ImportanceOfTasks = [String]()
var memoOfTasks = [String]()


class addController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {
    
     //ダブり防止のためのアラート
    var alertController: UIAlertController!
    

    @IBOutlet weak var TodoxtField: UITextField!
    
    @IBOutlet weak var DeadLineTextField: UITextField!
    
    @IBOutlet weak var ImportanceTextField: UITextField!
    
    @IBOutlet weak var memoTaskView: UITextView!
    
    var datePicker: UIDatePicker?
    var pickerView: UIPickerView?
    
    @IBOutlet weak var taskTextFieldIndicater: UILabel!
    @IBOutlet weak var deadLine: UILabel!
    @IBOutlet weak var importanceInputLabel: UILabel!
    @IBOutlet weak var memoOfTasksLabel: UILabel!
    
    @IBAction func TodoAddButton(_ sender: Any) {
        let firstIndex = ContentsOfTodoList1.firstIndex(of: TodoxtField.text!)
          let firstIndex2 = DeadLineOfTasks1.firstIndex(of: DeadLineTextField.text!)
        
        if firstIndex != nil, firstIndex2 != nil{
            func alert(title:String, message:String) {
                                  alertController = UIAlertController(title: title,
                                                             message: message,
                                                             preferredStyle: .alert)
                                  alertController.addAction(UIAlertAction(title: "OK",
                                                                 style: .default,
                                                                 handler: nil))
                                  present(alertController, animated: true)
                              }
                       alert(title: "エラー",
                       message: "既に同じセルが存在します")
                       
        }else{
        ContentsOfTodoList1.append(TodoxtField.text!)
        DeadLineOfTasks1.append(DeadLineTextField.text!)
        manageCheckBox.append(false)
        
        managePin.append(false)
        
        ImportanceOfTasks.append(ImportanceTextField.text!)
              memoOfTasks.append(memoTaskView.text!)
        
        if DeadLineTextField.text! != "" {
        dateForSort.append(DeadLineTextField.text!)
        }else{
            dateForSort.append("1800/11/11(火) 11:11")
        }
        
        //追加ボタンを押したらフィールドを空にする
        //TodoxtField.text = ""
        //変数の中身をUDに追加
        UserDefaults.standard.set( ContentsOfTodoList1, forKey: "TodoList1" )
        UserDefaults.standard.set( DeadLineOfTasks1, forKey: "DeadLineOfTasks2")
        UserDefaults.standard.set( manageCheckBox, forKey: "manageCheckBoxKey")
        UserDefaults.standard.set(dateForSort, forKey: "dateForSortKey")
        UserDefaults.standard.set(ImportanceOfTasks, forKey: "importanceOfTasks1")
               UserDefaults.standard.set(memoOfTasks, forKey: "MemoOfTasks")
        UserDefaults.standard.set(managePin, forKey: "managePinKey")
            
            
            let date1 = datePicker?.date
                            
                        
                            var differenceOfSeconds:Int
                            
                            
                            let cal = Calendar(identifier: .gregorian)
                            let currentDate = Date()
                        
                            //秒数差
                            differenceOfSeconds = cal.dateComponents([.second], from: currentDate, to: date1!).second!
                            print(differenceOfSeconds)
                            
                        
                                   // ローカル通知のの内容
                                   let content = UNMutableNotificationContent()
                                   content.sound = UNNotificationSound.default
                                   content.title = "タスクの締め切りが近づいています！"
                     content.subtitle = "\(TodoxtField.text!)の締め切りまであとn日です"
                                  // content.body = "まんじまんじ"
                                   
                                   // ローカル通知実行日時をセット（timeintevalは秒数で与えられることに注意)
                                   
                            
                            //ここでは秒数差で取ってるけど、重くなるようだったら、分数差を使うのもアリかも
                            let newDate = Date(timeInterval: TimeInterval(differenceOfSeconds), since: currentDate)
                            
                                   let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: newDate)
                                   
                                   // ローカル通知リクエストを作成
                                   let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
                                   // ユニークなIDを作る
                                   let identifier = NSUUID().uuidString
                                   let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                                   
                                   // ローカル通知リクエストを登録
                                   UNUserNotificationCenter.current().add(request){ (error : Error?) in
                                       if let error = error {
                                           print(error.localizedDescription)
                            
                        }
                            }
        }
    }
    //重要度ピッカーの中身
       let dataList = ["選択なし", "⭐︎", "⭐︎⭐︎", "⭐︎⭐︎⭐︎"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DeadLineTextField.delegate = self
        
        deadLine.text = "締め切り"
        taskTextFieldIndicater.text = "やること"
        importanceInputLabel.text = "重要度"
               memoOfTasksLabel.text = "メモ"
        //メモ欄のデザイン
              memoTaskView.layer.borderColor = UIColor.blue.cgColor
              memoTaskView.layer.borderWidth = 2.0
              memoTaskView.layer.cornerRadius = 10.0
              memoTaskView.layer.masksToBounds = true
       //ピッカー周りの設定
   datePicker = UIDatePicker()
        datePicker?.timeZone = NSTimeZone.local
        datePicker?.locale = Locale.current
   datePicker?.datePickerMode = .dateAndTime
   datePicker?.addTarget(self, action: #selector (addController.dateChanged(datePicker:)), for: .valueChanged)
   //未来に向けてしかピッカーを回せないように
   datePicker?.minimumDate = Date()
        
   let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addController.viewTapped(gestureRecognizer:)))
   
   view.addGestureRecognizer(tapGesture)
   
   DeadLineTextField.inputView = datePicker
        //重要度ピッカー周りの設定
                     pickerView = UIPickerView()
                     let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(addController.viewTapped(gestureRecognizer:)))
                     view.addGestureRecognizer(tapGesture1)
                
                DeadLineTextField.inputView = datePicker
              //DeadLineTextField.inputAccessoryView = toolbar
                            // Delegate設定
                     pickerView?.delegate = self
                     pickerView?.dataSource = self
                     
                     ImportanceTextField.inputView = pickerView
    }
    
    //改行、またはreturnキーが押されたら呼び出されるメソッド
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           //キーボードをしまう
           self.view.endEditing(true)
           return false
       }
    
    

    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
           view.endEditing(true)
       }
    
    
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy'/'MM'/'dd(EEE) HH:mm"
        
        DeadLineTextField.text = dateFormatter.string(from: datePicker.date)
    }
    // UIPickerViewの列の数
               func numberOfComponents(in pickerView: UIPickerView) -> Int {
                   return 1
               }
               
               // UIPickerViewの行数、リストの数
               func pickerView(_ pickerView: UIPickerView,
                               numberOfRowsInComponent component: Int) -> Int {
                   return dataList.count
               }
               
               // UIPickerViewの最初の表示
               func pickerView(_ pickerView: UIPickerView,
                               titleForRow row: Int,
                               forComponent component: Int) -> String? {
                   
                   return dataList[row]
               }
               // UIPickerViewのRowが選択された時の挙動
                     func pickerView(_ pickerView: UIPickerView,
                                     didSelectRow row: Int,
                                     inComponent component: Int) {
                         ImportanceTextField.text = dataList[row]
                     }
      
    //入力内容を破棄して画面を閉じる
    
    @IBAction func cancelButton(_ sender: Any) {
    
        dismiss(animated: true, completion: nil)
        
    }
    //最初からあるコード
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
}
