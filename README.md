SwiftyGit
SwiftyGit is a mobile application built using Swift, MVVM architecture, and Core Data to search through GitHub repositories, view repository details, and explore repositories tagged to contributors. The app consists of two main screens: the Home screen and the Repo Details screen.

Features
Home Screen
Search Bar: Allows users to search repositories using the GitHub API.
List View: Displays search results using a card view with pagination (10 items per page).
Offline Storage: Saves the first 15 items' data offline to view without network connectivity.
Repo Details Screen
Repository Details: Displays detailed information about the selected repository, including:
Image
Name
Project Link
Description
Contributors
Web View: Opens the project link in a web view.
Technologies Used
Swift: Programming language for iOS development.
MVVM: Architectural pattern to manage data and logic.
Core Data: Framework for offline storage.
UIKit: Framework for building the user interface.
SDWebImage: Library for asynchronous image downloading and caching.
Project Structure
Controller/: Contains view controllers for the Home and Repo Details screens.
ViewModel/: Contains view models for managing data and logic.
Model/: Contains data models for repositories and contributors.
ServiceManager/: Contains web service helper to interact with GitHub API.
CoreDataManager/: Contains Core Data stack and methods for data persistence.
Setup and Installation
Clone the repository:
bash
Copy code
git clone https://github.com/yourusername/SwiftyGit.git
Navigate to the project directory:
bash
Copy code
cd SwiftyGit
Install dependencies using CocoaPods:
bash
Copy code
pod install
Open the .xcworkspace file in Xcode:
bash
Copy code
open SwiftyGit.xcworkspace
Usage
Run the project in Xcode on a simulator or a physical device.
Use the search bar on the Home screen to search for GitHub repositories.
Click on a repository to view its details on the Repo Details screen.
Click on the project link to open it in a web view.
Commit and Push
Make sure to commit frequently with descriptive commit messages:

bash
Copy code
git add .
git commit -m "Descriptive message about the changes"
git push origin main
License
This project is licensed under the MIT License. See the LICENSE file for more details.
