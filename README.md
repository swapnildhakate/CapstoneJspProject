Yamin's Zumba Studio - Batch Management System
Project Overview
Yamin's Zumba Studio is a web application designed to streamline the management of Zumba classes. Built with Maven, JSP, MySQL, and Tomcat it allows:
•	Users to register, log in, and manage their batch enrollments.
•	Admins to log in, manage batches, manage participants, and view enrollments. The application features a modern, light-colored design with intuitive navigation, consolidated into key JSP files for simplicity.
Features
•	User Features: 
o	Register and log in with role-based access (user/admin).
o	Manage batch enrollments (enroll, update, delete) via manageEnrollments.jsp.
•	Admin Features: 
o	Manage batches (add, edit, delete) via manageBatches.jsp.
o	Manage participants (add, edit, delete) via manageParticipants.jsp.
o	View all enrollments in viewEnrollments.jsp.
•	Design: 
o	Consistent styling with style.css (light colors, rounded buttons, hover effects).
o	Distinct dashboards for admin (admin/dashboard.jsp) and user (user/dashboard.jsp).
Tech Stack
•	Frontend: JSP, HTML, CSS (style.css for styling).
•	Backend: Java, JSP.
•	Database: MySQL (tables: user, admin, batch, enrollment).
•	Build Tool: Maven.
•	Server: Apache Tomcat.

BatchManagementSystem/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   ├── com.project.bean/    # Bean classes (User, Batch, Admin)
│   │   │   ├── com.project.dao/     # DAO classes (UserDAO, BatchDAO, AdminDAO)
│   │   │   └── com.project.util/    # Utility classes (DBUtil for DB connection)
│   │   └── webapp/
│   │       ├── admin/                       # Admin JSP files
│   │       │   ├── dashboard.jsp
│   │       │   ├── manageBatches.jsp
│   │       │   ├── manageParticipants.jsp
│   │       │   └── viewEnrollments.jsp
│   │       ├── user/                        # User JSP files
│   │       │   ├── dashboard.jsp
│   │       │   ├── manageEnrollments.jsp
│   │       │   └── register.jsp
│   │       ├── style.css                    # Styling
│   │       ├── login.jsp                    # Login page (welcome file)
│   │       └── logout.jsp                   # Logout page
└── pom.xml                                  # Maven configuration
