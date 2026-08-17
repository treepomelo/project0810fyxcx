<template>
  <view class="chat-page">
    <!-- 顶部 -->
    <view class="top-bar">
      <view class="top-back" @click="goBack">
        <text class="back-icon">‹</text>
      </view>

      <view class="top-title">
        <text class="title">{{ name || (isGroup ? '群聊' : '聊天') }}</text>
        <text v-if="isGroup" class="subtitle">群聊</text>
      </view>

      <view class="top-more" @click="showChatMenu">
        <text>•••</text>
      </view>
    </view>

    <!-- 消息区域 -->
    <scroll-view
      class="msg-scroll"
      scroll-y
      :scroll-into-view="scrollIntoId"
      :scroll-with-animation="true"
      :show-scrollbar="false"
    >
      <view class="msg-list">

        <!-- 历史消息 -->
        <view v-if="loadingHistory" class="history-tip">
          <view class="loading-dot"></view>
          <text>正在加载消息...</text>
        </view>

        <view
          v-else-if="!historyEnded"
          class="history-more"
          @click="loadMore"
        >
          <text>加载更早消息</text>
        </view>

        <view
          v-else-if="messages.length"
          class="history-end"
        >
          <text>以上是更早的消息</text>
        </view>

        <!-- 消息 -->
        <view
          v-for="m in messages"
          :id="'msg-' + m.id"
          :key="m.id"
          class="msg-wrap"
        >

          <!-- 系统消息 -->
          <view v-if="isTip(m)" class="msg-tip">
            {{ renderTip(m) }}
          </view>

          <!-- 普通消息 -->
          <view
            v-else
            class="msg-row"
            :class="{ mine: m._mine }"
          >
            <!-- 对方头像 -->
            <image
              v-if="!m._mine"
              class="msg-avatar"
              :src="m._avatar || defaultAvatar"
              mode="aspectFill"
            />

            <view class="msg-content">

              <!-- 群聊昵称 -->
              <view
                v-if="!m._mine && isGroup && m._senderName"
                class="msg-name"
              >
                {{ m._senderName }}
              </view>

              <!-- 文字 -->
              <view
                v-if="m._kind === 'text'"
                class="text-bubble bubble"
                :class="{ mine: m._mine }"
                @longpress="onLongPress(m)"
              >
                <text selectable>{{ m._text }}</text>
              </view>

              <!-- 图片 -->
              <view
                v-else-if="m._kind === 'image'"
                class="image-bubble"
                :class="{ mine: m._mine }"
                @longpress="onLongPress(m)"
              >
                <image
                  class="chat-image"
                  :src="m._imageUrl"
                  mode="aspectFill"
                  @click.stop="preview(m._imageUrl)"
                />
              </view>

              <!-- 语音 -->
              <view
                v-else-if="m._kind === 'voice'"
                class="voice-bubble"
                :class="{ mine: m._mine }"
                :style="{ width: voiceWidth(m._duration) + 'rpx' }"
                @click.stop="playVoice(m)"
                @longpress="onLongPress(m)"
              >
                <!-- 自己的消息，波形在右边 -->
                <view
                  v-if="m._mine"
                  class="voice-duration"
                >
                  {{ m._duration }}″
                </view>

                <view
                  class="voice-icon"
                  :class="{ playing: playingVoiceId === m.id }"
                >
                  <view class="wave wave1"></view>
                  <view class="wave wave2"></view>
                  <view class="wave wave3"></view>
                </view>

                <!-- 对方消息，时长在右边 -->
                <view
                  v-if="!m._mine"
                  class="voice-duration"
                >
                  {{ m._duration }}″
                </view>
              </view>

              <!-- 其它消息 -->
              <view
                v-else
                class="text-bubble bubble"
                :class="{ mine: m._mine }"
                @longpress="onLongPress(m)"
              >
                <text>{{ renderTip(m) }}</text>
              </view>

            </view>

            <!-- 自己头像 -->
            <image
              v-if="m._mine"
              class="msg-avatar"
              :src="m._avatar || defaultAvatar"
              mode="aspectFill"
            />
          </view>
        </view>

        <!-- 底部留白 -->
        <view class="bottom-space"></view>
      </view>
    </scroll-view>

    <!-- 正在录音遮罩 -->
    <view
      v-if="recording"
      class="record-mask"
    >
      <view class="record-panel">

        <view class="record-animation">
          <view class="record-circle">
            <view class="record-mic">🎙</view>
          </view>
        </view>

        <text class="record-title">
          {{ recordSeconds }}″
        </text>

        <text class="record-tip">
          松开结束
        </text>

        <view class="record-wave">
          <view class="record-bar bar1"></view>
          <view class="record-bar bar2"></view>
          <view class="record-bar bar3"></view>
          <view class="record-bar bar4"></view>
          <view class="record-bar bar5"></view>
          <view class="record-bar bar6"></view>
          <view class="record-bar bar7"></view>
        </view>
      </view>
    </view>

    <!-- 输入区域 -->
    <view class="input-container">

      <!-- 上方工具栏 -->
      <view class="input-bar">

        <!-- 语音 / 键盘 -->
        <view
          class="circle-tool"
          :class="{ active: voiceMode }"
          @click="toggleVoiceMode"
        >
          <text v-if="!voiceMode" class="tool-icon">⌨</text>
          <text v-else class="tool-icon">🎙</text>
        </view>

        <!-- 文字模式 -->
        <template v-if="!voiceMode">

          <view class="input-wrapper">
            <input
              v-model="draft"
              class="input"
              confirm-type="send"
              :adjust-position="true"
              placeholder="输入消息..."
              placeholder-class="input-placeholder"
              @confirm="sendDraft"
            />
          </view>

          <!-- 发送 -->
          <view
            v-if="draft.trim()"
            class="send-mini"
            @click="sendDraft"
          >
            <text>发送</text>
          </view>

          <!-- 图片 -->
          <view
            v-else
            class="circle-tool"
            @click="chooseImage"
          >
            <text class="tool-icon">＋</text>
          </view>

        </template>

        <!-- 录音模式 -->
        <template v-else>

          <view
            class="record-button"
            :class="{ recording: recording }"
            @touchstart="startRecord"
            @touchend="stopRecord"
            @touchcancel="cancelRecord"
          >
            <text v-if="!recording">按住说话</text>
            <text v-else>松开结束</text>
          </view>

          <view
            class="circle-tool"
            @click="chooseImage"
          >
            <text class="tool-icon">＋</text>
          </view>

        </template>
      </view>

      <!-- 图片快捷入口 -->
      <view
        v-if="showTools"
        class="tools-panel"
      >
        <view class="tool-item" @click="chooseImage">
          <view class="tool-item-icon">🖼</view>
          <text>照片</text>
        </view>

        <view
          class="tool-item"
          @click="toggleVoiceMode"
        >
          <view class="tool-item-icon">🎙</view>
          <text>语音</text>
        </view>
      </view>

    </view>
  </view>
