using UnityEngine;

public class HelloClient : MonoBehaviour
{
    private ReadThread _helloRequester;

    private void Start()
    {
        _helloRequester = new ReadThread();
        Debug.Log("start thread");
        _helloRequester.Start();
    }

    private void OnDestroy()
    {
        _helloRequester.Stop();
    }
}