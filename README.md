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
