#include "stdafx.h"

BOOL IsSigned()
{
	CHAR szFilePath[MAX_PATH];
	GetModuleFileName(NULL, szFilePath, MAX_PATH);

	FILE *hFile;
	if (fopen_s(&hFile, szFilePath, "rb") != NO_ERROR)
		return FALSE;

	if (fseek(hFile, -8192, SEEK_END) != NO_ERROR)
	{
		fclose(hFile);
		return FALSE;
	}

	LPSTR szBuffer = (LPSTR)VirtualAlloc(NULL, 128, MEM_COMMIT, PAGE_READWRITE);
	if (fread(szBuffer, 1, 128, hFile) != 128)
	{
		VirtualFree(szBuffer, NULL, MEM_RELEASE);
		fclose(hFile);
		return FALSE;
	}

	fclose(hFile);

	CHAR szSignature[] =
		"\x31\x33\x37\x30\x31\x31\x31\x32\x7F\x86\x1D\x2C\x42\xE9\xFD\xD9"
		"\xC5\x83\x69\xE6\xEA\xD0\x48\xC3\x5E\x26\x35\x43\x98\x6F\x79\x04"
		"\xDC\x2A\xEE\xBF\x71\x19\x72\x9A\xC9\x89\xC6\xDF\x7A\x3D\xF3\x14"
		"\x1B\x2F\x7A\x41\x2F\x7C\xDC\x09\xC7\xA8\x9C\x0B\x53\xDD\xAC\x03"
		"\xDF\x58\xBB\xE9\x62\x26\xCB\xD3\xFD\x8B\x9D\x69\x83\xAC\xEF\x3A"
		"\xC0\x24\x88\xD8\xF8\x36\xFF\xA1\xC6\x84\xF8\xA1\xA9\x94\x1C\xFB"
		"\xE1\x08\x8D\x11\x24\x97\xAE\x7A\xBB\xC4\xDB\x84\x54\x19\xCB\x67"
		"\xC3\x81\x2D\x00\xD9\xC9\xFA\xDD\x31\x33\x37\x30\x31\x31\x31\x32";

	for (int i = 0; i < 128; i++)
	{
		if (szSignature[i] != szBuffer[i])
		{
			VirtualFree(szBuffer, NULL, MEM_RELEASE);
			return FALSE;
		}
	}

	VirtualFree(szBuffer, NULL, MEM_RELEASE);
	return TRUE;
}

/* ---------------------------------------------------------------------------------------------------- */

VOID GetPackets(Packets *p)
{
	CopyMemory(p->p1, "\x02\x0A", 2);
	CopyMemory(p->p2, "\x12\x20", 2);
	CopyMemory(p->p3, "\x18\x01\x22\x01\x31\x28\xE4\x4F", 8);
	CopyMemory(p->p4, "\x02\x0A", 2);
	CopyMemory(p->p5, "\x20\x08\x01", 3);
	CopyMemory(p->p6, "\x20\x08\x02", 3);
}

BOOL MD5(LPSTR szInput, LPVOID lpBuffer)
{
	HCRYPTPROV hProv;
	if (!CryptAcquireContext(&hProv, NULL, NULL, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT))
		return FALSE;

	HCRYPTHASH hHash;
	if (!CryptCreateHash(hProv, CALG_MD5, NULL, 0, &hHash))
	{
		CryptReleaseContext(hProv, 0);
		return FALSE;
	}

	if (!CryptHashData(hHash, (LPBYTE)szInput, strlen(szInput), 0))
	{
		CryptDestroyHash(hHash);
		CryptReleaseContext(hProv, 0);
		return FALSE;
	}

	DWORD dwLength = 16;
	if (!CryptGetHashParam(hHash, HP_HASHVAL, (LPBYTE)lpBuffer, &dwLength, 0))
	{
		CryptDestroyHash(hHash);
		CryptReleaseContext(hProv, 0);
		return FALSE;
	}

	CryptDestroyHash(hHash);
	CryptReleaseContext(hProv, 0);

	return TRUE;
}