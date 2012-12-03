#!/bin/sh
# Parameters are: [start sip_start number] [end sip_end number] 


outdir=/etc/asterisk/sip_custom.conf
outaddr=/etc/asterisk/extensions_custom.conf


echo "[test_dialplan]" >> $outaddr

for ((sip_num = $1; sip_num <= $2; sip_num++))
do
  
    		
    echo "exten => $sip_num,1,Dial(SIP/$sip_num)" >> $outaddr

		
done
