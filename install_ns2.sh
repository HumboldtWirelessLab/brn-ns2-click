#!/bin/sh

dir=$PWD

if [ "x$PREFIX" = "x" ]; then
  echo "Please set PREFIX to the target directory !"
  exit 0
fi

if [ "x$CLICKPATH" = "x" ]; then
  echo "Please set CLICKPATH to the click-directory !"
  exit 0
fi

if [ "x$CLEAN" = "x" ]; then
  CLEAN=1
fi

if [ "x$VERSION" = "x" ]; then
  VERSION=0
fi

if [ "x$CPUS" = "x" ]; then
  CPUS=1
fi

if [ $VERSION -eq 0 ]; then
  key=0
  echo "(1) 2.29-brn (Scheduler-Patch,Brn-extra)"
  echo "(2) 2.29"
  echo "(3) 2.29.3"
  echo "(4) 2.30"
  echo "(5) 2.34"

  while [ $key != "1" ] && [ $key != "2" ] && [ $key != "3" ] && [ $key != "4" ] && [ $key != "5" ]; do
    echo -n "Choose Version (1-5): "
    read key
    if [ "x$key" = "x" ]; then
      key=0
    fi
  done
else
  key=$VERSION
fi

if [ "x$CPUS" = "x" ]; then
  if [ -f /proc/cpuinfo ]; then
    CPUS=`grep -e "^processor" /proc/cpuinfo | wc -l`
  else
    CPUS=2
  fi
fi

download_and_unpack() {
  if [ ! -f /tmp/$2 ]; then
    (cd /tmp/; wget $1 -O $2)
  fi

  if [ -e /tmp/$3 ]; then
    rm -rf /tmp/$3
  fi
    
  (cd /tmp/; tar xvfz $2)
}

create_dir() {
  if [ ! -e $1 ]; then
    mkdir $1
  fi
  if [ ! -e $1/bin ]; then
    mkdir $1/bin
  fi
}

install_file() {
  (cd /tmp/$1; mv include $2/ ; mv man $2/ ; mv lib $2/)
  mv /tmp/$1/cweb/ctangle $2/bin/
  mv /tmp/$1/cweb/cweave $2/bin/
  mv /tmp/$1/xgraph-12.1/xgraph $2/bin/
  mv /tmp/$1/bin/tclsh8.4 $2/bin/
  mv /tmp/$1/bin/wish8.4 $2/bin/

  case "$1" in
  "ns-allinone-2.29")
    mv /tmp/ns-allinone-2.29/nam-1.11/nam $2/bin/
    mv /tmp/ns-allinone-2.29/ns-2.29/ns $2/bin/
    ;;
  "ns-allinone-2.30")
    mv /tmp/ns-allinone-2.30/nam-1.12/nam $2/bin/
    mv /tmp/ns-allinone-2.30/ns-2.30/ns $2/bin/
    ;;
  "ns-allinone-2.34")
    mv /tmp/ns-allinone-2.34/nam-1.14/nam $2/bin/
    mv /tmp/ns-allinone-2.34/ns-2.34/ns $2/bin/
    if [ -e /tmp/ns-allinone-2.34/ns-2.34/nse ]; then
      mv /tmp/ns-allinone-2.34/ns-2.34/nse $2/bin/
    fi
    mv /tmp/ns-allinone-2.34/ns-2.34/nstk $2/bin/
    ;;
  esac
  
}

clean_up() {
  echo "Clean up"
  rm -rf /tmp/$2
  rm -f /tmp/$1
}

