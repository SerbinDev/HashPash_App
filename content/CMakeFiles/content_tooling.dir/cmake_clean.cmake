file(REMOVE_RECURSE
  "../qml/content/App.qml"
  "../qml/content/HashPage.qml"
  "../qml/content/HashPageContent.qml"
  "../qml/content/HashPageForm.ui.qml"
  "../qml/content/PashPage.qml"
  "../qml/content/PashPageContent.qml"
  "../qml/content/PashPageForm.ui.qml"
  "../qml/content/fonts/fonts.txt"
  "../qml/content/images/history.svg"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/content_tooling.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
