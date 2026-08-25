package cn.iocoder.yudao.module.inherit.util;

import cn.hutool.core.util.StrUtil;
import net.sourceforge.pinyin4j.PinyinHelper;
import net.sourceforge.pinyin4j.format.HanyuPinyinCaseType;
import net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat;
import net.sourceforge.pinyin4j.format.HanyuPinyinToneType;
import net.sourceforge.pinyin4j.format.HanyuPinyinVCharType;
import net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination;

/**
 * 姓名拼音工具：汉字转小写无音调拼音，非汉字原样保留，用于拼音搜索。
 *
 * @author inherit
 */
public class PinyinUtils {

    private static final HanyuPinyinOutputFormat FORMAT = new HanyuPinyinOutputFormat();

    static {
        FORMAT.setCaseType(HanyuPinyinCaseType.LOWERCASE);
        FORMAT.setToneType(HanyuPinyinToneType.WITHOUT_TONE);
        FORMAT.setVCharType(HanyuPinyinVCharType.WITH_V);
    }

    /**
     * 将字符串转为小写无音调拼音（如 王景泰 -&gt; wangjingtai）
     *
     * @param text 原文（可为 null/空）
     * @return 拼音；入参为空返回 null
     */
    public static String toPinyin(String text) {
        if (StrUtil.isBlank(text)) {
            return null;
        }
        StringBuilder result = new StringBuilder();
        for (char ch : text.toCharArray()) {
            if (Character.isLetter(ch)) {
                try {
                    String[] pinyins = PinyinHelper.toHanyuPinyinStringArray(ch, FORMAT);
                    if (pinyins != null && pinyins.length > 0) {
                        result.append(pinyins[0]);
                        continue;
                    }
                } catch (BadHanyuPinyinOutputFormatCombination ignored) {
                    // 非汉字字符，走下方原样保留
                }
            }
            result.append(Character.toLowerCase(ch));
        }
        return result.toString();
    }

}
