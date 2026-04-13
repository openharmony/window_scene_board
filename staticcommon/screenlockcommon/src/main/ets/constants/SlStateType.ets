/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
 * 锁屏页面主状态类型
 */
export enum SlMainStateType {
  SL_STATIC_STATE = 'sl_static_state', // 锁屏静态变量状态
  SL_BIND_STATE = 'sl_bind_state', // 锁屏UI绑定变量状态
  CLOCK_ANIM_STATE = 'clock_anim_state', // 锁屏时钟组件动效状态
  SL_QT_WG_STATIC_STATE = 'sl_quick_tools_icon_widget_static_state', // 锁屏快捷工具图标静态状态
  SL_CAP_WG_STATIC_STATE = 'sl_capsule_widget_static_state', // 锁屏沉浸胶囊静态状态
  SL_CAMERA_WG_STATIC_STATE = 'sl_camera_icon_widget_static_state', // 锁屏相机图标静态状态
  SL_LIST_WG_BIND_STATE = 'sl_list_widget_bind_state', // 锁屏通知列表组件UI绑定变量状态
  SL_LOCK_ICON_WG_BIND_STATE = 'sl_lock_icon_widget_bind_state', // 锁屏锁头组件UI绑定变量状态
  SL_LOCK_GREET_WG_STATIC_STATE = 'sl_lock_greet_widget_static_state', //
  SL_LOCK_GREET_WG_BIND_STATE = 'sl_lock_greet_widget_bind_state', //
  SL_LOCK_ICON_WG_STATIC_STATE = 'sl_lock_icon_widget_static_state', // 锁屏锁头静态状态
  SL_CLOCK_WG_BIND_STATE = 'sl_clock_widget_bind_state', // 锁屏时钟组件UI绑定变量状态
  SL_CLOCK_WG_STATIC_STATE = 'sl_clock_widget_static_state', // 锁屏时钟组件静态状态
  SL_OUTER_FORM_WG_BIND_STATE = 'sl_outer_form_widget_bind_state', // 锁屏小外屏服务卡片组件UI绑定变量状态
  SL_OUTER_FORM_WG_STATIC_STATE = 'sl_outer_form_widget_static_state', //锁屏小外屏服务卡片组件静态状态
  SL_OUTER_TOOL_WG_BIND_STATE = 'sl_outer_tool_widget_bind_state', // 锁屏小外屏底部工具组件UI绑定变量状态
  SL_OUTER_TOOL_WG_STATIC_STATE = 'sl_outer_tool_widget_static_state', // 锁屏小外屏底部工具组件静态状态
  SL_SIGN_WG_BIND_STATE = 'sl_sign_widget_bind_state', // 锁屏签名组件UI绑定变量状态
  SL_SIGN_WG_STATIC_STATE = 'sl_sign_widget_static_state', // 锁屏签名静态状态
  SL_CARD_WG_STATIC_STATE = 'sl_card_widget_static_state', // 锁屏沉浸卡片静态状态
  SL_LIST_WG_STATIC_STATE = 'sl_list_widget_static_state', // 锁屏通知列表组件静态状态
  SL_CARD_WG_BIND_STATE = 'sl_card_widget_bind_state', // 锁屏沉浸卡片组件UI绑定变量状态
  SL_CAP_WG_BIND_STATE = 'sl_capsule_widget_bind_state', // 锁屏沉浸胶囊组件UI绑定变量状态
  SL_DOF_WALLPAPER_BIND_STATE = 'sl_dof_wallpaper_bind_state', // 锁屏景深壁纸UI绑定变量状态
  SL_DOF_WALLPAPER_STATIC_STATE = 'sl_dof_wallpaper_static_state', // 锁屏景深壁纸静态状态
  SL_FORM_WG_STATIC_STATE = 'sl_form_widget_static_state', // 锁屏服务卡片组件静态变量状态
  SL_FORM_WG_BIND_STATE = 'sl_form_widget_bind_state', // 锁屏服务卡片组件静态变量状态
  SL_OUT_CARD_WG_BIND_STATE = 'sl_out_card_widget_bind_state', // 锁屏外屏沉浸卡片组件UI绑定状态
  SL_FINGERPRINT_WG_BIND_STATE = 'sl_fingerprint_main_page_widget_bind_state', // 锁屏首页指纹组件UI绑定变量状态
  SL_FINGERPRINT_WG_STATIC_STATE = 'sl_fingerprint_widget_static_state', // 锁屏指纹组件静态变量状态
  SL_ONE_MIRROR_STATIC_STATE = 'sl_one_mirror_static_state', // 锁屏一镜到底服务静态变量状态
  SL_EDIT_STATIC_STATE = 'sl_edit_static_state', // 锁屏编辑界面静态变量状态,
  SL_EDIT_BIND_STATE = 'sl_edit_bind_state', // 锁屏编辑界面UI绑定变量状态,
  SL_CLOCK_EDIT_BIND_STATE = 'sl_clock_edit_bind_state', // 锁屏时钟编辑界面UI绑定变量状态,
  SL_CLOCK_MODE_STATE = 'sl_clock_mode_state', // 锁屏时钟原数据
  SL_FOLDABLE_PSD_STATIC_STATE = 'sl_foldable_psd_static_state', // 锁屏密码面板静态变量状态
  SL_ART_LAYOUT_STATE = 'sl_ART_LAYOUT_state', // 锁屏编辑艺术签名样式编辑UI绑定状态
  SL_ART_SIGN_BIND_DATA = 'sl_art_sign_bind_data', // 艺术签名绑定数据
}

