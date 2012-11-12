------------------------------------------------------------------------------
--                                                                          --
--      Copyright (C) 1998-2000 E. Briot, J. Brobecker and A. Charlet       --
--                     Copyright (C) 2000-2012, AdaCore                     --
--                                                                          --
-- This library is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. This library is distributed in the hope that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
------------------------------------------------------------------------------

pragma Style_Checks (Off);
pragma Warnings (Off, "*is already use-visible*");
with Glib.Type_Conversion_Hooks; use Glib.Type_Conversion_Hooks;
with Gtkada.Bindings;            use Gtkada.Bindings;
with Interfaces.C.Strings;       use Interfaces.C.Strings;

package body Gtk.Print_Operation is

   package Type_Conversion_Gtk_Print_Operation is new Glib.Type_Conversion_Hooks.Hook_Registrator
     (Get_Type'Access, Gtk_Print_Operation_Record);
   pragma Unreferenced (Type_Conversion_Gtk_Print_Operation);

   -------------
   -- Gtk_New --
   -------------

   procedure Gtk_New (Self : out Gtk_Print_Operation) is
   begin
      Self := new Gtk_Print_Operation_Record;
      Gtk.Print_Operation.Initialize (Self);
   end Gtk_New;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
      (Self : not null access Gtk_Print_Operation_Record'Class)
   is
      function Internal return System.Address;
      pragma Import (C, Internal, "gtk_print_operation_new");
   begin
      Set_Object (Self, Internal);
   end Initialize;

   ------------
   -- Cancel --
   ------------

   procedure Cancel (Self : not null access Gtk_Print_Operation_Record) is
      procedure Internal (Self : System.Address);
      pragma Import (C, Internal, "gtk_print_operation_cancel");
   begin
      Internal (Get_Object (Self));
   end Cancel;

   ----------------------
   -- Draw_Page_Finish --
   ----------------------

   procedure Draw_Page_Finish
      (Self : not null access Gtk_Print_Operation_Record)
   is
      procedure Internal (Self : System.Address);
      pragma Import (C, Internal, "gtk_print_operation_draw_page_finish");
   begin
      Internal (Get_Object (Self));
   end Draw_Page_Finish;

   ----------------------------
   -- Get_Default_Page_Setup --
   ----------------------------

   function Get_Default_Page_Setup
      (Self : not null access Gtk_Print_Operation_Record)
       return Gtk.Page_Setup.Gtk_Page_Setup
   is
      function Internal (Self : System.Address) return System.Address;
      pragma Import (C, Internal, "gtk_print_operation_get_default_page_setup");
      Stub_1996 : Gtk.Page_Setup.Gtk_Page_Setup_Record;
   begin
      return Gtk.Page_Setup.Gtk_Page_Setup (Get_User_Data (Internal (Get_Object (Self)), Stub_1996));
   end Get_Default_Page_Setup;

   --------------------------
   -- Get_Embed_Page_Setup --
   --------------------------

   function Get_Embed_Page_Setup
      (Self : not null access Gtk_Print_Operation_Record) return Boolean
   is
      function Internal (Self : System.Address) return Integer;
      pragma Import (C, Internal, "gtk_print_operation_get_embed_page_setup");
   begin
      return Boolean'Val (Internal (Get_Object (Self)));
   end Get_Embed_Page_Setup;

   ---------------
   -- Get_Error --
   ---------------

   procedure Get_Error (Self : not null access Gtk_Print_Operation_Record) is
      procedure Internal (Self : System.Address);
      pragma Import (C, Internal, "gtk_print_operation_get_error");
   begin
      Internal (Get_Object (Self));
   end Get_Error;

   -----------------------
   -- Get_Has_Selection --
   -----------------------

   function Get_Has_Selection
      (Self : not null access Gtk_Print_Operation_Record) return Boolean
   is
      function Internal (Self : System.Address) return Integer;
      pragma Import (C, Internal, "gtk_print_operation_get_has_selection");
   begin
      return Boolean'Val (Internal (Get_Object (Self)));
   end Get_Has_Selection;

   --------------------------
   -- Get_N_Pages_To_Print --
   --------------------------

   function Get_N_Pages_To_Print
      (Self : not null access Gtk_Print_Operation_Record) return Gint
   is
      function Internal (Self : System.Address) return Gint;
      pragma Import (C, Internal, "gtk_print_operation_get_n_pages_to_print");
   begin
      return Internal (Get_Object (Self));
   end Get_N_Pages_To_Print;

   ------------------------
   -- Get_Print_Settings --
   ------------------------

   function Get_Print_Settings
      (Self : not null access Gtk_Print_Operation_Record)
       return Gtk.Print_Settings.Gtk_Print_Settings
   is
      function Internal (Self : System.Address) return System.Address;
      pragma Import (C, Internal, "gtk_print_operation_get_print_settings");
      Stub_2002 : Gtk.Print_Settings.Gtk_Print_Settings_Record;
   begin
      return Gtk.Print_Settings.Gtk_Print_Settings (Get_User_Data (Internal (Get_Object (Self)), Stub_2002));
   end Get_Print_Settings;

   ----------------
   -- Get_Status --
   ----------------

   function Get_Status
      (Self : not null access Gtk_Print_Operation_Record)
       return Gtk_Print_Status
   is
      function Internal (Self : System.Address) return Gtk_Print_Status;
      pragma Import (C, Internal, "gtk_print_operation_get_status");
   begin
      return Internal (Get_Object (Self));
   end Get_Status;

   -----------------------
   -- Get_Status_String --
   -----------------------

   function Get_Status_String
      (Self : not null access Gtk_Print_Operation_Record) return UTF8_String
   is
      function Internal
         (Self : System.Address) return Interfaces.C.Strings.chars_ptr;
      pragma Import (C, Internal, "gtk_print_operation_get_status_string");
   begin
      return Gtkada.Bindings.Value_Allowing_Null (Internal (Get_Object (Self)));
   end Get_Status_String;

   ---------------------------
   -- Get_Support_Selection --
   ---------------------------

   function Get_Support_Selection
      (Self : not null access Gtk_Print_Operation_Record) return Boolean
   is
      function Internal (Self : System.Address) return Integer;
      pragma Import (C, Internal, "gtk_print_operation_get_support_selection");
   begin
      return Boolean'Val (Internal (Get_Object (Self)));
   end Get_Support_Selection;

   -----------------
   -- Is_Finished --
   -----------------

   function Is_Finished
      (Self : not null access Gtk_Print_Operation_Record) return Boolean
   is
      function Internal (Self : System.Address) return Integer;
      pragma Import (C, Internal, "gtk_print_operation_is_finished");
   begin
      return Boolean'Val (Internal (Get_Object (Self)));
   end Is_Finished;

   ---------
   -- Run --
   ---------

   function Run
      (Self   : not null access Gtk_Print_Operation_Record;
       Action : Gtk_Print_Operation_Action;
       Parent : access Gtk.Window.Gtk_Window_Record'Class)
       return Gtk_Print_Operation_Result
   is
      function Internal
         (Self   : System.Address;
          Action : Gtk_Print_Operation_Action;
          Parent : System.Address) return Gtk_Print_Operation_Result;
      pragma Import (C, Internal, "gtk_print_operation_run");
   begin
      return Internal (Get_Object (Self), Action, Get_Object_Or_Null (GObject (Parent)));
   end Run;

   ---------------------
   -- Set_Allow_Async --
   ---------------------

   procedure Set_Allow_Async
      (Self        : not null access Gtk_Print_Operation_Record;
       Allow_Async : Boolean)
   is
      procedure Internal (Self : System.Address; Allow_Async : Integer);
      pragma Import (C, Internal, "gtk_print_operation_set_allow_async");
   begin
      Internal (Get_Object (Self), Boolean'Pos (Allow_Async));
   end Set_Allow_Async;

   ----------------------
   -- Set_Current_Page --
   ----------------------

   procedure Set_Current_Page
      (Self         : not null access Gtk_Print_Operation_Record;
       Current_Page : Gint)
   is
      procedure Internal (Self : System.Address; Current_Page : Gint);
      pragma Import (C, Internal, "gtk_print_operation_set_current_page");
   begin
      Internal (Get_Object (Self), Current_Page);
   end Set_Current_Page;

   --------------------------
   -- Set_Custom_Tab_Label --
   --------------------------

   procedure Set_Custom_Tab_Label
      (Self  : not null access Gtk_Print_Operation_Record;
       Label : UTF8_String := "")
   is
      procedure Internal
         (Self  : System.Address;
          Label : Interfaces.C.Strings.chars_ptr);
      pragma Import (C, Internal, "gtk_print_operation_set_custom_tab_label");
      Tmp_Label : Interfaces.C.Strings.chars_ptr;
   begin
      if Label = "" then
         Tmp_Label := Interfaces.C.Strings.Null_Ptr;
      else
         Tmp_Label := New_String (Label);
      end if;
      Internal (Get_Object (Self), Tmp_Label);
      Free (Tmp_Label);
   end Set_Custom_Tab_Label;

   ----------------------------
   -- Set_Default_Page_Setup --
   ----------------------------

   procedure Set_Default_Page_Setup
      (Self               : not null access Gtk_Print_Operation_Record;
       Default_Page_Setup : access Gtk.Page_Setup.Gtk_Page_Setup_Record'Class)
      
   is
      procedure Internal
         (Self               : System.Address;
          Default_Page_Setup : System.Address);
      pragma Import (C, Internal, "gtk_print_operation_set_default_page_setup");
   begin
      Internal (Get_Object (Self), Get_Object_Or_Null (GObject (Default_Page_Setup)));
   end Set_Default_Page_Setup;

   -----------------------
   -- Set_Defer_Drawing --
   -----------------------

   procedure Set_Defer_Drawing
      (Self : not null access Gtk_Print_Operation_Record)
   is
      procedure Internal (Self : System.Address);
      pragma Import (C, Internal, "gtk_print_operation_set_defer_drawing");
   begin
      Internal (Get_Object (Self));
   end Set_Defer_Drawing;

   --------------------------
   -- Set_Embed_Page_Setup --
   --------------------------

   procedure Set_Embed_Page_Setup
      (Self  : not null access Gtk_Print_Operation_Record;
       Embed : Boolean)
   is
      procedure Internal (Self : System.Address; Embed : Integer);
      pragma Import (C, Internal, "gtk_print_operation_set_embed_page_setup");
   begin
      Internal (Get_Object (Self), Boolean'Pos (Embed));
   end Set_Embed_Page_Setup;

   -------------------------
   -- Set_Export_Filename --
   -------------------------

   procedure Set_Export_Filename
      (Self     : not null access Gtk_Print_Operation_Record;
       Filename : UTF8_String)
   is
      procedure Internal
         (Self     : System.Address;
          Filename : Interfaces.C.Strings.chars_ptr);
      pragma Import (C, Internal, "gtk_print_operation_set_export_filename");
      Tmp_Filename : Interfaces.C.Strings.chars_ptr := New_String (Filename);
   begin
      Internal (Get_Object (Self), Tmp_Filename);
      Free (Tmp_Filename);
   end Set_Export_Filename;

   -----------------------
   -- Set_Has_Selection --
   -----------------------

   procedure Set_Has_Selection
      (Self          : not null access Gtk_Print_Operation_Record;
       Has_Selection : Boolean)
   is
      procedure Internal (Self : System.Address; Has_Selection : Integer);
      pragma Import (C, Internal, "gtk_print_operation_set_has_selection");
   begin
      Internal (Get_Object (Self), Boolean'Pos (Has_Selection));
   end Set_Has_Selection;

   ------------------
   -- Set_Job_Name --
   ------------------

   procedure Set_Job_Name
      (Self     : not null access Gtk_Print_Operation_Record;
       Job_Name : UTF8_String)
   is
      procedure Internal
         (Self     : System.Address;
          Job_Name : Interfaces.C.Strings.chars_ptr);
      pragma Import (C, Internal, "gtk_print_operation_set_job_name");
      Tmp_Job_Name : Interfaces.C.Strings.chars_ptr := New_String (Job_Name);
   begin
      Internal (Get_Object (Self), Tmp_Job_Name);
      Free (Tmp_Job_Name);
   end Set_Job_Name;

   -----------------
   -- Set_N_Pages --
   -----------------

   procedure Set_N_Pages
      (Self    : not null access Gtk_Print_Operation_Record;
       N_Pages : Gint)
   is
      procedure Internal (Self : System.Address; N_Pages : Gint);
      pragma Import (C, Internal, "gtk_print_operation_set_n_pages");
   begin
      Internal (Get_Object (Self), N_Pages);
   end Set_N_Pages;

   ------------------------
   -- Set_Print_Settings --
   ------------------------

   procedure Set_Print_Settings
      (Self           : not null access Gtk_Print_Operation_Record;
       Print_Settings : access Gtk.Print_Settings.Gtk_Print_Settings_Record'Class)
      
   is
      procedure Internal
         (Self           : System.Address;
          Print_Settings : System.Address);
      pragma Import (C, Internal, "gtk_print_operation_set_print_settings");
   begin
      Internal (Get_Object (Self), Get_Object_Or_Null (GObject (Print_Settings)));
   end Set_Print_Settings;

   -----------------------
   -- Set_Show_Progress --
   -----------------------

   procedure Set_Show_Progress
      (Self          : not null access Gtk_Print_Operation_Record;
       Show_Progress : Boolean)
   is
      procedure Internal (Self : System.Address; Show_Progress : Integer);
      pragma Import (C, Internal, "gtk_print_operation_set_show_progress");
   begin
      Internal (Get_Object (Self), Boolean'Pos (Show_Progress));
   end Set_Show_Progress;

   ---------------------------
   -- Set_Support_Selection --
   ---------------------------

   procedure Set_Support_Selection
      (Self              : not null access Gtk_Print_Operation_Record;
       Support_Selection : Boolean)
   is
      procedure Internal
         (Self              : System.Address;
          Support_Selection : Integer);
      pragma Import (C, Internal, "gtk_print_operation_set_support_selection");
   begin
      Internal (Get_Object (Self), Boolean'Pos (Support_Selection));
   end Set_Support_Selection;

   ----------------------------
   -- Set_Track_Print_Status --
   ----------------------------

   procedure Set_Track_Print_Status
      (Self         : not null access Gtk_Print_Operation_Record;
       Track_Status : Boolean)
   is
      procedure Internal (Self : System.Address; Track_Status : Integer);
      pragma Import (C, Internal, "gtk_print_operation_set_track_print_status");
   begin
      Internal (Get_Object (Self), Boolean'Pos (Track_Status));
   end Set_Track_Print_Status;

   --------------
   -- Set_Unit --
   --------------

   procedure Set_Unit
      (Self : not null access Gtk_Print_Operation_Record;
       Unit : Gtk.Enums.Gtk_Unit)
   is
      procedure Internal (Self : System.Address; Unit : Gtk.Enums.Gtk_Unit);
      pragma Import (C, Internal, "gtk_print_operation_set_unit");
   begin
      Internal (Get_Object (Self), Unit);
   end Set_Unit;

   -----------------------
   -- Set_Use_Full_Page --
   -----------------------

   procedure Set_Use_Full_Page
      (Self      : not null access Gtk_Print_Operation_Record;
       Full_Page : Boolean)
   is
      procedure Internal (Self : System.Address; Full_Page : Integer);
      pragma Import (C, Internal, "gtk_print_operation_set_use_full_page");
   begin
      Internal (Get_Object (Self), Boolean'Pos (Full_Page));
   end Set_Use_Full_Page;

   -----------------
   -- End_Preview --
   -----------------

   procedure End_Preview
      (Preview : not null access Gtk_Print_Operation_Record)
   is
      procedure Internal (Preview : System.Address);
      pragma Import (C, Internal, "gtk_print_operation_preview_end_preview");
   begin
      Internal (Get_Object (Preview));
   end End_Preview;

   -----------------
   -- Is_Selected --
   -----------------

   function Is_Selected
      (Preview : not null access Gtk_Print_Operation_Record;
       Page_Nr : Gint) return Boolean
   is
      function Internal
         (Preview : System.Address;
          Page_Nr : Gint) return Integer;
      pragma Import (C, Internal, "gtk_print_operation_preview_is_selected");
   begin
      return Boolean'Val (Internal (Get_Object (Preview), Page_Nr));
   end Is_Selected;

   -----------------
   -- Render_Page --
   -----------------

   procedure Render_Page
      (Preview : not null access Gtk_Print_Operation_Record;
       Page_Nr : Gint)
   is
      procedure Internal (Preview : System.Address; Page_Nr : Gint);
      pragma Import (C, Internal, "gtk_print_operation_preview_render_page");
   begin
      Internal (Get_Object (Preview), Page_Nr);
   end Render_Page;

end Gtk.Print_Operation;