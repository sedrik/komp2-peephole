%% -*- erlang-indent-level: 2 -*-
%%-----------------------------------------------------------------------
%% A totally stupid program whose first function sends the typesig
%% version of March 2006 into the land of no return...
%% This, despite the fact that there are sizes of types are small,
%% there are no function dependencies in this one or complicated SCCs.
%%-----------------------------------------------------------------------

-module(babis1).
-export([token/4]).

%%
%% This function, which is analyzed last, is the culprit.
%%
token(Token,PrevTokenList,Stream,Counter) ->
  %%--- Wire Out ( Client view )
  case tWO_Header(Token,PrevTokenList,Stream,Counter) of false -> 
  case tWO_Version(Token,PrevTokenList,Stream,Counter)  of false ->     
  case tWO_StreamProtocol(Token,PrevTokenList,Stream,Counter) of false ->
  case tWO_SingleOpProtocol(Token,PrevTokenList,Stream,Counter) of false ->
  case tWO_MultiplexProtocol(Token,PrevTokenList,Stream,Counter) of false ->
  case tWO_Call(Token,PrevTokenList,Stream,Counter) of false ->
  case tWO_Ping(Token,PrevTokenList,Stream,Counter) of false ->
  case tWO_DgcAck(Token,PrevTokenList,Stream,Counter) of false ->
  case tWO_ObjNumber(Token,PrevTokenList,Stream,Counter) of false ->
  case tWO_Operation(Token,PrevTokenList,Stream,Counter) of false ->
  case tWO_Hash(Token,PrevTokenList,Stream,Counter) of false ->
	
  %%--- Wire In ( Client view )
  case tWI_ProtocolAck(Token,PrevTokenList,Stream,Counter) of false ->    
  case tWI_ProtNotSupported(Token,PrevTokenList,Stream,Counter) of false ->
  case tWI_ReturnData(Token,PrevTokenList,Stream,Counter) of false ->
  case tWI_PingAck(Token,PrevTokenList,Stream,Counter) of false ->
  case tWI_ReturnValue(Token,PrevTokenList,Stream,Counter) of false ->  

  %%--- Wire ( used by Out and In )
  case tW_UidNumber(Token,PrevTokenList,Stream,Counter) of false ->
  case tW_UidTime(Token,PrevTokenList,Stream,Counter) of false -> 
  case tW_UidCount(Token,PrevTokenList,Stream,Counter) of false ->  
 
  %%--- Serial Object
  case tSO_ObjectStream(Token,PrevTokenList,Stream,Counter) of false ->
  case tSO_Utf(Token,PrevTokenList,Stream,Counter) of false ->
  case tSO_Int(Token,PrevTokenList,Stream,Counter) of false -> false;

  Other -> Other end;
  Other -> Other end;
  Other -> Other end;
  Other -> Other end;
  Other -> Other end;
  Other -> Other end;
  Other -> Other end;
  Other -> Other end;
  Other -> Other end;
  Other -> Other end;
  Other -> Other end;
  Other -> Other end;
  Other -> Other end;
  Other -> Other end;
  Other -> Other end;
  Other -> Other end;
  Other -> Other end;
  Other -> Other end;
  Other -> Other end;
  Other -> Other end;
  Other -> Other end; 
  Other -> Other end.

%%--- 'HEADER'
tWO_Header(Chunk,[PrevToken|_],_Stream,Counter) ->
  case Chunk of
    [74,82,77,73] ->
      case PrevToken of
	{'$start',_} -> 
	  {'HEADER',Counter+1};
	_ ->
	  false
      end;
    _ -> false
  end.

%%--- 'VERSION'
tWO_Version(Chunk,[PrevToken|_],_Stream,Counter) ->
  case Chunk of
    [0,2] ->
      case PrevToken of
	{'HEADER',_} -> 
	  {'VERSION',Counter+1};          
	_ ->
	  false
      end;
    _ -> false
  end.

%%--- 'STREAM_PROTOCOL'
tWO_StreamProtocol(Chunk,[PrevToken|_],_Stream,Counter) ->
  case Chunk of
    [75] ->
      case PrevToken of
	{'VERSION',_} -> 
	  {'STREAM_PROTOCOL',Counter+1};          
	_ ->
	  false
      end;
    _ -> false
  end.