/**
 * 子状态类型，锁屏静态变量状态类型
 */
export enum SlStaticStateType {
  PORTRAIT_STATE = 'portrait_state', // 屏幕竖屏状态
  FOLDABLE_STATE = 'foldable_state', // 设备可折叠状态
  FOLD_EXPAND_STATE = 'fold_expand_state', // 可折叠设备展开状态
  SCREEN_BP = 'screen_width_height_break_point', // 屏幕宽高断点状态
  SL_SIZE_STATE = 'screen_size_state', // 锁屏面板大小状态
  SL_MAX_GRID_STATE = 'max_grid_amount_state', // 锁屏面板时钟最大可用栅格数状态
  SL_GRID_UNIT_STATE = 'grid_unit_size_state', // 锁屏面板栅格单位大小状态
  SL_GRID_MARGIN_STATE = 'grid_start_margin_state', // 锁屏面板起始栅格间距状态
  CLOCK_COLLAPSE_SHOW_REGION = 'clock_collapse_show_region', // 锁屏时钟折叠态显示范围
  CLOCK_NO_SIGN_SHOW_REGION = 'clock_no_sign_show_region', // 锁屏时钟折叠态无签名显示范围
  MESH_CONFIG = 'mesh_config', // 锁屏网格配置
  CLOCK_EXPAND_MESH_Y = 'clock_expand_mesh_y', // 锁屏时钟y轴网格展开态值
  SL_MAIN_ANIM_CTR = 'screen_lock_main_anim_control', // 锁屏主界面动效管理
  SL_PANEL_DOWN_GLOBAL_Y = 'screen_lock_panel_down_global_y', // 锁屏面板触摸down点，全局Y轴点
  SL_PANEL_DOWN_GLOBAL_X = 'screen_lock_panel_down_global_x', // 锁屏面板触摸down点，全局X轴点
  SL_LOCK_STATE = 'sl_lock_state', // 屏幕锁定状态
  SL_HOST_STATE = 'screen_lock_host_state', // 是否处于锁屏界面
  SL_SECURE_LOCKED_STATE = 'screen_secure_locked_state', // 锁屏面板是否处于锁定状态
  SL_UI_CONTEXT = 'sl_ui_context', // uiContext
  SL_PANEL_DOWN_GLOBAL = 'sl_panel_down_global', // 锁屏面板全局触摸点
}

/**
 * 子状态类型，锁屏UI绑定变量状态类型
 */
