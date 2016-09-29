#!/bin/bash
#kvm manager v1.0 
#by tianyun 04/28/2016

main_menu() {
	cat <<-YANG
	+-------------------------------------------------------+
	|                                                       |
	|                  KVM 管理器 v1.0   	                |
	|		1. 安装虚拟化软件			|
	|		2. 自动安装虚拟机			|
	|		3. 批量部署Linux虚拟机			|
	|		4. 批量部署Windows虚拟机		|
	|		5. 恢复指定虚拟机			|
	|		6. 删除指定虚拟机			|
	|		h. 打印管理菜单				|
	|		q. 退出KVM管理器			|
	+-------------------------------------------------------+ 
	YANG
}


main_menu

while :
do
	read -p "请选择相应的操作[q退出]: " choice
	case "$choice" in
	h|H)
		clear
		main_menu
		;;
	1)
		install_kvm_soft
		;;
	2)
		install_linux
		;;
	3)
		auto_install_linux
		;;	
	4)
		auto_install_windows
		;;
	5)
		rebuild_vm
		;;
	6)
		delete_vm
		;;
	q|Q)
		exit
		;;
	'')
		true
		;;
	*)
		echo "输入错误,重新输入"
	esac
done
