/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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

import { uiEffect } from '@kit.ArkGraphics2D';
import { power, thermal } from '@kit.BasicServicesKit';

export class SCBAiBarConstants {
  public static readonly DEFAULT_CAPSULE_HEIGHT = 24;
  public static readonly DEFAULT_CAPSULE_WIDTH = 112;
  public static readonly DRAG_TO_VOICE_FONT_SIZE = 14;
  public static readonly HOT_AREA_WIDTH: number = 280;
  // 导航条初始态高度:5vp
  public static readonly CAPSULE_HEIGHT_INIT: number = 5;
  // 胶囊圆角：初始态
  public static readonly CAPSULE_RADIUS_INIT = this.CAPSULE_HEIGHT_INIT / 2;
  // 初始态: 图文透明度0
  public static readonly TIPS_OPACITY_INIT: number = 0;
  // 初始态: 图文大小0.6
  public static readonly TIPS_SCALE_INIT: number = 0;
  public static readonly GESTURE_NAV_BOTTOM_HOTAREA_HEIGHT = 28;
  public static readonly CAPSULE_HEIGHT_DRAG_RESPONSE: number = SCBAiBarConstants.GESTURE_NAV_BOTTOM_HOTAREA_HEIGHT - 4;
  public static readonly GESTURE_NAV_AI_BAR_HEIGHT = this.CAPSULE_HEIGHT_INIT;
  public static readonly GESTURE_NAV_AI_BAR_WIDTH_DEFAULT = 112;
  public static readonly GESTURE_NAV_AI_BAR_WIDTH_DEFAULT_PAD = 262;
  public static readonly GESTURE_NAV_AI_BAR_EFFECT_BLUR_RADIUS = 30;
  public static readonly GESTURE_NAV_AI_BAR_EFFECT_COLOR = '#33ffffff';
  public static readonly GESTURE_NAV_AI_BAR_EFFECT_COLOR_PAD = '#66ffffff';
  public static readonly SHADOW_COLOR_START = '#00000000';
  public static readonly SHADOW_COLOR_END = '#4D000000';
  public static readonly GESTURE_NAV_AI_BAR_OPACITY = 1;
  // 状态栏高度，用于拖拽中转站热区计算
  public static readonly SCREEN_STATUS_HEIGHT: number = 36;

