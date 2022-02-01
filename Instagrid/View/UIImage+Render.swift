//
//  UIImage+Render.swift
//  Instagrid
//
//  Created by Yann Rouzaud on 01/02/2022.
//

import UIKit

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
