//
//  ViewController.swift
//  Instagrid
//
//  Created by Yann Rouzaud on 07/01/2022.
//

import UIKit

class PhotoLayoutViewController: UIViewController {


    @IBOutlet private weak var topSectionLayoutStackView: UIStackView!
    @IBOutlet private weak var bottomSectionLayoutStackView: UIStackView!
    
    private let photoLayoutProvider = PhotoLayoutProvider.shared
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayoutViews(photoLayoutIndex: 2)
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
        let phottoButtonView = UIButton()
//        phottoButtonView.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
        phottoButtonView.backgroundColor = .white
        stackView.addArrangedSubview(phottoButtonView)
    }
    
    
    private func openPhotoLibrary() {
        
    }
    
    
}

