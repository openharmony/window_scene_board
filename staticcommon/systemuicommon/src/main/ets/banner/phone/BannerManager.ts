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

/*
 */
import { SingletonHelper, CommonUtils, LogDomain, LogHelper, ArrayUtils, } from '@ohos/basicutils';
import { ResUtils, SCBSceneSessionManager, } from '@ohos/windowscene';
import { ViewType, viewMgrPolicy, DeviceHelper, EventManager, EvtBus, CutoutEvent,
  ScreenLockEvent, CustomPromise } from '@ohos/frameworkwrapper';
import type { SCBSystemSceneSession, SystemSessionInfo, } from '@ohos/windowscene';
import type { ViewArea } from '@ohos/frameworkwrapper';
import { baseStateMgr } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseStateManager';
import type { IState } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseState';
import { StateType } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseState';
import { SceneFlag } from '../../base/common/SceneFlag';
import type { OnStateChangeListener } from '@ohos/systemuiutils/src/main/ets/sysdialog/StateListenerRegister';
import { StateListenerRegister } from '@ohos/systemuiutils/src/main/ets/sysdialog/StateListenerRegister';
import { BannerStyleState } from '../common/info/BannerState';
import { BannerOutsideState, BannerPanelType, BannerState } from '../common/info/BannerState';
import { BannerStyle } from './style/BannerStyle';

import { BaseConstants } from '../../base/common/BaseConstants';
import { UIContext } from '@kit.ArkUI';
import { LiveUseScene } from '../../liveview/common/LiveConstants';
import { LayoutUtils, XTLayoutType } from '@ohos/systemuiutils/src/main/ets/base/LayoutUtils';
import { ArkUIAdapter } from '../../utils/ArkUIAdapter';
import { SceneSessionAdapter } from '../../adapter/SceneSessionAdapter';
import { ThreadSync } from '../../messageChannel/ThreadSync';
import { BannerViewControllerAdapter } from '../../adapter/BannerViewControllerAdapter';
import { BannerManagerAdapter } from '../../adapter/BannerManagerAdapter';
import { AccessibilityVm } from '../../vm/AccessibilityVm';

const TAG = 'BannerManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * banner窗口类型
 */
const BANNER_VIEW_TYPE = ViewType.NOTIFICATION_BANNER;

/**
 * 主面板类型
 */
const MAIN_PANEL_TYPE = [
  BannerPanelType.TYPE_HEADS_UP,
  BannerPanelType.TYPE_LIVE_LIST
];

/**
 * 副面板类型
 */
const SECONDARY_PANEL_TYPE = [
  BannerPanelType.TYPE_CAPSULE_LIST
];

/**
 * PAD、折叠屏宽度固定值vp
 */
const PAD_OR_FOLD_NTF_WIDTH: number = 532;

/**
 * 横幅、实况面板状态管理
 */
class BannerManager {
  /**
   * banner面板状态统一管理
   */
  private bannerState: BannerState = ThreadSync.create(new BannerState());

  /**
   * 状态监听集
   */
  private stateListeners: StateListenerRegister = new StateListenerRegister();

  /**
   * banner窗口控制器
   */
  private bannerController = BannerViewControllerAdapter.instance;

  /**
   * 默认样式，常量值
   */
  private defaultStyle: BannerStyle = BannerStyle.createStyle();

  /**
   * 面板外部触摸状态
   */
  private outsideState: BannerOutsideState = new BannerOutsideState();

  /**
   * 面板类型对应的交互热区
   */
  private panelArea: Map<BannerPanelType, Area> = new Map<BannerPanelType, Area>();

  private bannerPersistentId: number = 0;
  private isAccessibilityMode: boolean = false;

  private eventMgr: EventManager = EvtBus.createEventManager();

  /**
   * 中间孔高度
   */
  private midCutOutHeight: number = 0;

  /**
   * 状态栏高度
   */
  private statusBarHeight: number = 0;

  /**
   * 状态栏可见
   */
  private statusBarIsVisible: boolean = true;

  /**
   * 是否进入全屏热区模式，此时点击外部事件被屏蔽
   */
  private isInFullScreenMode: boolean = false;

  /**
   * 超时计时器ID
   */
  private timerId?: number;

