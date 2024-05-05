# StackOverflow User List Application

## Overview
This iOS application fetches a list of the top 20 StackOverflow users and displays them in a user-friendly interface. Users can view the profile image, name, and reputation of each StackOverflow user, and they have the option to follow or unfollow users. The follow status is persisted locally and updates are reflected immediately in the UI.

## Features
- Fetch and display the top 20 StackOverflow users.
- Show user details including profile image, name, and reputation.
- Allow users to follow or unfollow StackOverflow users.
- Persist follow/unfollow status locally using CoreData.
- Handle network failures gracefully with appropriate error messages.

## Installation Requirements
To run the StackOverflow User List application, you need:

- Xcode 12 or later
- iOS 16 or later
- Swift 5.10

## Setup
1. Clone the repository to your local machine:
git clone https://github.com/emilvaklinov/stackoverflow.git

2. Open the project in Xcode:
open StackOverflowUserList.xcodeproj

3. Build and run the application on a simulator or physical device targeting iOS 16 or later.

# Technical Decisions
## Architecture
The application is built using the Model-View-ViewModel (MVVM) architecture. This pattern supports better separation of concerns and allows for more modular code and easier testing.

## Networking
Network requests are handled by a custom NetworkManager class, which uses URLSession to fetch data asynchronously. This manager is designed to be reusable and extendable for future network calls.

## Data Persistence
User follow status is persisted using CoreData, which provides robust data management capabilities suitable for this application's needs. The decision to use CoreData over simpler solutions like UserDefaults was made to allow for more complex data relationships and querying capabilities in the future.

## Error Handling
The application is designed to handle network errors gracefully. An error view is displayed whenever there is a failure in fetching data, with an option to retry the fetch. This ensures a good user experience even when network conditions are poor.

## Unit Testing
Unit tests have been written to cover the core functionality provided by the view models and network manager. These tests use mock objects and an in-memory CoreData stack to ensure that tests are fast and do not affect the production database.

## UI Design
The user interface is designed to be simple yet effective, with a focus on usability and performance. UITableView is used to list users, and custom UITableViewCell designs are implemented to display user information neatly.

## Conclusion
This application serves as a practical demonstration of using modern iOS development practices to create a clean, robust, and user-friendly application. The architecture and technologies used ensure that the app is maintainable and scalable.
