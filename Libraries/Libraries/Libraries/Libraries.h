#pragma once

struct Packets {
	BYTE p1[2];
	BYTE p2[2];
	BYTE p3[8];
	BYTE p4[2];
	BYTE p5[3];
	BYTE p6[3];
};

/* ---------------------------------------------------------------------------------------------------- */

BOOL IsSigned();

/* ---------------------------------------------------------------------------------------------------- */

extern "C" __declspec(dllexport) VOID GetPackets(Packets *p);
extern "C" __declspec(dllexport) BOOL MD5(LPSTR, LPVOID);