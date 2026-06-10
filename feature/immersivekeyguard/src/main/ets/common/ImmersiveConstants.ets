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

import { DeviceHelper } from '@ohos/frameworkwrapper';


interface ErrorCode {
  NO_PERMISSION: number,
  LOCATION_SWITCH_OFF: number
}

/**
 * 沉浸锁屏常量
 *
 * @since 2024-02-27
 */
export class ImmersiveConstants {
  /**
   * 日志前缀
   */
  public static readonly LOG_PREFIX: string = '[IMMERSIVE_KEYGUARD]';

  /**
   * 一镜到底动效名称
   */
  public static readonly IMMERSIVE_ONE_MIRROR_SCENE: string = 'oneMirror';

  /**
   * 通知列表组件padding间距值
   */
  public static readonly NTF_LIST_PADDING = $r('app.float.ntf_list_item_padding_start_end');

  /**
   * 通知列表容器参数
   */
  public static readonly NOTIFICATION_LIST_MARGIN_TOP = 16;

  /**
   * 通知列表底部间距
   */
  public static readonly NOTIFICATION_LIST_MARGIN_BOTTOM = 16;

  /**
   * 沉浸列表裁切偏移量
   */
  public static readonly LIST_ROOT_OFFSET = 4;

  /**
   * 沉浸列表圆角
   */
  public static readonly LIST_ROOT_RADIUS = 16;

  /**
   * 时钟位移延迟
   */
  public static readonly CLOCK_DELAY_TIME = 50;


  public static readonly LOCATION_ERROR_CODE: ErrorCode = {
    /**
     * 应用无授权位置信息错误码
     */
    NO_PERMISSION: 201,

    /**
     * 系统位置权限未开启错误码
     */
    LOCATION_SWITCH_OFF: 3301100
  };

  /**
   * 位置权限
   */
  public static readonly APPROXIMATELY_LOCATION = 'ohos.permission.APPROXIMATELY_LOCATION';

  /**
   * settings bundle name
   */
  public static readonly SETTINGS_BUNDLE_NAME = 'com.ohos.settings';

  /**
   * settings ability name
   */
  public static readonly SETTINGS_ABILITY_NAME = 'com.ohos.settings.MainAbility';

  /**
   * settings location manager uri
   */
  public static readonly LOCATION_MANAGER_URI = 'location_manager_settings';

  /**
   * settings application entry uri
   */
  public static readonly APPLICATION_ENTRY_URI = 'application_info_entry';

  /**
   * 胶囊主文本高度
   */
  public static readonly TITLE_TIMER_HEIGHT = 19;

  /**
   * 胶囊主文本字体大小
   */
  public static readonly TITLE_TIMER_FONT_SIZE = 14;

  /**
   * 胶囊副文本高度
   */
  public static readonly CONTENT_TIMER_HEIGHT = 17;

  /**
   * 胶囊副文本字体大小
   */
  public static readonly CONTENT_TIMER_FONT_SIZE = 12;

  /**
   * SOLID模式下时钟模糊提亮默认策略
   */
  public static readonly IMMERSIVE_CLOCK_SOLID_BLUR_POLICY: number = 1;

  /**
   * SOLID模式下时钟模糊提亮默认半径
   */
  public static readonly IMMERSIVE_CLOCK_SOLID_BLUR_RADIUS: number = 25;

  /**
   * SOLID模式下时钟模糊提亮默认参数
   */
  public static readonly IMMERSIVE_CLOCK_SOLID_BLUR_CFG: BackgroundEffectOptions = {
    policy: ImmersiveConstants.IMMERSIVE_CLOCK_SOLID_BLUR_POLICY,
    radius: ImmersiveConstants.IMMERSIVE_CLOCK_SOLID_BLUR_RADIUS,
  };

  /**
   * 沉浸卡片组件ID
   */
  public static readonly IMMERSIVE_CARD_ITEM_ID: string = 'immersiveCardItemWrap';

