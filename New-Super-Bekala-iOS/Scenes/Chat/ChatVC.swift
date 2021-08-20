//
//  ChatVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 31/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import PusherSwift
import Lottie
import MaterialComponents
import SVProgressHUD
import SwiftyJSON
import AVFoundation

class ChatVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var agentName: LocalizedLabel!
    @IBOutlet weak var waitingAgentView: UIView!
    @IBOutlet weak var lineProgressView: UIView!
    @IBOutlet weak var lottieContainer: UIView!
    @IBOutlet weak var messageBottomCnst: NSLayoutConstraint!
    @IBOutlet weak var messageTV: UITextView!
    @IBOutlet weak var sendBtnWidthCnst: NSLayoutConstraint!
    @IBOutlet weak var minimizeBtn: UIButton!
    @IBOutlet weak var lockView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reopenBtn: LocalizedBtn!
    @IBOutlet weak var sendBtnView: ViewCorners!
    
    var animationView: AnimationView?
    var conversationId: Int?
    var userOne: User?
    var userTwo: User?
    var presenter: MainPresenter?
    var messages = [Message]()
    let dateFormatter = DateFormatter()
    var incrementalId = 1
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Shared.unseenMessages = 0
        
        let options = PusherClientOptions(
            authMethod: AuthMethod.authRequestBuilder(authRequestBuilder: AuthRequestBuilder()),
            host: .cluster("eu")
        )
        
        if let _ = AppDelegate.pusher{
            AppDelegate.pusher.unbindAll()
            AppDelegate.channel.unbindAll()
        }
        
        AppDelegate.pusher = Pusher(key: "3291250172ef81e382a7", options: options)
        AppDelegate.pusher.connection.delegate = self
        AppDelegate.pusher.delegate = self
        AppDelegate.pusher.connect()
        
        AppDelegate.channel = AppDelegate.pusher.subscribe("private-conversations.\(Shared.currentConversationId ?? 0)")
        
        let _ = AppDelegate.channel.bind(eventName: "App\\Events\\JoinConversation") { (data: Any?) -> Void in
            if let data = try? JSON(data!)["conversation"].rawData(),
               let conversation = data.getDecodedObject(from: Conversation.self){
                self.didCompleteWithConversation(conversation, nil)
                self.waitingAgentView.isHidden = true
                self.animationView?.stop()
            }
            AppDelegate.channel.unbindAll(forEventName: "App\\Events\\JoinConversation")
        }
        
        let _ = AppDelegate.channel.bind(eventName: "App\\Events\\MessageSent") { [self] (data: Any?) -> Void in
            guard JSON(data!)["message"]["sender_id"].intValue != APIServices.shared.user?.id else { return }
            self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            self.appendAndUpdateTable(msgModel: Message(
                                        body: JSON(data!)["message"]["body"].stringValue,
                                        senderID: 0, createdAt: self.dateFormatter.string(from: Date())))
            Shared.play("message_notify_tone", &self.player)
            guard !UIApplication.getTopViewController()!.isKind(of: ChatVC.self) else { return }
            Shared.unseenMessages += 1
            NotificationCenter.default.post(name: NSNotification.Name("is_chatting"), object: nil)
        }
        
        let _ = AppDelegate.channel.bind(eventName: "App\\Events\\LockConversation") { (data: Any?) -> Void in
            self.activityIndicator.stopAnimating()
            self.reopenBtn.isHidden = false
            Shared.play("conversation_locked", &self.player)
            self.lockView.isHidden = false
            Vibration.warning.vibrate()
        }
        
        let _ = AppDelegate.channel.bind(eventName: "App\\Events\\ReopenConversation") { (data: Any?) -> Void in
            self.activityIndicator.stopAnimating()
            self.reopenBtn.isHidden = false
            Shared.play("conversation_locked", &self.player)
            self.lockView.isHidden = true
            Vibration.warning.vibrate()
        }
        
        presenter = MainPresenter(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        chatTableView.addTapGesture { (_) in
            self.view.endEditing(true)
        }
                
        if Shared.isChatting{
            waitingAgentView.isHidden = true
            SVProgressHUD.show()
            presenter?.getConversation(Shared.currentConversationId!)
            minimizeBtn.isHidden = false
        }else{
            minimizeBtn.isHidden = true
            waitingAgentView.isHidden = false
            loadLottie()
        }
        
    }
    
    func loadLottie(){
        
        animationView = .init(name: "wait_joining_chat")
        animationView!.frame = lottieContainer.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        lottieContainer.addSubview(animationView!)
        animationView!.play()
        
        let progressView = MDCProgressView()
        progressView.mode = .indeterminate
        progressView.progressTintColor = UIColor(named: "Main")!
        progressView.trackTintColor = UIColor(named: "LightGray")!
        progressView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 2)
        lineProgressView.addSubview(progressView)
        progressView.startAnimating()
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue) {
            let keyboardRectangle = keyboardSize.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 0.5) {
                self.messageBottomCnst.constant = keyboardHeight
                self.view.layoutIfNeeded()
                self.chatTableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard !textView.text.isEmpty else{
            sendBtnView.alpha = 0.5
            return
        }
        sendBtnView.alpha = 1
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.4) {
            self.messageBottomCnst.constant = 20
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func reopen(_ sender: Any) {
        activityIndicator.startAnimating()
        reopenBtn.isHidden = true
        presenter?.reopenConversation()
    }
    
    
    @IBAction func sendMessageAction(_ sender: Any) {
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        presenter?.sendMessage(messageTV.text!, Shared.currentConversationId!, incrementalId)
        appendAndUpdateTable(msgModel: Message(body: messageTV.text!,
                                               senderID: APIServices.shared.user?.id,
                                               createdAt: dateFormatter.string(from: Date()),
                                               delivered: false,
                                               incrementalId: self.incrementalId))
        incrementalId += 1
    }
    
    func appendAndUpdateTable(msgModel: Message){
        messages.append(msgModel)
        var rowAnimation: UITableView.RowAnimation?
        if msgModel.senderID == APIServices.shared.user?.id{
            rowAnimation = "lang".localized == "ar" ? .left : .right
        }else{
            rowAnimation = "lang".localized == "ar" ? .right : .left
        }
        self.chatTableView.beginUpdates()
        self.chatTableView.insertRows(at: [IndexPath(row: (self.messages.count-1), section: 0)], with: rowAnimation ?? .automatic)
        self.chatTableView.endUpdates()
        self.chatTableView.scrollToRow(at: IndexPath(row: (self.messages.count-1), section: 0), at: .bottom, animated: true)
        self.messageTV.text = ""
    }
    
    @IBAction func backAction(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "If you exit the chat we will clear the current session messages, are you sure you want to exit ?".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue".localized, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Exit".localized, style: .cancel, handler: { (_) in
            self.presenter?.lockConversation()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func minimizeAction(_ sender: Any) {
        Shared.unseenMessages = 0
        Shared.isChatting = true
        NotificationCenter.default.post(name: NSNotification.Name("is_chatting"), object: nil)
        self.dismiss(animated: false, completion: nil)
        
    }
}

extension ChatVC: PusherDelegate{
    func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
        print("old: \(old.stringValue()) -> new: \(new.stringValue())")
    }
    func debugLog(message: String) {
        print("debugLog",message)
    }
    func subscribedToChannel(name: String) {
        print("subscribedToChannel",name)
    }
    func failedToSubscribeToChannel(name: String, response: URLResponse?, data: String?, error: NSError?) {
        print("failedToSubscribeToChannel",name)
    }
    func receivedError(error: PusherError) {
        print("receivedError",error.message)
    }
}


class AuthRequestBuilder: AuthRequestBuilderProtocol {
    func requestFor(socketID: String, channelName: String) -> URLRequest? {
        var request = URLRequest(url: URL(string: "https://dev4.superbekala.com/broadcasting/auth")!)
        request.httpMethod = "POST"
        request.httpBody = "socket_id=\(socketID)&channel_name=\(channelName)".data(using: String.Encoding.utf8)
        request.setValue("Bearer " + (APIServices.shared.user?.token ?? ""), forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

struct DebugConsoleMessage: Codable {
    let name: String
    let message: String
}

