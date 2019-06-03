#!/bin/bash

# 获取监本自身的文件夹路径
xq_DIR1="$(dirname $BASH_SOURCE)"
xq_MYDIR=$(readlink -f "$xq_DIR1")

# 获取执行环境的当前路径
# project_path=$(
#     cd $(dirname $0)
#     pwd
# )

basedir=$(
    cd $(dirname $0)
    pwd -P
)
echo "basedir: $basedir"

# 获取json配置数据

# 配置文件夹路径
# xqConfigFolderPath="/Users/wangxingqian/Desktop/Blog/XQScriptArchive1/Config"
# json 路径
# xqConfigJsonPath="$xqConfigFolderPath/xq_config.json"
xqConfigJsonPath="$1"

# 配置 plist 文件
xq_exportOptionsPlistPath=$2

#判断是否存在
if [ ! -f $xqConfigJsonPath ]; then
    #跳出函数
    echo "error: 配置文件不存在 $xqConfigJsonPath"
    exit
fi

xq_jq=/usr/local/bin/jq

#判断是否存在
if [ ! -f $xq_jq ]; then
    #跳出函数
    echo "error: jq 没有安装, 请执行: brew install jq "
    exit
fi

if [ ! -f ~/.bash_profile ]; then
    #跳出函数
    echo "error: 不存在 bash_profile"
else
    source ~/.profile
    source ~/.bash_profile
    source ~/.bashrc
    source ~/.mkshrc
fi

# 打印所有配置
echo "配置: $(${xq_jq} . ${xqConfigJsonPath})"

# 编译选项
buildMode=$($xq_jq .buildMode $xqConfigJsonPath)

# 上传选项
upAppStore=$($xq_jq .upAppStore $xqConfigJsonPath)

# 上传选项
upFir=$($xq_jq .upFir $xqConfigJsonPath)

# 上传选项
buglyUploadDSYM=$($xq_jq .buglyUploadDSYM $xqConfigJsonPath)

# 项目路径
xcodeprojPath=$($xq_jq .xcodeprojPath $xqConfigJsonPath)

# 项目路径
xcworkspace_path=$($xq_jq .xcworkspacePath $xqConfigJsonPath)

# scheme名, 一般和.xcworkspace一样, 如果不一样, 可以到项目里面查看
scheme_name=$($xq_jq .schemeName $xqConfigJsonPath)

# 项目的bundleid
xq_bundleID=$($xq_jq .bundleId $xqConfigJsonPath)

# 团队id, 生产证书最后的括号里面有
xq_teamID=$($xq_jq .teamId $xqConfigJsonPath)

#项目plist文件所在路径, 这个是拿来自增bundle version的
projectPlist_path=$($xq_jq .projectPlistPath $xqConfigJsonPath)

#存储.xcarchive文件夹路径
build_path=$($xq_jq .buildPath $xqConfigJsonPath)

#脚本和配置文件的文件夹名称
xq_shellPath=xq_shell

#编译模式 Debug/Release
archiveMode=$($xq_jq .archiveMode $xqConfigJsonPath)

# .xcarchive 文件
xcarchivePath=$($xq_jq .xcarchivePath $xqConfigJsonPath)

# .ipa 文件
ipaPath=$($xq_jq .ipaPath $xqConfigJsonPath)

# 是否生成 dsym
generateDSYM=$($xq_jq .generateDSYM $xqConfigJsonPath)

# dSYMFolderPath
dSYMFolderPath=$($xq_jq .dSYMFolderPath $xqConfigJsonPath)

buglyAppId=$($xq_jq .buglyAppId $xqConfigJsonPath)
buglyAppKey=$($xq_jq .buglyAppKey $xqConfigJsonPath)
symbolOutputPath=$($xq_jq .symbolOutputPath $xqConfigJsonPath)
buglyAppVersion=$($xq_jq .buglyAppVersion $xqConfigJsonPath)

# plist版本自增
plistAutoIncrement=$($xq_jq .plistAutoIncrement $xqConfigJsonPath)

# 正式 mobileprovision 的唯一标示
mobileprovisionUUID=$($xq_jq .mobileprovisionUUID $xqConfigJsonPath)

####### 上传App Store的修改
#开发账号
appleID=$($xq_jq .appleId $xqConfigJsonPath)
#密码, 如果开了双重验证, 那么就要APP-SPECIFIC PASSWORDS, 具体可百度, 申请专用密码: https://appleid.apple.com/account/manage
appleIDPwd=$($xq_jq .appleIdPwd $xqConfigJsonPath)

####### 上传Fir的修改
#上传fir的token
firToken=$($xq_jq .firToken $xqConfigJsonPath) #bc73c2a04554624e979e5c0b692bd710

