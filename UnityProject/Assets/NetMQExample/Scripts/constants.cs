using System.Collections;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using UnityEngine;

public static class Constants
{

    // instructions
    public static string START_GAME = "001";





    // classification result from matlab  
    public static string empty_state = "0";
    public static string left_hand = "1";
    public static string right_hand = "2";


    //settings
    public static string LIMB_NAME1 = "Hand";




    public static void Parse(string instruction)
    {
        switch (instruction)
        {
            case "001":
                Debug.Log("parse: " + START_GAME);
                break;
            default:
                Debug.Log("parse: ins input error");
                break;

        }


    }
}
