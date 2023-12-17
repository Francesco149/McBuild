this is a meson-based build system for McOsu and McEngine-based projects for linux.

* lets you link against system libraries instead of vendored ones
* heavily parallel compilation, faster than eclipse
* less stuff compiled since we are using system libraries
* can relocate the data directory for a linux-style split install in `/usr/share` and `/usr/bin`

I am not gonna try to upstream this for now as it's for linux only and it adds a bunch of ifdefs
to fix headers

# preparing your dev environment
install meson with your distro's package manager. or install python and do
`python -m pip install --user meson`. you also need git

install the following libraries

* [miniz](https://github.com/richgel999/miniz) (McOsu only)
* glew
* freetype2
* X11
* libjpeg
* xi
* [bass](https://www.un4seen.com/download.php?bass24-linux)
* [bass\_fx](https://www.un4seen.com/download.php?z/0/bass_fx24-linux)
* SDL2


```sh
curl -Ss https://raw.githubusercontent.com/Francesco149/McBuild/master/prepare.sh | sh
```

this will prepare and put you in a build directory

now you can edit `build.sh` to change the meson invocation with the options you want

example of relocating everything to ~/McOsu

```sh
meson --prefix="$HOME/McOsu"
```

example of building with discord-rpc support

```sh
meson -Dfeatures=multithreading,pthreads,opengl,sound,discord  ..
```

when you are ready, run `./build.sh`

to install everything to your prefix, run `./install.sh`
