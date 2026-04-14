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
 * 实况卡片图片名称
 */
export enum LiveIconName {

  PIC_NAME = 'pic',

  DESC_PIC_NAME = 'descPic',

  SPACE_ICON_NAME = 'spaceIcon',

  HOST_ICON_NAME = 'hostIcon',

  GUEST_ICON_NAME = 'guestIcon',

  CURRNAVDIRECTION_ICON_NAME = 'currNavDirectionIcon',

  INDICATOR_ICON_NAME = 'indicatorIcon',
}

/**
 * 实况卡片类型
 * TODO 卡片类型标识
 */
export enum LiveType {
  /**
   * 非法类型
   */
  INVALID = -2,

  /**
   * 无扩展区类型
   */
  NO_LAYOUT = -1,

  /**
   * 系统卡片
   */
  TYPE_SYSTEM = 0,

  /**
   * 进度可视化类型
   */
  PROGRESS = 3,

  /**
   * 强调文本类型
   */
  PICK_UP = 4,

  /**
   * 左右文本类型
   */
  FLIGHT = 5,

  /**
   * 赛事比分类型
   */
  SCORE = 7,

  /**
   * 导航类型
   */
  NAVIGATION = 8,
}

/**
 * 实况卡片、胶囊扩充数据类型，基础类型
 */
export enum LiveExtendType {
  /**
   * 系统按钮数据类型
   */
  TYPE_COMMON_BUTTON = 0x01,

  /**
   * 系统计时器数据类型
   */
  TYPE_COMMON_TIMER = 0x02,

  /**
   * 系统进度环数据类型
   */
  TYPE_COMMON_PROGRESS = 0x04,

  /**
   * 三方应用辅助区数据类型
   */
  TYPE_OTHER_EXTEND = 0x08,

  /**
   * 胶囊样式
   */
  TYPE_CAPSULE_STYLE = 0x10
}

/**
 * 成员变量使用场景
 */
export enum LiveUsageScene {
  /**
   * 实况卡片场景
   */
  SCENE_LIVE_NTF = 'scene_live_ntf_',

  /**
   * 胶囊卡片场景
   */
  SCENE_CAPSULE = 'scene_capsule_'
}

/**
 * 成员变量使用位置
 */
export enum LivePositionName {
  /**
   * 标题
   */
  TITLE = 'title_',

  /**
   * 副文本
   */
  CONTENT = 'content_',

  /**
   * 副文本(富文本)
   */
  RICH_CONTENT = 'rich_content_',

  /**
   * 扩展按钮数据
   */
  EXTEND_BUTTON = 'extend_button_',

  /**
   * 扩展计时器数据
   */
  EXTEND_TIMER = 'extend_timer_',

  /**
   * 扩展进度数据
   */
  EXTEND_PROGRESS = 'extend_progress_',

  /**
   * 扩展三方卡片模板辅助区数据
   */
  OTHER_EXTEND = 'other_extend_'
}

/**
 * 成员变量属性名称
 */
export enum LivePropertyName {
  /**
   * 文本颜色
   */
  TEXT_COLOR = 'text_color',

  /**
   * 胶囊样式
   */
  CAPSULE_STYLE = 'capsule_style',

  /**
   * 扩展数据
   */
  EXTEND_DATA = 'extend_data',

  /**
   * 不重新加载图片
   */
  NO_RELOAD_IMAGE = 'no_reload_image'
}

/**
 * 胶囊状态
 */
export enum CapsuleStatus {
  /**
   * 胶囊更新，持续显示
   */
  STATUS_UPDATE = 1,

  /**
   * 胶囊结束，移除胶囊
   */
  STATUS_FINISH = -1
}

/**
 * 胶囊类型
 */
export enum CapsuleType {
  /**
   * 文本类型
   */
  TYPE_TEXT,

  /**
   * 计时器类型
   */
  TYPE_TIMER = LiveExtendType.TYPE_COMMON_TIMER,

  /**
   * 进度类型
   */
  TYPE_PROGRESS = LiveExtendType.TYPE_COMMON_PROGRESS
}

/**
 * 扩展区进度条显示类型,默认值取0，值范围：[0,2]
 */