  /**
   * 屏幕宽高变化回调
   * 沉浸式状态变化回调
   */
  private onBaseStateChange: OnStateChangeListener = {
    /**
     * 基础状态回调
     */
    onStateChange: (state: IState): void => {
      this.uiContext?.runScopedTask(() => {
        this.handleStateChange(state);
      });
    }
  };

  /**
   * 窗口外部触摸事件回调
   */
  private onTouchOutside = (x: number, y: number): void => {
    if (this.isInFullScreenMode) {
      log.showInfo(`current scene is in full screen mode, ignore outside touch event, x=${x}, y=${y}`);
      return;
    }

    // 事件只给到当前显示面板
    this.outsideState.currentPanelType = this.bannerState.bannerPanelType.bannerPanelType;
    this.outsideState.touchX = x;
    this.outsideState.touchY = y;
    this.stateListeners.notifyStateChange(this.outsideState);
  };

  /**
   * 标识位，表示当前为横幅通知切换实况通知列表
   */
  public isHandleHeadUpToLiveList: boolean = false;

  /**
   * 是否为即时横幅占据横幅面板
   */
  public isInstantBanner: boolean = false;

  /**
   * 是否处于实况横幅和普通横幅抢占
   */
  public preemptPromise?: CustomPromise<void>;

  /**
   * 是否为实况独占据横幅面板
   */
  public isExclusiveLiveBanner: boolean = false;

  /**
   * 标识位，实况胶囊是否可被点击
   */
  public liveViewClickEnable: boolean = true;

  private uiContext?: UIContext;

  public runScopedTask(callback: () => void): void {
    if (this.uiContext) {
      this.uiContext?.runScopedTask(() => {
        callback?.();
      });
    } else {
      log.showInfo(`uiContext is undefined`);
      callback?.();
    }
  }

  public setLiveClickEnable(isEnable: boolean): void {
    log.showInfo(`setLiveClickEnable: ${isEnable}`);
    this.liveViewClickEnable = isEnable;
  }

  private handleStateChange(state: IState): void {
    switch (state.getStateType()) {
      case StateType.TYPE_DISPLAY_SIZE:
        this.onDisplaySizeChange();
        break;
      case StateType.TYPE_IMMERSIVE:
        this.onImmersiveChange();
        break;
      default:
        break;
    }
  }

  /**
   * 窗口依附
   */
  async appear(uiContext: UIContext): Promise<void> {
    this.uiContext = uiContext;
    // 注册窗口控制器
    this.bannerController.register();

    // 注册窗口touchOut事件
    SceneSessionAdapter.registerTouchOutsideCallback({
      callback: this.onTouchOutside,
    }, `${TAG}_registerTouchOutsideCallback`);

    await this.refreshBannerStyle();

    // 监听屏幕宽高、沉浸式变化
    baseStateMgr.registerStateChangeListener(StateType.TYPE_DISPLAY_SIZE, this.onBaseStateChange);
    baseStateMgr.registerStateChangeListener(StateType.TYPE_IMMERSIVE, this.onBaseStateChange);
    this.statusBarHeight = ResUtils.getNumber($r('app.float.status_bar_phone_height'));
    this.eventMgr.on(CutoutEvent, this.onCutoutEvent)
      .on(ScreenLockEvent, this.handleScreenLockEvent);
  }

  /**
   * 窗口解依附
   */
  disappear(): void {
    // 注销窗口touchOut事件
    SceneSessionAdapter.unregisterTouchOutsideCallback();

    // 注销窗口控制器
    this.bannerController.unregister();

    // 注销屏幕宽高、沉浸式监听
    baseStateMgr.unregisterStateChangeListener(StateType.TYPE_DISPLAY_SIZE, this.onBaseStateChange);
    baseStateMgr.unregisterStateChangeListener(StateType.TYPE_IMMERSIVE, this.onBaseStateChange);
    this.eventMgr.offAll();
    this.uiContext = undefined;
  }

  /**
   * 注册状态监听
   *
   * @param type 状态类型
   * @param listener 监听器
   * @returns 快速注销监听
   */
  registerStateChangeListener(type: StateType, listener: OnStateChangeListener): () => void {
    return this.stateListeners.registerStateChangeListener(type, listener);
  }

  /**
   * 注销状态监听
   *
   * @param type 状态类型
   * @param listener 监听器
   */
  unregisterStateChangeListener(type: StateType, listener: OnStateChangeListener): void {
    this.stateListeners.unregisterStateChangeListener(type, listener);
  }

