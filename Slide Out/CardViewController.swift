//
//  CardViewController.swift
//  Slide Out
//
//  Created by Saliou DJALO on 12/08/2019.
//  Copyright © 2019 Saliou DJALO. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
    
    var handleArea: UIView = {
        var vi = UIView()
        vi.backgroundColor = UIColor.white
        return vi
    }()
    
    var lineImageView: UIImageView = {
        var ig = UIImageView()
        ig.image = UIImage(named: "line")!
        ig.contentMode = .scaleAspectFit
        ig.clipsToBounds = true
        return ig
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 255/255, green: 187/255, blue: 51/255, alpha: 1)
        
        view.addSubview(handleArea)
        handleArea.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 30)
        
        view.addSubview(lineImageView)
        lineImageView.frame = CGRect(x: 16, y: 5, width: view.frame.width - 32, height: 25)
        
    }
    
}
