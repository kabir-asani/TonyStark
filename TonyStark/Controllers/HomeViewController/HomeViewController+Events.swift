//
//  HomeViewController+Events.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 08/06/22.
//

import Foundation

class HomeTabSwitchEvent: TXEvent {
    let tab: HomeViewController.TabItem
    
    init(tab: HomeViewController.TabItem) {
        self.tab = tab
    }
}
