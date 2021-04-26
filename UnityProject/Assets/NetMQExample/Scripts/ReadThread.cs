using System.Collections;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using UnityEngine;
using System.IO;
using System.Text;
using System.Globalization;
using System;

public class ReadThread : RunAbleThread
{
    TcpListener listener;
    private string msg;
    private Int32 port = 55001;


    protected override void Run()
    {
        listener = new TcpListener(IPAddress.Parse("127.0.0.1"), port);
        listener.Start();
        Debug.Log("is listening");
        while (true)
        {
            if (!listener.Pending())
            {
            }
            else
            {
                Debug.Log("socket comes");
                TcpClient client = listener.AcceptTcpClient();
                NetworkStream ns = client.GetStream();
                StreamReader reader = new StreamReader(ns);
                msg = reader.ReadToEnd();
                ns.Close();
                Debug.Log(msg);
                LimbController.SetState(msg);// 将分类结果在unity中以动画的效果展示出来
                break;
            }
        }

    }

    new public void Stop()
    {
        listener.Stop();
        base.Stop();

    }


}
