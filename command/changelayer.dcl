lineTypeDlg : dialog {
label = "画層選択";
: column {
: list_box {
height = 48;
width = 36;
key = "listbox";
allow_accept = true;
}
:row {
: toggle {
label = "入力指定";
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
//label = "従属図形を変更する。";
//value = "0";
//}
ok_cancel;
}
}