  /**
   * 更新窗口ID
   *
   * @param id 窗口ID
   */
  async updatePersistentId(id: number): Promise<void> {
    this.bannerPersistentId = id;
    await this.bannerController.updateId(id);
  }

  updateAccessibilityMode(isAccessibilityMode: boolean): void {
    this.isAccessibilityMode = isAccessibilityMode;
  }

  /**
   * 获取banner面板状态管理器
   *
   * @returns 状态管理
   */
  getBannerState(): BannerState {
    return this.bannerState;
  }

  /**
   * 获取banner面板默认样式
   *
   * @returns 默认样式
   */
  getBannerDefaultStyle(): BannerStyle {
    return this.defaultStyle;
  }

  /**
   * 请求隐藏banner面板
   *
   * @param scene 场景来源
   */
  requestHideBannerPanel(scene: SceneFlag): void {
    switch (scene) {
      // 横幅收起场景
      case SceneFlag.SCENE_RELEASE_HEADS_UP:
        this.releasePanelHeadsUp();
        break;
      // 实况面板收起场景
      case SceneFlag.SCENE_RELEASE_LIVE_LIST:
        this.releasePanelLiveList();
        break;
      // 胶囊列表收起场景
      case SceneFlag.SCENE_RELEASE_CAPSULE_LIST:
        this.releasePanelCapsuleList();
        break;
      // 锁屏场景，直接收起面板
      default:
        this.setBannerPanelType(BannerPanelType.TYPE_NONE);
        break;
    }
  }

  /**
   * 请求显示横幅面板
   *
   * @param timeout 横幅超时时间
   * @param runnable 超时任务
   * @returns true 切换面板成功
   */
  requestPanelHeadsUp(timeout?: number, runnable?: () => void): boolean {
    if (this.setBannerPanelType(BannerPanelType.TYPE_HEADS_UP)) {
      // 状态切换成功，开启计时器
      this.startTimeoutHide(timeout, runnable);
      return true;
    }
    return false;
  }

  /**
   * 释放横幅面板
   */
  releasePanelHeadsUp(): void {
    // 当前不是横幅面板则退出
    if (!this.isBannerPanelType(BannerPanelType.TYPE_HEADS_UP)) {
      return;
    }
    this.setBannerPanelType(BannerPanelType.TYPE_NONE);
  }

  /**
   * 请求显示实况横幅面板
   *
   * @param timeout 横幅超时时间
   * @param runnable 超时任务
   * @returns true 切换面板成功
   */
  requestLiveHeadsUp(timeout?: number): boolean {
    if (this.setBannerPanelType(BannerPanelType.TYPE_LIVE_HEADS_UP)) {
      // 状态切换成功，开启计时器
      this.startTimeoutHide(timeout);
      return true;
    }
    return false;
  }

  /**
   * 释放实况横幅面板
   */
  releaseLiveHeadsUp(): void {
    // 当前非实况横幅面板
    if (!this.isBannerPanelType(BannerPanelType.TYPE_LIVE_HEADS_UP)) {
      return;
    }
    this.setBannerPanelType(BannerPanelType.TYPE_NONE);
  }

  /**
   * 请求显示实况面板
   *
   * @returns true 切换面板成功
   */
  requestPanelLiveList(scene?: SceneFlag): boolean {
    if (this.setBannerPanelType(BannerPanelType.TYPE_LIVE_LIST, scene)) {
      // 面板切换成功，取消计时器
      this.cancelTimeoutHide();
      return true;
    }
    return false;
  }

  /**
   * 释放实况面板
   *
   * @param scene 触发场景
   */
  releasePanelLiveList(scene?: SceneFlag): void {
    // 当前横幅面板，实况释放无意义
    if (this.isBannerPanelType(BannerPanelType.TYPE_HEADS_UP)) {
      return;
    }
    this.setBannerPanelType(BannerPanelType.TYPE_NONE, scene);
  }

  /**
   * 请求显示胶囊列表
   */
  requestPanelCapsuleList(): void {
    this.setSecondaryPanelType(BannerPanelType.TYPE_CAPSULE_LIST);
  }

