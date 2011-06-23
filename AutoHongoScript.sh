if [ a$ObjName == a ]; then
	echo "Set ObjName."
	exit
elif [ a$ObsID == a ]; then
        echo "Set ObsID."
        exit
fi

if [ a$version == a ]; then
    echo "Set version."
    exit
fi

suzaku_create_analysis_folder.sh $ObjName
cd $ObjName/data
suzaku_download_data_indicating_obsid.sh $ObsID $version

cd bgd
pin_download_nxbs.sh
gso_download_nxbs.sh

cd ../../analysis/xis/
xis_link_event.sh ../../data/$ObsID/

cd ../pin
pin_link_event.sh ../../data/$ObsID/

cd ../gso
gso_link_event.sh ../../data/$ObsID/

export HS_PDF_VIEWER=xpdf

if [ a$PINDISABLE != a ]; then
    echo "PIN analysis is skipped."
else
    cd ../pin/spectral_analysis
    go_hxd_pointsource.rb --detector pin --command extract_spectra --tagname cleanedevent
fi

if [ a$GSODISABLE != a ]; then
    echo "GSO analysis is skipped."
else
    cd ../../gso/spectral_analysis
    go_hxd_pointsource.rb --detector gso --command extract_spectra --tagname cleanedevent
fi

export ObsID=""
export ObjName=""

echo "Completed."
echo "Then, please process the XIS data manually."
