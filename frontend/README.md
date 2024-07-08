#Requirements

**Frontend**
* Login screen
* Home page
  - Show a list of projects
    - A project has a name and a description
  - "New Project" button (top right)
    - On clicking this button, show a dialog box that has two fields:
      - Text Field for project name
      - Text Area for project description
  - Open a project
    - In the list of projects, when a user clicks a project name, open a new screen
* Project screen
  - show the project name in the header
  - show the list of images that are part of project in a grid view
  - provide a button "Upload Images" in the top right part of the screen
  - on clicking this button, show the upload images dialog

**Backend**
* Provide an API to create, edit and delete projects
  - store the project name and description in the database
  - project should have an ID too
* Provide an API to upload images
  - store the image path (on the server) along with project ID
* Provide an API to fetch images in a project
  
