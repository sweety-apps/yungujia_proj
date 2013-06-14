#pragma strict
//æ¸¸æææå¯¹è±¡  
var moveJoystick : Joystick; 
var joystickTrans : Transform; 
var cameraTrans : Transform; 

private var testString : String;
private var infoString : String;

function Start() {
	testString = "start";
	infoString = "欢迎来到牛头人的世界";
}  
  
function Update () {  
    //å¾å°æ¸¸æææçåé¦ä¿¡æ¯ï¼å¾å°çå¼æ¯ -1 å° +1 ä¹é´  
    
    //
    joystickTrans.position = cameraTrans.position;
    joystickTrans.rotation = cameraTrans.rotation;
    //cameraTrans.position.z += 10;
      
    var touchKey_x =  moveJoystick.position.x;  
    var touchKey_y =  moveJoystick.position.y;  
      /*
    //ææåå·¦  
    if(touchKey_x == -1){  
          //
    }  
    //ææåå³  
    else if(touchKey_x == 1){  
        //x += planSpeed;  
          
    }  
    //ææåä¸  
    if(touchKey_y == -1){  
        //y += planSpeed;  
          
    }  
    //ææåä¸  
    else if(touchKey_y == 1){  
        //y -= planSpeed;  
          
    }  
      
    //é²æ­¢é£æºé£åºå±å¹ï¼åºçæ£æµ  
    if(x < 0){  
        //x = 0;  
    }else if(x > cross_x){  
        //x = cross_x;  
    }  
      
    if(y < 0){  
        //y = 0;  
    }else if(y > cross_y){  
       // y = cross_y;  
    }  
    */
}  
  
  
  
  
function OnGUI () {  
	
	//testString = "Free";
	
	/*
	if(GUI.Button(new Rect(40,40,30,30),"W"))
	{
		testString = "Up";
	}
	
	if(GUI.Button(new Rect(10,75,30,30),"A"))
	{
		testString = "Left";
	}
	
	if(GUI.Button(new Rect(70,75,30,30),"D"))
	{
		testString = "Right";
	}
	
	if(GUI.Button(new Rect(40,110,30,30),"S"))
	{
		testString = "Down";
	}
	
	if(GUI.Button(new Rect(40,75,30,30)," "))
	{
		testString = "Stop";
	}
	
	  
	GUI.Label(new Rect(10,10,200,20),testString);  
	*/
	//GUI.Label(new Rect(10,10,200,20),infoString);
}