export enum LineType {
  /**
   * 虚线进度
   */
  DOTTED_PROGRESS,

  /**
   * 普通实线进度
   */
  NORMAL_SOLID_LINE_PROGRESS,

  /**
   * 粗实线进度
   */
  THICK_SOLID_LINE_PROGRESS
}

/**
 * 扩展区指示器小图标显示类型,枚举值范围为[0,2]
 */
export enum IndicatorType {
  /**
   * 不显示指示器小图标
   */
  NOT_SHOW,

  /**
   * 表示显示在进度线上方
   */
  UP_PROGRESS_LINE,

  /**
   * 显示覆盖在进度
   */
  COVERAGE_PROGRESS
}

/**
 * 实况通知类型,区分本地和三方
 */
export enum LiveViewType {
  LOCAL = 5,
  OTHER = 6
}

/**
 * 三方应用卡片模板辅助区显示类型
 */
export enum OtherFormExtendShowType {
  /**
   * 不显示
   */
  NOT_SHOW = 0,

  /**
   * 显示普通文本
   */
  NORMAL_TEXT = 1,

  /**
   * 显示胶囊文本
   */
  CAPSULE_TEXT = 2,

  /**
   * 显示图片
   */
  PICTURE = 3,

  /**
   * 显示Icon
   */
  ICON = 4,
}

/**
 * 三方应用胶囊数据类型
 */
export enum OtherCapsuleDataType {
  /**
   * 1：图标+文本类型，胶囊显示左侧图标，右侧文本
   */
  CAPSULE_TYPE_TEXT = 1,
  /**
   * 2：计时器类型，胶囊显示左侧图标，右侧计时文本
   */
  CAPSULE_TYPE_TIMER = 2,

  /**
   * 3：进度类型；胶囊显示整体进度，左侧叠加图标，右侧叠加百分比；进度值取自通知progress"
   */
  CAPSULE_TYPE_PROGRESS = 3
}

/**
 * 左右文本模板子类型
 */
export enum LayoutStyle {
  /**
   * 0：子类型值-强调型
   */
  SUB_TYPE_EMPHASIS = 0,
  /**
   * 1：子类型值-均衡型
   */
  SUB_TYPE_BALANCE = 1,
}

/**
 * 扩展区中间的显示类型
 */
export enum FlightLayoutSpaceType {
  /**
   * 0：扩展区中间的显示类型值-显示图标
   */
  SPACE_TYPE_ICON = 0,
  /**
   * 1：扩展区中间的显示类型值-显示文本
   */
  SPACE_TYPE_TEXT = 1,
}

/**
 * 来电SIM卡图标状态
 */
export enum PhoneSimStatus {
  /**
   * 不显示SIM卡标
   */
  STATUS_NONE,

  /**
   * 显示SIM卡1图标
   */
  STATUS_SIM_1,

  /**
   * 显示SIM卡2图标
   */
  STATUS_SIM_2
}

/**
 * 系统实况类型码
 */
export enum SysTypeCode {
  /**
   * 三方类型
   */
  OTHER = -1,

  /**
   * 来电
   */
  PHONE = 0,

  /**
   * 录屏
   */
  SCREEN_RECORDING = 1,

  /**
   * 播控
   */
  BROADCASTING_CENTER = 2,

  /**
   * 多屏协同
   */
  MULTISCREEN_COLLABORATION = 3,

  /**
   * 无线投屏
   */
  WIRELESS_PROJECTION = 4,

  /**
   * 闹钟
   */
  ALARM = 5,

  /**
   * 计时器
   */
  TIMER = 6,

  /**
   * 录音机
   */
  RECORDING = 7,

  /**
   * 蓝牙传输
   */
  BLUETOOTH = 8,

  /**
   * 验证码
   */
  VERIFY_CODE = 12,

  /**
   * 上传下载
   */
  UPLOAD_DOWNLOAD = 13,

  /**
   * 大字体计时器
   */
  BIG_TEXT_TIMER = 14,

  /**
   * 手电筒
   */
  FLASH_LIGHT = 15,

  /**
   * 充电
   */
  CHARGE = 16,

  /**
   * 钱包
   */
  WALLET = 17,

  /**
   * 耳机
   */
  EARPHONE = 18,

