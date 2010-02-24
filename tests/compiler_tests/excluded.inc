%% This is an -*- erlang -*- file.

excluded("kernel") ->
    [erl_prim_loader, erlang, init, otp_ring0,
     prim_file, prim_inet, prim_zip, zlib];
excluded("megaco") ->
    [megaco_text_parser_v1,
     megaco_text_parser_v2,
     megaco_text_parser_prev3a,
     megaco_text_parser_prev3b,
     megaco_text_parser_prev3c]; % COMPILATION TAKES LONG TIME
excluded("cosNotification") ->
    [oe_CosEvent]; % no such file
excluded("etk") ->
    [tk, etk_menu, tkbutton, tkentry, tklistbox, tkmenu, tkscale, tkscrlbar,
     tktext, tkconsole, tkdialog, tkfocus, tkoptmenu, tktearoff
    ]; % bump in beam_disasm for some reason
excluded(_) ->
    [].