%%--- 'SINGLE_OP_PROTOCOL'
tWO_SingleOpProtocol(Chunk,[PrevToken|_],_Stream,Counter) ->
  case Chunk of
    [76] ->
      case PrevToken of
	{'VERSION',_} -> 
	  {'SINGLE_OP_PROTOCOL',Counter+1};          
	_ ->
	  false
      end;
    _ -> false
  end.

%%--- 'MULTIPLEX_PROTOCOL'
tWO_MultiplexProtocol(Chunk,[PrevToken|_],_Stream,Counter) ->
  case Chunk of
    [77] ->
      case PrevToken of
	{'VERSION',_} -> 
	  {'MULTIPLEX_PROTOCOL',Counter+1};          
	_ ->
	  false
      end;
    _ -> false
  end.

%%--- 'CALL'
tWO_Call(Chunk,[PrevToken|PrevTokens],Stream,Counter) ->
  case Chunk of
    [80] ->
      case PrevToken of
	{'$start',_} ->               %-- DIRECT CALL ! WORKS !!!!!!          
	  case Stream of
	    [172,237,0,5|_] ->
	      {'CALL',Counter+1};
	    _ ->
	      false
	  end;
	{'INT',_,_} ->
	  case PrevTokens of
	    [{'UTF',_,_}|_] ->       %-- EXACT AFTER CONNECTION SETUP ! WORKS !
	      {'CALL',Counter+1};
	    [{'TC_REFERENCE',_}|_] -> %--- After another Call !
	      {'CALL',Counter+1};  
	    _ ->
	      false
	  end;
	{'STREAM_PROTOCOL',_} -> 
	  {'CALL',Counter+1};          
	{'SINGLE_OP_PROTOCOL',_} -> 
	  {'CALL',Counter+1};          
	{'MULTIPLEX_PROTOCOL',_} -> 
	  {'CALL',Counter+1};
	{'PING',_} ->                    %--- After a Ping !  
	  {'CALL',Counter+1};
	{'UID_COUNT',_,_} ->             %--- After a DgcAck !
	  case PrevTokens of
	    [{'UID_TIME',_,_},{'UID_NUMBER',_,_},{'DGC_ACK',_}|_] ->
	      {'CALL',Counter+1};
	    _ ->
	      false
	  end;
	_ ->
	  false
      end;
    _ -> false
  end.

%%--- 'PING'
tWO_Ping(Chunk,[PrevToken|PrevTokens],_Stream,Counter) ->
  case Chunk of
    [82] ->
      case PrevToken of
	{'STREAM_PROTOCOL',_} -> 
	  {'PING',Counter+1};          
	{'SINGLE_OP_PROTOCOL',_} -> 
	  {'PING',Counter+1};          
	{'MULTIPLEX_PROTOCOL',_} -> 
	  {'PING',Counter+1};
	{'PING',_} ->                  %--- After a Ping ! 
	  {'PING',Counter+1};
	{'INT',_,_} ->                 %--- After a Call ! 
	  case PrevTokens of       
	    [{'TC_REFERENCE',_}|_] ->
	      {'PING',Counter+1};  
	    _ ->
	      false
	  end;
	{'UID_COUNT',_,_} ->             %--- After a DgcAck !
	  case PrevTokens of
	    [{'UID_TIME',_,_},{'UID_NUMBER',_,_},{'DGC_ACK',_}|_] ->
	      {'PING',Counter+1};
	    _ ->
	      false
	  end;
	_ ->
	  false
      end;
    _ -> false
  end.

%%--- 'DGC_ACK'
tWO_DgcAck(Chunk,[PrevToken|PrevTokens],_Stream,Counter) ->
  case Chunk of
    [84] ->
      case PrevToken of
	{'STREAM_PROTOCOL',_} -> 
	  {'DGC_ACK',Counter+1};          
	{'SINGLE_OP_PROTOCOL',_} -> 
	  {'DGC_ACK',Counter+1};          
	{'MULTIPLEX_PROTOCOL',_} -> 
	  {'DGC_ACK',Counter+1};
	{'PING',_} ->                    %--- After a Ping !  
	  {'DGC_ACK',Counter+1};
	{'INT',_,_} ->                   
	  case PrevTokens of           %--- After a Call ! 
	    [{'TC_REFERENCE',_}|_] -> 
	      {'DGC_ACK',Counter+1};
	    [{'UTF',_,_}|_] ->
	      {'DGC_ACK',Counter+1};
	    _ ->
	      false
	  end;
	{'UID_COUNT',_,_} ->             %--- After a DgcAck !
	  case PrevTokens of
	    [{'UID_TIME',_,_},{'UID_NUMBER',_,_},{'DGC_ACK',_}|_] ->
	      {'DGC_ACK',Counter+1};
	    _ ->
	      false
	  end;
	_ ->
	  false
      end;
    _ -> false
    end.