  /**
   * 释放胶囊列表
   */
  releasePanelCapsuleList(): void {
    this.setSecondaryPanelType(BannerPanelType.TYPE_NONE);
  }

  /**
   * 当前banner面板是否目标类型
   *
   * @param type 类型
   * @returns true目标类型
   */
  isBannerPanelType(type: BannerPanelType): boolean {
    return this.bannerState.bannerPanelType.bannerPanelType === type;
  }

  /**
   * 当前banner副面板是否目标类型
   *
   * @param type 类型
   * @returns true目标类型
   */
  isSecondaryPanelType(type: BannerPanelType): boolean {
    return this.bannerState.bannerPanelType.secondaryPanelType === type;
  }

  /**
   * 清除超时任务
   */
  cancelTimeoutHide(): void {
    if (CommonUtils.isNumber(this.timerId)) {
      clearTimeout(this.timerId);
      this.timerId = null;
    }
  }

  /**
   * 设置触摸热区范围
   *
   * @param displayArea 组件区域范围
   */
  setResponseRegion(displayArea: Area, type?: BannerPanelType): void {
    let responseRegion = this.getRegionArea(displayArea);
    log.showWarn(`set response region x ${responseRegion.x} y ${responseRegion.y}, ` +
      `width ${responseRegion.width}, height ${responseRegion.height}`);

    ArkUIAdapter.runWithScope(() => {
      this.bannerController?.setResponseRegion([responseRegion]);
    })
    // 保存对应类型热区范围
    if (type !== undefined) {
      this.panelArea?.set(type, displayArea);
    }
  }

  /**
   * 给已有热区的type新增热区
   * @param displayArea
   * @param type
   */
  addExtraResponseRegion(displayArea: Area | undefined, type: BannerPanelType): void {
    const bannerDisplayArea = this.panelArea?.get(type);
    if (!bannerDisplayArea) {
      log.showWarn('set other response regions has no exit region, return')
      return
    }
    const bannerRegion = this.getRegionArea(bannerDisplayArea);
    let regions = [bannerRegion];
    if (displayArea) {
      const otherRegion = this.getRegionArea(displayArea);
      log.showWarn(`set other response region y ${otherRegion.y}, width ${otherRegion.width}, height ${otherRegion.height}`);
      regions.push(otherRegion);
    }
    ArkUIAdapter.runWithScope(() => {
      this.bannerController?.setResponseRegion(regions);
    })
  }

  getRegionArea(displayArea: Area): Rectangle {
    return {
      x: ArkUIAdapter.vp2px((displayArea?.globalPosition?.x as number) ?? BaseConstants.MIN_VALUE),
      y: ArkUIAdapter.vp2px((displayArea?.globalPosition?.y as number) ?? BaseConstants.MIN_VALUE),
      width: ArkUIAdapter.vp2px((displayArea?.width as number) ?? BaseConstants.MIN_VALUE),
      height: ArkUIAdapter.vp2px((displayArea?.height as number) ?? BaseConstants.MIN_VALUE)
    }
  }

  /**
   * 设置全屏面板热区
   */
  public enterFullPanelRegion(): void {
    const width = this.bannerState.displaySizeState.displayWidth;
    const height =
      this.bannerState.displaySizeState.displayHeight - ArkUIAdapter.vp2px(this.defaultStyle.bannerMarginBottom);
    const responseRegion = { x: 0, y: 0, width: width, height: height };
    log.showInfo(`enter full panel region width ${width} height ${height}`);
    ArkUIAdapter.runWithScope(() => {
      this.bannerController?.setResponseRegion([responseRegion]);
    });
    this.isInFullScreenMode = true;
  }

  /**
   * 退出全屏面板热区
   */
  public exitFullPanelRegion(): void {
    const type = this.bannerState.bannerPanelType.bannerPanelType;
    log.showInfo(`exit full panel region type ${type}`);
    this.isInFullScreenMode = false;

    if (this.panelArea?.get(type) !== undefined) {
      this.setResponseRegion(this.panelArea?.get(type));
    }
  }

  isSupportDouble(isNeedBannerInScreenLock: boolean, isLockScreen: boolean, isSecureAndLocked: boolean): boolean {
    return isNeedBannerInScreenLock && isLockScreen && isSecureAndLocked;
  }

  isBannerLockScreen(isNeedBannerInScreenLock: boolean, isLockScreen: boolean): boolean {
    return isNeedBannerInScreenLock && isLockScreen;
  }