</template>

<script>
import {
  setActiveChat,
  clearActiveChat,
  markRead,
  sendText,
  sendImage,
  sendVoice,
  getMyUserId,
  getLastMessage,
  on,
  off,
} from '../../utils/imStore.js'

import { getMyInfo } from '../../utils/adminRequest.js'

import {
  getPrivateMessageList,
  getGroupMessageList,
  getGroupMemberList,
  recallPrivateMessage,
  recallGroupMessage,
  uploadImage,
  ImContentType,
} from '../../api/im.js'

const keyOf = (type, targetId) => `${type}:${targetId}`

export default {
  data() {
    return {
      type: 1,
      targetId: null,

      name: '',
      avatar: '',

      messages: [],
      draft: '',

      scrollIntoId: '',

      loadingHistory: false,
      historyEnded: false,

      myId: null,
      myAvatar: '',

      memberMap: {},

      defaultAvatar:
        'https://qiniu-web-assets.dcloud.net.cn/unidoc/zh/uni.png',

      _handlers: [],

      // ---------- 输入 ----------
      voiceMode: false,
      showTools: false,

      // ---------- 录音 ----------
      recorderManager: null,
      recording: false,
      recordSeconds: 0,
      recordTimer: null,
      recordStartTime: 0,
      recordCanceled: false,

      // ---------- 播放 ----------
      audioContext: null,
      playingVoiceId: null,
    }
  },

  computed: {
    isGroup() {
      return this.type === 2
    },

    chatKey() {
      return keyOf(this.type, this.targetId)
    },
  },

  onLoad(options) {
    this.type = Number(options.type || 1)
    this.targetId = Number(options.targetId || 0)

    this.name = decodeURIComponent(options.name || '')
    this.avatar = decodeURIComponent(options.avatar || '')

    this.myId = getMyUserId()

    const me = getMyInfo()
    this.myAvatar = (me && me.avatar) || ''

    uni.setNavigationBarTitle({
      title:
        this.name ||
        (this.type === 1 ? '聊天' : '群聊'),
    })

    setActiveChat(this.type, this.targetId)

    // 初始化录音
    this.initRecorder()

    // 初始化播放器
    this.initAudio()

    // WebSocket 新消息
    this._subscribe(
      'new-message',
      ({ key, msg }) => {
        if (key === this.chatKey) {
          this.appendMessage(msg)
        }
      }
    )

    if (this.isGroup) {
      this.fetchMembers()
    }

    this.fetchHistory()

    this.maybeMarkRead()
  },

  onUnload() {
    this._handlers.forEach(([event, cb]) => {
      off(event, cb)
    })

    this._handlers = []

    this.stopRecordTimer()

    if (this.recording && this.recorderManager) {
      try {
        this.recorderManager.stop()
      } catch (e) {}
    }

    if (this.audioContext) {
      try {
        this.audioContext.stop()
        this.audioContext.destroy()
      } catch (e) {}

      this.audioContext = null
    }

    clearActiveChat()
  },

  methods: {
    // =========================================================
    // 基础
    // =========================================================

    _subscribe(event, cb) {
      on(event, cb)
      this._handlers.push([event, cb])
    },

    goBack() {
      uni.navigateBack()
    },

    showChatMenu() {
      uni.showActionSheet({
        itemList: ['清空聊天记录'],
        success: () => {},
      })
    },

    toggleVoiceMode() {
      if (this.recording) return

      this.voiceMode = !this.voiceMode
      this.showTools = false
    },

    // =========================================================
    // 消息解析
    // =========================================================

    parse(msg) {
      let parsed = {}

      try {
        parsed = JSON.parse(msg.content || '{}')
      } catch (e) {
        parsed = {
          content: msg.content || '',
        }
      }

      return parsed
    },

    normalizeDuration(value) {
      const n = Number(value || 0)

      if (!Number.isFinite(n) || n <= 0) {
        return 0
      }

      // 兼容：
      // duration = 5
      // duration = 5000
      if (n > 1000) {
        return Math.max(1, Math.round(n / 1000))
      }

      return Math.max(1, Math.round(n))
    },

    async fetchMembers() {
      try {
        const list = await getGroupMemberList(this.targetId)

        const map = {}

        ;(list || []).forEach((m) => {
          if (m.userId != null) {
            map[m.userId] = {
              nickname: m.nickname,
              avatar: m.avatar,
            }
          }
        })

        this.memberMap = map

        this.refreshSenders()
      } catch (e) {}
    },

    async fetchHistory() {
      if (this.loadingHistory) return

      this.loadingHistory = true

      try {
        const maxId = this.messages.length
          ? this.messages[0].id
          : undefined

        let list

        if (this.isGroup) {
          list = await getGroupMessageList(
            this.targetId,
            maxId,
            30
          )
        } else {
          list = await getPrivateMessageList(
            this.targetId,
            maxId,
            30
          )
        }

        const arr = (list || []).sort(
          (a, b) => a.id - b.id
        )

        if (arr.length < 30) {
          this.historyEnded = true
        }

        const existIds = {}

        this.messages.forEach((m) => {
          existIds[m.id] = true
        })

        const newOnes = arr.filter(
          (m) => !existIds[m.id]
        )

        this.messages = newOnes.concat(
          this.messages
        )

        this.refreshSenders()

        if (!maxId) {
          this.scrollToBottom()
        }
      } catch (e) {
        uni.showToast({
          title: (e && e.msg) || '加载失败',
          icon: 'none',
        })
      } finally {
        this.loadingHistory = false
      }
    },

    loadMore() {
      this.fetchHistory()
    },

    // =========================================================
    // 消息状态
    // =========================================================

    maybeMarkRead() {
      const last = getLastMessage(
        this.type,
        this.targetId
      )

      const maxId = last
        ? last.id
        : this.maxMessageId()

      if (maxId) {
        markRead(
          this.type,
          this.targetId,
          maxId
        )
      }
    },

    maxMessageId() {
      let max = 0

      this.messages.forEach((m) => {
        if (m.id && m.id > max) {
          max = m.id
        }
      })

      return max
    },

    appendMessage(msg) {
      if (!msg) return

      // WS 和发送接口可能重复
      if (
        this.messages.some(
          (m) => m.id === msg.id
        )
      ) {
        return
      }

      this.messages.push(msg)

      this.refreshSenders()

      this.scrollToBottom()

      this.maybeMarkRead()
    },

    refreshSenders() {
      this.messages.forEach((m) => {
        m._mine =
          m.senderId === this.myId

        const c = this.parse(m)

        // -----------------------------
        // 文字
        // -----------------------------
        if (
          m.type ===
          ImContentType.TEXT
        ) {
          m._kind = 'text'
          m._text =
            c.content ||
            c.text ||
            ''
        }

        // -----------------------------
        // 图片
        // -----------------------------
        else if (
          m.type ===
          ImContentType.IMAGE
        ) {
          m._kind = 'image'

          m._imageUrl =
            c.thumbnailUrl ||
            c.url ||
            c.imageUrl ||
            ''
        }

        // -----------------------------
        // 语音
        // -----------------------------
        else if (
          m.type ===
          ImContentType.VOICE
        ) {
          m._kind = 'voice'

          m._voiceUrl =
            c.url ||
            c.audioUrl ||
            c.voiceUrl ||
            ''

          m._duration =
            this.normalizeDuration(
              c.duration ||
              c.durationMs ||
              c.length
            )
        }

        // -----------------------------
        // 其它
        // -----------------------------
        else {
          m._kind = 'other'
        }

        // 头像
        if (m._mine) {
          m._avatar =
            this.myAvatar
        } else if (this.isGroup) {
          m._avatar =
            this.memberMap[m.senderId]
              ? this.memberMap[
                  m.senderId
                ].avatar
              : ''
        } else {
          m._avatar =
            this.avatar
        }

        // 群昵称
        if (
          this.memberMap[m.senderId]
        ) {
          m._senderName =
            this.memberMap[
              m.senderId
            ].nickname
        }
      })
    },

    scrollToBottom() {
      setTimeout(() => {
        const last =
          this.messages[
            this.messages.length - 1
          ]

        this.scrollIntoId = last
          ? 'msg-' + last.id
          : ''
      }, 80)
    },

    // =========================================================
    // 消息类型
    // =========================================================

    isTip(m) {
      const t = m.type

      return (
        t ===
          ImContentType.RECALL ||
        (t >= 1501 &&
          t <= 1533) ||
        (t >= 1201 &&
          t <= 1210)
      )
    },

    renderTip(m) {
      if (
        m.type ===
        ImContentType.RECALL
      ) {
        return m._mine
          ? '你撤回了一条消息'
          : '对方撤回了一条消息'
      }

      const c = this.parse(m)

      if (
        m.type ===
        ImContentType.VOICE
      ) {
        const duration =
          this.normalizeDuration(
            c.duration ||
            c.durationMs
          )

        return duration
          ? `[语音] ${duration}″`
          : '[语音]'
      }

      const typeMap = {
        [ImContentType.IMAGE]:
          '[图片]',
        [ImContentType.VOICE]:
          '[语音]',
        [ImContentType.VIDEO]:
          '[视频]',
        [ImContentType.FILE]:
          '[文件]',
      }

      if (typeMap[m.type]) {
        return typeMap[m.type]
      }

      const map = {
        1501: '创建了群聊',
        1502: '群信息已更新',
        1504: '有人退出了群聊',
        1508: '有新成员加入群聊',
        1509: '有新成员加入群聊',
        1510: '有人退出了群聊',
        1511: '群聊已解散',
        1516: '群成员昵称已更新',
        1517: '设置了群管理员',
        1518: '移除了群管理员',
        1519: '群主已转让',
        1520: '群名已更新',
        1530: '群成员设置已更新',
      }

      return (
        map[m.type] ||
        '系统通知'
      )
    },

    // =========================================================
    // 文字
    // =========================================================

    async sendDraft() {
      const text =
        this.draft.trim()

      if (!text) return

      this.draft = ''

      try {
        await sendText(
          this.type,
          this.targetId,
          text
        )
      } catch (e) {
        this.draft = text

        uni.showToast({
          title:
            (e && e.msg) ||
            '发送失败',
          icon: 'none',
        })
      }
    },

    // =========================================================
    // 图片
    // =========================================================

    chooseImage() {
      this.showTools = false

      uni.chooseImage({
        count: 1,
        sizeType: ['compressed'],
        sourceType: [
          'album',
          'camera',
        ],

        success: async (res) => {
          const filePath =
            res.tempFilePaths[0]

          if (!filePath) return

          uni.showLoading({
            title: '上传中...',
            mask: true,
          })

          try {
            const url =
              await uploadImage(
                filePath
              )

            await sendImage(
              this.type,
              this.targetId,
              url
            )
          } catch (e) {
            uni.showToast({
              title:
                (e && e.msg) ||
                '图片发送失败',
              icon: 'none',
            })
          } finally {
            uni.hideLoading()
          }
        },
      })
    },

    preview(url) {
      if (!url) return

      uni.previewImage({
        urls: [url],
        current: url,
      })
    },

    // =========================================================
    // 录音
    // =========================================================

    initRecorder() {
      try {
        this.recorderManager =
          uni.getRecorderManager()
      } catch (e) {
        this.recorderManager = null
        return
      }

      if (!this.recorderManager) {
        return
      }

      this.recorderManager.onStop(
        (res) => {
          this.handleRecordStop(
            res
          )
        }
      )

      this.recorderManager.onError(
        () => {
          this.recording = false
          this.stopRecordTimer()

          uni.showToast({
            title: '录音失败，请检查麦克风权限',
            icon: 'none',
          })
        }
      )
    },

    startRecord() {
      if (
        this.recording ||
        !this.recorderManager
      ) {
        return
      }

      this.recordCanceled = false
      this.recording = true
      this.recordSeconds = 0
      this.recordStartTime =
        Date.now()

      this.startRecordTimer()

      try {
        this.recorderManager.start({
          duration: 60000,

          sampleRate: 16000,

          numberOfChannels: 1,

          encodeBitRate: 48000,

          format: 'mp3',
        })
      } catch (e) {
        this.recording = false
        this.stopRecordTimer()

        uni.showToast({
          title: '无法开始录音',
          icon: 'none',
        })
      }
    },

    stopRecord() {
      if (!this.recording) {
        return
      }

      this.recording = false
      this.stopRecordTimer()

      if (!this.recorderManager) {
        return
      }

      try {
        this.recorderManager.stop()
      } catch (e) {}
    },

    cancelRecord() {
      if (!this.recording) {
        return
      }

      this.recordCanceled = true
      this.recording = false

      this.stopRecordTimer()

      try {
        this.recorderManager.stop()
      } catch (e) {}
    },

    startRecordTimer() {
      this.stopRecordTimer()

      this.recordTimer =
        setInterval(() => {
          if (!this.recording) {
            return
          }

          this.recordSeconds =
            Math.floor(
              (Date.now() -
                this.recordStartTime) /
                1000
            )

          // 保险限制
          if (
            this.recordSeconds >= 60
          ) {
            this.stopRecord()
          }
        }, 200)
    },

    stopRecordTimer() {
      if (this.recordTimer) {
        clearInterval(
          this.recordTimer
        )

        this.recordTimer = null
      }
    },

    async handleRecordStop(res) {
      const duration =
        res &&
        res.duration
          ? Math.max(
              1,
              Math.round(
                res.duration / 1000
              )
            )
          : Math.max(
              1,
              this.recordSeconds
            )

      if (this.recordCanceled) {
        this.recordCanceled = false
        return
      }

      const filePath =
        res && res.tempFilePath

      if (!filePath) {
        uni.showToast({
          title: '没有获取到录音文件',
          icon: 'none',
        })

        return
      }

      // 防止误触：低于 1 秒不发送
      if (duration < 1) {
        uni.showToast({
          title: '说话时间太短',
          icon: 'none',
        })

        return
      }

      uni.showLoading({
        title: '发送语音...',
        mask: true,
      })

      try {
        /*
         * 当前 api/im.js 中的 uploadImage()
         * 实际调用的是通用文件上传接口：
         *
         * /admin-api/infra/file/upload
         *
         * 所以这里直接复用。
         */
        const url =
          await uploadImage(
            filePath
          )

        if (!url) {
          throw new Error(
            '语音上传失败'
          )
        }

        await sendVoice(
          this.type,
          this.targetId,
          url,
          duration
        )
      } catch (e) {
        uni.showToast({
          title:
            (e && e.msg) ||
            e.message ||
            '语音发送失败',
          icon: 'none',
        })
      } finally {
        uni.hideLoading()
      }
    },

    // =========================================================
    // 语音播放
    // =========================================================

    initAudio() {
      try {
        this.audioContext =
          uni.createInnerAudioContext()
      } catch (e) {
        this.audioContext = null
        return
      }

      if (!this.audioContext) {
        return
      }

      this.audioContext.autoplay =
        false

      this.audioContext.onEnded(() => {
        this.playingVoiceId = null
      })

      this.audioContext.onStop(() => {
        this.playingVoiceId = null
      })

      this.audioContext.onError(() => {
        this.playingVoiceId = null

        uni.showToast({
          title: '语音播放失败',
          icon: 'none',
        })
      })
    },

    playVoice(m) {
      if (
        !m ||
        !m._voiceUrl
      ) {
        uni.showToast({
          title: '语音地址不存在',
          icon: 'none',
        })

        return
      }

      if (!this.audioContext) {
        this.initAudio()
      }

      if (!this.audioContext) {
        return
      }

      // 当前正在播放 -> 暂停
      if (
        this.playingVoiceId ===
        m.id
      ) {
        try {
          this.audioContext.pause()
        } catch (e) {}

        this.playingVoiceId = null

        return
      }

      // 切换其它语音
      try {
        this.audioContext.stop()
      } catch (e) {}

      this.playingVoiceId = m.id

      this.audioContext.src =
        m._voiceUrl

      try {
        this.audioContext.play()
      } catch (e) {
        this.playingVoiceId = null
      }
    },

    voiceWidth(duration) {
      const d =
        Number(duration) || 1

      // 3秒约 190rpx
      // 30秒约 360rpx
      return Math.min(
        380,
        Math.max(
          180,
          180 + d * 7
        )
      )
    },

    // =========================================================
    // 撤回
    // =========================================================

    onLongPress(m) {
      if (
        !m ||
        !m._mine ||
        this.isTip(m)
      ) {
        return
      }

      uni.showModal({
        title: '撤回消息',
        content:
          '确定撤回这条消息吗？',

        success: async (res) => {
          if (!res.confirm) {
            return
          }

          try {
            if (this.isGroup) {
              await recallGroupMessage(
                m.id
              )
            } else {
              await recallPrivateMessage(
                m.id
              )
            }

            this.messages.forEach(
              (x) => {
                if (
                  x.id === m.id
                ) {
                  x.type =
                    ImContentType.RECALL

                  x._type =
                    ImContentType.RECALL
                }
              }
            )

            this.refreshSenders()
          } catch (e) {
            uni.showToast({
              title:
                (e && e.msg) ||
                '撤回失败',
              icon: 'none',
            })
          }
        },
      })
    },
  },
}
</script>