  private static readonly VALID_UI_EXTENSION_WANTS = new Map([
    // 运动健康
    ['com.ohos.health', 'LiveViewAbility'],
    // Petal出行
    ['com.ohos.maps.app', 'NavigationLiveView'],
    // 美团
    ['com.sankuai.hmeituan', 'MtLiveViewLockScreenExtAbility'],
    // 东方航空
    ['com.ceair.hos', 'LiveLockScreenExtAbility'],
    // 高德地图
    ['com.amap.hmapp', 'LiveViewExtAbility'],
    // 情景模式
    ['com.ohos.intelligentscene', 'IntelligentSceneUIExtLockScreenAbility'],
  ]);

  private static readonly VALID_INTERACT_WANTS = new Map([
    // 美团
    ['com.sankuai.hmeituan', 'MtLiveViewLockScreenExtAbility'],
    // 情景模式
    ['com.ohos.intelligentscene', 'IntelligentSceneUIExtLockScreenAbility'],
  ]);

  /**
   * 小外屏沉浸卡片实况窗去授权按钮组件ID
   */
  public static readonly IMMERSIVE_GO_TO_AUTH_BTN_ID = 'ImmersiveCard_Go_Auth_Btn_ID';

  /**
   * 获取通知列表paddingTop值
   *
   * @returns 通知列表paddingTop值
   */
  public static getNtfListPaddingTop(): number {
    return KeyguardConstants.getKgMinHeight();
  }

  /**
   * 获取通知列表paddingBottom值
   *
   * @returns 通知列表paddingBottom值
   */
  public static getNtfListPaddingBottom(): number {
    return ImmersiveConstants.NOTIFICATION_LIST_MARGIN_BOTTOM;
  }

  /**
   * 获取沉浸锁屏组件id
   *
   * @param srcID 原始id
   * @returns 在原始id之前，加上沉浸锁屏特有标识
   */
  public static getImmersiveID(srcID: string): string {
    return ImmersiveConstants.LOG_PREFIX + '_' + srcID;
  }

  /**
   * 判断是否是有效的可以通过UiExtension拉起的want
   *
   * @param bundleName 包名
   * @param abilityName abilityName
   * @returns true 有效的
   */
  public static isValidUiExtensionWant(bundleName?: string, abilityName?: string): boolean {
    if (!bundleName || !abilityName) {
      return false;
    }
    if (!ImmersiveConstants.VALID_UI_EXTENSION_WANTS.has(bundleName)) {
      return false;
    }
    if (ImmersiveConstants.VALID_UI_EXTENSION_WANTS.get(bundleName) === abilityName) {
      return true;
    }
    return false;
  }

  /**
   * 判断是否在UIExtension支持透传的白名单内
   *
   * @param bundleName 包名
   * @param abilityName abilityName
   * @returns true 在白名单内
   */
  public static isInInteractWhiteList(bundleName?: string, abilityName?: string): boolean {
    if (!bundleName || !abilityName) {
      return false;
    }
    if (!ImmersiveConstants.VALID_INTERACT_WANTS.has(bundleName)) {
      return false;
    }
    if (ImmersiveConstants.VALID_INTERACT_WANTS.get(bundleName) === abilityName) {
      return true;
    }
    return false;
  }
}

/**
 * 锁屏元素参数, 用于设置列表可占用的最大范围, 锁屏布局算法替换后移除
 */
export class KeyguardConstants {
  /**
   * 天气时钟主题 时钟、日期高度
   */
  public static readonly NARROW_DOWN_CLOCK_VIWE_HEIGHT = 124;

  /**
   * 普通主题 时钟、日期高度
   */
  public static readonly TIME_VIEW_HEIGHT_IN_LAND: number = 130;
  public static readonly DATE_VIEW_HEIGHT_IN_LAND: number = 20;

  /**
   * 时钟、日期间距值
   */
  public static readonly CLOCK_VIEW_MARGIN_TOP_DEFAULT: number = 8;
  public static readonly CLOCK_VIEW_MARGIN_TOP_PAD_DEFAULT: number = 6;

  /**
   * 网格起始点
   */
  public static readonly MESH_START: number = 0;

