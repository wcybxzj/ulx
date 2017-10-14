#!/bin/sh

func1(){
	return 1
}

func0(){
	return 0
}

func3(){
	:
}

fun(){
	func0||echo 'not see'
	func1||echo 'see'
	func3||echo 'not see'
}

fun

