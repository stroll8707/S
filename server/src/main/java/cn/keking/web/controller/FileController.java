package cn.keking.web.controller;

import cn.keking.config.ConfigConstants;
import cn.keking.model.ReturnResponse;
import cn.keking.utils.CaptchaUtil;
import cn.keking.utils.DateUtils;
import cn.keking.utils.KkFileUtils;
import cn.keking.utils.RarUtils;
import cn.keking.utils.WebUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.ObjectUtils;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import static cn.keking.utils.CaptchaUtil.CAPTCHA_CODE;
import static cn.keking.utils.CaptchaUtil.CAPTCHA_GENERATE_TIME;

/**
 * 批量删除文件请求模型
 */
class BatchDeleteRequest {
    private List<String> fileNames;
    private String password;

    public List<String> getFileNames() {
        return fileNames;
    }

    public void setFileNames(List<String> fileNames) {
        this.fileNames = fileNames;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}

/**
 * @author yudian-it
 * 2017/12/1
 */
@RestController
public class FileController {

    private final Logger logger = LoggerFactory.getLogger(FileController.class);

    private final String fileDir = ConfigConstants.getFileDir();
    private final String demoDir = "demo";

    private final String demoPath = demoDir + File.separator;
    public static final String BASE64_DECODE_ERROR_MSG = "Base64解码失败，请检查你的 %s 是否采用 Base64 + urlEncode 双重编码了！";

    @PostMapping("/fileUpload")
    public ReturnResponse<Object> fileUpload(@RequestParam("file") MultipartFile file) {
        // 将单个文件转为数组，调用批量上传方法
        MultipartFile[] files = new MultipartFile[]{file};
        return batchFileUpload(files);
    }

