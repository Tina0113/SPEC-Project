function state = Transfer(roller, in, out)
    if(roller == 0 & in == 0 & out == 0 )
        state = 1
    elseif(roller == 0 & in == 0 & out == 1 )
        state = 2
    elseif(roller == 0 & in == 1 & out == 0 )
        state = 3
    elseif(roller == 0 & in == 1 & out == 1 )
        state = 4
    elseif(roller == 1 & in == 0 & out == 0 )
        state = 5
    elseif(roller == 1 & in == 0 & out == 1 )
        state = 6
    elseif(roller == 1 & in == 1 & out == 0 )
        state = 7
    else(roller == 1 & in == 1 & out == 1 )
        state = 8            
    end
end
%     if(out == 0 &  in == 0 & roller == 0)
%         state = 1
%     elseif(out == 0 &  in == 0 & roller == 1)
%         state = 2
%     elseif(out == 0 &  in == 1 & roller == 0)
%         state = 3
%     elseif(out == 1 &  in == 0 & roller == 0)
%         state = 4
%     elseif(out == 0 &  in == 1 & roller == 1)
%         state = 5
%     elseif(out == 1 &  in == 1 & roller == 0)
%         state = 6
%     elseif(out == 1 &  in == 1 & roller == 1)
%         state = 7
%     else(out == 1 &  in == 0 & roller == 1)
%         state = 8            
%     end
