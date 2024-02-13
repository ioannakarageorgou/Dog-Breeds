# Dog Breeds App

## Overview

The Dog Breeds app is designed to showcase various dog breeds, allowing users to explore images of different breeds and save their favorite ones.

![](https://github.com/shape-interviews/ios-take-home-ioannakarageorgou/blob/develop/Dog%20Breeds/Recorded%20Gif/Simulator%20Screen%20Recording%20-%20iPhone%2015%20Pro%20-%202024-01-21%20at%2012.02.38.gif)

## Project Structure

### Main Components

- **BreedListViewController**
  - Displays a list of dog breeds.
  - Coordinates with the `MainCoordinator` to navigate to breed images or favorite breeds.

- **BreedImageViewController**
  - Shows images of a specific dog breed.
  - Allows users to like or unlike images.

- **FavoriteBreedsViewController**
  - Displays a list of user-liked dog breeds.

- **MainCoordinator**
  - Acts as the coordinator to manage navigation flow between different view controllers.

- **BreedListViewModel**
  - Handles the logic related to the list of dog breeds.

- **BreedImageViewModel**
  - Manages logic for fetching and displaying breed images.

- **FavoriteBreedsViewModel**
  - Handles logic for fetching and displaying liked breed images.

- **RealmService**
  - Interacts with the Realm database for storing and retrieving liked breed images.

- **BreedsRepository**
  - Acts as an interface for fetching dog breeds and images, as well as saving and removing liked breed images.

- **NetworkManager**
  - Responsible for making network requests.

### Patterns Used

- **Coordinator Pattern**
  - Implemented through the `MainCoordinator` class to manage navigation.

- **MVVM (Model-View-ViewModel) Pattern**
  - View controllers (View) communicate with view models (ViewModel) to update UI.
  - View models handle the business logic and interact with repositories.

- **Repository Pattern**
  - `BreedsRepository` abstracts the data access layer, providing a clear interface for fetching and saving data.

- **Realm Database**
  - Used for local storage of liked breed images.