case "$key" in
    "1")
	echo "Install ns-2.29-brn"

	download_and_unpack "http://www.isi.edu/nsnam/dist/ns-allinone-2.29.tar.gz" ns-allinone-2.29.tar.gz ns-allinone-2.29
	
	(cd /tmp/ns-allinone-2.29/ns-2.29; patch -Np1 -i $dir/ns-2.29-patch)
	(cd /tmp/ns-allinone-2.29/ns-2.29; patch -Np1 -i $dir/ns-2.29-scheduler.patch; patch -Np1 -i $dir/ns-2.29-002-brnextra.patch;patch -Np1 -i $dir/ns-2.29-002-brnextra-tcp.patch)
	(cd /tmp/ns-allinone-2.29/nam-1.11; patch -Np1 -i $dir/ns-2.29-003-nam.patch)
	(cd /tmp/ns-allinone-2.29/; patch -Np1 -i $dir/ns-2.29-004-installfile.patch)
	(cd /tmp/ns-allinone-2.29; export CLICKPATH=$CLICKPATH; ./install)
	
	create_dir $PREFIX
	install_file ns-allinone-2.29 $PREFIX
	clean_up ns-allinone-2.29.tar.gz ns-allinone-2.29
	;;
    "2")
	echo "Install ns-2.29"

	download_and_unpack "http://www.isi.edu/nsnam/dist/ns-allinone-2.29.tar.gz" ns-allinone-2.29.tar.gz ns-allinone-2.29

	(cd /tmp/ns-allinone-2.29/ns-2.29; patch -Np1 -i $dir/ns-2.29-patch)
	(cd /tmp/ns-allinone-2.29/nam-1.11; patch -Np1 -i $dir/ns-2.29-003-nam.patch)
	(cd /tmp/ns-allinone-2.29/; patch -Np1 -i $dir/ns-2.29-004-installfile.patch)
	(cd /tmp/ns-allinone-2.29; export CLICKPATH=$CLICKPATH; ./install)

	create_dir $PREFIX
	install_file ns-allinone-2.29 $PREFIX
	clean_up ns-allinone-2.29.tar.gz ns-allinone-2.29
	;;
    "3")
	echo "Install ns-2.29.3"
	
	download_and_unpack  "http://downloads.sourceforge.net/nsnam/ns-allinone-2.29.3.tar.gz?modtime=1148674267&big_mirror=0" ns-allinone-2.29.3.tar.gz ns-allinone-2.29
	(cd /tmp/ns-allinone-2.29/ns-2.29; patch -Np1 -i $dir/ns-2.29.3-patch)
	(cd /tmp/ns-allinone-2.29/; patch -Np1 -i $dir/ns-2.29-004-installfile.patch)
	(cd /tmp/ns-allinone-2.29; export CLICKPATH=$CLICKPATH; ./install)

	create_dir $PREFIX
	install_file ns-allinone-2.29 $PREFIX
	clean_up ns-allinone-2.29.3.tar.gz ns-allinone-2.29
	;;
    "4")
	echo "Install ns-2.30"

	download_and_unpack "http://www.isi.edu/nsnam/dist/ns-allinone-2.30.tar.gz" ns-allinone-2.30.tar.gz ns-allinone-2.30

	(cd /tmp/ns-allinone-2.30/ns-2.30; patch -Np1 -i $dir/ns-2.30-patch)
	(cd /tmp/ns-allinone-2.30/ns-2.30; patch -Np1 -i $dir/ns-2.30-001-scheduler.patch)
	(cd /tmp/ns-allinone-2.30/; patch -Np1 -i $dir/ns-2.30-002-installfile.patch)
	(cd /tmp/ns-allinone-2.30; export CLICKPATH=$CLICKPATH; ./install)

	create_dir $PREFIX
	install_file ns-allinone-2.30 $PREFIX
	clean_up ns-allinone-2.30.tar.gz ns-allinone-2.30
	;;
    "5")
	echo "Install ns-2.34"

	download_and_unpack "http://downloads.sourceforge.net/project/nsnam/allinone/ns-allinone-2.34/ns-allinone-2.34.tar.gz?use_mirror=freefr" ns-allinone-2.34.tar.gz ns-allinone-2.34

	(cd /tmp/ns-allinone-2.34/ns-2.34; patch -Np1 -i $dir/ns-2.34-patch)
	(cd /tmp/ns-allinone-2.34/; patch -Np0 -i $dir/ns-2.34-001-installfile.patch)
	(cd /tmp/ns-allinone-2.34/; patch -Np0 -i $dir/ns-2.34-002-installfile-prefix.patch)
	(cd /tmp/ns-allinone-2.34/; patch -Np0 -i $dir/ns-2.34-003-gcc-stack-fix.patch)
	(cd /tmp/ns-allinone-2.34/; patch -Np0 -i $dir/ns-2.34-004-disable-nsbuild.patch)
	(cd /tmp/ns-allinone-2.34/; patch -Np0 -i $dir/ns-2.34-005-multicpu.patch)
	(cd /tmp/ns-allinone-2.34/; patch -Np0 -R -i $dir/ns-2.34-patch-gcc-4.6.2)
	(cd /tmp/ns-allinone-2.34; export CLICKPATH=$CLICKPATH; export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CLICKPATH/ns; ./install)
	
	create_dir $PREFIX
	install_file ns-allinone-2.34 $PREFIX

	if [ "x$DEVELOP" = "x1" ]; then
	  rm -rf /tmp/ns-allinone-2.34/bin
	  rm -rf /tmp/ns-allinone-2.34/include
	  rm -rf /tmp/ns-allinone-2.34/lib
	  rm -rf /tmp/ns-allinone-2.34/man
	  
	  (cd /tmp/ns-allinone-2.34/tcl8.4.18/unix; make install; make install-private-headers)
	  (cd /tmp/ns-allinone-2.34/tk8.4.18/unix; make install)
	  (cd /tmp/ns-allinone-2.34/tclcl-1.19; make install)
	  (cd /tmp/ns-allinone-2.34/otcl-1.13; make install)
	  
	  cp -r /tmp/ns-allinone-2.34/bin $PREFIX
	  cp -r /tmp/ns-allinone-2.34/include $PREFIX
	  cp -r /tmp/ns-allinone-2.34/lib $PREFIX
	  cp -r /tmp/ns-allinone-2.34/man $PREFIX
	  
	  rm -f $PREFIX/lib/libotcl.so
	  	  
	  (cd $PREFIX/src/ns-2.34; export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CLICKPATH/ns; CFLAGS="-L$CLICKPATH/ns/ -lstdc++" ./configure --prefix=$PREFIX --with-click=$CLICKPATH --with-tcl=$PREFIX --with-tclcl=$PREFIX --with-tk=$PREFIX  --with-otcl=$PREFIX; make -j $CPUS)
	  (mv $PREFIX/bin/ns $PREFIX/bin/ns.old)
	  ln -s $PREFIX/src/ns-2.34/ns $PREFIX/bin/ns
	fi
	
	ln -s $CLICKPATH/ns/libnsclick.so $PREFIX/lib/libnsclick.so
	if [ $CLEAN -eq 1 ]; then
	  clean_up ns-allinone-2.34.tar.gz ns-allinone-2.34
	fi
	;;
	
esac

exit 0
	
