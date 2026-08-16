package cn.iocoder.yudao.module.inherit.dal.mysql.inheritor;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorQualificationPageReqVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorQualificationDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * 传承人荣誉/资质 Mapper
 *
 * @author inherit
 */
@Mapper
public interface InheritorQualificationMapper extends BaseMapperX<InheritorQualificationDO> {

    default PageResult<InheritorQualificationDO> selectPage(InheritorQualificationPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<InheritorQualificationDO>()
                .eqIfPresent(InheritorQualificationDO::getInheritorId, reqVO.getInheritorId())
                .eqIfPresent(InheritorQualificationDO::getType, reqVO.getType())
                .likeIfPresent(InheritorQualificationDO::getName, reqVO.getName())
                .orderByAsc(InheritorQualificationDO::getSort)
                .orderByDesc(InheritorQualificationDO::getId));
    }

    /**
     * 按传承人查询（C 端详情使用），只返回状态正常（ENABLE）的荣誉/资质
     */
    default List<InheritorQualificationDO> selectListByInheritorId(Long inheritorId) {
        return selectList(new LambdaQueryWrapperX<InheritorQualificationDO>()
                .eq(InheritorQualificationDO::getInheritorId, inheritorId)
                .eq(InheritorQualificationDO::getStatus, CommonStatusEnum.ENABLE.getStatus())
                .orderByAsc(InheritorQualificationDO::getSort)
                .orderByDesc(InheritorQualificationDO::getId));
    }

    /**
     * 传承人删除时，级联逻辑删除其荣誉/资质
     */
    default void deleteByInheritorId(Long inheritorId) {
        delete(new LambdaQueryWrapperX<InheritorQualificationDO>()
                .eq(InheritorQualificationDO::getInheritorId, inheritorId));
    }

}
