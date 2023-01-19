To build the dev environment, simlpy
```bash
docker build . -t c_dev_env:latest
```

In the docker container, first run of `nvim` will automatically init the plugins for you.

The LSP manager I used is [Mason](https://github.com/williamboman/mason.nvim). To install your desired language server: `:Mason` to launch the plugin interface, search for the language server you are looking for, move the cursor to it and hit `i` to install.

Here is an example of init nvim + clangd in the container:
![](https://github.com/keg0704/keg_c_dev_env/blob/master/imgs/init_nvim.gif)

The prerequisite for `clangd` has been installed already, for other languages you can have a try with Mason to see if you need to install libraries manually.
