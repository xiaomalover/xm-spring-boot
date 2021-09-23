package com.xm.admin.module.storage.controller;

import cn.hutool.core.util.StrUtil;
import com.xm.admin.module.storage.service.IStorage;
import com.xm.admin.module.storage.service.StorageFactory;
import com.xm.common.vo.Result;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/file")
public class FileController {

    final private IStorage storage;

    public FileController(StorageFactory factoryForStrategy, @Value("${storage.type}") String storageType) {
        this.storage = factoryForStrategy.getStorage(storageType + "Impl");
    }

    @PostMapping("/upload")
    public Result<Object> upload(
        @RequestParam MultipartFile file,
        @RequestParam(required = false) String folder)
    {
        if (StrUtil.isBlank(folder)) {
            folder = "localDefault";
        }
        return storage.upload(file, folder);
    }
}
