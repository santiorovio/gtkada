-----------------------------------------------------------------------
--          GtkAda - Ada95 binding for the Gimp Toolkit              --
--                                                                   --
--                     Copyright (C) 2000                            --
--        Emmanuel Briot, Joel Brobecker and Arnaud Charlet          --
--                                                                   --
-- This library is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 2 of the License, or (at your option) any later version.  --
--                                                                   --
-- This library is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details.                          --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this library; if not, write to the             --
-- Free Software Foundation, Inc., 59 Temple Place - Suite 330,      --
-- Boston, MA 02111-1307, USA.                                       --
--                                                                   --
-- As a special exception, if other files instantiate generics from  --
-- this unit, or you link this unit with other files to produce an   --
-- executable, this  unit  does not  by itself cause  the resulting  --
-- executable to be covered by the GNU General Public License. This  --
-- exception does not however invalidate any other reasons why the   --
-- executable file  might be covered by the  GNU Public License.     --
-----------------------------------------------------------------------

#ifdef HAVE_LIBART

with Glib;              use Glib;
with Gtk.Frame;         use Gtk.Frame;
with Gtk.Box;           use Gtk.Box;
with Gtk.Drawing_Area;  use Gtk.Drawing_Area;
with Gdk.Pixbuf;        use Gdk.Pixbuf;
with Gtk.Handlers;      use Gtk.Handlers;
with Gtk.Style;         use Gtk.Style;
with Gtk.Widget;        use Gtk.Widget;
with Gdk.Rgb;           use Gdk.Rgb;
with Gtk.Label;         use Gtk.Label;

#endif

package body Libart_Demo is

#ifdef HAVE_LIBART

   --------------------------
   --  The type below is a special drawing area that displays the
   --  associated image in it automatically, and destroys the image
   --  when the widget is destroyed.
   ---------------------------

   type Image_Drawing_Record is new Gtk.Box.Gtk_Box_Record
     with record
        Area : Gtk.Drawing_Area.Gtk_Drawing_Area;
        Pix  : Gdk.Pixbuf.Gdk_Pixbuf;
     end record;
   type Image_Drawing is access all Image_Drawing_Record'Class;
   --  A special type of drawing area that can be associated with
   --  an image.

   procedure Gtk_New (Draw   : out Image_Drawing;
                      Pixbuf : in Gdk.Pixbuf.Gdk_Pixbuf;
                      Title  : in String);

   ------------------------
   -- Callbacks packages --
   ------------------------

   package Expose_Cb is new Gtk.Handlers.Return_Callback
     (Image_Drawing_Record, Boolean);

   package Destroy_Cb is new Gtk.Handlers.Callback
     (Image_Drawing_Record);

   -------------
   -- Destroy --
   -------------

   procedure Destroy (Draw : access Image_Drawing_Record'Class) is
   begin
      --  Destroy the associated image
      Unref (Draw.Pix);
   end Destroy;

   ------------
   -- Expose --
   ------------

   function Expose (Draw : access Image_Drawing_Record'Class)
                   return Boolean
   is
   begin
      Render_To_Drawable (Draw.Pix,
                          Get_Window (Draw.Area),
                          Gtk.Style.Get_Black_Gc (Get_Style (Draw.Area)),
                          0, 0,
                          0, 0,
                          Get_Width (Draw.Pix), Get_Height (Draw.Pix),
                          Dither_Normal,
                          0, 0);
      return False;
   end Expose;

   -------------
   -- Gtk_New --
   -------------

   procedure Gtk_New (Draw   : out Image_Drawing;
                      Pixbuf : in Gdk_Pixbuf;
                      Title  : in String)
   is
      Label           : Gtk_Label;
   begin
      --  The drawing area MUST be created with Gdk.Rgb colormap,
      --  otherwise the image can not be rendered correctly.

      Gtk.Widget.Push_Colormap (Gdk.Rgb.Get_Cmap);
      Gtk.Widget.Push_Visual   (Gdk.Rgb.Get_Visual);

      Draw := new Image_Drawing_Record;
      Initialize_Vbox (Draw, Homogeneous => False, Spacing => 0);

      Gtk_New (Label, Title);
      Pack_Start (Draw, Label, Expand => False, Fill => False);

      Draw.Pix := Pixbuf;
      Set_Usize (Draw,
                 Get_Width (Draw.Pix),
                 Get_Height (Draw.Pix) + Gint (Get_Allocation_Height (Label)));

      Gtk_New (Draw.Area);
      Pack_Start (Draw, Draw.Area);

      Expose_Cb.Connect (Draw, "expose_event",
                         Expose_Cb.To_Marshaller (Expose'Access));
      Destroy_Cb.Connect (Draw, "destroy",
                          Destroy_Cb.To_Marshaller (Destroy'Access));

      Gtk.Widget.Pop_Colormap;
      Gtk.Widget.Pop_Visual;

   end Gtk_New;

   ---------
   -- Run --
   ---------

   procedure Run (Frame : access Gtk.Frame.Gtk_Frame_Record'Class) is
      VBox            : Gtk_Box;
      Hbox            : Gtk_Box;
      Pix, Pix2, Pix3 : Gdk_Pixbuf;
      Draw            : Image_Drawing;
   begin
      Gtk_New_Vbox (Vbox, Homogeneous => False, Spacing => 0);
      Add (Frame, Vbox);

      Gtk_New_Hbox (Hbox, Homogeneous => False, Spacing => 0);
      Pack_Start (Vbox, Hbox);

      --  We must initialize Gdk.Rgb first.
      Gdk.Rgb.Init;

      --  Creating the images.
      --  We use the BMP format since it does not require any external
      --  libraries to load these files. But if the libjpeg is installed
      --  on the system, we could as well use JPEG images.

      Pix := New_From_File ("alps.bmp");
      Pix2 := Scale_Simple
        (Pix,
         Gint (550) - Get_Width (Pix),
         Get_Height (Pix) / 2);
      Pix3 := New_From_File ("lightning.bmp");
      Composite (Src         => Pix,
                 Dest        => Pix3,
                 Dest_X      => 0,
                 Dest_Y      => 0,
                 Scale_X     => 0.5,
                 Scale_Y     => 0.5,
                 Dest_Width  => Get_Width (Pix3),
                 Dest_Height => Get_Height (Pix3),
                 Overall_Alpha => 128);

      --  Creating the canvases
      Gtk_New (Draw, Pix, "Initial Image");
      Pack_Start (Hbox, Draw, Expand => False, Fill => True);

      Gtk_New (Draw, Pix2, "Scaled Image");
      Pack_Start (Hbox, Draw, Expand => False, Fill => True);

      Gtk_New (Draw, Pix3, "Composite Image with Opacity"
               & ASCII.LF
               & "This image is the addition of two simpler images");
      Pack_Start (Vbox, Draw);

      Show_All (Frame);
   end Run;


#else

   procedure Run (Frame : access Gtk.Frame.Gtk_Frame_Record'Class) is
      Label : Gtk_Label;
   begin
      Gtk_New (Label, "Libart and Gdk_Pixbuf have not been installed on this"
               & " system");
      Add (Frame, Label);
      Show_All (Frame);
   end Run;

#endif

end Libart_Demo;
