package;

/**
 * @author Matthijs Kamstra aka[mck]
 * MIT
 */ 
class Main {
	
	public function new () {
		trace( "------------ AIMLInterpreter --------------" );
		init();
	}

	public function init():Void 
	{	
		var projectFolder = Sys.getCwd ();
		var path = projectFolder + '/aiml/';
		// path = '/Volumes/Data HD/Users/matthijs/Documents/workingdir/haxe/aiml/aiml/bin/aiml/';

		var aimlInterpreter = new AIMLInterpreter({name:'HxAIML', age:100});
		// aimlInterpreter.loadAIMLFilesIntoArray(['./test.aiml.xml']);
		aimlInterpreter.readAIMLFile( path + 'test.aiml');

		// aimlInterpreter.findAnswerInLoadedAIMLFiles('What is your name?', callback);
		// aimlInterpreter.findAnswerInLoadedAIMLFiles('My name is Ben.', callback);
		// aimlInterpreter.findAnswerInLoadedAIMLFiles('What is my name?', callback);


		trace('What is your name? : ' + aimlInterpreter.answer('What is your name?') );
		// trace('what are you called : ' +  aimlInterpreter.answer('what are you called') );
		// trace('1. Hey there : ' +  aimlInterpreter.answer('Hey there') );
		// trace('2. Hey there : ' +  aimlInterpreter.answer('Hey there') );
		// trace('3. Hey there : ' +  aimlInterpreter.answer('Hey there') );
		// trace('hello world : ' +  aimlInterpreter.answer('hello world') );
		// trace('Hi : ' +  aimlInterpreter.answer('Hi') );

		// trace("'WHO ARE YOU' : "+aimlInterpreter.answer('WHO ARE YOU'));
		// trace("'WHAT ARE YOU CALLED' : "+aimlInterpreter.answer('WHAT ARE YOU CALLED'));

		// trace('"What is your name?" : ' +  aimlInterpreter.answer('What is your name?'));
		// trace('"My name is Ben." : ' +  aimlInterpreter.answer('My name is Ben.'));
		// trace('"What is my name?" : ' +  aimlInterpreter.answer('What is your name?'));

	}

	
	function callback (answer, wildCardArray, input){
	    trace(answer + ' | ' + wildCardArray + ' | ' + input);
	}

	static function tests():Void {
		var r = new haxe.unit.TestRunner();
   		r.add(new TestCase());
    	r.run(); // finally, run the tests
	}

	static public function main () {
		// tests();
		var app = new Main ();
	}
}