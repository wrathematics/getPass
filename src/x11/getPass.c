/*  Copyright (c) 2019 Drew Schmidt
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

#include <ctype.h>
#include <stdio.h>
#include <string.h>
#include <X11/Xutil.h>


#define MESSAGE_DEFAULT "PASSWORD:"

#define WINDOW_WIDTH 300
#define WINDOW_HEIGHT 220
#define WINDOW_BORDER_WIDTH 2

#define BASE_FONT_NAME_LIST "-*-*-*-R-Normal--*-100-100-100-*-*,fixed"
#define GRAPHICS_CONTEXT_VALUEMASK (GCForeground | GCLineWidth | GCLineStyle)

#define ERROR_DISPLAY -1
#define ERROR_TOOBIG -2

#define PWLEN 256
char pw[PWLEN];


static inline void clearstr(const int len, char *s)
{
  for (int i=0; i<len; i++)
    s[i] = '\0';
}



static inline XFontSet get_default_font(Display *display)
{
  int nmissing;
  char **missing;
  char *def_string;
  
  XFontSet font = XCreateFontSet(display, BASE_FONT_NAME_LIST, &missing, &nmissing, &def_string);
  XFreeStringList(missing);
  return font;
}



static inline void write_text(char *text, int line, Display *display, Window win, XFontSet font)
{
  XGCValues values = {0};
  GC pen = XCreateGC(display, win, GRAPHICS_CONTEXT_VALUEMASK, &values);
  int text_x = 10;
  int text_y = 10*line;
  int text_len = strlen(text);
  
  XSetForeground(display, pen, 0);
  
#if X_HAVE_UTF8_STRING
  XmbDrawString(display, win, font, pen, text_x, text_y, text, text_len);
#else
  Xutf8DrawString(display, win, font, pen, text_x, text_y, text, text_len);
#endif
}



int main(int argc, char **argv)
{
  XEvent event;
  
  // open display and create box
  Display *display = XOpenDisplay(NULL);
  if (!display)
  {
    fprintf(stderr, "ERROR: can't connect to display\n");
    return ERROR_DISPLAY;
  }
  
  int screen_number = DefaultScreen(display);
  unsigned long border = WhitePixel(display, screen_number);
  unsigned int background = WhitePixel(display, screen_number);
  
  Display *disp = XOpenDisplay(NULL);
  Screen *s = DefaultScreenOfDisplay(disp);
  int w_x = XWidthOfScreen(s) / 2;
  int w_y = XHeightOfScreen(s) / 2;
  
  Window win = XCreateSimpleWindow(display, DefaultRootWindow(display), w_x, w_y, WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_BORDER_WIDTH, border, background);
  
  XSelectInput(display, win, ButtonPressMask|StructureNotifyMask|KeyPressMask|KeyReleaseMask|KeymapStateMask);
  XMapWindow(display, win);
  
  
  // write msg to box
  char *msg;
  if (argc == 1)
    msg = MESSAGE_DEFAULT;
  else
    msg = argv[2];
  
  XFontSet font = get_default_font(display);
  
  write_text(msg, 2, display, win, font);
  
  write_text("Press enter to confirm or click anywhere", 5, display, win, font);
  write_text("in the window interior to cancel", 6, display, win, font);
  
  write_text("Note:", 8, display, win, font);
  write_text("* No text will print", 9, display, win, font);
  write_text("* There is no clipboard support", 10, display, win, font);
  
  
  // read keypresses
  clearstr(PWLEN, pw);
  int ind = 0;
  while (1)
  {
    if (ind == PWLEN)
    {
      fprintf(stderr, "ERROR: character limit exceeded\n");
      return ERROR_TOOBIG;
    }
    
    XNextEvent(display, &event);
    
    if (event.type == KeyPress)
    {
      char c;
      KeySym keysym;
      XLookupString(&event.xkey, &c, 1, &keysym, NULL);
      
      if (isascii(c))
      {
        if (c == '\n' || c == '\r')
          break;
        else if (c == '\b' || c == '\177')
        {
          if (ind > 0)
            ind--;
          
          pw[ind] = '\0';
        }
        else if (!iscntrl(c))
          pw[ind++] = c;  
      }
    }
    else if (event.type == ButtonPress)
    {
      if (ind > 0)
        clearstr(PWLEN, pw);
      
      break;
    }
  }
  
  XCloseDisplay(display);
  
  printf("%s\n", pw);
  clearstr(PWLEN, pw);
  return 0;
}
