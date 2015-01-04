//
//  BubbleSorter.swift
//  satisfaction
//
//  Created by Jason A Smith on 1/3/15.
//  Copyright (c) 2015 Jason A. Smith. All rights reserved.
//

import Foundation

/// A class responsible for sorting a list. Any time a swap is made, a callback
/// is called. When the sorting finishes, a callback is called.
///
/// The client is responsible for calling BubbleSorter::sort() on the object
/// to begin, and is responsible for calling BubbleSorter::next() on the object
/// in the modelChangeCallback.
///
/// Reference: http://en.wikipedia.org/wiki/Bubble_sort
///
class BubbleSorter<T: Comparable> {
    /// The list to be sorted
    var list: [T]
    
    /// MARK: Client callbacks
    
    /// Called when a swap is made
    var modelChangeCallback: (BubbleSorter, [Int]) -> ()
    
    /// Called when the sort is finished
    var completionCallback: () -> ()
    
    /// MARK: Variables for keeping track of the bubble sort state machine
    
    private var n: Int = 0
    private var newN: Int = 0
    private var resetN = true
    
    /// MARK: Initialization
    
    init(list: [T], modelChangeCallback: (BubbleSorter, [Int]) -> (), completionCallback: () -> ()) {
        self.list = list
        
        self.modelChangeCallback = modelChangeCallback
        self.completionCallback = completionCallback
        
        self.n = self.list.count
    }
    
    /// MARK: Start and advancement of the sorting state machine
    
    func sort() {
        next()
    }
    
    func next() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self._next()
        }
    }
    
    private func _next() {
        // this method is synchronized in case the modelChangeCallback makes
        // another call to next()
        objc_sync_enter(self)
        
        if n <= 0 {
            dispatch_async(dispatch_get_main_queue(), {
                self.completionCallback()
            })
            return
        }
        
        outerWhile: do {
            if resetN {
                newN = 0
                resetN = false
            }
            
            for i in 1..<n {
                if list[i - 1] > list[i] {
                    let tmp = list[i - 1]
                    list[i - 1] = list[i]
                    list[i] = tmp
                    
                    newN = i
                    resetN = true
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.modelChangeCallback(self, [i - 1, i])
                    })
                    break outerWhile
                }
            }
            
            n = newN
        } while n > 0
        
        if n <= 0 {
            dispatch_async(dispatch_get_main_queue(), {
                self.completionCallback()
            })
        }
        
        objc_sync_exit(self)
    }
    
}
