import UIKit

class SearchResultsViewController: UITableViewController {
    
    var movies = [Movie]() {
        didSet {
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = LocalizedString(key: "movies.title")
        
        tableView.dm_registerClassWithDefaultIdentifier(cellClass: MovieCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    @objc func textSizeChanged() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension SearchResultsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MovieCell = tableView.dm_dequeueReusableCellWithDefaultIdentifier() else {
            return UITableViewCell()
        }
        
        let movie = movies[indexPath.row]
        cell.configure(movie)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let viewController = MovieDetailsViewController(movie: movie)
        self.presentingViewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
