#include "Papyrus.h"

//void MessageHandler(SKSE::MessagingInterface::Message* a_msg)
//{
//	switch (a_msg->type) {
//	case SKSE::MessagingInterface::kDataLoaded:
//		VRInputHandler::Register();
//		break;
//
//	case SKSE::MessagingInterface::kPostLoadGame:
//		break;
//
//	default:
//		break;
//	}
//}

extern "C" DLLEXPORT bool SKSEAPI SKSEPlugin_Query(const SKSE::QueryInterface* a_skse, SKSE::PluginInfo* a_info)
{
	logger::init(Version::PROJECT);

    logger::warn("TESTING");
	
	a_info->infoVersion = SKSE::PluginInfo::kVersion;
	a_info->name = Version::PROJECT.data();
	a_info->version = Version::MAJOR;

	if (a_skse->IsEditor()) {
		logger::critical("Loaded in editor, marking as incompatible");
		return false;
	}

	const auto ver = a_skse->RuntimeVersion();
	if (ver <
#ifndef SKYRIMVR
		SKSE::RUNTIME_1_5_39
#else
		SKSE::RUNTIME_VR_1_4_15
#endif
	) {
		logger::critical(FMT_STRING("Unsupported runtime version {}"), ver.string());
		return false;
	}

	return true;
}

extern "C" DLLEXPORT bool SKSEAPI SKSEPlugin_Load(const SKSE::LoadInterface* a_skse)
{
	logger::info("loaded");

	SKSE::Init(a_skse);

	//const auto messaging = SKSE::GetMessagingInterface();
	//if (!messaging->RegisterListener("SKSE", MessageHandler))
	//	return false;

	SKSE::GetPapyrusInterface()->Register(Papyrus::RegisterFuncs);


	return true;
}
