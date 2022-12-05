package stx.log.env;

@:forward abstract LogFile(Option<String>) from Option<String> to Option<String>{
  public function new(){
    this =__.option(Sys.getEnv("STX_LOG__FILE"));
  }
}