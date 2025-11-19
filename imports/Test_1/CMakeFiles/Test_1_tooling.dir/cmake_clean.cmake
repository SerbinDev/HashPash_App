file(REMOVE_RECURSE
  "../../qml/Test_1/Constants.qml"
  "../../qml/Test_1/CustomMenuBar.qml"
  "../../qml/Test_1/DirectoryFontLoader.qml"
  "../../qml/Test_1/EventListModel.qml"
  "../../qml/Test_1/EventListSimulator.qml"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/Test_1_tooling.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
