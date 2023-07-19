# Using VSCode and Dev Containers

> The **Visual Studio Code Dev Containers** extension lets you use a container as a full-featured development environment. It allows you to open any folder inside (or mounted into) a container and take advantage of Visual Studio Code's full feature set.

See <[devcontainer-documentation]> for more information.

## Prerequisites

- Meet the [system requirements](https://code.visualstudio.com/docs/devcontainers/containers#_system-requirements)
- Follow the [installation instructions](https://code.visualstudio.com/docs/devcontainers/containers#_installation)
- [Check the installation](https://code.visualstudio.com/docs/devcontainers/tutorial#_check-installation)

## Initial setup

After you've verified that the extension is installed and working, click on the "Remote Status" bar icon and select
"Reopen in Container".

Once your machine is built and running you'll need to make sure to update the `.env.local` file with the required
credentials. These are _essential_ to running the application.

## Running the app

In this project, we use [tasks](https://code.visualstudio.com/docs/editor/tasks) to make the experience easier
when using VSCode.

Click on "Terminal" -> "Run Task" -> "bin/server - run the server"

We use [`overmind`](https://github.com/DarthSim/overmind) to start up all of the required processes defined in
`Procfile.dev`.

Your application will be viewable at <http://localhost:3000>.

[devcontainer-documentation]: https://code.visualstudio.com/docs/devcontainers/container
