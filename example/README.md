# Configuration for clangd server
To test out the exmaple:
```bash
cd example
mkdir build && cd build
cmake -DCMAKE_EXPORT_COMPILE_COMMAND=1 ..
```
this will generate a `compile_commands.json` file under the `build` directory, in our case:
```json
[
    {
      "directory": "${your_project_root}/keg_c_dev_env/example/build",
      "command": "/usr/bin/c++  -I${your_project_root}/keg_c_dev_env/example/include -std=gnu++1z -o CMakeFiles/example.dir/src/test.cpp.o -c ${your_project_root}/keg_c_dev_env/example/src/test.cpp",
      "file": "${your_project_root}/keg_c_dev_env/example/src/test.cpp"
    }
]
```
which tells `clangd` about the compiling information so that it knows where to find all the source files. You can leave the file under the build directory or move it to the project root, clangd will check both location.

# Features
At this point, nvim convers common IDE features such as:
## auto-compeletion
built in definitions
![](https://github.com/keg0704/keg_c_dev_env/blob/master/imgs/auto_complete_buildin.png)
self-defined functions
![](https://github.com/keg0704/keg_c_dev_env/blob/master/imgs/auto_complete_self_defined.png)

## go-to definition
![](https://github.com/keg0704/keg_c_dev_env/blob/master/imgs/goto_def.gif)

## format on save
![](https://github.com/keg0704/keg_c_dev_env/blob/master/imgs/goto_def.gif)

## comment out
![](https://github.com/keg0704/keg_c_dev_env/blob/master/imgs/comment_out.gif)

