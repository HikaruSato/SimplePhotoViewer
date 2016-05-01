//
//  SiglePhotoViewController.swift
//  PhotoViewer
//
//  Created by hikarusato on 2014/04/25.
//  Copyright © 2016年 HikaruSato. All rights reserved.
//

import UIKit

class SinglePhotoViewController: UIViewController,UIScrollViewDelegate {
	
	@IBOutlet weak var scrollView: UIScrollView!
	var imageView: UIImageView!
	var photoImage:UIImage!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let doubleTapRecognizer = UITapGestureRecognizer(target:self, action:#selector(SinglePhotoViewController.scrollViewDoubleTapped(_:)));
		doubleTapRecognizer.numberOfTapsRequired = 2;
		doubleTapRecognizer.numberOfTouchesRequired = 1;
		self.scrollView.addGestureRecognizer(doubleTapRecognizer);
		
		let twoFingerTapRecognizer = UITapGestureRecognizer(target:self, action:#selector(SinglePhotoViewController.scrollViewTwoFingerTapped(_:)));
		twoFingerTapRecognizer.numberOfTapsRequired = 1;
		twoFingerTapRecognizer.numberOfTouchesRequired = 2;
		self.scrollView.addGestureRecognizer(twoFingerTapRecognizer);
		self.showImage(photoImage)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	func showImage(image:UIImage) {
		self.imageView = UIImageView(image:nil)
		self.imageView.frame = CGRect(origin:CGPoint(x:0.0, y:0.0), size:image.size)
		self.scrollView.addSubview(self.imageView)
		self.scrollView.contentSize = image.size
		
		let minScale:CGFloat = 1.0
		self.scrollView.minimumZoomScale = minScale
		self.scrollView.maximumZoomScale = 5.0
		self.scrollView.zoomScale = minScale
		
		self.centerScrollViewContents()
	}
	
	func centerScrollViewContents() {
		let boundsSize = self.scrollView.bounds.size;
		var contentsFrame = self.imageView.frame;
		
		if (contentsFrame.size.width < boundsSize.width) {
			contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
		} else {
			contentsFrame.origin.x = 0.0
		}
		
		if (contentsFrame.size.height < boundsSize.height) {
			contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
		} else {
			contentsFrame.origin.y = 0.0
		}
		
		self.imageView.frame = contentsFrame;
	}
	
	func scrollViewDoubleTapped(recognizer:UITapGestureRecognizer) {
		let pointInView:CGPoint = recognizer.locationInView(self.imageView)
		
		var newZoomScale = self.scrollView.zoomScale * 1.5
		newZoomScale = min(newZoomScale, self.scrollView.maximumZoomScale);
		
		let scrollViewSize = self.scrollView.bounds.size;
		
		let w = scrollViewSize.width / newZoomScale;
		let h = scrollViewSize.height / newZoomScale;
		let x:CGFloat = pointInView.x - (w / 2.0);
		let y:CGFloat = pointInView.y - (h / 2.0);
		
		let rectToZoomTo = CGRectMake(x, y, w, h);
		
		self.scrollView.zoomToRect(rectToZoomTo,animated:true);
	}
	
	func scrollViewTwoFingerTapped(recognizer:UITapGestureRecognizer) {
		// Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
		var newZoomScale = self.scrollView.zoomScale / 1.5
		newZoomScale = max(newZoomScale, self.scrollView.minimumZoomScale);
		self.scrollView.setZoomScale(newZoomScale ,animated:true);
	}
	
	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
	// Return the view that you want to zoom
	return self.imageView;
	}
	
	func scrollViewDidZoom(scrollView: UIScrollView) {
		self.centerScrollViewContents()
	}
	
    @IBAction func tapClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
	
}


extension SinglePhotoViewController:RMPZoomTransitionAnimating, RMPZoomTransitionDelegate {
    
    //MARK: - <RMPZoomTransitionAnimating>
    
    func transitionSourceImageView() -> UIImageView!
    {
        let image = self.imageView.image
        let imageView = UIImageView(image:image)
        imageView.contentMode = UIViewContentMode.ScaleAspectFill;
        imageView.clipsToBounds = true
        imageView.userInteractionEnabled = false
        imageView.frame =  self.imageView.frame
        return imageView;
    }
    
    func transitionSourceBackgroundColor() -> UIColor!
    {
        return UIColor.clearColor()
    }
    
    func transitionDestinationImageViewFrame() -> CGRect
    {
        let frame = self.imageView.frame
        return frame;
    }
    
    //MARK: - <RMPZoomTransitionDelegate>
    
    func zoomTransitionAnimator(animator:RMPZoomTransitionAnimator,
                                didCompleteTransition didComplete:Bool,
                                                      animatingSourceImageView imageView:UIImageView)
    {
        self.imageView.image = imageView.image;
    }
    
}
