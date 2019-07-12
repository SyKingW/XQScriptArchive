#提示:
#在项目同级目录下生成的build文件夹是没用的, 这个只是系统自动生成
#证书名称这些, 在<钥匙串访问>应用里面查看
#执行的时候显示Permission denied, 输入:chmod +x 脚本文件名 ,

# 获取监本自身的文件夹路径
xq_DIR1="`dirname $BASH_SOURCE`"
xq_MYDIR=`readlink -f "$xq_DIR1"`
echo "DIR1: $xq_DIR1"

# echo "1: $1"
# echo "2: $2"
# echo "3: $3"
# echo "4: $4"
# echo "5: $5"
# echo "6: $6"
# echo "7: $7"
# echo "8: $8"
# echo "9: $9"
# echo "10: ${10}"
# echo "11: ${11}"
# echo "12: ${12}"
# echo "13: ${13}"


# 项目路径
xcodeprojPath=$1

# 项目路径
xcworkspace_path=$2

# scheme名, 一般和.xcworkspace一样, 如果不一样, 可以到项目里面查看
scheme_name=$3

# 项目的bundleid
xq_bundleID=$4

# 团队id, 生产证书最后的括号里面有
xq_teamID=$5

#项目plist文件所在路径, 这个是拿来自增bundle version的
projectPlist_path=$6

#编译模式 Debug/Release
archiveMode=$8

#存储.xcarchive文件夹路径
build_path="$7/build"

# 保存路径
xqDate=$(date +%Y.%m.%d-%H.%M.%S)
fileName="${scheme_name}-${xqDate}"
saveDirectionPath="${build_path}/${archiveMode}/${fileName}"

#存储.ipa文件夹路径
ipaDir_path=${saveDirectionPath}/ipa

#plist文件所在路径
xq_exportOptionsPlistPath=${9}

####### 上传App Store的修改
#开发账号
appleID=${10}
#密码, 如果开了双重验证, 那么就要APP-SPECIFIC PASSWORDS, 具体可百度, 申请专用密码: https://appleid.apple.com/account/manage
appleIDPwd=${11}

####### 上传Fir的修改
#上传fir的token
firToken=${12}

# 构建 model
# 0: 什么都不做
# 1: 构建
# 2: 打包ipa
buildMode=${13}


# 上传 model
# 0: 不上传
# 1: 上传App Store
upAppStore=${14}

# 上传 model
# 0: 不上传
# 1: 上传Fir
upFir=${15}

# xcarchive_path
xcarchive_path=${16}

# ipaPath
ipaPath=${17}

# 上传 dsym model
# 0: 什么都不做
# 1: 上传dsym到bugly
buglyUploadDSYM=${18}

dSYMFolderPath=${19}
buglyAppId=${20}
buglyAppKey=${21}
symbolOutputPath=${22}
buglyAppVersions=${23}

# plist 版本自增
# 0: 不自增
# 1: 自增
plistAutoIncrement=${24}

# 是否生成dsym
# 0: 不生成
# 1: 生成
generateDSYM=${25}

# 自定义 .ipa 名称
customArchiveName=${26}



# 如果传入值不为0, 那么就退出脚本
# $1 如果不为0, 那么退出脚本
function xq_funcIsExit() {
    if [ $1 != 0 ]; then
        exit 0
    fi
}

#判断文件夹是否已创建, -d文件夹, -f文件
if [ ! -d ".${build_path}" ]; then
    mkdir -p "${build_path}"
fi

if [ ! -d ".${saveDirectionPath}" ]; then
    mkdir -p "${saveDirectionPath}"
fi

if [ ! -d ".${ipaDir_path}" ]; then
    mkdir -p "${ipaDir_path}"
fi

#导入xcode相关编译打包脚本
source $xq_DIR1/xq_xcode.sh
xq_funcIsExit $?

#plist操作脚本
source $xq_DIR1/xq_plist.sh
xq_funcIsExit $?

#上传脚本
source $xq_DIR1/xq_upload.sh
xq_funcIsExit $?

echo "buildMode: ${buildMode}"

if [ ${buildMode} == 1 ]; then
    echo "构建项目"

    if [ $plistAutoIncrement == 1 ]; then
        #调用自增Bundle函数
        automaticAddBundle ${projectPlist_path}
    fi

    echo "saveDirectionPath: $saveDirectionPath"
    #调用这个之后, 因为那边返回出 xcarchive_path 这个值, 所以这边不用声明, 直接使用这个就好
    createXcarchiveFile ${archiveMode} "${xcworkspace_path}" "${scheme_name}" "${build_path}" "${projectPlist_path}" ${generateDSYM} "${saveDirectionPath}"

    #把xcarchive, 打成ipa包, 并返回 ipaPath
    createIpa "${xcarchive_path}" "${scheme_name}" ${archiveMode} "${ipaDir_path}" "${xq_exportOptionsPlistPath}" "${customArchiveName}"

elif [ ${buildMode} == 2 ]; then

    echo "构建ipa"

    #把xcarchive, 打成ipa包, 并返回 ipaPath
    createIpa "${xcarchive_path}" "${scheme_name}" ${archiveMode} "${ipaDir_path}" "${xq_exportOptionsPlistPath}" "${customArchiveName}"

else
    echo "不构建"
fi

#--------上传到App Store-------
if [ $upAppStore == 1 ]; then
    xqUploadAppStore ${appleID} ${appleIDPwd} "${ipaPath}"
fi

#--------上传到fir-------
if [ $upFir == 1 ]; then
    xqUploadFir ${firToken} "${ipaPath}"
fi

#--------上传dsym到bugly-------
if [ $buglyUploadDSYM == 1 ]; then

    buglyAppVersionsLength=${#buglyAppVersions}

    if [ buglyAppVersionsLength == 0 || buglyAppVersions == null ]; then
        xq_getPlistVersion $2
        buglyAppVersions=$xq_automaticAddBundle
    fi

    if [ buglyAppVersionsLength == 0 || buglyAppVersions == null ]; then
        echo "error: bugly version null"
        return 0
    fi
    echo 'D9027F18-1086-4C1A-9A62-256CD64CF8AC'
    uploadDSYM "${dSYMFolderPath}" ${xq_automaticAddBundle} ${buglyAppId} ${buglyAppKey} ${buglyAppVersions}
    echo '1A096E70-E133-4725-ADB7-020760A8D0BF'
fi

#结束脚本
echo "结束脚本构建"
