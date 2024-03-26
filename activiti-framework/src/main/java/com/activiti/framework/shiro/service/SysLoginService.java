package com.activiti.framework.shiro.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.activiti.common.constant.Constants;
import com.activiti.common.constant.ShiroConstants;
import com.activiti.common.constant.UserConstants;
import com.activiti.common.core.domain.entity.SysUser;
import com.activiti.common.enums.UserStatus;
import com.activiti.common.exception.user.CaptchaException;
import com.activiti.common.exception.user.UserBlockedException;
import com.activiti.common.exception.user.UserDeleteException;
import com.activiti.common.exception.user.UserNotExistsException;
import com.activiti.common.exception.user.UserPasswordNotMatchException;
import com.activiti.common.utils.DateUtils;
import com.activiti.common.utils.MessageUtils;
import com.activiti.common.utils.ServletUtils;
import com.activiti.common.utils.ShiroUtils;
import com.activiti.common.utils.StringUtils;
import com.activiti.framework.manager.AsyncManager;
import com.activiti.framework.manager.factory.AsyncFactory;
import com.activiti.system.service.ISysUserService;

/**
 * 登录校验方法
 * 
 *
 */
@Component
public class SysLoginService
{
    @Autowired
    private SysPasswordService passwordService;

    @Autowired
    private ISysUserService userService;

    /**
     * 登录
     */
    public SysUser login(String username, String password)
    {
        // 验证码校验
        if (ShiroConstants.CAPTCHA_ERROR.equals(ServletUtils.getRequest().getAttribute(ShiroConstants.CURRENT_CAPTCHA)))
        {
            throw new CaptchaException();
        }
        // 用户名或密码为空 错误
        if (StringUtils.isEmpty(username) || StringUtils.isEmpty(password))
        {
            throw new UserNotExistsException();
        }
        // 密码如果不在指定范围内 错误
        if (password.length() < UserConstants.PASSWORD_MIN_LENGTH
                || password.length() > UserConstants.PASSWORD_MAX_LENGTH)
        {
            throw new UserPasswordNotMatchException();
        }

        // 用户名不在指定范围内 错误
        if (username.length() < UserConstants.USERNAME_MIN_LENGTH
                || username.length() > UserConstants.USERNAME_MAX_LENGTH)
        {
            throw new UserPasswordNotMatchException();
        }

        // 查询用户信息
        SysUser user = userService.selectUserByLoginName(username);

        /**
        if (user == null && maybeMobilePhoneNumber(username))
        {
            user = userService.selectUserByPhoneNumber(username);
        }

        if (user == null && maybeEmail(username))
        {
            user = userService.selectUserByEmail(username);
        }
        */

        if (user == null)
        {
            throw new UserNotExistsException();
        }
        
        if (UserStatus.DELETED.getCode().equals(user.getDelFlag()))
        {
            throw new UserDeleteException();
        }
        
        if (UserStatus.DISABLE.getCode().equals(user.getStatus()))
        {
            throw new UserBlockedException();
        }

        passwordService.validate(user, password);

        recordLoginInfo(user.getUserId());
        return user;
    }

    /**
    private boolean maybeEmail(String username)
    {
        if (!username.matches(UserConstants.EMAIL_PATTERN))
        {
            return false;
        }
        return true;
    }

    private boolean maybeMobilePhoneNumber(String username)
    {
        if (!username.matches(UserConstants.MOBILE_PHONE_NUMBER_PATTERN))
        {
            return false;
        }
        return true;
    }
    */

    /**
     * 记录登录信息
     *
     * @param userId 用户ID
     */
    public void recordLoginInfo(Long userId)
    {
        SysUser user = new SysUser();
        user.setUserId(userId);
        user.setLoginIp(ShiroUtils.getIp());
        user.setLoginDate(DateUtils.getNowDate());
        user.setUpdateTime(DateUtils.getNowDate());
        userService.updateUserInfo(user);
    }
}
