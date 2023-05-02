import UIKit

enum MoviesListViewType {
    case top
    case similar
}

final class MoviesViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    private var movies : Page<Movie>?

    private let pageType : MoviesListViewType
    
    init(pageType: MoviesListViewType) {
        self.pageType = pageType
        super.init(nibName: nil, bundle: nil)

    }
    
    convenience init (similar: Page<Movie>) {
        self.init(pageType: .similar)
        self.movies = similar

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var searchResultsController : SearchResultsViewController? {
        self.searchViewController.searchResultsController as? SearchResultsViewController
    }

    lazy var searchViewController : UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchResultsUpdater = self
        return controller
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUI()
        setupTableView()
        
        if self.pageType == .top {
            configureSearchBar()
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
    
    private func configureSearchBar() {
    
        navigationItem.searchController = searchViewController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        let searchTextField = searchViewController.searchBar.searchTextField
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [.font: UIFont.Body.medium, .foregroundColor: UIColor.Text.charcoal])
        searchTextField.font = UIFont(name: "Poppins-Regular", size: 16)
        searchTextField.backgroundColor = UIColor.Background.whiteSmoke
        searchTextField.borderStyle = .none
        searchTextField.layer.borderColor = UIColor.black.withAlphaComponent(0.08).cgColor
        searchTextField.layer.borderWidth = 1.0
        searchTextField.layer.cornerRadius = 8
        
        searchViewController.searchBar.setLeftImage(UIImage(named: "Search"))
        searchViewController.searchBar.barTintColor = .clear
        searchViewController.searchBar.setImage(UIImage(named: "Filter"), for: .bookmark, state: .normal)
        searchViewController.searchBar.showsBookmarkButton = true
        searchViewController.searchBar.delegate = self
        searchViewController.searchBar.tintColor = UIColor.Brand.popsicle40
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
                    self.movies = page
                    self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                }
            case .failure:
                PSDispatchOnMainThread {
                    self.refreshControl?.endRefreshing()
                    self.showError(LocalizedString(key: "movies.load.error.body"))
                }
            }
        }
    }
    
   func loadMore() {
       guard let dataSource = self.movies, dataSource.canPagignate else {
           return
        }
        self.tableView.tableFooterView = self.view.getFooterViewSpinner()
        self.movies!.isPagigNating = true
        var request = Movie.topRated
        if let movieId = dataSource.id, self.pageType == .similar {
            request = Movie.similarMovies(for: movieId)
        }
       request.queryParams["page"] = dataSource.pageNumber + 1
        APIManager.shared.execute(request) {[weak self]  result in
          guard let self = self else {return}
          if case .success(let page) = result {
                PSDispatchOnMainThread {
                    self.movies!.pageNumber = page.pageNumber
                    self.movies!.totalPages = page.totalPages
                    self.movies!.totalResults = page.totalResults
                    self.reloadData(page.results)
                }
            }

        }
    }
    
    func reloadData(_ movies:[Movie]) {
        guard self.movies != nil else {return}
        let oldSize = self.movies!.results.count
        let newSize = oldSize + movies.count
        var indexPaths = [IndexPath]()
        for row in 0..<(newSize - oldSize) {
            let indexPath = IndexPath(row: row + oldSize, section: 0)
            indexPaths.append(indexPath)
        }
        tableView.beginUpdates()
        self.movies!.results.append(contentsOf: movies)
        tableView.insertRows(at: indexPaths, with: .automatic)
        tableView.endUpdates()
        self.movies!.isPagigNating = false
        self.tableView.tableFooterView = nil
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else {return}
        let request = Request<Page<Movie>>(method: Method.get, path: "/search/movie", params: ["query": query])
        APIManager.shared.execute(request, completion: { [weak self] result in
            if case .success(let page) = result {
                PSDispatchOnMainThread {
                    self?.searchResultsController?.movies = page.results
                }
            }
        })
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
        if scrollView.contentOffset.y > (tableView.contentSize.height  - scrollView.frame.size.height) && self.movies?.canPagignate == true && self.movies?.isPagigNating == false {
            self.loadMore()
        }
        
        
    }
}

// MARK: - UITableViewDataSource
extension MoviesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.results.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MovieCell = tableView.dm_dequeueReusableCellWithDefaultIdentifier(for: indexPath) else {
            return UITableViewCell()
        }
        
        if let movie = movies?.results[indexPath.row] {
            cell.configure(movie)
        }

        
        return cell
    }
    
}

// MARK: - UITableViewControllerDelegate
extension MoviesViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movie = movies?.results[indexPath.row] {
            let viewController = MovieDetailsViewController(movie: movie)
            self.navigationController?.pushViewController(viewController, animated: true)
        }

    }
}