%%--- 'OBJ_NUMBER'
tWO_ObjNumber(Chunk,[PrevToken|_],_Stream,Counter) ->
  case Chunk of
    [B1,B2,B3,B4] ->
      case PrevToken of
	{'CALL',_} -> 
	  {'OBJ_NUMBER',Counter+1,[B1,B2,B3,B4]};
	_ ->
	  false
      end;
    _ -> false
  end.

%%--- 'OPERATION'
tWO_Operation(Chunk,[PrevToken|PrevTokens],_Stream,Counter) ->
  case Chunk of
    [B1,B2,B3,B4] ->
      case PrevToken of
	{'UID_COUNT',_,_} ->
	  case PrevTokens of
	    [{'UID_TIME',_,_},{'UID_NUMBER',_,_},
	     {'OBJ_NUMBER',_,_},{'CALL',_}|_] ->
	      {'OPERATION',Counter+1,[B1,B2,B3,B4]};
	    _ ->
	      false
	  end;
	_ ->
	  false
      end;
    _ -> false
  end.

%%--- 'HASH'
tWO_Hash(Chunk,[PrevToken|_],_Stream,Counter) ->
  case Chunk of
    [B1,B2,B3,B4,B5,B6,B7,B8] ->
      case PrevToken of
	{'OPERATION',_,_} -> 
	  {'HASH',Counter+1,[B1,B2,B3,B4,B5,B6,B7,B8]};
	_ ->
	  false
      end;
    _ -> false
  end.

%%*<--------------------- WIRE IN ( CLIENT  VIEW )

tWI_ProtocolAck(Chunk,[PrevToken|_],_Stream,Counter) ->
  case Chunk of
    [78] ->
      case PrevToken of
	{'$start',_} ->
	  {'PROTOCOL_ACK',Counter+1};
	_ ->
	  false
      end;
    _ -> false
  end.

tWI_ProtNotSupported(Chunk,[PrevToken|_],_Stream,Counter) ->
  case Chunk of
    [79] ->
      case PrevToken of
	{'$start',_} ->
	  {'PROT_NOT_SUPPORTED',Counter+1};
	_ ->
	  false
      end;
    _ -> false
  end.

tWI_ReturnData(Chunk,[PrevToken|_],_Stream,Counter) ->
  case Chunk of
    [81] ->
      case PrevToken of
	{'$start',_} ->
	  {'RETURN_DATA',Counter+1};
	{'PROTOCOL_ACK',_} ->     
	  {'RETURN_DATA',Counter+1};
	{'RETURN_DATA',_} ->
	  {'RETURN_DATA',Counter+1};
	{'PING_ACK',_} ->
	  {'RETURN_DATA',Counter+1};
	_ ->
	  false
      end;
    _ -> false
  end.

tWI_PingAck(Chunk,[PrevToken|_],_Stream,Counter) ->
  case Chunk of
    [83] ->
      case PrevToken of
	{'PROTOCOL_ACK',_} ->
	  {'PING_ACK',Counter+1};
	{'RETURN_DATA',_} ->
	  {'PING_ACK',Counter+1};
	{'PING_ACK',_} ->
	  {'PING_ACK',Counter+1};
	_ ->
	  false
      end;
    _ -> false
  end.

tWI_ReturnValue(Chunk,[PrevToken|_],_Stream,Counter) ->
  case Chunk of
    [1] ->
      case PrevToken of
	{'RETURN_DATA',_} ->
	  {'RETURN_VALUE',Counter+1};
	_ ->
	  false
      end;
    [2] ->
      case PrevToken of
	{'RETURN_DATA',_} ->
	  {'RETURN_EXCEPTION',Counter+1};
	_ ->
	  false
      end;
    _ -> false
  end.

