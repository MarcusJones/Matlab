function trnTime = set_operation_mask(trnTime,settings)

% Re-create the operation mask from the settings
hourFractions=trnTime.time-floor(trnTime.time);
startTime=datenum(0,0,0,settings.operationMask.startOperationHour,0,0);
stopTime=datenum(0,0,0,settings.operationMask.stopOperationHour,0,0);
trnTime.operationMask = ((hourFractions>=startTime) & (hourFractions<=stopTime));

% Apply the operation mask to the overall mask
if settings.operationMask.useOperationMask
    trnTime.mask = trnTime.operationMask;
else % Or use entire range
    trnTime.mask = logical(ones(length(trnTime.operationMask),1));
end

end