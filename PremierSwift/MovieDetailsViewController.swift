import UIKit

final class MovieDetailsViewController: UIViewController {
    
    let movie: Movie
    private var movieDetails: MovieDetails?
    
    private var movieDisplayView : MovieDetailsDisplayView? {
        return self.view as? MovieDetailsDisplayView
    }
    
    private var similarCollectionView : UICollectionView? {
        return self.movieDisplayView?.similarCollectionView
    }
    
    private var similarMovies = [Movie]() {
        didSet {
            similarCollectionView?.reloadSections(IndexSet(integer: 0))
        }
    }

    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = MovieDetailsDisplayView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUI()
        setupSimilarCollectionView()
        
        fetchMovieDetails()
        fetchSimilarMovies()
    }
    
    private func loadUI() {
        title = movie.title
        navigationItem.leftBarButtonItem = UIBarButtonItem.backButton(target: self, action: #selector(didTapNavigationBack(_:)))
        self.movieDisplayView?.similarHeaderViewAllButton.addTarget(self, action: #selector(didTapViewAllSimilarMovies), for: .touchUpInside)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    /**
              Setting `CollectionView` for similar movies  list
     */
    private func setupSimilarCollectionView() {
        self.similarCollectionView?.dm_registerClassWithDefaultIdentifier(cellClass: SimilarMovieCell.self)
        self.similarCollectionView?.dataSource = self
        self.similarCollectionView?.delegate = self
    }
}


// MARK: - API's

extension MovieDetailsViewController {
    /**
     Fetching Movie Details
     */
    @objc fileprivate func fetchMovieDetails() {
        self.view.showLoader()
        APIManager.shared.execute(MovieDetails.details(for: movie)) { [weak self] result in
            guard let self = self else { return }
            PSDispatchOnMainThread {
                self.view.hideLoader()
            }
            switch result {
            case .success(let movieDetails):
                PSDispatchOnMainThread {
                    self.movieDisplayView?.configure(movieDetails: movieDetails)
                }
            case .failure:
                PSDispatchOnMainThread  {
                    self.showError(LocalizedString(key: "moviedetails.load.error.body"))
                }
            }
        }
    }
    /**
     Fetching Similar Movies
     */
    @objc private func fetchSimilarMovies() {
        APIManager.shared.execute(Movie.similarMovies(for: self.movie)) { [weak self] result in
            guard let self = self else { return }
            if case .success(let page) = result {
                PSDispatchOnMainThread {
                    self.similarMovies = page.results.filter{$0.posterPath != nil && $0.title != "" }
                }
            }
        }
    }
}

// MARK: - Button Actions

extension MovieDetailsViewController {
    @objc fileprivate func didTapViewAllSimilarMovies() {
        guard self.similarMovies.count > 0 else {
            self.showError(LocalizedString(key: "moviedetails.load.error.body"))
            return
        }
        let viewController = MoviesViewController(similar: self.similarMovies)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension MovieDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.similarMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: SimilarMovieCell = collectionView.dm_dequeueReusableCellWithDefaultIdentifier(for: indexPath) else {
            return UICollectionViewCell()
        }
        let movie = similarMovies[indexPath.row]
        cell.configure(movie)
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension MovieDetailsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = similarMovies[indexPath.row]
        let viewController = MovieDetailsViewController(movie: movie)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return SimilarMovieCell.contentSize
   }
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return SimilarMovieCell.edgeInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return SimilarMovieCell.columnSpacing
    }
    
}
