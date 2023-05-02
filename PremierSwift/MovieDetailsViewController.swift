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
    
    private var similarMovies : Page<Movie>? {
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
    public override var childForStatusBarHidden: UIViewController? {
        return children.first
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
        self.movieDisplayView?.backdropImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                        action:
                                                                        #selector(self.handleTapImageView)))
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
        APIManager.shared.execute(Movie.similarMovies(for: self.movie.id)) { [weak self] result in
            guard let self = self else { return }
            if case .success(var page) = result {
                PSDispatchOnMainThread {
                    page.results =  page.results.filter{$0.posterPath != nil && $0.title != "" }
                    self.similarMovies = page
                    self.similarMovies?.id = self.movie.id
                }
            }
        }
    }
}

// MARK: - Button Actions

extension MovieDetailsViewController {
    
    @objc fileprivate func handleTapImageView() {
        guard let image = self.movieDisplayView?.backdropImageView.image  else {return}
        self.show(image: image, from: self.movieDisplayView?.backdropImageView)
    }
    
    @objc fileprivate func didTapViewAllSimilarMovies() {
        guard let similar = self.similarMovies, similar.results.count > 0 else {
            self.showError(LocalizedString(key: "moviedetails.load.error.body"))
            return
        }
        let viewController = MoviesViewController(similar: similar)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension MovieDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.similarMovies?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: SimilarMovieCell = collectionView.dm_dequeueReusableCellWithDefaultIdentifier(for: indexPath) else {
            return UICollectionViewCell()
        }
        if let movie = similarMovies?.results[indexPath.row] {
            cell.configure(movie)
        }
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension MovieDetailsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movie = similarMovies?.results[indexPath.row] {
            let viewController = MovieDetailsViewController(movie: movie)
            self.navigationController?.pushViewController(viewController, animated: true)
        }

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
