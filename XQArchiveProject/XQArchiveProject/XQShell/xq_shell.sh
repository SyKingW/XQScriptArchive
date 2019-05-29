#提示:
#在项目同级目录下生成的build文件夹是没用的, 这个只是系统自动生成
#证书名称这些, 在<钥匙串访问>应用里面查看
#执行的时候显示Permission denied, 输入:chmod +x 脚本文件名 ,

# 获取监本自身的文件夹路径
xq_DIR1="`dirname $BASH_SOURCE`"
xq_MYDIR=`readlink -f "$xq_DIR1"`
echo "DIR1: $xq_DIR1"


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

# 生产证书的名字, 因为有空格, 所以要用引号括起来
xq_signingCertificate=$6

#项目plist文件所在路径, 这个是拿来自增bundle version的
projectPlist_path=$7

#编译模式 Debug/Release
archiveMode=$9

#存储.xcarchive文件夹路径
build_path="$8/build"

# 保存路径
xqDate=$(date +%Y.%m.%d-%H.%M.%S)
fileName=${scheme_name}-${xqDate}
saveDirectionPath=${build_path}/${archiveMode}/${fileName}

#存储.ipa文件夹路径
ipaDir_path=${saveDirectionPath}/ipa

#plist文件所在路径
xq_exportOptionsPlistPath=${10}

####### 上传App Store的修改
#开发账号
appleID=${11}
#密码, 如果开了双重验证, 那么就要APP-SPECIFIC PASSWORDS, 具体可百度, 申请专用密码: https://appleid.apple.com/account/manage
appleIDPwd=${12}

####### 上传Fir的修改
#上传fir的token
firToken=${13}

# 构建 model
# 0: 什么都不做
# 1: 构建
# 2: 打包ipa
buildMode=${14}

# 上传 model
# 0: 不上传
# 1: 上传App Store
upAppStore=${15}

# 上传 model
# 0: 不上传
# 1: 上传Fir
upFir=${16}

# xcarchive_path
xcarchive_path=${17}

# ipaPath
ipaPath=${18}

# 上传 dsym model
# 0: 什么都不做
# 1: 上传dsym到bugly
buglyUploadDSYM=${19}

dSYMFolderPath=${20}
buglyAppId=${21}
buglyAppKey=${22}
symbolOutputPath=${23}
buglyAppVersions=${24}

# plist 版本自增
# 0: 不自增
# 1: 自增
plistAutoIncrement=${25}

# 是否生成dsym
# 0: 不生成
# 1: 生成
generateDSYM=${26}



# 如果传入值不为0, 那么就退出脚本
# $1 如果不为0, 那么退出脚本
function xq_funcIsExit() {
    if [ $1 != 0 ]; then
        exit 0
    fi
}

#判断文件夹是否已创建, -d文件夹, -f文件
if [ ! -d .${build_path} ]; then
    mkdir -p ${build_path}
fi
if [ ! -d .${ipaDir_path} ]; then
    mkdir -p ${ipaDir_path}
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

echo "buildModel: ${buildMode}"

if [ ${buildMode} == 1 ]; then
    echo "构建项目"

    if [ $plistAutoIncrement == 1 ]; then
        #调用自增Bundle函数
        automaticAddBundle ${projectPlist_path}
    fi
    echo "saveDirectionPath: $saveDirectionPath"
    #调用这个之后, 因为那边返回出 xcarchive_path 这个值, 所以这边不用声明, 直接使用这个就好
    createXcarchiveFile ${archiveMode} ${xcworkspace_path} ${scheme_name} ${build_path} ${projectPlist_path} ${generateDSYM} ${saveDirectionPath}

    #把xcarchive, 打成ipa包, 并返回 ipaPath
    createIpa ${xcarchive_path} ${scheme_name} ${archiveMode} ${ipaDir_path} ${xq_exportOptionsPlistPath}

elif [ ${buildMode} == 2 ]; then

    echo "构建ipa"

    #把xcarchive, 打成ipa包, 并返回 ipaPath
    createIpa ${xcarchive_path} ${scheme_name} ${archiveMode} ${ipaDir_path} ${xq_exportOptionsPlistPath}

else
    echo "不构建"
fi

#--------上传到App Store-------
if [ $upAppStore == 1 ]; then
    xqUploadAppStore ${appleID} ${appleIDPwd} ${ipaPath}
fi

#--------上传到fir-------
if [ $upFir == 1 ]; then
    xqUploadFir ${firToken} ${ipaPath}
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

    uploadDSYM ${dSYMFolderPath} ${xq_automaticAddBundle} ${buglyAppId} ${buglyAppKey} ${buglyAppVersions}
fi

#结束脚本
echo "结束脚本构建"
