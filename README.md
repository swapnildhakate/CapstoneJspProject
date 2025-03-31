# Yamin's Zumba Studio - Zumba (Batch) Management System

## Overview
Yamin's Zumba Studio is a web application designed to streamline Zumba class management. Built with Maven, JSP, MySQL, and Tomcat, it provides:
- **Users**: Register, log in, and manage batch enrollments.
- **Admins**: Log in, manage batches, manage participants, and view enrollments.
- **Design**: Modern, light-colored interface with intuitive navigation, consolidated into key JSP files.

## Features
### User Features
- Register and log in with role-based access (user/admin).
- Manage batch enrollments (enroll, update, delete) via `manageEnrollments.jsp`.

### Admin Features
- Manage batches (add, edit, delete) via `manageBatches.jsp`.
- Manage participants (add, edit, delete) via `manageParticipants.jsp`.
- View all enrollments in `viewEnrollments.jsp`.

### Design
- Consistent styling with `style.css` (light colors, rounded buttons, hover effects).
- Distinct dashboards:
  - Admin: `admin/dashboard.jsp` (purple buttons, indigo gradient).
  - User: `user/dashboard.jsp` (green buttons, green gradient).

## Tech Stack
- **Frontend**: JSP, HTML, CSS (`style.css`).
- **Backend**: Java, JSP.
- **Database**: MySQL (tables: `user`, `admin`, `batch`, `enrollment`).
- **Build Tool**: Maven.
- **Server**: Apache Tomcat.

## Project Structure
```
BatchManagementSystem/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   ├── com.project.bean/    # Bean classes (User, Batch, Admin)
│   │   │   ├── com.project.dao/     # DAO classes (UserDAO, BatchDAO, AdminDAO)
│   │   │   └── com.project.util/    # Utility classes (DBUtil for DB connection)
│   │   └── webapp/
│   │       ├── admin/               # Admin JSP files
│   │       │   ├── dashboard.jsp
│   │       │   ├── manageBatches.jsp
│   │       │   ├── manageParticipants.jsp
│   │       │   └── viewEnrollments.jsp
│   │       ├── user/                # User JSP files
│   │       │   ├── dashboard.jsp
│   │       │   ├── manageEnrollments.jsp
│   │       │   └── register.jsp
│   │       ├── style.css            # Styling
│   │       ├── login.jsp            # Login page (welcome file)
│   │       └── logout.jsp           # Logout page
└── pom.xml                          # Maven configuration
```

## Prerequisites
- Java: JDK 14 or higher
- Maven: For building the project.
- MySQL: MySQL Server 8 or higher.
- Tomcat: Apache Tomcat 9 or higher.
