#include "stdafx.h"

BOOL APIENTRY DllMain(HMODULE hModule, DWORD dwReason, LPVOID lpReserved)
{
	UNREFERENCED_PARAMETER(lpReserved);

	if (dwReason == DLL_PROCESS_ATTACH)
	{
		HANDLE hMutex = OpenMutex(SYNCHRONIZE, FALSE, "Garena Cracker: Running");
		if (hMutex == NULL)
			return FALSE;

		CloseHandle(hMutex);

		if (!IsSigned())
			return FALSE;

		DisableThreadLibraryCalls(hModule);
	}

	return TRUE;
}