  /**
   * 情景模式
   */
  SCENARIO_MODE = 19,

  /**
   * 听歌识曲
   */
  NAME_THAT_TUNE = 20,
  /**
   * 设置搜索-防窥保护
   */
  PRIVACY_PROTECTION = 21,
  /**
   * AI反诈
   */
  AI_ANTI_FRAUD = 22,
  /**
   * 超级隐私
   */
  SUPER_PRIVACY = 23,
  /**
   * 人脸解锁
   */
  FACE_LOCK = 24,
}

/**
 * 数据显示类型
 */
export enum LiveViewShowType {
  NONE, //不显示*
  CARD, //卡片*
  CAPSULE, //胶囊*
}

/**
 * 胶囊类型基类
 */
export enum CapsuleDataType {
  /**
   * 1：图标+文本类型，胶囊显示左侧图标，右侧文本
   */
  CAPSULE_TYPE_TEXT = 1,
  /**
   * 2：计时器类型，胶囊显示左侧图标，右侧计时文本
   */
  CAPSULE_TYPE_TIMER = 2,

  /**
   * 3：进度类型；胶囊显示整体进度，左侧叠加图标，右侧叠加百分比；进度值取自通知progress
   */
  CAPSULE_TYPE_PROGRESS = 3
}

/**
 * 胶囊显示类型
 */
export enum CapsuleShowType {
  NONE, //不显示*
  BANNER, //横幅*
  SHADOW, //阴影*
  SHOW, //显示*
  TOP, //置顶显示*
}

/**
 * 实况卡片使用场景
 */
export enum LiveUseScene {
  /**
   * 通知中心
   */
  SCENE_NTF_CENTER = 'notification_center',

  /**
   * 横幅通知
   */
  SCENE_HEADS_UP = 'heads_up',

  /**
   * 实况面板
   */
  SCENE_LIVE_LIST = 'live_list',

  /**
   * 锁屏面板
   */
  SCENE_SCREEN_LOCK = 'screen_lock',

  /**
   * 沉浸卡片
   */
  SCENE_IMMERSIVE_CARD = 'immersive_card',

  /**
   * 锁屏面板普通通知
   */
  SCENE_SCREEN_LOCK_NOTIFICATION = 'screen_lock_notification'
}

/**
 * 实况卡片、胶囊动效场景
 */
export enum LiveAnimScene {
  /**
   * 胶囊出现动效
   */
  SCENE_CAPSULE_SHOW = 'anim_capsule_show',

  /**
   * 胶囊消失动效
   */
  SCENE_CAPSULE_HIDE = 'anim_capsule_hide',

  /**
   * 胶囊占位场景
   */
  SCENE_CAPSULE_PLACE = 'anim_capsule_place',

  /**
   * 应用退出到胶囊动效
   */
  SCENE_APP_EXIT_CAPSULE = 'anim_app_exit_capsule',

  /**
   * 点击胶囊展开列表动效
   */
  SCENE_CAPSULE_TO_LIST = 'anim_capsule_to_list',

  /**
   * 列表收起到胶囊动效
   */
  SCENE_LIST_TO_CAPSULE = 'anim_list_to_capsule',

  /**
   * 胶囊更新强提醒
   */
  SCENE_CAPSULE_REMIND = 'scene_capsule_remind',
}

/**
 * 时间进制、倒计时最大时间(小于100小时）
 */
export enum TimeItem {
  MILLISECOND_ITEM = 1000,
  SEC_ITEM = 60,
  MIN_ITEM = 60,
  HOUR_ITEM = 24,
  MAX_HOURS_ITEM = 100
}

/**
 * 实况操作类型：status
 */
export enum LiveViewDataStatus {
  /**
   * 创建
   */
  CREATE,

  /**
   * 局部更新
   */
  SOME_UPDATE,

  /**
   * 结束
   */
  END,

  /**
   * 全量刷新
   */
  ALL_UPDATE
}

export enum CapsuleRemindType {
  /**
   * 自动展开为横幅
   */
  EXPAND = 'EXPAND',

  /**
   * 胶囊强提醒更新
   */
  FLIP = 'FLIP',

  /**
   * 无特殊提醒方式
   */
  DEFAULT = 'DEFAULT',
}

