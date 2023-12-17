#!/bin/sh

builddir="$(pwd)/McBuild-$(date +%F%H%M%S)" || exit
mkdir "${builddir}" &&
cd "${builddir}" || exit
if [ -n "$LOCAL_DEBUG" ]; then
  git clone ~/src/McBuild &&
  git clone ~/3src/McEngine &&
  git clone ~/3src/McOsu || exit
else
  git clone https://github.com/Francesco149/McBuild &&
  git clone https://github.com/McKay42/McEngine &&
  git clone https://github.com/McKay42/McOsu || exit
fi
cd "${builddir}/McEngine" &&
patch -p1 < "${builddir}/McBuild/McEngine.diff" &&
cd "${builddir}/McEngine/McEngine" &&
cp "${builddir}/McBuild/McEngine.build" ./meson.build &&
cp "${builddir}/McBuild/meson_options.txt" . &&
cd "${builddir}/McOsu" &&
patch -p1 < "${builddir}/McBuild/McOsu.diff" &&
cp "${builddir}/McBuild/McOsu.build" ./src/App/Osu/meson.build \
  || exit

for d in cfg fonts materials; do
  cp -rvi "${builddir}/McBuild/build/${d}/"* "${builddir}/McEngine/McEngine/build/${d}/" || exit
done

ln -sv "${builddir}/McOsu/src/App/Osu" "${builddir}/McEngine/McEngine/src/App/Osu" || exit

cd "${builddir}" || exit
cat > build.sh << "EOF"
#!/bin/sh
dir="$(dirname "$0")"
abspath="$(realpath "$dir")"
olddir="$(pwd)"
cd "${abspath}/McEngine/McEngine/build" || exit

# edit this meson invokation with your options
meson setup --prefix="${abspath}/McOsu" "$@" .. && ninja || exit
EOF

cat > install.sh << "EOF"
#!/bin/sh
dir="$(dirname "$0")"
abspath="$(realpath "$dir")"
olddir="$(pwd)"
cd "${abspath}/McEngine/McEngine/build" || exit
ninja install || exit
EOF

chmod +x ./build.sh || exit
chmod +x ./install.sh || exit

echo
echo "====="
echo "===== The build directory should be ready"
echo "===== You can now cd to ${builddir} and run build.sh"
echo "====="
