lineTypeDlg : dialog {
label = "��w�I��";
: column {
: list_box {
height = 48;
width = 36;
key = "listbox";
allow_accept = true;
}
:row {
: toggle {
label = "���͎w��";
key = "userInput";

}
: edit_box {
label = "";
key = "userValue";
value = "";
width = 22;
is_enabled = false;
}  
}
//: toggle {
//label = "�]���}�`��ύX����B";
//value = "0";
//}
ok_cancel;
}
}
