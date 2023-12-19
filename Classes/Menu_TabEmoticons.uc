class Menu_TabEmoticons extends UT2k3TabPanel;

var automated AltSectionBackground BackG;
var automated GUIVertScrollBar ScrollBar;
var EmoticonsReplicationInfo ERI;
var int Offset;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

    if(Misc_Player(PlayerOwner()) != None)
    {
        ERI = Misc_Player(PlayerOwner()).EmoteInfo;
        ScrollBar.ItemCount=ERI.Smileys.length;
    }
	
}

delegate PositionChanged(int NewPos)
{
	Offset = NewPos;
}

delegate OnRender(Canvas C)
{	
	local int i;
	local float x, y, w, h;
	local float iconY;
	
	x = PageOwner.ActualLeft();
	y = PageOwner.ActualTop();
	w = PageOwner.ActualWidth();
	h = PageOwner.ActualHeight();	
	
	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;
	C.DrawColor.A = 255;
	
	C.SetOrigin(x+64, y+128);
	C.SetClip(w,h);

    if(ERI == None)
        return;
	
	iconY = 0;
	
	for(i=0; i<ERI.Smileys.Length; ++i)
	{		
		if(Offset>i)
			continue;
			
		C.SetPos(0,iconY);
        if(ERI.Smileys[i].Icon != None)
            C.DrawTile(ERI.Smileys[i].Icon, 64,64, 0,0,64,64);
        else if(ERI.Smileys[i].MatIcon != None)
            C.DrawTile(ERI.Smileys[i].MatIcon, 64,64, 0,0,64,64);
		C.SetPos(128,iconY);
		C.DrawText(ERI.Smileys[i].Event);
		
		iconY += 64;
		
		if(C.OrgY+iconY+32 >= C.ClipY)
			break;
	}
}

defaultproperties
{
     Begin Object Class=AltSectionBackground Name=BackGObj
         bFillClient=True
         Caption="Emoticons"
         LeftPadding=0.000000
         RightPadding=0.000000
         WinHeight=1.000000
         OnPreDraw=BackGObj.InternalPreDraw
         OnRendered=Menu_TabEmoticons.OnRender
     End Object
     BackG=AltSectionBackground'3SPNvSoL.Menu_TabEmoticons.BackGObj'

     Begin Object Class=GUIVertScrollBar Name=ScrollBarObj
         ItemsPerPage=5
         PositionChanged=Menu_TabEmoticons.PositionChanged
         WinTop=0.050000
         WinLeft=0.955000
         WinWidth=0.035000
         WinHeight=0.900000
         OnPreDraw=ScrollBarObj.GripPreDraw
     End Object
     ScrollBar=GUIVertScrollBar'3SPNvSoL.Menu_TabEmoticons.ScrollBarObj'
}