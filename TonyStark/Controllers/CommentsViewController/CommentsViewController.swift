//
//  CommentsViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import UIKit

class CommentsViewController: TXViewController {
    // Declare
    private var state: Result<Paginated<Comment>, CommentsFailure> = .success(.empty())
    
    private let tableView: TXTableView = {
        let tableView = TXTableView()
        
        tableView.enableAutolayout()
        
        return tableView
    }()
    
    private let commentInputBar: CommentInputBar = {
        let commentInputBar = CommentInputBar()
        
        commentInputBar.enableAutolayout()
        
        return commentInputBar
    }()
    
    private let separator: TXView = {
        let separator = TXView()
        
        separator.enableAutolayout()
        separator.backgroundColor = .separator
        
        return separator
    }()
    
    private let bottomInputBar: TXView = {
        let bottomBar = TXView()
        
        bottomBar.enableAutolayout()
        bottomBar.backgroundColor = .systemBackground
        
        return bottomBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        
        configureNavigationBar()
        configureTableView()
        configureCommentInputBar()
        configureSeparator()
        configureBottomInputBar()
        
        populateTableViewWithComments()
    }
    
    // Arrange
    private func addSubviews() {
        bottomInputBar.addSubview(commentInputBar)
        
        view.addSubview(tableView)
        view.addSubview(separator)
        view.addSubview(bottomInputBar)
    }
    
    // Configure
    private func configureNavigationBar() {
        navigationItem.title = "Comments"
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationController?.navigationBar.barTintColor = .systemBackground
    
        navigationItem.leftBarButtonItem = TXBarButtonItem(
            image: UIImage(systemName: "multiply"),
            style: .plain,
            target: self,
            action: #selector(onClosePressed(_:))
        )
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(
            CommentTableViewCell.self,
            forCellReuseIdentifier: CommentTableViewCell.reuseIdentifer
        )
        
        tableView.keyboardDismissMode = .onDrag
        
        tableView.pin(toTopOf: view, byBeingSafeAreaAware: true)
        tableView.pin(toLeftOf: view, byBeingSafeAreaAware: true)
        tableView.pin(toRightOf: view, byBeingSafeAreaAware: true)
        tableView.attach(bottomToTopOf: separator, byBeingSafeAreaAware: true)
    }
    
    private func configureCommentInputBar() {
        commentInputBar.configure(
            withData: (
                inputPlaceholder: "Enter a comment ...",
                buttonText: "Send"
            )
        ) { text in
        }
        
        commentInputBar.pin(
            to: bottomInputBar,
            withInsets: TXEdgeInsets(
                top: 0,
                right: 16,
                bottom: 0,
                left: 16
            )
        )
    }
    
    private func configureSeparator() {
        separator.fixHeight(to: 0.5)
        
        separator.pin(toRightOf: view, byBeingSafeAreaAware: true)
        separator.pin(toLeftOf: view, byBeingSafeAreaAware: true)
        separator.attach(bottomToTopOf: bottomInputBar, byBeingSafeAreaAware: true)
    }
    
    private func configureBottomInputBar() {
        bottomInputBar.fixHeight(to: 60)
        bottomInputBar.pin(toRightOf: view, byBeingSafeAreaAware: true)
        bottomInputBar.pin(toLeftOf: view, byBeingSafeAreaAware: true)
        bottomInputBar.pin(
            toBottomOf: view,
            byBeingSafeAreaAware: true
        )
    }
    
    // Interact
    @objc private func onClosePressed(_ sender: TXBarButtonItem) {
        dismiss(animated: true)
    }
}

// MARK: UITableViewDataSource
extension CommentsViewController: TXTableViewDataSource {
    private func populateTableViewWithComments() {
        tableView.showActivityIndicatorAtTheBottomOfTableView()
        
        Task {
            [weak self] in
            let result = await CommentsProvider.shared.comments()
            
            self?.tableView.hideActivityIndicatorAtTheBottomOfTableView()
            
            self?.state = result
            self?.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch state {
        case .success(_):
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .success(let paginate):
            return paginate.page.count
        default:
            return 0
        }
    }
}

// MARK: UITableViewDelegate
extension CommentsViewController: TXTableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state {
        case .success(let paginate):
            let cell = tableView.dequeueReusableCellWithIndexPath(
                withIdentifier: CommentTableViewCell.reuseIdentifer,
                for: indexPath
            ) as! CommentTableViewCell
            
            cell.interactionsHandler = self
            cell.configure(withComment: paginate.page[indexPath.row])
            
            return cell
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: CommentTableViewCellInteractionsHandler
extension CommentsViewController: CommentTableViewCellInteractionsHandler {
    func didPressProfileImage(_ commentTableViewCell: CommentTableViewCell) {
        print(#function)
    }
}