export enum SlBindStateType {
  SL_SHOWING_STATE = 'screen_session_showing_state', // 锁屏面板可见性状态
  OS_ACCOUNT_UNLOCK_STATE = 'os_account_unlock_state', // 账号认证解锁状态
  BG_BLUR_FREEZE = 'sl_bg_blur_freeze_state', // 背景模糊冻结状态
  IS_USING_IMMERSIVE_WALL_PAPER = 'is_using_immersive_wall_paper', // 是否正在使用沉浸态壁纸
  SL_WALLPAPER_LIGHT = 'is_sl_wallpaper_light', // 锁屏壁纸是否为浅色壁纸
  DISABLE_CLOCK_SHADOW = 'disable_clock_shadow', // 是否关闭时钟阴影
  IMMERSIVE_SHOWING_STATE = 'immersive_showing_state',
  SL_GREET_SHOWING_STATE = 'SL_GREET_SHOWING_STATE',
  SL_ROOT_SCALE = 'sl_root_scale',
  SL_VISIBILITY = 'screen_lock_visibility', // 锁屏显影状态
  SL_OPACITY = 'screen_lock_opacity', // 主页透明度
  SL_ZOOM_RATIO = 'screen_lock_zoom_ratio', // 跟手滑动时主题缩放
  SL_WALLPAPER_TRANSLATE = 'screen_lock_wallpaper_translate', // 壁纸纵向偏移
  SL_THEME_STATIC = 'is_static_theme', // 是否是静态布局
  SL_GRID_WIDTH = 'screen_lock_grid_width', // 网格区域宽度
  SL_HOME_BLUR = 'screen_lock_home_blur', // 锁屏面板前景内容模糊
  SL_HOME_SCALE = 'screen_lock_home_scale', // 锁屏小工具滑动过程中主界面的缩放
  IS_USING_TOOLS = 'is_tool_using', // 锁屏小工具是否在使用
  IS_CAMERA_VISIBLE = 'is_camera_visible', // 锁屏相机是否可见
  IS_QUICK_TOOLS_VISIBLE = 'is_quick_tool_visible', // 锁屏小工具是否可见
  IS_FOCUS_DISABLED = 'is_focus_disabled', // 无障碍模式下锁屏根组件是否禁止聚焦
  SL_NEED_USE_EFFECT = 'need_use_effect', // 是否需要开启特效
  IS_FORM_DRAG_NOT_DROP = 'is_form_drag_not_drop', // 是否拖拽卡片未松手
  IS_SMALL_OUT_SCREEN = 'is_small_out_screen', // 是否小外屏显示
  IS_FAKE_AOD_STATE = 'is_fake_aod_state', // 是否在假Aod状态
  SL_BOTTOM_VIEW_MARGIN = 'bottom_view_margin', //底部小工具距离屏幕边缘间距
  SL_EDIT_CLOCK_UP_SCALE = 'edit_clock_up_Scale', //编辑界面缩放比例
  SL_CLOCK_DRAG_STATE = 'clock_drag_state', // 时钟拖拽中
  SL_FOLD_EXPAND_STATE = 'sl_fold_expand_state', // 屏幕是否展开状态
}

/**
 * 子状态类型，时钟组件动效状态类型
 */
export enum ClockAnimStateType {
  ADD_ANIM_SCENE = 'add_anim_scene', // 加入动效场景
  REMOVE_ANIM_SCENE = 'remove_anim_scene', // 移除动效场景
  IS_ANIMATING = 'is_animating', // 是否正在动效中
  IS_SCENE_ANIMATING = 'is_scene_animating', // 是否某个场景动效中
  TRAN_Y_STATE = 'tran_y_state', // 纵向位移状态
  SCALE_X_STATE = 'scale_x_state', // 横向缩放状态
  SCALE_Y_STATE = 'scale_y_state', // 纵向缩放状态
  ALPHA_STATE = 'alpha_state', // 透明度状态
  CLEAR_ALL = 'clear_all' // 清空动效状态
}

/**
 * 子状态类型，锁屏首页组件静态变量状态类型，公共属性
 */
export enum WidgetStaticStateType {
  WIDGET_AREA = 'sl_widget_area', // 组件显示区域
  WIDGET_SCREEN_PIVOT = 'sl_widget_screen_pivot', // 组件相对全屏缩放中心点
  WIDGET_ANIM_CTRL = 'sl_widget_anim_control', // 动效管理
}

