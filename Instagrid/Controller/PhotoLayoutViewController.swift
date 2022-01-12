//
//  ViewController.swift
//  Instagrid
//
//  Created by Yann Rouzaud on 07/01/2022.
//

import UIKit

class PhotoLayoutViewController: UIViewController {

    //MARK: -PRIVATE: properties
    
    @IBOutlet private weak var changePhotoLayoutButtonStackView: UIStackView!
    @IBOutlet private weak var topSectionLayoutStackView: UIStackView!
    @IBOutlet private weak var bottomSectionLayoutStackView: UIStackView!
    
    private let photoLayoutProvider = PhotoLayoutProvider.shared
    
    private var changePhotoLayoutButtons: [UIButton] = []
    
    private var openPhotoLibraryImages: [UIImageView] = []
    
    
    //MARK: -INTERNAL: methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createChangePhotoLayoutButtons()
    }

    
    //MARK: -PRIVATE: methods
    
    /// This function allows you to create a button for each type of photo layout grid and add it to the stackview.
    private func createChangePhotoLayoutButtons() {
        for (index, photoLayout) in photoLayoutProvider.photoLayouts.enumerated() {
            let button = UIButton()
            
            
            guard let selectedImage = UIImage(named: "Selected") else { return }
            button.setImage(selectedImage, for: .selected)
            
            guard let backgroundImage = UIImage(named: photoLayout.imageName) else { return }
            button.setBackgroundImage(backgroundImage, for: .normal)
            
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
            button.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 1, constant: 0))
            
            button.tag = index
            
            button.addTarget(self, action: #selector(displaySelectedLayout), for: .touchUpInside)
            
            changePhotoLayoutButtonStackView.addArrangedSubview(button)
            changePhotoLayoutButtons.append(button)
        }
    }
    
    
    /// This function displays the layout when the button is pressed and indicates which layout is selected
    /// - parameter changeLayoutButton: The button to change the photo layout
    @objc private func displaySelectedLayout(_ changeLayoutButton: UIButton) {
        changePhotoLayoutButtons.forEach { $0.isSelected = false }
        changeLayoutButton.isSelected = true
        setupLayoutViews(photoLayoutIndex: changeLayoutButton.tag)
    }

    
    /// This function creates a photo layout
    /// - parameter photoLayoutIndex: Index of the array where the layout is located (in PhotoLayoutProvider)
    private func setupLayoutViews(photoLayoutIndex: Int) {
        cleanLayoutGrid()
        let photoLayout = photoLayoutProvider.photoLayouts[photoLayoutIndex]
        createLayout(from: photoLayout)
    
    }
    
    
    /// This function allows you to remove all the buttons from the photo layout grid
    private func cleanLayoutGrid() {
        topSectionLayoutStackView.subviews.forEach({ $0.removeFromSuperview() })
        bottomSectionLayoutStackView.subviews.forEach({ $0.removeFromSuperview() })
        openPhotoLibraryImages.removeAll()
    }
    
    
    /// This function is used to create the layout
    /// - parameter photoLayout: The layout to create (from PhotoLayoutProvider)
    private func createLayout(from photoLayout: PhotoLayout) {
        createPhotoButtons(number: photoLayout.numberOfPhotosOnTop, place: .top)
        createPhotoButtons(number: photoLayout.numberOfPhotosOnBottom, place: .bottom)
    }
    
    
    /// This function creates all buttons in the stackview
    /// - parameter number: The number of buttons to create
    /// - parameter place: Place to create the buttons (top or bottom)
    private func createPhotoButtons(number: Int, place: PhotoButtonPlace) {
        for _ in 1...number {
            switch place {
            case .top:
                createPhotoButton(in: topSectionLayoutStackView)
            case .bottom:
                createPhotoButton(in: bottomSectionLayoutStackView)
            }
        }
    }
    
    
    /// This function allows you to create a button for the photo layout grid
    /// - parameter stackview: Add the button in the desired stackview (top or bottom)
    private func createPhotoButton(in stackView: UIStackView) {
        let photoImageView = UIImageView()
        
        photoImageView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)

        didTapOnImage(on: photoImageView)
        
        openPhotoLibraryImages.append(photoImageView)
        stackView.addArrangedSubview(photoImageView)
        
    }
    
    private func didTapOnImage(on imageView: UIImageView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openPhotoLibrary(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func openPhotoLibrary(tapGestureRecognizer: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
}


extension PhotoLayoutViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("\(info)")
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
