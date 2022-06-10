//
//  EditBioViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 01/05/22.
//

import UIKit

protocol EditBioViewControllerInteractionsHandler: AnyObject {
    func editBioViewController(
        _ controller: EditBioViewController,
        didUpdateBio bio: String
    )
}

class EditBioViewController: TXViewController {
    // Declare
    enum EditBioTableViewSection: Int, CaseIterable {
        case bio
    }
    
    weak var interactionsHandler: EditBioViewControllerInteractionsHandler?
    
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
        
        tableView.appendSpacerOnHeader()
        tableView.keyboardDismissMode = .onDrag
        
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
        
        if bio.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    // Interact
    @objc private func onDonePressed(_ sender: TXBarButtonItem) {
        interactionsHandler?.editBioViewController(
            self,
            didUpdateBio: bio
        )
    }
}

// MARK: TXTableViewDataSource
extension EditBioViewController: TXTableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        EditBioTableViewSection.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        1
    }
    
    func tableView(
        _ tableView: UITableView,
        titleForFooterInSection section: Int
    ) -> String? {
        switch section {
        case EditBioTableViewSection.bio.rawValue:
            return "Bio is a description of yourself"
        default:
            return nil
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
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
        TXTableView.automaticDimension
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
            at: IndexPath(
                row: 0,
                section: EditBioTableViewSection.bio.rawValue
            ),
            at: .bottom,
            animated: true
        )
    }
}
