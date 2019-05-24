# 获取json配置数据

# 配置文件夹路径
xqConfigFolderPath="/Users/wangxingqian/Desktop/Blog/XQScriptArchive1/Config"

# json 路径
xqConfigJsonPath="$xqConfigFolderPath/xq_config.json"
# json 路径
xqAppConfigJsonPath="$xqConfigFolderPath/xq_appStoreConfig.json"
# json 路径
xqBuglyConfigJsonPath="$xqConfigFolderPath/xq_buglyConfig.json"
# json 路径
xqFirConfigJsonPath="$xqConfigFolderPath/xq_firConfig.json"

#上一级目录
#project_path=$(dirname $(pwd))
#当前文件夹路径, 项目路径
# project_path=$(
#     cd $(dirname $0)
#     pwd
# )

# 打印所有配置
echo "配置: $(jq . $xqConfigJsonPath)"
# 打印所有配置
echo "配置: $(jq . $xqAppConfigJsonPath)"
# 打印所有配置
echo "配置: $(jq . $xqBuglyConfigJsonPath)"
# 打印所有配置
echo "配置: $(jq . $xqFirConfigJsonPath)"


# 编译选项
buildMode=$(jq .buildMode $xqConfigJsonPath)

# 上传选项
upAppStore=$(jq .upAppStore $xqConfigJsonPath)

# 上传选项
upFir=$(jq .upFir $xqConfigJsonPath)

# 项目路径
xcodeprojPath=$(jq .xcodeprojPath $xqConfigJsonPath)

# 项目路径
xcworkspace_path=$(jq .xcworkspacePath $xqConfigJsonPath)

# scheme名, 一般和.xcworkspace一样, 如果不一样, 可以到项目里面查看
scheme_name=$(jq .schemeName $xqConfigJsonPath)

# 项目的bundleid
xq_bundleID=$(jq .bundleId $xqConfigJsonPath)

# 团队id, 生产证书最后的括号里面有
xq_teamID=$(jq .teamId $xqConfigJsonPath)

# 生产证书的名字, 因为有空格, 所以要用引号括起来
xq_signingCertificate=$(jq .signingCertificate $xqConfigJsonPath)

#项目plist文件所在路径, 这个是拿来自增bundle version的
projectPlist_path=$(jq .projectPlistPath $xqConfigJsonPath)

#存储.xcarchive文件夹路径
build_path=$(jq .buildPath $xqConfigJsonPath)

#脚本和配置文件的文件夹名称
xq_shellPath=xq_shell

#plist文件所在路径
xq_devExportOptionsPlistPath=$(jq .devExportOptionsPlistPath $xqConfigJsonPath)
xq_disExportOptionsPlistPath=$(jq .disExportOptionsPlistPath $xqConfigJsonPath)
xq_exportOptionsPlistPath=${xq_devExportOptionsPlistPath}

#编译模式 Debug/Release
archiveMode=$(jq .archiveMode $xqConfigJsonPath)

# .xcarchive 文件
xcarchivePath=$(jq .xcarchivePath $xqConfigJsonPath)

# .ipa 文件
ipaPath=$(jq .ipaPath $xqConfigJsonPath)

####### 上传App Store的修改
#开发账号
appleID=$(jq .appleId $xqAppConfigJsonPath)
#密码, 如果开了双重验证, 那么就要APP-SPECIFIC PASSWORDS, 具体可百度, 申请专用密码: https://appleid.apple.com/account/manage
appleIDPwd=$(jq .appleIdPwd $xqAppConfigJsonPath) 

####### 上传Fir的修改
#上传fir的token
firToken=$(jq .firToken $xqConfigJsonPath) #bc73c2a04554624e979e5c0b692bd710

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
xq_isEmpty $xq_signingCertificate xq_signingCertificate
xq_isEmpty $projectPlist_path projectPlist_path
xq_isEmpty $build_path build_path
xq_isEmpty $archiveMode archiveMode
xq_isEmpty $xq_devExportOptionsPlistPath xq_devExportOptionsPlistPath
xq_isEmpty $xq_disExportOptionsPlistPath xq_disExportOptionsPlistPath

# 把 " 去掉
xcworkspace_path=${xcworkspace_path//"\""/}
scheme_name=${scheme_name//"\""/}
xq_bundleID=${xq_bundleID//"\""/}
xq_teamID=${xq_teamID//"\""/}
xq_signingCertificate=${xq_signingCertificate//"\""/}
projectPlist_path=${projectPlist_path//"\""/}
build_path=${build_path//"\""/}
archiveMode=${archiveMode//"\""/}
xq_devExportOptionsPlistPath=${xq_devExportOptionsPlistPath//"\""/}
xq_disExportOptionsPlistPath=${xq_disExportOptionsPlistPath//"\""/}


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

# ${var:-null} 如果是 var 是空值, 那么默认取得为 null, 不过这个解决不了 "" 问题, 所以还是按照现在的来吧

source ./xq_shell.sh \
    ${xcodeprojPath} \
    ${xcworkspace_path} \
    ${scheme_name} \
    ${xq_bundleID} \
    ${xq_teamID} \
    "${xq_signingCertificate}" \
    ${projectPlist_path} \
    ${build_path} \
    ${archiveMode} \
    ${xq_devExportOptionsPlistPath} \
    ${xq_disExportOptionsPlistPath} \
    ${appleID} \
    ${appleIDPwd} \
    ${firToken} \
    ${buildMode} \
    ${upAppStore} \
    ${upFir} \
    ${xcarchivePath} \
    ${ipaPath}



