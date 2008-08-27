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
echo "(1) 2.28"
echo "(2) 2.29"
echo "(3) 2.29.3"
echo "(4) 2.30"

while [ $key != "1" ] && [ $key != "2" ] && [ $key != "3" ] && [ $key != "4" ]; do
  echo "Choose Version (1-4)"
  read key
done

case "$key" in
    "1")
	echo "Not supported"
	;;
    "2")
	echo "Install ns-2.29"
	if [ ! -f /tmp/ns-allinone-2.29.tar.gz ]; then
	  (cd /tmp/; wget http://www.isi.edu/nsnam/dist/ns-allinone-2.29.tar.gz)
	fi
	if [ -e /tmp/ns-allinone-2.29 ]; then
	  rm -rf /tmp/ns-allinone-2.29
	fi
	
	(cd /tmp/; tar xvfz ns-allinone-2.29.tar.gz)
	(cd /tmp/ns-allinone-2.29/ns-2.29; patch -Np1 -i $dir/ns-2.29-patch;patch -Np1 -i $dir/ns-2.29-002-brnextra.patch)
	(cd /tmp/ns-allinone-2.29/nam-1.11; patch -Np1 -i $dir/ns-2.29-003-nam.patch)
	(cd /tmp/ns-allinone-2.29/; patch -Np1 -i $dir/ns-2.29-004-installfile.patch)
	(cd /tmp/ns-allinone-2.29; export CLICKPATH=$CLICKPATH; ./install)
	
	if [ ! -e $PREFIX ]; then
	  mkdir $PREFIX
	  mkdir $PREFIX/bin
	fi
	
	(cd /tmp/ns-allinone-2.29; mv include $PREFIX/ ; mv man $PREFIX/ ; mv lib $PREFIX/)
	mv /tmp/ns-allinone-2.29/cweb/ctangle $PREFIX/bin/
	mv /tmp/ns-allinone-2.29/cweb/cweave $PREFIX/bin/
	mv /tmp/ns-allinone-2.29/nam-1.11/nam $PREFIX/bin/
	mv /tmp/ns-allinone-2.29/ns-2.29/ns $PREFIX/bin/
	mv /tmp/ns-allinone-2.29/xgraph-12.1/xgraph $PREFIX/bin/
	mv /tmp/ns-allinone-2.29/bin/tclsh8.4 $PREFIX/bin/
	mv /tmp/ns-allinone-2.29/bin/wish8.4 $PREFIX/bin/
	
	rm -rf /tmp/ns-allinone-2.29
	rm -f /tmp/ns-allinone-2.29.tar.gz
	;;
    "3")
	echo "Install ns-2.29.3"
	if [ ! -f /tmp/ns-allinone-2.29.3.tar.gz ]; then
	  (cd /tmp/; wget "http://downloads.sourceforge.net/nsnam/ns-allinone-2.29.3.tar.gz?modtime=1148674267&big_mirror=0")
	fi
	if [ -e /tmp/ns-allinone-2.29 ]; then
	  rm -rf /tmp/ns-allinone-2.29
	fi
	
	(cd /tmp/; tar xvfz ns-allinone-2.29.3.tar.gz)
	(cd /tmp/ns-allinone-2.29/ns-2.29; patch -Np1 -i $dir/ns-2.29.3-patch)
	(cd /tmp/ns-allinone-2.29/; patch -Np1 -i $dir/ns-2.29-004-installfile.patch)
	(cd /tmp/ns-allinone-2.29; export CLICKPATH=$CLICKPATH; ./install)
	
	if [ ! -e $PREFIX ]; then
	  mkdir $PREFIX
	  mkdir $PREFIX/bin
	fi
	
	(cd /tmp/ns-allinone-2.29; mv include $PREFIX/ ; mv man $PREFIX/ ; mv lib $PREFIX/)
	mv /tmp/ns-allinone-2.29/cweb/ctangle $PREFIX/bin/
	mv /tmp/ns-allinone-2.29/cweb/cweave $PREFIX/bin/
	mv /tmp/ns-allinone-2.29/nam-1.11/nam $PREFIX/bin/
	mv /tmp/ns-allinone-2.29/ns-2.29/ns $PREFIX/bin/
	mv /tmp/ns-allinone-2.29/xgraph-12.1/xgraph $PREFIX/bin/
	mv /tmp/ns-allinone-2.29/bin/tclsh8.4 $PREFIX/bin/
	mv /tmp/ns-allinone-2.29/bin/wish8.4 $PREFIX/bin/
	
	rm -rf /tmp/ns-allinone-2.29
	rm -f /tmp/ns-allinone-2.29.3.tar.gz
	;;
    "4")
	echo "Install ns-2.30"
	if [ ! -f /tmp/ns-allinone-2.30.tar.gz ]; then
	  (cd /tmp/; wget http://www.isi.edu/nsnam/dist/ns-allinone-2.30.tar.gz)
	fi
	if [ -e /tmp/ns-allinone-2.30 ]; then
	  rm -rf /tmp/ns-allinone-2.30
	fi
	
	(cd /tmp/; tar xvfz ns-allinone-2.30.tar.gz)
	(cd /tmp/ns-allinone-2.30/ns-2.30; patch -Np1 -i $dir/ns-2.30-patch)
	(cd /tmp/ns-allinone-2.30/; patch -Np1 -i $dir/ns-2.30-002-installfile.patch)
	(cd /tmp/ns-allinone-2.30; export CLICKPATH=$CLICKPATH; ./install)
	
	if [ ! -e $PREFIX ]; then
	  mkdir $PREFIX
	  mkdir $PREFIX/bin
	fi
	
	(cd /tmp/ns-allinone-2.30; mv include $PREFIX/ ; mv man $PREFIX/ ; mv lib $PREFIX/)
	mv /tmp/ns-allinone-2.30/cweb/ctangle $PREFIX/bin/
	mv /tmp/ns-allinone-2.30/cweb/cweave $PREFIX/bin/
	mv /tmp/ns-allinone-2.30/nam-1.12/nam $PREFIX/bin/
	mv /tmp/ns-allinone-2.30/ns-2.30/ns $PREFIX/bin/
	mv /tmp/ns-allinone-2.30/xgraph-12.1/xgraph $PREFIX/bin/
	mv /tmp/ns-allinone-2.30/bin/tclsh8.4 $PREFIX/bin/
	mv /tmp/ns-allinone-2.30/bin/wish8.4 $PREFIX/bin/
	
	rm -rf /tmp/ns-allinone-2.30
	rm -f /tmp/ns-allinone-2.30.tar.gz
	;;
esac

exit 0
	