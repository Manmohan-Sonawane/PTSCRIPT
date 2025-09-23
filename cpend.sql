select count(1) from fnd_concurrent_requests where trunc(REQUEST_DATE)=trunc(sysdate) and phase_code ='P';
