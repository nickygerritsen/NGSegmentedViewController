cd "NGSegmentedViewController example"
pod update
xctool -workspace NGSegmentedViewController\ example.xcworkspace -scheme "NGSegmentedViewController example" -configuration Release -sdk iphonesimulator -arch i386 build || exit $?
cd ..
cd "NGSegmentedViewController IB example"
pod update
xctool -workspace NGSegmentedViewController\ IB\ example.xcworkspace -scheme "NGSegmentedViewController IB example" -configuration Release -sdk iphonesimulator -arch i386 build || exit $?
cd ..