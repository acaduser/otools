lineTypeDlg : dialog
{
	label = "🌈changeLayer";
	initial_focus = "listbox";
	: column
	{
		: list_box
		{
			height = 40;
			width = 36;
			key = "listbox";
			allow_accept = true;
		}
		:row
		{
			: toggle
			{
				label = "画層名指定";
				key = "userInput";
			}
			: edit_box
			{
				label = "";
				key = "userValue";
				value = "";
				width = 24;
				is_enabled = false;
				allow_accept = true;
			}  
		}
		ok_cancel;
	}
}