  isBannerSecureLockScreen(isNeedBannerInScreenLock: boolean, isSecureAndLocked: boolean): boolean {
    return isNeedBannerInScreenLock && isSecureAndLocked;
  }

  isLiveListInScreenLock(useScene: LiveUseScene, isNeedBannerInScreenLock: boolean,
    isShowBannerFromScreenLock: boolean): boolean {
    return isNeedBannerInScreenLock && (useScene === LiveUseScene.SCENE_LIVE_LIST) && isShowBannerFromScreenLock;
  }

  isHeadsUpInScreenLock(useScene: LiveUseScene, isNeedBannerInScreenLock: boolean,
  isShowBannerFromScreenLock: boolean): boolean {
    return isNeedBannerInScreenLock && (useScene === LiveUseScene.SCENE_HEADS_UP) && isShowBannerFromScreenLock;
  }

  isHiddenBannerContent(isHideContent: boolean, isNeedBannerInScreenLock: boolean,
    isShowBannerFromScreenLock: boolean): boolean {
    return isNeedBannerInScreenLock && isHideContent && isShowBannerFromScreenLock;
  }

  /**
   * 开启倒计时收起面板任务
   *
   * @param timeout 超时时间
   * @param runnable 超时任务
   */
  private startTimeoutHide(timeout?: number, runnable?: () => void): void {
    this.cancelTimeoutHide();
    if (CommonUtils.isNumber(timeout) && !CommonUtils.isInvalid(runnable)) {
      this.timerId = setTimeout(() => {
        this.timerId = null;
        runnable?.();
      }, timeout);
    }
  }

  /**
   * 沉浸式切换
   */
  private async onImmersiveChange(): Promise<void> {
    // 刷新banner样式
    await this.refreshBannerStyle();
  }

  /**
   * 屏幕宽高切换
   */
  private onDisplaySizeChange(): void {
    let sizeState = this.bannerState.displaySizeState;
    let bannerSize: ViewArea = {
      left: 0,
      top: 0,
      width: ArkUIAdapter.px2vp(sizeState.displayWidth),
      height: ArkUIAdapter.px2vp(sizeState.displayHeight) - this.defaultStyle.bannerMarginBottom
    };

    ArkUIAdapter.runWithScope(() => {
      // 更新banner窗口大小
      this.bannerController.updateArea(bannerSize);
      this.bannerController.updateRect(bannerSize);
      // 刷新banner样式
      this.refreshBannerStyle();
    })
  }

  /**
   * 刷新banner面板样式
   */
  private async refreshBannerStyle(): Promise<void> {
    let sizeState = this.bannerState.displaySizeState;
    let tempState = await BannerManagerAdapter.getBannerState();
    sizeState.displayWidth = tempState.displaySizeState.displayWidth;
    sizeState.displayHeight = tempState.displaySizeState.displayHeight;
    log.showInfo(`refreshBannerStyle. displayWidth: ${sizeState.displayWidth}, displayHeight: ${sizeState.displayHeight}`)
    if (sizeState.displayWidth === 0) {
      return;
    }
    let itemWidth = 0;
    let marginLeftRight = 0;
    let displayWidth = ArkUIAdapter.px2vp(sizeState.displayWidth);

    // 宽屏场景，采用栅格宽度
    if (sizeState.isWidestScreenByVp(displayWidth)) {
      itemWidth = this.getWidestScreenWidth(sizeState.displayWidth);
      marginLeftRight = (displayWidth - itemWidth) / BaseConstants.DIVIDE;
    } else {
      // 普通场景，默认间距
      marginLeftRight = this.defaultStyle.marginLeftRight;
      itemWidth = displayWidth - (marginLeftRight * BaseConstants.DOUBLE);
    }

    // 沉浸式横屏场景顶部间距
    let immersiveState = this.bannerState.immersiveState;
    let marginStatusBarTop =
    this.defaultStyle.marginStatusBarTop;
    log.showInfo(`isBreak: ${immersiveState.isBreak}, isImmersive: ${immersiveState.isImmersive}` +
      `, statusBarIsVisible: ${this.statusBarIsVisible}, ${this.midCutOutHeight} `);
    let marginTop =
      (immersiveState.isInImmersive && !immersiveState.isBreak) || !this.statusBarIsVisible ? (this.defaultStyle.marginTopInImmersive + this.midCutOutHeight) :
        (marginStatusBarTop + this.statusBarHeight);

    // 刷新样式值
    log.showInfo(`refreshBanner style marginTop:${marginTop}, width ${itemWidth}`);
    this.setBannerStyle(this.bannerState.headsUpStyle, itemWidth, marginTop, marginLeftRight);
    this.setBannerStyle(this.bannerState.liveListStyle, itemWidth, marginTop, marginLeftRight);
  }

