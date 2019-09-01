dlg : dialog
{
	label = "stTextEdit";
	initial_focus = "userValue";
	: column
	{
		: row
		{
			: list_box
			{
				height = 20;
				width = 36;
				key = "listbox";
				allow_accept = true;
			}
		}
		:row
		{
			: edit_box
			{
				label = "newstr";
				key = "userValue";
				//value = "";
				width = 24;
				is_enabled = true;
				allow_accept = true;
			}  
		}
		ok_cancel;
	}
}