/**
 * 实况按钮开关状态
 */
export enum LiveButtonState {
  /**
   * 开状态
   */
  ON = 'ON',

  /**
   * 关状态
   */
  OFF = 'OFF'
}

/**
 * 胶囊动效组件名称
 */
export enum CapsuleAnimName {
  /**
   * 动效组件根组件
   */
  CAPSULE_ROOT = 'capsule_root',

  /**
   * 动效组件内容组件
   */
  CAPSULE_CONTENT = 'capsule_content',

  /**
   * 动效组件overlay组件
   */
  CAPSULE_OVERLAY = 'capsule_overlay',

  /**
   * 动效组件阴影组件
   */
  CAPSULE_SHADOW = 'capsule_shadow',
  /**
   * 动效组件渐隐组件
   */
  CAPSULE_FADE = 'capsule_fade',
}

/**
 * 组件属性默认值
 */
export enum WDefault {
  MAX_VALUE = 1
}

/**
 * 胶囊操作类型
 */
export enum HandleType {
  ADD = 'add',
  UPDATE = 'update',
}

/**
 * 实况常量
 *
 * @since 2023-11-24
 */
export class LiveViewCommonConstants {
  static readonly LOG_PREFIX: string = '[LiveViewBase]';

  /**
   * 实况卡片背景颜色
   */
  static readonly ITEM_BG_COLOR = '#99FAFAFA';

  /**
      * 锁屏通知动效卡片背景颜色
      */
    static readonly ITEM_LOCK_NTF_BG_COLOR = '#FAFAFA';

  /**
   * 实况卡片背景圆角
   */
  static readonly ITEM_BG_RADIUS = 16;

  /**
   * 实况卡片背景模糊半径
   */
  static readonly ITEM_BG_BLUR = 30;

  /**
   * 小折叠外屏实况卡片固定区域高度
   */
  static readonly SMALL_FOLD_OUTER_CARD_FIXED_AREA_HEIGHT = 40;

  /**
   * 小图标大小
   */
  static readonly LIVE_SMALL_ICON_SIZE = 16;

  /**
   * 小图标圆角大小
   */
  static readonly LIVE_SMALL_ICON_BORDER_RADIUS = 4;

  /**
   * 小图标间距
   */
  static readonly LIVE_SMALL_ICON_MARGIN = -4;

  /**
   * SIM卡图标上间距
   */
  static readonly LIVE_SIM_PADDING_TOP = 1;

  /**
   * SIM卡图标右间距
   */
  static readonly LIVE_SIM_PADDING_RIGHT = 2;

  /**
   * SIM卡图标下间距
   */
  static readonly LIVE_SIM_PADDING_BOTTOM = 2;

  /**
   * 默认时间值
   */
  static readonly DEDAULT_TIME_TEXT = '00:00';

  /**
   * mm:ss最大秒数
   */
  static readonly MAX_HOUR_TIME = TimeItem.MIN_ITEM * TimeItem.MIN_ITEM;

  /**
   * HH:mm:ss最大秒数
   */
  static readonly MAX_DAY_TIME = TimeItem.HOUR_ITEM * TimeItem.SEC_ITEM * TimeItem.SEC_ITEM;

  /**
   * HH:mm:ss秒数 倒计时最大99时99分99秒
   */
  static readonly MAX_TIME_TEXT = TimeItem.SEC_ITEM * TimeItem.MIN_ITEM * TimeItem.MAX_HOURS_ITEM;

  /**
   * 1s = 1000 ms
   */
  static readonly ONE_SECOND_TO_MILLISECOND: number = 1000;

  /**
   * 倒计时最大99时99分99秒, ms数
   */
  static readonly MAX_TIME_MILLS = TimeItem.SEC_ITEM * TimeItem.MIN_ITEM * TimeItem.MAX_HOURS_ITEM *
  TimeItem.MILLISECOND_ITEM;

  /**
   * 倒计时文本
   */
  static readonly COUNTDOWN_TEXT = '--:--';

  /**
   * 大字体倒计时文本字号
   */
  static readonly BIG_TIMER_FONT_SIZE = 14;

  /**
   * 数字正则表达式，匹配整数或小数，小数最多4位
   */
  static readonly NUM_REGX: RegExp = /\d+(\.\d{1,4})?/g;

