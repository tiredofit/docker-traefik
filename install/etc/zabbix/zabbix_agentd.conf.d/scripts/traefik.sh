#!/usr/bin/with-contenv bash

URL=localhost
PROTO=http
PORT=8080

if [ "$ENABLE_API" = "TRUE" ]; then
    if [ "$ENABLE_DASHBOARD_AUTHENTICATION" = "TRUE" ]; then
            url="${PROTO}://${DASHBOARD_ADMIN_USER}:${DASHBOARD_ADMIN_PASS}@${URL}:${PORT}/health"
    else
            url="${PROTO}://${URL}:${PORT}/health"
    fi

    output=$(curl --silent -X GET ${url})
fi

function trapper {
	pid=$( echo "$output" | jq '.["pid"]' )
	uptime=$(echo "$output" | jq '.["uptime_sec"]')
	status_code_count=$(echo "$output" | jq '.["status_code_count"]')
	total_status_200=$(echo "$output" | jq '.["total_status_code_count"]["200"]')
	total_status_204=$(echo "$output" | jq '.["total_status_code_count"]["201"]')
	total_status_204=$(echo "$output" | jq '.["total_status_code_count"]["204"]')
	total_status_301=$(echo "$output" | jq '.["total_status_code_count"]["301"]')
	total_status_302=$(echo "$output" | jq '.["total_status_code_count"]["302"]')
	total_status_303=$(echo "$output" | jq '.["total_status_code_count"]["303"]')
	total_status_304=$(echo "$output" | jq '.["total_status_code_count"]["304"]')
	total_status_308=$(echo "$output" | jq '.["total_status_code_count"]["308"]')
	total_status_401=$(echo "$output" | jq '.["total_status_code_count"]["401"]')
	total_status_403=$(echo "$output" | jq '.["total_status_code_count"]["403"]')
	total_status_404=$(echo "$output" | jq '.["total_status_code_count"]["404"]')
	total_status_407=$(echo "$output" | jq '.["total_status_code_count"]["407"]')
	total_status_499=$(echo "$output" | jq '.["total_status_code_count"]["499"]')
	total_status_500=$(echo "$output" | jq '.["total_status_code_count"]["500"]')
	total_status_501=$(echo "$output" | jq '.["total_status_code_count"]["501"]')
	total_status_502=$(echo "$output" | jq '.["total_status_code_count"]["502"]')
	total_status_503=$(echo "$output" | jq '.["total_status_code_count"]["503"]')
	total_status_504=$(echo "$output" | jq '.["total_status_code_count"]["504"]')
	count=$(echo "$output" | jq '.["count"]')
	total_count=$(echo "$output" | jq '.["total_count"]')
	total_response_time=$(echo "$output" | jq '.["total_response_time_sec"]')
	total_response_size=$(echo "$output" | jq '.["total_response_size"]')
	average_response_time=$(echo "$output" | jq '.["average_response_time"]')
	average_response_size=$(echo "$output" | jq '.["average_response_size"]')
	average_metrics_timers=$(echo "$output" | jq '.["average_metrics_timers"]')
	average_metrics_count=$(echo "$output" | jq '.["average_metrics_count"]')

	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[pid] -o `echo $pid`
	if [ -z "$uptime" ]; then 
		uptime=0
	else
		uptime=`echo $uptime | cut -d . -f1`
	fi
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[uptime] -o `echo $uptime`
	if [ -z "$average_response_time" ]; then 
		average_response_time=0
	else
		average_response_time=`echo $average_response_time | cut -d . -f1`
	fi
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[response.time.average] -o `echo $average_response_time`
	if [ -z "$average_response_size" ]; then average_response_size=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[response.size.average] -o `echo $average_response_size`
	if [ -z "$count" ]; then count=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[code.count] -o `echo $count`
	if [ -z "$total_count" ]; then count=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[code.count.total] -o `echo $total_count`
	if [ -z "$total_response_time" ]; then
		total_response_time=0
	else
		total_response_time=`echo $total_response_time | cut -d . -f1`
	fi
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[response.time.total] -o `echo $total_response_time`
	if [ -z "$total_response_size" ]; then total_response_size=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[response.size.total] -o `echo $total_response_size`
	if [ "$total_status_200" = "null" ] || [ -z "$total_status_200" ]; then total_status_200=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[code.200] -o `echo $total_status_200`
	if [ "$total_status_201" = "null" ] || [ -z "$total_status_201" ]; then total_status_201=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[code.201] -o `echo $total_status_201`
	if [ "$total_status_204" = "null" ] || [ -z "$total_status_204" ]; then total_status_200=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[code.204] -o `echo $total_status_204`
	if [ "$total_status_301" = "null" ] || [ -z "$total_status_301" ]; then total_status_302=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[code.301] -o `echo $total_status_301`
	if [ "$total_status_302" = "null" ] || [ -z "$total_status_302" ]; then total_status_302=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[code.302] -o `echo $total_status_302`
	if [ "$total_status_303" = "null" ] || [ -z "$total_status_303" ]; then total_status_303=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[code.303] -o `echo $total_status_303`
	if [ "$total_status_304" = "null" ] || [ -z "$total_status_304" ]; then total_status_304=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[code.304] -o `echo $total_status_304`
	if [ "$total_status_401" = "null" ] || [ -z "$total_status_401" ]; then total_status_401=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[code.401] -o `echo $total_status_401`
	if [ "$total_status_403" = "null" ] || [ -z "$total_status_403" ]; then total_status_403=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[code.403] -o `echo $total_status_403`
	if [ "$total_status_404" = "null" ] || [ -z "$total_status_404" ]; then total_status_404=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[code.404] -o `echo $total_status_404`
	if [ "$total_status_407" = "null" ] || [ -z "$total_status_407" ]; then total_status_404=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[code.407] -o `echo $total_status_407`
	if [ "$total_status_499" = "null" ] || [ -z "$total_status_499" ]; then total_status_404=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[code.499] -o `echo $total_status_499`
	if [ "$total_status_500" = "null" ] || [ -z "$total_status_500" ]; then total_status_500=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[code.500] -o `echo $total_status_500`
	if [ "$total_status_501" = "null" ] || [ -z "$total_status_501" ]; then total_status_501=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[code.501] -o `echo $total_status_501`
	if [ "$total_status_502" = "null" ] || [ -z "$total_status_502" ]; then total_status_502=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[code.502] -o `echo $total_status_502`
	if [ "$total_status_503" = "null" ] || [ -z "$total_status_503" ]; then total_status_503=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[code.503] -o `echo $total_status_503`
	if [ "$total_status_504" = "null" ] || [ -z "$total_status_504" ]; then total_status_504=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[code.504] -o `echo $total_status_504`
	if [ "$average_metrics_timers" = "{}" ] || [ -z "$average_metrics_timers" ]; then average_metrics_timers=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[metrics.timers.average] -o `echo $average_metrics_timers`
	if [ "$average_metrics_count" = "null" ] || [ -z "$average_metrics_count" ]; then average_metrics_count=0; fi;
	zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k status[metrics.count.average] -o `echo $average_metrics_count`
}

trapper > /dev/null
