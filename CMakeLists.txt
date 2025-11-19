cmake_minimum_required(VERSION 3.21.1)

option(LINK_INSIGHT "Link Qt Insight Tracker library" ON)
option(BUILD_QDS_COMPONENTS "Build design studio components" ON)

project(HashPash LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)

find_package(Qt6 6.2 REQUIRED COMPONENTS Core Gui Qml Quick Sql)
find_package(OpenSSL REQUIRED)
find_package(ZLIB REQUIRED)
find_package(Qt6 REQUIRED COMPONENTS Widgets)
find_package(Qt6 REQUIRED COMPONENTS Concurrent)
if (Qt6_VERSION VERSION_GREATER_EQUAL 6.3)
    qt_standard_project_setup()
endif()

qt_add_executable(HashPash src/main.cpp
    backend/SignVerify.h
    backend/SignVerify.cpp
    backend/SQLiteDatabase.h
    backend/SQLiteDatabase.cpp

    backend/ClipboardHelper.h
    backend/EncryptFile.h backend/EncryptFile.cpp
    backend/DecryptFile.h backend/DecryptFile.cpp
    backend/StandardTemplate.h backend/StandardTemplate.cpp
    backend/FolderSelector.h

)

qt_add_resources(HashPash "configuration"
    # PREFIX "/"
    FILES
        qtquickcontrols2.conf
)

target_link_libraries(HashPash PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    OpenSSL::Crypto
    Qt6::Sql
    ZLIB::ZLIB
    Qt6::Concurrent
    Qt6::Widgets
)

if (BUILD_QDS_COMPONENTS)
include(${CMAKE_CURRENT_SOURCE_DIR}/qmlcomponents)
endif()

include(${CMAKE_CURRENT_SOURCE_DIR}/qmlmodules)

if (LINK_INSIGHT)
    include(${CMAKE_CURRENT_SOURCE_DIR}/insight)
endif()

include(GNUInstallDirs)
install(TARGETS HashPash
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# make IDEs aware of the QML import path
set(QML_IMPORT_PATH ${PROJECT_BINARY_DIR}/qml CACHE PATH
    "Path to the custom QML components defined by the project")

# ===== تنظیمات برای خروجی اندروید =====

# حداقل سطح پلتفرم اندروید
set(ANDROID_PLATFORM android-21)

# نوع معماری اندروید (armeabi-v7a, arm64-v8a, x86, x86_64)
set(ANDROID_ABI armeabi-v7a)

# افزودن تنظیمات مخصوص اندروید
if(ANDROID)
    find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick AndroidExtras)

    # تنظیمات ابزار NDK
    set(CMAKE_ANDROID_NDK_TOOLCHAIN_VERSION clang)
    set(CMAKE_SYSTEM_NAME Android)
    set(CMAKE_SYSTEM_VERSION 28)  # نسخه پلتفرم اندروید
    set(CMAKE_ANDROID_ARCH_ABI ${ANDROID_ABI})

    # مسیر خروجی کتابخانه‌های JNI (اختیاری)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/libs/${ANDROID_ABI})

    # اضافه کردن تنظیمات و وابستگی‌های مخصوص اندروید در صورت نیاز
endif()

# ===== پایان تنظیمات اندروید =====
