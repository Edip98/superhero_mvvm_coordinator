//
//  ProfileHeaderView.swift
//  SuperheroKhalilov
//
//  Created by Эдип on 14.03.2022.
//

import UIKit

protocol ProfileHeaderViewDelegate: AnyObject {
    func handleTextFieldDidChange(nameTextField: UITextField, textFieldUnderline: UIView)
    func didTapOnCameraButton(view: UIView, button: UIButton)
    func didFinishPickingMediaWithInfo(cameraButton: UIButton, profileImage: UIImage)
}

class ProfileHeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var textFieldUnderline: UIView!
    
    weak var delegate: ProfileHeaderViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadNib() {
        let bundle = Bundle(for: ProfileHeaderView.self)
        bundle.loadNibNamed("ProfileHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }
    
    private func configureUI() {
        if let image = ProfileManager.sharedInstance.userProfile?.image {
            cameraButton.setImage(UIImage(data: image), for: .normal)
            cameraButton.layer.borderWidth = 1
            cameraButton.layer.borderColor = UIColor.customYellow.cgColor
            cameraButton.clipsToBounds = true
        } else {
            cameraButton.setImage(UIImage(named: "Camera"), for: .normal)
        }
        cameraButton.layer.cornerRadius = 8
        cameraButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        cameraButton.contentMode = .scaleAspectFit

        nameTitle.text = "Name"
        nameTitle.textColor = .white
        nameTitle.font = UIFont(name: UIFont.helveticaNeue, size: 18)
        
        nameTextField.delegate = self
        nameTextField.borderStyle = .none
        nameTextField.backgroundColor = .clear
        nameTextField.textColor = .white
        nameTextField.font = UIFont(name: UIFont.helveticaNeue, size: 18)
        nameTextField.returnKeyType = .done
        nameTextField.autocorrectionType = .no
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter Your Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.customGray, .font: UIFont(name: UIFont.helveticaNeueLight, size: 18) ?? UIFont.systemFont(ofSize: 18)])
        nameTextField.addTarget(self, action: #selector(handleTextFieldDidChange), for: .editingChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
        
        textFieldUnderline.backgroundColor = .white
    }
    
    @objc private func handleTap() {
        endEditing(true)
    }
    
    @IBAction func cameraButtonAction(_ sender: UIButton) {
        delegate.didTapOnCameraButton(view: self, button: cameraButton)
    }
    
    @objc func handleTextFieldDidChange() {
        delegate.handleTextFieldDidChange(nameTextField: nameTextField, textFieldUnderline: textFieldUnderline)
    }
}

extension ProfileHeaderView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
}

extension ProfileHeaderView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            delegate.didFinishPickingMediaWithInfo(cameraButton: cameraButton, profileImage: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