# 判断是否为空
# $1 判断的字符串
# $2 打印的名称
function xq_isEmpty() {
    str=$1
    if [ $str == null ] || [ ${#str} == 2 ]; then
        echo "${2} 不能为空"
        exit 0
    fi
    return 0
}

xq_isEmpty $buildMode buildMode
xq_isEmpty $upMode upMode
xq_isEmpty $xcworkspace_path xcworkspace_path
xq_isEmpty $scheme_name scheme_name
xq_isEmpty $xq_bundleID xq_bundleID
xq_isEmpty $xq_teamID xq_teamID
xq_isEmpty $projectPlist_path projectPlist_path
xq_isEmpty $build_path build_path
xq_isEmpty $archiveMode archiveMode
xq_isEmpty $xq_exportOptionsPlistPath xq_exportOptionsPlistPath
xq_isEmpty $generateDSYM generateDSYM

# 把 " 去掉
xcworkspace_path=${xcworkspace_path//"\""/}
scheme_name=${scheme_name//"\""/}
xq_bundleID=${xq_bundleID//"\""/}
xq_teamID=${xq_teamID//"\""/}
projectPlist_path=${projectPlist_path//"\""/}
build_path=${build_path//"\""/}
archiveMode=${archiveMode//"\""/}
xq_exportOptionsPlistPath=${xq_exportOptionsPlistPath//"\""/}
buglyUploadDSYM=${buglyUploadDSYM//"\""/}
upFir=${upFir//"\""/}
upAppStore=${upAppStore//"\""/}
buildMode=${buildMode//"\""/}
dSYMFolderPath=${dSYMFolderPath//"\""/}
generateDSYM=${generateDSYM//"\""/}

# $1 要判断的字符串
function xq_assignment() {
    str=$1

    # 不能留 "" ,不然传值的时候...会把下一个值往上顶
    if [ ${#str} == 0 ] || [ ${#str} == 1 ] || [ ${#str} == 2 ]; then
        xq_result=null
    elif [ "$str" == null ]; then
        xq_result=null
    else
        xq_result=$str
    fi
}

xq_assignment $xcodeprojPath xcodeprojPath
xcodeprojPath=$xq_result

xq_assignment $appleID
appleID=$xq_result

xq_assignment $appleIDPwd
appleIDPwd=$xq_result

xq_assignment $firToken
firToken=$xq_result

xq_assignment $xcarchivePath
xcarchivePath=$xq_result

xq_assignment $ipaPath
ipaPath=$xq_result

xq_assignment $upFir
upFir=$xq_result

xq_assignment $buglyUploadDSYM
buglyUploadDSYM=$xq_result

xq_assignment $upFir
upFir=$xq_result

xq_assignment $upAppStore
upAppStore=$xq_result

xq_assignment $dSYMFolderPath
dSYMFolderPath=$xq_result

xq_assignment $buglyAppId
buglyAppId=$xq_result

xq_assignment $buglyAppKey
buglyAppKey=$xq_result

xq_assignment $symbolOutputPath
symbolOutputPath=$xq_result

xq_assignment $buglyAppVersion
buglyAppVersion=$xq_result

xq_assignment $plistAutoIncrement
plistAutoIncrement=$xq_result

xq_assignment $mobileprovisionUUID
mobileprovisionUUID=$xq_result


# ${var:-null} 如果是 var 是空值, 那么默认取得为 null, 不过这个解决不了 "" 问题, 所以还是按照现在的来吧

#echo "1: $xcodeprojPath"
#echo "2: $xcworkspace_path"
#echo "3: $scheme_name"
#echo "4: $xq_bundleID"
#echo "5: $xq_teamID"
#echo "6: $projectPlist_path"
#echo "7: $build_path"
#echo "8: $archiveMode"
#echo "9: $xq_exportOptionsPlistPath"
#echo "10: $appleID"
#echo "11: $appleIDPwd"
#echo "12: $firToken"
#echo "13: $buildMode"


source ${xq_DIR1}/xq_shell.sh \
    "${xcodeprojPath:-null}" \
    "${xcworkspace_path:-null}" \
    "${scheme_name:-null}" \
    ${xq_bundleID:-null} \
    ${xq_teamID:-null} \
    "${projectPlist_path:-null}" \
    "${build_path:-null}" \
    ${archiveMode:-null} \
    "${xq_exportOptionsPlistPath:-null}" \
    ${appleID:-null} \
    ${appleIDPwd:-null} \
    ${firToken:-null} \
    ${buildMode:-null} \
    ${upAppStore:-null} \
    ${upFir:-null} \
    "${xcarchivePath:-null}" \
    "${ipaPath:-null}" \
    ${buglyUploadDSYM:-null} \
    "${dSYMFolderPath:-null}" \
    ${buglyAppId:-null} \
    ${buglyAppKey:-null} \
    ${symbolOutputPath:-null} \
    ${buglyAppVersions:-null} \
    ${plistAutoIncrement:-null} \
    ${generateDSYM:-null}
