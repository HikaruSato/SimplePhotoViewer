//
//  PhotoCllectionViewController.swift
//  PhotoViewer
//
//  Created by hikarusato on 2016/05/01.
//  Copyright © 2016年 HikaruSato. All rights reserved.
//

import UIKit

class PhotoCollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
	
	@IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var images:[UIImage]!
    
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let cellWidth = (self.view.frame.width - self.flowLayout.sectionInset.left - self.flowLayout.sectionInset.right - self.flowLayout.minimumInteritemSpacing*2)/3
		self.flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
	}
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return images.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        cell.imageView.image = images[indexPath.row]
		return cell
	}
	    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "singlePhoto" {
            let sp = segue.destinationViewController as! SinglePhotoViewController
            let imageIndex = self.collectionView.indexPathsForSelectedItems()!.first!.row
            sp.photoImage = self.images[imageIndex]
            sp.transitioningDelegate = self
        }
    }
}

extension PhotoCollectionViewController:RMPZoomTransitionAnimating,RMPZoomTransitionDelegate,UIViewControllerTransitioningDelegate {
    
    //MARK: -RMPZoomTransitionAnimating
    
    func transitionSourceImageView() -> UIImageView {
        guard let selectedIndexPath = self.collectionView.indexPathsForSelectedItems()?.first else {
            return UIImageView()
        }
        
        let cell = self.collectionView.cellForItemAtIndexPath(selectedIndexPath) as! PhotoCollectionViewCell
        let imageView = UIImageView(image: cell.imageView.image!)
        imageView.contentMode = cell.imageView.contentMode;
        imageView.clipsToBounds = true;
        imageView.userInteractionEnabled = false;
        imageView.frame = cell.imageView.convertRect(cell.imageView.frame, toView: self.collectionView.superview)
        return imageView;
    }
    
    func transitionSourceBackgroundColor() -> UIColor! {
        return UIColor.clearColor()
    }
    

    func transitionDestinationImageViewFrame() -> CGRect {
        let selectedIndexPath: NSIndexPath = self.collectionView.indexPathsForSelectedItems()!.first!
        let cell: PhotoCollectionViewCell = (self.collectionView.cellForItemAtIndexPath(selectedIndexPath) as! PhotoCollectionViewCell)
        let cellFrameInSuperview: CGRect = cell.imageView.convertRect(cell.imageView.frame, toView: self.view.superview)
        return cellFrameInSuperview
    }
    
    //MARK: -UIViewControllerTransitioningDelegate
    
    
    func animationControllerForPresentedController(presented:UIViewController,
                                                   presentingController presenting:UIViewController,
        sourceController source:UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        if let sourceTransition = source as? protocol<RMPZoomTransitionAnimating,RMPZoomTransitionDelegate>,
            destinationTransition = presented as? protocol<RMPZoomTransitionAnimating,RMPZoomTransitionDelegate> {
            let animator = RMPZoomTransitionAnimator()
            animator.goingForward = true
            animator.sourceTransition = sourceTransition;
            animator.destinationTransition = destinationTransition;
            return animator
        }
        
        return nil
    }
    
    func animationControllerForDismissedController(dismissed:UIViewController) ->UIViewControllerAnimatedTransitioning?
    {
        if let sourceTransition = dismissed as? protocol<RMPZoomTransitionAnimating,RMPZoomTransitionDelegate> {
            let animator = RMPZoomTransitionAnimator()
            animator.goingForward = false
            animator.sourceTransition = sourceTransition;
            animator.destinationTransition = self;
            return animator
        }
        return nil
    }
    
    //MARK: - <RMPZoomTransitionDelegate>
    
    func zoomTransitionAnimator(animator:RMPZoomTransitionAnimator,
                                didCompleteTransition didComplete:Bool,
                                                      animatingSourceImageView imageView:UIImageView)
    {
        
    }
}

