//
//  CommentsViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import UIKit

class CommentsViewController: TXTableViewController {
    private var state: Result<Paginated<Comment>, CommentsFailure> = .success(.empty())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        
        populateTableViewWithComments()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Comments"
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.isTranslucent = true
    
        navigationItem.leftBarButtonItem = TXBarButtonItem(
            image: UIImage(systemName: "multiply"),
            style: .plain,
            target: self,
            action: #selector(onClosePressed(_:))
        )
    }
    
    private func configureTableView() {
        tableView.register(
            CommentTableViewCell.self,
            forCellReuseIdentifier: CommentTableViewCell.reuseIdentifer
        )
    }
    
    @objc private func onClosePressed(_ sender: TXBarButtonItem) {
        dismiss(animated: true)
    }
}

// MARK: UITableViewDataSource
extension CommentsViewController {
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        switch state {
        case .success(_):
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .success(let paginate):
            return paginate.page.count
        default:
            return 0
        }
    }
}

// MARK: UITableViewDelegate
extension CommentsViewController {
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state {
        case .success(let paginate):
            let cell = tableView.dequeueReusableCellWithIndexPath(
                withIdentifier: CommentTableViewCell.reuseIdentifer,
                for: indexPath
            ) as! CommentTableViewCell
            
            cell.configure(withComment: paginate.page[indexPath.row])
            
            return cell
        default:
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
