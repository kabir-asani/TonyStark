//
//  CommentsViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import UIKit

class CommentsViewController: TXViewController {
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
    
    private let bottomInputBar: TXVisualEffectView = {
        let bottomBar = TXVisualEffectView()
        
        bottomBar.enableAutolayout()
        bottomBar.effect = UIBlurEffect(style: .systemChromeMaterial)
        
        return bottomBar
    }()
    
    private let bottomSafeAreaChin: UIVisualEffectView = {
        let bottomSafeAreaChin = UIVisualEffectView()
        
        bottomSafeAreaChin.enableAutolayout()
        bottomSafeAreaChin.effect = UIBlurEffect(style: .systemChromeMaterial)
        
        return bottomSafeAreaChin
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        
        configureNavigationBar()
        configureTableView()
        configureCommentInputBar()
        configureBottomInputBar()
        configureBottomSafeAreaChin()
        
        populateTableViewWithComments()
    }
    
    private func addSubviews() {
        bottomInputBar.contentView.addSubview(commentInputBar)
        
        view.addSubview(tableView)
        view.addSubview(bottomInputBar)
        view.addSubview(bottomSafeAreaChin)
    }
    
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
        
        tableView.pin(toTopOf: view)
        tableView.pin(toLeftOf: view)
        tableView.pin(toRightOf: view)
        tableView.attach(bottomToTopOf: bottomInputBar)
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
    
    private func configureBottomInputBar() {
        bottomInputBar.fixHeight(to: 60)
        bottomInputBar.pin(toRightOf: view)
        bottomInputBar.pin(toLeftOf: view)
        bottomInputBar.pin(
            toBottomOf: view,
            byBeingSafeAreaAware: true
        )
    }
    
    private func configureBottomSafeAreaChin() {
        bottomSafeAreaChin.attach(topToBottomOf: bottomInputBar)
        bottomSafeAreaChin.pin(toRightOf: view)
        bottomSafeAreaChin.pin(toLeftOf: view)
        bottomSafeAreaChin.pin(toBottomOf: view)
    }
    
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

extension CommentsViewController: CommentTableViewCellInteractionsHandler {
    func didPressProfileImage(_ commentTableViewCell: CommentTableViewCell) {
        print(#function)
    }
}
