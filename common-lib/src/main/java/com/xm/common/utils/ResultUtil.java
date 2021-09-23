package com.xm.common.utils;

import com.xm.common.enums.ResultCodeEnums;
import com.xm.common.vo.Result;

/**
 * @author xiaomalover <xiaomalover@gmail.com>
 * 返回结果(vo)工具类
 */
public class ResultUtil<T> {

    /**
     * 结果对象
     */
    private Result<T> result;

    /**
     * 构造函数初始化结果对象，以免其它方法都要初始化结果对象
     */
    public ResultUtil() {
        result = new Result<>();
        result.setSuccess(true);
        result.setCode(null);
        result.setMessage(null);
        result.setResult(null);
    }

    public Result<T> success() {

        result.setSuccess(true);
        result.setCode(ResultCodeEnums.SUCCESS.getCode());
        result.setMessage(ResultCodeEnums.SUCCESS.getMessage());
        result.setResult(null);

        return result;
    }

    public Result<T> success(T t) {

        result.setSuccess(true);
        result.setCode(ResultCodeEnums.SUCCESS.getCode());
        result.setMessage(ResultCodeEnums.SUCCESS.getMessage());
        result.setResult(t);

        return result;
    }

    public Result<T> success(String msg) {

        result.setSuccess(true);
        result.setCode(ResultCodeEnums.SUCCESS.getCode());
        result.setResult(null);
        result.setMessage(msg);

        return this.result;
    }

    public Result<T> success(T t, String msg) {

        result.setSuccess(true);
        result.setCode(ResultCodeEnums.SUCCESS.getCode());
        result.setMessage(msg);
        result.setResult(t);

        return this.result;
    }

    public Result<T> error() {

        result.setSuccess(false);
        result.setCode(ResultCodeEnums.ERR.getCode());
        result.setMessage(ResultCodeEnums.ERR.getMessage());
        result.setResult(null);

        return this.result;
    }


    public Result<T> error(ResultCodeEnums resultCodeEnums, T t) {

        result.setSuccess(false);
        result.setCode(resultCodeEnums.getCode());
        result.setMessage(resultCodeEnums.getMessage());
        result.setResult(t);

        return this.result;
    }

    public Result<T> error(ResultCodeEnums resultCodeEnums) {

        result.setSuccess(false);
        result.setCode(resultCodeEnums.getCode());
        result.setMessage(resultCodeEnums.getMessage());
        result.setResult(null);

        return this.result;
    }

    public Result<T> error(String msg) {

        result.setSuccess(false);
        result.setCode(ResultCodeEnums.ERR.getCode());
        result.setMessage(msg);
        result.setResult(null);

        return this.result;
    }

    public Result<T> error(Integer code, String msg) {

        this.result.setSuccess(false);
        this.result.setCode(code);
        this.result.setMessage(msg);
        this.result.setResult(null);

        return this.result;
    }

    public Result<T> error(Integer code, String msg, T data) {

        this.result.setSuccess(false);
        this.result.setCode(code);
        this.result.setMessage(msg);
        this.result.setResult(data);

        return this.result;
    }
}
