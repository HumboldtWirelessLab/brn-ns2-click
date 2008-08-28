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

key=0
echo "(1) 2.29-brn (Scheduler-Patch,Brn-extra)"
echo "(2) 2.29"
echo "(3) 2.29.3"
echo "(4) 2.30"

while [ $key != "1" ] && [ $key != "2" ] && [ $key != "3" ] && [ $key != "4" ]; do
  echo "Choose Version (1-4)"
  read key
done

download_and_unpack() {
  if [ ! -f /tmp/$2 ]; then
    (cd /tmp/; wget $1)
  fi
  
  if [ -e /tmp/$3 ]; then
    rm -rf /tmp/$3
  fi
    
  (cd /tmp/; tar xvfz $2)
}

create_dir() {
  if [ ! -e $1 ]; then
    mkdir $1
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

  if [ "$1" = "ns-allinone-2.29"  ]; then
    mv /tmp/ns-allinone-2.29/nam-1.11/nam $2/bin/
    mv /tmp/ns-allinone-2.29/ns-2.29/ns $2/bin/
  else
    mv /tmp/ns-allinone-2.30/nam-1.12/nam $2/bin/
    mv /tmp/ns-allinone-2.30/ns-2.30/ns $2/bin/
  fi
}

clean_up() {
  rm -rf /tmp/$2
#  rm -f /tmp/$1
}

case "$key" in
    "1")
	echo "Install ns-2.29-brn"

	download_and_unpack "http://www.isi.edu/nsnam/dist/ns-allinone-2.29.tar.gz" ns-allinone-2.29.tar.gz ns-allinone-2.29
	
	(cd /tmp/ns-allinone-2.29/ns-2.29; patch -Np1 -i $dir/ns-2.29-patch)
	(cd /tmp/ns-allinone-2.29/ns-2.29; patch -Np1 -i $dir/ns-2.29-scheduler.patch; patch -Np1 -i $dir/ns-2.29-002-brnextra.patch)
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
	(cd /tmp/ns-allinone-2.30/; patch -Np1 -i $dir/ns-2.30-002-installfile.patch)
	(cd /tmp/ns-allinone-2.30; export CLICKPATH=$CLICKPATH; ./install)

	create_dir $PREFIX
	install_file ns-allinone-2.30 $PREFIX
	clean_up ns-allinone-2.30.tar.gz ns-allinone-2.30
	;;
esac

exit 0
	