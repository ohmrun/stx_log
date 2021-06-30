package stx.log;

@:forward abstract Includes(Array<String>) from Array<String> to Array<String>{
  public function clear(){
    while(this.length > 0){
      this.pop();
    }
  }
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