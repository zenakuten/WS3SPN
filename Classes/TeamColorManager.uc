class TeamColorManager extends Object;

// skin colors go from 0-100?
static function byte cscale(byte in)
{
    return byte(float(in)/100.0*255.0);
}

static function Color GetColor(int TeamNum, PlayerController PC)
{
    local Color retval;
    local int PlayerTeam;

    if(class'Misc_Player'.default.bUseTeamColors)
    {
        if(TeamNum == 0)
        {
            retval = class'Misc_Player'.default.TeamColorRed;
            if(class'Misc_Player'.default.bTeamColorUseBrightSkinsEnemy)
            {
                retval.R = cscale(class'Misc_Player'.default.RedOrEnemy.R);
                retval.G = cscale(class'Misc_Player'.default.RedOrEnemy.G);
                retval.B = cscale(class'Misc_Player'.default.RedOrEnemy.B);
                retval.A = cscale(class'Misc_Player'.default.RedOrEnemy.A);
            }
        }
        else
        {
            retval = class'Misc_Player'.default.TeamColorBlue;
            if(class'Misc_Player'.default.bTeamColorUseBrightSkinsAlly)
            {
                retval.R = cscale(class'Misc_Player'.default.BlueOrAlly.R);
                retval.G = cscale(class'Misc_Player'.default.BlueOrAlly.G);
                retval.B = cscale(class'Misc_Player'.default.BlueOrAlly.B);
                retval.A = cscale(class'Misc_Player'.default.BlueOrAlly.A);
            }
        }
    }
    else
    {
        if(PC != None)
            PlayerTeam = PC.GetTeamNum();
        
        if(TeamNum == 0)
            retval = class'Misc_Player'.default.TeamColorRed;
        else
            retval = class'Misc_Player'.default.TeamColorBlue;

        if(TeamNum == PlayerTeam && class'Misc_Player'.default.bTeamColorUseBrightSkinsAlly)
        {
            retval.R = cscale(class'Misc_Player'.default.BlueOrAlly.R);
            retval.G = cscale(class'Misc_Player'.default.BlueOrAlly.G);
            retval.B = cscale(class'Misc_Player'.default.BlueOrAlly.B);
            retval.A = cscale(class'Misc_Player'.default.BlueOrAlly.A);
        }
        else if(TeamNum != PlayerTeam && class'Misc_Player'.default.bTeamColorUseBrightSkinsEnemy)
        {
            retval.R = cscale(class'Misc_Player'.default.RedOrEnemy.R);
            retval.G = cscale(class'Misc_Player'.default.RedOrEnemy.G);
            retval.B = cscale(class'Misc_Player'.default.RedOrEnemy.B);
            retval.A = cscale(class'Misc_Player'.default.RedOrEnemy.A);
        }
    }

    return retval;
}

static function byte GetHue(Color c)
{
    local float cmin,cmax, hue;
    local int red,green,blue;

    red=c.R;
    green=c.G;
    blue=c.B;

    cmin = min(min(red, green), blue);
    cmax = max(max(red, green), blue);

    if (cmin == cmax) {
        return 0;
    }

    hue = 0;
    if (cmax == red) {
        hue = (green - blue) / (cmax - cmin);

    } else if (cmax == green) {
        hue = 2f + (blue - red) / (cmax - cmin);

    } else {
        hue = 4f + (red - green) / (cmax - cmin);
    }

    hue = hue * 42.5;
    if (hue < 0) hue = hue + 255;

    hue= round(hue);
    return hue;
}

defaultproperties
{
}