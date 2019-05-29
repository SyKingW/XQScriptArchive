#这个是上传到appstore, 或者其他第三方的脚本

#$1 appleID: 开发者账号
#$2 appleID pwd: 密码
#$3 ipaPath: ipa包路径
function xqUploadAppStore() {

    echo '-------------'
    echo ' 开始上传AppStore '
    echo ' 账号:${1} '
    echo ' 路径:${3} '
    echo '-------------'

    if [ ! -f ${3} ]; then
        echo "error: 上传 App Store, ipa文件不存在"
        return 0
    fi

    #验证并上传到App Store
    #appleID: 开发账号, appleIDPwd: 密码
    appleID=$1
    appleIDPwd=$2
    ipaPath=$3
    #不知道为什么...怎么弄, 他都显示路径错误, 所以, 下面就直接用路径了
    altoolPath="/Applications/Xcode.app/Contents/Applications/Application\ Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool"
    #echo "account: " ${appleID}
    echo "验证需要密码, 再次输入密码验证: " ${appleIDPwd}

    #注意：使用AppleID密码上传时若遇到以下报错 “Please sign in with an app-specific password. You can create one at appleid.apple.com” 则说明你的 Apple ID 采用了双重认证密码，上架 iOS App 需要去建立一个专用密码来登入 Apple ID 才能上架。, 申请专用密码: https://appleid.apple.com/account/manage, 具体可以百度 APP-SPECIFIC PASSWORDS
    echo '-------------'
    echo ' 开始验证 '
    echo '-------------'
    #验证APP
    /Applications/Xcode.app/Contents/Applications/Application\ Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool --validate-app -f ${ipaPath} -u ${appleID} [-p ${appleIDPwd}] [--output-format xml]
    echo '-------------'
    echo ' 验证结束, 开始上传 '
    echo '-------------'
    #上传APP
    /Applications/Xcode.app/Contents/Applications/Application\ Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool --upload-app -f ${ipaPath} -u ${appleID} -p ${appleIDPwd} [--output-format xml]
    echo '-------------'
    echo ' 上传AppStore结束 '
    echo '-------------'

    return 1
}

#$1 fir token: 平台的token
#$2 ipaPath: ipa包路径
function xqUploadFir() {

    if [ ! -f ${2} ]; then
        echo "error: 上传 Fir, ipa文件不存在"
        return 0
    fi

    echo '-------------'
    echo ' 上传第fir平台 '
    echo '-------------'

    #上传到Fir
    # 将XXX替换成自己的Fir平台的token
    firToken=$1
    ipaPath=$2
    #登陆
    fir login -T $firToken
    #上传
    fir publish $ipaPath

    echo '-------------'
    echo ' 上传fir结束 '
    echo '-------------'

    return 1
}

#上传数据
#$1 upload type: 上传类型 1fir 3app store 其他不上传
#$2 ipaPath: 文件路径
#$3 firToken
#$4 appleID
#$5 appleIDPwd
function xq_uploadIpa() {
    xq_uploadType=$1
    xq_ipaPath=$2
    xq_firToken=$3
    xq_appleID=$4
    xq_applePwd=$5

    #上传fir
    if [ $xq_uploadType == 1 ]; then
        xqUploadFir ${xq_firToken} ${xq_ipaPath}

    #上传到App Store
    elif [ $xq_uploadType == 3 ]; then
        xqUploadAppStore ${xq_appleID} ${xq_applePwd} ${xq_ipaPath}

    fi

    #不上传

}

#--------上传dSYM-------

# 上传 dSYM 到 bugly
# $1 dSYM 文件夹
# $2 上传版本
# $3 bugly app id
# $4 bugly app key
# $5 app bundle id
function uploadDSYM() {
    # # 获取 plist 版本
    # source ./xq_plist.sh
    # xq_getPlistVersion $2

    if [ ! -d .${1} ]; then
        echo "error: dsym文件夹不存在"
        return 0
    fi

    xq_BUGLY_APP_VERSION=${2}
    xq_BUGLY_APP_ID=${3}
    xq_BUGLY_APP_KEY=${4}
    xq_PRODUCT_BUNDLE_IDENTIFIER=${5}

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
    source ./xq_bugly.sh ${xq_BUGLY_APP_ID} ${xq_BUGLY_APP_KEY} ${xq_PRODUCT_BUNDLE_IDENTIFIER} ${xq_BUGLY_APP_VERSION} ${xq_DWARF_DSYM_FOLDER_PATH} ${xq_SYMBOL_OUTPUT_PATH} 1
    
    return 1
}
