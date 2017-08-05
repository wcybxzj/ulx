#!/bin/bash
fun(){
	sum=$(($1+$2))
	echo $sum
}
fun $1 $2
