#!/bin/bash
rulespec=$1

rulespec_list=`cat $rulespec.rulesspec |grep -v "#"|grep -v "_base\/"|grep "engine/rules"|sed -e "s/.*.engine\/rules\///"  -e "s/\.rule.*/\.rule/"|sort|uniq -u > /tmp/rulespec_list`
rules_list=`ls ../rules/*/*/*.rule|grep -v "_base\/"|sed -e "s/.*.\/rules\///"|sort|uniq -u > /tmp/rules_list`

echo -e "\n## Rules not used in rulesspec \"$rulespec\":"
echo -e "Count: `grep -Fxcv -f  /tmp/rulespec_list /tmp/rules_list`\n"
grep -Fxv -f  /tmp/rulespec_list /tmp/rules_list


