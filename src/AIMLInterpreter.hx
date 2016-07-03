package;

import haxe.ds.StringMap;

#if js

import haxe.Http;

#end


using StringTools;

class AIMLInterpreter {
	
	var botAttributes : BotType;
	var currentXml : Xml;

	var domXArray : Array<Xml> = [];
	var domIndex = 0;

	var botMap : StringMap<String> = new StringMap<String>();
	var storedVariableValues : StringMap<String> = new StringMap<String>();

	
	// var lastWildCardValue = '';
	var wildCardArray = [];


	// var isAIMLFileLoadingStarted = false;
	// var isAIMLFileLoaded = false;

	// var previousAnswer = '';
	// var previousThinkTag = false;


	public function new(botAttributesParam:BotType):Void {
		this.botAttributes = botAttributesParam;
		// trace('name: '+this.botAttributes.name);
		// trace(botAttributesParam);
		for (n in Reflect.fields(botAttributesParam)) {
			// trace(n);
			// trace(Reflect.field(botAttributesParam, n));
			botMap.set(n,Reflect.field(botAttributesParam, n));
		}
	}

	/**
	 * [loadAIMLFilesIntoArray description]
	 * @param  arr<String> [description]
	 * @return             [description]
	 */
	public function loadAIMLFilesIntoArray(arr:Array<String>):Void 
	{	
		for (i in 0 ... arr.length) {
			readAIMLFile(arr[i]);
		}
	}
	/**
	 * [loadAIMLFolder description]
	 * 
	 * @param  path [description]
	 * @return      [description]
	 */
	public function loadAIMLFolder(path:String):Void
	{
#if sys		
		if (sys.FileSystem.exists(path)) {
			var arr = sys.FileSystem.readDirectory(path); 
			for (i in 0 ... arr.length) {
				readAIMLFile(path + '/' + arr[i]);
			}
		} else {
			Sys.println('ERROR: can\'t find folder "$path")');
		}
#end
	} 

	/**
	 * [readAIMLFile description]
	 * 
	 * @param  path [description]
	 * @return      [description]
	 */
	public function readAIMLFile(path:String):Void 
	{
#if sys
		if (sys.FileSystem.exists(path)) {
			var str = sys.io.File.getContent(path);
			var xml = Xml.parse(str);
			domXArray.push(xml);
			domIndex++;
		} else {
			Sys.println('ERROR: can\'t find file "$path")');
		}
#elseif js
		var loader = new Http(path);  
		loader.onData = function(raw) {  
			try {  
				var xml = Xml.parse(raw);  
				domXArray.push(xml);
				domIndex++;
			}  
			catch (err:Dynamic) {  
				untyped alert(err);  
			}  
		}  
		loader.request(); 
#else
		trace('flash / openfl / NME');
#end
	}

	public function answer(clientInput:String):String
	{
		var result = '';
		for (i in 0 ... domXArray.length){
			result = findCorrectCategory(clientInput, domXArray[i]);
		}
		return result;
	}

	public function findAnswerInLoadedAIMLFiles(clientInput:String, cb:Dynamic)
	{
		wildCardArray = [];
		var result = '';
		for (i in 0 ... domXArray.length){
			result = findCorrectCategory(clientInput, domXArray[i]);
		}
		cb(result, wildCardArray, clientInput);
	}

