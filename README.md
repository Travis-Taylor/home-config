# home-config

Repo to centralize various config files across work and home linux machines.

At the top-level are files meant to live in the $HOME directory. An easy way to link these to their intended location is by running this from the top-level dir:

`find . -maxdepth 1 -type f ! -name README.md | xargs -I{} ln -s $(pwd)/{} ~`