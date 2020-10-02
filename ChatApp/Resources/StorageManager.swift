//
//  StorageManager.swift
//  ChatApp
//
//  Created by Stanislav Starovoytov on 29.09.2020.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    
    public typealias UploadPictureComletion = (Result<String, Error>) -> Void
    
    ///upload picture to firebase storage and returns completion with url string to download
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureComletion ) {
        storage.child("images/\(fileName)").putData(data, metadata: nil) { (metadata, error) in
            guard error == nil else {
                //fail
                print("failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            self.storage.child("images/\(fileName)").downloadURL { (url, error) in
                guard let url = url else {
                    print("Failed to get download URL")
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
                
            }
            
        }
        
    }
    
    
    ///upload image that will be sent in a conversation
    public func uploadMessagePhoto(with data: Data, fileName: String, completion: @escaping UploadPictureComletion ) {
        storage.child("message_images/\(fileName)").putData(data, metadata: nil) { [weak self] (metadata, error) in
            guard error == nil else {
                //fail
                print("failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            self?.storage.child("message_images/\(fileName)").downloadURL { (url, error) in
                guard let url = url else {
                    print("Failed to get download URL")
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
                
            }
            
        }
        
    }
    
    ///upload video that will be sent in a conversation
    public func uploadMessageVideo(with fileUrl: URL, fileName: String, completion: @escaping UploadPictureComletion ) {
        guard let fileUrl = NSData(contentsOf: fileUrl) as Data? else {
            return
        }
        storage.child("message_videos/\(fileName)").putData(fileUrl, metadata: nil) { [weak self] (metadata, error) in
            guard error == nil else {
                //fail
                print("failed to upload video file to firebase")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            self?.storage.child("message_videos/\(fileName)").downloadURL { (url, error) in
                guard let url = url else {
                    print("Failed to get download URL")
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
                
            }
            
        }
        
    }
    
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadURL
    }
    
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
        reference.downloadURL { (url, error) in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadURL))
                return
            }
            
            completion(.success(url))
            
        }
    }
    
}
