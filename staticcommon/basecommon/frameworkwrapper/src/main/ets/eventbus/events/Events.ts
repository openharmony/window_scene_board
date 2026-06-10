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

import type { Configuration } from '@ohos.app.ability.Configuration';
import type Display from '@ohos.display';
import type Window from '@ohos.window';
import type AccountMgr from '@ohos.account.osAccount';
import type { PluginInfo } from '../../plugin/PluginInfo';
import { PluginConstants } from '../../plugin/PluginConstants';
import type { PluginPosition } from '../../plugin/PluginConstants';
import type audio from '@ohos.multimedia.audio';
import type { ViewArea as ScreenRect } from '../../manager/view/ViewManagerPolicy';
import type InputMethodSubtype from '@ohos.InputMethodSubtype';
import type appManager from '@ohos.app.ability.appManager';
import { inputMethod } from '@kit.IMEKit';
import { CommonComponent } from '../../schedule/AnimPolicyRegistry';

/**
 * configuration属性变化事件
 *
 * @since 2022-09-16
 */
export class ConfigurationEvent {
  /**
   * 属性
   */
  config?: Configuration;
}

Object.defineProperty(ConfigurationEvent, 'eventTypeName', { value: 'ConfigurationEvent' });

export class SolidColorEvent {
  /* 全屏 */
  public static FULL = 'FULL';

  /* 顶部20% */
  public static TOP20 = 'TOP20';

  /**
   * 场景
   */
  scene: string;

  constructor(scene: string) {
    this.scene = scene;
  }
}

Object.defineProperty(SolidColorEvent, 'eventTypeName', { value: 'SolidColorEvent' });

/**
 * 挖孔区域变化事件
 */
export class CutoutEvent {
  /**
   * 左侧挖孔
   */
  static readonly CUTOUT_LEFT = 1;

  /**
   * 中间挖孔
   */
  static readonly CUTOUT_MID = 2;

  /**
   * 右侧挖孔
   */
  static readonly CUTOUT_RIGHT = 3;

  /**
   * 挖孔位置
   */
  cutoutPosition: number;

  /**
   * 挖孔区域大小
   */
  cutoutRect: ScreenRect;

  /**
   * 创建事件
   *
   * @param position 位置
   * @param rect 区域
   * @return 事件
   */
  static create(position: number, rect: ScreenRect): CutoutEvent {
    let event = new CutoutEvent();
    event.cutoutPosition = position;
    event.cutoutRect = rect;
    return event;
  }
}

Object.defineProperty(CutoutEvent, 'eventTypeName', { value: 'CutoutEvent' });

/**
 * 瀑布曲面屏周边曲面区域变化事件
 */
export class WaterfallEvent {
  /**
   * 曲面四周区域
   * TODO
   */
  areaRects: Display.WaterfallDisplayAreaRects;
}

Object.defineProperty(WaterfallEvent, 'eventTypeName', { value: 'WaterfallEvent' });

/**
 * 窗口可见性事件
 */
export class WindowEvent {
  /**
   * 窗口事件类型-展开窗口
   */
  static readonly EVENT_TYPE_SHOW = 0;

  /**
   * 窗口事件类型-隐藏窗口
   */
  static readonly EVENT_TYPE_HIDE = 1;

  /**
   * 窗口事件状态-开始展开/隐藏
   */
  static readonly EVENT_STATE_START = 0;

  /**
   * 窗口事件状态-结束展开/隐藏
   */
  static readonly EVENT_STATE_END = 1;

  /**
   * 事件类型
   */
  eventType: number;

  /**
   * 事件状态
   */
  eventState: number;

  /**
   * 窗口名称
   */
  windowName: string;

  /**
   * 设置窗口名称
   *
   * @param windowName 窗口名称
   * @return 链式
   */
  setWindowName(windowName: string): WindowEvent {
    this.windowName = windowName;
    return this;
  }

  /**
   * 窗口名是否匹配
   *
   * @param winName 目标窗口名
   * @return true匹配
   */
  isMatchName(winName: string): boolean {
    return this.windowName === winName;
  }

  /**
   * 是否窗口显示事件
   *
   * @return true显示事件
   */
  isWindowShow(): boolean {
    return this.eventType === WindowEvent.EVENT_TYPE_SHOW;
  }

  /**
   * 是否窗口开始显示事件
   *
   * @return true开始显示事件
   */
  isWindowStartShow(): boolean {
    return this.isWindowShow() && this.eventState === WindowEvent.EVENT_STATE_START;
  }