/**
 * 子状态类型，锁屏首页组件UI绑定变量状态类型，公共属性
 */
export enum WidgetBindStateType {
  LAYOUT_WIDTH = 'layout_width', // 组件宽度
  LAYOUT_HEIGHT = 'layout_height', // 组件高度
  LAYOUT_VISIBILITY = 'layout_visibility', // 组件可见性
  LAYOUT_SCALE = 'layout_scale', // 组件缩放比例 0 - 1
  LAYOUT_OPACITY = 'layout_opacity', // 组件透明度 0 - 1
  IS_LIGHT_WALLPAPER = 'isLightWallpaper', // 是否亮色壁纸
}

/**
 * 子状态类型，锁屏首页组件UI绑定变量状态类型，快捷工具图标特有属性
 */
export enum QtStaticStateType {
}

/**
 * 子状态类型，锁屏首页组件UI绑定变量状态类型，沉浸胶囊特有属性
 */
export enum CapStaticStateType {
  // 胶囊背景色
  BACKGROUND_COLOR = 'backgroundColor',
  // 提亮参数
  BRIGHTNESS = 'brightnessOptions',
  // 主文本字体样式
  CAPSULE_MAIN_TEXT_STYLE = 'capsuleMainTextStyle',
  // 副文本字体样式
  CAPSULE_SECONDARY_TEXT_STYLE = 'capsuleSecondaryTextStyle',
}

/**
 * 子状态类型，锁屏首页组件UI绑定变量状态类型，相机图标特有属性
 */
export enum CameraStaticStateType {
}

/**
 * 子状态类型，锁屏首页组件UI绑定变量状态类型，通知列表特有属性
 */
export enum ListWgBindStateType {
  BG_BLUR_FREEZE = 'list_bg_blur_freeze_state', // 列表背景模糊冻结状态
  SCROLL_ENABLE = 'scroll_enable', // 列表滚动使能状态
  SHOW_AREA = 'show_area', // 列表显示区域
  NTF_LIST_ITEM_HEIGHT_MAX = 'ntfListItemHeightMax', // 通知列表的最大高度
}

/**
 * 子状态类型，锁屏首页组件UI绑定变量状态类型，锁头特有属性
 */
export enum LockIconBindStateType {
}

/**
 * 子状态类型，锁屏首页组件UI绑定变量状态类型，签名特有属性
 */
export enum SignatureBindStateType {
  SL_SUPPORT_ART_SIGN = 'sl_support_art_signature', // 是否支持艺术签名特性
  SL_SIGN_PANEL_HEIGHT = 'sl_signature_panel_height', // 签名输入面板的高度
}

/**
 * 子状态类型，锁屏首页组件静态变量状态类型，锁头特有属性
 */
export enum LockIconStaticStateType {
  SL_LOCK_ICON_ANIM_CTR = 'screen_lock_lock_icon_anim_control', // 锁头动效管理
}

/**
 * 子状态类型，锁屏首页组件UI绑定变量状态类型，时钟特有属性
 */
export enum ClockBindStateType {
  BACKGROUND_COLOR = 'backgroundColor', // 时钟背景色
  BRIGHTNESS = 'brightnessOptions', // 提亮参数
  IS_CHANGE_COLOR = 'isChangeColor', // 用户是否设置了时钟颜色
  BATTERY_VISIBILITY = 'batteryVisibility', // 时钟组件上的电量图标可见性
  HAS_FORM_CARD = 'hasFormCard', // 服务卡片是否已添加
  TRANSLATE_OPTIONS = 'translateOptions', // 时钟位移
  POSITION_X = 'positionX', // X坐标
  POSITION_Y = 'positionY', // Y坐标
  FONT_FAMILY = 'fontFamily', // 字体
  TEXT_ALIGN = 'textAlign', // 文字对齐方式
  TEXT_COLOR = 'textColor', // 文字颜色
  STROKE_COLOR = 'strokeColor', // 美学推荐颜色
  CLOCK_LAYOUT = 'clockLayout', // 时钟布局
  SIGNATURE_VISIBLE = 'signatureVisible', // 签名是否可见
  SIGNATURE_TEXT = 'signatureText', // 签名内容
  REMOVE_BRIGHTNESS = 'removeBrightness', // 业务场景暂时移除提亮
  CONFIG_BRIGHT_ENABLE = 'configBrightEnable', // 配置移除提亮
  CLOCK_BOARD_AREA = 'clockBoardArea', // 时钟外边框的真实位置
  IS_POSTER_SHADOW = 'isPosterShadow', // 艺术签名阴影是否使能
}

