package stx.log;

@:forward abstract Includes(Array<String>) from Array<String> to Array<String>{
  public function clear(){
    while(this.length > 0){
      this.pop();
    }
  }
}