  /**
   * 数字模糊替换字符
   */
  static readonly NUM_FUZZ: string = '--';

  /**
   * 最大长度
   */
  static readonly MAX_LENGTH = 2;

  /**
   * 定时器周期时间间隔ms
   */
  static readonly INITIAL_TIME = 1000;

  /**
   * 计时器更新单位：1s
   */
  static readonly ONE_SECOND = 1;

  /**
   * 时间不更新
   */
  static readonly INVALID_TIME = -1;

  /**
   * 大桌面上下文
   */
  static readonly CONTEXT: string = 'desktopContext';

  /**
   * 来电SIM卡1图标
   */
  static sim1Icon?: Resource;

  /**
   * 来电SIM卡2图标
   */
  static sim2Icon?: Resource;

  /**
   * 系统实况字体覆盖区域
   */
  static readonly SYSTEM_CARD_FONT_AREA = 32;

  /**
   * 三方实况固定区域字体覆盖区
   */
  static readonly OTHER_CARD_FONT_FIXED_AREA = 34;

  /**
   * 播控字体覆盖区
   */
  static readonly BROADCASTING_FONT_AREA = 49;

  /**
   * push包名
   */
  static readonly PUSH_BUNDLE_NAME = 'com.ohos.pushservice';

  /**
   * 录屏计时器胶囊文字组件名称
   */
  static readonly CAPSULE_SCREEN_RECORD_TIMER_CONTENT = 'CapsuleScreenRecordTimerContent';

  /**
   * 设置SIM卡图标
   *
   * @param sim1 卡1
   * @param sim2 卡2
   */
  static setSimIcon(sim1: Resource, sim2: Resource): void {
    LiveViewCommonConstants.sim1Icon = sim1;
    LiveViewCommonConstants.sim2Icon = sim2;
  }

  /**
   * 获取卡片内容组件ID标识
   *
   * @param cardId 通知数据ID
   * @param scene 组件使用场景
   * @returns 组件ID
   */
  static getItemContentId(cardId?: string, scene?: LiveUseScene): string {
    return 'live_item_content_' + scene + '_' + cardId;
  }

  static formatDate(millSecondCount: number | undefined, dateFormat: Date | undefined, isCountDown: boolean,
                    hideSeconds = false): string {
    if (!millSecondCount || !dateFormat) {
      return LiveViewCommonConstants.DEDAULT_TIME_TEXT;
    }
    dateFormat.setHours(0, 0, 0, 0);
    let secondCount = Math.floor(millSecondCount / LiveViewCommonConstants.ONE_SECOND_TO_MILLISECOND);
    if (isCountDown) {
      secondCount = Math.ceil(millSecondCount / LiveViewCommonConstants.ONE_SECOND_TO_MILLISECOND);
    }
    dateFormat.setSeconds(secondCount);
    const minutes = dateFormat.getMinutes().toString().padStart(LiveViewCommonConstants.MAX_LENGTH, '0');
    const seconds = dateFormat.getSeconds().toString().padStart(LiveViewCommonConstants.MAX_LENGTH, '0');
    let result = minutes + ':' + seconds;
    if (secondCount < LiveViewCommonConstants.MAX_HOUR_TIME) {
      return result;
    } else if (secondCount < LiveViewCommonConstants.MAX_TIME_TEXT) {
      let hours = dateFormat.getHours() + TimeItem.HOUR_ITEM *
        Math.floor(secondCount / LiveViewCommonConstants.MAX_DAY_TIME);
      if (hideSeconds) {
        return hours + ':' + minutes;
      }
      let res = hours.toString().padStart(LiveViewCommonConstants.MAX_LENGTH, '0') + ':' + result;
      return res;
    } else {
      return LiveViewCommonConstants.DEDAULT_TIME_TEXT;
    }
  }

  /**
   * 获取适配大字体卡片高度
   *
   * @param height 卡片基础高度
   * @param scale 字体放大倍数
   * @param area 字段区域大小
   */
  static getCardHeight(height: number, scale: number, area: number): number {
    const increase = scale - 1 < 0 ? 0 : scale - 1;
    return height + increase * area;
  }
}