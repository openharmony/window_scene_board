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
 * 视效特性相关常量
 *
 * @since 2024-11-28
 */
export class VisualEffectConstants {
  /**
   * 领域视效档位-低
   */
  static readonly DOMAIN_EFFECT_LEVEL_LOW: string = 'low';

  /**
   * 通知模糊效果禁用
   */
  static readonly NTF_BLUR_EFFECT_DISABLE: string = 'notification_blur_effect_disable';

  /**
   * 通知阴影效果禁用
   */
  static readonly NTF_SHADOW_DISABLE: string = 'notification_shadow_disable';

  /**
   * 通知提亮压暗禁用
   */
  static readonly NTF_BRIGHTENS_DISABLE: string = 'notification_brightens_disable';

  /**
   * 通知混合集中提亮
   */
  static readonly NTF_BRIGHTENS_CENTRALIZED: string = 'notification_brightens_centralized';

  /**
   * 控制中心提亮压暗禁用
   */
  static readonly CC_BRIGHTNESS_DISABLE: string = 'control_center_brightness_disable';

  /**
   * 控制中心纯色模式启用
   */
  static readonly CC_SOLID_COLOR_ENABLE: string = 'control_center_solid_color_enable';

  /**
   * 控制中心纯色模式使用固定颜色
   */
  static readonly CC_SOLID_COLOR_USE_FIXED_COLOR: string = 'control_center_solid_color_use_fixed_color';

  /**
   * 通知沉浸态提亮压暗禁用
   */
  static readonly IMMERSIVE_CARD_BRIGHTNESS_DISABLE: string = 'immersive_card_brightness_disable';

  /**
   * 控制中心边缘像素扩展禁用
   */
  static readonly CC_PIXEL_STRETCH_EFFECT_DISABLE: string = 'control_center_pixel_stretch_effect_disable';

  /**
   * 控制中心顶部模糊效果禁用
   */
  static readonly CC_HEAD_BLUR_EFFECT_DISABLE: string = 'control_center_head_blur_effect_disable';

  /**
   * 下拉控制中心面板可旋转
   */
  static readonly CC_DROPDOWN_PANEL_ROTATION_ABLE: string = 'dropdown_panel_rotation_able';

  /**
   * 下拉双中心强制关闭HDR
   */
  static readonly CC_DROPDOWN_PANEL_FORCE_CLOSE_HDR_ENABLE: string = 'dropdown_panel_force_close_hdr_enable';

  /**
   * 控制中心实时模糊策略，属性定义与CCM配置参数保持一致
   */
  static readonly CC_ANIMATION_BLUR_POLICY: string = 'const.sceneboard.control_center.animation_blur_policy';

  /**
   * 控制中心低温实时模糊时长，属性定义与CCM配置参数保持一致
   */
  static readonly CC_ANIMATION_BLUR_STOP_TIME_NORMAL: string = 'const.sceneboard.control_center.animation_blur_stop_time_normal';

  /**
   * 控制中心高温实时模糊时长，属性定义与CCM配置参数保持一致
   */
  static readonly CC_ANIMATION_BLUR_STOP_TIME_ABNORMAL: string = 'const.sceneboard.control_center.animation_blur_stop_time_abnormal';

  /**
   * 控制中心取消实时模糊效果温度档位阈值，属性定义与CCM配置参数保持一致
   */
  static readonly CC_ANIMATION_BLUR_CANCEL_THERMAL_LEVEL: string = 'const.sceneboard.control_center.animation_blur_cancel_thermal_level';

  /**
   * 应用启动退出模糊效果禁用
   */
  static readonly ICON_START_EXIT_BLUR_DISABLE: string = 'icon_start_exit_blur_disable';

  /**
  * 启动退出模糊效果
  */
  static readonly  ICON_START_EXIT_BLUR_EFFECT: string = 'icon_start_exit_blur_effect';

  /**
   * 启动退出动效模糊等级
   */
  static readonly ICON_START_EXIT_MOTION_BLUR_LEVEL: string = 'icon_start_exit_motion_blur_level';

  /**
   * 图标卡片阴影禁用
   */
  static readonly ICON_CARD_SHADOW_DISABLE: string = 'icon_card_shadow_disable';

  /**
   * 多任务/快切桌面模糊禁用，用壁纸模糊代替
   */
  static readonly IS_RECENT_BLUR_DISABLED: string = 'recent_blur_disabled';

  /**
   * 多任务/快切壁纸模糊效果
   */
  static readonly IS_RECENT_BLUR_EFFECT: string = 'isRecentBlurEffect';

  /**
   * 进入多任务额外预创建卡片数量
   */
  static readonly RECENT_BUILD_COUNT_BEFORE_SCROLL: string = 'const.recent.build_count_before_scroll';

  /**
   * 负一屏模糊禁用，用壁纸模糊代替
   */
  static readonly IS_NEGATIVESCREEN_BLUR_DISABLED: string = 'negativescreen_blur_disabled';

  /**
   * 负一屏壁纸模糊效果
   */
  static readonly IS_NEGATIVESCREEN_EFFECT: string = 'isNegativeScreenEffect';

  /**
   * 全搜模式壁纸模糊效果禁用
   */
  static readonly GLOBAL_SEARCH_BLUR_EFFECT_DISABLE: string = 'global_search_blur_effect_disable';

  /**
   * 全搜模式壁纸模糊效果
   */
  static readonly GLOBAL_SEARCH_BLUR_EFFECT: string = 'globalSearchBlurEffect';

  /**
   * 文件夹背景模糊效果禁用
   */
  static readonly FOLDER_BLUR_EFFECT_DISABLE: string = 'folder_blur_effect_disable';

