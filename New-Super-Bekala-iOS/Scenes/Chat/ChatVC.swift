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

class ChatVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var agentName: LocalizedLabel!
    @IBOutlet weak var waitingAgentView: UIView!
    @IBOutlet weak var lineProgressView: UIView!
    @IBOutlet weak var lottieContainer: UIView!
    @IBOutlet weak var messageBottomCnst: NSLayoutConstraint!
    @IBOutlet weak var messageTV: UITextView!
    @IBOutlet weak var sendBtnWidthCnst: NSLayoutConstraint!
    
    var animationView: AnimationView?
    var conversationId: Int?
    var userOne: User?
    var userTwo: User?
    var presenter: MainPresenter?
    var messages = [Message]()
    let dateFormatter = DateFormatter()
    var incrementalId = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenter(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                
        let options = PusherClientOptions(
            authMethod: AuthMethod.authRequestBuilder(authRequestBuilder: AuthRequestBuilder()),
            autoReconnect: true, host: .cluster("eu")
        )
        
        chatTableView.addTapGesture { (_) in
            self.view.endEditing(true)
        }
        
        sendBtnWidthCnst.constant = 0
        view.layoutIfNeeded()
        
        AppDelegate.pusher = Pusher(key: "3291250172ef81e382a7", options: options)
        AppDelegate.pusher.connection.delegate = self
        AppDelegate.pusher.delegate = self
        AppDelegate.pusher.connect()
        
        if Shared.isChatting{
            waitingAgentView.isHidden = true
            SVProgressHUD.show()
            presenter?.getConversation(Shared.currentConversationId!)
        }else{
            waitingAgentView.isHidden = false
            loadLottie()
            DispatchQueue.main.asyncAfter(deadline: .now()+5) {
                self.agentDidJoinConversation()
            }
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
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let height = keyboardSize.height
            UIView.animate(withDuration: 0.5) {
                self.messageBottomCnst.constant = height
                self.view.layoutIfNeeded()
                self.chatTableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        UIView.animate(withDuration: 0.2) { [self] in
            guard !textView.text.isEmpty else{
                sendBtnWidthCnst.constant = 0
                self.view.layoutIfNeeded()
                return
            }
            sendBtnWidthCnst.constant = 45
            self.view.layoutIfNeeded()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.4) {
            self.messageBottomCnst.constant = 0
            self.view.layoutIfNeeded()
        }
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
    
    
    func agentDidJoinConversation(){
        waitingAgentView.isHidden = true
        animationView?.stop()
        presenter?.getConversation(Shared.currentConversationId!)
    }
    
    @IBAction func backAction(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "If you exit the chat we will clear the current session messages, are you sure you want to exit ?".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue".localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Exit".localized, style: .default, handler: { (_) in
            Shared.isChatting = false
            NotificationCenter.default.post(name: NSNotification.Name("is_chatting"), object: nil)
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func minimizeAction(_ sender: Any) {
        Shared.isChatting = true
        NotificationCenter.default.post(name: NSNotification.Name("is_chatting"), object: nil)
        self.dismiss(animated: false, completion: nil)

    }
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let messageDate = dateFormatter.date(from: self.messages[indexPath.row].createdAt!)
        dateFormatter.dateFormat = "h:mm a"//"MMM d, h:mm a"
        
        if self.messages[indexPath.row].senderID == APIServices.shared.user?.id{
            let cell = tableView.dequeueReusableCell(withIdentifier: SentTextMessageCell.identifier, for: indexPath) as! SentTextMessageCell
            cell.message.text = self.messages[indexPath.row].body
            cell.timeStamp.text = dateFormatter.string(from: messageDate!)
            cell.userImage.kf.setImage(with: URL(string: Shared.storageBase + (userOne?.avatar ?? "")))
            cell.messageStatusImage.isHidden = false
            if self.messages[indexPath.row].delivered {
                cell.messageStatusImage.image = UIImage(named: "message_sent")
            }else{
                cell.messageStatusImage.image = UIImage(named: "message_loading")
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: ReceivedTextMessageCell.identifier, for: indexPath) as! ReceivedTextMessageCell
            cell.message.text = self.messages[indexPath.row].body
            cell.timeStamp.text = dateFormatter.string(from: messageDate!)
            cell.userImage.kf.setImage(with: URL(string: Shared.storageBase + (userTwo?.avatar ?? "")))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
        var request = URLRequest(url: URL(string: "https://khdamat.app/broadcasting/auth")!)
        request.httpMethod = "POST"
        request.httpBody = "socket_id=\(socketID)&channel_name=\(channelName)".data(using: String.Encoding.utf8)
        request.setValue("Bearer " + (APIServices.shared.user?.token ?? ""), forHTTPHeaderField: "Authorization")
      //  request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        //request.setValue("*", forHTTPHeaderField: "Access-Control-Allow-Origin")
        return request
    }
}

struct DebugConsoleMessage: Codable {
    let name: String
    let message: String
}

extension ChatVC: MainViewDelegate{
    func didCompleteWithConversation(_ data: Conversation?, _ error: String?) {
        SVProgressHUD.dismiss()
        if let data = data{
            userOne = data.userOne
            userTwo = data.userTwo
            if data.messages.isEmpty{
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let msgEn = "Hi, \(userOne?.name ?? ""). Thanks for contacting Super Be. This is \(userTwo?.name ?? ""), I hope you`re having a good day, How may I help you?"
                let msgAr = "أهلا \(userOne?.name ?? "") ، " + " شكرا لتواصلك مع سوبر بي ، معاك " + (userTwo?.name ?? "") + " ، اقدر اساعدك ازاي؟"
                messages.append(
                    Message(body: "lang".localized == "en" ? msgEn : msgAr,
                            senderID: 0,
                            createdAt: dateFormatter.string(from: Date())))
            }
            data.messages.forEach { message in self.messages.append(message) }
            messages = messages.reversed()
            agentName.text = data.userTwo?.name
            chatTableView.delegate = self
            chatTableView.dataSource = self
            chatTableView.reloadData()
        }else{
            showToast(error!)
        }
    }
    
    func didCompleteSendMessage(_ sent: Bool, _ id: Int) {
        if sent{
            messages[messages.firstIndex{ $0.incrementalId == id }!].delivered = true
            chatTableView.reloadData()
        }
    }
}