  /**
   * 是否窗口完全显示事件
   *
   * @return true完全显示事件
   */
  isWindowEndShow(): boolean {
    return this.isWindowShow() && this.eventState === WindowEvent.EVENT_STATE_END;
  }

  /**
   * 是否窗口隐藏事件
   *
   * @return true隐藏事件
   */
  isWindowHide(): boolean {
    return this.eventType === WindowEvent.EVENT_TYPE_HIDE;
  }

  /**
   * 是否窗口开始隐藏事件
   *
   * @return true开始隐藏事件
   */
  isWindowStartHide(): boolean {
    return this.isWindowHide() && this.eventState === WindowEvent.EVENT_STATE_START;
  }

  /**
   * 是否窗口完全隐藏事件
   *
   * @return true完全隐藏事件
   */
  isWindowEndHide(): boolean {
    return this.isWindowHide() && this.eventState === WindowEvent.EVENT_STATE_END;
  }
}

Object.defineProperty(WindowEvent, 'eventTypeName', { value: 'WindowEvent' });

/**
 * 请求窗口show/hide事件
 */
export class RequestWindowEvent {
  /**
   * 请求类型，show窗口
   */
  static readonly REQUEST_SHOW = 1;

  /**
   * 请求类型，hide窗口
   */
  static readonly REQUEST_HIDE = 2;

  /**
   * 请求类型，创建窗口
   */
  static readonly REQUEST_CREATE = 3;

  /**
   * 窗口名称
   */
  windowName: string;

  /**
   * 请求类型，show/hide
   */
  requestType: number;

  /**
   * 是否需要动效
   */
  hasWindowAnim: boolean = false;

  /**
   * 额外标记位
   */
  extrasFlag: string;

  /**
   * 请求show窗口
   */
  isRequestShow(): boolean {
    return this.requestType === RequestWindowEvent.REQUEST_SHOW;
  }

  /**
   * 请求hide窗口
   */
  isRequestHide(): boolean {
    return this.requestType === RequestWindowEvent.REQUEST_HIDE;
  }

  /**
   * 请求创建窗口
   */
  isRequestCreate(): boolean {
    return this.requestType === RequestWindowEvent.REQUEST_CREATE;
  }

  /**
   * 创建事件
   *
   * @param windowName 窗口名
   * @param requestType 请求类型
   */
  static create(windowName: string, requestType: number): RequestWindowEvent {
    let event = new RequestWindowEvent();
    event.windowName = windowName;
    event.requestType = requestType;
    return event;
  }
}

Object.defineProperty(RequestWindowEvent, 'eventTypeName', { value: 'RequestWindowEvent' });

/**
 * 桌面状态栏显示OR隐藏事件
 */
export class LauncherStatusBarEvent {
  /**
   * 桌面状态栏显示
   */
  static readonly STATUS_SHOW = 0;

  /**
   * 桌面状态栏隐藏
   */
  static readonly STATUS_HIDE = 1;

  /**
   * 状态栏是否需要显示 0：显示 1：隐藏
   */
  statusBarVisible: number;

  /**
   * 创建事件
   *
   * @param sbVisible 是否当前状态显示
   */
  static create(sbVisible: number): LauncherStatusBarEvent {
    let event = new LauncherStatusBarEvent();
    event.statusBarVisible = sbVisible;
    return event;
  }
}

Object.defineProperty(LauncherStatusBarEvent, 'eventTypeName', { value: 'LauncherStatusBarEvent' });

/**
 * 最近使用的元服务事件
 */
export class RecentlyUseEvent {
  /**
   * 打开的应用信息
   */
  abilityStateData: appManager.AbilityStateData;

  constructor(abilityStateData: appManager.AbilityStateData) {
    this.abilityStateData = abilityStateData;
  }
}

Object.defineProperty(RecentlyUseEvent, 'eventTypeName', { value: 'RecentlyUseEvent' });

/**
 * 最近使用的元服务语言切换事件
 */
export class RecentlyUseConfigurationEvent {}

Object.defineProperty(RecentlyUseConfigurationEvent, 'eventTypeName', { value: 'RecentlyUseConfigurationEvent' });

/**
 * 多用户切换事件
 */
export class AccountEvent {
  /**
   * 当前用户信息
   */
  accountInfo?: AccountMgr.OsAccountInfo;
}

Object.defineProperty(AccountEvent, 'eventTypeName', { value: 'AccountEvent' });

export class UserSwitchEvent {
  userActive: boolean;
}
Object.defineProperty(UserSwitchEvent, 'eventTypeName', { value: 'UserSwitchEvent' });

