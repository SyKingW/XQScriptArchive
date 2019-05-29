#自增版本
#自增Bundle, 需要传入.plist的path, 这样调用: automaticAddBundle 地址
#地址获取: path=$(cd `dirname $0`; pwd)/MQTTProject/Other/Info.plist
#$1 .plist路径
function automaticAddBundle() {
    #获取.plist文件路径
    a_plist_path=$1

    #判断是否存在.plist
    if [ ! -f $a_plist_path ]; then
        #跳出函数
        echo 'error: automaticAddBundle plist地址错误: $a_plist_path'
        return 1
    fi

    #PlistBuddy命令
    #这些字段到项目里面, 用 Source code模式打开, 可以看到
    #V CFBundleShortVersionString 上架主要版本
    #B CFBundleVersion 内部区分版本
    #读取版本
    Version=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" ${a_plist_path})
    Bundle=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" ${a_plist_path})

    #用expr表达计算式, 内部版本+1, 这个不能加小数点
    #Bundle=`expr $Bundle + 1`
    Bundle=$(echo "$Bundle+0.1" | bc)
    echo '自增后版本': $Bundle

    #写入.plist
    /usr/libexec/PlistBuddy -c "Set CFBundleVersion $Bundle" $a_plist_path
    echo '自增版本完毕'

    xq_automaticAddBundle="${Version}(${Bundle})"
    echo ${xq_automaticAddBundle}
}

function xq_getPlistVersion() {
    #获取.plist文件路径
    a_plist_path=$1
    #判断是否存在.plist
    if [ ! -f $a_plist_path ]; then
        #跳出函数
        echo 'error: xq_getPlistVersion plist地址错误: $a_plist_path'
        return 1
    fi
    Version=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" ${a_plist_path})
    Bundle=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" ${a_plist_path})
    xq_automaticAddBundle="${Version}(${Bundle})"
    echo ${xq_automaticAddBundle}
}


# 获取plist某个字段值
# $1 plist path
# $2 key (后面考虑可以连续 点语法获取值?, 还有获取数组某个值)
function xq_getPlistValue() {
xq_value=$(/usr/libexec/PlistBuddy -c "Print ${2}" $1)
}

# 设置plist值
# $1 plist path
# $2 key
# $3 value
function xq_setPlistValue() {
/usr/libexec/PlistBuddy -c "Set $2 $3" $1
}

#更新配置.plist
#$1 signingCertificate: 证书名称
#$2 team id: 团队id
#$3 bundle id: 项目的包名
#$4 disPlistPath: 生产plist路径
#$5 devPlistPath: 开发plist路径
#$6 生产 mobileprovision 的 UUID
#$7 签名模式
function configExport() {

    xq_signingCertificate=$1
    xq_teamID=$2
    xq_bundleID=$3
    xq_disPlistPath=$4
    xq_devPlistPath=$5

    #配置plist, 这里有个坑, 如果不这样传参数...是传过去, 是不完整的
    configPlist "$1" "$2" "$3" "$4" "$6" "$7"
    configPlist "$1" "$2" "$3" "$5" "$6" "$7"

    #生产得多配置一个属性
    /usr/libexec/PlistBuddy -c 'Add :provisioningProfiles:aps-environment string app-store' $4

}

#配置plist
#$1 signingCertificate: 证书名称
#$2 team id: 团队id
#$3 bundle id: 项目的包名
#$4 plistPath: plist路径
#$5 生产 mobileprovision 的 UUID
#$6 签名模式
function configPlist() {

    xq_signingCertificate=$1
    xq_teamID=$2
    xq_bundleID=$3
    xq_plistPath=$4
    xq_mobileprovision_uuid=$5
    codeSignStyle=$6

    #判断是否存在.plist
    if [ ! -f ${xq_plistPath} ]; then
        echo 'error: configExport plist地址错误: ' ${xq_plistPath}
        return 1
    fi

    #写入证书名称
    /usr/libexec/PlistBuddy -c "Set signingCertificate $xq_signingCertificate" $xq_plistPath
    #写入teamid
    /usr/libexec/PlistBuddy -c "Set teamID $xq_teamID" $xq_plistPath

    # /usr/libexec/PlistBuddy -c "Set uploadSymbols true" $xq_plistPath

    #移除provisioningProfiles
    /usr/libexec/PlistBuddy -c 'Delete :provisioningProfiles' $xq_plistPath

    #重新在添加provisioningProfiles, 并赋值
    /usr/libexec/PlistBuddy -c 'Add :provisioningProfiles dict' $xq_plistPath
    #因为证书名称有空格, 所以, 暂时创建key, 然后再次改变值就行
    /usr/libexec/PlistBuddy -c "Add :provisioningProfiles:${xq_bundleID} string asdasd" $xq_plistPath
    # /usr/libexec/PlistBuddy -c "Set :provisioningProfiles:$xq_bundleID $xq_signingCertificate" $xq_plistPath
    /usr/libexec/PlistBuddy -c "Set :provisioningProfiles:${xq_bundleID} ${xq_mobileprovision_uuid}" $xq_plistPath

    #Automatic: 自动签名
    #Manual: 手动签名
    /usr/libexec/PlistBuddy -c "Set signingStyle $codeSignStyle" $xq_plistPath

}

# function xq_pbxproj() {
# .pbxproj 其实一样是 xml 文件, 也可以用 plistbuddy 命令去修改
# }