/**
 * 子状态类型，锁屏首页组件UI绑定变量状态类型，卡片特有属性
 */
export enum FormBindStateType {
}

/**
 * 子状态类型，锁屏首页组件静态变量状态类型，时钟特有属性
 */
export enum ClockStaticStateType {
  CLOCK_VIEW_ANIM = 'clockViewAnimState', // 首页时钟组件动效状态
  BACKGROUND_COLOR = 'backgroundColor', // 时钟背景色
  IS_CHANGE_COLOR = 'isChangeColor', // 用户是否设置了时钟颜色
  BRIGHTNESS = 'brightness', // 提亮参数
  AOD_CLOCK_COLOR = 'aodClockColor', // AOD锁屏时钟颜色
  IS_EXITING_KG = 'isExitingKg',
  IS_CLOCK_FORCE_COLLAPSE_STATE = 'isClockForceCollapseState', // 时钟组件初始化是否强制设置锁屏时钟展开状态
  DESKTOP_TO_AOD_ANIM_TYPE = 'desktopToAodAnimType', // 灭屏时时钟组件是否需要播放一镜到底动画
  BATTERY_SWITCH_STATE = 'batterySwitchState', // AOD下电量显示开关开启状态
  IS_CLOCK_EXPAND_STATE = 'isClockExpandState', // 时钟是否展开显示
  CLOCK_MOVE_DISTANCE = 'clockMoveDistance', // 时钟整体偏移
  CLOCK_DIGITAL_RECT_COLLAPSE = 'clock_digital_rect_collapse', // Text_Digital时钟横排位置
  CLOCK_DIGITAL_RECT_EXPAND = 'clock_digital_rect_expand', // Text_Digital时钟竖排位置
  CLOCK_VISIBLE_STATE = 'isClockVisible', // 时钟组件可见性状态
  IS_NEED_REFRESH_CLOCK_LAYOUT = 'isNeedRefreshClockLayout', // 是否需要刷新时钟样式
  HAS_NTF_RELATED_ANIMATION = 'hasNtfRelatedAnimation', // 是否有通知联动动效
  SHOW_AOD_BATTERY = 'showAodBattery', // 是否有通知联动动效
  IS_SUB_SCREEN = 'isSubScreen', // 是否有通知联动动效
  SUB_SCREEN_GRID_WIDTH = 'subScreenGridWidth', // 是否有通知联动动效
  CLOCK_VIEW_ID = 'clockViewId', // 是否有通知联动动效
  AOD_BATTERY_LAYOUT = 'aodBatteryLayout', // 电量显示模式
  IS_AOD_CLOCK_EXPAND = 'isAodClockExpand', // 电量显示模式
}

/**
 * 子状态类型，锁屏首页组件UI绑定变量状态类型，时钟特有属性
 */
export enum OuterFormBindStateType {
  OPACITY_ALPHA = 'opacityAlpha', // 小外屏服务卡片透明度值
}

/**
 * 子状态类型，锁屏首页组件静态变量状态类型，小外屏服务卡片特有属性
 */
export enum OuterFormStaticStateType {
  OPACITY_ALPHA = 'opacityAlpha', // 小外屏服务卡片透明度值
}

/**
 * 子状态类型，锁屏首页组件UI绑定变量状态类型，小外屏底部工具特有属性
 */
export enum OuterToolsBindStateType {
  TOOL_SCALE = 'toolScale', // 小外屏底部工具尺度值
}

/**
 * 子状态类型，锁屏首页组件静态变量状态类型，小外屏底部工具特有属性
 */
export enum OuterToolsStaticStateType {
  TOOL_SCALE = 'toolScale', // 小外屏底部工具尺度值
}