/**
 * plugin解析事件
 */
export class PluginEvent {
  /**
   * 事件类型
   * 查询全部/新增plugin/更新plugin/删除plugin
   * @see PluginConstants
   */
  eventType: number;

  /**
   * plugin action
   */
  action: string;

  /**
   * plugin信息集
   */
  pluginInfos: Array<PluginInfo>;
}

Object.defineProperty(PluginEvent, 'eventTypeName', { value: 'PluginEvent' });

/**
 * 状态栏plugin解析事件
 */
export class PluginStatusBarEvent extends PluginEvent {
  /**
   * 构造
   */
  constructor() {
    super();
    this.action = PluginConstants.ACTION_PLUGIN_STATUS_BAR;
  }
}

Object.defineProperty(PluginStatusBarEvent, 'eventTypeName', { value: 'PluginStatusBarEvent' });

/**
 * 控制中心plugin解析事件
 */
export class PluginToggleEvent extends PluginEvent {
  /**
   * 构造
   */
  constructor() {
    super();
    this.action = PluginConstants.ACTION_PLUGIN_TOGGLE;
  }
}

Object.defineProperty(PluginToggleEvent, 'eventTypeName', { value: 'PluginToggleEvent' });

/**
 * plugin数据更新事件
 */
export class PluginUpdateEvent {
  /**
   * 更新数据
   */
  newInfo: PluginInfo;

  /**
   * 创建事件
   *
   * @param info plugin数据
   */
  static create(info: PluginInfo): PluginUpdateEvent {
    let event = new PluginUpdateEvent();
    event.newInfo = info;
    return event;
  }
}

Object.defineProperty(PluginUpdateEvent, 'eventTypeName', { value: 'PluginUpdateEvent' });

/**
 * 图标红点事件
 */
export class IconRedHotEvent {
  /**
   * 图标唯一标示
   */
  iconSlot: string;

  /**
   * 是否显示红点
   */
  isShowRedHot: boolean;

  /**
   * 创建事件
   *
   * @param slot 唯一标示
   * @param isShowRedHot 是否显示红点
   */
  static create(slot: string, isShowRedHot: boolean): IconRedHotEvent {
    let event = new IconRedHotEvent();
    event.iconSlot = slot;
    event.isShowRedHot = isShowRedHot;
    return event;
  }
}

Object.defineProperty(IconRedHotEvent, 'eventTypeName', { value: 'IconRedHotEvent' });

/**
 * 状态栏沉浸式事件
 */
export class StatusBarTintEvent {
  /**
   * 不同区域的沉浸式数据
   */
  regionTint: Array<Window.SystemBarRegionTint>;
}

Object.defineProperty(StatusBarTintEvent, 'eventTypeName', { value: 'StatusBarTintEvent' });

/**
 * OOBE阶段变化事件
 */
export class OobeActivatedEvent {
  /**
   * 当前是否在OOBE阶段
   */
  isActivated: boolean;
}

Object.defineProperty(OobeActivatedEvent, 'eventTypeName', { value: 'OobeActivatedEvent' });

/**
 * 状态栏内容颜色事件
 * 主要用于锁屏状态栏跟随杂志锁屏切换内容颜色
 */
export class StatusBarContentEvent {
  /**
   * 状态栏类型
   *
   * @see StatusBarType
   */
  statusBarType: number;

  /**
   * 状态栏内容颜色
   */
  contentColor: string;

  /**
   * 创建事件
   *
   * @param type 状态栏类型
   * @param contentColor
   */
  static create(type: number, contentColor: string): StatusBarContentEvent {
    let event = new StatusBarContentEvent();
    event.statusBarType = type;
    event.contentColor = contentColor;
    return event;
  }
}

Object.defineProperty(StatusBarContentEvent, 'eventTypeName', { value: 'StatusBarContentEvent' });

/**
 * 状态栏背景颜色沉浸式事件
 * 只有桌面状态栏涉及沉浸式
 */
export class StatusBarBackgroundEvent {
  /**
   * 状态栏背景颜色集
   */
  bgColors: Array<string>;

  /**
   * 状态栏背景颜色区域集
   */
  regions: Array<Window.Rect>;

  /**
   * 状态栏背景色变化是否有动效
   */
  enableAnimations: Array<boolean>;

