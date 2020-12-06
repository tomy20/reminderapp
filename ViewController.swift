//
//  ViewController.swift
//  ourReminder02
//
//  Created by Yoshito Hasegawa on 2020/06/22.
//  Copyright © 2020 Yoshito Hasegawa. All rights reserved.
//


import UIKit
import Foundation

var sortedNumber = [Int]()
var dateForSort = [String]()
var manageCheckBox = [Bool]()
var manageImage: Bool!      //画像の表示ラグを解消、display()のタイミングの管理
var manageDefaultImg : Int!//初期背景の管理
var tempImage02: UIImage! //グローバル変数じゃないとnilが出る　tempImage02は背景画像周りのプログラムの主役

var tempImage03: UIImage!

var managePin = [Bool]() //ピン留めのon/offを管理する配列

//確認用
var sortedNumber02 = [Int]()



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.image = UIImage(named: "logo") // image名前 要確認
        return imageView
    } ()

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var addCellButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var tempImage : UIImage! {
        didSet {
            save()
            
            tempImage02 = tempImage //backgroundImageView.imageがロードされたないためnilになるので、直接backgroundImageView.imageに入れるのではなくグローバル変数に代入しておいて、mainVCに戻ってきてbackgroundImageViewがロードされてから代入する→tempImage02はグローバル変数でないとnilになるのも同様
            
            
            //self.backgroundImageView.image = tempImage
            //
            
            if manageImage != true {
            manageImage = true
            }else{
                print("2回目以降")
            }
            if manageDefaultImg != 0 {
                manageDefaultImg = 0
                
            }
            UserDefaults.standard.set( manageDefaultImg, forKey: "manageDefaultImgKey" )
            
        }
    }
    
       enum StorageType {
           case userDefaults
           case fileSystem
       }
       
       private func store(image: UIImage,
                           forKey key: String,
                           withStorageType storageType: StorageType) {
           if let pngRepresentation = image.pngData() {
               switch storageType {
               case .fileSystem:
                   if let filePath = filePath(forKey: key) {
                       do  {
                           try pngRepresentation.write(to: filePath,
                                                       options: .atomic)
                       } catch let err {
                           print("Saving file resulted in error: ", err)
                       }
                   }
               case .userDefaults:
                   UserDefaults.standard.set(pngRepresentation,
                                               forKey: key)
               }
           }
       }
       
       private func retrieveImage(forKey key: String,
                                   inStorageType storageType: StorageType) -> UIImage? {
           switch storageType {
           case .fileSystem:
               if let filePath = self.filePath(forKey: key),
                   let fileData = FileManager.default.contents(atPath: filePath.path),
                let image = UIImage(data: fileData) {
                   return image
               }
           case .userDefaults:
               if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
                   let image = UIImage(data: imageData) {
                   return image
               }
           }
           
           return nil
       }
    
     private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".png")
       }
       
       @objc
       func save() {
        if let buildingImage = tempImage {
               DispatchQueue.global(qos: .background).async {
                   self.store(image: buildingImage,
                               forKey: "buildingImage",
                               withStorageType: .fileSystem)
               }
            
           }
        
       }
    
       @objc
       func display() {

        
           DispatchQueue.global(qos: .background).async {
               if let savedImage = self.retrieveImage(forKey: "buildingImage",inStorageType: .fileSystem) {
                   DispatchQueue.main.async {
                    self.backgroundImageView.image = savedImage
                    tempImage02 = savedImage
                   }
               }
           }
       }
    
    @objc
    func setBackGroundImage() {

     
        DispatchQueue.global(qos: .background).async {
            if let savedImage = self.retrieveImage(forKey: "buildingImage",inStorageType: .fileSystem) {
                DispatchQueue.main.async {
                    tempImage03 = savedImage
                }
            }
        }
    }
       
       
    
    
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            
            return 70
            
        }else{
            
           return 100
       }
    }
    
    //セルの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return ContentsOfTodoList1.count
       }
    
       let formatter1 = DateFormatter()
    
    //セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "invisibleCell", for: indexPath)as! ReminderCellSettings
            cell.selectionStyle = .none
            
            return cell
            
            
        } else {
        
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderCellSettings
         let task = ContentsOfTodoList1[sortedNumber[indexPath.row]]
         let deadline = DeadLineOfTasks1[sortedNumber[indexPath.row]]
         let importance = ImportanceOfTasks[sortedNumber[indexPath.row]]
         //日付関連
         let dateString1 = DeadLineOfTasks1[sortedNumber[indexPath.row]]
         print(dateString1)
            
         //ここまではOK
         formatter1.dateFormat = "yyyy'/'MM'/'dd(EEE) HH:mm"
         formatter1.locale = Locale(identifier: "ja_JP")
             //formatter1.locale = Locale(identifier: "en_US_POSIX")
         let date1 = formatter1.date(from: dateString1)
         
         print(date1 as Any)
         
     
         
         let currentDate = Date()
         
         var differenceOfDates: Int
         var differenceOfHours: Int
            
              let cal = Calendar(identifier: .gregorian)
            
         if date1 == nil {
             differenceOfDates = 0
            differenceOfHours = 0
             print("date = nil")
         } else {
             differenceOfDates = Calendar.current.dateComponents([.day], from: currentDate, to: date1!).day!
             print(differenceOfDates)
            differenceOfHours = cal.dateComponents([.hour], from: currentDate, to: date1!).hour!
                       //differenceOfHours = Calendar.current.dateComponents([.day], from: currentDate, to: date1!).hour!
                       print(differenceOfHours)
         }
         
   if importance == "" {
                       cell.taskView.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.9)
                       if manageCheckBox[sortedNumber[indexPath.row]] == true {
                           cell.checkBoxImageView.image = UIImage(named: "角形checkBox Done 04")
                           cell.taskView.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.6)
                       } else {
                           cell.checkBoxImageView.image = UIImage(named: "角形checkBox unDone 03")
                           cell.taskView.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.9)
                       }
                   } else if importance == "選択なし" {
                       cell.taskView.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.9)
                       if manageCheckBox[sortedNumber[indexPath.row]] == true {
                           cell.checkBoxImageView.image = UIImage(named: "角形checkBox Done 04")
                           cell.taskView.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.6)
                       } else {
                           cell.checkBoxImageView.image = UIImage(named: "角形checkBox unDone 03")
                           cell.taskView.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.9)
                       }
                   } else if importance == "⭐︎" {
                       cell.taskView.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.5, blue: 0.0, alpha: 0.9)
                       if manageCheckBox[sortedNumber[indexPath.row]] == true {
                           cell.checkBoxImageView.image = UIImage(named: "角形checkBox Done 04")
                           cell.taskView.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.5, blue: 0.0, alpha: 0.6)
                       } else {
                           cell.checkBoxImageView.image = UIImage(named: "角形checkBox unDone 03")
                           cell.taskView.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.5, blue: 0.0, alpha: 0.9)
                       }
                   } else if importance == "⭐︎⭐︎" {
                       cell.taskView.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.0, alpha: 0.9)
                       if manageCheckBox[sortedNumber[indexPath.row]] == true {
                           cell.checkBoxImageView.image = UIImage(named: "角形checkBox Done 04")
                           cell.taskView.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.0, alpha: 0.6)
                       } else {
                           cell.checkBoxImageView.image = UIImage(named: "角形checkBox unDone 03")
                           cell.taskView.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.0, alpha: 0.9)
                       }
                   } else {
                       cell.taskView.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.0, blue: 0.0, alpha: 0.9)
                       if manageCheckBox[sortedNumber[indexPath.row]] == true {
                           cell.checkBoxImageView.image = UIImage(named: "角形checkBox Done 04")
                           cell.taskView.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.0, blue: 0.0, alpha: 0.6)
                       } else {
                           cell.checkBoxImageView.image = UIImage(named: "角形checkBox unDone 03")
                           cell.taskView.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.0, blue: 0.0, alpha: 0.9)
                       }
                   }
            
           
           cell.taskNameLabel.text = task
           cell.deadLineLabel.text = deadline
             if differenceOfDates > 1 {
                cell.countDownForDeadLineLabel.text = "あと\(differenceOfDates + 1)日"
                } else {
                  cell.countDownForDeadLineLabel.text = "あと\(differenceOfHours)時間"
                }
                
           cell.taskView.layer.cornerRadius = 20
            
            
          //ピン留めの証
            if managePin[sortedNumber[indexPath.row]] == true {
                cell.taskView.layer.borderColor = UIColor.blue.cgColor
                cell.taskView.layer.borderWidth = 4
            }else{
                cell.taskView.layer.borderWidth = 0
            }
     
        //セル選択時のハイライトの設定
           cell.selectionStyle = .none
        
           return cell
        }
       }
    
    
    //スワイプしたセルを削除 & スワイプ時の削除ボタンのカスタマイズ(trailingSwipeActionsConfigurationForRowAt)
       
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
                
                if indexPath.row == 0 {
                    return nil
                }else{
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            
                //itemArray.remove(at: indexPath.row)
                ContentsOfTodoList1.remove(at: sortedNumber[indexPath.row])
                //日付の方も
                DeadLineOfTasks1.remove(at: sortedNumber[indexPath.row])
                dateForSort.remove(at: sortedNumber[indexPath.row])
                //
                manageCheckBox.remove(at: sortedNumber[indexPath.row])
                //
                ImportanceOfTasks.remove(at: sortedNumber[indexPath.row])
                               //
                               memoOfTasks.remove(at: sortedNumber[indexPath.row])
                managePin.remove(at: sortedNumber[indexPath.row])
                //
                sortedNumber.removeAll()
                
                
                let timeAndIndexSorted = dateForSort.enumerated().sorted { $1.element > $0.element }

                   
                     
                     print(timeAndIndexSorted)
                     
                 
                     for indexPathRow in 0..<DeadLineOfTasks1.count {
                         

                        //並べ替えた後の並びから元のindex番号を取り出す
                         let originalIndex = timeAndIndexSorted[indexPathRow].offset

                         sortedNumber.append(originalIndex)
                        
                         //`time`自体は並び替えていないがindex番号が正しく変換されている
                         print(DeadLineOfTasks1[originalIndex], terminator: ",")

                         print(ContentsOfTodoList1[originalIndex], terminator: ",")
                        
                        print(ImportanceOfTasks[originalIndex], terminator: ",")
                                               
                                               print(memoOfTasks[originalIndex], terminator: ",")
                     }
                
                // todoが更新されたので保存
                    UserDefaults.standard.set(ContentsOfTodoList1, forKey: "TodoList1" )
                    UserDefaults.standard.set(DeadLineOfTasks1, forKey: "DeadLineOfTasks2")
                    UserDefaults.standard.set(sortedNumber, forKey: "sortedNumberKey")
                    UserDefaults.standard.set(manageCheckBox, forKey: "manageCheckBoxKey")
                    UserDefaults.standard.set(dateForSort, forKey: "dateForSortKey")
                   UserDefaults.standard.set(ImportanceOfTasks, forKey: "importanceOfTasks1")
                   UserDefaults.standard.set(memoOfTasks, forKey: "MemoOfTasks")
                UserDefaults.standard.set(managePin, forKey: "managePinKey")
                
                    tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
                completionHandler(true)
            }
                
            //スワイプ時の削除ボタンをカスタマイズ
                
                deleteAction.image = UIImage(named: "deleteButton05")
                deleteAction.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
                
                
    }
    }
    
    
    
    
    //右スワイプでピンどめ
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
                
        
                let tempSortedNum = sortedNumber[indexPath.row]
                
                let dateString = dateForSort[sortedNumber[indexPath.row]]
                
                
                if indexPath.row == 0 {
                    return nil
                }else  {
                    
            let pinAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            
                self.formatter.dateFormat = "yyyy'/'MM'/'dd(EEE) HH:mm"
                self.formatter.locale = Locale(identifier: "ja_JP")
                let date = self.formatter.date(from: dateString)
                    
                    print(date as Any)
                    
                    if date == nil {
                        //実行されないはず
                        dateForSort[sortedNumber[indexPath.row]] = "1800/12/12/ 12:12"
                    } else {
                        
                        
                        if managePin[sortedNumber[indexPath.row]] == false {
                    
                        let modifiedDate = Calendar.current.date(byAdding: .day, value: -300000, to: date!)!
                            dateForSort[sortedNumber[indexPath.row]] = self.formatter.string(from: modifiedDate)
                            
                            managePin[sortedNumber[indexPath.row]] = true
                        }else{
                            managePin[sortedNumber[indexPath.row]] = false
                            
                            
                            let modifiedDate = Calendar.current.date(byAdding: .day, value: 300000, to: date!)!
                            dateForSort[sortedNumber[indexPath.row]] = self.formatter.string(from: modifiedDate)

                        }

                }
                
                UserDefaults.standard.set(ContentsOfTodoList1, forKey: "TodoList1" )
                UserDefaults.standard.set( DeadLineOfTasks1, forKey: "DeadLineOfTasks2")
                UserDefaults.standard.set(sortedNumber, forKey: "sortedNumberKey")
                UserDefaults.standard.set(manageCheckBox, forKey: "manageCheckBoxKey")
                UserDefaults.standard.set(dateForSort, forKey: "dateForSortKey")
                    
                    
                    
                UserDefaults.standard.set(managePin, forKey: "managePinKey")
                    
                    //並び替え配列リセット
                         sortedNumber.removeAll()
                    //再生成
                      let timeAndIndexSorted = dateForSort.enumerated().sorted { $1.element > $0.element }

                          for indexPathRow in 0..<DeadLineOfTasks1.count {

                              //並べ替えた後の並びから元のindex番号を取り出す
                              let originalIndex = timeAndIndexSorted[indexPathRow].offset

                              sortedNumber.append(originalIndex)
                              
                              
                              //`time`自体は並び替えていないがindex番号が正しく変換されている
                              print(DeadLineOfTasks1[originalIndex], terminator: ",")

                              print(ContentsOfTodoList1[originalIndex], terminator: ",")
                              
                              print(ImportanceOfTasks[originalIndex], terminator: ",")
                                             
                                             print(memoOfTasks[originalIndex], terminator: ",")

                          }
                     
                       UserDefaults.standard.set(sortedNumber, forKey: "sortedNumberKey")
                
                
                
                let destinationIndexPath = sortedNumber.firstIndex(of: tempSortedNum)
                    
                    //cellForRowAtの呼び出し
                    
                    //画面を再読み込みしてcellForRowAtを呼び出して変更内容を画面に反映
                    
                    self.tableView.reloadData()
                    
                    //cellForRowAtの呼び出し
                    //self.tableView.reloadData()
                
                    // DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {}
                    
                
                
                    //移動
                self.tableView.moveRow(at: indexPath, to: IndexPath(row: destinationIndexPath!, section: 0))
                        
                /*
                //セルごとのリロードをするためのindexPathの配列を生成
                var indexPathArray1 = [IndexPath]()
                for i in 1 ..< ContentsOfTodoList1.count{
                    indexPathArray1.append(IndexPath(row: i, section: 0))
                }
                
                //セルごとのリロード(セルごとにcellForRowAtを呼び出す)
                self.tableView.reloadRows(at: indexPathArray1, with: UITableView.RowAnimation.left)
                
                */
                    
                //self.tableView.reloadData()
                //self.viewDidLoad()
                    }
                //スワイプ時のピン留めボタンをカスタマイズ
                pinAction.image = UIImage(named: "deleteButton05")
                pinAction.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
                    
                    
                let configuration = UISwipeActionsConfiguration(actions: [pinAction])
                return configuration
                
    }
                
            
    }
    

    
    
    
                
    var toDoTextField01: String?
    var deadLineField01: String?
    
