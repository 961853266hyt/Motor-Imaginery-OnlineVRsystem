%打开数据接收
nchannel = 9;
sampleRate = 1000;
bufferSize = 1;
port = 8712;
dataServer = DataServer('Neuracle', nchannel, '127.0.0.1', port, sampleRate, bufferSize);
dataServer.Open();
pause(10);
% t=TriggerBox();  %打开事件记录记录事件
% t.OutputEventData(stinum); 
raw0 = dataServer.GetBufferData();%channel * buffersize * sampleRate
disp(raw0(1:100));
dataServer.Close();

