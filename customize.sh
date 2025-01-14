[ -x "$(which magisk)" ] && MIRRORPATH=$(magisk --path)/.magisk/mirror || unset MIRRORPATH
array=$(find /system /vendor /product /system_ext -name WCNSS_qcom_cfg.ini)
for CFG in $array
do
[[ -f $CFG ]] && [[ ! -L $CFG ]] && {
SELECTPATH=$CFG
mkdir -p `dirname $MODPATH$CFG`
ui_print "- Migrating $MIRRORPATH$SELECTPATH"
cp -af $MIRRORPATH$SELECTPATH $MODPATH$SELECTPATH
ui_print "- Starting modifiy"
sed -i '/gChannelBondingMode24GHz=/d;/gChannelBondingMode5GHz=/d;/gForce1x1Exception=/d;/sae_enabled=/d;s/^END$/gChannelBondingMode24GHz=1\ngChannelBondingMode5GHz=1\ngForce1x1Exception=0\nsae_enabled=1\nEND/g' $MODPATH$SELECTPATH
}
done
[[ -z $SELECTPATH ]] && abort "- Installation FAILED. Your device didn't support WCNSS_qcom_cfg.ini." || { mkdir -p $MODPATH/system; mv -f $MODPATH/vendor $MODPATH/system/vendor; mv -f $MODPATH/product $MODPATH/system/product; mv -f $MODPATH/system_ext $MODPATH/system/system_ext;}
