<template>
  <view class="page">
    <view v-if="!group" class="tip">加载中...</view>
    <template v-else>
      <!-- 群信息 -->
      <view class="group-header">
        <image class="g-avatar" :src="group.avatar || defaultAvatar" mode="aspectFill" />
        <view class="g-info">
          <view class="g-name">{{ group.name }}</view>
          <view class="g-notice" v-if="group.notice">公告：{{ group.notice }}</view>
        </view>
      </view>

      <!-- 成员 -->
      <view class="section">
        <view class="section-title">群成员（{{ members.length }}）</view>
        <view class="member-item" v-for="m in members" :key="m.userId">
          <image class="avatar" :src="m.avatar || defaultAvatar" mode="aspectFill" />
          <view class="m-info">
            <view class="m-name">
              {{ m.nickname || '用户' + m.userId }}
              <text class="role-tag" v-if="m.role === 1">群主</text>
              <text class="role-tag admin" v-else-if="m.role === 2">管理员</text>
            </view>
            <view class="m-remark" v-if="m.groupRemark">{{ m.groupRemark }}</view>
          </view>
          <text class="m-me" v-if="m.userId === myId">我</text>
        </view>
      </view>

      <!-- 操作 -->
      <view class="section">
        <view class="action-btn" @click="showInvite = true">邀请成员</view>
        <view class="action-btn danger" @click="doLeave">退出群聊</view>
        <view class="action-btn danger" v-if="group.ownerUserId === myId" @click="doDissolve">解散群聊</view>
      </view>
    </template>

    <!-- 邀请成员弹窗 -->
    <view class="mask" v-if="showInvite" @click="showInvite = false">
      <view class="invite-box" @click.stop>
        <view class="invite-title">邀请好友进群</view>
        <scroll-view scroll-y class="invite-list">
          <view class="invite-item" v-for="f in friends" :key="f.friendUserId" @click="toggleInvite(f.friendUserId)">
            <image class="avatar small" :src="f.avatar || defaultAvatar" mode="aspectFill" />
            <view class="invite-name">{{ f.displayName || f.nickname }}</view>
            <view class="checkbox" :class="{ checked: inviteIds.includes(f.friendUserId) }">
              {{ inviteIds.includes(f.friendUserId) ? '✓' : '' }}
            </view>
          </view>
          <view v-if="friends.length === 0" class="tip-mini">暂无好友可邀请</view>
        </scroll-view>
        <view class="invite-btn" :class="{ disabled: inviteIds.length === 0 }" @click="doInvite">邀请（{{ inviteIds.length }}）</view>
      </view>
    </view>
  </view>
</template>

<script>
import { getGroup, getGroupMemberList, inviteGroupMember, quitGroup, dissolveGroup } from '../../api/im.js'
import { getMyUserId, refreshContacts, getContacts } from '../../utils/imStore.js'

export default {
  data() {
    return {
      groupId: null,
      group: null,
      members: [],
      myId: null,
      friends: [],
      showInvite: false,
      inviteIds: [],
      defaultAvatar: 'https://qiniu-web-assets.dcloud.net.cn/unidoc/zh/uni.png',
    }
  },
  onLoad(options) {
    this.groupId = Number(options.groupId)
    this.myId = getMyUserId()
    const contacts = getContacts()
    this.friends = (contacts.friends || []).filter((f) => !f.blocked)
    this.load()
  },
  methods: {
    async load() {
      try {
        const [group, members] = await Promise.all([
          getGroup(this.groupId),
          getGroupMemberList(this.groupId),
        ])
        this.group = group
        this.members = (members || []).filter((m) => m.status === 0) // 仅展示在群成员
        uni.setNavigationBarTitle({ title: group && group.name ? group.name : '群信息' })
      } catch (e) {
        uni.showToast({ title: (e && e.msg) || '加载失败', icon: 'none' })
      }
    },
    toggleInvite(id) {
      const i = this.inviteIds.indexOf(id)
      if (i >= 0) {
        this.inviteIds.splice(i, 1)
      } else {
        this.inviteIds.push(id)
      }
    },
    async doInvite() {
      if (this.inviteIds.length === 0) return
      try {
        await inviteGroupMember(this.groupId, this.inviteIds)
        uni.showToast({ title: '已发送邀请', icon: 'success' })
        this.showInvite = false
        this.inviteIds = []
        this.load()
        refreshContacts()
      } catch (e) {
        uni.showToast({ title: (e && e.msg) || '邀请失败', icon: 'none' })
      }
    },
    doLeave() {
      uni.showModal({
        title: '退出群聊',
        content: '确定退出该群吗？',
        success: async (res) => {
          if (!res.confirm) return
          try {
            await quitGroup(this.groupId)
            uni.showToast({ title: '已退出', icon: 'success' })
            refreshContacts()
            setTimeout(() => uni.navigateBack(), 400)
          } catch (e) {
            uni.showToast({ title: (e && e.msg) || '操作失败', icon: 'none' })
          }
        },
      })
    },
    doDissolve() {
      uni.showModal({
        title: '解散群聊',
        content: '解散后所有成员将无法查看该群，确定继续？',
        success: async (res) => {
          if (!res.confirm) return
          try {
            await dissolveGroup(this.groupId)
            uni.showToast({ title: '已解散', icon: 'success' })
            refreshContacts()
            setTimeout(() => uni.navigateBack(), 400)
          } catch (e) {
            uni.showToast({ title: (e && e.msg) || '操作失败', icon: 'none' })
          }
        },
      })
    },
  },
}
</script>

