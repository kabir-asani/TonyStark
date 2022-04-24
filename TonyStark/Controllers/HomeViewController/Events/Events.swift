//
//  TXHomeViewTabSwitchEvent.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 23/04/22.
//

class HomeViewTabSwitchEvent: TXEvent {
    let tab: HomeViewController.TabItem
    
    init(tab: HomeViewController.TabItem) {
        self.tab = tab
    }
}
