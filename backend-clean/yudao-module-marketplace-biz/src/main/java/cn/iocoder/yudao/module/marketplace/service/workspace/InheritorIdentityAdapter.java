package cn.iocoder.yudao.module.marketplace.service.workspace;

/**
 * Boundary for resolving a Member to an approved Inheritor profile.
 * The concrete integration belongs to yudao-module-inheritor-api in a later phase.
 */
public interface InheritorIdentityAdapter {

    Long getInheritorIdByMemberId(Long memberId);
}
