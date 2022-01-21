//
//  ViewController.swift
//  AppUIKIT
//
//  Created by FELIPE AUGUSTO SILVA on 19/01/22.
//

import UIKit
import PhotosUI

class AddStoryPromptViewController: UIViewController {

    @IBOutlet weak var nounTextField: UITextField!
    @IBOutlet weak var adjectiveTextField: UITextField!
    @IBOutlet weak var verbTextField: UITextField!
    @IBOutlet weak var numberSlider: UISlider!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var storyPromptImageView: UIImageView!
    
    let storyPrompt = StoryPromptEntry()
    
    //    Change the story type
    @IBAction func changeStoryType(_ sender: UISegmentedControl) {
        if let genre = StoryPrompts.Genre(rawValue: sender.selectedSegmentIndex) {
            storyPrompt.genre = genre
        } else {
            storyPrompt.genre = .scifi
        }
        
    }
    
    //    SLIDER
    @IBAction func changeNumber(_ sender: UISlider) {
        numberLabel.text = "Number: \(Int(sender.value))"
        storyPrompt.number = Int(sender.value)
    }
    
    //    PASS DATA
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StoryPrompt" {
            guard let storyPromptViewController = segue.destination as? storyPromptViewController else {
                return
            }
            storyPromptViewController.storyPrompt = storyPrompt
            storyPromptViewController.isNewStoryPrompt = true
        }
    }
    
    //    GENERATE A PROMPT
    @IBAction func generateStoryPrompt(_ sender: Any) {
        updateStoryPrompt()
        if storyPrompt.isValid() {
            performSegue(withIdentifier: "StoryPrompt", sender: nil)
        } else {
            let alert = UIAlertController(title: "Invalid Story Prompt", message: "Please fill out all of the fields", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: {
                action in
            })
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storyPromptImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeImage))
        storyPromptImageView.addGestureRecognizer(gestureRecognizer)
        title = "Prompt"
        NotificationCenter.default.addObserver(self, selector: #selector(updateStoryPrompt), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    
    @objc func updateStoryPrompt() {
        
        storyPrompt.noun = nounTextField.text ?? ""
        storyPrompt.adjective = adjectiveTextField.text ?? ""
        storyPrompt.verb = verbTextField.text ?? ""
    }
    @objc func changeImage() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let controller = PHPickerViewController(configuration:  configuration)
        controller.delegate = self
        present(controller, animated: true)
    }
}
extension AddStoryPromptViewController: UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        updateStoryPrompt()
        return true
    }
}

extension AddStoryPromptViewController: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    if !results.isEmpty {
      let result = results.first!
      let itemProvider = result.itemProvider
      if itemProvider.canLoadObject(ofClass: UIImage.self) {
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
          guard let image = image as? UIImage else {
            return
          }
          DispatchQueue.main.async {
            self?.storyPromptImageView.image = image
          }
        }
      }
    }
  }
}