/**
 * 子状态类型，锁屏首页组件UI绑定变量状态类型，沉浸卡片特有属性
 */
export enum CardStaticStateType {
  // 卡片背景色
  BACKGROUND_COLOR = 'backgroundColor',
  // 提亮参数
  BRIGHTNESS = 'brightnessOptions',
  // 三方卡片标题文本样式
  OTHER_CARD_TITLE_TEXT_STYLE = 'otherCardTitleTextStyle',
  // 三方卡片副文本文本样式
  OTHER_CARD_RICH_TEXT_STYLE = 'otherCardRichTextStyle',
  // 导航卡片主要导航文本样式
  CARD_MAIN_NAV_INFO_STYLE = 'cardMainNavInfoStyle',
  // 导航卡片次要导航文本样式
  CARD_VICE_NAV_INFO_STYLE = 'cardViceNavInfoStyle',
}

/**
 * 子状态类型，锁屏首页组件UI绑定变量状态类型，通知列表特有属性
 */
export enum ListStaticStateType {
  // 通知列表背景色
  BACKGROUND_COLOR = 'backgroundColor',
  // 提亮参数
  BRIGHTNESS = 'brightnessOptions',
  // 主文本样式
  LIST_MAIN_TEXT_STYLE = 'listMainTextStyle',
  // 副文本样式
  LIST_SECONDARY_TEXT_STYLE = 'listSecondaryTextStyle',
  // 锁屏通知列表数据是否按隐藏处理
  NTF_LIST_HIDE_FLAG = 'ntfListHideFlag',
  // 锁屏通知列表条目高度总和
  NTF_LIST_ITEM_HEIGHT_SUM = 'ntfListItemHeightSum',
}

/**
 * 子状态类型，锁屏首页组件UI绑定变量状态类型，沉浸胶囊特有属性
 */
export enum CapWgBindStateType {
  // 胶囊背景色
  BACKGROUND_COLOR = 'backgroundColor',
  // 提亮参数
  BRIGHTNESS = 'brightnessOptions',
  // 缩放参数
  CAPSULE_SCALE = 'capScale',
  // 透明度
  CAPSULE_ALPHA = 'capAlpha',
  // 胶囊指纹重叠
  CAPSULE_CONFLICT = 'capFingerConflict',
  // 胶囊壁纸反色，是否压暗处理
  PT_CAP_DARK_MODE = 'isCapDarkMode',
}

/**
 * 子状态类型，锁屏首页组件UI绑定变量状态类型，沉浸卡片特有属性
 */
export enum CardWgBindStateType {
  // 卡片背景色
  BACKGROUND_COLOR = 'backgroundColor',
  // 提亮参数
  BRIGHTNESS = 'brightnessOptions',
  // 背板透明度
  BACKGROUND_ALPHA = 'backgroundAlpha',
  // 预览图透明度
  PREVIEW_ALPHA = 'previewAlpha',
  // 缩放参数
  CARD_SCALE = 'cardScale',
  // 透明度
  CARD_ALPHA = 'cardAlpha',
  // 堆叠布局小卡是否收拢
  IS_CARD_FOLD = 'isCardFold',
  // UIExtention组件加载loading状态
  UI_EXTENTION_LOADING_STATE = 'UIExtentionLoadingState',
}

/**
 * 子状态类型，锁屏景深壁纸UI绑定变量特有属性
 */
export enum DofWallpaperStaticStateType {
  // 景深壁纸配置
  DOF_TYPE_CONFIG = 'dofTypeConfig',
  // 需要重新计算景深的type
  DOF_TYPE_CALC = 'dofTypeCalc',
  // 计算景深后是否需要刷新配置文件
  NEED_WRITE_CONFIG_FILE = 'needWriteConfigFile',
  // 景深计算时，阈值控制
  DOF_CALC_CONTROL_MODE = 'dofCalcControlMode'
}

/**
 * 子状态类型，锁屏首页组件静态变量状态类型，景深壁纸特有属性
 */
export enum DofWallpaperBindStateType {
  // 壁纸亮度
  DOF_WALLPAPER_LIGHT = 'dofWallpaperLight'
}

/**
 * 子状态类型，锁屏指纹UI绑定变量特有属性
 */
