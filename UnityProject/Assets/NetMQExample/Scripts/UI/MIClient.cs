using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class MIClient : MonoBehaviour
{
    private MIRequester _miRequester;
    private GameObject startbtnobj;
    private GameObject stopbtnobj;
    private GameObject showstateobj;


 
    private void Start()
    {
        Debug.Log("start MIclient");
        startbtnobj = GameObject.Find("StartButton");
        stopbtnobj = GameObject.Find("StopButton");
        showstateobj = GameObject.Find("ShowText");
        startbtnobj.GetComponent<Button>().onClick.AddListener(OnStartBtnclick);
        stopbtnobj.GetComponent<Button>().onClick.AddListener(OnStopBtnclick);
    }
    public void OnStartBtnclick()
    {
        ClientStart();
        Debug.Log("click btn1");
    }

    public void OnStopBtnclick()
    {
        ClientStop();
        showstateobj.GetComponent<Text>().text = "connection is lost";
    }


    private void ClientStart()
    {
        _miRequester = new MIRequester();
        if (_miRequester == null)
        {
            showstateobj.GetComponent<Text>().text = "creating requester failed";
        }
        else
        {
            showstateobj.GetComponent<Text>().text = "connection succeed";
        }
        _miRequester.Start();
    }

    private void ClientStop()
    {
        _miRequester.Stop();
    }

    private void OnDestroy()
    {
        if (_miRequester!=null)
            _miRequester.Stop();
    }
}