<style>
.page {
  padding: 20rpx 24rpx 40rpx;
  background: #f7f7f7;
  min-height: 100vh;
}

.group-header {
  display: flex;
  align-items: center;
  background: #fff;
  border-radius: 16rpx;
  padding: 24rpx;
  margin-bottom: 20rpx;
}

.g-avatar {
  width: 120rpx;
  height: 120rpx;
  border-radius: 14rpx;
  background: #eee;
  flex-shrink: 0;
}

.g-info {
  flex: 1;
  margin-left: 24rpx;
  overflow: hidden;
}

.g-name {
  font-size: 34rpx;
  font-weight: bold;
  color: #333;
}

.g-notice {
  margin-top: 8rpx;
  font-size: 24rpx;
  color: #999;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.section {
  background: #fff;
  border-radius: 16rpx;
  padding: 24rpx;
  margin-bottom: 20rpx;
}

.section-title {
  font-size: 28rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 12rpx;
}

.member-item {
  display: flex;
  align-items: center;
  padding: 14rpx 0;
  border-bottom: 1rpx solid #f5f5f5;
}

.avatar {
  width: 80rpx;
  height: 80rpx;
  border-radius: 10rpx;
  background: #eee;
  flex-shrink: 0;
}

.m-info {
  flex: 1;
  margin-left: 20rpx;
  overflow: hidden;
}

.m-name {
  font-size: 30rpx;
  color: #333;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.role-tag {
  margin-left: 10rpx;
  font-size: 20rpx;
  color: #c8102e;
  border: 1rpx solid #c8102e;
  border-radius: 6rpx;
  padding: 0 8rpx;
}

.role-tag.admin {
  color: #576b95;
  border-color: #576b95;
}

.m-remark {
  font-size: 24rpx;
  color: #999;
}

.m-me {
  font-size: 22rpx;
  color: #bbb;
  flex-shrink: 0;
}

.action-btn {
  height: 84rpx;
  line-height: 84rpx;
  text-align: center;
  border-radius: 12rpx;
  background: #f2f2f2;
  color: #333;
  font-size: 30rpx;
  margin-bottom: 16rpx;
}

.action-btn.danger {
  background: #fff;
  color: #fa5151;
  border: 1rpx solid #fa5151;
}

.tip {
  text-align: center;
  color: #999;
  font-size: 28rpx;
  padding: 100rpx 0;
}

/* 邀请弹窗 */
.mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 999;
}

.invite-box {
  width: 600rpx;
  max-height: 75vh;
  background: #fff;
  border-radius: 16rpx;
  padding: 30rpx;
  display: flex;
  flex-direction: column;
}

.invite-title {
  font-size: 32rpx;
  font-weight: bold;
  text-align: center;
  margin-bottom: 20rpx;
}

.invite-list {
  flex: 1;
  max-height: 50vh;
}

.invite-item {
  display: flex;
  align-items: center;
  padding: 12rpx 0;
  border-bottom: 1rpx solid #f5f5f5;
}

.avatar.small {
  width: 64rpx;
  height: 64rpx;
}

.invite-name {
  flex: 1;
  margin-left: 16rpx;
  font-size: 28rpx;
  color: #333;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.checkbox {
  width: 40rpx;
  height: 40rpx;
  border-radius: 50%;
  border: 2rpx solid #ccc;
  text-align: center;
  line-height: 36rpx;
  font-size: 26rpx;
  color: #fff;
  flex-shrink: 0;
}

.checkbox.checked {
  background: #c8102e;
  border-color: #c8102e;
}

.invite-btn {
  margin-top: 20rpx;
  height: 80rpx;
  line-height: 80rpx;
  text-align: center;
  background: #c8102e;
  color: #fff;
  border-radius: 12rpx;
  font-size: 30rpx;
}

.invite-btn.disabled {
  opacity: 0.5;
}

.tip-mini {
  text-align: center;
  color: #999;
  font-size: 26rpx;
  padding: 40rpx 0;
}
</style>