export enum FingerprintStaticStateType {
}

/**
 * 子状态类型，锁屏首页组件静态变量状态类型，指纹特有属性
 */
export enum FingerprintBindStateType {
  // 指纹使能情况
  FINGER_ENABLE_STATE = 'fingerEnableState',
  // 锁屏指纹在屏幕里的X坐标
  FINGER_POSITION_X = 'fingerprintPositionX',
  // 锁屏指纹在屏幕里的Y坐标
  FINGER_POSITION_Y = 'fingerprintPositionY',
  // 锁屏指纹一镜到底动画配置
  FINGER_RADIUS = 'fingerprintRadius',
  // 锁屏指纹动画状态
  FINGER_ANIMATE_STATE = 'fingerAnimateState',
  // 锁屏指纹通知禁用状态
  FINGER_NTF_DISABLE_STATE = 'isNtfDisableFingerPrint',
  // 锁屏指纹隐藏动效播放状态
  FINGER_ICON_HIDDEN_STATE = 'isHiddenLottiePlaying',
}

/**
 * 子状态类型，锁屏首页组件静态变量状态类型，服务卡片特有属性
 */
export enum FormWgStaticStateType {
  FORM_SHOW_COUNT = 'form_show_count', // 服务卡片可见栅格数
  IS_FORM_PANEL_SHOW = 'is_form_panel_show', // 服务卡片面板是否显示
}

/**
 * 子状态类型，锁屏一镜到底服务静态变量状态类型
 */
export enum OneMirrorStaticStateType {
  ONE_MIRROR_ANIM_STATE = 'one_mirror_anim_state', // 一镜到底动效状态
  IS_AOD_SHOWING = 'is_aod_showing', // AOD显示状态
  IS_DESKTOP_TO_SL = 'is_desktop_to_aod', // 是否是桌面到锁屏界面场景
  IS_NEED_SHOW_IMMERSIVE = 'is_Need_Show_Immersive', // 当前通知数据是否存在可以进沉浸态的卡片
  IS_HAS_BROAD_CASTING_CENTER = 'is_has_Broad_Casting_Center', // 当前是否存在播控类实况通知
  SLEEP_REASON = 'beginSleepReason', // 灭屏原因
  PT_AOD_STATE = 'is_aod_state', // 是否AOD状态，带有动效状态
}

export enum SlGreetSBindStateType {}

export enum SlGreetStaticStateType {
  WIDGET_ANIM_CTRL = 'sl_widget_anim_control', // 动效管理
}

/**
 * 子状态类型，锁屏编辑静态变量状态类型
 */
export enum EditStaticStateType {
  IS_CANCEL_EDIT = 'isCancelEdit', // 是否取消编辑
}

/**
 * 子状态类型，锁屏编辑UI绑定变量状态类型
 */
export enum EditBindStateType {
  SL_EDIT_ART_SIGN_CAP = 'sl_edit_art_signature_capability', // 艺术签名能力支持集
  SL_EDIT_TOOLBAR_WIDTH = 'sl_edit_toolbar_width', // toolbar的宽度
  SL_EDIT_LAYOUT_TYPE = 'sl_edit_layout_type', // 当前选择的时钟样式类型
  SL_EDIT_CLOCK_AMOUNT = 'sl_edit_clock_amount', // 当前屏幕时钟可用栅格最大值
  SELECTED_COLOR_INDEX = 'selectedColorIndex', // 字体颜色索引值
  SL_EDIT_ART_TIP_HIDDEN = 'sl_edit_art_tip_hidden', // 艺术签名tip隐藏状态
  SL_EDIT_ART_TAB_TEXT_AREA = 'sl_edit_art_tab_text_area', // 艺术签名tab文本位置
}

/**
 * 子状态类型,锁屏时钟编辑
 */
export enum ClockEditBindStateType {
  IS_SHOW_FORM_BIND_SHEET = 'is_show_form_bind_sheet', // 是否显示时钟卡片编辑界面
}

/**
 * 子状态类型，锁屏编辑艺术签名样式选择界面UI绑定变量状态类型
 */
