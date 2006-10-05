-----------------------------------------------------------------------
--              GtkAda - Ada95 binding for Gtk+/Gnome                --
--                                                                   --
--                Copyright (C) 2006, AdaCore                        --
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

with Gtk.File_Chooser;   use Gtk.File_Chooser;
with Gtk.Window;         use Gtk.Window;

package body Gtk.File_Chooser_Dialog is

   -------------
   -- Gtk_New --
   -------------

   procedure Gtk_New
     (Dialog            : out Gtk_File_Chooser_Dialog;
      Title             : String;
      Parent            : access Gtk.Window.Gtk_Window_Record'Class;
      Action            : Gtk.File_Chooser.File_Chooser_Action)
   is
   begin
      Dialog := new Gtk_File_Chooser_Dialog_Record;
      Initialize (Dialog, Title, Parent, Action);
   end Gtk_New;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (Dialog            : access Gtk_File_Chooser_Dialog_Record'Class;
      Title             : String;
      Parent            : access Gtk.Window.Gtk_Window_Record'Class;
      Action            : Gtk.File_Chooser.File_Chooser_Action)
   is
      function Internal
        (Title             : String;
         Parent            : System.Address;
         Action            : File_Chooser_Action)
         return System.Address;
      pragma Import (C, Internal, "ada_gtk_file_chooser_dialog_new");
   begin
      Set_Object
        (Dialog,
         Internal (Title & ASCII.NUL, Get_Object (Parent), Action));
   end Initialize;

   --------------------------
   -- Gtk_New_With_Backend --
   --------------------------

   procedure Gtk_New_With_Backend
     (Dialog            : out Gtk_File_Chooser_Dialog;
      Title             : String;
      Parent            : access Gtk.Window.Gtk_Window_Record'Class;
      Action            : Gtk.File_Chooser.File_Chooser_Action;
      Backend           : String)
   is
   begin
      Dialog := new Gtk_File_Chooser_Dialog_Record;
      Initialize_With_Backend (Dialog, Title, Parent, Action, Backend);
   end Gtk_New_With_Backend;

   -----------------------------
   -- Initialize_With_Backend --
   -----------------------------

   procedure Initialize_With_Backend
     (Dialog            : access Gtk_File_Chooser_Dialog_Record'Class;
      Title             : String;
      Parent            : access Gtk.Window.Gtk_Window_Record'Class;
      Action            : Gtk.File_Chooser.File_Chooser_Action;
      Backend           : String)
   is
      function Internal
        (Title             : String;
         Parent            : System.Address;
         Action            : File_Chooser_Action;
         Backend           : String)
         return System.Address;
      pragma Import
        (C, Internal, "ada_gtk_file_chooser_dialog_new_with_backend");
   begin
      Set_Object
        (Dialog,
         Internal (Title & ASCII.NUL, Get_Object (Parent), Action,
                   Backend & ASCII.NUL));
   end Initialize_With_Backend;

end Gtk.File_Chooser_Dialog;
