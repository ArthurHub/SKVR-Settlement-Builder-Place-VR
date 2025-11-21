#pragma once

#define NOMMNOSOUND
#define WIN32_LEAN_AND_MEAN

#include "RE/Skyrim.h"
#include "SKSE/SKSE.h"

#include <REL/Relocation.h>

// #include <ClibUtil/simpleINI.hpp>
// #include <ClibUtil/singleton.hpp>

using namespace std::literals;

#include "skcf/Logger.h"

using namespace skcf;

// namespace string = clib_util::string;
// namespace ini = clib_util::ini;
// using namespace clib_util::singleton;

#define DLLEXPORT __declspec(dllexport)

#include "Version.h"