  /**
   * 获取宽屏下横幅、实况宽度
   *
   * @param displayWidth 屏幕宽度
   * @returns 横幅、实况宽度
   */
  private getWidestScreenWidth(displayWidth: number): number {
    if (LayoutUtils.isPadLayout() || DeviceHelper.isFoldExpanded() || LayoutUtils.isMatchXTFoldMode(XTLayoutType.M)) {
      // 小折叠按比例取值
      if (DeviceHelper.isSmallFoldProduct()) {
        return ArkUIAdapter.px2vp(ResUtils.getTimeStartWidthByLandScreenWidth(displayWidth));
      }
      return PAD_OR_FOLD_NTF_WIDTH;
    }
    return ArkUIAdapter.px2vp(ResUtils.getTimeStartWidthByLandScreenWidth(displayWidth));
  }

  /**
   * 设置样式值
   *
   * @param style 样式状态
   * @param width 宽度
   * @param marginTop 顶部间距
   * @param marginLeftRight 左右间距
   */
  private setBannerStyle(style: BannerStyleState, width: number, marginTop: number, marginLeftRight: number): void {
    style.itemWidth = width;
    style.containerWidth = width;
    style.containerMarginTop = marginTop;
    style.containerMarginLeft = marginLeftRight;
    style.containerMarginRight = marginLeftRight;

    // 底部固定间距
    style.containerMarginBottom = this.defaultStyle.marginBottom;

  }

  /**
   * 设置banner面板类型
   *
   * @param type 类型
   * @param scene 触发场景
   * @returns true设置成功
   */
  private setBannerPanelType(type: BannerPanelType, scene?: SceneFlag): boolean {
    // 主面板不允许设置副面板类型
    if (ArrayUtils.contains(SECONDARY_PANEL_TYPE, type)) {
      return false;
    }
    let panelType = this.bannerState.bannerPanelType;
    let oldType = panelType.bannerPanelType;
    if (oldType === type) {
      if (AccessibilityVm.instance.isEnabled) {
        SceneSessionAdapter.setFocusable(this.bannerPersistentId, false);
        SceneSessionAdapter.requestFocus(this.bannerPersistentId);
      }
      return true;
    }
    log.showInfo('setBannerPanelType old: ' + oldType + ', ' + type + ', ' + scene);

    if (!this.isTypeAllowed(type)) {
      return false;
    }


    // 实况列表展开状态，不允许设置横幅状态
    if (this.isBannerPanelType(BannerPanelType.TYPE_LIVE_LIST) &&
      type === BannerPanelType.TYPE_HEADS_UP) {
      return false;
    }

    // 横幅切实况列表时，需要控制时序；让LiveViewVm 中的 handleBannerStateChange 先执行
    if (this.isBannerPanelType(BannerPanelType.TYPE_HEADS_UP) &&
      type === BannerPanelType.TYPE_LIVE_LIST) {
      this.isHandleHeadUpToLiveList = true;
    }
    panelType.bannerPanelType = type;

    // 设置banner面板类型时，设置对应类型热区
    if (this.panelArea?.get(type) !== undefined) {
      this.setResponseRegion(this.panelArea?.get(type));
    }

    // 面板自动显示、隐藏
    if (type === BannerPanelType.TYPE_NONE) {
      SceneSessionAdapter.setFocusable(this.bannerPersistentId, false);
      this.checkHideBannerPanel();
    } else {
      // 取消计时器
      this.cancelTimeoutHide();
      this.bannerController.show();
      if (AccessibilityVm.instance.isEnabled) {
        SceneSessionAdapter.setFocusable(this.bannerPersistentId, true);
        SceneSessionAdapter.requestFocus(this.bannerPersistentId);
      }
    }

    // 回调监听
    panelType?.setTypeScene(scene);
    this.stateListeners.notifyStateChange(panelType);
    return true;
  }