  /**
   * 文件夹壁纸模糊效果
   */
  static readonly FOLDER_BLUR_EFFECT: string = 'folderBlurEffect';

  /**
   * 导航条应用内模糊反色禁用
   */
  static readonly NAVIBAR_BLUR_INVERT_EFFECT_DISABLE: string = 'navibar_blur_invert_effect_disable';

  /**
   * 文件夹秩序感禁用
   */
  static readonly FOLDER_SENSE_OF_ORDER_DISABLE: string = 'folder_sense_of_order_disable';

  /**
   * 桌面滑动效果定制，优化该场景下功耗
   */
  static readonly LAUNCHER_SWIPER_CUSTOM_ENABLED: string = 'launcher_swiper_custom_enabled';

  /**
   * 运动模糊效果禁用
   */
  static readonly MOTION_BLUR_DISABLE: string = 'motion_blur_disable';
  /**
   * 文件夹纯色模式
   */
  static readonly FOLDER_SOLID_COLOR_DISABLE: string = 'folder_solid_color_disable';

  /**
   * 多任务前景模糊动效禁用
   */
  static readonly FOREGROUND_BLUR_DISABLE: string = 'foreground_blur_disable';

  /**
  * 锁屏主页面模糊禁用
  */
  static readonly SCREEN_LOCK_EFFECT_DISABLE: string = 'screen_lock_effect_disable';

  /**
   * 锁屏上划进入密码页跟手模糊禁用
   */
  static readonly SCREEN_LOCK_BOUNCER_ONE_FRAME_BLUR: string = 'screen_lock_bouncer_one_frame_blur';

  /**
   * 锁屏主页面元素提亮禁用
   */
  static readonly SCREEN_LOCK_BRIGHT_DISABLE: string = 'screen_lock_bright_disable';

  /**
   * 锁屏解锁HDR开关
   */
  static readonly SCREEN_LOCK_HDR_ENABLE: string = 'screen_lock_hdr_enable';

  /**
   * 锁屏主页面元素纯色开启
   */
  static readonly SCREEN_LOCK_SOLID_ENABLE: string = 'screen_lock_solid_enable';

  /**
   * 锁屏快捷工具背板模糊半径
   */
  static readonly SCREEN_LOCK_QUICK_TOOL_BACKGROUND_BLUR_RADIUS: string = 'screen_lock_quick_tool_background_blur_radius';

  /**
   * 是否开启时钟一镜到底动画
   */
  static readonly SCREEN_CLOCK_ONE_SHOT_ANIM_ENABLE: string = 'screen_clock_one_shot_anim_enable';

  /**
   * dock模糊禁用
   */
  static readonly DOCK_BLUR_DISABLE: string = 'dock_blur_disable';

  /**
   * 卡片视效级别
   */
  static readonly CARD_VISUAL_EFFECT_LEVEL: string = 'card_visual_effect_level';

  /**
   * 退分屏背景模糊
   */
  static readonly SPLIT_EXIT_BACKGROUND_BLUR_EFFECT_DISABLE: string = 'split_exit_background_blur_effect_disable';

  /**
   * 退分屏加于应用上的模糊
   */
  static readonly SPLIT_EXIT_APP_BLUR_EFFECT_DISABLE: string = 'split_exit_app_blur_effect_disable';

  /**
   * 悬浮窗最大化实时模糊
   */
  static readonly FLOAT_MAXIMIZE_BLUR_EFFECT_DISABLE: string = 'float_maximize_blur_effect_disable';

  /**
   * 待分屏拖拽、点击放大加于应用上的模糊
   */
  static readonly ONE_STEP_EXIT_APP_BLUR_EFFECT_DISABLE: string = 'one_step_exit_app_blur_effect_disable';

  /**
   * 分屏拖拽过程中加于应用上的模糊
   */
  static readonly SPLIT_DRAGGING_APP_BLUR_EFFECT_DISABLE: string = 'split_dragging_app_blur_effect_disable';

  /**
   * 运动模糊最高生效帧率
   */
  static readonly HIGHEST_MOTION_BLUR_ENABLE: string = 'highest_motion_blur_enable';

  /**
   * 熄屏风格编辑视效级别
   */
  static readonly AOD_VISUAL_EFFECT_LEVEL: string = 'aod_visual_effect_level';

  /**
   * 手势场景强制关闭HDR
   */
  static readonly GESTURE_FORCE_CLOSE_HDR_ENABLE: string = 'gesture_force_close_hdr_enable';

  /**
   * 优先预加载相机
   */
  static readonly PRIORITY_PRELAUNCH_CAMERA_ENABLE: string = 'priority_prelaunch_camera_enable';

  /**
   * 限制启动帧率90fps
   */
  static readonly RESTRICT_FRAME_RATE_MIDDLE: string = 'restrict_frame_rate_middle';
}

export class BlurEffect {
  isRecentBlurEffect: boolean = false;
  isNegativeScreenEffect: boolean = false;
  isFolderBlurEffect: boolean = false;
  isEditModeFolderEffect: boolean = false;
  isGlobalSearchEffect: boolean = false;
  isStartExitBlurEffect: boolean = false;
}

export enum BlurEffectType {
  RECENT = 'recentEffect',
  NEGATIVE_SCREEN = 'negativeScreenEffect',
  FOLDER = 'foldEffect',
  EDIT_MODE_FOLDER = 'editModeFolderEffect',
  GLOBAL_SEARCH = 'globalSearchEffect',
  ICON_START_EXIT = 'iconStartExit',
}

export enum StartExitMotionLevel {
  NORMAL_BLUR = '1',
  WALLPAPER_BLUR = '2',
  REMOVE_BLUR = '3',
}