    @PostMapping("/batchFileUpload")
    public ReturnResponse<Object> batchFileUpload(@RequestParam("files") MultipartFile[] files) {
        if (files == null || files.length == 0) {
            return ReturnResponse.failure("没有选择文件");
        }
        
        List<String> successFiles = new ArrayList<>();
        List<String> failureFiles = new ArrayList<>();
        
        for (MultipartFile file : files) {
            ReturnResponse<Object> checkResult = this.fileUploadCheck(file);
            if (checkResult.isFailure()) {
                failureFiles.add(file.getOriginalFilename() + "(" + checkResult.getMsg() + ")");
                continue;
            }
            
            File outFile = new File(fileDir + demoPath);
            if (!outFile.exists() && !outFile.mkdirs()) {
                logger.error("创建文件夹【{}】失败，请检查目录权限！", fileDir + demoPath);
            }
            
            String fileName = checkResult.getContent().toString();
            logger.info("上传文件：{}{}{}", fileDir, demoPath, fileName);
            
            try (InputStream in = file.getInputStream(); 
                 OutputStream out = Files.newOutputStream(Paths.get(fileDir + demoPath + fileName))) {
                StreamUtils.copy(in, out);
                successFiles.add(fileName);
            } catch (IOException e) {
                logger.error("文件上传失败: " + fileName, e);
                failureFiles.add(fileName);
            }
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", successFiles);
        result.put("failure", failureFiles);
        
        return ReturnResponse.success(result);
    }

    @GetMapping("/deleteFile")
    public ReturnResponse<Object> deleteFile(HttpServletRequest request, String fileName, String password) {
        ReturnResponse<Object> checkResult = this.deleteFileCheck(request, fileName, password);
        if (checkResult.isFailure()) {
            return checkResult;
        }
        fileName = checkResult.getContent().toString();
        File file = new File(fileDir + demoPath + fileName);
        logger.info("删除文件：{}", file.getAbsolutePath());
        if (file.exists() && !file.delete()) {
            String msg = String.format("删除文件【%s】失败，请检查目录权限！", file.getPath());
            logger.error(msg);
            return ReturnResponse.failure(msg);
        }
        WebUtils.removeSessionAttr(request, CAPTCHA_CODE); //删除缓存验证码
        return ReturnResponse.success();
    }

    /**
     * 验证码方法
     */
    @RequestMapping("/deleteFile/captcha")
    public void captcha(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (!ConfigConstants.getDeleteCaptcha()) {
            return;
        }

        response.setContentType("image/jpeg");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", -1);
        String captchaCode = WebUtils.getSessionAttr(request, CAPTCHA_CODE);
        long captchaGenerateTime = WebUtils.getLongSessionAttr(request, CAPTCHA_GENERATE_TIME);
        long timeDifference = DateUtils.calculateCurrentTimeDifference(captchaGenerateTime);

        // 验证码为空，且生成验证码超过50秒，重新生成验证码
        if (timeDifference > 50 && ObjectUtils.isEmpty(captchaCode)) {
            captchaCode = CaptchaUtil.generateCaptchaCode();
            // 更新验证码
            WebUtils.setSessionAttr(request, CAPTCHA_CODE, captchaCode);
            WebUtils.setSessionAttr(request, CAPTCHA_GENERATE_TIME, DateUtils.getCurrentSecond());
        } else {
            captchaCode = ObjectUtils.isEmpty(captchaCode) ? "wait" : captchaCode;
        }

        ServletOutputStream outputStream = response.getOutputStream();
        ImageIO.write(CaptchaUtil.generateCaptchaPic(captchaCode), "jpeg", outputStream);
        outputStream.close();
    }

    @GetMapping("/listFiles")
    public List<Map<String, String>> getFiles() {
        List<Map<String, String>> list = new ArrayList<>();
        File file = new File(fileDir + demoPath);
        if (file.exists()) {
            File[] files = Objects.requireNonNull(file.listFiles());
            Arrays.sort(files, (f1, f2) -> Long.compare(f2.lastModified(), f1.lastModified()));
            Arrays.stream(files).forEach(file1 -> {
                Map<String, String> fileInfo = new HashMap<>();
                fileInfo.put("fileName", demoDir + "/" + file1.getName());
                fileInfo.put("uploadTime", DateUtils.formatTime(file1.lastModified()));
                list.add(fileInfo);
            });
        }
        return list;
    }

    /**
     * 上传文件前校验
     *
     * @param file 文件
     * @return 校验结果
     */
    private ReturnResponse<Object> fileUploadCheck(MultipartFile file) {
        if (ConfigConstants.getFileUploadDisable()) {
            return ReturnResponse.failure("文件传接口已禁用");
        }
        String fileName = WebUtils.getFileNameFromMultipartFile(file);
        if (fileName.lastIndexOf(".") == -1) {
            return ReturnResponse.failure("不允许上传的类型");
        }
        if (!KkFileUtils.isAllowedUpload(fileName)) {
            return ReturnResponse.failure("不允许上传的文件类型: " + fileName);
        }
        if (KkFileUtils.isIllegalFileName(fileName)) {
            return ReturnResponse.failure("不允许上传的文件名: " + fileName);
        }
        // 判断是否存在同名文件
        if (existsFile(fileName)) {
            return ReturnResponse.failure("存在同名文件，请先删除原有文件再次上传");
        }
        return ReturnResponse.success(fileName);
    }


    /**
     * 删除文件前校验
     *
     * @param fileName 文件名
     * @return 校验结果
     */
    private ReturnResponse<Object> deleteFileCheck(HttpServletRequest request, String fileName, String password) {
        if (ObjectUtils.isEmpty(fileName)) {
            return ReturnResponse.failure("文件名为空，删除失败！");
        }
        try {
            fileName = WebUtils.decodeUrl(fileName);
        } catch (Exception ex) {
            String errorMsg = String.format(BASE64_DECODE_ERROR_MSG, fileName);
            return ReturnResponse.failure(errorMsg + "删除失败！");
        }
        assert fileName != null;
        if (fileName.contains("/")) {
            fileName = fileName.substring(fileName.lastIndexOf("/") + 1);
        }
        if (KkFileUtils.isIllegalFileName(fileName)) {
            return ReturnResponse.failure("非法文件名，删除失败！");
        }
        if (ObjectUtils.isEmpty(password)) {
            return ReturnResponse.failure("密码 or 验证码为空，删除失败！");
        }

        String expectedPassword = ConfigConstants.getDeleteCaptcha() ? WebUtils.getSessionAttr(request, CAPTCHA_CODE) : ConfigConstants.getPassword();

        if (!password.equalsIgnoreCase(expectedPassword)) {
            logger.error("删除文件【{}】失败，密码错误！", fileName);
            return ReturnResponse.failure("删除文件失败，密码错误！");
        }
        return ReturnResponse.success(fileName);
    }

    @GetMapping("/directory")
    public Object directory(String urls) {
        String fileUrl;
        try {
            fileUrl = WebUtils.decodeUrl(urls);
        } catch (Exception ex) {
            String errorMsg = String.format(BASE64_DECODE_ERROR_MSG, "url");
            return ReturnResponse.failure(errorMsg);
        }
        fileUrl = fileUrl.replaceAll("http://", "");
        if (KkFileUtils.isIllegalFileName(fileUrl)) {
            return ReturnResponse.failure("不允许访问的路径:");
        }
        return RarUtils.getTree(fileUrl);
    }

    /**
     * 批量删除文件名检查，不进行密码验证
     *
     * @param fileName 文件名
     * @return 校验结果
     */
    private ReturnResponse<Object> batchDeleteFileCheck(String fileName) {
        if (ObjectUtils.isEmpty(fileName)) {
            return ReturnResponse.failure("文件名为空，删除失败！");
        }
        
        String decodedFileName = null;
        try {
            // 先进行 URL 解码再进行 Base64 解码
            String urlDecoded = java.net.URLDecoder.decode(fileName, "UTF-8");
            decodedFileName = WebUtils.decodeUrl(urlDecoded);
            
            if (decodedFileName == null) {
                logger.error("文件名解码后为空，原始文件名: {}", fileName);
                return ReturnResponse.failure("文件名解码失败，删除失败！");
            }
        } catch (Exception ex) {
            logger.error("文件名解码异常: " + fileName, ex);
            return ReturnResponse.failure("文件名解码异常，删除失败！");
        }
        
        // 处理路径中的分隔符
        if (decodedFileName.contains("/")) {
            decodedFileName = decodedFileName.substring(decodedFileName.lastIndexOf("/") + 1);
        }
        
        // 检查文件名合法性
        if (KkFileUtils.isIllegalFileName(decodedFileName)) {
            return ReturnResponse.failure("非法文件名，删除失败！");
        }
        
        return ReturnResponse.success(decodedFileName);
    }

    @PostMapping("/batchDeleteFiles")
    public ReturnResponse<Object> batchDeleteFiles(HttpServletRequest request, @RequestBody BatchDeleteRequest deleteRequest) {
        if (deleteRequest == null || deleteRequest.getFileNames() == null || deleteRequest.getFileNames().isEmpty()) {
            return ReturnResponse.failure("未选择任何文件");
        }
        
        String password = deleteRequest.getPassword();
        if (ObjectUtils.isEmpty(password)) {
            return ReturnResponse.failure("密码 or 验证码为空，删除失败！");
        }
        
        String expectedPassword = ConfigConstants.getDeleteCaptcha() ? WebUtils.getSessionAttr(request, CAPTCHA_CODE) : ConfigConstants.getPassword();
        if (!password.equalsIgnoreCase(expectedPassword)) {
            logger.error("批量删除文件失败，密码错误！");
            return ReturnResponse.failure("删除文件失败，密码错误！");
        }
        
        int successCount = 0;
        int failureCount = 0;
        
        for (String encodedFileName : deleteRequest.getFileNames()) {
            try {
                // 处理前端传入的编码文件名，只做文件名检查，不重复验证密码
                ReturnResponse<Object> checkResult = this.batchDeleteFileCheck(encodedFileName);
                if (checkResult.isFailure()) {
                    failureCount++;
                    continue;
                }
                
                String fileName = checkResult.getContent().toString();
                File file = new File(fileDir + demoPath + fileName);
                logger.info("批量删除文件：{}", file.getAbsolutePath());
                if (file.exists() && file.delete()) {
                    successCount++;
                } else {
                    failureCount++;
                    logger.error("删除文件【{}】失败，请检查目录权限！", file.getPath());
                }
            } catch (Exception e) {
                failureCount++;
                logger.error("删除文件失败: " + encodedFileName, e);
            }
        }
        
        // 如果使用验证码，删除缓存验证码
        if (ConfigConstants.getDeleteCaptcha()) {
            WebUtils.removeSessionAttr(request, CAPTCHA_CODE);
        }
        
        Map<String, Integer> result = new HashMap<>();
        result.put("success", successCount);
        result.put("failure", failureCount);
        
        return ReturnResponse.success(result);
    }

    private boolean existsFile(String fileName) {
        File file = new File(fileDir + demoPath + fileName);
        return file.exists();
    }

    /**
     * 处理文件下载请求
     *
     * @param urlPath  经过Base64编码的文件URL
     * @param response HttpServletResponse对象
     */
    @GetMapping("/download")
    public void downloadFile(String urlPath, HttpServletResponse response) {
        String decodedUrl;
        try {
            decodedUrl = WebUtils.decodeUrl(urlPath);
        } catch (Exception ex) {
            logger.error("文件下载失败，urlPath：{}，错误信息：{}", urlPath, ex.getMessage());
            return;
        }
        
        if (decodedUrl == null) {
            return;
        }
        
        // 先检查是否是demo目录的文件
        String fileName = decodedUrl;
        boolean isDemoFile = false;

        // 处理demo目录下的文件
        if (fileName.startsWith(demoDir)) {
            isDemoFile = true;
            if (fileName.startsWith(demoDir + "/")) {
                fileName = fileName.substring((demoDir + "/").length());
            } else if (fileName.startsWith(demoDir + "\\")) {
                fileName = fileName.substring((demoDir + "\\").length());
            } else {
                fileName = fileName.substring(demoDir.length());
            }
        }
        
        // 从文件名中提取实际的文件名（不含路径）
        String displayFileName = fileName;
        if (displayFileName.contains("/")) {
            displayFileName = displayFileName.substring(displayFileName.lastIndexOf("/") + 1);
        }
        if (displayFileName.contains("\\")) {
            displayFileName = displayFileName.substring(displayFileName.lastIndexOf("\\") + 1);
        }
        
        // 确定文件的实际路径
        String localFilePath;
        if (isDemoFile) {
            localFilePath = fileDir + demoPath + fileName;
        } else {
            localFilePath = fileDir + fileName;
        }
        
        File file = new File(localFilePath);
        if (!file.exists()) {
            try {
                response.setContentType("text/html;charset=utf-8");
                response.getWriter().write("404，您请求的文件不存在!");
                logger.error("请求的文件不存在，路径：{}", localFilePath);
                return;
            } catch (IOException e) {
                logger.error("写入响应数据失败", e);
                return;
            }
        }
        
        // 设置文件下载响应头
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment;filename=" + 
            new String(displayFileName.getBytes(StandardCharsets.UTF_8), StandardCharsets.ISO_8859_1));
        
        // 将文件写入响应输出流
        try (InputStream inputStream = Files.newInputStream(file.toPath());
             OutputStream outputStream = response.getOutputStream()) {
            
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
            outputStream.flush();
            logger.info("文件下载成功：{}", localFilePath);
            
        } catch (IOException e) {
            logger.error("文件下载失败，文件路径：{}，错误信息：{}", localFilePath, e.getMessage());
        }
    }
}
