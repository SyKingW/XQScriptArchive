echo '打印json'

# jq 也支持管道操作, 就是连续命令行的意思, 把上一个管道操作的值给下一个管道

# 读取
# jq . filenpath
# jq . filenpath 读取所有
# jq .key.key.key filenpath, 就相当于一层一层取值
# jq .key[0][2][1], 数组一层一层取值, jq .key[] 是获取所有元素
# 当然，也可以组合起来用
# 注意, 这里有一个坑, 作为 key, 不能用数字开头...目前没找到解决方法
# 这个还有很多操作....以后再研究吧
echo "所有: $(jq . xq_shell/xq_config.json)"
echo "testDic.key.key: $(jq .testDic.key.key xq_shell/xq_config.json)"
echo "testArr[]: $(jq .testArr[] xq_shell/xq_config.json)"
echo "testArr[1][1].key: $(jq .testArr[1][1].key xq_shell/xq_config.json)"

echo '打印json结束'

# if [s=1]
# fi

# echo "请选择编译类型 ?"
# echo "1:development"
# echo "2:app store"
# read number
# while ([[ $number != 1 ]] && [[ $number != 2 ]]); do
#     echo "Error! Should enter 1 or 2"
#     echo "请选择编译类型 ?"
#     echo "1:Release"
#     echo "2:Debug"
#     read number
# done

exit 0