  /**
   * 创建事件
   *
   * @param colors 背景颜色集
   * @param regions 背景区域集
   */
  static create(colors: Array<string>, regions: Array<Window.Rect>): StatusBarBackgroundEvent {
    let event = new StatusBarBackgroundEvent();
    event.bgColors = colors;
    event.regions = regions;
    return event;
  }
}

Object.defineProperty(StatusBarBackgroundEvent, 'eventTypeName', { value: 'StatusBarBackgroundEvent' });

/**
 * 下拉事件
 */
export class DropDownEvent {
  static readonly DEFAULT_PULL_FRACTION = 0.3; // 初始跟手比

  /**
   * 下拉跟手幅度
   */
  pullFraction:number = DropDownEvent.DEFAULT_PULL_FRACTION;

  /**
   * 下拉进度，用于刷新模糊参数
   */
  progress: number = 0;

  /**
   * 手指y轴滑动距离，用于计算卡片位置
   */
  moveY: number = 0;

  /**
   * 下拉跟手位移
   */
  translateY: number = 0;

  /**
   * 下拉速度
   */
  speedY: number = 0;

  /**
   * 横滑速度
   */
  speedX: number = 0;

  /**
   * 下拉原面板
   */
  source: TargetPanel = TargetPanel.NONE;

  /**
   * 下拉目标面板
   */
  target: TargetPanel = TargetPanel.NONE;

  /**
   * 是否双中心互切
   */
  targetChanged: TargetChangeState = TargetChangeState.NONE;
  /**
   * 目标面板超出预置之前的move距离
   */
  targetChangedMove: number = 0;

  /**
   * 是否开始执行下拉结束动画
   */
  isEndAnimRunning: boolean = false;

  /**
   * 下拉手势状态，点击、移动、抬起、取消，默认为1，抬起状态
   */
  eventType: number = 1;

  /**
   * 新建下拉事件
   */
  static create(): DropDownEvent {
    return new DropDownEvent();
  }

  /**
   * 重置下拉事件
   */
  reset(): void {
    this.progress = 0;
    this.moveY = 0;
    this.targetChanged = TargetChangeState.NONE;
    this.source = TargetPanel.NONE;
    this.target = TargetPanel.NONE;
    this.targetChangedMove = 0;
    this.translateY = 0;
    this.speedY = 0;
  }

  /**
   * 获取面板是否展开
   */
  isPanelExpand(): boolean {
    return this.target !== TargetPanel.NONE;
  }
}

Object.defineProperty(DropDownEvent, 'eventTypeName', { value: 'DropDownEvent' });

/**
 * 手势双中心切换状态枚举值
 */
export enum TargetChangeState {
  NONE,
  PRE_VERTICAL, //竖向，超出阈值前
  VERTICAL, //竖向，超出阈值后
  VERTICAL_FLING, // 交替下拉超出阈值后，抛滑反悔
  HORIZONTAL, //横向切换
  HORIZONTAL_REVERSES, // 反向横移，不切换
  HORIZONTAL_UP_BACK, //横向切换未达到阈值反悔
  VERTICAL_FLING_SWITCH // 抛滑出现
}

export enum TargetPanel {
  NONE,
  NOTIFICATION_PANEL,
  CONTROL_CENTER_PANEL
}

export class PluginIconChangeEvent {
  tokenId: number;
  instanceKey: string;
}

Object.defineProperty(PluginIconChangeEvent, 'eventTypeName', { value: 'PluginIconChangeEvent' });

/**
 * plugin图标内容颜色事件
 */
export class PluginContentEvent {
  /**
   * 根组件标示，复用时，区分对象
   */
  rootParentId: string;

  /**
   * key plugin唯一标示
   * value plugin内容颜色
   */
  pluginSlotMap: Map<string, string>;

  /**
   * 创建事件
   *
   * @param rootId 实例对象标示
   * @param pluginSlotMap 图标标示对应图标内容颜色
   */
  static create(rootId: string, pluginSlotMap: Map<string, string>): PluginContentEvent {
    let event = new PluginContentEvent();
    event.rootParentId = rootId;
    event.pluginSlotMap = pluginSlotMap;
    return event;
  }
}

Object.defineProperty(PluginContentEvent, 'eventTypeName', { value: 'PluginContentEvent' });

/**
 * plugin图标请求事件
 */
export class PluginRequestEvent {
  /**
   * 请求类型，plugin图标可见性
   */
  static readonly REQUEST_TYPE_VISIBILITY = 1;

  /**
   * 值，可见性，可见
   */
  static readonly VALUE_VISIBILITY_VISIBLE = 'visible';

  /**
   * 值，可见性，隐藏
   */
  static readonly VALUE_VISIBILITY_GONE = 'gone';

