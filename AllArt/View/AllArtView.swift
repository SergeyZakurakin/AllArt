//
//  ContentView.swift
//  AllArt
//
//  Created by Sergey Zakurakin on 12/22/24.
//

import SwiftUI

@MainActor
class AllArtViewModel: ObservableObject {
    
    @Published var artworks: [Datum] = []
    
    
    func fetchArtworks() {
        Task {
            let url = URL(string: "https://api.artic.edu/api/v1/artworks")!
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                let decoder = JSONDecoder()
                let artworksResult = try decoder.decode(Artwork.self, from: data)
                
                self.artworks = artworksResult.data!
                
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func getImageURL(imageId: String) -> URL? {
        let baseUrl = "https://www.artic.edu/iiif/2/"
        let imageSize = "full/843,/0/default.jpg"
        return URL(string: "\(baseUrl)\(imageId)/\(imageSize)")
//        return "\(baseUrl)\(imageId)/\(imageSize)"
    }
}

struct AllArtView: View {
    
    @StateObject private var viewModel = AllArtViewModel()
    
    
    var body: some View {
        ZStack {
            Color.indigo.opacity(0.5)
                .ignoresSafeArea()
            ScrollView() {
                ForEach(viewModel.artworks) { artwork in
                    AllArtCard(cardItem: artwork, imageURL: viewModel.getImageURL(imageId: artwork.image_id!))
                }
                
            }
            .onAppear {
                viewModel.fetchArtworks()
            }
            .padding()
        }
    }
}

#Preview {
    AllArtView()
}


struct AllArtCard: View {
    
    var cardItem: Datum
    var imageURL: URL?
    
    
    var body: some View {
        VStack(spacing: 20) {
            if let imageURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        
                } placeholder: {
                    ProgressView()
                }
                    Text(cardItem.title)
                        .foregroundStyle(.white)
                        .font(.headline)
                Spacer()
                
            }
        }
    
        .frame(width: 300, height: 300)
    }
}



struct Artwork: Decodable {
    let data: [Datum]?
}



struct Datum: Decodable, Identifiable {
    let id: Int
    let apiLink: String?
    let isBoosted: Bool?
    let title: String
    let mainReferenceNumber: String?
    let hasNotBeenViewedMuch: Bool?
    let boostRank: Int?
    let dateStart, dateEnd: Int?
    let dateDisplay: String?
    let dateQualifierID: Int?
    let artistDisplay, placeOfOrigin: String?
    let description, shortDescription: String?
    let dimensions: String?
    let mediumDisplay: String?
    let inscriptions: String?
    let creditLine: String?
    let catalogueDisplay, publicationHistory, exhibitionHistory, provenanceText: String?
    let internalDepartmentID: Int?
    let fiscalYear: Int?
    let isPublicDomain, isZoomable: Bool?
    let maxZoomWindowSize: Int?
    let copyrightNotice: String?
    let hasMultimediaResources, hasEducationalResources, hasAdvancedImaging: Bool?
    let colorfulness: Double?
    let latitude, longitude: Double?
    let latlon: String?
    let isOnView: Bool?
    let onLoanDisplay, galleryTitle: String?
    let galleryID: Int?
    let artworkTypeID: Int?
    let departmentTitle, departmentID: String?
    let artistID: Int?
    let artistTitle: String?
    let artistIDS: [Int]?
    let artistTitles, categoryIDS, categoryTitles, termTitles: [String]?
    let image_id: String?
}
