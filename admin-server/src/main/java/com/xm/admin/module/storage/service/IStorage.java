package com.xm.admin.module.storage.service;

import com.xm.common.vo.Result;
import org.springframework.web.multipart.MultipartFile;

public interface IStorage {

    /**
     * 上传文件
     * @param   file            文件
     * @param   folder          上传路径
     * @return  返回url地址
     */
    Result<Object> upload(MultipartFile file, String folder);

    /**
     * 获取文件url
     * @param  path  文件路径
     * @return  返回url
     */
    String getUrl(String path);
}
