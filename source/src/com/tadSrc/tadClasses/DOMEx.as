package com.tadSrc.tadClasses
{

	import flash.external.ExternalInterface;

	/**
	* @author - (tad) A.D. Green,  Copyright 2009 - July 2010 Revision
	* License - Free for any use so long as this notice remains intact.
	* Warranty - None. Your use of this software is at your own risk.
	*/
	final public class DOMEx
	{

		private var callTo:*;

    
		public function DOMEx(object:* = null) {
				callTo = object;
		}


		public static function get a():Boolean
		{

				var isa:Boolean = false;
				if (ExternalInterface.available) isa = true;
				return isa;

		}

		public static function get statChange():XML { 

				var getStatChange:XML = 
				<script>
				<![CDATA[
				function (starg)
				{
					function chst(thestarg)
					{
						window.status = thestarg;
					}
					chst(starg);
				}
				]]>
				</script>;

				return getStatChange;

		}


		public static var getHash:XML = 
				<script>
				<![CDATA[
				function ()
				{
					if (window.location.toString().match("#"))
					{
						var afthash = new RegExp("[\#]{1}[a-z0-9]{1,}", "i");
						var thehashword = window.location.toString().match(afthash).toString().replace("#", "");
						return(thehashword);
					}
					else {return("");}
				}
				]]>
				</script>;



		public static var blankTheWindowStatus:XML = 
				<script>
				<![CDATA[
				function ()
				{
					window.status = "";
				}
				]]>
				</script>;

				
		public static function makeMasterTalkScript(how:Object):String {
					
				var output:String = 
				"<script><![CDATA[function(){"+(how.funcName ? how.funcName : "masterTalk")+" = function"+
				"() { var fcontenter;var outer;" + (how.id ? "" : "var ider = arguments[0].toString();") +
				(how.funcIs ? "" :"var funcIs = arguments[1].toString();")+
				"try {fcontenter=window.document.getElementById("+(how.id ? "'"+how.id+"'" : "ider")+");}catch(e) {"+
				"try {var theflash=" + (how.id ? "'" + how.id + "'" : "ider") + ";fcontenter=window.document.theflash;}catch(e) {var movie=" +
				(how.id ? "'"+how.id+"'" : "ider")+";"+
				"if (navigator.appName.indexOf('Microsoft')!=-1 || navigator.appName.indexOf('MSIE')!=-1) {"+ 
				"if (window.document[movie]){fcontenter=window.document[movie];}else{fcontenter=window[movie];};"+
				"}else {if (document.embeds[movie]){fcontenter=document.embeds[movie];}else"+
				"{fcontenter=document[movie];};}}}"+
				"if (arguments)"+
				" {var ars = Array.prototype.slice.call(arguments);" +
				(how.funcIs ? "" : "ars.shift();")+(how.id ? "" : "ars.shift();")+
				"outer = fcontenter["+(how.funcIs ? "'"+how.funcIs+"'" : "funcIs")+"].apply(fcontenter, ars);} else "+ 
				"{outer = fcontenter["+(how.funcIs ? "'"+how.funcIs+"'" : "funcIs")+"]();} return(outer); }; }]]></script>";
					
				return output;
					
		}

		public static function makeMasterTalk(nameToBe:String = null, funcIs:String = null, idIs:String = null):void
		{

			if (ExternalInterface.available) {

				var already:String = null;

				/* first the function checks to make sure the variable name choosen does not already exist */

				var checkFor:String = "masterTalk";

				if (nameToBe != null) checkFor = nameToBe;

				var seeCheck:String = "<script><![CDATA[function () {try{return("+checkFor+".toString());}"+
				"catch(e){return('undefined');} }]]></script>";
				var sc:XML = new XML(seeCheck);
  
				already = ExternalInterface.call(sc) + "";

				if (already == "undefined" || already == null) {

					var doneCheck:String = "<script><![CDATA[function () {"+checkFor+"Done = 'yes';}]]></script>";
					var dc:XML = new XML(doneCheck);

					var masterTalkBuild:String;

					/* used to create a javascript function that acts as the callBack function itself. */

					if (funcIs != null && idIs != null && nameToBe != null) {
						masterTalkBuild = DOMEx.makeMasterTalkScript( { "funcName":nameToBe, "id":idIs, "funcIs":funcIs } );
					}

					/* Variable ID */

					if (funcIs != null && idIs == null && nameToBe != null) {
						masterTalkBuild = DOMEx.makeMasterTalkScript( { "funcName":nameToBe, "funcIs":funcIs } );
					}

					/* Variable ID and callBack */

					if (funcIs == null && idIs == null && nameToBe != null) {
						masterTalkBuild = DOMEx.makeMasterTalkScript( { "funcName":nameToBe } );
					}

					/* variable ID and callBack and will be called masterTalk */

					if (funcIs == null && idIs == null && nameToBe == null) {
						masterTalkBuild = DOMEx.makeMasterTalkScript( { "funcName":"masterTalk" } );
					}

					if (!masterTalkBuild) {

						throw new Error("makeMasterTalk parameters are not in correct format for masterTalk creation.");

					}else {

						var builtFunction:XML = new XML(masterTalkBuild);

						ExternalInterface.marshallExceptions = true;
						ExternalInterface.call(builtFunction);
						ExternalInterface.call(dc);
					}

				}
				else
				{
    
					var backCheck:String = "<script><![CDATA[function () {return("+checkFor+"Done.toString());}]]></script>";
					var bc:XML = new XML(backCheck);

					var whatitis:String = ExternalInterface.call(bc) +"";


					if (whatitis != "yes") {
						var mterrorsay:String = "Error at ActionScript function makeMasterTalk: "+nameToBe+
						" is already defined in the wrapper. A masterTalk will not be applied to it.";
						ExternalInterface.call("alert", mterrorsay);
					}

				}

			}

		}



		public function invokeViaJavaScript(publicMethodName:*, ... args):*
		{

			var etex:String;
			var ther:*;

			if (args[0] != "=" || args.length == 0) {
				
				if (args.length == 0) {
					try {
					  
						ther = callTo[publicMethodName]();
					
					} catch (e:Error) {
					  
						try {
							ther = callTo[publicMethodName];
						} catch(e:Error) {
							etex = "AS3 Error " + e.message + " in relation to "+publicMethodName;
							if (ExternalInterface.available) ExternalInterface.call("alert", etex);
						}
					}
				   
				} else {
					
					try {
						
						ther = callTo.Function[publicMethodName].apply(null, args);
					   
					} catch (e:Error) { 
						
						try {
							ther = callTo[publicMethodName].apply(null, args);
						}catch(e:Error) { 
							etex = "AS3 Error " + e.message + " when trying to call "+publicMethodName;
							if (ExternalInterface.available) ExternalInterface.call("alert", etex);
						} 
						
					}	   
				}

			} else {

				try { 
					
					if (args[args.length-1] == "undefinedLock") {
						if (callTo[publicMethodName]) callTo[publicMethodName] = args[1];
					} else {
						callTo[publicMethodName] = args[1];
					}
					
				} catch (e:Error) {
					
					etex = "AS3 Error "+e.message+" when trying to set "+publicMethodName;
					if (ExternalInterface.available) ExternalInterface.call("alert", etex);
					
				}

			}	  

			return ther;  

		}


		public static function idGet(index:Number = 0):*
		{
			var outed:*;
			var idofswfobject:XML = 
			<script>
			<![CDATA[
			function (indexr) {
			
			 function getid(indexer) {
			  var objects;
			  var r = "";
				try {
				 
				 (document.getElementsByTagName("object")) ? 
				 objects = document.getElementsByTagName("object")[indexer] : 
				 objects = document.getElementsByTagName("OBJECT")[indexer];
						 
				 if (objects.hasAttribute("id") && !objects.id) {r=objects.getAttribute("id");}
				 if (objects.id && !objects.hasAttribute("ID")) {r=objects.id+"";}
				 if (objects.hasAttribute("ID")) {r=objects.getAttribute("ID");}
		 
				}catch (e) {

				  (document.getElementsByTagName("object")) ? 
				  objects = document.getElementsByTagName("object")[indexer] : 
				  objects = document.getElementsByTagName("OBJECT")[indexer];

				  if (objects && objects.outerHTML) {
					 var ohtml=objects.outerHTML.toString();
					 var idfind = new RegExp("id[ ]{0,}=[ ]{0,}[ a-zA-Z0-9\_\"]{1,}", "i");
					 var ridid = new RegExp("id", "i");
					 var rideq = new RegExp("[=\"]{1,}", "ig");
					 var ridspace = new RegExp("[ ]{1,}", "g");
					 var nocodeBase = new RegExp("codeBase|classid|height|width", "ig");
					 if (ohtml.match(idfind)) { 
				  r = 
				  ohtml.match(idfind).toString().replace(ridid, "").replace(rideq, 
				  "").replace(ridspace, "").replace(nocodeBase, "");
					 }else{r = "";}
				   }else {r = "";}

				}
			  return r;
			 };

			 return(getid(indexr));

			}
			]]>
			</script>;

			if (ExternalInterface.available) outed = ExternalInterface.call(idofswfobject, index);

			return outed;

		}

		public static function get objectID():String
		{
			var id:String = "";
			if (ExternalInterface.available) {
			  id = ExternalInterface.objectID;
			}
			return id;
		}


		public static function get marshall():Boolean
		{
			var m:Boolean = false;
			if (ExternalInterface.available) {
			  m = ExternalInterface.marshallExceptions;
			}
			return m;
		}


		public static function set marshall(b:Boolean):void
		{
			if (ExternalInterface.available) {
			  ExternalInterface.marshallExceptions = b;
			}
		}


		public static function addCall(callBack:String, callBackFunction:Function):Boolean
		{

			var tell:Boolean = false;

			if (ExternalInterface.available) {

				tell = true;
				try { 
					ExternalInterface.addCallback(callBack, callBackFunction);
				} catch (error:Error) {
					tell = false;
				}

			}

			return(tell);

		}



		public static function call(toCall:*, ...args):*
		{

			var tout:* = null;

			if (ExternalInterface.available) {
				
				if (args.length == 0) 
				{
					try{tout = ExternalInterface.call(toCall);} catch (e:Error) {}
				}
				else
				{
					args.unshift(toCall);
					/* this try catch guards against an unknown runtime error that happens sometimes in IE.
					 the error happens on the undocumented ExternalInterface._toAS method.
					 fortunetely, that method is the last thing to happen after the call has already gone through. */
					try {tout = ExternalInterface.call.apply(null, args);} catch (e:Error) {}
				}
			
			}

			return tout;
		  
		}


		public static function eget(fromThis:*, ...args):*
		{

			var toget:*;

			if (ExternalInterface.available) {

				if (args.length == 0)
				{toget = ExternalInterface.call(fromThis);}
				else {
					args.unshift(fromThis);
					toget = ExternalInterface.call.apply(null, args);
				}

			}

			return(toget);

		}


		public static function alert(thiser:String):void
		{
			if (ExternalInterface.available) {
				ExternalInterface.call("alert", thiser);
			}
		}

		
		public static function updateInnerHTML(actualElement:String, theString:String, 
			how:String = "byId", elementNumber:Number = 0, replaceIt:Boolean = false):Boolean
		{

			var didIt:Boolean = false;

			var inserter:XML =
			<script>
			<![CDATA[
			function (element, stringer, howto, elnum, rer) {

			  function doinsert(thisElement, thisString, hower, elnumber, replacer) {
			
				try {

				  if (hower == "byId" || hower == undefined) {
				   (replacer != undefined && replacer == true) ?
				   document.getElementById(thisElement).innerHTML = thisString :
				   document.getElementById(thisElement).innerHTML += thisString;
				  } else {

					if (hower == "byTagName") {
							(replacer != undefined && replacer == true ) ? 
							document.getElementsByTagName(thisElement)[elnumber].innerHTML = thisString :
							document.getElementsByTagName(thisElement)[elnumber].innerHTML += thisString;
					}

				  }

				} catch (e) {
				   alert(e+"   @ "+thisElement+" as thisElement.");
				}
			
			  };

			  doinsert(element, stringer, howto, elnum, rer);

			}
			]]>
			</script>;


			if (ExternalInterface.available) {
			  ExternalInterface.call(inserter, actualElement, theString, how, elementNumber, replaceIt);
			  didIt = true;
			}

			return(didIt);

		}

		public static function appendTextTo(anElement:String, theText:String, 
			how:String = "byId", elementNumber:Number = 0):Boolean
		{

			var didItA:Boolean = false;

			var inserterAppend:XML =
			<script>
			<![CDATA[
			function (element, stringer, howto, elnum) {

			  function doAppend(thisElement, thisText, hower, elnumber) {
			
				try {

				  if (hower == "byId" || hower == undefined) {
					var newText = document.createTextNode(thisText);
					document.getElementById(thisElement).appendChild(newText);
				  } else {

					if (hower == "byTagName") {
						  var newText = document.createTextNode(thisText); 
						  document.getElementsByTagName(thisElement)[elnumber].appendChild(newText);
					}
				  }

				} catch (e) {
				  alert(e+"   @ "+thisElement+" as thisElement.");
				}

			  };

			  doAppend(element, stringer, howto, elnum);

			}
			]]>
			</script>;

			if (ExternalInterface.available) {
			  ExternalInterface.call(inserterAppend, anElement, theText, how, elementNumber);
			  didItA = true;
			}

			return(didItA);

		}


		public static function resizeMakeAbleHorizontal(elements:String):Boolean
		{

			var toOut:Boolean = false;

			var makeHTMLElementHorizontallyResizeable:XML = 
			<tadScript>
			<![CDATA[
			function (allTheseElements) {


			  function resizeMakeAbleDoHorizontal(forAllTheseElements) {

				var alls = document.getElementsByTagName(forAllTheseElements);

			   if (alls.length > 0) {

				var dragsig = function(e) {
					var thee = (e != undefined) ? e : event;
					var moX = thee.clientX;var moY = thee.clientY;
					if (moX >= (this.offsetWidth - 40)) {this.title = "drag to resize";this.style.cursor = "pointer";}
					else {this.title = "";this.style.cursor = "auto";} 
				};

				var isdrag = false;

				for (var prei = 0; prei < alls.length; prei++) {

				alls[prei].onmousemove = dragsig;

				alls[prei].onmouseup = function () { isdrag = false; this.onmousemove = dragsig; };
			
				alls[prei].onmouseout = function () { isdrag = false; this.onmousemove = dragsig; };

				alls[prei].onscroll = function () { if (isdrag==false) {this.onmousemove = function() {}; }  };

				alls[prei].onmousedown = function (e) {

				  var thee = (e != undefined) ? e : event;var toWidth = this.offsetWidth;

				  if (thee.clientX >= toWidth - 40) {

					 this.onmousemove = function (e) {
					   var thee = (e != undefined) ? e : event;
						if (thee.preventDefault) thee.preventDefault();
					    var mX = thee.clientX;var mY = thee.clientY;
						if (mX >= this.offsetWidth - 40 && mX <= this.offsetWidth + 40) {
							 (mX >= 30) ? toWidth = mX : toWidth = toWidth;
							 isdrag = true;this.style.width = toWidth+"px";
						} 
					 };

				  } 

				}; 

				}

			   }else{alert("resizeMakeAbleHorizontal Error: 0 "+forAllTheseElements+"s found.");}

			  };

			  resizeMakeAbleDoHorizontal(allTheseElements);

			}
			]]>
			</tadScript>;


			if (ExternalInterface.available) {ExternalInterface.call(makeHTMLElementHorizontallyResizeable, elements);toOut = true;}

			return toOut;

		}

		public static function makeJavaScript(innerBody:String):XML
		{

				innerBody = innerBody.toString();

				var afunction:RegExp = new RegExp("function[ ]{0,}[a-zA-Z]{1,}[ ]{0,}[\(]{1}", "i");

				var buildXML:String;


			  if (innerBody.match(afunction))
			  {

				var argReg:RegExp = new RegExp("[\(]{1}[a-zA-Z0-9\.\, ]{1,}[\)]{1}", "i");

				if (innerBody.match(argReg)) {

				  var theArgString:String = "blank";
				  var theArgArray:Array;
				  var theArgArrayPre:String = innerBody.match(argReg).toString().replace("(", "").replace(")", "");

				  (theArgArrayPre.match(",")) ? theArgArray = theArgArrayPre.replace(/ /g, "").split(",") :
				  theArgArray = [ ""+theArgArrayPre.replace(/ /g,"")+"" ];

				  for (var i:int = 0; i<theArgArray.length; i++)
				  { theArgString += ","+theArgArray[i]+"A"; }

				  theArgString = theArgString.replace("blank,", "");
				  var theFunctionName:String = 
				  innerBody.match(afunction).toString().replace("function", "").replace("(", "").replace(/ /g, "");
				  buildXML = 
				  "<script><![CDATA[function ("+theArgString+") {"+innerBody+";"+theFunctionName+"("+theArgString+");}"+
				  "]]></script>";

				}else{throw new Error("Your JavaScript function must have () and at least one paramater.");}
				
			  }else {
				buildXML = "<script><![CDATA[" + innerBody + "]]></script>";
			  }


			var jsToDo:XML = new XML(buildXML);

			return jsToDo;

		}

	}

}