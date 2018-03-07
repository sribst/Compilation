#!/bin/bash
declare -a arr=(
    "test"
    "defdef"
    "pow"
    "list"
    "ack"
    "ack_cont"
    "fibo"
    # "fibo_cont"
    # "fiboopt"
    "fact"
    "factopt"
    "fact_cont"
    "treelist"
)

echo "JAVIX with -noverify"
for i in "${arr[@]}"
do
    echo -n "$i : "
    ./flap.native -s fopix -t javix examples/"$i.fx"
    jasmin examples/"$i.j" >> /tmp/foo
    java -noverify examples/"$i"
done


echo "JAKIX without -noverify"
for i in "${arr[@]}"
do
    echo -n "$i : "
    ./flap.native -s fopix -t jakix examples/"$i.fx"
    jasmin examples/"$i.k" >> /tmp/foo
    java -noverify examples/"$i"
done