//セルタップ時の処理 ->　画面遷移から内容変更、presentメソッドを利用(segueを使うとindexPathを維持したままoverrideができない)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if indexPath.row == 0 {
            
        }else{
        
        // storyboardのインスタンス取得
        let storyboard: UIStoryboard = self.storyboard!

        //遷移先のeditingControllerのインスタンスを取得
        let nextView = storyboard.instantiateViewController(withIdentifier: "EditingController") as! EditingController
                
        //データ配列から値を設定
        nextView.toDoTextField = ContentsOfTodoList1[sortedNumber[indexPath.row]]
        nextView.deadLineField = DeadLineOfTasks1[sortedNumber[indexPath.row]]
              nextView.importanceField = ImportanceOfTasks[sortedNumber[indexPath.row]]
              nextView.memoTaskViewString = memoOfTasks[sortedNumber[indexPath.row]]
            nextView.indexFromVC = indexPath
            
            
            
        //遷移
        self.present(nextView, animated: true, completion: nil)
        
        
        //コンソールに行を表示(確認用)
        print("\(indexPath.row)番目の行が選択されました。")
        
    
        
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
            
        /*
        
        //itemArray.remove(at: indexPath.row)
        ContentsOfTodoList1.remove(at: sortedNumber[indexPath.row])
        //日付の方も
        DeadLineOfTasks1.remove(at: sortedNumber[indexPath.row])
        dateForSort.remove(at: sortedNumber[indexPath.row])
        //
        manageCheckBox.remove(at: sortedNumber[indexPath.row])
            
            ImportanceOfTasks.remove(at: sortedNumber[indexPath.row])
                   
                   memoOfTasks.remove(at: sortedNumber[indexPath.row])
            
        //ついでにsortedNum
        sortedNumber.removeAll()
        
        
        
        
        let timeAndIndexSorted = dateForSort.enumerated().sorted { $1.element > $0.element }

           
             
             print(timeAndIndexSorted)
             
         
             for indexPathRow in 0..<DeadLineOfTasks1.count {
                 

                 //並べ替えた後の並びから元のindex番号を取り出す
                 let originalIndex = timeAndIndexSorted[indexPathRow].offset

                 sortedNumber.append(originalIndex)
                 
                 
                 //`time`自体は並び替えていないがindex番号が正しく変換されている
                 print(DeadLineOfTasks1[originalIndex], terminator: ",")

                 print(ContentsOfTodoList1[originalIndex], terminator: ",")
                
                print(ImportanceOfTasks[originalIndex], terminator: ",")
                
                print(memoOfTasks[originalIndex], terminator: ",")
                 
                              }
         
         print(sortedNumber)
        

        // todoが更新されたので保存
            UserDefaults.standard.set(ContentsOfTodoList1, forKey: "TodoList1" )
            UserDefaults.standard.set( DeadLineOfTasks1, forKey: "DeadLineOfTasks2")
            UserDefaults.standard.set(sortedNumber, forKey: "sortedNumberKey")
            UserDefaults.standard.set(manageCheckBox, forKey: "manageCheckBoxKey")
            UserDefaults.standard.set(dateForSort, forKey: "dateForSortKey")
            UserDefaults.standard.set(ImportanceOfTasks, forKey: "importanceOfTasks1")
            UserDefaults.standard.set(memoOfTasks, forKey: "MemoOfTasks")
        
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
 
    */
        
    }
    }
    
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.addSubview(imageView)

        tableView.delegate = self
        tableView.dataSource = self
        
        if tempImage == nil {
            print("tempImageはnilです")
        }else{
            print("tempImageは値を持っています")
        }
        
       
        
        print("viewdidroad")
        
        setBackGroundImage()
        
        //UIImage(named: "backgroundimage3")
                
        //追加画面で入力した内容を取得する
        if UserDefaults.standard.object(forKey: "TodoList1") != nil {
            ContentsOfTodoList1 = UserDefaults.standard.object(forKey: "TodoList1") as! [String]
        }
        if UserDefaults.standard.object(forKey: "DeadLineOfTasks2") != nil {
            DeadLineOfTasks1 = UserDefaults.standard.object(forKey: "DeadLineOfTasks2") as! [String]
        }
        if UserDefaults.standard.object(forKey: "manageCheckBoxKey") != nil {
            manageCheckBox = UserDefaults.standard.object(forKey: "manageCheckBoxKey") as! [Bool]
        }
        if UserDefaults.standard.object(forKey: "dateForSortKey") != nil {
            dateForSort = UserDefaults.standard.object(forKey: "dateForSortKey") as! [String]
        }
        // userDefaultsに保存された値の取得
        if UserDefaults.standard.object(forKey: "sortedNumberKey") != nil {
              sortedNumber = UserDefaults.standard.object(forKey: "sortedNumberKey") as! [Int]
        }
        if UserDefaults.standard.object(forKey: "importanceOfTasks1") != nil {
                   ImportanceOfTasks = UserDefaults.standard.object(forKey: "importanceOfTasks1") as! [String]
               }
        if UserDefaults.standard.object(forKey: "MemoOfTasks") != nil {
                  memoOfTasks = UserDefaults.standard.object(forKey: "MemoOfTasks") as! [String]
              }
        if UserDefaults.standard.object(forKey: "manageDefaultImgKey") != nil {
            manageDefaultImg = UserDefaults.standard.object(forKey: "manageDefaultImgKey") as? Int
        }
        if UserDefaults.standard.object(forKey: "managePinKey") != nil {
            managePin = UserDefaults.standard.object(forKey: "managePinKey") as! [Bool]
        }
        
        //アプリ立ち上げ時背景画像の表示
  
               if manageDefaultImg == 0{
               if manageImage == true {
                   //何か
               }else{
                   display()
                   print("display実行")
                   manageImage = true
                   
               }
               }
        
        if manageDefaultImg == nil {
            manageDefaultImg = 1
            UserDefaults.standard.set(manageDefaultImg, forKey: "manageDefaultImgKey")
        }
        
        
        
        
        
       //並び替え配列リセット
           sortedNumber.removeAll()
      
        //日時にインデックスを付加したタプルを日時の新しい順でソート
            // timeAndIndexSortedは元のdateのindexとそのindexの要素がペアで並ぶ`[(index: Int, element: String)]`型の配列になる
        
        

        let timeAndIndexSorted = dateForSort.enumerated().sorted { $1.element > $0.element }

          
            
            print(timeAndIndexSorted)
            
        
            for indexPathRow in 0..<DeadLineOfTasks1.count {
                

                //並べ替えた後の並びから元のindex番号を取り出す
                let originalIndex = timeAndIndexSorted[indexPathRow].offset

                sortedNumber.append(originalIndex)
                
                
                //`time`自体は並び替えていないがindex番号が正しく変換されている
                print(DeadLineOfTasks1[originalIndex], terminator: ",")

                print(ContentsOfTodoList1[originalIndex], terminator: ",")
                
                print(ImportanceOfTasks[originalIndex], terminator: ",")
                               
                               print(memoOfTasks[originalIndex], terminator: ",")

            }

        print(sortedNumber)
        print(manageCheckBox)
        
        
         UserDefaults.standard.set(sortedNumber, forKey: "sortedNumberKey")
        
        //経線をなくす
        
        tableView.separatorStyle = .none
        //スクロールの棒を無くす
        tableView.showsVerticalScrollIndicator = false
        
        
        
        if UserDefaults.standard.object(forKey: "sortedNumberKey") != nil {
              sortedNumber02 = UserDefaults.standard.object(forKey: "sortedNumberKey") as! [Int]
        }
        
        print(sortedNumber02)
        
        
        if dateForSort.count == 0 {
            ContentsOfTodoList1.append("先日、三田の、小さい学生さんが二人、私の家に参りました。私は生憎加減が悪くて寝ていたのですが、ちょっとで済む御話でしたら、と断って床から抜け出し、どてらの上に羽織を羽織って、面会いたしました。お二人とも、なかなかに行儀がよろしく、しかもさっさと要談をすまし、たちどころに引上げました。つまり、この新聞に随筆を書けという要談であったわけです。私から見ると、いずれも十六七くらいにしか見えない温厚な少年でありましたが、それでもやはり廿を過ぎて居られるのでしょうね。")
            DeadLineOfTasks1.append("")
            dateForSort.append("")
            ImportanceOfTasks.append("")
            memoOfTasks.append("")
            managePin.append(false)
            manageCheckBox.append(false)
            
            //backgroundImageView.image = UIImage(named:"backgroundimage2")
            
            
         
            //変数の中身をUDに追加
            UserDefaults.standard.set( ContentsOfTodoList1, forKey: "TodoList1" )
            UserDefaults.standard.set( DeadLineOfTasks1, forKey: "DeadLineOfTasks2")
            UserDefaults.standard.set( manageCheckBox, forKey: "manageCheckBoxKey")
            UserDefaults.standard.set(dateForSort, forKey: "dateForSortKey")
            UserDefaults.standard.set(ImportanceOfTasks, forKey: "importanceOfTasks1")
                       UserDefaults.standard.set(memoOfTasks, forKey: "MemoOfTasks")
            
            
        }
        
        print(dateForSort)
        
        //初期背景の表示
        switch manageDefaultImg {
        case 1:
            self.backgroundImageView.image = UIImage(named: "backgroundimage2")
        case 2:
            self.backgroundImageView.image = UIImage(named: "backgroundimage1")
        case 3:
            self.backgroundImageView.image = UIImage(named: "backgroundimage3")
        default:
            print("ユーザーのImageを使用")
            backgroundImageView.image = tempImage02
        }
        
    }
   
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.animate()
        })
    }
    
    private func animate() {
        UIView.animate(withDuration: 1, animations:  {
            let size = self.view.frame.size.width * 3
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            
            self.imageView.frame = CGRect(
                x: -(diffX/2),
                y: diffY/2,
                width: size,
                height: size
            )
        })
        
        UIView.animate(withDuration: 1.5, animations:  {
                   self.imageView.alpha = 0
        }, completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                    let viewController = HomeViewController()
                            viewController.modalTransitionStyle = .crossDissolve
                            viewController.modalPresentationStyle = .fullScreen
                            self.present(viewController, animated: true)

                })
            }
        })
    
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    let formatter = DateFormatter()
    
    

    @IBAction func actionButton(_ sender: Any) {
        
        /*
         タップされたセルのoriginalIndexを取得＆表示
        備忘：originalIndex.row　は　ContensOf...やDeadLine...の配列の順序で示してる
            print(sortedNumber[indexPath!.row])
         */
        
        

        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to:tableView)
            let indexPath = tableView.indexPathForRow(at: buttonPosition)
        
            print(indexPath as Any)
        
        //移動先検索用定数
        //let tempSortedNum = sortedNumber[indexPath!.row]
        
        let dateString = dateForSort[sortedNumber[indexPath!.row]]
        //Dateに変換
        formatter.dateFormat = "yyyy'/'MM'/'dd(EEE) HH:mm"
        formatter.locale = Locale(identifier: "ja_JP")
        let date = formatter.date(from: dateString)
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath!) as! ReminderCellSettings
  
        if manageCheckBox[sortedNumber[indexPath!.row]] == true {
            
            //cell.checkBoxImageView.image = UIImage(named: "角形checkBox unDone 03")
            
            manageCheckBox[sortedNumber[indexPath!.row]] = false
            let modifiedDate = Calendar.current.date(byAdding: .day, value: -9000000, to: date!)!
            
            dateForSort[sortedNumber[indexPath!.row]] = formatter.string(from: modifiedDate)
            
            
        } else {
            manageCheckBox[sortedNumber[indexPath!.row]] = true
           // cell.checkBoxImageView.image = UIImage(named: "角形checkBox Done 04")
           
            
            print("日付はnilにならないはず\(date as Any)")
            
            if date == nil {
                
                //dateForSort[sortedNumber[indexPath!.row]] = "3020/12/12/ 12:12"
                
                   
            } else {
            
            let modifiedDate = Calendar.current.date(byAdding: .day, value: 9000000, to: date!)!
            
            dateForSort[sortedNumber[indexPath!.row]] = formatter.string(from: modifiedDate)

        }
        }
        
        
        UserDefaults.standard.set(ContentsOfTodoList1, forKey: "TodoList1" )
        UserDefaults.standard.set( DeadLineOfTasks1, forKey: "DeadLineOfTasks2")
        UserDefaults.standard.set(sortedNumber, forKey: "sortedNumberKey")
        UserDefaults.standard.set(manageCheckBox, forKey: "manageCheckBoxKey")
        UserDefaults.standard.set(dateForSort, forKey: "dateForSortKey")
        UserDefaults.standard.set(ImportanceOfTasks, forKey: "importanceOfTasks1")
        UserDefaults.standard.set(memoOfTasks, forKey: "MemoOfTasks")
        

        //セルの行移動 sortedNumberの再生成→moveRowメソッドでtempSortedNumと再生成したsortedNumberを引数にして移動
        
        //並び替え配列リセット
             sortedNumber.removeAll()
        //再生成
          let timeAndIndexSorted = dateForSort.enumerated().sorted { $1.element > $0.element }

              for indexPathRow in 0..<DeadLineOfTasks1.count {

                  //並べ替えた後の並びから元のindex番号を取り出す
                  let originalIndex = timeAndIndexSorted[indexPathRow].offset

                  sortedNumber.append(originalIndex)
                  
                  
                  //`time`自体は並び替えていないがindex番号が正しく変換されている
                  print(DeadLineOfTasks1[originalIndex], terminator: ",")

                  print(ContentsOfTodoList1[originalIndex], terminator: ",")
                  
                  print(ImportanceOfTasks[originalIndex], terminator: ",")
                                 
                                 print(memoOfTasks[originalIndex], terminator: ",")

              }
         
           UserDefaults.standard.set(sortedNumber, forKey: "sortedNumberKey")
        
        
        //移動先のindexPathを検索
      //let destinationIndexPath = sortedNumber.firstIndex(of: tempSortedNum)
        
        
        
        
        
        //cellForRowAtの呼び出し
        

        
        //self.tableView.reloadData()
        
        //func test()
        //{