<style>
page {
  background: #f6f7fb;
}

.chat-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: #f6f7fb;
  overflow: hidden;
}

/* =========================================================
   顶部
   ========================================================= */

.top-bar {
  height: 90rpx;
  padding-top: var(--status-bar-height);
  box-sizing: content-box;

  display: flex;
  align-items: center;

  background: rgba(255, 255, 255, 0.96);

  border-bottom: 1rpx solid #eef0f5;

  position: relative;
  z-index: 10;
}

.top-back {
  width: 90rpx;
  height: 90rpx;

  display: flex;
  align-items: center;
  justify-content: center;
}

.back-icon {
  font-size: 64rpx;
  line-height: 1;
  color: #222;
  font-weight: 300;
  transform: translateY(-3rpx);
}

.top-title {
  flex: 1;
  text-align: center;

  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.title {
  color: #1f2430;
  font-size: 34rpx;
  font-weight: 600;
}

.subtitle {
  margin-top: 3rpx;
  color: #a0a5b1;
  font-size: 20rpx;
}

.top-more {
  width: 90rpx;
  height: 90rpx;

  display: flex;
  align-items: center;
  justify-content: center;

  color: #444;
  font-size: 30rpx;
}

/* =========================================================
   消息列表
   ========================================================= */

.msg-scroll {
  flex: 1;
  min-height: 0;
  overflow: hidden;
}

.msg-list {
  padding: 28rpx 26rpx 0;
}

.history-more,
.history-end,
.history-tip {
  display: flex;
  justify-content: center;
  align-items: center;

  height: 64rpx;

  color: #a4a9b4;
  font-size: 22rpx;
}

.history-more {
  color: #7d8491;
}

.loading-dot {
  width: 14rpx;
  height: 14rpx;

  border-radius: 50%;

  background: #b7bdc8;

  margin-right: 10rpx;
}

.msg-wrap {
  margin-bottom: 28rpx;
}

.msg-tip {
  display: flex;
  justify-content: center;
  align-items: center;

  padding: 8rpx 0;

  color: #a5aab5;
  font-size: 21rpx;
}

.msg-row {
  width: 100%;

  display: flex;
  align-items: flex-start;

  box-sizing: border-box;
}

.msg-row.mine {
  justify-content: flex-end;
}

.msg-avatar {
  width: 76rpx;
  height: 76rpx;

  border-radius: 22rpx;

  background: #edf0f5;

  flex-shrink: 0;

  box-shadow: 0 3rpx 12rpx rgba(30, 40, 60, 0.04);
}

.msg-content {
  max-width: 72%;

  margin: 0 16rpx;

  display: flex;
  flex-direction: column;
}

.msg-row.mine .msg-content {
  align-items: flex-end;
}

.msg-name {
  margin: 0 0 8rpx 4rpx;

  color: #9298a5;

  font-size: 21rpx;
}

/* =========================================================
   文字气泡
   ========================================================= */

.bubble {
  max-width: 100%;

  padding: 20rpx 24rpx;

  border-radius: 10rpx 26rpx 26rpx 26rpx;

  background: #ffffff;

  color: #303540;

  font-size: 29rpx;

  line-height: 1.55;

  word-break: break-all;

  box-shadow:
    0 5rpx 20rpx rgba(40, 50, 70, 0.045);
}

.bubble.mine {
  border-radius: 26rpx 10rpx 26rpx 26rpx;

  background: #dbe9ff;

  color: #263a5b;

  box-shadow: none;
}

/* =========================================================
   图片
   ========================================================= */

.image-bubble {
  overflow: hidden;

  border-radius: 20rpx;

  background: #fff;

  box-shadow:
    0 5rpx 20rpx rgba(40, 50, 70, 0.045);
}

.chat-image {
  display: block;

  width: 360rpx;
  height: 360rpx;

  border-radius: 20rpx;
}

/* =========================================================
   语音
   ========================================================= */

.voice-bubble {
  height: 82rpx;

  min-width: 180rpx;
  max-width: 380rpx;

  padding: 0 22rpx;

  box-sizing: border-box;

  display: flex;
  align-items: center;

  border-radius: 24rpx 10rpx 24rpx 24rpx;

  background: #dbe9ff;

  color: #263a5b;

  box-shadow: none;
}

.msg-row:not(.mine) .voice-bubble {
  border-radius: 10rpx 24rpx 24rpx 24rpx;

  background: #ffffff;

  color: #4c5360;

  box-shadow:
    0 5rpx 20rpx rgba(40, 50, 70, 0.045);
}

.voice-duration {
  font-size: 25rpx;
  font-weight: 500;
  white-space: nowrap;
}

.msg-row.mine .voice-duration {
  margin-right: 18rpx;
}

.msg-row:not(.mine) .voice-duration {
  margin-left: 18rpx;
}

.voice-icon {
  width: 30rpx;
  height: 38rpx;

  display: flex;
  align-items: center;
  justify-content: center;

  gap: 4rpx;
}

.wave {
  width: 4rpx;

  border-radius: 4rpx;

  background: currentColor;
}

.wave1 {
  height: 14rpx;
}

.wave2 {
  height: 27rpx;
}

.wave3 {
  height: 19rpx;
}

.voice-icon.playing .wave1 {
  animation: voiceWave 0.7s infinite ease-in-out;
}

.voice-icon.playing .wave2 {
  animation: voiceWave 0.7s infinite 0.12s ease-in-out;
}

.voice-icon.playing .wave3 {
  animation: voiceWave 0.7s infinite 0.24s ease-in-out;
}

@keyframes voiceWave {
  0%,
  100% {
    transform: scaleY(0.55);
  }

  50% {
    transform: scaleY(1.25);
  }
}

/* =========================================================
   底部输入区域
   ========================================================= */

.input-container {
  flex-shrink: 0;

  background: rgba(255, 255, 255, 0.98);

  border-top: 1rpx solid #eef0f5;

  padding-bottom: env(safe-area-inset-bottom);
}

.input-bar {
  min-height: 112rpx;

  padding: 18rpx 22rpx;

  box-sizing: border-box;

  display: flex;
  align-items: center;
}

.circle-tool {
  width: 68rpx;
  height: 68rpx;

  border-radius: 50%;

  background: #f2f4f8;

  display: flex;
  align-items: center;
  justify-content: center;

  flex-shrink: 0;

  transition: all 0.2s;
}

.circle-tool.active {
  background: #e3edff;
}

.tool-icon {
  color: #687180;
  font-size: 34rpx;
}

.input-wrapper {
  flex: 1;

  height: 72rpx;

  margin: 0 14rpx;

  background: #f4f5f8;

  border-radius: 36rpx;

  display: flex;
  align-items: center;
}

.input {
  width: 100%;
  height: 72rpx;

  padding: 0 28rpx;

  box-sizing: border-box;

  color: #303540;

  font-size: 28rpx;

  background: transparent;
}

.input-placeholder {
  color: #b3b8c2;
}

.send-mini {
  height: 68rpx;

  padding: 0 24rpx;

  margin-left: 6rpx;

  border-radius: 34rpx;

  display: flex;
  align-items: center;
  justify-content: center;

  background: #397cf6;

  color: #fff;

  font-size: 24rpx;
}

.record-button {
  flex: 1;

  height: 72rpx;

  margin: 0 14rpx;

  border-radius: 36rpx;

  background: #f2f4f8;

  display: flex;
  align-items: center;
  justify-content: center;

  color: #646c79;

  font-size: 27rpx;
}

.record-button.recording {
  background: #dbe8ff;
  color: #397cf6;
}

/* =========================================================
   工具面板
   ========================================================= */

.tools-panel {
  display: flex;

  padding: 20rpx 28rpx 28rpx;

  border-top: 1rpx solid #f0f1f5;

  background: #fff;
}

.tool-item {
  width: 130rpx;

  display: flex;
  flex-direction: column;
  align-items: center;

  color: #717784;

  font-size: 22rpx;
}

.tool-item-icon {
  width: 82rpx;
  height: 82rpx;

  margin-bottom: 10rpx;

  border-radius: 24rpx;

  background: #f3f5f9;

  display: flex;
  align-items: center;
  justify-content: center;

  font-size: 38rpx;
}

/* =========================================================
   录音遮罩
   ========================================================= */

.record-mask {
  position: fixed;

  left: 0;
  right: 0;
  top: 0;
  bottom: 0;

  z-index: 999;

  display: flex;
  align-items: center;
  justify-content: center;

  background: rgba(15, 20, 30, 0.36);
}

.record-panel {
  width: 430rpx;
  height: 430rpx;

  border-radius: 42rpx;

  background: rgba(255, 255, 255, 0.97);

  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;

  box-shadow:
    0 20rpx 80rpx rgba(0, 0, 0, 0.18);
}

.record-animation {
  margin-bottom: 24rpx;
}

.record-circle {
  width: 132rpx;
  height: 132rpx;

  border-radius: 50%;

  background: #397cf6;

  display: flex;
  align-items: center;
  justify-content: center;

  box-shadow:
    0 0 0 20rpx rgba(57, 124, 246, 0.08);

  animation: recordPulse 1.4s infinite ease-in-out;
}

.record-mic {
  font-size: 54rpx;
}

@keyframes recordPulse {
  0% {
    transform: scale(0.94);
  }

  50% {
    transform: scale(1.04);
  }

  100% {
    transform: scale(0.94);
  }
}

.record-title {
  color: #20242d;

  font-size: 38rpx;
  font-weight: 600;
}

.record-tip {
  margin-top: 10rpx;

  color: #9ba1ac;

  font-size: 24rpx;
}

.record-wave {
  height: 46rpx;

  margin-top: 28rpx;

  display: flex;
  align-items: center;

  gap: 8rpx;
}

.record-bar {
  width: 5rpx;

  border-radius: 5rpx;

  background: #397cf6;

  animation: recordWave 0.8s infinite ease-in-out;
}

.bar1 {
  height: 18rpx;
}

.bar2 {
  height: 32rpx;
  animation-delay: 0.1s;
}

.bar3 {
  height: 44rpx;
  animation-delay: 0.2s;
}

.bar4 {
  height: 28rpx;
  animation-delay: 0.3s;
}

.bar5 {
  height: 40rpx;
  animation-delay: 0.4s;
}

.bar6 {
  height: 24rpx;
  animation-delay: 0.5s;
}

.bar7 {
  height: 35rpx;
  animation-delay: 0.6s;
}

@keyframes recordWave {
  0%,
  100% {
    transform: scaleY(0.65);
  }

  50% {
    transform: scaleY(1.1);
  }
}

.bottom-space {
  height: 20rpx;
}
</style>