%%--- 'UID_NUMBER'
tW_UidNumber(Chunk,[PrevToken|_],_Stream,Counter) ->
  case Chunk of
    [B1,B2,B3,B4] ->
      case PrevToken of
	%%--- Wire out use
	{'OBJ_NUMBER',_,_} -> 
	  {'UID_NUMBER',Counter+1,[B1,B2,B3,B4]};
	{'DGC_ACK',_} ->
	  {'UID_NUMBER',Counter+1,[B1,B2,B3,B4]};
	%%--- Wire in use
	{'RETURN_VALUE',_} -> 
	  {'UID_NUMBER',Counter+1,[B1,B2,B3,B4]};
	{'RETURN_EXCEPTION',_} ->
	  {'UID_NUMBER',Counter+1,[B1,B2,B3,B4]};
	_ ->
	  false
      end;
    _ -> false
  end.

tW_UidTime(Chunk,[PrevToken|_],_Stream,Counter) ->
  case Chunk of
    [B1,B2,B3,B4,B5,B6,B7,B8] ->
      case PrevToken of
	{'UID_NUMBER',_,_} -> 
	  {'UID_TIME',Counter+1,[B1,B2,B3,B4,B5,B6,B7,B8]};
	_ ->
	  false
      end;
    _ -> false
  end.

%%--- 'UID_COUNT'
tW_UidCount(Chunk,[PrevToken|_],_Stream,Counter) ->
  case Chunk of
    [B1,B2] ->
      case PrevToken of
	{'UID_TIME',_,_} -> 
	  {'UID_COUNT',Counter+1,[B1,B2]};
	_ ->
	  false
      end;
    _ -> false
  end.

%%--- 'STREAM_MAGIC'
tSO_ObjectStream(Chunk,[PrevToken|PrevTokens],Stream,Counter) ->
  case Chunk of
    [172,237] ->
      case PrevToken of
	{'HASH',_,_} ->                 % WIRE OUT ( client view )
	  {'OBJECT_STREAM',Counter+1,objectScanner:scan([172,237|Stream])};
	{'UID_COUNT',_,_} ->            % WIRE IN ( client view )
	  case PrevTokens of
	    [{'UID_TIME',_,_},{'UID_NUMBER',_,_},Next|_] ->
	      case Next of
		{'RETURN_VALUE',_} ->
		  {'OBJECT_STREAM',Counter+1,objectScanner:scan([172,237|Stream])};
		{'RETURN_EXCEPTION',_} ->
		  {'OBJECT_STREAM',Counter+1,objectScanner:scan([172,237|Stream])};
		_ ->
		  false
	      end;
	    _ ->
	      false
	  end;
	_ ->                            % Look ahead ! <- BUG DANGER !
	  case Stream of             
	    [0,5|_] ->
	      {'OBJECT_STREAM',Counter+1,objectScanner:scan([172,237|Stream])};
	    _ ->
	      false
	  end
      end;
    _ -> false
  end.

%%---- 'UTF'
tSO_Utf(Chunk,[PrevToken|_PrevTokens],Stream,Counter) ->
  case Chunk of
    [B1,B2] ->
      case PrevToken of
	{'$start',_} ->              %-- ATT A CLIENT CALL
	  case Chunk of
	    [74,82] ->               %-- Check if this
	      case Stream of         %-- is the beginning
		[77,73,0,2|_] ->     %-- of a message header !
		  false;
		_ ->
		  {'UTF',Counter+1,[B1,B2]}
	      end;
	    [80,172] ->              %-- Check if this
	      case Stream of         %-- is the beginning
		[237,0,5|_] ->       %-- of a message header !
		  false;
		_ ->
		  {'UTF',Counter+1,[B1,B2]}
	      end;
	    _ ->
	      {'UTF',Counter+1,[B1,B2]}
	  end; 
	{'PROTOCOL_ACK',_} -> 
	  {'UTF',Counter+1,[B1,B2]};         %-- ATT A CONNECTION START 
					     %-- ( SERVER ->  CLIENT )
	_ ->
	  false
      end;
    _ ->
      false
  end.

%%---- 'INT'
tSO_Int(Chunk,[First|PrevTokens],_Stream,Counter) ->
  case Chunk of
    [B1,B2,B3,B4] ->
      case First of
	{'UTF',_,_} ->                     
	  case PrevTokens of             
	    [{'$start',_}|_] ->           %-- ATT A CLIENT CALL
	      {'INT',Counter+1,[B1,B2,B3,B4]};
	    [{'PROTOCOL_ACK',_}|_] ->     %-- ATT A CONNECTION START
	      {'INT',Counter+1,[B1,B2,B3,B4]};  %-- ( SERVER ->  CLIENT )
	    _ ->
	      false
	  end;
	_ ->
	  false
      end;
    _ ->
      false
  end.

