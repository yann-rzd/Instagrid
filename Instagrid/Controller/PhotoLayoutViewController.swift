//
//  ViewController.swift
//  Instagrid
//
//  Created by Yann Rouzaud on 07/01/2022.
//

import UIKit

class PhotoLayoutViewController: UIViewController {


    @IBOutlet weak var firstLayoutButton: UIButton!
    @IBOutlet weak var secondLayoutButton: UIButton!
    @IBOutlet weak var thirdLayoutButton: UIButton!
    @IBOutlet private weak var topSectionLayoutStackView: UIStackView!
    @IBOutlet private weak var bottomSectionLayoutStackView: UIStackView!
    
    private let photoLayoutProvider = PhotoLayoutProvider.shared
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    @IBAction func didTapLayoutButton(_ sender: UIButton) {
        firstLayoutButton.isSelected = false
        secondLayoutButton.isSelected = false
        thirdLayoutButton.isSelected = false
        
        sender.isSelected = true
        displaySelectedLayout(sender)
    }
    
    private func displaySelectedLayout(_ layout: UIButton) {
        switch layout {
        case firstLayoutButton:
            refreshLayoutGrid()
            setupLayoutViews(photoLayoutIndex: 0)
        case secondLayoutButton:
            refreshLayoutGrid()
            setupLayoutViews(photoLayoutIndex: 1)
        case thirdLayoutButton:
            refreshLayoutGrid()
            setupLayoutViews(photoLayoutIndex: 2)
        default:
            break
        }
    }
    
    private func refreshLayoutGrid() {
        topSectionLayoutStackView.subviews.forEach({ $0.removeFromSuperview() })
        bottomSectionLayoutStackView.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    private func setupLayoutViews(photoLayoutIndex: Int) {
        let photoLayout = photoLayoutProvider.photoLayouts[photoLayoutIndex]
        createLayout(from: photoLayout)
    
    }
    
    private func createLayout(from photoLayout: PhotoLayout) {
        createPhotoButtons(number: photoLayout.numberOfPhotosOnTop, place: .top)
        createPhotoButtons(number: photoLayout.numberOfPhotosOnBottom, place: .bottom)
    }
    
    
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
    
    private func createPhotoButton(in stackView: UIStackView) {
        
        let photoButtonView = UIButton()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        let image = UIImage(named: "Plus.png")
        imageView.image = image
        
        photoButtonView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
        photoButtonView.setImage(image, for: UIControl.State.normal)
        stackView.addArrangedSubview(photoButtonView)
        

    }
    
    
    private func openPhotoLibrary() {
        
    }
    
    
}

