import UIKit

enum MoviesListViewType {
    case top
    case similar
}

final class MoviesViewController: UITableViewController {
    
    private var movies = [Movie]() {
        didSet {
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
    
    private let pageType : MoviesListViewType
    
    init(pageType: MoviesListViewType) {
        self.pageType = pageType
        super.init(nibName: nil, bundle: nil)

    }
    
    convenience init (similar: [Movie]) {
        self.init(pageType: .similar)
        self.movies = similar

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        setupTableView()

        NotificationCenter.default.addObserver(self, selector: #selector(textSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
        if self.pageType == .top {
            Genres.fetchGenres() //Fetching geres strings
            fetchTopMovies()
        }
        
    }
    private func loadUI() {
        if pageType == .top {
            title = LocalizedString(key: "movies.title")
        }else {
            title = LocalizedString(key: "movies.similar.title")
            navigationItem.largeTitleDisplayMode = .never
            navigationItem.leftBarButtonItem = UIBarButtonItem.backButton(target: self, action: #selector(didTapNavigationBack(_:)))
            self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }
    }
    
    /**
              Setting `TableView` for movies list
     */
    private func setupTableView() {
        self.tableView.dm_registerClassWithDefaultIdentifier(cellClass: MovieCell.self)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.bounces = true
        self.tableView.alwaysBounceVertical = true

        if self.pageType == .top {
            self.refreshControl = UIRefreshControl()
            self.refreshControl?.addTarget(self, action: #selector(fetchTopMovies), for: .valueChanged)
        }

    }
    
    @objc func textSizeChanged() {
        tableView.reloadData()
    }
}

// MARK: - API's

extension MoviesViewController {
    
    /**
     Fetching Top Movies
     */
    @objc func fetchTopMovies() {
        APIManager.shared.execute(Movie.topRated) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let page):
                PSDispatchOnMainThread {
                    self.refreshControl?.endRefreshing()
                    self.movies = page.results
                }
            case .failure:
                PSDispatchOnMainThread {
                    self.refreshControl?.endRefreshing()
                    self.showError(LocalizedString(key: "movies.load.error.body"))
                }
            }
        }
    }
    
}

// MARK: - UITableViewDataSource
extension MoviesViewController {
    
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
    
}

// MARK: - UITableViewControllerDelegate
extension MoviesViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let viewController = MovieDetailsViewController(movie: movie)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}


