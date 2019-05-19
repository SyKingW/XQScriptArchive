#使用方法
#层级关系: 把xq_shell文件夹, shell.sh, 放到和xxx.xcworkspace目录下, 当然, 你也可以自定义路径, 修改xcworkspace_path
#脚本执行: cd到脚本目录, 输入 ./xq_shell.sh , 根据提示选择打包开发包, 还是生产包, 还有是否上传到网上

#提示:
#在项目同级目录下生成的build文件夹是没用的, 这个只是系统自动生成
#证书名称这些, 在<钥匙串访问>应用里面查看
#执行的时候显示Permission denied, 输入:chmod +x 脚本文件名 ,

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
ipaDir_path=${saveDirectionPath}/ipaDir

#plist文件所在路径
xq_devExportOptionsPlistPath=${10}
xq_disExportOptionsPlistPath=${11}
xq_exportOptionsPlistPath=${xq_devExportOptionsPlistPath}

####### 上传App Store的修改
#开发账号
appleID=${12}
#密码, 如果开了双重验证, 那么就要APP-SPECIFIC PASSWORDS, 具体可百度, 申请专用密码: https://appleid.apple.com/account/manage
appleIDPwd=${13}

####### 上传Fir的修改
#上传fir的token
firToken=${14}

#脚本和配置文件的文件夹名称
xq_shellPath=xq_shell

#判断文件夹是否已创建, -d文件夹, -f文件
if [ ! -d .${build_path} ]; then
    mkdir -p $build_path
fi
if [ ! -d .${ipaDir_path} ]; then
    mkdir -p ${ipaDir_path}
fi

#导入xcode相关编译打包脚本
source ./${xq_shellPath}/xq_xcode.sh
#plist操作脚本
source ./${xq_shellPath}/xq_plist.sh
#上传脚本
source ./${xq_shellPath}/xq_upload.sh

#配置plist, 这里有个坑, 如果不这样传参数...是传过去, 是不完整的, 因为值有空格...
configExport "${xq_signingCertificate}" "${xq_teamID}" "${xq_bundleID}" "${xq_disExportOptionsPlistPath}" "${xq_devExportOptionsPlistPath}"

# 其实这里不应该是 App Store和 Developer 的, 应该打包是打包, 上传到哪就哪
number=1
if [ archiveMode="Debug" ]; then
    number=1
elif [ archiveMode="Release" ]; then
    number=2
else
    echo "请选择 archiveMode"
    exit 0
fi

#根据打包的类型, 获取配置文件路径
if [ $number == 2 ]; then
    archiveMode=Release
    xq_exportOptionsPlistPath=${xq_disExportOptionsPlistPath}
else
    archiveMode=Debug
    xq_exportOptionsPlistPath=${xq_devExportOptionsPlistPath}
fi

#具体执行步骤
echo "请选择打包步骤"
echo "1:需要编译"
echo "2:无需编译, 已有xcarchive文件, 直接导出ipa包"
echo "3:已有ipa包, 上传到fir"
echo "4:已有ipa包, 上传到app store"
echo "5:上传dSYM"
read stepNumber
while ([[ $stepNumber != 1 ]] && [[ $stepNumber != 2 ]] && [[ $stepNumber != 3 ]] && [[ $stepNumber != 4 ]] && [[ $stepNumber != 5 ]]); do
    echo "Error! Should enter 1 or 2"
    echo "请选择打包步骤"
    echo "1:需要编译"
    echo "2:无需编译, 已有.xcarchive文件"
    echo "3:已有ipa包, 上传到fir"
    echo "4:已有ipa包, 上传到app store"
    echo "5:上传dSYM"
    read stepNumber
done

#--------已有xcarchive-------
if [ $stepNumber == 2 ]; then

    echo "上传到哪里 ? [ 1:fir 2:不上传 3:AppStore] "
    read isUpload
    while ([[ $isUpload != 1 ]] && [[ $isUpload != 2 ]] && [[ $isUpload != 3 ]]); do
        echo "上传到哪里 ? [ 1:fir 2:不上传 3:AppStore] "
        read isUpload
    done

    echo "请输入xcarchive文件路径"
    read xcarchive_path
    createIpa ${xcarchive_path} ${scheme_name} ${archiveMode} ${ipaDir_path} ${xq_exportOptionsPlistPath} ${xcworkspace_path}

    xq_uploadIpa $isUpload $ipaPath $firToken $appleID $appleIDPwd
    exit 0

fi

#--------已有ipa包,上传到fir-------
if [ $stepNumber == 3 ]; then
    echo "请输入ipa包路径"
    read ipaPath
    xqUploadFir ${firToken} ${ipaPath}
    exit 0
fi

#--------已有ipa包,上传到appstore-------
if [ $stepNumber == 4 ]; then
    echo "请输入ipa包路径"
    read ipaPath
    xqUploadAppStore ${appleID} ${appleIDPwd} ${ipaPath}
    exit 0
