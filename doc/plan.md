# Flutter Portfolio: Agent Execution Plan

This document serves as the master execution checklist for your Kilo AI agents. By feeding these specific task prompts to your agent one by one, you ensure the architecture remains modular, strictly adheres to the dark theme, and maintains responsive boundaries.

---

## Phase 1: Project Foundation & Routing
*Goal: Establish the base layout, global theming, and responsive navigation.*

- [ ] **Task 1: The Theme & Layout Shell**
  > **Prompt for Agent:** "Using Riverpod for state management and GoRouter for routing, set up the base Flutter project. Create a `PortfolioScaffold` widget that acts as the main wrapper. Implement a strict dark theme (`#1E232B` background, `#F05B43` primary orange accent) using a global `ThemeData`. Implement a responsive navigation bar: on desktop widths (>1000px), display a top `Row` with 'Home, About, Projects, Contacts'; on mobile widths, display a hamburger `IconButton` that opens an `EndDrawer`."

- [ ] **Task 2: Responsive Helpers**
  > **Prompt for Agent:** "Create a utility wrapper widget called `ResponsiveBuilder` in a `lib/core/` directory. It should take `mobileBuilder`, `tabletBuilder`, and `desktopBuilder` functions to easily switch layouts throughout the app without hardcoding `MediaQuery` breakpoints in every file."

---

## Phase 2: Building the UI (Public Face)
*Goal: Replicate the design pixel-perfectly with reusable, stateless widgets.*

- [ ] **Task 3: The Hero Section**
  > **Prompt for Agent:** "Build the `HeroSection` widget. On the left, include the stylized text 'Hello.' (with an orange dot), 'I\'m Jensen', and the bolded 'Software Developer'. Below the text, add two buttons: an orange filled `ElevatedButton` ('Got a project?') and an outlined `OutlinedButton` ('My resume'). On the right side, build the `ProfileAvatarWidget` using a `Stack` to layer the circular orange background elements and chevron vectors behind a placeholder portrait image."

- [ ] **Task 4: The Tech Stack Ribbon**
  > **Prompt for Agent:** "Create a responsive `TechStackMarquee` widget. It should display a wrapping list of technologies: HTML5, CSS, Javascript, Node.js, React, Git, Github, Flutter, Dart, Docker, and FastAPI. Use a subtle grey text color for these and ensure it wraps cleanly on mobile."

- [ ] **Task 5: The About & Services Section**
  > **Prompt for Agent:** "Build the `AboutSectionWidget`. Split this into a 50/50 `Row` on desktop, and a single stacked `Column` on mobile. The left side must feature a column of custom service widgets (Website Development, App Development, Website Hosting) with custom line-art icons and vertical timeline connectors. The right side must have the biography text and a `StatsGrid` (120+ Projects, 95% Client satisfaction, 10+ Years of experience). Use the primary orange color for the '+' and '%' symbols."

---

## Phase 3: Data Layer & Containerized Backend
*Goal: Stand up a robust API to serve and store your projects.*

- [ ] **Task 6: FastAPI & Docker Infrastructure**
  > **Prompt for Agent:** "Create a new root directory called `backend/`. Inside, initialize a FastAPI project with a PostgreSQL database. Set up a `docker-compose.yml` to run both the API and the database in containers. Create a `Project` SQLAlchemy model with fields for title, description, image_url, and github_url. Generate the basic RESTful CRUD endpoints for this model."

- [ ] **Task 7: Flutter API Integration**
  > **Prompt for Agent:** "In the Flutter `lib/features/projects/` directory, create the Dart data models and Riverpod `FutureProvider`s necessary to fetch the list of projects from our local FastAPI backend. Display these projects in a responsive `GridView.builder` beneath the 'About me' section."

---

## Phase 4: Secure Admin Interface
*Goal: Build the protected UI necessary to populate the database without writing code.*

- [ ] **Task 8: Admin Authentication Shield**
  > **Prompt for Agent:** "Update GoRouter to include a secure `/admin` route. Build a simple, branded `AdminLoginScreen` taking a username and password. Upon successful login, store the authentication token securely using the `flutter_secure_storage` package. Unauthenticated access to `/admin` must redirect to `/`."

- [ ] **Task 9: Dynamic Add Project Form**
  > **Prompt for Agent:** "Create the `AddProjectScreen` (accessible only after login). Build a validated `Form` widget containing `TextFormField`s for the project title, description, and repository URL. Include an image picker integration for uploading a thumbnail. Add a submit button that executes a POST request to our FastAPI backend to persist the new project data."
