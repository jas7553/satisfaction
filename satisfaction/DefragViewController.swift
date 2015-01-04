//
//  DefragViewController.swift
//  satisfaction
//
//  Created by Jason A Smith on 1/3/15.
//  Copyright (c) 2015 Jason A. Smith. All rights reserved.
//

import UIKit

class DefragViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var defragButton: UIButton!
    
    // MARK: Cell colors
    private let redColor = UIColor(red: 0.8902, green: 0.2549, blue: 0.2667, alpha: 1)
    private let greenColor = UIColor(red: 0.2431, green: 0.7882, blue: 0.3216, alpha: 1)
    private let blueColor = UIColor(red: 0.2863, green: 0.4627, blue: 0.8863, alpha: 1)
    
    // MARK: Cell properties
    private let cellCount = 7 * 11
    private let cellSize: CGFloat = 45
    
    // MARK: Model
    private var model: BubbleSorter<Int>?
    
    private func modelChangeCallback(sorter: BubbleSorter<Int>, updatedIndexes: [Int]) {
        var indexPaths: [NSIndexPath] = []
        for index in updatedIndexes {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            indexPaths.append(indexPath)
        }
        collectionView.reloadItemsAtIndexPaths(indexPaths)
        
        sorter.next()
    }
    
    private func completionCallback() {
        defragButton.setTitle("Done", forState: .Normal)
        defragButton.enabled = true
    }
    
    // MARK: Initializer
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initializeModel()
    }
    
    private func initializeModel() {
        var cellTypes: [Int] = listOfTypes(3, length: cellCount)
        
        model = BubbleSorter(list: cellTypes,
            modelChangeCallback: modelChangeCallback,
            completionCallback: completionCallback)
    }
    
    private func listOfTypes(typeCount: Int, length: Int) -> [Int]{
        var cellTypes: [Int] = []
        for _ in 0..<length {
            let randomCellType = Int(arc4random_uniform(UInt32(typeCount)))
            cellTypes.append(randomCellType)
        }
        return cellTypes
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.contentInset = UIEdgeInsets(top:10, left: 0, bottom: 10, right: 0)
        
        collectionView.userInteractionEnabled = false
    }
    
    // MARK: IBAction
    
    @IBAction func defrag(sender: AnyObject) {
        if (model?.isSorted == true) {
            initializeModel()
            collectionView.reloadItemsAtIndexPaths(collectionView.indexPathsForVisibleItems())
            
            defragButton.setTitle("Defrag", forState: .Normal)
            defragButton.enabled = true
        }
        else {
            defragButton.enabled = false
            defragButton.setTitle("Defragging...", forState: .Disabled)
            
            model!.sort()
        }
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
        
        switch model!.list[indexPath.row] {
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
        return CGSizeMake(cellSize, cellSize)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 4
    }
    
}
