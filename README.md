# PocketDesk - Mobile Issue Tracker

PocketDesk is a mobile-first issue tracking app built to demonstrate practical Flutter architecture and reliable offline behavior. Users can authenticate, create and manage issues, track progress through status dashboards, and quickly find issues using search and filters.

The app is designed for day-to-day usability:

- Fast local operations with Hive-backed persistence
- Clear state transitions using BLoC and use-case driven logic
- Reliable UX with loading, empty, and error handling states
- Extra productivity features like CSV export and image attachments

This implementation follows a clean, layered structure (Data -> Domain -> Presentation) so features remain testable, maintainable, and easy to extend.

## Features

**Core**

- Authentication (email/password, test@test.com / password)
- Create, read, update, delete issues
- Dashboard with status counts
- Search by title + filter by status/priority
- Loading/empty/error states
- Local persistence (Hive), no network needed
- Pull-to-refresh

**Bonus**

- Dark & Light mode with persistent theme
- CSV export with share functionality
- Image attachments (local storage)
- Reusable UI components
- 4 test suites (CRUD, search, filter, export)
- Clean Architecture (Data → Domain → Presentation)

## Tech Stack

| Component        | Tech                       |
| ---------------- | -------------------------- |
| Framework        | Flutter 3.11.5+            |
| State Management | BLoC 9.1.1                 |
| Database         | Hive 2.2.3                 |
| DI               | GetIt 9.2.1                |
| Export           | CSV, share_plus            |
| Files            | file_picker, path_provider |

## Setup

```bash
git clone <repository-url>
cd pocket_desk
flutter pub get
flutter pub run build_runner build
flutter run
```

## Architecture

```
Presentation (BLoC, Pages, Widgets)
         ↓
Domain (Entities, Use Cases, Repositories)
         ↓
Data (Models, DataSources, Repositories)
```

**Folder Structure:**

```
lib/
├── config/              # Theme
├── core/                # Shared services, cubits, widgets
├── features/
│   ├── auth/            # Login feature
│   └── issue/           # Issue management feature
├── init_dependencies.dart
└── main.dart
```

## Key Implementation

- **Offline-First**: All data in Hive, works completely offline
- **BLoC**: Event-driven state with use cases
- **Search/Filter**: Real-time by title, status, priority
- **CSV Export**: Share issues as CSV
- **Images**: File picker + local document storage
- **Theme**: Persistent dark/light mode

## Testing

**4 Test Suites:**

```
✅ CRUD operations (create, read, update, delete)
✅ Search functionality (title matching)
✅ Filter functionality (status, priority)
✅ CSV export (format validation)
```

Run tests:

```bash
flutter test                                    # All tests
flutter test test/features/issue/issue_crud_test.dart  # Single file
flutter test --coverage                        # With coverage
```

## Architecture Design Decisions

| Choice             | Why                                           |
| ------------------ | --------------------------------------------- |
| BLoC               | Clear event flow, testable                    |
| Hive               | Type-safe, no migrations, perfect for offline |
| Clean Architecture | Testable, maintainable, scalable              |
| GetIt              | Easy DI, explicit dependencies                |
| CSV Export         | Shareable, Excel-compatible                   |

## Quick Commands

```bash
flutter pub run build_runner build   # Generate adapters
flutter test                          # Run all tests
flutter analyze                       # Code analysis
flutter clean && flutter pub get      # Clean setup
```

## Troubleshooting

- **Hive errors**: `flutter pub run build_runner clean` then rebuild
- **Theme not persisting**: Check `init_dependencies()` called in main
- **Test failures**: Regenerate adapters with `build_runner`

## Screenshots

**Light Mode**

**Login and Home**
![Login and home (light)](assets/screenshots/Login,%20Home%20-%20Light.png)

**Add, Edit, Delete**
![Add, edit, delete (light)](assets/screenshots/Add,edit,delete%20-%20light.png)

**Detail View with Action Buttons**
![Detail view with action buttons (light)](assets/screenshots/Detail%20view%20with%20action%20buttons%20-%20light.png)

**Search and Filter**
![Search and filter (light)](assets/screenshots/Search%20,%20Filter%20-%20light.png)

**Dark Mode**

**Login and Home**
![Login and home (dark)](assets/screenshots/Login%20,%20home%20-%20dark.png)

**Add, Edit, Delete**
![Add, edit, delete (dark)](assets/screenshots/add,%20edit,%20delete%20-%20dark.png)

**Detail View with Action**
![Detail view with action (dark)](assets/screenshots/Detail%20view%20with%20action%20-%20dark.png)

**Settings, Theme, CSV Export, Sign Out**
![Settings, theme, CSV export, sign out](assets/screenshots/Settings,%20theme,%20csv%20export%20,%20signout.png)

---

**Production-ready Flutter implementation** with all core and bonus features fully functional and tested.
