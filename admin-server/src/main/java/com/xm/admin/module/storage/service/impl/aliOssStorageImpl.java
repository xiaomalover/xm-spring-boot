package com.xm.admin.module.storage.service.impl;

import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONObject;
import com.aliyun.oss.OSS;
import com.aliyun.oss.OSSClientBuilder;
import com.aliyun.oss.model.PutObjectRequest;
import com.xm.admin.module.storage.service.IStorage;
import com.xm.common.utils.ResultUtil;
import com.xm.common.vo.Result;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.net.URL;
import java.util.Date;
import java.util.Random;

@Component
public class aliOssStorageImpl implements IStorage {

    // endpoint以杭州为例，其它region请按实际情况填写
    @Value("${storage.alioss.endpoint}")
    private String endpoint;

    // accessKey
    @Value("${storage.alioss.accessKeyId}")
    private String accessKeyId;

    @Value("${storage.alioss.accessKeySecret}")
    private String accessKeySecret;

    //空间
    @Value("${storage.alioss.bucketName}")
    private String bucketName;

    //文件存储目录
    @Value("${storage.alioss.fileDir}")
    private String fileDir;

    @Override
    public Result<Object> upload(MultipartFile file, String folder) {
        if (file.getSize() > 10 * 1024 * 1024) {
            return new ResultUtil<>().error("大小不能超过10M！");
        }
        String originalFilename = file.getOriginalFilename();
        String substring = "";
        if (StrUtil.isNotBlank(originalFilename) && originalFilename != null) {
            substring = originalFilename.substring(originalFilename.lastIndexOf(".")).toLowerCase();
        }
        Random random = new Random();
        String name = random.nextInt(10000) + System.currentTimeMillis() + substring;
        if (StrUtil.isNotBlank(folder)) {
            name = folder + "/" + name;
        }
        try {
            InputStream inputStream = file.getInputStream();
            String url = this.uploadFile2OSS(inputStream, name);
            if (StrUtil.isNotBlank(url)) {
                JSONObject jsonObject = new JSONObject();
                jsonObject.set("url", url);
                jsonObject.set("path", "");
                return new ResultUtil<>().success(jsonObject);
            }
            return new ResultUtil<>().error("上传失败");
        } catch (Exception e) {
            return new ResultUtil<>().error("上传失败！");
        }
    }

    @Override
    public String getUrl(String path) {
        return path;
    }

    /**
     * 上传到OSS服务器  如果同名文件会覆盖服务器上的
     *
     * @param inputStream 文件流
     * @param fileName 文件名称 包括后缀名
     * @return 出错返回"" ,唯一MD5数字签名
     */
    public String uploadFile2OSS(InputStream inputStream, String fileName) {

        String fullFileName = fileDir + "/" + fileName;

        // 创建PutObjectRequest对象。
        // 依次填写Bucket名称（例如examplebucket）、Object完整路径（例如exampledir/exampleobject.txt）和本地文件的完整路径。Object完整路径中不能包含Bucket名称。
        // 如果未指定本地路径，则默认从示例程序所属项目对应本地路径中上传文件。
        PutObjectRequest putObjectRequest = new PutObjectRequest(bucketName, fullFileName, inputStream);

        // 如果需要上传时设置存储类型和访问权限，请参考以下示例代码。
        // ObjectMetadata metadata = new ObjectMetadata();
        // metadata.setHeader(OSSHeaders.OSS_STORAGE_CLASS, StorageClass.Standard.toString());
        // metadata.setObjectAcl(CannedAccessControlList.Private);
        // putObjectRequest.setMetadata(metadata);

        OSS ossClient = new OSSClientBuilder().build(endpoint, accessKeyId, accessKeySecret);

        // 上传文件。
        ossClient.putObject(putObjectRequest);

        // 关闭OSSClient。
        ossClient.shutdown();

        Date expiration = new Date(new Date().getTime() + 3600L * 1000 * 24 * 365 * 10);
        // 生成URL
        URL url = ossClient.generatePresignedUrl(bucketName, fullFileName, expiration);
        if (url != null) {
            return url.toString();
        }
        return "";
    }
}
