//
//  EditingController.swift
//  ourReminder02
//
//  Created by Yoshito Hasegawa on 2020/06/22.
//  Copyright © 2020 Yoshito Hasegawa. All rights reserved.
//

import UIKit

class EditingController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
     //ダブり防止のためのアラート
    var alertController02: UIAlertController!
    
    var toDoTextField: String?
    var deadLineField: String?
    var importanceField: String?
    var memoTaskViewString: String?
    
    
    var indexFromVC: IndexPath?
    let formatter = DateFormatter()
    
    @IBOutlet weak var TodoxtField02: UITextField!
        
    @IBOutlet weak var DeadLineTextField02: UITextField!
    
    @IBOutlet weak var ImportanceTextField02: UITextField!
    
    @IBOutlet weak var memoTaskView02: UITextView!
    
    
    var datePicker: UIDatePicker?
    var pickerView: UIPickerView?
    
    @IBOutlet weak var taskTextFieldIndicater02: UILabel!
    @IBOutlet weak var deadLine02: UILabel!
    
    @IBOutlet weak var importanceInputLabel02: UILabel!
    
    @IBOutlet weak var memoOfTasksLabel2: UILabel!
    
    @IBAction func TodoAddButton02(_ sender: Any) {
        let firstIndex02 = ContentsOfTodoList1.firstIndex(of: TodoxtField02.text!)
               let firstIndex202 = DeadLineOfTasks1.firstIndex(of: DeadLineTextField02.text!)
        
        if firstIndex02 != nil, firstIndex202 != nil{
            func alert(title:String, message:String) {
                                  alertController02 = UIAlertController(title: title,
                                                             message: message,
                                                             preferredStyle: .alert)
                                  alertController02.addAction(UIAlertAction(title: "OK",
                                                                 style: .default,
                                                                 handler: nil))
                                  present(alertController02, animated: true)
                              }
                       alert(title: "エラー",
                       message: "既に同じセルが存在します")
                       
                       
        }else{
        ContentsOfTodoList1[sortedNumber[indexFromVC!.row]] = (TodoxtField02.text!)
        DeadLineOfTasks1[sortedNumber[indexFromVC!.row]] = (DeadLineTextField02.text!)
        
        ImportanceOfTasks[sortedNumber[indexFromVC!.row]] = (ImportanceTextField02.text!)
        memoOfTasks[sortedNumber[indexFromVC!.row]] = (memoTaskView02.text!)
        
        
        let dateString = (DeadLineTextField02.text!)
        formatter.dateFormat = "yyyy'/'MM'/'dd(EEE) HH:mm"
        formatter.locale = Locale(identifier: "ja_JP")
        let date = formatter.date(from: dateString)
        
        
        
        
        //チェックボックスの状態を保持するために日付の足し算をしてdateForSortの値とチェックボックスの表示を揃える
        if manageCheckBox[sortedNumber[indexFromVC!.row]] == false {
            
        
        //Pinの状態を維持するために...
        if managePin[sortedNumber[indexFromVC!.row]] == false {
            
        if DeadLineTextField02.text! != "" {
            dateForSort[sortedNumber[indexFromVC!.row]] = (DeadLineTextField02.text!)
        }else{
            dateForSort[sortedNumber[indexFromVC!.row]] = ("1800/11/11(火) 11:11")
        }
            
        }else{
            if DeadLineTextField02.text! != "" {
            
                let modifiedDate = Calendar.current.date(byAdding: .day, value: -300000, to: date!)!
                dateForSort[sortedNumber[indexFromVC!.row]] = formatter.string(from: modifiedDate)
            }else{
                dateForSort[sortedNumber[indexFromVC!.row]] = ("979/06/23(月) 11:11")
                //print("dateが””の分岐に成功")
            }

        }
        /*if DeadLineTextField02.text! != "" {
            dateForSort[sortedNumber[indexFromVC!.row]] = (DeadLineTextField02.text!)
        }else{
            dateForSort[sortedNumber[indexFromVC!.row]] = ("1800/11/11(火) 11:11")
        }
         */
        }else{
            //Pinの状態を維持するために...
            if managePin[sortedNumber[indexFromVC!.row]] == false {
                
            if DeadLineTextField02.text! != "" {
                let modifiedDate = Calendar.current.date(byAdding: .day, value: 9000000, to: date!)!
                dateForSort[sortedNumber[indexFromVC!.row]] = formatter.string(from: modifiedDate)
            }else{
                dateForSort[sortedNumber[indexFromVC!.row]] = ("26442/01/09(木) 11:11")
            }
                
            }else{
                if DeadLineTextField02.text! != "" {
                
                    let modifiedDate = Calendar.current.date(byAdding: .day, value: 8700000, to: date!)!
                    dateForSort[sortedNumber[indexFromVC!.row]] = formatter.string(from: modifiedDate)
                }else{
                    dateForSort[sortedNumber[indexFromVC!.row]] = ("25620/08/26(水) 11:11")
                    //print("dateが””の分岐に成功")
                }

                
                
                
            }
            /*
            if DeadLineTextField02.text! != "" {
            let dateString = (DeadLineTextField02.text!)
            formatter.dateFormat = "yyyy'/'MM'/'dd(EEE) HH:mm"
            formatter.locale = Locale(identifier: "ja_JP")
            let date = formatter.date(from: dateString)
                let modifiedDate = Calendar.current.date(byAdding: .day, value: 9000000, to: date!)!
                dateForSort[sortedNumber[indexFromVC!.row]] = formatter.string(from: modifiedDate)
            }else{
                dateForSort[sortedNumber[indexFromVC!.row]] = ("26442/01/09(木) 11:11")
                print("dateが””の分岐に成功")
            }

            */
            
            
        }
        
        
        
        
        
        
        
        
        //変数の中身をUDに追加
        UserDefaults.standard.set( ContentsOfTodoList1, forKey: "TodoList1" )
        UserDefaults.standard.set( DeadLineOfTasks1, forKey: "DeadLineOfTasks2")
       // UserDefaults.standard.set( manageCheckBox, forKey: "manageCheckBoxKey")
        UserDefaults.standard.set(dateForSort, forKey: "dateForSortKey")
       UserDefaults.standard.set(ImportanceOfTasks, forKey: "importanceOfTasks1")
              UserDefaults.standard.set(memoOfTasks, forKey: "MemoOfTasks")
        
            
            let date102 = datePicker?.date
                            
                        
                            var differenceOfSeconds02:Int
                            
                            
                            let cal02 = Calendar(identifier: .gregorian)
                            let currentDate02 = Date()
                        
                            //秒数差
                            differenceOfSeconds02 = cal02.dateComponents([.second], from: currentDate02, to: date102!).second!
                            print(differenceOfSeconds02)
                            
                        
                                   // ローカル通知のの内容
                                   let content02 = UNMutableNotificationContent()
                                   content02.sound = UNNotificationSound.default
                                   content02.title = "タスクの締め切りが近づいています！"
                     content02.subtitle = "\(TodoxtField02.text!)の締め切りまであとn日です"
                                  // content.body = "まんじまんじ"
                                   
                                   // ローカル通知実行日時をセット（timeintevalは秒数で与えられることに注意)
                                   
                            
                            //ここでは秒数差で取ってるけど、重くなるようだったら、分数差を使うのもアリかも
                            let newDate02 = Date(timeInterval: TimeInterval(differenceOfSeconds02), since: currentDate02)
                            
                                   let component02 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: newDate02)
                                   
                                   // ローカル通知リクエストを作成
                                   let trigger02 = UNCalendarNotificationTrigger(dateMatching: component02, repeats: false)
                                   // ユニークなIDを作る
                                   let identifier02 = NSUUID().uuidString
                                   let request02 = UNNotificationRequest(identifier: identifier02, content: content02, trigger: trigger02)
                                   
                                   // ローカル通知リクエストを登録
                                   UNUserNotificationCenter.current().add(request02){ (error : Error?) in
                                       if let error = error {
                                           print(error.localizedDescription)
                            
                        }
                            }
                     
        }
    }
    let dataList = ["選択なし", "⭐︎", "⭐︎⭐︎", "⭐︎⭐︎⭐︎"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //メモ欄のデザイン
        memoTaskView02.layer.borderColor = UIColor.blue.cgColor
        memoTaskView02.layer.borderWidth = 2.0
        memoTaskView02.layer.cornerRadius = 10.0
        memoTaskView02.layer.masksToBounds = true
        
        DeadLineTextField02.delegate = self
        
        deadLine02.text = "締め切り"
        taskTextFieldIndicater02.text = "やること"
        importanceInputLabel02.text = "重要度"
        memoOfTasksLabel2.text = "メモ"
        
        TodoxtField02.text = toDoTextField
        DeadLineTextField02.text = deadLineField
        ImportanceTextField02.text = importanceField
        memoTaskView02.text = memoTaskViewString
        
   //ピッカー周りの設定
   datePicker = UIDatePicker()
        
        
    let dateString = (DeadLineOfTasks1[sortedNumber[indexFromVC!.row]])
    formatter.dateFormat = "yyyy'/'MM'/'dd(EEE) HH:mm"
    formatter.locale = Locale(identifier: "ja_JP")
    let date = formatter.date(from: dateString)
        
        
        if date != nil {
   datePicker?.date = date!
        }
        
   datePicker?.datePickerMode = .dateAndTime
   datePicker?.addTarget(self, action: #selector (addController.dateChanged(datePicker:)), for: .valueChanged)
   
   let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addController.viewTapped(gestureRecognizer:)))
   
   view.addGestureRecognizer(tapGesture)
   
   DeadLineTextField02.inputView = datePicker
        
        //重要度ピッカー周りの設定
             pickerView = UIPickerView()
             let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(addController.viewTapped(gestureRecognizer:)))
             view.addGestureRecognizer(tapGesture1)
        
        DeadLineTextField02.inputView = datePicker
                    // Delegate設定
             pickerView?.delegate = self
             pickerView?.dataSource = self
             
             ImportanceTextField02.inputView = pickerView
        
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
        DeadLineTextField02.text = dateFormatter.string(from: datePicker.date)
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
                 ImportanceTextField02.text = dataList[row]
             }
    
    //最初からあるコード
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
   
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
