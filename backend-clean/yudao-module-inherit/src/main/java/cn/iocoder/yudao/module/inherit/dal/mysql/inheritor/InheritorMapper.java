package cn.iocoder.yudao.module.inherit.dal.mysql.inheritor;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorPageReqVO;
import cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo.AppInheritorPageReqVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorDO;
import cn.hutool.core.util.ObjectUtil;
import org.apache.ibatis.annotations.Mapper;

/**
 * 传承人 Mapper
 *
 * @author inherit
 */
@Mapper
public interface InheritorMapper extends BaseMapperX<InheritorDO> {

    /**
     * 管理后台分页查询
     */
    default PageResult<InheritorDO> selectPage(InheritorPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<InheritorDO>()
                .likeIfPresent(InheritorDO::getName, reqVO.getName())
                .eqIfPresent(InheritorDO::getLevel, reqVO.getLevel())
                .eqIfPresent(InheritorDO::getProvinceCode, reqVO.getProvinceCode())
                .eqIfPresent(InheritorDO::getCityCode, reqVO.getCityCode())
                .eqIfPresent(InheritorDO::getDistrictCode, reqVO.getDistrictCode())
                .eqIfPresent(InheritorDO::getStatus, reqVO.getStatus())
                .eqIfPresent(InheritorDO::getAuditStatus, reqVO.getAuditStatus())
                .orderByAsc(InheritorDO::getSort)
                .orderByDesc(InheritorDO::getId));
    }

    /**
     * 用户 App 分页查询：只返回【已启用 + 已通过审核 + 展示中】的传承人
     */
    default PageResult<InheritorDO> selectAppPage(AppInheritorPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<InheritorDO>()
                .eq(InheritorDO::getStatus, CommonStatusEnum.ENABLE.getStatus())
                .eq(InheritorDO::getAuditStatus, InheritorDO.AUDIT_STATUS_SUCCESS)
                .eq(InheritorDO::getDisplayStatus, 1)
                .eqIfPresent(InheritorDO::getLevel, reqVO.getLevel())
                .eqIfPresent(InheritorDO::getProvinceCode, reqVO.getProvinceCode())
                .eqIfPresent(InheritorDO::getCityCode, reqVO.getCityCode())
                .eqIfPresent(InheritorDO::getDistrictCode, reqVO.getDistrictCode())
                .and(ObjectUtil.isNotEmpty(reqVO.getKeyword()), w -> w
                        .like(InheritorDO::getName, reqVO.getKeyword())
                        .or().like(InheritorDO::getSpecialty, reqVO.getKeyword())
                        .or().like(InheritorDO::getPinyin, reqVO.getKeyword()))
                .orderByAsc(InheritorDO::getSort)
                .orderByDesc(InheritorDO::getId));
    }

    /**
     * 用户 App 详情校验查询：只返回【已启用 + 已通过审核 + 展示中】的传承人
     *
     * 4 个条件超过 BaseMapperX.selectOne 的 3 参重载上限，需使用 wrapper 形式。
     *
     * @param id 传承人编号
     * @return 公开可见的传承人；不可见（未审核/未展示/停用/已删除）返回 null
     */
    default InheritorDO selectPublicInheritor(Long id) {
        return selectOne(new LambdaQueryWrapperX<InheritorDO>()
                .eq(InheritorDO::getId, id)
                .eq(InheritorDO::getStatus, CommonStatusEnum.ENABLE.getStatus())
                .eq(InheritorDO::getAuditStatus, InheritorDO.AUDIT_STATUS_SUCCESS)
                .eq(InheritorDO::getDisplayStatus, 1));
    }

}
