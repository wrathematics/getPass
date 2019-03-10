// Uses CredUIPromptForCredentials() for password entry. See:
// https://docs.microsoft.com/en-us/windows/desktop/api/wincred/nf-wincred-creduipromptforcredentialsa
// 
// Taken largely from the following Microsoft example:
// https://github.com/Microsoft/Windows-classic-samples/blob/1d363ff4bd17d8e20415b92e2ee989d615cc0d91/Samples/Win7Samples/sysmgmt/tasksched/emailonevent/EventTrigger_EmailAction_UserLogon_Example.cpp
// 
// Original license is as follows:
// 
// Copyright (c) Microsoft Corporation
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
// 
// Portions of this repo are provided under the SIL Open Font License.
// See the LICENSE file in individual samples for additional details.

#define _WIN32_DCOM

#include <windows.h>
#include <stdio.h>
#include <comdef.h>
#include <wincred.h>

#include <string>


#define MESSAGE_DEFAULT "PASSWORD:"
#define TITLEBAR_TEXT "getPass::getPass()"
#define PWLEN CREDUI_MAX_PASSWORD_LENGTH
#define CREDENTIALS_FLAGS (CREDUI_FLAGS_GENERIC_CREDENTIALS | CREDUI_FLAGS_ALWAYS_SHOW_UI | CREDUI_FLAGS_DO_NOT_PERSIST | CREDUI_FLAGS_KEEP_USERNAME)


static inline void clearstr(const int len, char *s)
{
  for (int i=0; i<len; i++)
    s[i] = '\0';
}



int main(int argc, char **argv)
{
  CREDUI_INFO cui;
  DWORD err;
  BOOL save_checkbox = FALSE;
  TCHAR target[1] = TEXT("");
  TCHAR user[3] = TEXT("NA");
  TCHAR pw[PWLEN];
  TCHAR *msg;
  int noblank = argv[1][0] == 'T' ? 1 : 0;
  
  if (argc == 2)
    msg = (char*) std::string(MESSAGE_DEFAULT).c_str();
  else
    msg = TEXT(argv[2]);
  
  cui.cbSize = sizeof(CREDUI_INFO);
  cui.hwndParent = NULL;
  cui.pszMessageText = TEXT(msg);
  cui.pszCaptionText = TEXT(TITLEBAR_TEXT);
  cui.hbmBanner = NULL;
  
  int getpass = 1;
  while (getpass)
  {
    clearstr(PWLEN, pw);
    err = CredUIPromptForCredentials(&cui, target, NULL, 0, user, 0, pw, PWLEN, &save_checkbox, CREDENTIALS_FLAGS);  
    
    if (noblank && pw[0] == '\0')
      MessageBox(NULL, "No blank input please!", TITLEBAR_TEXT, MB_ICONWARNING | MB_SETFOREGROUND);
    else
      getpass = 0;
  }
  
  printf("%s\n", pw);
  clearstr(PWLEN, pw);
  return 0;
}