  /**
   * 网格默认终点
   */
  public static readonly MESH_END: number = 7;

  /**
   * 锁屏时钟默认占用网格数
   */
  public static readonly DEFAULT_CLOCK_LAYOUT_AMOUNT_Y: number = 4;

  /**
   * 获取锁屏时钟、日期占用最小高度
   *
   * @returns 锁屏时钟、日期占用最小高度
   */
  public static getKgClockMinHeight(): number {
    let clockViewHeight = (DeviceHelper.isPhone() && !DeviceHelper.isFold() || DeviceHelper.isPad()) ?
      KeyguardConstants.NARROW_DOWN_CLOCK_VIWE_HEIGHT :
      (KeyguardConstants.TIME_VIEW_HEIGHT_IN_LAND + KeyguardConstants.DATE_VIEW_HEIGHT_IN_LAND);
    let marginTop = DeviceHelper.isPhone() ? KeyguardConstants.CLOCK_VIEW_MARGIN_TOP_DEFAULT :
      KeyguardConstants.CLOCK_VIEW_MARGIN_TOP_PAD_DEFAULT;
    return clockViewHeight + marginTop;
  }

  /**
   * 获取锁屏元素占用最小高度
   *
   * @returns 锁屏元素占用最小高度
   */
  public static getKgMinHeight(): number {
    return KeyguardConstants.getKgClockMinHeight();
  }
}

/**
 * 沉浸锁屏状态
 */
export enum ImmersiveStatus {
  /**
   * 锁屏胶囊
   */
  CAPSULE,

  /**
   * 沉浸卡片
   */
  IMMERSIVE,

  /**
   * 通知列表
   */
  LIST
}

/**
 * 沉浸胶囊显示位置类型
 */
export enum CapsulePositionType {
  /**
   * 无类型
   */
  TYPE_NONE = 'none',

  /**
   * 内容胶囊
   */
  TYPE_CONTENT = 'content',

  /**
   * 阴影胶囊
   */
  TYPE_SHADOW = 'shadow',

  /**
   * 强提醒胶囊
   */
  TYPE_REMIND = 'remind',

  /**
   * 动效内容胶囊
   */
  TYPE_ANIM_CONTENT = 'animContent',

  /**
   * 动效阴影胶囊
   */
  TYPE_ANIM_SHADOW = 'animShadow',
}

/**
 * 动效卡片类型
 */
export enum CardAnimType {
  /**
   * 更新场景卡片
   */
  CARD_UPDATE_TYPE = 'card_update_type',

  /**
   * 切换场景卡片
   */
  CARD_TOGGLE_TYPE = 'card_toggle_type',

  /**
   * 在小外屏显示沉浸卡片大图
   */
  CARD_LIVE_IMAGE_TYPE = 'card_live_image_type',

  /**
   * 在小外屏显示沉浸卡片内容
   */
  CARD_LIVE_CONTENT_TYPE = 'card_live_content_type',

  /**
   * 在小外屏显示沉浸卡片返回按钮
   */
  CARD_LIVE_BACK_BTN_TYPE = 'card_live_back_btn_type',
}

/**
 * 沉浸实况权益级别
 */
export enum ImmersiveCardAuthLevel {
  INVALID_AUTH = -1,
  NO_RIGHT = 0, //不支持进入沉浸态
  STATIC_IMAGE_RIGHT = 1, //支持进入沉浸态
  DYNAMIC_IMAGE_RIGHT = 2,
  DYNAMIC_IMAGE_RIGHT_WITH_INTERACTION = 3 //支持进入沉浸态且支持交互
}

// 沉浸数据类型
export enum ImmDataType {
  DATA_CAP, // 胶囊数据
  DATA_CARD, // 大卡数据
  DATA_LIST, // 列表数据
}

// 沉浸通知隐私类型
export enum ImmPrivacyType {
  PRIVACY_NONE, // 无隐私
  PRIVACY_HIDE_CONTENT, // 隐藏内容
  PRIVACY_APP_LOCK, // 应用锁
}