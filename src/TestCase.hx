package;

class TestCase extends haxe.unit.TestCase
{


	var aimlInterpreter : AIMLInterpreter;
	var botType : AIMLInterpreter.BotType;

	override public function setup() {
		var projectFolder = Sys.getCwd ();
		var path = projectFolder + '/bin/aiml/';
		path = '/Volumes/Data HD/Users/matthijs/Documents/workingdir/haxe/aiml/aiml/bin/aiml/';

		botType = {name:'Herman', age:0}

		aimlInterpreter = new AIMLInterpreter(botType);
		// aimlInterpreter.loadAIMLFilesIntoArray(['./test.aiml.xml']);
		aimlInterpreter.readAIMLFile( path + 'test.aiml');
	}


	public function testSimpleAnswer() {
		assertEquals(aimlInterpreter.answer('HELLO WORLD'), 'Hello to you too');
		assertEquals(aimlInterpreter.answer('HELLO WORLD!!'), 'Hello to you too');
		assertEquals(aimlInterpreter.answer('  HELLO WORLD  '), 'Hello to you too');
		assertEquals(aimlInterpreter.answer('  HELLO   WORLD  '), 'Hello to you too');
		assertEquals(aimlInterpreter.answer('hi'), 'Hey, what\'s up?');
	}

	public function testRandom() {
		// [mck] difficult to test a random answer
		// trace('"give me a letter" : ' + aimlInterpreter.answer('give me a letter'));
		// trace('"Hey there" : ' + aimlInterpreter.answer('Hey there'));
		assertEquals(aimlInterpreter.answer('give me a letter').length, 1);
	}
	
	public function testBotName(){
		assertEquals (aimlInterpreter.answer('What is your name?'), 'My name is ${botType.name}.');
	}

	/**
	 * Symbolic Reductions
	 */
	public function testSraiAnswer() {
		assertEquals(aimlInterpreter.answer('WHO ARE YOU'), 'My name is ${botType.name}.');
		assertEquals(aimlInterpreter.answer('WHAT ARE YOU CALLED'), 'My name is ${botType.name}.');
	}	

	public function testSetName(){
		var name = 'Ben';
		assertEquals(aimlInterpreter.answer('My name is $name.'), 'Hey $name!');

	}

}