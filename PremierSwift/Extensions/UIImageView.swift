import UIKit

extension UIImageView {
    
    func dm_setImage(posterPath: String) {
        guard let imageURL = URL(string: "https://image.tmdb.org/t/p/w185/\(posterPath)") else {return}
        MediaCache.getImage(imageURL: imageURL) { image in
            self.image = image
        }
    }
    
    func dm_setImage(backdropPath: String) {
        guard let imageURL = URL(string: "https://image.tmdb.org/t/p/w1280/\(backdropPath)") else {return}
        MediaCache.getImage(imageURL: imageURL) { image in
            self.image = image
        }
    }
    
}
