//
//  DefragViewController.swift
//  satisfaction
//
//  Created by Jason A Smith on 1/3/15.
//  Copyright (c) 2015 Jason A. Smith. All rights reserved.
//

import UIKit

class DefragViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let redColor = UIColor(red: 0.8902, green: 0.2549, blue: 0.2667, alpha: 1)
    private let greenColor = UIColor(red: 0.2431, green: 0.7882, blue: 0.3216, alpha: 1)
    private let blueColor = UIColor(red: 0.2863, green: 0.4627, blue: 0.8863, alpha: 1)
    
    private let cellCount = 25 * 30;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.contentInset = UIEdgeInsets(top:10, left: 10, bottom: 10, right: 10)
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DefragCell", forIndexPath: indexPath) as UICollectionViewCell
        
        switch Int(arc4random_uniform(3)) {
        case 0:
            cell.backgroundColor = blueColor
        case 1:
            cell.backgroundColor = greenColor
        default:
            cell.backgroundColor = redColor
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(10, 10)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 4
    }
    
}
