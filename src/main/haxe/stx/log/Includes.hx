package stx.log;

@:forward abstract Includes(Cluster<String>) from Cluster<String> to Cluster<String>{
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