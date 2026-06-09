/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * 动效名称，用于统一管理
 *
 * @since 2024-08-02
 */
export enum AnimationNames {
  /**
   * 一键清除动效
   */
  NTF_CLEAR_ALL_ANIMATION = 'NtfClearAllAnimation',

  /**
   * 通知卡片启动应用一镜到底动效
   */
  NTF_OVERLAY_ANIMATION = 'NtfOverlayAnimation',

  /**
   * 流量数据出现消失动效
   */
  NTF_DATA_PLAN_ANIMATION = 'NtfDataPlanAnimation',

  /**
   * 通知中心面板头部动效
   */
  NTF_HEADER_ANIMATION = 'NtfHeaderAnimation',

  /**
   * 通知中心面板头部动效
   */
  NTF_GROUP_EXPANDED_ANIMATION = 'NtfGroupExpandedAnimation',

  /**
   * 更多通知折叠展开动效
   */
  MORE_NTF_COLLAPSED_ANIMATION = 'MoreNtfCollapsedAnimation',

  /**
   * 更多通知折叠展开动效
   */
  NTF_ACTION_BUTTON_ANIMATION = 'NtfActionButtonAnimation',

  /**
   * 删除链式补位动效
   */
  NTF_DELETE_CHAIN_ANIMATION = 'NtfDeleteChainAnimation',

  /**
   * 通知列表动效
   */
  NTF_LIST_ANIMATION = 'NtfListAnimation',

  /**
   * 通知设置弹窗动效
   */
  NTF_DIALOG_ANIMATION = 'NtfDialogAnimation',

  /**
   * 子通知数量变化动效
   */
  NTF_GROUP_CHILDREN_UPDATE_ANIMATION = 'NtfGroupChildrenUpdateAnimation',

  /**
   * 通知按钮动效
   */
  NTF_MENU_ANIMATION = 'NtfMenuAnimation',

  /**
   * 通知卡片左右滑动动效
   */
  NTF_CARD_SWIPE_ANIMATION = 'NtfCardSwipeAnimation',

  /**
   * 展开沉浸态卡片
   */
  NTF_EXPAND_IMMERSIVE = 'NtfExpandImmersive',

  /**
   * 通知卡片大小变化动效
   */
  NTF_ITEM_SIZE_CHANGE_ANIMATION = 'NtfItemSizeChangeAnimation',

  /**
   * 三方实况卡片辅助区淡入动效
   */
  OTHER_CARD_EXTEND_ANIMATION = 'OtherCardExtendAnimation',

  /**
   * 三方进度类实况平移动效
   */
  PROGRESS_CARD_ANIMATION = 'ProgressCardAnimation',

  /**
   * 胶囊的出现消失动效
   */
  LIVE_CAPSULE_ANIMATION = 'LiveCapsuleAnimation',

  /**
   * 实况卡片菜单动画
   */
  LIVE_CARD_MENU_ANIMATION = 'LiveCardMenuAnimation',

  /**
   * 实况卡片列表动画
   */
  LIVE_CARD_LIST_ANIMATION = 'LiveCardListAnimation',

  /**
   * 实况横幅通用动画
   */
  LIVE_HEADS_UP_COMMON_CARD_ANIMATION = 'LiveHeadsUpCommonCardAnimation',

  /**
   * 钱包实况横幅动画
   */
  LIVE_HEADS_UP_WALLET_ANIMATION = 'LiveHeadsUpWalletAnimation',

  /**
   * 人脸解锁动画
   */
  LIVE_HEADS_UP_FACE_LOCK_ANIMATION = 'LiveHeadsUpFaceLockAnimation',

  /**
   * 实况卡片列表项动画
   */
  LIVE_CARD_LIST_ITEM_ANIMATION = 'LiveCardListItemAnimation',

  /**
   * 实况卡片更新动画
   */
  LIVE_CARD_UPDATE_ANIMATION = 'LiveCardUpdateAnimation',

  /**
   * 实况卡片新增动效
   */
  LIVE_CARD_ADD_ANIMATION = 'LiveCardAddAnimation',

  /**
   * 横幅下拉悬浮窗蒙版消失动效
   */
  BANNER_MASK_DISAPPEAR_ANIMATION = 'BannerMaskDisappearAnimation',

  /**
   * 横幅下拉悬浮窗蒙版中心图标缩放动效
   */
  BANNER_MASK_ICON_SCALE_ANIMATION = 'BannerMaskIconScaleAnimation',

  /**
   * 拉起应用一镜到底动效
   */
  START_APP_ONE_MIRROR = 'StartAppOneMirror',

