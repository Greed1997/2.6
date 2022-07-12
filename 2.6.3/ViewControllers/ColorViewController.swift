//
//  ColorViewController.swift
//  2.6.3
//
//  Created by Александр on 11.07.2022.
//

import UIKit

class ColorViewController: UIViewController {

    //IBOutlets
    @IBOutlet var mainView: UIView!
    
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redTextField: UITextField!
    @IBOutlet var greenTextField: UITextField!
    @IBOutlet var blueTextField: UITextField!
    
    //Public properties
    var delegate: ColorViewControllerDelegate!
    var viewColor: UIColor!
    
    //IBActions
    @IBAction func useSliders(slider: UISlider) {
        switch slider {
        case redSlider:
            setValue(for: redLabel)
            setValue(for: redTextField)
        case greenSlider:
            setValue(for: greenLabel)
            setValue(for: greenTextField)
        default:
            setValue(for: blueLabel)
            setValue(for: blueTextField)
        }
        setColor()
    }
    @IBAction func doneButtonPressed() {
        delegate.setColor(mainView.backgroundColor ?? .purple)
        dismiss(animated: true)
    }
    
    //View
    override func viewDidLoad() {
        
        mainView.layer.cornerRadius = 15
        
        redSlider.minimumTrackTintColor = .red
        greenSlider.minimumTrackTintColor = .green
        blueSlider.minimumTrackTintColor = .blue
        
        setSliders()
        setValue(for: redLabel, greenLabel, blueLabel)
        setValue(for: redTextField, greenTextField, blueTextField)
    }

}
extension ColorViewController {
    private func setColor() {
        mainView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
    private func string(slider: UISlider) -> String {
        return String(format: "%.2f", slider.value)
    }
    private func setValue(for labels: UILabel...) {
        for label in labels {
            switch label {
            case redLabel:
                redLabel.text = string(slider: redSlider)
            case greenLabel:
                greenLabel.text = string(slider: greenSlider)
            default:
                blueLabel.text = string(slider: blueSlider)
            }
        }
    }
    private func setValue(for textFields: UITextField...) {
        textFields.forEach { textField in
            switch textField {
            case redTextField:
                redTextField.text = string(slider: redSlider)
            case greenTextField:
                greenTextField.text = string(slider: greenSlider)
            default:
                blueTextField.text = string(slider: blueSlider)
            }
        }
    }
    private func setSliders() {
        let ciColor = CIColor(color: viewColor)
        
        redSlider.value = Float(ciColor.red)
        greenSlider.value = Float(ciColor.green)
        blueSlider.value = Float(ciColor.blue)
        setColor()
    }
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
    @objc private func didTapDone() {
        view.endEditing(true)
    }
}
// UITextFieldDelegate
extension ColorViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if let value = Float(text) {
            if value <= Float(1) {
                switch textField {
                case redTextField:
                    redSlider.setValue(value, animated: true)
                    setValue(for: redLabel)
                case greenTextField:
                    greenSlider.setValue(value, animated: true)
                    setValue(for: greenLabel)
                default:
                    blueSlider.setValue(value, animated: true)
                    setValue(for: blueLabel)
                }
                setColor()
                return
            }
        }
        showAlert(title: "Wrong Format", message: "Enter correct value")
    }
            
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        textField.inputAccessoryView = keyboardToolbar
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTapDone)
        )
        
        let flexBarButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        keyboardToolbar.items = [flexBarButton, doneButton, flexBarButton]
    }
}
