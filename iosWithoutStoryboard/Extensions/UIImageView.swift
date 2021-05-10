//
//  UIImageView.swift
//  iosWithoutStoryboard
//
//  Created by quan bui on 2021/05/10.
//

import Foundation
import UIKit

extension UIImageView {

    func loadImageAsync(url: URL?) {
        let defaultImg = UIImage(named: "placeholder.png")
        self.contentMode = .scaleAspectFill

        if url == nil {
            self.image = defaultImg
            return
        }

        DispatchQueue.global(qos: .utility).async {
            do {
                let imgData: Data? = try Data(contentsOf: url!)
                DispatchQueue.main.async {
                    if let data = imgData {
                        self.image = UIImage(data: data)
                    } else {
                        self.image = defaultImg
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.image = defaultImg
                }
            }
        }
    }
}
