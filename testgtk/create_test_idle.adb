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
with Gtk.Box; use Gtk.Box;
with Gtk.Button; use Gtk.Button;
with Gtk.Container; use Gtk.Container;
with Gtk.Dialog; use Gtk.Dialog;
with Gtk.Enums;  use Gtk.Enums;
with Gtk.Frame;  use Gtk.Frame;
with Gtk.Label; use Gtk.Label;
with Gtk.Main; use Gtk.Main;
with Gtk.Radio_Button; use Gtk.Radio_Button;
with Gtk.Signal; use Gtk.Signal;
with Gtk.Status_Bar; use Gtk.Status_Bar;
with Gtk.Widget; use Gtk.Widget;
with Gtk; use Gtk;
with Common; use Common;

package body Create_Test_Idle is

   package Label_Idle is new Idle (Gtk_Label);

   type My_Button_Record is new Gtk_Radio_Button_Record with record
      Value : Gtk_Resize_Mode;
   end record;
   type My_Button is access all My_Button_Record'Class;

   package My_Button_Cb is new Signal.Callback
     (My_Button_Record, Gtk_Box);

   Dialog : aliased Gtk_Dialog;
   Idle   : Guint;
   Count  : Integer := 0;

   function Idle_Test (Label : in Gtk_Label) return Boolean is
   begin
      Count := Count + 1;
      Set_Text (Label, "count:" & Integer'Image (Count));
      return True;
   end Idle_Test;

   procedure Stop_Idle (Object : access Gtk_Widget_Record) is
      pragma Warnings (Off, Object);
   begin
      if Idle /= 0 then
         Idle_Remove (Idle);
         Idle := 0;
      end if;
   end Stop_Idle;

   procedure Destroy_Idle (Window : access Gtk_Widget_Record) is
   begin
      Stop_Idle (Window);
      Dialog := null;
   end Destroy_Idle;

   procedure Start_Idle (Label : access Gtk_Label_Record) is
   begin
      if Idle = 0 then
         Idle := Label_Idle.Add (Idle_Test'Access, Gtk_Label (Label));
      end if;
   end Start_Idle;

   procedure Toggle_Container (Button : access My_Button_Record;
                               Contain : in Gtk_Box) is
   begin
      Set_Resize_Mode (Contain, Button.Value);
   end Toggle_Container;

   procedure Run (Widget : access Gtk.Button.Gtk_Button_Record) is
      Id       : Guint;
      Button   : Gtk_Button;
      Box      : Gtk_Box;
      Label    : Gtk_Label;
      Container : Gtk_Box;
      Frame    : Gtk_Frame;
      Myb      : My_Button;
      Gr       : Widget_Slist.GSList;
   begin

      if Dialog = null then
         Gtk_New (Dialog);
         Id := Widget3_Cb.Connect (Dialog, "destroy", Destroy_idle'Access);
         Set_Title (Dialog, "Idle");
         Set_Border_Width (Dialog, Border_Width => 0);

         Gtk_New (Label, "count : " & Integer'Image (Count));
         Set_Padding (Label, 10, 10);
         Show (Label);

         Gtk_New_Hbox (Container, False, 0);
         Pack_Start (Container, Label, True, True, 0);
         Show (Container);
         Pack_Start (Get_Vbox (Dialog), Container, True, True, 0);

         Gtk_New (Frame);
         Set_Border_Width (Frame, 5);
         Pack_Start (Get_Vbox (Dialog), Frame);
         Show (Frame);

         Gtk_New_Vbox (Box, False, 0);
         Add (Frame, Box);
         Show (Box);

         Myb := new My_Button_Record;
         Initialize (Myb, Widget_Slist.Null_List, "Resize-Parent");
         Myb.Value := Resize_Parent;
         Id := My_Button_Cb.Connect
           (Myb, "clicked", Toggle_Container'Access, Container);
         Show (Myb);
         Pack_Start (Box, Myb, True, True, 0);

         Gr := Group (Myb);
         Myb := new My_Button_Record;
         Initialize (Myb, Gr, "Resize-Queue");
         Myb.Value := Resize_Queue;
         Id := My_Button_Cb.Connect
           (Myb, "clicked", Toggle_Container'Access, Container);
         Show (Myb);
         Pack_Start (Box, Myb, True, True, 0);

         Gr := Group (Myb);
         Myb := new My_Button_Record;
         Initialize (Myb, Gr, "Resize-Immediate");
         Myb.Value := Resize_Immediate;
         Id := My_Button_Cb.Connect
           (Myb, "clicked", Toggle_Container'Access, Container);
         Show (Myb);
         Pack_Start (Box, Myb, True, True, 0);

         Gtk_New (Button, "close");
         Id := Widget_Cb.Connect (Button, "clicked", Destroy'Access, Dialog);
         Set_Flags (Button, Can_Default);
         Grab_Default (Button);
         Pack_Start (Get_Action_Area (Dialog), Button, True, True, 0);
         Show (Button);

         Gtk_New (Button, "start");
         Id := Label_Cb.Connect (Button, "clicked", Start_Idle'Access, Label);
         Set_Flags (Button, Can_Default);
         Pack_Start (Get_Action_Area (Dialog), Button, True, True, 0);
         Show (Button);

         Gtk_New (Button, "stop");
         Id := Widget_Cb.Connect
           (Button, "clicked", Destroy_Idle'Access, Dialog);
         Set_Flags (Button, Can_Default);
         Pack_Start (Get_Action_Area (Dialog), Button, True, True, 0);
         Show (Button);
         Show (Dialog);
      else
         Destroy (Dialog);
      end if;

   end Run;

end Create_Test_Idle;