fi

#--------上传dSYM-------

# 上传 dSYM 到 bugly
# $1 dSYM 文件夹
# $2 plist 文件路径
function uploadDSYM() {
    # 获取 plist 版本
    xq_getPlistVersion $2

    # ${PRODUCT_BUNDLE_IDENTIFIER} 是获取BundleID #
    # xq_PRODUCT_BUNDLE_IDENTIFIER=${PRODUCT_BUNDLE_IDENTIFIER}
    xq_PRODUCT_BUNDLE_IDENTIFIER=""

    if [ "${xq_PRODUCT_BUNDLE_IDENTIFIER}" == "" ]; then
        
    elif [ "${xq_PRODUCT_BUNDLE_IDENTIFIER}" == "" ]; then

        
    elif [ "${xq_PRODUCT_BUNDLE_IDENTIFIER}" == "" ]; then
        xq_BUGLY_APP_ID=""
        xq_BUGLY_APP_KEY=""
    fi

    xq_BUGLY_APP_VERSION=${xq_automaticAddBundle}
    xq_DWARF_DSYM_FOLDER_PATH=$1

    xqDate=$(date +%Y.%m.%d-%H.%M.%S)
    xq_SYMBOL_OUTPUT_PATH=${xq_DWARF_DSYM_FOLDER_PATH}/${xqDate}-SYMBOL_OUTPUT_PATH

    # BUGLY_APP_ID="$1"
    #     BUGLY_APP_KEY="$2"
    #     BUNDLE_IDENTIFIER="$3"
    #     BUGLY_APP_VERSION="$4"
    #     DWARF_DSYM_FOLDER_PATH="$5"
    #     SYMBOL_OUTPUT_PATH="$6"
    #     UPLOAD_DSYM_ONLY=$7
    # bugly 脚本
    source ./${xq_shellPath}/xq_bugly.sh ${xq_BUGLY_APP_ID} ${xq_BUGLY_APP_KEY} ${xq_PRODUCT_BUNDLE_IDENTIFIER} ${xq_BUGLY_APP_VERSION} ${xq_DWARF_DSYM_FOLDER_PATH} ${xq_SYMBOL_OUTPUT_PATH} 1
}

if [ $stepNumber == 5 ]; then
    echo "请输入dSYM文件夹路径"
    read dSYMPath
    uploadDSYM ${dSYMPath} ${projectPlist_path}
    exit 0
fi

#--------需要编译-------
#询问是否上传网上, 还是打ipa包就可以
echo "上传到哪里 ? [ 1:fir 2:不上传 3:AppStore] "
read isUpload
while ([[ $isUpload != 1 ]] && [[ $isUpload != 2 ]] && [[ $isUpload != 3 ]]); do
    echo "上传到哪里 ? [ 1:fir 2:不上传 3:AppStore] "
    read isUpload
done

isGenerateDSYM=0
if [ $number == 2 ]; then
    # 如果是app store, 默认生成 dSYM
    isGenerateDSYM=1
else
    # 询问是否要生成 dSYM
    echo "是否生成 dSYM, 生成dSYM会编译较慢 ? [ 1: 生成, 0: 不生成 ]"
    read isGenerateDSYM
    while ([[ $isGenerateDSYM != 1 ]] && [[ $isGenerateDSYM != 0 ]]); do
        echo "是否生成 dSYM ? [ 1: 生成, 0: 不生成 ]"
        read isGenerateDSYM
    done
fi

isUploadBugly=0
if [ $isGenerateDSYM == 1 ]; then
    isGenerateDSYM=true

    echo "是否要上传 dSYM 到 Bugly ? [ 1: 上传, 0: 不上传 ]"
    read isUploadBugly
    while ([[ $isUploadBugly != 1 ]] && [[ $isUploadBugly != 0 ]]); do
        echo "是否要上传 dSYM 到 Bugly ? [ 1: 上传, 0: 不上传 ]"
        read isUploadBugly
    done

else
    isGenerateDSYM=false
fi

#调用自增Bundle函数
automaticAddBundle ${projectPlist_path}

#调用编译函数
#调用这个之后, 因为那边返回出 xcarchive_path 这个值, 所以这边不用声明, 直接使用这个就好
createXcarchiveFile ${archiveMode} ${xcworkspace_path} ${scheme_name} ${build_path} ${projectPlist_path} ${isGenerateDSYM} ${saveDirectionPath}

#把xcarchive, 打成ipa包, 并返回 ipaPath
createIpa ${xcarchive_path} ${scheme_name} ${archiveMode} ${ipaDir_path} ${xq_exportOptionsPlistPath} ${xcworkspace_path}

#上传ipa
xq_uploadIpa $isUpload $ipaPath $firToken $appleID $appleIDPwd

if [ $isUploadBugly == 1 ]; then
    uploadDSYM ${dSYMPath} ${projectPlist_path}
fi

#结束脚本
exit 0
