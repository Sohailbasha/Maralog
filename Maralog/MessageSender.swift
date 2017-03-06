//
//  MessageSender.swift
//  Maralog
//
//  Created by Ilias Basha on 3/6/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import Foundation
import MessageUI


class MessageSender: NSObject, MFMessageComposeViewControllerDelegate {
    
    static let sharedInstance = MessageSender()
    var recepients: [String] = []
    var textBody = ""
    
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    func configuredMessageComposeViewController() -> MFMessageComposeViewController {
        let textComposeVC = MFMessageComposeViewController()
        textComposeVC.messageComposeDelegate = self
        textComposeVC.recipients = recepients
        textComposeVC.body = textBody
        return textComposeVC
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true) {
            self.textBody = ""
            self.recepients.removeAll()
        }
    }
}
