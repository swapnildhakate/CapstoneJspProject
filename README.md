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
  │   │       ├── style.css          # Styling
│   │       ├── login.jsp            # Login page (welcome file)
│   │       └── logout.jsp           # Logout page
└── pom.xml                          # Maven configuration
```

## Prerequisites
- Java: JDK 14 or higher.
- Maven: For building the project.
- MySQL: MySQL Server 8 or higher.
- Tomcat: Apache Tomcat 9 or higher.

## Setup Instructions
Follow these steps to set up and run the project locally:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/<your-username>/BatchManagementSystem.git
   cd BatchManagementSystem
   ```

2. **Set Up the Database**:
   - Create a MySQL database named `zumba_db`.
   - Execute the following SQL to create tables and insert a default admin:
     ```sql
     CREATE TABLE admin (
         username VARCHAR(50) PRIMARY KEY,
         password VARCHAR(255) NOT NULL
     );

     CREATE TABLE user (
         user_id INT AUTO_INCREMENT PRIMARY KEY,
         username VARCHAR(50) UNIQUE NOT NULL,
         password VARCHAR(255) NOT NULL,
         email VARCHAR(100) UNIQUE NOT NULL
     );

     CREATE TABLE batch (
         batch_id INT AUTO_INCREMENT PRIMARY KEY,
         batch_name VARCHAR(50) NOT NULL,
         start_date DATE NOT NULL,
         end_date DATE NOT NULL,
         time VARCHAR(10) NOT NULL
     );

     CREATE TABLE enrollment (
         user_id INT,
         batch_id INT,
         PRIMARY KEY (user_id, batch_id),
         FOREIGN KEY (user_id) REFERENCES user(user_id),
         FOREIGN KEY (batch_id) REFERENCES batch(batch_id)
     );

     INSERT INTO admin (username, password) VALUES ('admin', 'admin123');
     ```
     
