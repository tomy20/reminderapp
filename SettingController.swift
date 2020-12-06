//
//  SettingController.swift
//  ourReminder02
//
//  Created by Yoshito Hasegawa on 2020/08/04.
//  Copyright © 2020 Yoshito Hasegawa. All rights reserved.
//

import UIKit
import Foundation
import CoreData

extension UIImage {

func fixedOrientation() -> UIImage {
    if self.imageOrientation == .up { return self }

UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
    self.draw(in: CGRect(origin: CGPoint.init(), size: self.size))
let image = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()
    return image!
}
}

class SettingController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    //var IMAGE : UIImage!

    @IBOutlet weak var backGround01: UIImageView!
    
    @IBOutlet weak var backGround02: UIImageView!
    
    @IBOutlet weak var backGround03: UIImageView!
    
    @IBAction func backGround01_Action(_ sender: Any) {
        manageDefaultImg = 1
        UserDefaults.standard.set( manageDefaultImg, forKey: "manageDefaultImgKey" )
        viewDidLoad()
    }
    
    @IBAction func backGround02_Action(_ sender: Any) {
        manageDefaultImg = 2
        UserDefaults.standard.set( manageDefaultImg, forKey: "manageDefaultImgKey" )
        viewDidLoad()
    }
    
    @IBAction func backGround03_Action(_ sender: Any) {
        manageDefaultImg = 3
        UserDefaults.standard.set( manageDefaultImg, forKey: "manageDefaultImgKey" )
        viewDidLoad()
    }
    
    
    @IBAction func userPhoto(_ sender: Any) {
        print(tempImage03 as Any)
        if tempImage03 != nil {
        manageDefaultImg = 0
        UserDefaults.standard.set( manageDefaultImg, forKey: "manageDefaultImgKey" )
        viewDidLoad()
        }else{
            print("there isn't any photo")
        }
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    @IBAction func chooseImage(_ sender: UIButton) {
        let ipc = UIImagePickerController()
        ipc.delegate = self
        ipc.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        //編集を可能にする
        ipc.allowsEditing = true

        self.present(ipc,animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backGround01.image = UIImage(named: "backgroundimage2")
        backGround02.image = UIImage(named: "backgroundimage1")
        backGround03.image = UIImage(named: "backgroundimage3")
        
        if tempImage03 == nil {
            imageView.image = UIImage(named: "defaultChooseImg")
        }else{
        imageView.image = tempImage03
        }
        
        //ここから追加部分
        switch manageDefaultImg {
        case 1:
            backGround01.alpha = 1
            backGround02.alpha = 0.4
            backGround03.alpha = 0.4
            imageView.alpha = 0.4
            
        case 2:
            backGround01.alpha = 0.4
            backGround02.alpha = 1
            backGround03.alpha = 0.4
            imageView.alpha = 0.4
            
        case 3:
            backGround01.alpha = 0.4
            backGround02.alpha = 0.4
            backGround03.alpha = 1
            imageView.alpha = 0.4
        
        case 0:
            backGround01.alpha = 0.4
            backGround02.alpha = 0.4
            backGround03.alpha = 0.4
            imageView.alpha = 1
            
            
        default:
            print("予期せぬエラー(manageDefaultImg)")
            
        }
        
        
        
        
        
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        //編集機能を表示させない場合
        let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage
        
        
        imageView.image = image

        
        //imagePickerで取得した画像を遷移先のViewControllerに渡す
        let storyboard: UIStoryboard = self.storyboard!

        let nextView = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        
        if let IMAGE = image {
            nextView.tempImage = IMAGE.fixedOrientation()
            //nextView.backgroundImageView.image = UIImage(named: "")
            
            
            
        }else{
            print("err")
        }
        
        
        backGround01.alpha = 0.4
        backGround02.alpha = 0.4
        backGround03.alpha = 0.4
        imageView.alpha = 1
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func done001(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainSetting") as! mainSettingControllerViewController
        

        //let storyboard: UIStoryboard = self.storyboard!

        //let nextView = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        //nextView.backgroundImageView.image = IMAGE.fixedOrientation()
        
        secondViewController.modalPresentationStyle = .fullScreen
        self.present(secondViewController, animated: true, completion: nil)
        
    }
}
