package cn.keking.utils;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

/**
 * @author kl (http://kailing.pub)
 * @since 2023/8/11
 */
public class DateUtils {
    /**
     * 获取当前时间的秒级时间戳
     * @return
     */
    public static long getCurrentSecond() {
       return Instant.now().getEpochSecond();
    }

    /**
     * 计算当前时间与指定时间的秒级时间戳差值
     * @param datetime 指定时间
     * @return 差值
     */
    public static long calculateCurrentTimeDifference(long datetime) {
        return getCurrentSecond() - datetime;
    }
    
    /**
     * 将时间戳格式化为可读字符串
     * @param timestamp 时间戳（毫秒）
     * @return 格式化后的时间字符串
     */
    public static String formatTime(long timestamp) {
        LocalDateTime dateTime = LocalDateTime.ofInstant(
                Instant.ofEpochMilli(timestamp),
                ZoneId.systemDefault()
        );
        return dateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
    }
}
