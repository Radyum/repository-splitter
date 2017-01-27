#!/usr/bin/env bash

echo
echo "*---------------------------------*"
echo "| Interactive Repository Splitter |"
echo "*---------------------------------*"
echo
echo "Provide the main repository git address :"
read repo_address
git clone "$repo_address"
echo
echo "Moving to cloned main repository"
repo_name="$(basename "$repo_address")"
repo_name="${repo_name::-4}"
cd "$repo_name"
while true
do
	echo "Which folder would you like to split as a new repository ? ('none' to quit)"
	read folder
	if [ $folder == 'none' ]; then
		break
	fi
	git filter-branch --prune-empty --subdirectory-filter $folder  'master'
	echo
	echo "Provide the new git repository address (Repository must be previously created manually)" 
	read new_repo_address
	git remote set-url origin "$new_repo_address"
	git push --force -u origin master
	echo
	echo "New repository created!"
	echo
	echo "Rebuilding main repository"
	cd ..
	rm -rf "$repo_name"
	git clone "$repo_address"
	cd "$repo_name"
done
echo "bye"
