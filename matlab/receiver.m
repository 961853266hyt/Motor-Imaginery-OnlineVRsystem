% matlab as server
function [] = receiver
tcpipServer = tcpip('0.0.0.0',55010,'NetworkRole','Server');
fopen(tcpipServer);

while(1) %��ѯ��ֱ������������fread
    nBytes = get(tcpipServer,'BytesAvailable');
    if nBytes>0
        break;
    end
end
rawData = fread(tcpipServer,nBytes,'char');
rawwData = char(rawData')
disp(rawwData);
fclose(tcpipServer);
end

