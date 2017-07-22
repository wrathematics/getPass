/*  Copyright (c) 2016-2017 Drew Schmidt
    All rights reserved.
    
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
    
    1. Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
    
    2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
    
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
    TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
    PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
    CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
    EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
    PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
    PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
    LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
    NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#ifndef GETPASS_OS_H__
#define GETPASS_OS_H__


#if (defined(__WIN32) || defined(__WIN32__) || defined(_WIN64) || defined(__WIN64) || defined(__WIN64__) || defined(__TOS_WIN__) || defined(__WINNT) || defined(__WINNT__))
  #define OS_WINDOWS 1
#else
  #define OS_WINDOWS 0
#endif

#if (defined(__gnu_linux__) || defined(__linux__) || defined(__linux))
  #define OS_LINUX 1
#else
  #define OS_LINUX 0
#endif



#if OS_WINDOWS
  #include <windows.h>
  #include <conio.h>
#else
  #include <stdio.h>
  #include <stdlib.h>
  #include <termios.h>
  #include <unistd.h>
  #include <signal.h>
#endif


#endif
