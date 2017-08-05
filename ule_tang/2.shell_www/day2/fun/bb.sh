#!/bin/bash
fun(){
	local x=123
	echo "in fun"
	echo $x
}
fun

echo "out of fun"
echo $x
