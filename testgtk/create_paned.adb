-----------------------------------------------------------------------
--          GtkAda - Ada95 binding for the Gimp Toolkit              --
--                                                                   --
--                     Copyright (C) 1998-1999                       --
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

with Glib; use Glib;
with Gdk;  use Gdk;
with Gtk.Box;    use Gtk.Box;
with Gtk.Button; use Gtk.Button;
with Gtk.Check_Button; use Gtk.Check_Button;
with Gtk.Enums; use Gtk.Enums;
with Gtk.Frame; use Gtk.Frame;
with Gtk.Label; use Gtk.Label;
with Gtk.Paned; use Gtk.Paned;
with Gtk.Signal; use Gtk.Signal;
with Gtk.Table; use Gtk.Table;
with Gtk.Widget; use Gtk.Widget;
with Gtk.Window; use Gtk.Window;
with Gtk; use Gtk;
with Common; use Common;

package body Create_Paned is

   Window : aliased Gtk.Window.Gtk_Window;

   package To_Paned is new Unchecked_Cast (Gtk_Paned_Record, Gtk_Paned);

   procedure Toggle_Resize (Child : access Gtk_Widget_Record) is
      Paned : Gtk_Paned := To_Paned.Convert (Get_Parent (Child));
      Is_Child1 : Boolean := Gtk_Widget (Child) = Get_Child1 (Paned);
      Resize : Boolean;
      Shrink : Boolean;
   begin
      if Is_Child1 then
         Resize := Get_Child1_Resize (Paned);
         Shrink := Get_Child1_Shrink (Paned);
      else
         Resize := Get_Child2_Resize (Paned);
         Shrink := Get_Child2_Shrink (Paned);
      end if;

      Ref (Child);
      --  Since we are going to remove it, we do not want
      --  to delete it.
      Remove (Paned, Child);
      if Is_Child1 then
         Pack1 (Paned, Child, not Resize, Shrink);
      else
         Pack2 (Paned, Child, not Resize, Shrink);
      end if;
      Unref (Child);
   end Toggle_Resize;

   procedure Toggle_Shrink (Child : access Gtk_Widget_Record) is
      Paned : Gtk_Paned := To_Paned.Convert (Get_Parent (Child));
      Is_Child1 : Boolean := Gtk_Widget (Child) = Get_Child1 (Paned);
      Resize : Boolean;
      Shrink : Boolean;
   begin
      if Is_Child1 then
         Resize := Get_Child1_Resize (Paned);
         Shrink := Get_Child1_Shrink (Paned);
      else
         Resize := Get_Child2_Resize (Paned);
         Shrink := Get_Child2_Shrink (Paned);
      end if;

      Ref (Child);
      --  Since we are going to remove it, we do not want
      --  to delete it.
      Remove (Paned, Child);
      if Is_Child1 then
         Pack1 (Paned, Child, Resize, not Shrink);
      else
         Pack2 (Paned, Child, Resize, not Shrink);
      end if;
      Unref (Child);
   end Toggle_Shrink;

   function Create_Pane_Options (Paned : access Gtk_Paned_Record'Class;
                                 Frame_Label : String;
                                 Label1 : String;
                                 Label2 : String)
                                 return Gtk_Frame
   is
      Frame : Gtk_Frame;
      Table : Gtk_Table;
      Label : Gtk_Label;
      Check : Gtk_Check_Button;
      Id    : Guint;
   begin
      Gtk_New (Frame, Frame_Label);
      Set_Border_Width (Frame, 4);

      Gtk_New (Table, 3, 2, False);
      Add (Frame, Table);

      Gtk_New (Label, Label1);
      Attach_Defaults (Table, Label, 0, 1, 0, 1);

      Gtk_New (Check, "Resize");
      Attach_Defaults (Table, Check, 0, 1, 1, 2);
      Id := Widget_Cb.Connect
        (Check, "toggled", Toggle_Resize'Access, Get_Child1 (Paned));

      Gtk_New (Check, "Shrink");
      Attach_Defaults (Table, Check, 0, 1, 2, 3);
      Set_Active (Check, True);
      Id := Widget_Cb.Connect
        (Check, "toggled", Toggle_Shrink'Access, Get_Child1 (Paned));

      Gtk_New (Label, Label2);
      Attach_Defaults (Table, Label, 1, 2, 0, 1);

      Gtk_New (Check, "Resize");
      Attach_Defaults (Table, Check, 1, 2, 1, 2);
      Id := Widget_Cb.Connect
        (Check, "toggled", Toggle_Resize'Access, Get_Child2 (Paned));

      Gtk_New (Check, "Shrink");
      Attach_Defaults (Table, Check, 1, 2, 2, 3);
      Set_Active (Check, True);
      Id := Widget_Cb.Connect
        (Check, "toggled", Toggle_Shrink'Access, Get_Child2 (Paned));

      return Frame;
   end Create_Pane_Options;

   procedure Run (Widget : access Gtk.Button.Gtk_Button_Record) is
      VPaned : Gtk_Paned;
      HPaned : Gtk_Paned;
      Frame  : Gtk_Frame;
      Button : Gtk_Button;
      Id     : Guint;
      Vbox   : Gtk_Box;
   begin

      if Window = null then
         Gtk_New (Window, Window_Toplevel);
         Id := Destroy_Cb.Connect
           (Window, "destroy", Destroy_Window'Access, Window'Access);
         Set_Title (Window, "Panes");
         Set_Border_Width (Window, Border_Width => 0);

         Gtk_New_Vbox (Vbox, False, 0);
         Add (Window, Vbox);

         Gtk_New_Vpaned (VPaned);
         Pack_Start (Vbox, Vpaned, True, True, 0);
         Set_Border_Width (VPaned, 5);
         Show (VPaned);

         Gtk_New_Hpaned (HPaned);
         Add1 (Vpaned, HPaned);

         Gtk_New (Frame);
         Set_Shadow_Type (Frame, Shadow_In);
         Set_Usize (Frame, 60, 60);
         Add1 (HPaned, Frame);
         Show (Frame);

         Gtk_New (Button, "Hi There");
         Add (Frame, Button);
         Show (Button);

         Gtk_New (Frame);
         Set_Shadow_Type (Frame, Shadow_In);
         Set_Usize (Frame, 80, 60);
         Add2 (HPaned, Frame);
         Show (Frame);

         Show (HPaned);

         Gtk_New (Frame);
         Set_Shadow_Type (Frame, Shadow_In);
         Set_Usize (Frame, 60, 80);
         Add2 (VPaned, Frame);

         Pack_Start (Vbox,
                     Create_Pane_Options (Hpaned, "Horizontal",
                                          "Left", "Right"),
                     False, False, 0);
         Pack_Start (Vbox,
                     Create_Pane_Options (Hpaned, "Vertical",
                                          "Top", "Bottom"),
                     False, False, 0);

         Show_All (Window);
      else
         Destroy (Window);
      end if;

   end Run;

end Create_Paned;
