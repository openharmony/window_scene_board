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
import effectKit from '@ohos.effectKit';

/**
 * 锁屏常量
 */
export default class CommonConstants {
  /**
   * APS开关打开
   */
  public static readonly APS_UNLOCK_TO_ENTER_DESKTOP_OPEN = 1;

  /**
   * APS开关关闭
   */
  public static readonly APS_UNLOCK_TO_ENTER_DESKTOP_CLOSE = 0;

  /**
   * AppStorage key 当前用户
   */
  public static readonly CURRENT_USER_KEY = 'currentUserItem';

  /**
   * The default user id
   */
  public static readonly DEFAULT_USER_ID: number = 100;

  /**
   * AppStorage key 是否为PIN码，true：PIN码，false:域账号密码
   */
  public static readonly IS_PIN_AUTH_TYPE_KEY = 'isPinAuthType';

  /**
   * AppStorage key 锁屏状态
   */
  public static readonly LOCK_STATUS_KEY = 'lockStatus';

  /**
   * AppStorage key 密码类型
   */
  public static readonly PASSWORD_TYPE_KEY = 'passwordType';

  /**
   * GlobalStatusCache key 是否有设置密码
   */
  public static readonly SETTING_HAS_PASSWORD_KEY = 'SETTING_HAS_PASSWORD';

  /**
   * AppStorage key 是否灭屏
   */
  public static readonly SCREEN_OFF_KEY = 'isScreenOff';

  /**
   * AppStorage key inputFilter
   */
  public static readonly TYPE_FILTER_KEY = 'typeFilter';

  /**
   * AppStorage key 开始滑动时间
   */
  public static readonly START_SLIDING_UNLOCK_KEY = 'startSlidingUnlock';

  /**
   * wallpaper default scale
   */
  public static readonly DEFAULT_WALLPAPER_SCALE: number = 1.1;

  /**
   * Hour to day
   */
  public static readonly HOURS_TO_DAY: number = 24;

  /**
   * Minute to hour
   */
  public static readonly MINUTE_TO_HOURS: number = 60;

  /**
   * Seconds to minutes
   */
  public static readonly SECOND_TO_MINUTE: number = 60;

  /**
   * milliseconds to seconds
   */
  public static readonly MILLISECOND_TO_SECOND: number = 1000;

  /**
   * milliseconds to half seconds
   */
  public static readonly MILLISECOND_TO_HALF_SECOND: number = 500;

  /**
   * max opacity in unlock animation
   */
  public static readonly maxViewOpacity: number = 150;

  /**
   * max scale in unlock animate
   */
  public static readonly maxZoomRatio: number = 1.1;

  /**
   * max scale in slide animate
   */
  public static readonly maxSlideRatio: number = 1.1;

  /**
   * min scale of wallpaper in unlock animation
   */
  public static readonly minWallpaperScale: number = 1.05;

  /**
   * max account offset in unlock animate
   */
  public static readonly maxAccountOffset: number = 30;

  /**
   * The refresh interval
   */
  public static readonly INTERVAL:number = 1000;

  /**
   * The password type array
   */
  public static readonly PIN_TYPE_ARRAY: string[] = ['PIN_SIX', 'PIN_FOUR', 'PIN_PATTERN', 'PIN_NUMBER', 'PIN_MIXED'];

  /**
   * The password type array no PIN_MIXED
   */
  public static readonly NO_PIN_MIXED_ARRAY: string[] = ['PIN_SIX', 'PIN_FOUR', 'PIN_PATTERN', 'PIN_NUMBER'];

  /**
   * The password type none
   */
  public static readonly PIN_TYPE_NONE: string = 'NONE';

  /**
   * The password type PIN_MIXED
   */
  public static readonly PIN_TYPE_MIX: string = 'PIN_MIXED';

  /**
   * The password type PIN_SIX
   */
  public static readonly PIN_TYPE_SIX: string = 'PIN_SIX';

  /**
   * The password type PIN_FOUR
   */
  public static readonly PIN_TYPE_FOUR: string = 'PIN_FOUR';

  /**
   * The password type PIN_PATTERN
   */
  public static readonly PIN_TYPE_PATTERN: string = 'PIN_PATTERN';

  /**
   * The password type PIN_NUMBER
   */
  public static readonly PIN_TYPE_NUMBER: string = 'PIN_NUMBER';

  /**
   * 判断隐私空间是否正在迁移数据
   */
  public static readonly PRIVATE_SPACE_MOVING_DATA: string = 'isPrivateSpaceServiceMoveData';

  /**
   * 判断隐私空间正在迁移数据
   */
  public static readonly PRIVATE_SPACE_MOVING_DATA_START: string = '1';

