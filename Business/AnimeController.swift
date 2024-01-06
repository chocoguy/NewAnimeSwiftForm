//
//  AnimeController.swift
//  NewAnimeSwiftForm
//
//  Created by Edgar Zarco on 1/2/24.
//

import Foundation

struct AnimeController {
    enum NetworkError: Error {
        case badURL, badResponse, badData
    }
    
    private let baseURL = URL(string: "http://localhost:5074/MAL/Anime/")
    
    func getAnimeById(MalId: Int) async throws -> MALAnime{
        
        
        let completeURL = URL(string: "\(baseURL!)\(MalId)")
        let (data, response) = try await URLSession.shared.data(from: completeURL!)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        let retMalAnime = try JSONDecoder().decode(MALAnime.self, from: data)
        
        print("Got \(retMalAnime.title)")
        
        return retMalAnime
    }
    
    func searchAnime(query: String) async throws -> MALAnimeSearch{
        var request = URLRequest(url: URL(string: "http://localhost:5074/MAL/AnimeSearch")!)
        request.httpMethod = "POST"
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        
        if let data = query.data(using: .utf8) {
            request.httpBody = data
        } else{
            print("Cannot utf8")
        }
                
        let (data, response) = try await URLSession.shared.data(for: request)
        
//        let (data, response) = try await URLSession.shared.data(from: URL(string: "http://localhost:5074/MAL/AnimeSearch")!)
//        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        let retAnimeSearch = try JSONDecoder().decode(MALAnimeSearch.self, from: data)
        return retAnimeSearch
        
    }
    
    func searchAnimeTwo(){
        // Your raw text data
        let rawText = "Hello, this is raw text data."

        // URL of the API endpoint
        let url = URL(string: "https://example.com/api/endpoint")!

        // Create a URLRequest
        var request = URLRequest(url: url)

        // Set the HTTP method (e.g., POST, GET)
        request.httpMethod = "POST"

        // Set the content type of the request
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")

        // Convert the raw text data to Data
        if let data = rawText.data(using: .utf8) {
            // Set the HTTP body with the raw text data
            request.httpBody = data
        } else {
            print("Error converting text to data")
        }

        // Perform the request using URLSession
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                // Handle the response data
                print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
            }
        }

        // Start the task
        task.resume()
    }
    
}