  /**
   * 应用上滑退出到胶囊动效
   */
  SWIPE_APP_TO_CAPSULE = 'SwipeAppToCapsule',

  /**
   * 下拉面板时通知item依次出现动效
   */
  NTF_ITEM_APPEAR_ANIMATION = 'NtfItemAppearAnimation',

  /**
   * 状态栏时间动效
   */
  STATUSBAR_CLOCK_ICON_ANIMATION = 'StatusBarClockIconAnimation',

  /**
   * 状态栏动效移动模糊动效
   */
  STATUSBAR_MOVE_BLUR_ANIMATION = 'StatusBarMoveAndBlurAnimation',
  /**
   * 状态栏缩放动效
   */
  STATUSBAR_SCALE_ANIMATION = 'StatusBarScaleAnimation',

  /**
   * 状态栏图标动效
   */
  STATUSBAR_ICON_ANIMATION = 'StatusBarIconAnimation',

  /**
   * 状态栏图标透明度动效
   */
  STATUSBAR_ICON_OPACITY_ANIMATION = 'StatusBarIconOpacityAnimation',
  /**
   * 状态栏平移动效,XT设备使用
   */
  STATUSBAR_ICON_TRANSLATE_ANIMATION = 'StatusBarIconTranslateAnimation',

  /**
   * 胶囊列表动效
   */
  CAPSULE_LIST_ANIMATION = 'CAPSULE_LIST_ANIMATION',
  /**
   * 胶囊收起列表动效
   */
  CAPSULE_LIST_COLLAPSE_ANIMATION = 'CAPSULE_LIST_COLLAPSE_ANIMATION',
  /**
   * 胶囊展开列表动效
   */
  CAPSULE_LIST_EXPAND_ANIMATION = 'CAPSULE_LIST_EXPAND_ANIMATION',
  /**
   * 点击胶囊展开为应用动效
   */
  CAPSULE_CLICK_TO_APP_ANIMATION = 'CAPSULE_CLICK_TO_APP_ANIMATION',

  /**
   * 胶囊过渡动效
   */
  CAPSULE_LIST_TRANS_ANIMATION = 'CAPSULE_LIST_TRANS_ANIMATION',

  /**
   * 横屏胶囊收起列表动效
   */
  CAPSULE_LIST_COLLAPSE_ANIMATION_WITHOUT_HOLE = 'CAPSULE_LIST_COLLAPSE_ANIMATION_WITHOUT_HOLE',
  /**
   * 横屏胶囊展开列表动效
   */
  CAPSULE_LIST_EXPAND_ANIMATION_WITHOUT_HOLE = 'CAPSULE_LIST_EXPAND_ANIMATION_WITHOUT_HOLE',

  /**
   * 横屏胶囊过渡动效
   */
  CAPSULE_LIST_TRANS_ANIMATION_WITHOUT_HOLE = 'CAPSULE_LIST_TRANS_ANIMATION_WITHOUT_HOLE',

  /**
   * 融球透明度显隐动效
   */
  META_BALL_ANIMATION = 'META_BALL_OPACITY_ANIMATION',

  /**
   * 横屏胶囊动效
   */
  CAPSULE_LIST_WITHOUT_HOLE_ANIMATION = 'CAPSULE_LIST_WITHOUT_HOLE_ANIMATION',

  /**
   * 胶囊宽度偏移变化动效
   */
  CAPSULE_LIST_WIDTH_OFFSET_CHANGE_ANIMATION = 'CAPSULE_LIST_WIDTH_OFFSET_CHANGE_ANIMATION',

  /**
   * 胶囊文本显示动效
   */
  CAPSULE_LIST_TEXT_SHOW_ANIMATION = 'CAPSULE_LIST_TEXT_SHOW_ANIMATION',

  /**
   * 胶囊文本隐藏动效
   */
  CAPSULE_LIST_TEXT_HIDE_ANIMATION = 'CAPSULE_LIST_TEXT_HIDE_ANIMATION',

  /**
   * 进度胶囊扫光动效
   */
  PROGRESS_CAPSULE_WAVE_ANIMATION = 'PROGRESS_CAPSULE_WAVE_ANIMATION',

