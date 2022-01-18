//
//  ViewController.swift
//  Instagrid
//
//  Created by Yann Rouzaud on 07/01/2022.
//

import UIKit

class PhotoLayoutViewController: UIViewController {

    //MARK: - PRIVATE: properties
    
    @IBOutlet private weak var changePhotoLayoutButtonStackView: UIStackView!
    @IBOutlet private weak var topSectionLayoutStackView: UIStackView!
    @IBOutlet private weak var bottomSectionLayoutStackView: UIStackView!

    @IBOutlet private weak var mainPhotoLayoutView: UIView!
    
    @IBOutlet private weak var swipeToShareStackView: UIStackView!
    
    private let photoLayoutProvider = PhotoLayoutProvider.shared
    
    private var changePhotoLayoutButtons: [UIButton] = []
    
    private var currentSelectedButtonImageView: UIImageView?
    
    private var openPhotoLibraryImages: [UIImageView] = []
    
    private var windowInterfaceOrientation: UIInterfaceOrientation? {
        return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
    }
    
    private var swipeGesture: UISwipeGestureRecognizer?
    
    // MARK: - INTERNAL: Methods
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) in
            guard let windowInterfaceOrientation = self.windowInterfaceOrientation else { return }
            
            if windowInterfaceOrientation.isLandscape {
                self.swipeGesture?.direction = .left
            } else {
                self.swipeGesture?.direction = .up
                
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createChangePhotoLayoutButtons()
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGestureRecognizer.direction = windowInterfaceOrientation == .portrait ? .up : .left
        self.swipeGesture = swipeGestureRecognizer
        mainPhotoLayoutView.addGestureRecognizer(swipeGestureRecognizer)
    }
    

    //MARK: - PRIVATE: methods
    
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
    private func createImageView(in stackView: UIStackView) {
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
    
    
    // MARK: - Swipe to share
    
    /// This function triggers the swipe function if the user has swiped and add some animations.
    /// - parameter sender: UISwipeGestureRecognizer.
    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width

        var translationTransform = CGAffineTransform()
        
        switch sender.direction {
            case .up:
                translationTransform = CGAffineTransform(translationX: 0, y: -screenHeight)
            case .left:
                translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
            default:
                break
            }

        UIView.animate(withDuration: 0.5, animations: {
            self.mainPhotoLayoutView.transform = translationTransform
            self.swipeToShareStackView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }) { (succes) in

            if succes {
                self.share()
            }
        }
    }
    
    
    /// This function allows to share the desired content
    private func share() {
        guard let image = UIImage(view: mainPhotoLayoutView) else { return }
        
        // set up activity view controller
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // Did share or cancel
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            self.showMainPhotoLayoutView()
        }
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    /// This function resets the position of the elements
    private func showMainPhotoLayoutView(){
        mainPhotoLayoutView.transform = .identity
        mainPhotoLayoutView.transform = CGAffineTransform(scaleX: 0, y: 0)

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.mainPhotoLayoutView.transform = .identity
            self.swipeToShareStackView.transform = .identity
        })
    }
}


// MARK: - EXTENSIONS

extension PhotoLayoutViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        currentSelectedButtonImageView?.image = selectedImage
        
        guard let currentSelectedButtonImageViewUnwrapped = currentSelectedButtonImageView else { return }
        
        for subView in currentSelectedButtonImageViewUnwrapped.subviews {
            if let imageView = subView as? UIImageView {
                imageView.removeFromSuperview()
            }
        }
        
        currentSelectedButtonImageView = nil
  
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UIImage {
    convenience init?(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let graphicContext = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.render(in: graphicContext)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        guard let cgImage = image.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
