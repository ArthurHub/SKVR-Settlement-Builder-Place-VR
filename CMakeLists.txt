cmake_minimum_required(VERSION 3.23)


# >>> Project
set(NAME "Settlement-Builder-Placer-VR")
set(FRIENDLY_NAME "Settlement Builder Placer VR")
set(VERSION 0.1.0)


# >>> Folders
set(ROOT_DIR  "${CMAKE_CURRENT_SOURCE_DIR}")
set(SOURCE_DIR "${ROOT_DIR}/src")
set(BUILD_DIR "${CMAKE_CURRENT_BINARY_DIR}")

# >>> Include guards
if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
  message(FATAL_ERROR ">> In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there.")
endif()

# >>> Set variable from environment by same name
macro(set_from_environment VARIABLE)
  if(NOT DEFINED ${VARIABLE} AND DEFINED ENV{${VARIABLE}})
    set(${VARIABLE} $ENV{${VARIABLE}})
  endif()
endmacro()


# >>> Setup vcpkg
set_from_environment(VCPKG_ROOT)
if(DEFINED VCPKG_ROOT)
  set(CMAKE_TOOLCHAIN_FILE "${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake" CACHE STRING "")
  set(VCPKG_TARGET_TRIPLET "x64-windows-static" CACHE STRING "")
  set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>" CACHE STRING "")
else()
  message(FATAL_ERROR ">> Variable VCPKG_ROOT is not set!")
endif()

# >>> CommonLibVR: locate and add
set_from_environment(CommonLibVRPath)
find_path(CommonLibVRPathFind
  NAMES "include/REL/Relocation.h"
  HINTS
    "${CMAKE_CURRENT_LIST_DIR}/external/CommonLibVR" # nested under the framework
    "${CMAKE_CURRENT_LIST_DIR}/CommonLibVR"
    "${CMAKE_SOURCE_DIR}/external/CommonLibVR"       # sibling to the framework in the parent project
    "${CMAKE_SOURCE_DIR}/CommonLibVR"
    "${CMAKE_SOURCE_DIR}/../CommonLibVR"
    "${CommonLibVR_ROOT}"
    "${CommonLibVRPath}"
)
if(${CommonLibVRPathFind} STREQUAL "CommonLibVRPathFind-NOTFOUND")
  message(FATAL_ERROR ">> CommonLibVR path not found! Did you init submodules or set CommonLibVRPath?")
endif()

# >>> Create Project
project(${NAME} VERSION ${VERSION} LANGUAGES CXX)
message(">>> Building '${PROJECT_NAME}' v:${PROJECT_VERSION}")
message(">>> Using ROOT_DIR: '${ROOT_DIR}'")
message(">>> Using SOURCE_DIR: '${SOURCE_DIR}'")
message(">>> Using BUILD_DIR: '${BUILD_DIR}'")
message(">>> Using CommonLibVR: '${CommonLibVRPathFind}'")


# >>> Build flags
add_compile_definitions(_CRT_SECURE_NO_WARNINGS)
set(Boost_USE_STATIC_RUNTIME OFF CACHE BOOL "")
set(Boost_USE_STATIC_LIBS ON)
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_DEBUG OFF)

# >>> Configure CommonLib for Skyrim VR
add_compile_definitions(SKYRIMVR)
# >>> Bring in the framework (it brings CommonLibVR transitively)
add_subdirectory(${CommonLibVRPathFind} "CommonLibVR" EXCLUDE_FROM_ALL)

# >>> Version & resource files
configure_file(${ROOT_DIR}/cmake/version.rc.in  ${BUILD_DIR}/version.rc  @ONLY)
configure_file(${ROOT_DIR}/cmake/Version.h.in   ${BUILD_DIR}/include/Version.h @ONLY)
configure_file(${ROOT_DIR}/cmake/resources.rc.in ${BUILD_DIR}/resources.rc @ONLY)
source_group(TREE ${BUILD_DIR} FILES ${BUILD_DIR}/include/Version.h ${BUILD_DIR}/resources.rc)

# >>> Sources
file(GLOB_RECURSE headers CONFIGURE_DEPENDS "${SOURCE_DIR}/*.h")
file(GLOB_RECURSE sources CONFIGURE_DEPENDS "${SOURCE_DIR}/*.cpp")
file(GLOB_RECURSE inls    CONFIGURE_DEPENDS "${SOURCE_DIR}/*.inl")
source_group(TREE ${ROOT_DIR} FILES ${headers} ${sources} ${inls})

# >>> Resource files
list(APPEND resource_files
  "${ROOT_DIR}/data/config/${NAME}.ini"
)

# >>> Target (DLL)
add_library(${PROJECT_NAME} SHARED
  ${headers}
  ${sources}
  ${inls}
  ${resource_files}
  ${BUILD_DIR}/include/Version.h
  ${BUILD_DIR}/version.rc
  ${BUILD_DIR}/resources.rc
  "${ROOT_DIR}/.clang-format"
  "${ROOT_DIR}/.editorconfig"
)

# >>> C++ standard & defs
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_23)
target_compile_definitions(${PROJECT_NAME} PRIVATE _UNICODE)