  /**
   * 播控实况动效
   */
  LIVE_MEDIA_PLAYER_ANIMATION = 'LIVE_MEDIA_PLAYER_ANIMATION',
  /**
   * 横幅滑动动画
   */
  LIVE_HEAD_UP_SWIPE_ANIMATION = 'LiveHeadUpSwipeAnimation',
  /**
   * 阴影胶囊颜色过渡动画
   */
  LIVE_SHADOW_CAPSULE_ANIMATION = 'LiveShadowCapsuleAnimation',
  /**
   * 胶囊边框扫光动画
   */
  LIVE_CAPSULE_LIGHT_ANIMATION = 'LiveCapsuleLightBorderAnimation',
  /**
   * 悬浮窗蒙层动效
   */
  FLOATING_LAYER_ANIMATION = 'FloatingLayerAnimation',
  /**
   * 融球组件位移动画
   */
  METABALL_TRANS_ANIMATION = 'METABALL_UPWARDS_ANIMATION',
  /**
   * 系统卡片按钮置灰动效
   */
  LIVE_SYS_CARD_BTN_ANIMATION = 'LiveSysCardBtnAnimation',
  /**
   * 卡片进入沉浸态动画
   */
  LIVE_ENTER_IMMERSIVE_ANIMATION = 'LiveEnterImmersiveAnimation',
  /**
   * 卡片退出沉浸态动画
   */
  LIVE_EXIT_IMMERSIVE_ANIMATION = 'LiveExitImmersiveAnimation',

  WALLET_SWIPE_ENTER_ANIMATION = 'WALLET_SWIPE_ENTER_ANIMATION',

  WALLET_SWIPE_ENTER_ROTATION_ANIMATION = 'WALLET_SWIPE_ENTER_ROTATION_ANIMATION',

  WALLET_SWIPE_ENTER_ANGLE_FIXED_ANIMATION = 'WALLET_SWIPE_ENTER_ANGLE_FIXED_ANIMATION',

  WALLET_SWIPE_ENTER_REFRESH_IMAGE_ANIMATION = 'WALLET_SWIPE_ENTER_REFRESH_IMAGE_ANIMATION',

  WALLET_SWIPE_EXIT_SUCCESS_START_ANIMATION = 'WALLET_SWIPE_EXIT_SUCCESS_START_ANIMATION',

  WALLET_SWIPE_EXIT_SUCCESS_END_ANIMATION = 'WALLET_SWIPE_EXIT_SUCCESS_END_ANIMATION',

  WALLET_SWIPE_EXIT_SUCCESS_END_PHASE_ANIMATION = 'WALLET_SWIPE_EXIT_SUCCESS_END_PHASE_ANIMATION',

  WALLET_SWIPE_EXIT_FAIL_END_ANIMATION = 'WALLET_SWIPE_EXIT_FAIL_END_ANIMATION',

  WALLET_SWIPE_EXIT_FAIL_END_PHASE_ANIMATION = 'WALLET_SWIPE_EXIT_FAIL_END_PHASE_ANIMATION',

  WALLET_SWIPE_EXIT_FAIL_START_ANIMATION = 'WALLET_SWIPE_EXIT_FAIL_START_ANIMATION',

  WALLET_SWIPE_EXIT_NO_FEEDBACK_END_ANIMATION = 'WALLET_SWIPE_EXIT_NO_FEEDBACK_END_ANIMATION',
  /**
   * 悬浮球出现动效
   */
  FLOATING_BALL_SHOW_ANIMATION = 'FloatingBallShowAnimation',
  /**
   * 悬浮球添加动效
   */
  FLOATING_BALL_ADD_ANIMATION = 'FloatingBallAddAnimation',
  /**
   * 悬浮球更新动效
   */
  FLOATING_BALL_UPDATE_ANIMATION = 'FloatingBallUpdateAnimation',
  /**
   * 悬浮球删除动效
   */
  FLOATING_BALL_REMOVE_ANIMATION = 'FloatingBallRemoveAnimation',
  /**
   * 悬浮球挤占动效
   */
  FLOATING_BALL_SQUEEZE_ANIMATION = 'FloatingBallSqueezeAnimation',
  /**
   * 悬浮球全部清除动效
   */
  FLOATING_BALL_CLEAR_ANIMATION = 'FloatingBallClearAnimation',
  /**
   * 悬浮球面板缩放动效
   */
  FLOATING_BALL_PANEL_SCALE_ANIMATION = 'FloatingBallPanelScaleAnimation',
  /**
   * 悬浮球面板大小变化动效
   */
  FLOATING_BALL_PANEL_SIZE_CHANGE_ANIMATION = 'FloatingBallPanelSizeChangeAnimation',
  /**
   * 悬浮球长按动效，蒙版出现，原组件显隐
   */
  FLOATING_BALL_LONG_PRESS_ANIMATION = 'FloatingBallLongPressAnimation',
  /**
   * 悬浮球恢复默认位置动效
   */
  FLOATING_BALL_DEFAULT_POSITION_ANIMATION = 'FloatingBallDefaultPositionAnimation',
}