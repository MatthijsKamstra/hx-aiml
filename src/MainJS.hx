package;

import jQuery.*;

import js.html.InputElement;

class MainJS {
	
	private var aimlInterpreter : AIMLInterpreter;

	private var doc = js.Browser.document;
	private var win = js.Browser.window;

	public function new() 
	{
		aimlInterpreter = new AIMLInterpreter({name:'HxAIML', age:100});
		aimlInterpreter.readAIMLFile( 'aiml/haxe.aiml');

		new JQuery(js.Browser.document).ready ( function (){
			init();		
			// [mck] wait 2 seconds before callChat
			// haxe.Timer.delay(callChat, 2000);
		});
	}

	function init():Void 
	{
		// onclick submit
		new JQuery("#btn-chat").click(function (e:Dynamic) {
			getInput();			
		});
		// listen to enter
		win.onkeyup = function(e) {
			var key : Int = e.keyCode;
			if(key == 13) getInput();
		}
		// focus field
		new JQuery('#btn-input').focus();
	}

	function getInput():Void 
	{
		var text : String = new JQuery('#btn-input').val();
		if(text.length <=1) return; // do something clever with no input
		// trace('submit $text');
		userBalloon(text);
		aimlInterpreter.findAnswerInLoadedAIMLFiles(text, callbackChat);
		// clear input
		new JQuery('#btn-input').val('');	
		new JQuery('#btn-input').focus();	

	}

	public function userBalloon(str:String):Void {

		// trace( 'userBalloon ($str)' );

		var li : String =  
		'<li class="left clearfix"><span class="chat-img pull-left">
			<img src="http://placehold.it/50/55C1E7/fff&text=U" alt="User Avatar" class="img-circle" />
		</span>
			<div class="chat-body clearfix">
				<!-- 
				<div class="header">
					<strong class="primary-font">Jack Sparrow</strong> <small class="pull-right text-muted">
						<span class="glyphicon glyphicon-time"></span>12 mins ago</small> 
				</div>
				-->
				<p>
					$str
				</p>
			</div>
		</li>';

		var ul = new JQuery("ul.chat");
		ul.prepend(li);
		
	}

	public function botBalloon (str:String){
		
		var li : String =  
		'<li class="right clearfix"><span class="chat-img pull-right">
			<img src="http://placehold.it/50/FA6F57/fff&text=BOT" alt="User Avatar" class="img-circle" />
		</span>
			<div class="chat-body clearfix">
				<!--
				<div class="header">
					<small class=" text-muted"><span class="glyphicon glyphicon-time"></span>13 mins ago</small>
					<strong class="pull-right primary-font">Bhaumik Patel</strong>
				</div>
				-->
				<p>
					$str
				</p>
			</div>
		</li>';

		var ul = new JQuery("ul.chat");
		ul.prepend(li);
	}



	private function callbackChat (answer, wildCardArray, input){
		haxe.Timer.delay(function () { 
	    	botBalloon(answer);
		}, 800);
	}

	// ____________________________________ test ____________________________________

	public function callChat():Void 
	{	
		trace(':: fake chat:: ');
		aimlInterpreter.findAnswerInLoadedAIMLFiles('What is your name?', callback);
		// aimlInterpreter.findAnswerInLoadedAIMLFiles('My name is Ben.', callback);
		// aimlInterpreter.findAnswerInLoadedAIMLFiles('What is my name?', callback);
		// trace('What is your name? : ' + aimlInterpreter.answer('What is your name?') );
	}


	private function callback (answer, wildCardArray, input){
	    trace(answer + ' | ' + wildCardArray + ' | ' + input);
	}


	// ____________________________________ main ____________________________________

	static public function main() {
		var app = new MainJS();
	}
}