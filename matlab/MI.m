%�����ݽ���
nchannel = 9;
sampleRate = 1000;
bufferSize = 1;
port = 8712;
dataServer = DataServer('Neuracle', nchannel, '127.0.0.1', port, sampleRate, bufferSize);
dataServer.Open();
pause(10);
% t=TriggerBox();  %���¼���¼��¼�¼�
% t.OutputEventData(stinum); 
raw0 = dataServer.GetBufferData();%channel * buffersize * sampleRate
disp(raw0(1:100));
dataServer.Close();