  /**
   * 判断隐私空间暂停迁移数据
   */
  public static readonly PRIVATE_SPACE_MOVING_DATA_STOP: string = '0';

  /**
   * The password six length
   */
  public static readonly PW_SIX_LEN: number = 6;

  /**
   * The password four length
   */
  public static readonly PW_FOUR_LEN: number = 4;

  /**
   * 提亮压暗分界默认值
   */
  public static readonly BRIGHT_NESS_DEFAULT = 1;

/*
   壁纸延时默认值
 */
  public static readonly DESKTOP_TO_AOD_HOME_PAGE_DELAY: number = 500;

  public static readonly DESKTOP_TO_AOD_DELAY: number = 150;
  /*
   * 锁屏壁纸的层级 Z_INDEX
   */
  public static readonly SCREEN_LOCK_WALL_PAPER_ZINDEX = 1999;

  /**
   * 手势支持结果
   */
  public static readonly GESTURE_DEFAULT: number = -2;
  public static readonly GESTURE_NOT_SUPPORT: number = -1;
  public static readonly GESTURE_ERROR: number = 0;
  public static readonly GESTURE_SUCCESS: number = 1;

  /**
   * 默认时钟展开等待时间
   */
  public static readonly CLOCK_EXPAND_WAIT_TIME: number = 5000;

  /**
   * 默认计时器ID
   */
  public static readonly DEFAULT_TIMEOUT_ID: number = -1;

  /**
   * 截图取色获取颜色失败
   */
  public static readonly ERROR_LIGHT_COLOR_DEGREE_PICTURE: number = 404;

  /**
   * 锁屏通知根组件区域
   */
  public static readonly DEFAULT_WIDGET_AREA = [0, 0, 1, 1];

  /**
   * 锁屏默认提亮RGB颜色
   */
  public static readonly DEFAULT_BRIGHT_RGB_COLOR: effectKit.Color = { red: 255, green: 255, blue: 255, alpha: 0 };

  /**
   * 锁屏默认提亮string颜色
   */
  public static readonly DEFAULT_BRIGHT_COLOR = '#FFFFFF';

  /**
   * 锁屏默认压暗string颜色
   */
  public static readonly DEFAULT_DARK_COLOR = '#000000';

  /**
   * 根据壁纸和锁屏组件区域计算的背景色缓存容量
   */
  public static readonly BACK_COLOR_CACHE_CAPACITY = 1024;

  /**
   * 缓存统计最大查询次数
   */
  public static readonly MAX_CACHE_COUNT_SIZE = 1000;

  /**
   * 锁屏组件坐标默认值
   */
  public static readonly POSITION_ZERO = 0;

  /**
   * 锁屏组件区域坐标数组最大长度为4
   */
  public static readonly POSITION_ARR_LENGTH = 4;

  /**
   * 计算纯色时，时钟区域的小数坐标整体放大倍数
   */
  public static readonly TOTAL_MULTIPLES = 100;

  /**
   * 锁屏组件坐标放大后，认为位置近似的最大差值
   */
  public static readonly MAX_DIFFERENCE = 5;

  /**
   * 纯色参数重复注册最大次数
   */
  public static readonly MAX_REGISTER_COUNT = 10000;
}

/**
 * 触发取消密码contextID的原因
 */
export class CancelAuthPWDReason {
  /**
   * 未知原因
   */
  public static readonly UNKNOWN: string = 'Unknown';

  /**
   * 删除第一个输入
   */
  public static readonly DELETE_FIRST_INPUT: string = 'delete_first_input';

  /**
   * 退出密码页
   */
  public static readonly EXIT_BOUNCER: string = 'exit_bouncer';

  /**
   * 指纹解锁
   */
  public static readonly FP_UNLOCK: string = 'fp_unlock';

  /**
   * 人脸解锁
   */
  public static readonly FACE_UNLOCK: string = 'face_unlock';
}

/**
 * 锁屏主页面子业务
 */
export enum SlFeatureType {
  /**
   * 锁头
   */
  LOCK_ICON = 'lock_icon',

  /**
   * 主页面时钟
   */
  CLOCK_MAIN = 'clock_main',

  /**
   * 锁屏卡片业务
   */
  FORM = 'form',

  /**
   * 锁屏通知胶囊业务
   */
  CAPSULE = 'capsule',

  /**
   * 锁屏通知列表业务
   */
  NTF_LIST = 'ntf_list',

  /**
   * 沉浸态大卡片业务
   */
  IMMERSIVE_CARD = 'immersive_card'
}

/**
 * 标识锁屏各根组件区域类型，用于计算组件局部取色
 */
