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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return images.count
	}
	
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! PhotoCollectionViewCell
        cell.imageView.image = images[indexPath.row]
		return cell
	}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let sp = segue.destination as? SinglePhotoViewController,
            let imageIndex = self.collectionView.indexPathsForSelectedItems?.first?.row,
            segue.identifier == "singlePhoto" {
            sp.photoImage = self.images[imageIndex]
            sp.transitioningDelegate = self
        }
    }
}

extension PhotoCollectionViewController:RMPZoomTransitionAnimating,RMPZoomTransitionDelegate,UIViewControllerTransitioningDelegate {
    
    //MARK: -RMPZoomTransitionAnimating
    
    func transitionSourceImageView() -> UIImageView {
        guard let selectedIndexPath = self.collectionView.indexPathsForSelectedItems?.first else {
            return UIImageView()
        }
        
        let cell = self.collectionView.cellForItem(at: selectedIndexPath) as! PhotoCollectionViewCell
        let imageView = UIImageView(image: cell.imageView.image!)
        imageView.contentMode = cell.imageView.contentMode
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        imageView.frame = cell.imageView.convert(cell.imageView.frame, to: self.collectionView.superview)
        return imageView;
    }
    
    func transitionSourceBackgroundColor() -> UIColor! {
        return UIColor.clear
    }
    

    func transitionDestinationImageViewFrame() -> CGRect {
        guard let selectedIndexPath = self.collectionView.indexPathsForSelectedItems?.first,
            let cell = (self.collectionView.cellForItem(at: selectedIndexPath) as? PhotoCollectionViewCell) else {
            return CGRect.zero
        }
        let cellFrameInSuperview = cell.imageView.convert(cell.imageView.frame, to: self.view.superview)
        return cellFrameInSuperview
    }
    
    //MARK: -UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented:UIViewController,
                                                   presentingController presenting:UIViewController,
        sourceController source:UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        if let sourceTransition = source as? RMPZoomTransitionAnimating & RMPZoomTransitionDelegate,
            let destinationTransition = presented as? RMPZoomTransitionAnimating & RMPZoomTransitionDelegate {
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
        if let sourceTransition = dismissed as? RMPZoomTransitionAnimating & RMPZoomTransitionDelegate {
            let animator = RMPZoomTransitionAnimator()
            animator.goingForward = false
            animator.sourceTransition = sourceTransition;
            animator.destinationTransition = self;
            return animator
        }
        return nil
    }
    
    //MARK: - <RMPZoomTransitionDelegate>
    
    func zoomTransitionAnimator(_ animator:RMPZoomTransitionAnimator,
                                didCompleteTransition didComplete:Bool,
                                                      animatingSourceImageView imageView:UIImageView)
    {
        
    }
}