	/*
	<category>
		<pattern>MY NAME IS <set name='clientName'>*</set></pattern>
		<template>Hey <get name='clientName'/>!</template>
	</category>
	*/
	public function findCorrectCategory(clientInput:String, xml:Xml):String 
	{
		currentXml = xml;
		for ( i in xml.firstElement().elementsNamed('category'))
		{
			var category = i;
			for ( j in category.elementsNamed('pattern'))
			{
				var pattern = j;
				var patternText = pattern.firstChild().toString(); // WHAT IS YOUR NAME
				
				if(pattern.firstElement() != null)
				{
					// trace('clientInput: '+clientInput); 	// My name is Ben.
					// trace('pattern: ' + pattern); 		// <pattern>MY NAME IS <set name="clientName">*</set></pattern>
					// trace('name: ' + pattern.firstElement().get("name")); // clientName
					// trace('firstChild: ' + pattern.firstElement().firstChild()); // *
					// trace(pattern.removeChild(pattern.firstElement()));
					
					// trace(pattern);

					var strippedPattern = pattern.firstChild().toString().trim().toUpperCase();
					// trace( "strippedPattern: " + strippedPattern ); // MY NAME IS / YOU FEEL
					if (clientInput.toUpperCase().indexOf(strippedPattern) != -1)
					{
						// trace(clientInput.toUpperCase().replace(strippedPattern,''));
						var start = clientInput.toUpperCase().indexOf(strippedPattern);
						var end = strippedPattern.toUpperCase().length;
						var substr = clientInput.substr(start+end);

						// trace(cleanText(substr));

						storedVariableValues.set(pattern.firstElement().get("name"),cleanText(substr));

						// trace(storedVariableValues.get(pattern.firstElement().get("name")));

						var template = category.elementsNamed('template'); // Iterator<Xml>				
						var text = findFinalTextInTemplateNode(template.next());
						return text;

					}

				}

				var template = category.elementsNamed('template'); // Iterator<Xml>				
				var text = findFinalTextInTemplateNode(template.next());

				if(cleanText(patternText).toUpperCase() == cleanText(clientInput).toUpperCase()){
					return text;
				}

				// return text;
			}
		}
		return 'I am sorry... I can\'t help you';
	}

 	function resolveSpecialNodes(innerNodes){

 	}


	function findFinalTextInTemplateNode(template:Xml):String
	{
		// trace(template);
		// trace('> ${template.nodeName}');
		var el = template.elements(); // iterator xml
		if (el.hasNext() ){
			for (i in el){
				// trace('> ${i.nodeName}');
				switch (i.nodeName) {
					case 'srai': 
						return findCorrectCategory(i.firstChild().toString().toUpperCase(), currentXml);
					case 'random': 
						// random, search for li
						var li = i.elements();
						var liArray = [];
						for (j in li) {
							liArray.push(j.firstChild().toString());
						}
						var out = (liArray[Std.random(liArray.length)]);
						return out; 

					case 'bot': 

						// trace(template.removeChild(i));
						// trace(template);
						// trace(template.nodeName);
						// trace(template.nodeType);
						// // trace(template.nodeValue);
						// trace(template.firstChild());
						// trace(template.firstElement());
						// trace ('bot $i');
						// trace ('${i.get("name")}');
						
						var botName = '';
						if(botMap.exists(i.get("name"))) botName = botMap.get(i.get("name"));

						var txt = template.toString();
						txt = txt.replace(i.toString(), botName);

						var xml = Xml.parse(txt);
						return (xml.firstChild().firstChild().toString()); // replace <bot name> with the value in botMap



					case 'get': 
						// trace ('get');
						
						// trace ('bot $i');
						// trace ('${i.get("name")}');

						var getName = '';
						if(storedVariableValues.exists(i.get("name"))) getName = storedVariableValues.get(i.get("name"));
						// trace(getName);

						var txt = template.toString();
						txt = txt.replace(i.toString(), getName);

						// trace(txt);

						var xml = Xml.parse(txt);
						
						// trace(xml.firstChild().firstChild().toString());

						return (xml.firstChild().firstChild().toString()); // replace <bot name> with the value in botMap




					// case 'sr': trace ('sr');
					// case 'star': trace ('star');
					// case 'condition': trace ('condition');


					// default : trace ("case '"+i.nodeName+"': trace ('"+i.nodeName+"');");
				}						
			}
		} else {
			var str = template.firstChild().toString();
			// trace(str);
			return str;
		}

		// 
		return '';
	}

	function cleanText (clientInput:String):String 
	{
		return 	clientInput
				.trim()
				.replace("  ", "")
				.replace("!", "")
				.replace("?","")
				.replace(".","");
	}

	function check(clientInput:String, pattern : Dynamic)
	{
		trace(clientInput, pattern);
	}

}


typedef BotType = {
	var name : String;
	@:optional var age : Int;
}