  // 导航条底板距离导航条左右距离
  public static readonly AI_BAR_GAP_BETWEEN_BACKGROUND_AND_BAR: number = 6;
  // 导航条底板默认高度
  public static readonly AI_BAR_BACKGROUND_DEFAULT_HEIGHT: number =
    this.CAPSULE_HEIGHT_INIT + this.AI_BAR_GAP_BETWEEN_BACKGROUND_AND_BAR * 2;
  // 导航条底板默认宽度
  public static readonly AI_BAR_BACKGROUND_DEFAULT_WIDTH: number = 126;
  public static readonly WIDTH_THRESHOLD_SMALL: number = 600;
  public static readonly WIDTH_THRESHOLD_MIDDLE: number = 840;
  public static readonly CAPSULE_DISAPPEAR_TIME: number = 11500;
  public static readonly CAPSULE_RADIUS: string = 'sys.float.ohos_id_corner_radius_tips_instant_tip';
  public static readonly CAPSULE_TEXT_COLOR: string = 'sys.color.ohos_id_color_text_primary';
  public static readonly DARK_COLOR_MODE: number = 0;
  public static readonly CAPSULE_CONTENT_MARGIN: number = 2;
  public static readonly CAPSULE_CONTENT_RIGHT_MARGIN: number = 12;
  public static readonly AIBAR_DEFAULT_BOTTOM_MARGIN = 6;
  public static readonly CAPSULE_BACKDROP_BLUR: number = 80;
  public static readonly CAPSULE_SATURATE: number = 1.9;
  public static readonly CAPSULE_TEXT_SIZE: Resource = $r('sys.float.ohos_id_text_size_button2');
  public static readonly CAPSULE_IMG_SIZE: number = 20;
  public static readonly CAPSULE_HEIGHT: number =
    SCBAiBarConstants.CAPSULE_IMG_SIZE + SCBAiBarConstants.CAPSULE_CONTENT_MARGIN * 2;
  public static readonly TEXT_HEIGHT: number = 20;
  public static readonly NOTIFICATION_BAR_WIDTH: number = 120;
  public static readonly NOTIFICATION_BAR_HEIGHT: number = 8;
  // 24vp * 2，UX要求AI导航条宽度比锁屏胶囊两侧各少24vp
  public static readonly AIBAR_MARGIN: number = 48;
  // 导航长度
  public static readonly NAVIGATION_LENGTH_BASE: number = 4;
  // 动效延时时间
  public static readonly APPEAR_DELAY: number = 300;
  // 动效的偏移量
  public static readonly ANIMATION_OFFSET: number = 1;
  // AI导航条颜色构成1
  public static readonly WEAK_NOTIFY_COLOR_ONE: Array<[ResourceColor, number]> =
    [[('#FFC788'), 0], [('#BEA1FE'), 0.125],
      [('#6C8CFB'), 0.25], [('#BEA1FE'), 0.375], [('#FFC788'), 0.5],
      [('#BEA1FE'), 0.625], [('#6C8CFB'), 0.75], [('#BEA1FE'), 0.875], [('#FFC788'), 1]];
  // AI导航条时间阶段分配
  public static readonly WEAK_NOTIFY_DURATION_LIST: Array<number> = [500, 800, 700, 1000, 800, 700, 500];
  // AI导航条动效帧率
  public static readonly ANIMATE_FRAME_RATE_RANGE: ExpectedFrameRateRange = {
    min: 20,
    max: 60,
    expected: 40,
  };
  // 动效消失的延时时间
  public static readonly DISAPPEAR_DELAY: number = 50;
  // 动效延时时间
  public static readonly DRAG_DELAY: number = 50;
  // 点击返回
  public static readonly CLICK_BACK: string = 'click_back';
  // 天生绘画keyName
  public static readonly NATURAL_PAINTING_NAME: string = 'com.ohos.hicreateEntryAbilitytablet';
  // 笔记keyName
  public static readonly OpenHarmony_NOTES_NAME: string = 'com.ohos.hinoteHiNotePcMainAbilityHiNotePc';
  // 配置防误触功能的应用名称列表
  public static readonly MIS_TOUCH_APP_LIST: string[] = [this.NATURAL_PAINTING_NAME, this.OpenHarmony_NOTES_NAME];
  public static readonly SUPPORT_USE_NEW_EFFECT: string = 'support_anim_6_0';

  public static readonly BRIGHTNESS_OPTIONS_TYPE1: BrightnessOptions = {
    rate: 0.8718,
    lightUpDegree: 30 / 255,
    cubicCoeff: -0.457060725,
    quadCoeff: 0.4845,
    saturation: 1.2,
    posRGB: [1, 0.5, 1],
    negRGB: [1.2, 1, 1],
    fraction: 0
  };

  public static readonly BRIGHTNESS_OPTIONS_TYPE2: BrightnessOptions = {
    rate: 1,
    lightUpDegree: -15 / 255,
    cubicCoeff: 0,
    quadCoeff: 0,
    saturation: 1.35,
    posRGB: [1, 0.5, 0.5],
    negRGB: [1.5, 1.5, 1],
    fraction: 0
  };

  public static readonly BRIGHTNESS_OPTIONS_TYPE3: BrightnessOptions = {
    rate: 1,
    lightUpDegree: -20 / 255,
    cubicCoeff: 0,
    quadCoeff: 0,
    saturation: 1.7,
    posRGB: [0.6, 0.5, 0.5],
    negRGB: [0.3, 1, 1],
    fraction: 0
  };

  public static readonly BRIGHTNESS_OPTIONS_TYPE4: BrightnessOptions = {
    rate: 1,
    lightUpDegree: 25 / 255,
    cubicCoeff: 0,
    quadCoeff: 0,
    saturation: 1.2,
    posRGB: [1, 0.5, 1],
    negRGB: [1.2, 1, 1],
    fraction: 0
  };

  public static readonly BRIGHTNESS_OPTIONS_AOD: BrightnessOptions = {
    rate: 1,
    lightUpDegree: 0,
    cubicCoeff: 0,
    quadCoeff: 0,
    saturation: 1,
    posRGB: [0, 0, 0],
    negRGB: [0, 0, 0],
    fraction: 0.2
  };

