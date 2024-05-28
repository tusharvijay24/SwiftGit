//
//  CoreDataManager.swift
//  SwiftyGit
//
//  Created by Tushar on 28/05/24.
//

import Foundation
import CoreData
import UIKit
import SDWebImage

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    private var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func saveContext() {
        let context = self.context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func saveRepositories(_ repositories: [RepositoryListModel]) {
        let context = self.context
        clearRepositories() // Clear old data before saving new data

        for repo in repositories {
            let entity = NSEntityDescription.entity(forEntityName: "CDRepository", in: context)!
            let repoObject = NSManagedObject(entity: entity, insertInto: context)
            repoObject.setValue(repo.id, forKey: "id")
            repoObject.setValue(repo.name, forKey: "name")
            repoObject.setValue(repo.description, forKey: "repoDescription")
            repoObject.setValue(repo.html_url, forKey: "html_url")
            repoObject.setValue(repo.owner.avatar_url, forKey: "ownerAvatarUrl")
            repoObject.setValue(repo.owner.login, forKey: "ownerLogin")
            repoObject.setValue(repo.contributors_url, forKey: "contributorsUrl")
            
            // Fetch and save the image data using SDWebImage
            if let url = URL(string: repo.owner.avatar_url) {
                SDWebImageDownloader.shared.downloadImage(with: url, options: .highPriority, progress: nil) { image, data, error, finished in
                    if let imageData = data {
                        repoObject.setValue(imageData, forKey: "avatarImageData")
                        self.saveContext()
                    }
                }
            }
        }

        saveContext()
    }

    func fetchRepositories() -> [RepositoryListModel] {
        let context = self.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDRepository")

        do {
            let repoObjects = try context.fetch(fetchRequest)
            var repositories: [RepositoryListModel] = []

            for repoObject in repoObjects {
                let repository = RepositoryListModel(
                    id: repoObject.value(forKey: "id") as! Int,
                    name: repoObject.value(forKey: "name") as! String,
                    description: repoObject.value(forKey: "repoDescription") as? String,
                    html_url: repoObject.value(forKey: "html_url") as! String,
                    owner: Owner(login: repoObject.value(forKey: "ownerLogin") as! String, avatar_url: repoObject.value(forKey: "ownerAvatarUrl") as! String),
                    contributors_url: repoObject.value(forKey: "contributorsUrl") as! String
                )
                repositories.append(repository)
            }

            return repositories
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }

    func fetchImageData(for repositoryId: Int) -> Data? {
        let context = self.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDRepository")
        fetchRequest.predicate = NSPredicate(format: "id == %d", repositoryId)
        
        do {
            let repoObjects = try context.fetch(fetchRequest)
            return repoObjects.first?.value(forKey: "avatarImageData") as? Data
        } catch let error as NSError {
            print("Could not fetch image data. \(error), \(error.userInfo)")
            return nil
        }
    }

    private func clearRepositories() {
        let context = self.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDRepository")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            print("Could not clear. \(error), \(error.userInfo)")
        }
    }
}
