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

    @IBOutlet private weak var mainPhotoLayoutView: UIView!
    
    
    private let photoLayoutProvider = PhotoLayoutProvider.shared
    
    private var changePhotoLayoutButtons: [UIButton] = []
    
    
    private var currentSelectedButtonImageView: UIImageView?
    
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
        createImageViews(number: photoLayout.numberOfPhotosOnTop, place: .top)
        createImageViews(number: photoLayout.numberOfPhotosOnBottom, place: .bottom)
    }
    
    
    /// This function creates all buttons in the stackview
    /// - parameter number: The number of buttons to create
    /// - parameter place: Place to create the buttons (top or bottom)
    private func createImageViews(number: Int, place: PhotoButtonPlace) {
        for _ in 1...number {
            switch place {
            case .top:
                createImageView(in: topSectionLayoutStackView)
            case .bottom:
                createImageView(in: bottomSectionLayoutStackView)
            }
        }
    }
    
    
    /// This function allows you to create a image view for the photo layout grid
    /// - parameter stackview: Add the image view in the desired stackview (top or bottom)
    func createImageView(in stackView: UIStackView) {
        let photoImageView = UIImageView()
        
        let iconName = "Plus.png"
        let icon = UIImage(named: iconName)
        let iconView = UIImageView(image: icon!)
        
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        
        photoImageView.addSubview(iconView)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 45)
        ])
        
        photoImageView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)

        didTapOnImage(on: photoImageView)
        
        openPhotoLibraryImages.append(photoImageView)
        stackView.addArrangedSubview(photoImageView)
        
    }
    
    
    /// This function recognize when the user tap on photoImageView
    /// - parameter imageView: The imageView tapped
    private func didTapOnImage(on imageView: UIImageView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openPhotoLibrary(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    /// This function open the photo library for choose a photo
    /// - parameter tapGestureRecognizer: The tap gesture
    @objc private func openPhotoLibrary(tapGestureRecognizer: UITapGestureRecognizer) {
        currentSelectedButtonImageView = tapGestureRecognizer.view as? UIImageView
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
}


extension PhotoLayoutViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        currentSelectedButtonImageView?.image = selectedImage
        
        for subView in currentSelectedButtonImageView!.subviews {
            if let imageView = subView as? UIImageView {
                imageView.removeFromSuperview()
            }
        }
        
        currentSelectedButtonImageView = nil
  
        picker.dismiss(animated: true, completion: nil)
    }
}
