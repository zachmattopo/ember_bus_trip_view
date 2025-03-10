# ember_bus_trip_view

This project is to demonstrate an app showing daily Ember bus trips between Dundee and Edinburgh.

The app first opens to a page listing all the trips happening on the current day ("Trips Today"). This list view also has the pull-to-refresh feature to refresh the list of bus trips.

Tapping on any of them will expand the card into a full page view of a map showing the current location of the bus and its next stop. In the app bar are the registration number of the bus and the bus GPS last updated time. A refresh button sits next to it to refresh the page. At the bottom of this page, a container with the name of the next stop will be shown, along with the scheduled/actual/expected times.

Tapping on this container will open up another page, listing all the stops for this bus trip in a timeline manner (note that this page is half-baked due to time constraints).

Video demos:

https://github.com/user-attachments/assets/4eefa937-16ea-4398-a24a-39049e382915

https://github.com/user-attachments/assets/d3381bba-9342-4536-9934-808e771193cb

## App folder structure

```
ember_bus_trip_view/
├── assets/                    # Static assets
│   ├── fonts/                 # Font files
│   └── icons/                 # Icon assets
├── lib/
│   ├── core/                  # Core functionality
│   │   └── app_config.dart    # App-wide configuration aka API key for Google Maps
│   ├── cubits/                # State management using Cubits
│   │   ├── trip_info_cubit/
│   │   └── trip_list_cubit/
│   ├── models/                # Data models
│   │   ├── trip.dart
│   │   ├── trip_info.dart
│   │   └── stop_info.dart
│   ├── services/              # API and services
│   │   ├── repository.dart
│   │   └── dio_client.dart
│   ├── utils/                 # Utility functions
│   │   └── app_utils.dart
│   ├── views/                 # UI components
│   │   ├── widgets/
│   │   ├── trip_info_page.dart
│   │   └── trip_list_page.dart
│   └── main.dart              # App entry point
├── test/                      # Test files
│   ├── cubits/                # Cubit tests
│   ├── models/                # Model tests
│   ├── mock/                  # Mock test data
│   └── widget_test.dart
├── pubspec.yaml               # Dependencies
└── README.md                  # Project documentation
```

## Architecture

This project follows a simpler form of CLEAN architecture pattern with:

Data Models for entity representation
Repository pattern for data access
Cubit pattern for state management
Separation of UI and business logic
