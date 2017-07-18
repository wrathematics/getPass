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


#include "getPass.h"
#include "platform.h"


#define CTRLC_NO 0
#define CTRLC_YES 1

#define PWLEN 256
char pw[PWLEN];

int ctrlc;

#if !(OS_WINDOWS)
static void ctrlc_handler(int signal)
{
  ctrlc = 1;
}
#endif



SEXP getPass_readline_masked(SEXP msg, SEXP showstars_, SEXP noblank_)
{
  SEXP ret;
  const int showstars = INTEGER(showstars_)[0];
  const int noblank = INTEGER(noblank_)[0];
  int i = 0;
  int j;
  char c;
  ctrlc = CTRLC_NO; // must be global!
  
  REprintf(CHARPT(msg, 0));
  
#if !(OS_WINDOWS)
  struct termios tp, old;
  tcgetattr(STDIN_FILENO, &tp);
  old = tp;
  tp.c_lflag &= ~(ECHO | ICANON | ISIG);
  tcsetattr(0, TCSAFLUSH, &tp);

  #if OS_LINUX
    signal(SIGINT, ctrlc_handler);
  #else
    struct sigaction sa;
    sa.sa_handler = ctrlc_handler;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0;
    sigaction(SIGINT, &sa, NULL);
  #endif
  
#endif
  
  for (i=0; i<PWLEN; i++)
  {
#if OS_WINDOWS
    c = _getch();
#else
    c = fgetc(stdin);
#endif
    
    // newline
    if (c == '\n' || c == '\r')
    {
      if (noblank && i == 0)
      {
        i--;
        continue;
      }
      else
        break;
    }
    // backspace
    else if (c == '\b' || c == '\177')
    {
      if (i == 0)
      {
        i--;
        continue;
      }
      else
      {
        if (showstars)
          REprintf("\b \b");
        
        pw[--i] = '\0';
        i--;
      }
    }
    // C-c
    else if (ctrlc == CTRLC_YES || c == 3 || c == '\xff')
    {
#if !(OS_WINDOWS)
      tcsetattr(0, TCSANOW, &old);
#endif
      REprintf("\n");
      return R_NilValue;
    }
    // store value
    else
    {
      if (showstars)
        REprintf("*");
      
      pw[i] = c;
    }
  }

#if !(OS_WINDOWS)
  tcsetattr(0, TCSANOW, &old);
#endif
  
  if (i == PWLEN)
  {
    REprintf("\n");
    error("character limit exceeded");
  }
  
  if (showstars || strncmp(CHARPT(msg, 0), "", 1) != 0)
    REprintf("\n");
  
  PROTECT(ret = allocVector(STRSXP, 1));
  SET_STRING_ELT(ret, 0, mkCharLen(pw, i));
  
  for (j=0; j<i; j++)
    pw[j] = '\0';
  
  UNPROTECT(1);
  return ret;
}
