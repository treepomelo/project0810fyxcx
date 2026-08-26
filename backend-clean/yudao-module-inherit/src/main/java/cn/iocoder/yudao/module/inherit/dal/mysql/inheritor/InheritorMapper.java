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

/** 传承人 Mapper */
@Mapper
public interface InheritorMapper extends BaseMapperX<InheritorDO> {

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

    /** App 分页在数据库层完成公开条件、关键词、地区、级别和门类过滤。 */
    default PageResult<InheritorDO> selectAppPage(AppInheritorPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<InheritorDO>()
                .eq(InheritorDO::getStatus, CommonStatusEnum.ENABLE.getStatus())
                .eq(InheritorDO::getAuditStatus, InheritorDO.AUDIT_STATUS_SUCCESS)
                .eq(InheritorDO::getDisplayStatus, 1)
                .eqIfPresent(InheritorDO::getLevel, reqVO.getLevel())
                .eqIfPresent(InheritorDO::getProvinceCode, reqVO.getProvinceCode())
                .eqIfPresent(InheritorDO::getCityCode, reqVO.getCityCode())
                .eqIfPresent(InheritorDO::getDistrictCode, reqVO.getDistrictCode())
                .inSql(reqVO.getHeritageCategoryId() != null, InheritorDO::getId,
                        "SELECT r.inheritor_id FROM inherit_inheritor_project_relation r " +
                                "JOIN heritage_project p ON p.id = r.project_id AND p.deleted = 0 AND p.status = 1 " +
                                "JOIN heritage_category c ON c.id = p.category_id AND c.deleted = 0 AND c.status = 1 " +
                                "WHERE r.deleted = 0 AND p.category_id = " + reqVO.getHeritageCategoryId())
                .and(ObjectUtil.isNotEmpty(reqVO.getKeyword()), w -> w
                        .like(InheritorDO::getName, reqVO.getKeyword())
                        .or().like(InheritorDO::getSpecialty, reqVO.getKeyword())
                        .or().like(InheritorDO::getPinyin, reqVO.getKeyword()))
                .orderByAsc(InheritorDO::getSort)
                .orderByDesc(InheritorDO::getId));
    }

    default InheritorDO selectPublicInheritor(Long id) {
        return selectOne(new LambdaQueryWrapperX<InheritorDO>()
                .eq(InheritorDO::getId, id)
                .eq(InheritorDO::getStatus, CommonStatusEnum.ENABLE.getStatus())
                .eq(InheritorDO::getAuditStatus, InheritorDO.AUDIT_STATUS_SUCCESS)
                .eq(InheritorDO::getDisplayStatus, 1));
    }
}