# >>> Includes
target_include_directories(${PROJECT_NAME}
  PRIVATE
    ${BUILD_DIR}/include
    ${SOURCE_DIR}
)

# >>> Dependencies
target_link_directories(${PROJECT_NAME} PRIVATE
    ${ROOT_DIR}/external/CommonLibVR/extern/openvr/lib/win64
)
# Link only the framework; it re-exports CommonLibVR and other usage requirements.
target_link_libraries(${PROJECT_NAME}
  PRIVATE
    CommonLibVR::CommonLibVR
    openvr_api
)

# cpptrace via vcpkg
find_package(cpptrace CONFIG REQUIRED)
target_link_libraries(${PROJECT_NAME} PRIVATE cpptrace::cpptrace)

# >>> PCH
target_precompile_headers(${PROJECT_NAME} PRIVATE src/PCH.h)

# >>> Compile / Link options
target_compile_options(${PROJECT_NAME}
  PRIVATE
    /sdl # Enable Additional Security Checks
	/utf-8 # Set Source and Executable character sets to UTF-8
	/Zi # Debug Information Format

	/permissive- # Standards conformance

	/Zc:alignedNew # C++17 over-aligned allocation
	/Zc:auto # Deduce Variable Type
	/Zc:char8_t
	/Zc:__cplusplus # Enable updated __cplusplus macro
	/Zc:externC
	/Zc:externConstexpr # Enable extern constexpr variables
	/Zc:forScope # Force Conformance in for Loop Scope
	/Zc:hiddenFriend
	/Zc:implicitNoexcept # Implicit Exception Specifiers
	/Zc:lambda
	/Zc:noexceptTypes # C++17 noexcept rules
	/Zc:preprocessor # Enable preprocessor conformance mode
	/Zc:referenceBinding # Enforce reference binding rules
	/Zc:rvalueCast # Enforce type conversion rules
	/Zc:sizedDealloc # Enable Global Sized Deallocation Functions
	/Zc:strictStrings # Disable string literal type conversion
	/Zc:ternary # Enforce conditional operator rules
	/Zc:threadSafeInit # Thread-safe Local Static Initialization
	/Zc:tlsGuards
	/Zc:trigraphs # Trigraphs Substitution
	/Zc:wchar_t # wchar_t Is Native Type

	/external:anglebrackets
	/external:W0

    /W4 # Warning level
    "$<$<CONFIG:RELEASE>:/Zc:inline;/JMC-;/Ob3>"
)

target_link_options(${PROJECT_NAME}
  PRIVATE
    /WX # Treat Linker Warnings as Errors
    "$<$<CONFIG:DEBUG>:/INCREMENTAL;/OPT:NOREF;/OPT:NOICF>"
    "$<$<CONFIG:RELEASE>:/INCREMENTAL:NO;/OPT:REF;/OPT:ICF;/DEBUG:FULL>"
)

# >>> fix a warning with /Ob2 being overridden with /Ob3
string(REPLACE "/Ob2" "/Ob3" CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}")

# >>> Post build command to copy plugins (supports multiple paths separated by ';')
if(POST_BUILD_COPY_PLUGIN)
  if(DEFINED COPY_PLUGIN_BASE_PATH)
    # Treat semicolon-separated COPY_PLUGIN_BASE_PATH as a CMake list
    set(COPY_PLUGIN_PATH_LIST ${COPY_PLUGIN_BASE_PATH})

    message(">>> Create post build command: copy targets to:")
    foreach(copy_path IN LISTS COPY_PLUGIN_PATH_LIST)
      message("    ${copy_path}/SKSE/Plugins/")
      add_custom_command(
        TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMENT "Copying ${PROJECT_NAME}.dll and .pdb to plugins folder: '${copy_path}/SKSE/Plugins/'"
        COMMAND ${CMAKE_COMMAND} -E make_directory ${copy_path}/SKSE/Plugins/
        COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${PROJECT_NAME}> ${copy_path}/SKSE/Plugins/
        COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_PDB_FILE:${PROJECT_NAME}> ${copy_path}/SKSE/Plugins/
      )
    endforeach()
  else()
    message(FATAL_ERROR "Variable 'COPY_PLUGIN_BASE_PATH' is not defined but 'POST_BUILD_COPY_PLUGIN' is true!")
  endif()
else()
  message(">>> No post build copy")
endif()

# >>> Post build for release only to package the mod into a .7z file
message(">>> Create post build command: package mod on release build")
add_custom_command(
  TARGET ${PROJECT_NAME}
  POST_BUILD
  COMMAND ${CMAKE_COMMAND}
          -DPROJECT_NAME=${PROJECT_NAME}
          -DPROJECT_FRIENDLY_NAME=${FRIENDLY_NAME}
          -DPROJECT_VERSION=${PROJECT_VERSION}
          -DROOT_DIR=${ROOT_DIR}
          -DBUILD_DIR=${BUILD_DIR}
          -DTARGET_FILE="$<TARGET_FILE:${PROJECT_NAME}>"
          -DTARGET_PDB_FILE="$<TARGET_PDB_FILE:${PROJECT_NAME}>"
          -DCONFIG=$(Configuration)
          -P "${ROOT_DIR}/cmake/package.cmake"
)