  /**
   * 请求类型
   */
  requestType: number;

  /**
   * plugin图标唯一标示
   */
  pluginSlot: string;

  /**
   * 请求数据
   */
  value: string;

  /**
   * 设置plugin可见性
   *
   * @param isVisible 是否可见
   */
  setIsVisible(isVisible: boolean): void {
    this.value = isVisible ? PluginRequestEvent.VALUE_VISIBILITY_VISIBLE : PluginRequestEvent.VALUE_VISIBILITY_GONE;
  }

  /**
   * plugin可见性
   *
   * @return true 可见
   */
  isVisible(): boolean {
    return this.value === PluginRequestEvent.VALUE_VISIBILITY_VISIBLE;
  }

  /**
   * 创建事件
   *
   * @param slot 唯一标示
   * @param requestType 请求类型
   * @param value 请求数据
   * @return 事件
   */
  static create(slot: string, requestType: number, value: string): PluginRequestEvent {
    let event = new PluginRequestEvent();
    event.pluginSlot = slot;
    event.requestType = requestType;
    event.value = value;
    return event;
  }
}

Object.defineProperty(PluginRequestEvent, 'eventTypeName', { value: 'PluginRequestEvent' });

/**
 * 锁屏状态事件
 */
export class ScreenLockEvent {
  /**
   * 锁屏状态，无密码锁
   */
  static readonly LOCK_STATUS_UNLOCK = 0;

  /**
   * 锁屏状态，有密码锁
   */
  static readonly LOCK_STATUS_SECURE = 1;

  /**
   * 锁屏状态，默认无密码锁
   */
  lockStatus: number = ScreenLockEvent.LOCK_STATUS_UNLOCK;

  /**
   * 当前是否锁屏页面
   */
  isLockScreen: boolean = false;

  /**
   * 是否有密码锁
   *
   * @return true 有密码锁
   */
  isSecureStatus(): boolean {
    return this.lockStatus !== ScreenLockEvent.LOCK_STATUS_UNLOCK;
  }

  /**
   * 密码锁并且锁屏状态
   *
   * @return true 密码锁定
   */
  isSecureAndLocked(): boolean {
    return this.isSecureStatus() && this.isLockScreen;
  }
}

Object.defineProperty(ScreenLockEvent, 'eventTypeName', { value: 'ScreenLockEvent' });

/**
 * 音频事件
 */
export class AudioEvent {
  /**
   * 设备连接状态变化信息
   */
  audioChangeAction: audio.DeviceChangeAction = null;

  /**
   * 创建事件
   *
   * @param audioChangeAction 设备连接状态变化和设备信息
   * @return 事件
   */
  static create(audioChangeAction: audio.DeviceChangeAction): AudioEvent {
    let event = new AudioEvent();
    event.audioChangeAction = audioChangeAction;
    return event;
  }
}

Object.defineProperty(AudioEvent, 'eventTypeName', { value: 'AudioEvent' });

export enum InputMethodEventType {
  INPUT_METHOD_CHANGED = 'INPUT_METHOD_CHANGED',
  INPUT_METHOD_LANGUAGE_CHANGED = 'INPUT_METHOD_LANGUAGE_CHANGED',
}

/**
 * 输入法事件
 */
export class InputMethodEvent {
  /**
   * 事件类型
   */
  eventType: InputMethodEventType;

  /**
   * 输入法子类型
   */
  subtype: InputMethodSubtype;

  /**
   * 输入法
   */
  methodProperty: inputMethod.InputMethodProperty;

  static createLanguageChangeEvent(subtype: InputMethodSubtype): InputMethodEvent {
    let event = new InputMethodEvent();
    event.eventType = InputMethodEventType.INPUT_METHOD_LANGUAGE_CHANGED;
    event.subtype = subtype;
    return event;
  }

  static createMethodChangeEvent(methodProperty: inputMethod.InputMethodProperty): InputMethodEvent {
    let event = new InputMethodEvent();
    event.eventType = InputMethodEventType.INPUT_METHOD_CHANGED;
    event.methodProperty = methodProperty;
    return event;
  }
}

Object.defineProperty(InputMethodEvent, 'eventTypeName', { value: 'InputMethodEvent' });

/**
 * 窗口创建完成事件
 */
export class WindowCreatedEvent {
  /**
   * 窗口名称
   */
  windowName: string;

