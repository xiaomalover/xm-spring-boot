package com.xm.admin.module.storage.service.impl;

import cn.hutool.json.JSONObject;
import com.xm.admin.common.utils.ImageUtil;
import com.xm.admin.module.storage.service.IStorage;
import com.xm.common.utils.ResultUtil;
import com.xm.common.vo.Result;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.util.DigestUtils;
import org.springframework.util.ObjectUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;

@Component
public class LocalStorageImpl implements IStorage {


    @Value("${storage.local.rootPath}")
    private String imagePath;

    @Value("${storage.local.domain}")
    private String imageDomain;

    @Override
    public Result<Object> upload(MultipartFile file, String folder) {
        try {

            String rootPath = imagePath;
            String savePath = rootPath + File.separator + folder;
            if (!ImageUtil.initDir(savePath)) {
                return new ResultUtil<>().error("创建上传目录失败");
            }
            String fName = file.getOriginalFilename();
            if (ObjectUtils.isEmpty(fName)) {
                return new ResultUtil<>().error("读取文件失败");
            }
            String suffix = fName.substring(fName.lastIndexOf(".") + 1);
            InputStream inputStream = file.getInputStream();

            //创建一个文件输出流
            String fileName = DigestUtils.md5DigestAsHex(fName.getBytes()) + "." + suffix;
            FileOutputStream fos = new FileOutputStream(savePath + File.separator + fileName);

            //创建一个缓冲区
            byte[] buffer = new byte[1024];
            //判断输入流中的数据是否已经读完的标识
            int length;
            //循环将输入流读入到缓冲区当中，(len=in.read(buffer))>0就表示in里面还有数据
            while ((length = inputStream.read(buffer)) > 0) {
                //使用FileOutputStream输出流将缓冲区的数据写入到指定的目录(savePath + "\\" + filename)当中
                fos.write(buffer, 0, length);
            }
            //关闭输入流
            inputStream.close();
            //关闭输出流
            fos.close();

            String fullUrl = imageDomain + folder + "/" + fileName;

            JSONObject jsonObject = new JSONObject();
            jsonObject.set("url", fullUrl);
            jsonObject.set("path", folder + "/" + fileName);
            return new ResultUtil<>().success(jsonObject);
        } catch (Exception e) {
            return new ResultUtil<>().error(e.toString());
        }
    }
}