/*
            UIView.animate(
                withDuration: 0.4,
                animations:{
                    // リロード
                    self.tableView.moveRow(at: indexPath!, to: IndexPath(row: destinationIndexPath!, section: 0))
                    
                }, completion:{ finished in
                    if (finished) { // 一応finished確認はしておく
                        /* やりたい処理 */
                        self.tableView.reloadData()
                    }
            });
        //}
        
        */
        /*
        //移動
        
        
        */
        
        
        //セルごとのリロードをするためのindexPathの配列を生成
        var indexPathArray = [IndexPath]()
        for i in 1 ..< ContentsOfTodoList1.count{
            indexPathArray.append(IndexPath(row: i, section: 0))
        }
        
        //セルごとのリロード(セルごとにcellForRowAtを呼び出す)
        self.tableView.reloadRows(at: indexPathArray, with: UITableView.RowAnimation.middle)
        
      

        
  
        
        /*画面を再読み込みしてcellForRowAtを呼び出して変更内容を画面に反映
        self.tableView.reloadData()
        self.viewDidLoad()*/
        
    
    
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    @IBAction func multipleDeleteButton(_ sender: Any) {
        

        
        
        for indexPathRow in (0..<DeadLineOfTasks1.count).reversed() {
            

            
            if manageCheckBox[sortedNumber[indexPathRow]] == true {
                
                //itemArray.remove(at: indexPath.row)
                ContentsOfTodoList1.remove(at: sortedNumber[indexPathRow])
                //日付の方も
                DeadLineOfTasks1.remove(at: sortedNumber[indexPathRow])
                dateForSort.remove(at: sortedNumber[indexPathRow])
                //
                ImportanceOfTasks.remove(at: sortedNumber[indexPathRow])
                
                memoOfTasks.remove(at: sortedNumber[indexPathRow])
                
                manageCheckBox.remove(at: sortedNumber[indexPathRow])
                    managePin.remove(at: sortedNumber[indexPathRow])
                
                //IBActionの中なのでIndexPath型のIndexPathが取得できないが、rowとsectionがわかればIndexPathを生成できる IndexPath(row: ,section: )
                tableView.deleteRows(at: [IndexPath(row: indexPathRow, section: 0)], with: UITableView.RowAnimation.middle)
                //
                
                
        
            }
            
            
            
            sortedNumber.removeAll()
            
            let timeAndIndexSorted = dateForSort.enumerated().sorted { $1.element > $0.element }

                 
                 print(timeAndIndexSorted)
                                
                 for indexPathRow in 0..<DeadLineOfTasks1.count {
                     
                     //並べ替えた後の並びから元のindex番号を取り出す
                     let originalIndex = timeAndIndexSorted[indexPathRow].offset

                     sortedNumber.append(originalIndex)
                     
                     
                     //`time`自体は並び替えていないがindex番号が正しく変換されている
                     print(DeadLineOfTasks1[originalIndex], terminator: ",")

                     print(ContentsOfTodoList1[originalIndex], terminator: ",")
                    
                    print(ImportanceOfTasks[originalIndex], terminator: ",")
                                      
                                      print(memoOfTasks[originalIndex], terminator: ",")
                     
            
                 }
            
        }
        
    
    
    // todoが更新されたので保存
     UserDefaults.standard.set(ContentsOfTodoList1, forKey: "TodoList1" )
     UserDefaults.standard.set(DeadLineOfTasks1, forKey: "DeadLineOfTasks2")
     UserDefaults.standard.set(sortedNumber, forKey: "sortedNumberKey")
     UserDefaults.standard.set(manageCheckBox, forKey: "manageCheckBoxKey")
     UserDefaults.standard.set(dateForSort, forKey: "dateForSortKey")
    UserDefaults.standard.set(ImportanceOfTasks, forKey: "importanceOfTasks1")
    UserDefaults.standard.set(memoOfTasks, forKey: "MemoOfTasks")
         UserDefaults.standard.set(managePin, forKey: "managePinKey")
        
}
    
    
//    // 起動時 アニメーション
//       class ViewController: UIViewController {
//
//       var logoImageView: UIImageView!
//
//       override func viewDidLoad() {
//           super.viewDidLoad()
//           // Do any additional setup after loading the view, typically from a nib.
//           self.view.backgroundColor = UIColor.white
//
//           //imageView作成
//           self.logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 204, height: 77))
//           //画面centerに
//           self.logoImageView.center = self.view.center
//           //logo設定
//           self.logoImageView.image = UIImage(named: "logo")
//           //viewに追加
//           self.view.addSubview(self.logoImageView)
//
//       }
//
//           override func viewDidAppear(_ animated: Bool) {
//           //少し縮小するアニメーション
//            UIView.animate(withDuration: 0.3,
//               delay: 1.0,
//               options: UIView.AnimationOptions.curveEaseOut,
//               animations: { () in
//                   self.logoImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//               }, completion: { (Bool) in
//
//           })
//
//           //拡大させて、消えるアニメーション
//               UIView.animate(withDuration: 0.2,
//               delay: 1.3,
//               options: UIView.AnimationOptions.curveEaseOut,
//               animations: { () in
//                   self.logoImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//                   self.logoImageView.alpha = 0
//               }, completion: { (Bool) in
//                   self.logoImageView.removeFromSuperview()
//           })
//       }
//

    }

