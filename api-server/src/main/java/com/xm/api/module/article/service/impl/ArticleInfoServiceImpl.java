package com.xm.api.module.article.service.impl;

import com.xm.api.module.article.entity.ArticleInfo;
import com.xm.api.module.article.mapper.ArticleInfoMapper;
import com.xm.api.module.article.service.IArticleInfoService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 文章表 服务实现类
 * </p>
 *
 * @author xiaomalover <xiaomalover@gmail.com>
 * @since 2020-03-01
 */
@Service
public class ArticleInfoServiceImpl extends ServiceImpl<ArticleInfoMapper, ArticleInfo> implements IArticleInfoService {

}
