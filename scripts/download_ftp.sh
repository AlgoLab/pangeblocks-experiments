# copied from https://github.com/fawaz-dabbaghieh/PanPA/tree/main/tutorial
in_ftp=$1

while read -r ftp_line; do

	dir="${ftp_line%/*}"
	sample="${ftp_line##*/}"
	echo $dir
	echo $sample
	file=$dir/$sample/$sample\_protein.faa.gz

	if [ ! -f "$assembly_file" ];then
		echo "Downloading file $protein"
		wget $file --no-clobber
	fi
done < $in_ftp