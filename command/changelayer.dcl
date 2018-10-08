lineTypeDlg : dialog
{
	label = "layers";
	: column
	{
		: list_box
		{
			height = 48;
			width = 36;
			key = "listbox";
			allow_accept = true;
		}
		:row
		{
			: toggle
			{
				label = "layer or make layer";
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
