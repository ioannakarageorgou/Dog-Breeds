//
//  UIImageView+Extensions.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 20/1/24.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        // make it async to not block the UI, otherwise use Kingfisher (+ caching)
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
