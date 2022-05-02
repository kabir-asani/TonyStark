//
//  EditBioViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 01/05/22.
//

import UIKit

class EditBioViewController: TXViewController {
    // Declare
    private var bio: String!
    
    private let tableView: TXTableView = {
        let tableView = TXTableView(
            frame: .zero,
            style: .insetGrouped
        )
        
        tableView.enableAutolayout()
        
        return tableView
    }()
    
    // Configure
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        configureNavigationBar()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startKeyboardAwareness()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopKeyboardAwareness()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = TXBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(onDonePressed(_:))
        )
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.addBufferOnHeader(withHeight: 0)
        
        tableView.register(
            EditBioTableViewCell.self,
            forCellReuseIdentifier: EditBioTableViewCell.reuseIdentifier
        )
        
        tableView.pin(
            to: view,
            byBeingSafeAreaAware: true
        )
    }
    
    // Populate
    func populate(withBio bio: String) {
        self.bio = bio
        
        navigationItem.title = "Bio (\(120 - bio.count))"
    }
    
    // Interact
    @objc private func onDonePressed(_ sender: TXBarButtonItem) {
        print(#function)
    }
}

// MARK: TXTableViewDataSource
extension EditBioViewController: TXTableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 1
    }
    
    func tableView(
        _ tableView: UITableView,
        titleForFooterInSection section: Int
    ) -> String? {
        switch section {
        case 0:
            return "Bio is a description of yourself"
        default:
            return nil
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIndexPath(
            withIdentifier: EditBioTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! EditBioTableViewCell
        
        cell.delegate = self
        cell.configure(withText: bio)
        
        return cell
    }
}

// MARK: TXTextViewDelegate
extension EditBioViewController: TXTableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return TXTableView.automaticDimension
    }
}

// MARK: EditBioTableViewCellDelegate
extension EditBioViewController: EditBioTableViewCellDelegate {
    func cell(
        _ cell: EditBioTableViewCell,
        didChangeText text: String
    ) {
        populate(withBio: text)
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        tableView.scrollToRow(
            at: cell.indexPath,
            at: .bottom,
            animated: true
        )
    }
}
