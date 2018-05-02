function myNet = initNet(netLayout)
    inputCount = netLayout(1);
    hiddenLayersConfig = netLayout(2:end);
    
    layerCount = length(hiddenLayersConfig);
    
    inputConnectMatrix = ones(1, inputCount);
    for i = 2:layerCount
        inputConnectMatrix = [inputConnectMatrix; zeros(1, inputCount)];
    end % end for i
    
    layerConnectMatrix = zeros(layerCount);  
    for j = 2:layerCount
        layerConnectMatrix(j, (j-1)) = 1;
    end %for j
    
    outputConnectMatrix = zeros(1, layerCount);
    outputConnectMatrix(layerCount) = 1;
    
    myNet = network(inputCount, layerCount, ones(layerCount, 1), inputConnectMatrix,layerConnectMatrix, outputConnectMatrix);
    myNet.inputs{:}.size = 1; % set len of input node matrix
    
    for k = 1:layerCount
        myNet.layers{k}.size = hiddenLayersConfig(k); % set num of nodes of a layer
        %myNet.layers{k}.transferFcn = 'logsig';
        myNet.layers{k}.transferFcn = 'tansig';
    end % for k
    %myNet.layers{layerCount}.transferFcn = 'logsig';
    %myNet.layers{layerCount}.transferFcn = 'roundedlogsig';
    myNet.layers{layerCount}.transferFcn = 'hardlogsig';
end

