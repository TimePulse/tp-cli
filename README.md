# tp-cli
CLI tool for submitting activity information to [TimePulse](https://github.com/TimePulse/TimePulse)

###User Configuration
Tp-cli relies on YAML files in user and project directories for information about how and where to send information. For user-specific information, we recommend you place a `timepulse.yml` in one of these directories:

* ~/.timepulse
* ~/
* /usr/share/timepulse
* /etc/timepulse

A user `timepulse.yml` should have the following information:

```
timepulse_url: http://[www.timepulse.io]/activities.json
login: [yourname@emailaddress.com]
authorization: [insert your API key here]
```

Your implementation of timepulse may have a different website, but the url should still end with `/activities.json`. You can generate a new API key on your user profile on TimePulse.

Individual projects that are billed in TimePulse should also have a `timepulse.yml` file in their root directory, or in a config directory off of root. A project `timepulse.yml` should have the following information:

```
project_id: [2]
directory_name: [Main Project Directory]
```

The `project_id` is the number used by TimePulse to identify the project billed for its work on a particular project. The `directory_name` line is optional. If you want to specify a more descriptive name for the directory being tracked by `cwd` annotations, you can uncomment this line and specify a new name. Otherwise, the message will include the current working directory.

### Sending notes
The command `tp-cli note "Note message"` can be used to annotate your work without having to visit the TimePulse web interface. If you are currently logged into a project, the note will automatically be added to your current work unit. Otherwise, it will be saved so you can use it to catch unbilled time.

### Using direnv and cwd
The `tp-cli cwd` command is designed to be used in conjunction with [direnv](http://direnv.net/). By adding `tp-cli cwd` to a project directory's `.envrc` file, you will automatically send an annotation to TimePulse. You can use these notes to ensure that you don't lose any time working on a project.