  /**
   * 是否允许要切换的类型
   * @param type
   * @returns
   */
  private isTypeAllowed(type: BannerPanelType): boolean {
    // 实况横幅状态，不允许设置横幅状态
    if (this.isBannerPanelType(BannerPanelType.TYPE_LIVE_HEADS_UP) &&
      type === BannerPanelType.TYPE_HEADS_UP) {
      if (this.isExclusiveLiveBanner) {
        return false;
      }
      return true;
    }

    // 实况列表展开状态，不允许设置横幅状态
    if (this.isBannerPanelType(BannerPanelType.TYPE_LIVE_LIST) &&
      type === BannerPanelType.TYPE_HEADS_UP) {
      return false;
    }
    return true;
  }

  /**
   * 设置banner副面板类型
   *
   * @param type 面板类型
   * @returns true设置成功
   */
  private setSecondaryPanelType(type: BannerPanelType): boolean {
    // 副面板不允许设置主面板类型
    if (ArrayUtils.contains(MAIN_PANEL_TYPE, type)) {
      return false;
    }
    let panelType = this.bannerState.bannerPanelType;
    let oldType = panelType.secondaryPanelType;
    if (oldType === type) {
      return true;
    }
    log.showInfo('setSecondaryPanelType old: ' + oldType + ', ' + type);

    // 切换面板类型
    panelType.secondaryPanelType = type;
    if (type === BannerPanelType.TYPE_NONE) {
      this.checkHideBannerPanel();
    } else {
      this.bannerController.show();
    }
    return true;
  }

  /**
   * 尝试直接隐藏banner窗口
   */
  private checkHideBannerPanel(): void {
    // 当主、副面板类型均置none，则隐藏面板
    let panelType = this.bannerState.bannerPanelType;
    if (panelType.bannerPanelType === BannerPanelType.TYPE_NONE &&
      panelType.secondaryPanelType === BannerPanelType.TYPE_NONE) {
      this.bannerController.hide();
    }
  }

  /**
   * 挖孔位置切换事件
   */
  private onCutoutEvent = (event: CutoutEvent): void => {
    let newMidCutOutHeight = this.getMidCutOutHeight(event);
    if (newMidCutOutHeight === this.midCutOutHeight) {
      return;
    }
    this.midCutOutHeight = newMidCutOutHeight;
    log.showInfo(`refresh midCutOutHeight: ${this.midCutOutHeight}`);
    this.refreshBannerStyle();
  };

  private getMidCutOutHeight(event: CutoutEvent): number {
    if (event?.cutoutPosition === CutoutEvent.CUTOUT_MID) {
      // 位置比状态栏高，下挖孔
      if (event.cutoutRect?.top > this.statusBarHeight) {
        return 0;
      }
      return (event.cutoutRect?.top ?? 0) + (event.cutoutRect?.height ?? 0);
    }
    return 0;
  }

  /**
   * 处理锁屏事件
   */
  private handleScreenLockEvent = (event: ScreenLockEvent): void => {
    log.showInfo('handleScreenLockEvent isLockScreen:' + event?.isLockScreen);
    if (CommonUtils.isInvalid(event)) {
      return;
    }

    if (this.isBannerPanelType(BannerPanelType.TYPE_LIVE_HEADS_UP) && this.isInstantBanner) {
      log.showInfo(`instant banner is showing, do not hide banner`);
      return;
    }

    // 锁屏后请求隐藏banner面板
    if (event?.isLockScreen) {
      this.setBannerPanelType(BannerPanelType.TYPE_NONE, SceneFlag.SCENE_LOCK_SCREEN);
    }
  };


  /**
   * 设置状态栏是否可见
   *
   * @param statusBarIsVisible 状态栏可见
   */
  async setStatusBarIsVisible(statusBarIsVisible: boolean): Promise<void> {
    if (statusBarIsVisible === this.statusBarIsVisible) {
      return;
    }
    this.statusBarIsVisible = statusBarIsVisible;
    log.showInfo(`statusBarIsVisible: ${statusBarIsVisible}`);
    await this.refreshBannerStyle();
  }
}

// 单例
export let bannerMgr: BannerManager = SingletonHelper.getInstance(BannerManager, TAG);