  /**
   * 创建事件
   *
   * @param windowName 窗口名
   */
  static create(windowName: string): WindowCreatedEvent {
    let event = new WindowCreatedEvent();
    event.windowName = windowName;
    return event;
  }
}

Object.defineProperty(WindowCreatedEvent, 'eventTypeName', { value: 'WindowCreatedEvent' });

/**
 * 颜色变化事件
 */
export class ColorModeChangeEvent {
  /**
   * currColorMode
   */
  public currColorMode: number;

  /**
   * 创建事件
   *
   * @param currColorMode 颜色
   */
  static create(currColorMode: number): ColorModeChangeEvent {
    let event = new ColorModeChangeEvent();
    event.currColorMode = currColorMode;
    return event;
  }
}

Object.defineProperty(ColorModeChangeEvent, 'eventTypeName', { value: 'ColorModeChangeEvent' });

/**
 * 屏幕状态变化事件
 */
export class ScreenStatusChangeEvent {
  /**
   * 锁屏状态
   */
  public lockStatus: number;

  /**
   * 小折叠折叠展开状态
   */
  public foldStatusForOuterScreen: number;

  /**
   * 屏幕自动旋转状态
   */
  public autoRotateStatus: boolean;

  /**
   * 创建事件
   *
   * @param lockStatus 锁屏状态
   * @param foldStatusForOuterScreen 小折叠折叠展开状态
   * @param autoRotateStatus 屏幕自动旋转状态
   */
  static create(lockStatus: number, foldStatusForOuterScreen: number,
    autoRotateStatus: boolean): ScreenStatusChangeEvent {
    let event = new ScreenStatusChangeEvent();
    event.lockStatus = lockStatus;
    event.foldStatusForOuterScreen = foldStatusForOuterScreen;
    event.autoRotateStatus = autoRotateStatus;
    return event;
  }
}

Object.defineProperty(ScreenStatusChangeEvent, 'eventTypeName', { value: 'ScreenStatusChangeEvent' });

/**
 * 无障碍变化事件
 */
export class AccessibilityModeChangeEvent {
  /**
   * AccessibilityMode
   */
  public isAccessibilityMode: boolean;

  /**
   * 创建事件
   *
   * @param AccessibilityMode
   */
  static create(isAccessibilityMode: boolean): AccessibilityModeChangeEvent {
    let event = new AccessibilityModeChangeEvent();
    event.isAccessibilityMode = isAccessibilityMode;
    return event;
  }
}

Object.defineProperty(AccessibilityModeChangeEvent, 'eventTypeName', { value: 'AccessibilityModeChangeEvent' });

/**
 * 动态胶囊显隐事件
 */
export class CapsuleVisibleEvent {
  pluginSlot: string;

  visible: boolean;

  requestPid?: number;
}

Object.defineProperty(CapsuleVisibleEvent, 'eventTypeName', { value: 'CapsuleVisibleEvent' });

/**
 * 状态栏动态胶囊排序事件
 *
 * @param PluginPosition
 */
export class StatusBarSortEvent {
  /**
   * 属性
   */
  position: string;
}

Object.defineProperty(StatusBarSortEvent, 'eventTypeName', { value: 'StatusBarSortEvent' });

/**
 * lottie动效播放事件
 */
export class LottiePlayEvent {
  /**
   * 组件对应业务图标slot名
   */
  pluginSlot: string;

  /**
   * 是否hover
   */
  isHover: boolean;
}

Object.defineProperty(LottiePlayEvent, 'eventTypeName', { value: 'LottiePlayEvent' });

/**
 * plugin变更事件
 */
export class PluginChangeEvent {
  /**
   * plugin信息集
   */
  pluginInfos: Array<PluginInfo>;

  position: PluginPosition;
}

export class AccessPanelHeightChangeEvent {
  tokenId: number;
  instanceKey: string;
  windowHeight: number;
}

Object.defineProperty(AccessPanelHeightChangeEvent, 'eventTypeName',
  { value: 'AccessPanelHeightChangeEvent' });

/**
 * 下拉事件
 */
export class DropDownStatus {
  /**
   * 是否在进行桌面状态栏的onTouch
   */
  isTouchingStatusBar: boolean = false;

  /**
   * 新建下拉事件
   */
  static create(): DropDownStatus {
    return new DropDownStatus();
  }
}

Object.defineProperty(PluginChangeEvent, 'eventTypeName', { value: 'PluginChangeEvent' });


/**
 * 下拉事件
 */
export class WallpaperChangeEvent {
  /**
   * 平均色
   */
  avgColor: string = '#00000000';

}

