//
//  ReminderCellSettingsTableViewCell.swift
//  ourReminder02
//
//  Created by Yoshito Hasegawa on 2020/06/22.
//  Copyright © 2020 Yoshito Hasegawa. All rights reserved.
//
import UIKit



class ReminderCellSettings: UITableViewCell {

    @IBOutlet weak var taskView: UIView!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var notificationButtonImageView: UIImageView!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var deadLineLabel: UILabel!
    @IBOutlet weak var countDownForDeadLineLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      /*
        if taskView == nil {}
        else{
        //viewの背景色設定
        taskView.backgroundColor = UIColor(displayP3Red: 0.5 ,green: 0.5, blue: 0.5, alpha: 0.9)
        //最初にボックスに表示する画像
        //checkBoxImageView.image = UIImage(named: "角形checkBox unDone 03")
        //notificationButtonImageView.image = UIImage(named: "通知off02")
        //deadLineLabel.text = "2020.06.05. 12:00"
            
        //countDownForDeadLineLabel.text = "あと4日"
        
        }
 */
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     

  // var checkBoxChangeNumber = 0
    @IBAction func changeCheckBoxButton(_ sender: Any) {
        
  /* if checkBoxChangeNumber == 0 {
           checkBoxImageView.image = UIImage(named: "角形checkBox Done 04")
           taskView.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.6)
       } else {
           checkBoxImageView.image = UIImage(named: "角形checkBox unDone 03")
             taskView.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.9)
       }
       checkBoxChangeNumber = (checkBoxChangeNumber + 1) % 2
 */
        
   }
   
    
        
    
    var notificationChangeNumber = true
    @IBAction func notificationChangeButton(_ sender: Any) {
        if notificationChangeNumber == true {
            notificationButtonImageView.image = UIImage(named: "通知on01")
            notificationChangeNumber = false
        } else {
            notificationButtonImageView.image = UIImage(named: "通知off02")
            notificationChangeNumber = true
        }
        
    }
    


}
