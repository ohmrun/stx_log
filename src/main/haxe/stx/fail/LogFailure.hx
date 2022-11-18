package stx.fail;

import haxe.DynamicAccess;

enum LogFailure{
  E_Log(explanation:String);
  E_Log_UnderLogLevel;
  E_Log_SourceNotInPackage(source:String,dir:String);
  E_Log_NotLine(n:Int);
  E_Log_NotOfRange(l:Int,r:Int);
  E_Log_NotInMethod(str:String);
  E_Log_DoesNotContainTag(tag:String);
  E_Log_Not;
  E_Log_LosesRace;
  E_Log_Default(data:Dynamic);
  E_Log_Zero;
}