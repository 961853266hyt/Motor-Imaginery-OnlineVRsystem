using UnityEngine;
using System.Collections;
using System.Net;
using System.Net.Sockets;
using System.Linq;
using System;
using System.IO;
using System.Text;
public class WriteThread : RunAbleThread
{
    // Use this for initialization
    internal Boolean socketReady = false;
    TcpClient wSocket;
    NetworkStream wStream;
    StreamWriter theWriter;
    //StreamReader theReader;
    String Host = "localhost";
    Int32 WritingPort = 55010;
    //Int32 ReadingPort = 55009;
    string msg;

    public WriteThread(string msg)
    {
        this.msg = msg;
    }


    public void setupSocket()
    {
        try
        {
            wSocket = new TcpClient(Host, WritingPort);
            wStream = wSocket.GetStream();
            theWriter = new StreamWriter(wStream);
        }
        catch (Exception e)
        {
            Debug.Log("Socket error: " + e);
        }
    }

    public void sendmsg()
    {
        socketReady = true;
        //writeSocket("yah!! it works");
        Byte[] sendBytes = Encoding.UTF8.GetBytes(msg); //--> if the above line doesn't work use this line instead
        wSocket.GetStream().Write(sendBytes, 0, sendBytes.Length); // with this one also
        Debug.Log("socket is sent");

    }

    protected override void Run()
    {
        Debug.Log("run write thread");
        setupSocket();
        Debug.Log("socket is set up");
        sendmsg();
    }

    new public void Stop()
    {
        wSocket.Close();
        base.Stop();

    }
}