function xq_mobileprovision() {
    # 先用 security cms -D -i 获取到里面的信息 (是 xml )
    # 再用 PlistBuddy 获取xml 里面信息

    # mobileprovision 路径
    # mobileprovision_file=xxxx.mobileprovision
    mobileprovision_file=$1

    # 可以利用这个 + teamid, 组成证书名称
    mobileprovision_teamname=$(/usr/libexec/PlistBuddy -c "Print TeamName" /dev/stdin <<<$(security cms -D -i $mobileprovision_file))
    echo $mobileprovision_teamname

    CODE_SIGN_IDENTITY="iPhone Distribution: $mobileprovision_teamname"
    echo "$CODE_SIGN_IDENTITY"

    PROVISIONING_PROFILE_SPECIFIER=$(/usr/libexec/PlistBuddy -c "Print AppIDName" /dev/stdin <<<$(security cms -D -i $mobileprovision_file))
    echo "AppIDName:"$PROVISIONING_PROFILE_SPECIFIER

    UUID=$(/usr/libexec/PlistBuddy -c "Print UUID" /dev/stdin <<<$(security cms -D -i $mobileprovision_file))
    echo "UUID:"$UUID

    Name=$(/usr/libexec/PlistBuddy -c "Print Name" /dev/stdin <<<$(security cms -D -i $mobileprovision_file))
    echo "Name:"$Name

    # 获取teamid
    TeamIdentifier=$(/usr/libexec/PlistBuddy -c "Print TeamIdentifier:0" /dev/stdin <<<$(security cms -D -i $mobileprovision_file))
    echo "TeamIdentifier:"$TeamIdentifier

    # 获取teamid ( 获取数组: Print key:index )
    ApplicationIdentifierPrefix=$(/usr/libexec/PlistBuddy -c "Print ApplicationIdentifierPrefix:0" /dev/stdin <<<$(security cms -D -i $mobileprovision_file))
    echo "ApplicationIdentifierPrefix:"${ApplicationIdentifierPrefix}

    # 获取 teamid.appid
    PROVISIONING_PROFILE_SPECIFIER=$(/usr/libexec/PlistBuddy -c "Print Entitlements:application-identifier" /dev/stdin <<<$(security cms -D -i $mobileprovision_file))
    # 打印整一个
    echo "AppID:"${PROVISIONING_PROFILE_SPECIFIER}
    # 获取 teamid.appid 后面的 appid
    echo "bundleId:"${PROVISIONING_PROFILE_SPECIFIER#*${ApplicationIdentifierPrefix}.}

    # 这里解释一下生成证书名称组成
    # iPhone Distribution: xxx xx xxx CO., LTD (teamid)
    # xxx xx xxx CO., LTD: 公司地址
    # teamid: 团队id

    # 以下是 dis 内容
    # 因尽量保持不要暴露隐私的问题, 一下内容替换成了这些
    # appid: 项目 id
    # teamid: 团队id

    # <?xml version="1.0" encoding="UTF-8"?>
    # <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    # <plist version="1.0">
    # <dict>
    # 	<key>AppIDName</key>
    # 	<string>在开发者账号上面 app id 对应的 name</string>
    # 	<key>ApplicationIdentifierPrefix</key>
    # 	<array>
    # 	<string>teamid</string>
    # 	</array>
    # 	<key>CreationDate</key>
    # 	<date>2019-05-17T01:08:50Z</date>
    # 	<key>Platform</key>
    # 	<array>
    # 		<string>iOS</string>
    # 	</array>
    # 	<key>IsXcodeManaged</key>
    # 	<false/>
    # 	<key>DeveloperCertificates</key>
    # 	<array>
    # 		<data>xxxxx一大串码</data>
    # 	</array>

    # 	<key>Entitlements</key>
    # 	<dict>
    # 		<key>beta-reports-active</key>
    # 		<true/>
    # 						<key>aps-environment</key>
    # 		<string>production</string>
    # 						<key>com.apple.developer.siri</key>
    # 		<true/>
    # 						<key>com.apple.developer.networking.wifi-info</key>
    # 		<true/>
    # 						<key>application-identifier</key>
    # 		<string>teamid.appid</string>
    # 						<key>keychain-access-groups</key>
    # 		<array>
    # 				<string>teamid.*</string>
    # 		</array>
    # 						<key>get-task-allow</key>
    # 		<false/>
    # 						<key>com.apple.developer.team-identifier</key>
    # 		<string>teamid</string>

    # 	</dict>
    # 	<key>ExpirationDate</key>
    # 	<date>2019-12-26T08:29:06Z</date>
    # 	<key>Name</key>
    # 	<string>在开发者账号上面创建profile时的名称</string>
    # 	<key>TeamIdentifier</key>
    # 	<array>
    # 		<string>teamid</string>
    # 	</array>
    # 	<key>TeamName</key>
    # 	<string>公司地址信息</string>
    # 	<key>TimeToLive</key>
    # 	<integer>223</integer>
    # 	<key>UUID</key>
    # 	<string>唯一id, 改配置的唯一id ( 下载下来, 然后双击打开, 会自动到 Provisioning Profiles 这个文件夹下, 这个uuid就是在这里面的名称 ) </string>
    # 	<key>Version</key>
    # 	<integer>1</integer>
    # </dict>

}
