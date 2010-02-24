%% From: Igor Goryachev <igor@goryachev.org>
%% Date: 15 June 2006
%%
%% I have experienced a different behaviour and possibly a weird result
%% while playing with matching a huge lists on x86_32 and x86_64 machines.

-module(big_list).
-export([test/0, compile/1]).

test() ->
    case big_list() of
        {selected,
         ["uid",
          "nickname",
          "n_family",
          "n_given",
          "email_pref",
          "tel_home_number",
          "tel_cellular_number",
          "adr_home_country",
          "adr_home_locality",
          "adr_home_region",
          "url",
          "gender",
          "bday",
          "constitution",
          "height",
          "weight",
          "hair",
          "routine",
          "smoke",
          "maritalstatus",
          "children",
          "independence",
          "school_number",
          "school_locality",
          "school_title",
          "school_period",
          "org_orgname",
          "title",
          "adr_work_locality",
          "photo_type",
          "photo_binval"],
         _} ->
            ok;
        _ ->
            not_matched
    end.

big_list() ->
    {selected,
     ["uid",
      "nickname",
      "n_family",
      "n_given",
      "email_pref",
      "tel_home_number",
      "tel_cellular_number",
      "adr_home_country",
      "adr_home_locality",
      "adr_home_region",
      "url",
      "gender",
      "bday",
      "constitution",
      "height",
      "weight",
      "hair",
      "routine",
      "smoke",
      "maritalstatus",
      "children",
      "independence",
      "school_number",
      "school_locality",
      "school_title",
      "school_period",
      "org_orgname",
      "title",
      "adr_work_locality",
      "photo_type",
      "photo_binval"],
     [{"test"}]}.

compile(Opts) ->
  hipe:c(?MODULE, Opts).
