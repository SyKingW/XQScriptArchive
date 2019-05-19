#这个是上传到appstore, 或者其他第三方的脚本

#$1 appleID: 开发者账号
#$2 appleID pwd: 密码
#$3 ipaPath: ipa包路径
function xqUploadAppStore() {

    echo '-------------'
    echo ' 开始上传AppStore '
    echo '-------------'

    #验证并上传到App Store
    #appleID: 开发账号, appleIDPwd: 密码
    appleID=$1
    appleIDPwd=$2
    ipaPath=$3
    #不知道为什么...怎么弄, 他都显示路径错误, 所以, 下面就直接用路径了
    altoolPath="/Applications/Xcode.app/Contents/Applications/Application\ Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool"
    #echo "account: " ${appleID}
    echo "验证需要密码, 复制这个密码输入验证: " ${appleIDPwd}

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

}

#$1 fir token: 平台的token
#$2 ipaPath: ipa包路径
function xqUploadFir() {

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