Object.defineProperty(WallpaperChangeEvent, 'eventTypeName', { value: 'WallpaperChangeEvent'});

/**
 * 合一编辑变化卡片事件
 */
export class ThemeCardEvent {
  /**
   * 平均色
   */
  unlockWallpaperUrl: string = '';

}

Object.defineProperty(ThemeCardEvent, 'eventTypeName', { value: 'ThemeCardEvent'});

/**
 *桌面dock背板颜色变化事件
 */
export class DockAvgColorChangeEvent {
  /**
   * 平均色
   */
  dockAvgColor: string = '#ff000000';

  /**
   * 是否是壁纸颜色更新
   */
  isWallpaperChange: boolean = true;
}

Object.defineProperty(DockAvgColorChangeEvent, 'eventTypeName', { value: 'DockAvgColorChangeEvent' });


/**
 * 屏幕旋转事件
 */
export class RotateChangeEvent {
  /**
   * 开始旋转动效
   */
  static readonly ROTATE_STATUS_START: number = 0;

  /**
   * 旋转动效结束
   */
  static readonly ROTATE_STATUS_END: number = 1;

  /**
   * 旋转动效被打断
   */
  static readonly ROTATE_STATUS_CANCEL: number = 2;

  /**
   * 折叠屏旋转流程状态
   */
  rotateStatus: number = RotateChangeEvent.ROTATE_STATUS_START;

  /**
   * 创建旋转事件
   *
   * @param status 当前旋转状态
   * @returns 旋转事件
   */
  static create(status: number): RotateChangeEvent {
    let event: RotateChangeEvent = new RotateChangeEvent();
    event.rotateStatus = status;
    return event;
  }
}

Object.defineProperty(RotateChangeEvent, 'eventTypeName', { value: 'RotateChangeEvent'});

/**
 * StartSceneFromOtherEvent 事件
 */
export class StartSceneFromOtherEvent {
  /**
   * Bundle name.
   */
  bundleName: string;
  /**
   * abilityName name.
   */
  abilityName: string;

  private static startSceneFromOtherEvent: StartSceneFromOtherEvent;

  public static getInstance(bundleName: string, abilityName: string): StartSceneFromOtherEvent {
    if (!StartSceneFromOtherEvent.startSceneFromOtherEvent) {
      StartSceneFromOtherEvent.startSceneFromOtherEvent = new StartSceneFromOtherEvent();
    }
    StartSceneFromOtherEvent.startSceneFromOtherEvent.bundleName = bundleName;
    StartSceneFromOtherEvent.startSceneFromOtherEvent.abilityName = abilityName;
    return StartSceneFromOtherEvent.startSceneFromOtherEvent;
  }
}

Object.defineProperty(StartSceneFromOtherEvent, 'eventTypeName', { value: 'StartSceneFromOtherEvent' });

/*
 * 主题使能事件，用于通知各模块主题使能并提供当前生效资源目录
 */
export class ThemeActivationEvent {
  // 主题生效范围
  public target: number;

  // 主题类型
  public themeType: number;

  // 用户对主题包的拥有权区分，用于区分试用主题还是已购买的主题
  public themeOwnership: number;

  // 当前资源目录(A/B)
  public activeThemePath: string;
}

Object.defineProperty(ThemeActivationEvent, 'eventTypeName', { value: 'ThemeActivationEvent' });

/**
 * 头等舱显示事件
 */
export class PluginCardChangeEvent {

  /**
   * 显示
   */
  public static readonly PLUGIN_CARD_SHOW: number = 0;

  private static pluginCardChangeEvent: PluginCardChangeEvent;

  /**
   * 状态
   */
  status: number;

  /**
   * 创造头等舱显示事件
   *
   * @param status 当前显示状态
   * @returns 显示事件
   */
  public static getInstance(status: number): PluginCardChangeEvent {
    if (!PluginCardChangeEvent.pluginCardChangeEvent) {
      PluginCardChangeEvent.pluginCardChangeEvent = new PluginCardChangeEvent();
    }
    PluginCardChangeEvent.pluginCardChangeEvent.status = status;
    return PluginCardChangeEvent.pluginCardChangeEvent;
  }
}

Object.defineProperty(PluginCardChangeEvent, 'eventTypeName', { value: 'PluginCardChangeEvent'});

/**
 * 进程创建销毁事件
 */
export class ProcessStateChangeEvent {
  bundleName: string;
  visible: boolean;
  requestPid?: number;
  requestUid?: number;
}
Object.defineProperty(ProcessStateChangeEvent, 'eventTypeName', { value: 'ProcessStateChangeEvent' });

