# 清理工程, 并编译工程, 生成xcarchive文件
# $1 编辑mode
# $2 .xcworkspace文件路径
# $3 scheme名称
# $4 保存文件夹路径
# $5 plist路径
# $6 1 or 0 是否生成 dSYM
# $7 保存 xx.xcarchive 文件夹路径
function createXcarchiveFile() {

    development_mode=$1
    xcworkspace_path=$2
    scheme_name=$3
    build_path=$4
    projectPlist_path=$5
    generateDSYM=$6

    echo '-----------'
    echo '该次编译mode:'${development_mode}
    echo '-----------'

    echo "development_mode: $1"
    echo "xcworkspace_path: $2"
    echo "scheme_name: $3"
    echo "build_path: $4"
    echo "projectPlist_path: $5"
    echo "dSYM: $6"
    echo "Save .Xcarchive Path: $7"

    echo '49CECB67-99E5-4B30-A73F-D5EBD8AA3E68'

    echo '-----------'
    echo ' 开始清理工程 '
    echo '-----------'
    xcodebuild \
        clean \
        -workspace "${xcworkspace_path}" \
        -scheme "${scheme_name}" \
        -configuration ${development_mode} -quiet || exit
    echo '--------'
    echo ' 清理完成 '
    echo '--------'
    echo ''

    echo 'A0661894-953B-41B6-B0A4-B520163E1DA2'
    
    directionPath=$7
    xcarchive_path="${directionPath}/${scheme_name}.xcarchive"

    dSYMFolderPath="${directionPath}/dSYM"

    #判断文件夹是否已创建, -d文件夹, -f文件
    if [ ! -d ".${directionPath}" ]; then
        mkdir -p "$directionPath"
    fi

    if [ ! -d ".${dSYMFolderPath}" ]; then
        mkdir -p "$dSYMFolderPath"
    fi

    echo '6042B410-261D-4B81-9037-9B4288DCAFB0'

    #开始编译
    if [ $generateDSYM == 1 ] || [ "$generateDSYM" == "1" ]; then

        echo '-----------'
        echo ' 正在编译工程(生成dSYM) '
        echo '-----------'
        # DEBUG 编译没有出来dSYM, 是因为配置问题, 这里直接改配置就好 DEBUG_INFORMATION_FORMAT='dwarf-with-dsym'
        xcodebuild archive \
            -workspace "${xcworkspace_path}" \
            -scheme "${scheme_name}" \
            -configuration ${development_mode} \
            -archivePath "${xcarchive_path}" \
            -sdk iphoneos build DWARF_DSYM_FOLDER_PATH="${dSYMFolderPath}" DEBUG_INFORMATION_FORMAT='dwarf-with-dsym' \
            -quiet || exit
    else

        echo '-----------'
        echo ' 正在编译工程'
        echo '-----------'
        xcodebuild archive \
            -workspace "${xcworkspace_path}" \
            -scheme "${scheme_name}" \
            -configuration ${development_mode} \
            -archivePath "${xcarchive_path}" \
            -quiet || exit 0

        # 只有 xxx.xcodeproj 用这个
        # xcodebuild [-project <projectname>] \
        # -scheme <schemeName>
        # [-destination <destinationspecifier>]...
        # [-configuration <configurationname>]
        # [-arch <architecture>]...
        # [-sdk [<sdkname>|<sdkpath>]]
        # [-showBuildSettings [-json]]
        # [-showdestinations]
        # [<buildsetting>=<value>]...
        # [<buildaction>]...

        # 有 xx.xcworkspace 用这个
        # xcodebuild -workspace <workspacename> \
        # -scheme <schemeName>
        # [-destination <destinationspecifier>]...
        # [-configuration <configurationname>]
        # [-arch <architecture>]...
        # [-sdk [<sdkname>|<sdkpath>]]
        # [-showBuildSettings]
        # [-showdestinations]
        # [<buildsetting>=<value>]...
        # [<buildaction>]...

    fi

echo 'B125B79C-5DA1-47D3-AFA5-CE763F4173B8'

if [ -e "$xcarchive_path" ]; then

echo '--------'
echo ' 编译完成'
echo '--------'

else

echo '--------'
echo ' 编译失败 '
echo '--------'

exit

fi



    # 不能用return, 一般return是返回0, 1, 表示执行成功或失败
    #return $xcarchive_path;
    #这时候会返回执行的最后一个结果
    #这样能返回多个
    # echo ${xcarchive_path}
    # echo ${dSYMFolderPath}
}

# 把xcarchive转为ipa包
# $1 xcarchive文件路劲
# $2 scheme_name名称
# $3 编译的mode debug还是release
# $4 导出文件夹路径
# $5 exportOptionsPlistPath 配置文件的plist
# $6 .ipa 名称
function createIpa() {

    xcarchive_path=$1
    scheme_name=$2
    development_mode=$3
    exportIpaFolderPath=$4
    exportOptionsPlistPath=$5
    customArchiveName=$6

#判断是否存在.plist
if [ ! -f $exportOptionsPlistPath ]; then
#跳出函数
echo 'error: create ipa plist 地址错误: $exportOptionsPlistPath'
return 1
fi

xq_getPlistValue ${exportOptionsPlistPath} signingStyle
xq_allowProvisioningUpdates=$xq_value

    echo '----------'
    echo ' 开始ipa打包'
    echo '----------'

    echo "xcarchive_path: $1"
    echo "scheme_name: $2"
    echo "development_mode: $3"
    echo "exportIpaFolderPath: $4"
    echo "exportOptionsPlistPath: $5"
    echo "customArchiveName: $6"
    echo "allowProvisioningUpdates: $xq_allowProvisioningUpdates"

    #导出.ipa文件所在路径
    exportIpaPath="${exportIpaFolderPath}"

    echo '61486A3E-C857-4DCE-8AA2-681F6614A922'

    if [ $xq_allowProvisioningUpdates == automatic ]; then
        echo "automatic 签名打包"
        #把xcarchive编译成ipa
        xcodebuild \
        -exportArchive \
        -archivePath "${xcarchive_path}" \
        -configuration ${development_mode} \
        -exportPath "${exportIpaPath}" \
        -exportOptionsPlist "${exportOptionsPlistPath}" \
        -allowProvisioningUpdates true \
        -quiet || exit 0

        # -allowProvisioningUpdates 自动签名模式下, 这个设为 true

    else
        echo "manual 签名打包"
        #把xcarchive编译成ipa
        xcodebuild \
        -exportArchive \
        -archivePath "${xcarchive_path}" \
        -configuration ${development_mode} \
        -exportPath "${exportIpaPath}" \
        -exportOptionsPlist "${exportOptionsPlistPath}" \
        -quiet || exit 0

    fi

    echo '443C5591-8181-4117-B95A-8776A2BFE08C'


    #ipa包路径
    ipaPath="${exportIpaPath}/${customArchiveName}.ipa"
    #判断包是否存在, 不存在则表示打包失败
    if [ -e "$ipaPath" ]; then
        echo '----------'
        echo ' ipa包已导出'
        echo '----------'
    #打开文件夹
    #open $exportIpaPath
    else
        echo '-------------'
        echo " ipa包导出失败: ${ipaPath} "
        echo '-------------'
        #结束脚本
        exit
    fi
}

