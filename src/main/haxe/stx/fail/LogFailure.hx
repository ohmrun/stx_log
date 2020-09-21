package stx.fail;

enum LogFailure{
  E_Log_UnderLogLevel;
  E_Log_SourceNotInPackage(source:String,dir:String);
  E_Log_NotLine(n:Int);
  E_Log_NotOfRange(l:Int,r:Int);
  E_Log_DoesNotContainTag(tag:String);
}