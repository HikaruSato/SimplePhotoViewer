//
//  ViewController.swift
//  PhotoViewer
//
//  Created by HikaruSato on 2016/04/10.
//  Copyright © 2016年 HikaruSato. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let navi = segue.destination as? UINavigationController,
            let pc = navi.topViewController as? PhotoCollectionViewController,
            segue.identifier == "photoViewer" {
            pc.images = self.getSampleImages()
        }
    }
    
    private func getSampleImages() -> [UIImage] {
        var images = [UIImage]()
        for i in 1...15 {
            let image = UIImage(named: "cat\(i)")!
            images.append(image)
        }
        return images
    }
}
