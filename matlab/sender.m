% client  该函数用于发送运动想像的分类结果 
function [] = sender()

tcpipClient = tcpip('127.0.0.1',55001,'NetworkRole','Client');
set(tcpipClient,'Timeout',30);
fopen(tcpipClient);

msg = '2';
% msg = classify();  分类结果
fwrite(tcpipClient,msg);
fclose(tcpipClient);
end