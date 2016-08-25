
//
//  ChatViewController.swift
//  GoogleandChat
//
//  Created by 廖堉筌 on 2016/8/21.
//  Copyright © 2016年 CrazyQuan. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import AVFoundation
class ChatViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderId = "1110"
        self.senderDisplayName = "CrazyQuan"
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //=================================
    //以下是包含傳送出去按件的方法/泡泡
    //=================================
    //按下傳送得回傳值
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        print("didPressSendButton----------------------------------------------------------------------")
        
        messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
        print(messages)
        
        
        
        // 執行collectionView有關的方法,而是立即返回
        collectionView.reloadData()
        
    }
    
    ////返回item個數
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of item:\(messages.count)")
        return (messages.count)
    }
    
    //
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        return cell
    }
    
    
    //    要求對應於indexPath在的CollectionView指定項目的信息數據的數據源。
    //    * @參數的CollectionView請求該信息的收集視圖。
    //    * @參數indexPath指定項目的位置的索引路徑。
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    // 建立對話框的泡泡
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        return bubbleFactory.outgoingMessagesBubbleImageWithColor(.blackColor())
    }
    
    // 對話框的users
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    //===============================
    // 以下是左邊迴紋針的方法/照片/拍照
    //===============================
    // 旁邊的迴紋針
    override func didPressAccessoryButton(sender: UIButton!) {
        print("didPressAcessoryButton------------------------------------------------------------------")
        
        // 選單上來的資訊
        let Sheet = UIAlertController(title: "Location Information", message: "Photo/Video", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let Cancel = UIAlertAction(title: "Cancel", style:UIAlertActionStyle.Cancel) { (alert :UIAlertAction) in
        }
        
        let PhotoLibary = UIAlertAction(title: "Show Photo", style: UIAlertActionStyle.Default) { (alert :UIAlertAction) in
            self.getMediaFrom(kUTTypeImage)
        }
        let VideoLibary = UIAlertAction(title: "Show Video", style: UIAlertActionStyle.Default) { (alert :UIAlertAction) in
            self.getMediaFrom(kUTTypeMovie )
        }
        
        self.presentViewController(Sheet, animated: true, completion: nil)
        Sheet.addAction(PhotoLibary)
        Sheet.addAction(VideoLibary)
        Sheet.addAction(Cancel)
        //let imagePicker = UIImagePickerController()
        //presentViewController: 暗示使用者需要完成某件事情，輸入密碼、增加資料等等，使用者必須完成或者取消，才能做其他事
        //pushViewController(補充): 則是讓使用者瀏覽資料，使用者可以決定要前進或回到哪個頁面
        //self.presentViewController(imagePicker, animated: true, completion: nil)
        //imagePicker.delegate = self
        // 上面這些 用下面代替掉了～～ func getMediaFrom
    }
    // 以下不太懂 ？？？？？
    // 似乎是這樣比較好整理 從photolibary,videolibary資料一起整合 再把最下面的func送上來！！！
    func getMediaFrom(type:CFString) {
        let mediaPicker = UIImagePickerController()
        mediaPicker.delegate = self
        mediaPicker.mediaTypes = [type as String]
        self.presentViewController(mediaPicker, animated: true, completion: nil)
        
        print(type)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        
        print("didTapMessageBubbleAtIndexPath : .\(indexPath.item)")
        let message = messages[indexPath.item]
         if message.isMediaMessage {
            
            if let mediaItem = message.media as? JSQVideoMediaItem {
                let player = AVPlayer (URL:mediaItem.fileURL)
                let playViewController = AVPlayerViewController()
                    playViewController.player = player
                self.presentViewController(playViewController, animated: true, completion: nil)
                
            }
        }
    }
    
    
    // 轉頁面  LogOut ！
    @IBAction func LogOutDidTapped(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewControllerWithIdentifier("LoginViewVC") as! LoginViewController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginVC
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}// End...class ChatViewController: JSQMessagesViewController


extension ChatViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    // 跑照片上對話框上面！！！
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("did Finish Picking------------------------------------------")
        print(info)
        
        // get the Image and Video
        
        if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // 因為 picture 不能填入media 他是 UIImage
            // 用 JSQPhotoMediaItem（image: UIImage!)轉成可以用的
            let photo = JSQPhotoMediaItem(image: picture)
            messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: photo))
            
        } else if let Video = info[UIImagePickerControllerMediaURL] as? NSURL {
            let VideoItem = JSQVideoMediaItem(fileURL: Video, isReadyToPlay: true   )
            messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: VideoItem))
            
        }
        // 消失
        self.dismissViewControllerAnimated(true, completion: nil)
        //執行 collectionView有關的方法,而是立即返回
        collectionView.reloadData()
        
    } 
    
}//End...exension ChatViewController


