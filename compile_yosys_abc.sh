# -- Compile Yosys ABC script

ABC=abc
HG_ABC=https://bitbucket.org/alanmi/abc
ABCREV=ae7d65e71adc

EXT=""
if [ $ARCH == "windows" ]; then
  EXT=".exe"
fi

if [ $ARCH == "darwin" ]; then
  J=$(($(sysctl -n hw.ncpu)-1))
else
  J=$(($(nproc)-1))
fi

cd $UPSTREAM_DIR

# -- Check and download the sources
test -d $ABC || hg clone $HG_ABC $ABC
cd $ABC
hg pull && hg update -r $ABCREV
cd ..

# -- Copy the upstream sources into the build directory
rsync -a $ABC $BUILD_DIR --exclude .hg

cd $BUILD_DIR/$ABC

# -- Apply the patches
cp $DATA/Makefile.yosys-abc $BUILD_DIR/$ABC/Makefile

# -- Compile it
make -j$J

# -- Copy the executable file
cp yosys-abc$EXT $PACKAGE_DIR/$NAME/bin