/**
 * 外屏IPC通信回调事件
 */
export class OuterHomeCallbackEvent {
  /**
   * 回调编码
   */
  eventCode: number;

  /**
   * 回调参数
   */
  eventData: string;

  /**
   * 构造
   */
  constructor(eventCode: number, eventData: string) {
    this.eventCode = eventCode;
    this.eventData = eventData;
  }
}

Object.defineProperty(OuterHomeCallbackEvent, 'eventTypeName', { value: 'OuterHomeCallbackEvent'});

/**
 * 应用状态变更事件
 */
export class AppStateChangeEvent {
  public appName: string;
  public state: string;
}

Object.defineProperty(AppStateChangeEvent, 'eventTypeName', { value: 'AppStateChangeEvent' });

/**
 * 窗口位置属性变更事件
 */
export class WindowPositionChangeEvent {
  public windowName: string;
  public position: string;
  public area: Window.Rect;
  public caller?: string;
}

Object.defineProperty(WindowPositionChangeEvent, 'eventTypeName', { value: 'WindowPositionChangeEvent' });

/**
 * 侧边音量面板展示事件
 */
export class VolumePanelVisibilityEvent {
  /**
   * 侧边音量面板是否展示
   */
  private _volumePanelNeedShow: boolean;

  public get volumePanelNeedShow(): boolean {
    return this._volumePanelNeedShow;
  }

  /**
   * 创建事件
   */
  static create(volumePanelNeedShow: boolean): VolumePanelVisibilityEvent {
    let event = new VolumePanelVisibilityEvent();
    event._volumePanelNeedShow = volumePanelNeedShow;
    return event;
  }
}

Object.defineProperty(VolumePanelVisibilityEvent, 'eventTypeName', { value: 'VolumePanelVisibilityEvent' });

/**
 * RSS动效规格变化通知事件
 * 主要用于控制中心模糊动效根据rss动效规格变化而改变规格
 */
export class RssNotifyEvent {

  /**
   * 动效策略
   */
  component: CommonComponent;

  /**
   * 创建事件
   *
   * @param policy
   */
  static create(component: CommonComponent): RssNotifyEvent {
    let event = new RssNotifyEvent();
    event.component = component;
    return event;
  }
}

Object.defineProperty(RssNotifyEvent, 'eventTypeName', { value: 'RssNotifyEvent' });

export class AbilityStateChangedEvent {
  /*
   * 状态变化的包名称
   * */
  public bundleName: string;
  /*
   * 状态
   * */
  public state: number;
  /*
   * ability name
   * */
  public abilityName: string;
  /*
   * uid
   * */
  public uid: number;
  /**
   * module name
   */
  public moduleName: string;
  /**
   * pid
   */
  public pid: number;
  /*
   * ability type
   * */
  public abilityType: number;

  constructor(bundleName: string, status: number, ability: string, uid: number, moduleName: string, pid: number,
    abilityType: number) {
    this.bundleName = bundleName;
    this.state = status;
    this.abilityName = ability;
    this.uid = uid;
    this.moduleName = moduleName;
    this.pid = pid;
    this.abilityType = abilityType;
  }
}

Object.defineProperty(AbilityStateChangedEvent, 'eventTypeName', { value: 'AbilityStateChangedEvent' });

export class HideAppConfigLoadEvent {
  loadStatus: boolean;
}
Object.defineProperty(HideAppConfigLoadEvent, 'eventTypeName', { value: 'HideAppConfigLoadEvent' });

/**
 * 自由多窗模式下，旋转锁定状态变更事件
 */
export class MultiWindowRotateChangeEvent {
  /**
   *  旋转锁定按钮可用状态
   */
  public isRotateUnavailable: boolean;

  /**
   * 创建事件
   * @param isRotateUnavailable 可用状态
   * @returns
   */
  static create(isRotateUnavailable: boolean): MultiWindowRotateChangeEvent {
    let event = new MultiWindowRotateChangeEvent();
    event.isRotateUnavailable = isRotateUnavailable;
    return event;
  }
}
Object.defineProperty(MultiWindowRotateChangeEvent, 'eventTypeName', { value: 'MultiWindowRotateChangeEvent'});

/**
 * 多用户切换事件
 */
export class AccountSwitchEvent {
  /**
   * 当前用户id
   */
  currentUserId: number | undefined;
}

Object.defineProperty(AccountSwitchEvent, 'eventTypeName', { value: 'AccountSwitchEvent' });