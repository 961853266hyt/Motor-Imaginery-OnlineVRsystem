% client  �ú������ڷ����˶�����ķ����� 
function [] = sender()

tcpipClient = tcpip('127.0.0.1',55001,'NetworkRole','Client');
set(tcpipClient,'Timeout',30);
fopen(tcpipClient);

msg = '2';
% msg = classify();  ������
fwrite(tcpipClient,msg);
fclose(tcpipClient);
end