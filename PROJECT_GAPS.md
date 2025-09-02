# HaYBuy Project Feature Coverage & Gaps (as of 2025-09-03)

## HaYBuy Project Feature Coverage & Gaps (2025-09-03)

### 1. Core Features: What’s Missing or Incomplete?

**User Registration & Verification**

- Only basic Firebase Auth is present.
- Missing: Location-based verification, mock ID verification, full user profile (address, photo, contact info).

**Item Listing**

- Basic add/edit/delete likely present.
- Missing: Category management, item status (available/sold/reserved), image upload (camera/gallery).

**Advanced Search & Filtering**

- Basic keyword search exists.
- Missing: Map-based search, filter by category/price/distance, save favorite searches.

**In-app Messaging**

- Missing: No chat system, no chat list, no Firebase Realtime DB integration.

**Rating & Review System**

- Partial: Some rating UI in profile.
- Missing: Written reviews, reputation score, reporting inappropriate behavior.

**Push Notifications**

- Missing: No FCM integration, no notification logic for messages or price updates.

**Saved Items & Wishlist**

- Partial: Favorites exist.
- Missing: Wishlist, price tracking, sharing wishlists.

**Transaction History & Offline Access**

- Missing: No buy/sell history, no offline sync/storage.

---

### 2. Tech Stack: What’s Missing?

- **Frontend**: Flutter/Dart – Complete
- **Backend**: Firebase Auth – Complete; Firestore/Storage/FCM/Realtime DB – Not fully implemented
- **State Management**: Provider – Complete
- **Local Storage**: Missing (`SharedPreferences`, `sqflite`)
- **Image Handling**: Missing (`image_picker`, `cached_network_image`)
- **Mapping**: Missing (Google Maps/OpenStreetMap integration)
- **Location Services**: Missing (`geolocator`)
- **Mock Data**: Missing (categories, items, users, reviews, Hat Yai location coords)
- **Security**: Missing (image verification, sensitive data hiding, reporting system)

---

### 3. Other Gaps

- No comprehensive code comments or documentation
- Only basic widget test present
- No structure for final presentation/demo

---

### 4. Summary: Key Areas to Address

**User Verification**

- Location-based, mock ID verification

**Item Listing**

- Category management, item status (sold/reserved), image upload

**Search/Filtering**

- Map-based search, advanced filters/sorting

**Messaging**

- In-app chat, image sharing, read receipts, negotiation

**Ratings/Reviews**

- Written reviews, reputation score, reporting

**Notifications**

- Push notification integration

**Wishlist**

- Wanted list, price tracking, sharing

**Transactions**

- History, statistics, offline access

**Tech Stack**

- Local storage, image handling, mapping, location services, mock data, security features

**Documentation/Test**

- Comprehensive docs, code comments, advanced tests

**Presentation/Demo**

- Structure for final deliverables

---

### 5. Next Steps

To meet the requirements, you should add:

- Messaging/chat system (Firebase Realtime DB)
- Push notification logic (FCM)
- Location/map integration (Google Maps/OpenStreetMap, geolocator)
- Local storage (SharedPreferences/sqflite)
- Mock data for testing
- Advanced search/filtering and item status/category management
- Ratings/reviews with reporting and reputation
- Transaction history and offline access
- Comprehensive documentation and code comments

---

Let me know which feature you want to prioritize or need code snippets for!
