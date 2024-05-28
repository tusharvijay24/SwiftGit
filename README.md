**SwiftyGit**

SwiftyGit is a mobile application built using Swift, MVVM architecture, and Core Data to search through GitHub repositories, view repository details, and explore repositories tagged to contributors. The app consists of two main screens: the Home screen and the Repo Details screen.

Features

Home Screen
1) Search Bar: Allows users to search repositories using the GitHub API.
2) List View: Displays search results using a card view with pagination (10 items per page).
3) Offline Storage: Saves the first 15 items' data offline to view without network connectivity.

Repo Details Screen
1) Repository Details: Displays detailed information about the selected repository, including:
* Image
* Name
* Project Link
* Description
* Contributors
2) Web View: Opens the project link in a web view.

Technologies Used
1) Swift: Programming language for iOS development.
2) MVVM: Architectural pattern to manage data and logic.
3) Core Data: Framework for offline storage.
4) UIKit: Framework for building the user interface.
5) SDWebImage: Library for asynchronous image downloading and caching.
