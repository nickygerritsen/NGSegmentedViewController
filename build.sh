cd "NGSegmentedViewController example"
XCWORKSPACE="NGSegmentedViewController example.xcworkspace" ~/travis-utils/osx-cibuild.sh || exit $?
cd ..
cd "NGSegmentedViewController IB example"
XCWORKSPACE="NGSegmentedViewController IB example.xcworkspace" ~/travis-utils/osx-cibuild.sh || exit $?
cd ..