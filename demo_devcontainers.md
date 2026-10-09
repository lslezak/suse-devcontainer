
- Start VSCode in Agama without container
- Advantages of devcontainers
  - All needed development tools are automatically installed.
  - Ensures all developers have the same environment.
  - You can develop from different version or from a completely different
    distribution (or even from Windows using WSL containers).
  - The sandbox is useful when running AI code assisting tools.
  - If you mess up the development system you can just rebuild the container and
    start from scratch.
  - Want to develop on openSUSE Tumbleweed instead of Leap? Just switch the base
    system image and rebuild the container!

- `cat /etc/os-release`
- Configure devcontainer, select All-in-1 (describe the defined containers)
- Use `ghcr.io/lslezak/suse-devcontainer/agama` template name

- Start container
- ```sh
  cat /etc/os-release
  cd web
  AGAMA_SERVER=https://agama.local npm run server
  ```
- Open integrated browser
- Change color
- SSH and GPG agents are forwarded inside the container

- Exclude from git `echo ".devcontainer/" >> .git/info/exclude`

- Extensions - run in container too, show how to install, how to get extension ID
- How to customize - devcontainer.json + Dockerfile 
- How to rebuild (+ without cache)

- How to install and configure
  - podman instead of docker
  - default extensions
  - dotfiles - https://dotfiles.github.io/
  - dev container path