  // 浅色模式下的最下层导航条颜色
  public static readonly LIGHT_DRAG_BG_COLOR: ResourceColor = '#00808080';
  // 浅色模式下的最下层导航条描边颜色
  public static readonly LIGHT_DRAG_BG_EFFECT: BackgroundEffectOptions = {
    radius: 120,
    saturation: 1.6,
    brightness: 1.2,
    color: '#00FFFFFF'
  };
  // 深色模式下的最下层导航条颜色
  public static readonly DARK_DRAG_BG_COLOR: ResourceColor = '#00808080';
  // 深色模式下的最下层导航条描边颜色
  public static readonly DARK_DRAG_BG_EFFECT: BackgroundEffectOptions = {
    radius: 200,
    saturation: 1,
    brightness: 1,
    color: '#00000000'
  };
  // DELIVER纯色导航条颜色
  public static readonly DELIVER_AIBAR_COLOR: ResourceColor = '#FF808080';
  // 如果应用内处于低功耗或过热模式，使用纯色
  public static readonly LOW_POWER_AIBAR_COLOR: ResourceColor = '#ff999999';
  // 导航条纯色高温级别
  public static readonly OVERHEAT_LEVEL = thermal.ThermalLevel.NORMAL;
  // 导航条纯色电源模式级别
  public static readonly LOW_POWER_LEVEL = power.DevicePowerMode.MODE_POWER_SAVE;
  // 桌面导航条模糊半径
  public static readonly DESKTOP_AIBAR_BLUR_RADIUS: number = 45;
  public static readonly SHADOW_BLUR_OFFSET_Y = 20;
  public static readonly SHADOW_BLUR_RADIUS = 60;

  // 克隆字段
  public static readonly SETTING_DATA_DB_CLONE_FLAG = 'settingsCloneStatus';
  // 当前正在克隆
  public static readonly SETTING_DATA_DB_CLONE_FLAG_DEFAULT_OPEN_VALUE = '1';

  // 亮灭屏事件开始标记
  public static readonly EVENT_STATUS_BEGIN = 0;
  // 亮屏事件
  public static readonly DISPLAY_POWER_EVENT_WAKE_UP = 0;
  // 灭屏事件
  public static readonly DISPLAY_POWER_EVENT_SLEEP = 1;
  // 用-1表示当前值无意义或者尚未初始化过
  public static readonly NO_INIT_STATUS = -1;

  // 悬浮导航常量
  /**
   * 开关关闭值
   */
  public static readonly FLOATING_NAVIGATION_SWITCH_OFF_VALUE: string = '1';
  /**
   * 开关打开值
   */
  public static readonly FLOATING_NAVIGATION_SWITCH_ON_VALUE: string = '0';
  /**
   * 悬浮导航隐藏值
   */
  public static readonly FLOATING_NAVIGATION_HIDDEN_VALUE: string = '0';
  /**
   * 悬浮导航显示值
   */
  public static readonly FLOATING_NAVIGATION_SHOW_VALUE: string = '1';

  /**
   * 无效位置样式
   */
  public static readonly BUTTON_POSITION_STYLE_INVALID: string = '-1';

  /**
   * 无效定时器ID
   */
  public static readonly TIME_OUT_ID_INVALID: number = -1;

  /**
   * 默认位置样式
   */
  public static readonly BUTTON_POSITION_STYLE_DEFAULT: string = '0';

  /**
   * 三键位置样式1
   */
  public static readonly BUTTON_POSITION_STYLE_ONE: string = '1';

  /*
  * 极花壁纸色阶
  */
  public static readonly EXTREMELY_FLOWERY_PICTURE: number = 6;

  /**
   * 绘制起始位置x坐标
   */
  public static readonly PATH_SHAPE_START_X: number = 18;

  /**
   * 绘制起始位置y坐标
   */
  public static readonly PATH_SHAPE_START_Y: number = 4;

  /**
   * 绘制圆的半径
   */
  public static readonly PATH_SHAPE_RADIUS: number = 10;

  /**
   * 绘制结束位置的y坐标
   */
  public static readonly PATH_SHAPE_END_Y: number = 16;
}

export enum AiBarChangeType {
  SHOW_BAR,
  HIDE_BAR
}