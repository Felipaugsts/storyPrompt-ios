//
//  storyPromptViewController.swift
//  AppUIKIT
//
//  Created by FELIPE AUGUSTO SILVA on 20/01/22.
//

import UIKit

class storyPromptViewController: UIViewController {

    @IBOutlet weak var storyPromptTextField: UITextView!
    
    var storyPrompt: StoryPromptEntry?
    var isNewStoryPrompt = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storyPromptTextField.text = storyPrompt?.description
        if isNewStoryPrompt {
            let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveStoryPrompt))
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelStoryPrompt))
            navigationItem.rightBarButtonItem = saveButton
            navigationItem.leftBarButtonItem = cancelButton
            
        }
    }
    @objc func cancelStoryPrompt() {
        performSegue(withIdentifier: "CancelStorPrompt", sender: nil)
    }
    @objc func saveStoryPrompt() {
        NotificationCenter.default.post(name: .StoryPromptSaved, object: storyPrompt)
        performSegue(withIdentifier: "SaveStoryPrompt", sender: nil)
    }


}
extension Notification.Name {
     static let StoryPromptSaved = Notification.Name("StoryPromptSave")
 }
