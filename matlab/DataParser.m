classdef DataParser < handle
% Data parser for TCP/IP
%
% Syntax:  
%     
%
% Inputs:
%     
%
% Outputs:
%     
%
% Example:
%     
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% Author: Xiaoshan Huang, hxs@neuracle.cn
%
% Versions:
%    v0.1: 2016-11-02, orignal
%    v0.2: 2017-05-17, add NeuroScan data parser
%
% Copyright (c) 2016 Neuracle, Inc. All Rights Reserved. http://neuracle.cn/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties (Constant)
        
    end

    properties
        device;
        nChan;
        buffer;
    end

    methods
        function obj = DataParser(device, nChan)
            obj.device = device;
            obj.nChan = nChan;
        end

        function WriteData(obj, buffer, ringBuffer)
            buffer = uint8(buffer(:));
            obj.buffer = [obj.buffer; buffer];
            if obj.nChan ~= ringBuffer.nChan
                error('Channel number mismatch.');
            end
            switch obj.device
                case 'Neuracle'
                    [data, event, obj.buffer] = ParseDataNeuracle(obj, obj.buffer, ringBuffer.nChan);
                    data = typecast(data,'single');
                case 'Neuracle-32'
                    [data, event, obj.buffer] = ParseDataNeuracle(obj, obj.buffer, ringBuffer.nChan);
                    data = typecast(data,'single');
                case 'DSI-24'
                    [data, event, obj.buffer] = ParseDataWS(obj, obj.buffer);
                    if ~isempty(data)
                        data = [data.ChannelData];
                        data = data(:);
                        data = swapbytes(typecast(data,'single'));
                    end
                case 'DSI-7'
                    [data, event, obj.buffer] = ParseDataWS(obj, obj.buffer);
                    if ~isempty(data)
                        data = [data.ChannelData];
                        data = data(:);
                        data = swapbytes(typecast(data,'single'));
                    end
                case 'NeuroScan'
                    [data, event, obj.buffer] = ParseDataNeuroScan(obj, obj.buffer, ringBuffer.nChan);
                otherwise
                    error('Device not supported');
            end
            data = reshape(data, ringBuffer.nChan, numel(data)/ringBuffer.nChan);
            ringBuffer.Append(data);
        end
        
        function [data, event, buffer] = ParseDataNeuracle(obj, buffer, nChan)
            n = numel(buffer);
            data = [];
            event = [];
            data = buffer(1:n-mod(n,4*nChan));
            buffer = buffer(n-mod(n,4*nChan)+1:n);
        end
        
        function [data, event, buffer] = ParseDataNeuroScan(obj, buffer, nChan)
            data = [];
            event = [];
            nHeader = 12;
            nPoint = 40;
            nBytes = 4;
            nPacket = nHeader+nBytes*nChan*nPoint;
            while numel(buffer) >= nPacket
                data = [data; buffer((nHeader+1):nPacket)];
                buffer = buffer((nPacket+1):end);
            end
            data = double(typecast(data,'int32'));
            data = reshape(data, nChan, numel(data)/nChan);
            data(1:end-1,:) = data(1:end-1,:) * 0.15;
            data(end,:) = [0 data(end, 2:end) - data(end, 1:end-1)];
            data = data(:);
        end

        function [data, event, buffer] = ParseDataWS(obj, buffer)
            token = unicode2native('@ABCD')';
            n = numel(buffer);
            i = 1;
            data = [];
            iData = 1;
            event = [];
            iEvent = 1;
            while i + 12 < n
                if isequal(buffer(i:i+4), token)
                    packetType = buffer(i+5);
                    bytes = double(buffer(i+6:i+7));
                    packetLength = 256*bytes(1)+bytes(2);
                    bytes = double(buffer(i+8:i+11));
                    packetNumber = 16777216*bytes(1)+65536*bytes(2)+256*bytes(3)+bytes(4);
                    if i+12+packetLength-1 > n
                        break;
                    end
                    switch packetType
                        case 1
                            bytes = double(buffer(i+12:i+15));
                            data(iData).TimeStamp = 16777216*bytes(1)+65536*bytes(2)+256*bytes(3)+bytes(4);
                            data(iData).DataCounter = buffer(i+16);
                            data(iData).ADCStatus = buffer(i+17:i+22);
                            data(iData).ChannelData = buffer(i+23:i+12+packetLength-1);
                            iData = iData+1;
                        case 5
                            bytes = double(buffer(i+12:i+15));
                            event(iEvent).EventCode = 16777216*bytes(1)+65536*bytes(2)+256*bytes(3)+bytes(4);
                            bytes = double(buffer(i+16:i+19));
                            event(iEvent).SendingNode = 16777216*bytes(1)+65536*bytes(2)+256*bytes(3)+bytes(4);
                            if packetLength > 20
                                bytes = double(buffer(i+20:i+23));
                                event(iEvent).MessageLength = 16777216*bytes(1)+65536*bytes(2)+256*bytes(3)+bytes(4);
                                event(iEvent).Message = buffer(i+24:i+24+event(iEvent).MessageLength-1);
                            end
                            iEvent = iEvent+1;
                        otherwise
                    end
                    i = i+12+packetLength;
                else
                    i = i+1;
                end

            end
            buffer = buffer(i:end);
        end
        
    end
end


