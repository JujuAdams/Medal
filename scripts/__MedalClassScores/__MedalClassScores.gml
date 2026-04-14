/// @param scoresID
/// @param formattedServiceRef
/// @param range

function __MedalClassScores(_scoresID, _formattedServiceRef, _range) constructor
{
    static _system = __MedalSystem();
    
    __scoresID            = _scoresID;
    __formattedServiceRef = _formattedServiceRef;
    __range               = _range;
    __state               = MEDAL_LB_STATE_NO_DATA;
    __lastRequestTime     = -infinity;
    __asyncID             = undefined;
    __data                = [];
    
    
    
    static __GetScores = function()
    {
        if (__asyncID != undefined)
        {
            //Pending
            return;
        }
        
        if (_system.__local)
        {
            //TODO
        }
        else
        {
            if (_system.__steamAvailable)
            {
                if (__range == MEDAL_RANGE_TOP)
                {
                    __asyncID = steam_download_scores(__formattedServiceRef, 1, 10);
                }
                else if (__range == MEDAL_RANGE_FRIENDS)
                {
                    __asyncID = steam_download_friends_scores(__formattedServiceRef);
                }
                else if (__range == MEDAL_RANGE_AROUND)
                {
                    __asyncID = steam_download_scores_around_user(__formattedServiceRef, -5, 5);
                }
                
                __MedalRegisterAsyncID(__asyncID, function(_aborted)
                {
                    __asyncID = undefined;
                    
                    if (_aborted)
                    {
                        __state = MEDAL_LB_STATE_ERROR;
                        return;
                    }
                    
                    __state = MEDAL_LB_STATE_SUCCESS;
                });
            }
            else
            {
                if (MEDAL_RUNNING_FROM_IDE)
                {
                    __MedalError($"Unhandled OS {os_type}. Please report this error");
                }
                else
                {
                    __MedalTrace($"Warning! Unhandled OS {os_type}");
                }
            }
            
            if (__asyncID != undefined)
            {
                if (__state != MEDAL_LB_STATE_ERROR)
                {
                    __state = MEDAL_LB_STATE_PENDING;
                }
            }
        }
        
        return undefined;
    }
}