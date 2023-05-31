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

    if(PC != None)
        PlayerTeam = PC.GetTeamNum();
    
    if(TeamNum == 0)
        retval = class'Misc_Player'.default.TeamColorRed;
    else
        retval = class'Misc_Player'.default.TeamColorBlue;

    if(!class'Misc_Player'.default.bTeamColorUseTeam)
    {
        if(TeamNum == PlayerTeam)
        {
            //blue or ally
            retval = class'Misc_Player'.default.TeamColorBlue;
        }
        else
        {
            //red or enemy
            retval = class'Misc_Player'.default.TeamColorRed;
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