export enum ArtLayoutBindStateType {
  SL_EDIT_ART_LAYOUTS, // 可选的艺术签名样式及其对应的预览图资源
  SL_EDIT_ART_FONTS, // 可选的艺术签名字体及其对应的预览图资源
  SL_EDIT_ART_TEXT, // 艺术签名文本
  SL_EDIT_ART_LAYOUT, // 艺术签名样式
  SL_EDIT_ART_FONT, // 艺术签名字体
  SL_EDIT_ART_RIPPLE, // 艺术签名构图动画
  SL_EDIT_ART_PANEL, // 艺术签名编辑面板
  SL_EDIT_ART_COLOR, // 艺术签名颜色
  SL_EDIT_ART_LAYOUT_DETAIL, // 艺术签名详细信息（镜像）
}

/**
 * 子状态类型，时钟原数据变量状态类型
 */
export enum ClockModeDataType {
  LAYOUT = 'layout',
  POS_X = 'pos_x',
  POS_Y = 'pos_y',
  ALIGNMENT = 'alignment',
  CLOCK_STROKE_COLOR = 'clock_stroke_color',
  CLOCK_FONT_FAMILY = 'clock_font_family',
  IS_DOF = 'is_dof',
  DOF_CLOCK_LAYOUT = 'dof_clock_layout',
  DOF_CLOCK_X = 'dof_clock_x',
  DOF_CLOCK_Y = 'dof_clock_y',
  IS_CLOCK_TEXT_SHADOW_ENABLED = 'is_clock_text_shadow_enabled',
  IS_CLOCK_TEXT_BLUR_EFFECT_ENABLED = 'is_clock_text_blur_effect_enabled',
  IS_CLOCK_DATE_VISIBLE = 'is_clock_date_visible',
  IS_CLOCK_LUNAR_VISIBLE = 'is_clock_lunar_visible',
  IS_CLOCK_SIGNATURE_VISIBLE = 'is_clock_signature_visible',
  CLOCK_SIGNATURE_TEXT = 'clock_signature_text',
  CLOCK_DEGREE_NUMBER = 'clock_degree_number',
  RADIUS = 'radius',
  SATURATION = 'saturation',
  BRIGHTNESS = 'brightness',
  NEED_COLOR = 'need_color',
  IS_SHADOW = 'is_shadow',
  IS_CHANGE_COLOR = 'isChange_color',
  IS_LIGHT_WALLPAPER = 'is_light_wallPaper'
}

// 子状态类型，锁屏密码面板静态变量类型
export enum FoldablePSDStaticStateType {
}

/**
 * 时钟桌面一镜到底动画类型
 */
export enum ClockDeskTop2AodAnimType {
  // 无动画 桌面非首页到全屏AOD
  NONE = 1,
  // 桌面首页到全屏AOD
  DESKTOP_TO_FULL_AOD = 2,
  // 桌面首页到局部AOD
  DESKTOP_TO_PART_AOD = 3,
  // 桌面非首页到局部AOD
  DESKTOP_TO_PART_AOD_NO_ANIM = 4,
}

// 子状态类型统一对外
export type SlSubStateType = SlStaticStateType | SlBindStateType | ClockAnimStateType | WidgetStaticStateType |
  WidgetBindStateType | ListWgBindStateType | QtStaticStateType | CapStaticStateType | CameraStaticStateType |
  LockIconBindStateType | LockIconStaticStateType | ClockBindStateType | ClockStaticStateType | CardStaticStateType |
  ListStaticStateType | CapWgBindStateType | CardWgBindStateType | DofWallpaperBindStateType |
  DofWallpaperStaticStateType | FormWgStaticStateType | FingerprintBindStateType | FingerprintStaticStateType |
  OneMirrorStaticStateType | OuterFormBindStateType | OuterFormStaticStateType | SlGreetSBindStateType |
  SlGreetStaticStateType | EditStaticStateType | ClockModeDataType | OuterToolsBindStateType |
  OuterToolsStaticStateType | FoldablePSDStaticStateType | SignatureBindStateType |
  EditBindStateType | ArtLayoutBindStateType | ClockEditBindStateType | FormBindStateType | ClockDeskTop2AodAnimType;
