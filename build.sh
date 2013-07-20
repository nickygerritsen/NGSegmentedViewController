cd "NGSegmentedViewController example"
~/travis-utils/osx-cibuild.sh || exit $?
cd ..
cd "NGSegmentedViewController IB example"
~/travis-utils/osx-cibuild.sh || exit $?
cd ..