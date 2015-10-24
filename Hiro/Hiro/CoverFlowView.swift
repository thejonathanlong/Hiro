//
//  CoverFlowView.swift
//  Hiro
//
//  Created by Jonathan Long on 9/25/15.
//  Copyright © 2015 Apple. All rights reserved.
//

//import UIKit
//protocol CoverFlowViewDelegate {
//    func coverFlowView(coverFlowView: UIView, didSelectItemAtIndexPath indexPath: NSIndexPath)
//}
//
//protocol CoverFlowViewDataSource {
//    func coverFlowViewNumberOfItems(coverFlowView: CoverFlowView) -> Int
//    func coverFlowView(coverFlowView: CoverFlowView, cellForItemAtIndexPath indexPath: NSIndexPath) -> CoverFlowCell
//    func coverFlowViewSizeForCells(coverFlowView: CoverFlowView) -> CGSize
//    
//    
//}
//
//class CoverFlowView: UIScrollView {
//    var coverFlowDelegate : CoverFlowViewDelegate?
//    var coverFlowDatasource : CoverFlowViewDataSource?
//
//    private var coverFlowCellCache = [CoverFlowCell]()
//    private var numberOfCellsCreated : Int
//    private var totalNumberOfItems = 0
//    private var numberOnScreen = 0
//    
//    override init(frame: CGRect) {
//
//        numberOfCellsCreated = 0
//        super.init(frame: frame)
//        numberOnScreen = numberOfItemsThatFitOnScreen()
//        totalNumberOfItems = coverFlowDatasource!.coverFlowViewNumberOfItems(self)
//        for index in 0 ..< (numberOnScreen * 2){
//            if index < totalNumberOfItems{
//                let indexPath = NSIndexPath(forRow: index, inSection: 0)
//                let cell = coverFlowDatasource!.coverFlowView(self, cellForItemAtIndexPath: indexPath)
//                appropriatelyAddCell(cell, atIndexPath: indexPath)
//            }
//        }
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func numberOfItemsThatFitOnScreen() -> Int{
//        if let cellSize = self.coverFlowDatasource?.coverFlowViewSizeForCells(self){
//            return Int(ceil(cellSize.width / self.bounds.size.width))
//        }
//        assertionFailure("You should implement coverFlowViewSizeForCells")
//        return 0
//    }
//    
//    func dequeueReusableCellWithIdentifier(identifier : String) -> CoverFlowCell{
//        if coverFlowCellCache.count < (numberOnScreen * 2) {
//            let nibViews = NSBundle.mainBundle().loadNibNamed(identifier, owner: self, options: nil)
//            numberOfCellsCreated++
//            let cell = nibViews.first as! CoverFlowCell
//            
//            if numberOfCellsCreated >= Int(Double(numberOnScreen) * 1.5){
//                coverFlowCellCache.append(cell)
//            }
//            return cell
//        } else {
//            if let cell = coverFlowCellCache.first{
//                coverFlowCellCache.removeAtIndex(0)
//                return cell
//            }
//        }
//        assertionFailure("We did not create a new cell and we did not return a cached cell. Something went wrong.")
//        return CoverFlowCell()
//    }
//    
//    private func appropriatelyAddCell(cell : CoverFlowCell, atIndexPath indexPath : NSIndexPath){
//        
//    }
//}
