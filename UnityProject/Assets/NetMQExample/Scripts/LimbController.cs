using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LimbController:MonoBehaviour
{
    private static GameObject limb;
    public  static string State = Constants.empty_state;

    private void Start()
    {
        limb = GameObject.Find(Constants.LIMB_NAME1);
    }

    

    public static void SetState(string msg)
    {
        if (msg.Equals(Constants.left_hand))
        {
            State = Constants.left_hand;

        }

        else if (msg.Equals(Constants.right_hand))
        {
            State = Constants.right_hand;
        }
        else  //empty state
        {

           
        }


    }


    private void Update()
    {
        if (State.Equals(Constants.left_hand))
        {
            limb.transform.Translate(Vector3.left * Time.deltaTime);
            //Debug.Log("向左移动");
        }
        else if (State.Equals(Constants.right_hand))
        {
            limb.transform.Translate(Vector3.right * Time.deltaTime);
            //Debug.Log("向右移动");

        }
        else if ((State.Equals(Constants.empty_state)))
        {
           // Debug.Log("empty state");
        }
    }



}