export enum SlAreaType {
  /**
   * 默认区域
   */
  DEFAULT = 'default',

  /**
   * 锁头区域
   */
  LOCK_ICON = 'lock_icon',

  /**
   * 时钟区域
   */
  CLOCK = 'clock',

  /**
   * 卡片区域
   */
  FORM = 'form',

  /**
   * 通知列表
   */
  NTF_LIST = 'ntf_list',

  /**
   * 锁屏胶囊区域
   */
  CAPSULE = 'capsule',

  /**
   * 沉浸态大卡区域
   */
  IMMERSIVE_CARD = 'immersive_card',
}

/**
 * 锁屏视效参数使用场景位置
 */
export enum SlPositionType {
  /**
   * 默认
   */
  DEFAULT = '',

  /**
   * 锁头
   */
  LOCK_ICON = 'lock_icon',

  /**
   * 锁头赋色
   */
  LOCK_ICON_CHANGE_COLOR = 'lock_icon_change_color',

  /**
   * 时钟组件
   */
  SL_CLOCK_WIDGET = 'sl_clock_widget',

  /**
   * 时钟组件
   */
  SL_CLOCK_WIDGET_CHANGE_COLOR = 'sl_clock_widget_change_color',

  /**
   * 卡片前景
   */
  SL_FORM_FOREGROUND = 'sl_form_foreground',

  /**
   * 卡片前景赋色
   */
  SL_FORM_FOREGROUND_CHANGE_COLOR = 'sl_form_foreground_change_color',

  /**
   * 卡片背板
   */
  SL_FORM_PANEL = 'sl_form_panel',

  /**
   * 锁屏主页面场景胶囊一级前景
   */
  SL_CAP_FIRST_FOREGROUND = 'sl_cap_content_foreground',

  /**
   * 锁屏主页面场景胶囊一级按钮
   */
  SL_CAP_FIRST_BUTTON = 'sl_cap_content_button',

  /**
   * 锁屏主页面场景胶囊一级背景
   */
  SL_CAP_FIRST_BACKGROUND = 'sl_cap_content_back',

  /**
   * 锁屏主页面胶囊状态下实况辅助区文字提亮
   */
  SL_CAP_SUPPORT_TEXT_BRIGHT = 'sl_cap_support_text_bright',

  /**
   * 锁屏主页面胶囊状态下实况辅助区背景提亮
   */
  SL_CAP_SUPPORT_BACK_BRIGHT = 'sl_cap_support_back_bright',

  /**
   * 锁屏主页面场景胶囊二级前景
   */
  SL_CAP_SECOND_FOREGROUND = 'sl_cap_shadow_foreground',

  /**
   * 锁屏主页面场景胶囊二级按钮
   */
  SL_CAP_SECOND_BUTTON = 'sl_cap_shadow_button',

  /**
   * 锁屏主页面场景胶囊二级级背景
   */
  SL_CAP_SECOND_BACKGROUND = 'sl_cap_shadow_back',

  /**
   * 锁屏通知列表背板
   */
  SL_NTF_LIST_BACK = 'sl_ntf_list_back',

  /**
   * 锁屏通知前景
   */
  SL_NTF_LIST_FOREGROUND = 'sl_ntf_list_foreground',

  /**
   * 锁屏沉浸态大卡片背景
   */
  SL_IMMERSIVE_CARD_BG = 'sl_immersive_card_bg'
}

/**
 * 锁屏主页面元素CCM特性级配置
 */
export enum CcmOption {
  /**
   * 模糊
   */
  EFFECT,

  /**
   * 提亮
   */
  BRIGHT,

  /**
   * 纯色
   */
  SOLID,

  /**
   * HDR效果
   */
  HDR,

  /**
   * 跟手模糊
   */
  SLIDE2BOUNCER,
}

export enum GestureAction {
  START = 0,
  UPDATE = 1,
  END = 2,
  CANCEL = 3,
}

export enum TransitionAction {
  ACTIVE = 0,
  INACTIVE = 1,
  INACTIVE_WITH_MOVE_STARTING = 2,
}

/**
 * 美学壁纸类型
 */
export enum PictureLightColorDegree {
  UNKOWN_LIGHT_COLOR_DEGREE_PICTURE = 0,
  EXTREMELY_LIGHT_COLOR_PICTURE = 1,
  LIGHT_COLOR_PICTURE = 2,
  DARK_COLOR_PICTURE = 3,
  EXTREMELY_DARK_COLOR_PICTURE = 4,
  FLOWERY_PICTURE = 5,
  EXTREMELY_FLOWERY_PICTURE = 6
}
