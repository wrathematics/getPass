#include <ctype.h>
#include <stdio.h>
#include <string.h>
#include <X11/Xutil.h>


#define MESSAGE_DEFAULT "PASSWORD:"

#define WINDOW_X 0
#define WINDOW_Y 0
#define WINDOW_WIDTH 300
#define WINDOW_HEIGHT 220

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
  
  XFontSet font = XCreateFontSet(display, "fixed", &missing, &nmissing, &def_string);
  XFreeStringList(missing);
  return font;
}



#define VALUEMASK (GCForeground | GCLineWidth | GCLineStyle)

static inline void write_text(char *text, int line, Display *display, Window win, XFontSet font)
{
  XGCValues values = {0};
  GC pen = XCreateGC(display, win, VALUEMASK, &values);
  int text_x = 10;
  int text_y = 10*line;
  int text_len = strlen(text);
  Xutf8DrawString(display, win, font, pen, text_x, text_y, text, text_len);
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
  
  int screen = DefaultScreen(display);
  unsigned long border = WhitePixel(display, screen);
  unsigned int background = WhitePixel(display, screen);
  
  Window win = XCreateSimpleWindow(display, DefaultRootWindow(display), WINDOW_X, WINDOW_Y, WINDOW_WIDTH, WINDOW_HEIGHT, 2, border, background);
  
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
  write_text("* Text will not print (not even masked)", 9, display, win, font);
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
