#!/bin/bash

echo "Enter the inventory filename:"
read inventory

echo "Running checks for the following hosts:"
cat $inventory | grep -iv "contract" | awk '{print $1}'

./check_dashboard.py $inventory

while read -r playbook test
do
ansible-playbook -i $inventory $playbook --check > ./tmp/ntp
grep -i changed= ./tmp/ntp | grep -iv changed=0
ret_code=$?
if [ $ret_code -eq 0 ]
then
{
        echo $test test failed 
}
else
{
        echo $test test passed 
}
fi
done < "checkindex.txt"
