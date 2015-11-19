# tp-cli
CLI tool for submitting activity information to TimePulse

###User Configuration
In order to make POST request parameters configurable according to user and project,
the user should have a (project repository) config/.timepulse.yml file and/or a (system)
~/.timepulse.yml file (see config/.timepulse.yml.example for example
file format) with the necessary POST request parameters as key: value pairs.

It is recommended that the user has a ~/.timepulse.yml file to configure unchanging
login and authorization credentials, e.g.:

  in `~/.timepulse.yml`:
  `timepulse_url: http://localhost:3000/activities
  login: admin
  authorization: [insert your API key here]`

as well as a project-specific .timepulse.yml file to configure specifics of the project,
e.g.:
  in project repository, `config/.timepulse.yml`:
  `project_id: 3`