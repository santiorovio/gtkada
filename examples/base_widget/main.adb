with Glib; use Glib;
with Gtk.Box;    use Gtk.Box;
with Gtk.Button; use Gtk.Button;
with Gtk.Drawing_Area; use Gtk.Drawing_Area;
with Gtk.Enums; use Gtk.Enums;
with Gtk.Label; use Gtk.Label;
with Gtk.Main; use Gtk.Main;
with Gtk.Signal; use Gtk.Signal;
with Gtk.Widget; use Gtk.Widget;
with Gtk.Window; use Gtk.Window;

with My_Widget; use My_Widget;
with Text_IO;

procedure Main is

   package Target_Cb is new Gtk.Signal.Callback
     (Target_Widget_Record, String);

   procedure Won (Widget : access Target_Widget_Record;
                  Message : String) is
   begin
      Text_IO.Put_Line (Message);
   end Won;

   Main_W : Gtk_Window;
   Ok     : Target_Widget;
   Box    : Gtk_Box;
   Label  : Gtk_Label;
   Id     : Guint;

begin
   Gtk.Main.Set_Locale;
   Gtk.Main.Init;

   Gtk_New (Main_W, Window_Toplevel);

   Gtk_New_Vbox (Box, False, 0);
   Add (Main_W, Box);

   Gtk_New (Label, "The widget below was created in Ada");
   Pack_Start (Box, Label);
   Gtk_New (Label, "Try clicking in the middle or on the sides");
   Pack_Start (Box, Label);

   Gtk_New (Ok);
   Pack_Start (Box, Ok, True, True);
   Id := Target_Cb.Connect (Ok, "bullseye", Won'Access, "I won");
   Id := Target_Cb.Connect (Ok, "missed", Won'Access, "I lost");

   Show_All (Main_W);

   Gtk.Main.Main;
end Main;

