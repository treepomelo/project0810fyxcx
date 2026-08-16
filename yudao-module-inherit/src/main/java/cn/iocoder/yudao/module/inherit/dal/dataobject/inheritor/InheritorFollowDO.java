package cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 传承人关注 DO
 *
 * 用户（member_user）关注传承人。user_id + inheritor_id 唯一，防止重复关注。
 * user_id 取自登录用户 {@code SecurityFrameworkUtils.getLoginUserId()}，复用底座用户体系，
 * 不新建任何用户/账号体系。
 *
 * @author inherit
 */
@TableName("inherit_inheritor_follow")
@Data
@EqualsAndHashCode(callSuper = true)
public class InheritorFollowDO extends TenantBaseDO {

    /**
     * 编号
     */
    private Long id;
    /**
     * 用户编号（member_user.id）
     */
    private Long userId;
    /**
     * 传承人编号
     */
    private Long inheritorId;

}
