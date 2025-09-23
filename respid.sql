select * from fnd_user_resp_groups where responsibility_id = (select responsibility_id from fnd_responsibility_tl
where responsibility_NAME='&responsibility_name');
