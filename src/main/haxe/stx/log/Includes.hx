package stx.log;

@:forward abstract Includes(Array<String>) from Array<String> to Array<String>{
  public function match(string){
    return this.lfold(
      (next:String,memo:Bool) -> memo.if_else(
        ()  -> true,
        ()  -> hx.files.GlobPatterns.toEReg(next).match(string)
      ),
      false
    );
  }
}