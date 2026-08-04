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
import { NotificationBaseVm, INotificationBannerVm, NotificationBannerStyle,
  BannerVm, NOTIFICATION_ICON_SMALL_SCALE, CutoutVm } from '@ohos/systemuicommon/newIndex';
import { InnerEventUtil, NormalNotification } from '@ohos/systemuicommon/newTsIndex';
import { NotificationConfig } from '../../../common/NotificationConfig';
import { NotificationBannerEntryVm, HeadsUpCallback, HEADS_UP_DURATION } from './NotificationBannerEntryVm';
import {
  APSSceneState,
  FloatingOperationType,
  NotificationSysEventReporter,
  SystemUICommonUtil,
  TimeoutPromise
} from '@ohos/systemuicommon';
import curves from '@ohos.curves';
import { LogDomain, Logger, RectItem } from '@ohos/basicutils/src/main/ets/TsIndex';
import { ApsUtils, CustomPromise, HiDfxEventUtil } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { EventBroadcast, SysUiWindowType } from '@ohos/systemuicommon/src/main/ets/event/EventBroadcast';
import { sharedData } from '@ohos/systemuicommon/src/main/ets/model/SendableData';
import { SceneSessionAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/SceneSessionAdapter';
import { BannerSlideUpEvent } from '@ohos/systemuicommon/src/main/ets/event/NotificationEvent';

const TAG = 'NotificationBannerVm';
const log: Logger = Logger.getLogHelper(LogDomain.NC);
const BANNER_ANI_TIMEOUT_DURATION = 1000;
const DISAPPEAR_EXPIRE_TIME = 2000;
const CLICK_TO_FLOATING_ANIMATION_MAX_WAIT_TIME = 100;
/**
 * 横幅通知转场动效切换后的延迟时间，防止刚切换不生效情况
 */
const HEADS_UP_TRANSITION_EFFECT_CHANGE_DELAY = 20;
/**
 * 抬手后收起悬浮窗蒙版兜底计时
 */
const ACTION_END_HIDE_BANNER_PANEL_LIMIT = 3000;

@ObservedV2
export class NotificationBannerVm extends NotificationBaseVm implements INotificationBannerVm {
  @Trace public ntf: NormalNotification | undefined = undefined;
  @Trace public bannerWidth: number = this.vmInjector.getPanelVm().cardWidth;

  @Trace public bannerTransX: number = 0;

  @Trace public bannerTransY: number = 0;

  @Trace public scaleX: number = 1;

  @Trace public scaleY: number = 1;

  @Trace public headsUpTransitionEffect: TransitionEffect =
    NotificationConfig.HEADS_UP_DISAPPEAR_ANIM_TRANSITION_EFFECT;

  @Trace public isDeformFlag: boolean = false;

  @Trace public isShowImmersive: boolean = false;
  @Trace public isImmersiveExpanded: boolean = false;

  /**
   * banner面板横幅样式
   */
  @Trace public notificationBannerStyle: NotificationBannerStyle | undefined = undefined;

  @Trace public containerClip: boolean | undefined = undefined;

  @Trace public containerScale = 1;

  /**
   * 横幅样式顶边距，使用动效赋值，防止位置跳变
   */
  @Trace public containerMarginTop: number = 0;

  @Trace private bannerVm: BannerVm = BannerVm.instance;

  /**
   * 横幅通知VM
   */
  public headsUpVM: NotificationBannerEntryVm = new NotificationBannerEntryVm();

  public bannerAniTimeoutID: number = 0;

  public persistentId: number = 0;

  /**
   * 切换横幅出场动效的任务id
   */
  private timeId: number | undefined = undefined;

  private isHeadsUpVisibility: boolean = false;

  private isDisappear = false
  private lastDisappearTime?: number;
  private tempNtf?: NormalNotification;
  private headsUpTEChange: boolean = false;
  private verticalSwipeVm = this.vmInjector.getVerticalSwipeVm()!;
  private touchStartX = 0;
  private touchStartY = 0;
  private floatingRectCallbackPromise?: TimeoutPromise<void>;
  /**
   * 记录窗口回调来的悬浮窗宽度
   */
  private floatingRect: RectItem = new RectItem(0, 0, 0, 0);
  /**
   * 下拉开始时记录的边距,此次下拉结束前不再更新,避免蒙版跳变
   */
  private recordMargin: number = 0;
  /**
   * 下拉悬浮窗抬手后，收起蒙版的计时器
   */
  private hideMaskTimer: number | undefined = undefined;

  /**
   * 触摸promise
   */
  public touchPromise?: CustomPromise<void>;

  /**
   * 形变promise
   */
  public deformPromise?: CustomPromise<void>;

  /**
   * 屏幕ID
   */
  public screenId: number = 0;

  /**
   * 是否中景窗态
   */
  public isMidScene: boolean = false;

  public transitionEffect: TransitionEffect = TransitionEffect.asymmetric(
    TransitionEffect.OPACITY.animation({
      duration: 118,
      delay: 90,
      curve: curves.cubicBezierCurve(0.2, 0, 0.83, 1)
    })
      .combine(TransitionEffect.translate({
        x: 10,
        y: -22
      }).animation({duration: 333, curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1)})),
    TransitionEffect.OPACITY.animation({
      duration: 118,
      curve: curves.cubicBezierCurve(0.2, 0, 0.83, 1)
    })
      .combine(TransitionEffect.translate({
        x: 10,
        y: -8
      }).animation({duration: 333, curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1)}))
  );

  private liveHeadsUpTransition: TransitionEffect =
    TransitionEffect.OPACITY
      .animation({ delay: 0, curve: Curve.Linear, duration: 100 })
      .combine(TransitionEffect
        .scale({ x: 0.9, y: 0.9 }).animation({
          delay: 0,
          duration: 100,
          curve: Curve.Friction
        }));

  @Computed get margin(): Margin {
    return {
      top: this.containerMarginTop,
      right: this.notificationBannerStyle?.containerMarginRight,
      bottom: this.notificationBannerStyle?.containerMarginBottom,
      left: this.notificationBannerStyle?.containerMarginLeft,
    }
  };

  @Computed
  get containerWidth(): number | undefined {
    if (!this.verticalSwipeVm.isDeformFlag) {
      return this.notificationBannerStyle?.containerWidth;
    } else {
      return this.verticalSwipeVm.bannerDeformState.bannerWidth;
    }
  }

  @Computed
  get containerHeight(): number | undefined {
    if (!this.verticalSwipeVm.isDeformFlag) {
      return undefined;
    }
    return this.verticalSwipeVm.bannerDeformState.bannerHeight;
  }

  @Computed
  get containerScaleOptions(): ScaleOptions {
    return { x: this.containerScale, y: this.containerScale };
  }

  @Computed
  get containerTranslateY(): number | undefined {
    if (!this.verticalSwipeVm.isDeformFlag) {
      return this.verticalSwipeVm.bannerTransY;
    } else {
      return this.verticalSwipeVm.bannerDeformState.bannerTranY;
    }
  }

  @Computed
  get containerTranslateX(): number | undefined {
    if (!this.verticalSwipeVm.isDeformFlag) {
      return undefined;
    } else {
      return this.verticalSwipeVm.bannerDeformState.bannerTranX;
    }
  }

  @Computed
  get floatingLayerIconScale(): number {
    const bannerIconScale = this.verticalSwipeVm.bannerDeformState.bannerIconScale;
    // 删除该行后无法正确设置CardVm的透明度，会导致沉浸式横幅点击展开后变透明
    const iconScale = this.vmInjector.getImmersiveVm().iconScale;
    if (this.isShowImmersive || this.isImmersiveExpanded) {
      return bannerIconScale * NOTIFICATION_ICON_SMALL_SCALE;
    }
    return bannerIconScale;
  }

  @Computed get isHiddenBannerContent(): boolean {
    const privacyVm = this.ntf && this.vmInjector.getPrivacyVm(this.ntf);
    if (privacyVm) {
      return privacyVm.isProtected || privacyVm.isHidden;
    }
    return false;
  }

  @Monitor('bannerVm.itemWidth', 'bannerVm.containerMarginTop')
  onBannerStyleChange() {
    log.showInfo(TAG, `onBannerStyleChange.`)
    if (this.verticalSwipeVm) {
      this.notificationBannerStyle = {
        itemWidth: this.bannerVm.itemWidth,
        containerWidth: this.bannerVm.containerWidth,
        bannerTransY: 0,
        containerMarginTop: this.bannerVm.containerMarginTop,
        containerMarginBottom: this.bannerVm.containerMarginBottom,
        containerMarginLeft: this.bannerVm.containerMarginLeft,
        containerMarginRight: this.bannerVm.containerMarginRight,
      }
      this.setContainerMarginTop();
      this.screenId = sharedData.bannerScreenId;
    }
    this.bannerWidth = this.bannerVm.itemWidth;
    this.vmInjector.getPanelVm().cardWidth = this.bannerVm.itemWidth
  }

  //悬浮窗打开完成回调
  public onEndFloatingOpen = (): void => {
    this.verticalSwipeVm.onVanish();
    this.containerClip = undefined;
  };

  init() {
    this.headsUpVM.init(this as HeadsUpCallback);
    this.verticalSwipeVm.init();
    BannerVm.instance.emitter.on('bannerTypeChange', this.onBannerTypeChange);
    SceneSessionAdapter.registerOnNtfFloatingWindowCallback({
      callback: this.onEndFloatingOpen,
    }, TAG + '_OnNtfFloatingWindowCallback');
    SceneSessionAdapter.registerOnGetFloatingRectCallback({
      callback: this.getFloatRect
    }, TAG + '_OnGetFloatingRectCallback');
    this.onBannerStyleChange();
  }

  destroy(): void {
    this.headsUpVM.onDestroy();
    this.verticalSwipeVm.destroy();
    SceneSessionAdapter.unRegisterOnNtfFloatingWindowCallback({
      callback: this.onEndFloatingOpen,
    }, TAG + '_OnNtfFloatingWindowCallback');
    if (this.persistentId) {
      SceneSessionAdapter.setFocusable(this.persistentId, false);
    }
  }

  getNtfEntry(): NormalNotification | undefined {
    return this.ntf;
  }

  async onClick(): Promise<void> {
    if (!this.ntf) {
      log.showError(TAG, 'Cannot find ntf data');
      return;
    }
    if (this.verticalSwipeVm.isDeformFlag) {
      log.showInfo(TAG, 'Floating Window is dragging to form, ignore the click');
      return;
    }
    log.showInfo(TAG, `Click for ${this.ntf.hashCode}`);
    await this.refreshMidSceneState();
    if (await this.verticalSwipeVm?.canOpenFloating(false)) {
      this.initFloatingDeformParam();
      // ApsUtils.setApsScene(apsManager.SceneAnimation.BANNER_NOTIFICATION, APSSceneState.START_SCENE);
      if (!this.deformPromise) {
        this.deformPromise = new CustomPromise();
      }
      // 0、预置点击显示悬浮窗动效
      this.presetClickToFloatingAnimation();
      this.setChangeTransitionEffectJob();
      // 1、拉起悬浮窗
      this.verticalSwipeVm.startFloatingForClick();
      this.startFloatingEventReport();
      this.addWatcher();
      this.setHideMaskTimer();
      return;
    }
    this.vmInjector.getCardVm(this.ntf).onClick();
  }

  /**
   * 卡片触摸事件
   *
   * @param event 触摸事件
   */
  public onTouch = (event: TouchEvent): void => {
    if (event.type === TouchType.Down) {
      this.touchStartX = event.changedTouches[0].windowX;
      this.touchStartY = event.changedTouches[0].windowY;
      this.touchPromise = new CustomPromise();
      animateTo({ curve: curves.interpolatingSpring(10, 1, 350, 35) }, () => this.containerScale = 0.95)
      return;
    }
    if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      animateTo({ duration: 200, curve: Curve.Linear, }, () => this.containerScale = 1);
      if (this.touchPromise) {
        this.touchPromise.resolve();
        this.touchPromise = undefined;
      }
      return;
    }
    if (event.type === TouchType.Move) {
      // 提高触摸按压状态结束的阈值，避免无意识的轻微移动导致按压态结束
      const isNeedResetScale = Math.abs(this.touchStartX - event.changedTouches[0].windowX) > 4 ||
        Math.abs(this.touchStartY - event.changedTouches[0].windowY) > 4;
      if (this.containerScale !== 1 && isNeedResetScale) {
        animateTo({ duration: 200, curve: Curve.Linear, }, () => this.containerScale = 1);
      }
    }
  };

  /**
   * 是否正在进行横幅退场动效
   * @returns
   */
  private isDisappearEffect(): boolean {
    if (!this.isDisappear) {
      this.lastDisappearTime = undefined;
      return false;
    }
    let currentTime: number = new Date().getTime();
    log.showInfo(TAG, `isDisappearEffect, current: ${currentTime}, last: ${this.lastDisappearTime}`);
    if (this.lastDisappearTime && currentTime - this.lastDisappearTime > DISAPPEAR_EXPIRE_TIME) {
      log.showInfo(TAG, `last banner on disappear expired`);
      this.isDisappear = false;
      this.lastDisappearTime = undefined;
      return false;
    }
    return true;
  }

  public onDisappear = (): void => {
    setTimeout(() => {
      log.showInfo(TAG, 'Banner disappear end');
      this.isDisappear = false;
      this.lastDisappearTime = undefined;
      if (this.tempNtf) {
        this.notifyNtfEntryChange(this.tempNtf);
        this.tempNtf = undefined;
      }
    });
  };

  async notifyNtfEntryChange(ntf?: NormalNotification): Promise<void> {
    this.clearHideMaskTimer();
    if (this.verticalSwipeVm.isDeformFlag && this.ntf) {
      this.vmInjector.getCardVm(this.ntf).opacity = 1;
    }
    // 通知数据变化，先清理旧通知的vm数据避免残留
    this.vmInjector.deleteVmByAllNtf();
    if (ntf && this.ntf?.hashCode !== ntf.hashCode) {
      this.verticalSwipeVm.bannerDeformState.reset();
    }
    if (ntf && this.isDisappearEffect()) {
      log.showInfo(TAG, `Last entry is disappearing, cache new entry ${ntf.hashCode}`);
      this.tempNtf = ntf;
      return;
    }
    if (!ntf && this.ntf) {
      log.showInfo(TAG, `Banner disappear begin, bannerType: ${BannerVm.instance.isLiveHeadsUp()}`);
      if (BannerVm.instance.isLiveHeadsUp() && !CutoutVm.instance.isMiddleCutout()) {
        this.headsUpTransitionEffect = this.liveHeadsUpTransition;
        await SystemUICommonUtil.sleep(50); //延时50ms, 保证transition能够生效
      }
      this.isDisappear = true;
      this.lastDisappearTime = new Date().getTime();
      // 广播通知中心显示
      this.broadcastHideBanner();
    }
    log.showInfo(TAG, `notifyNtfEntryChange: ${ntf?.toSimpleString()}, isImmersive: ${this.bannerVm.isInImmersive}`);
    if (ntf) {
      this.headsUpTransitionEffect = NotificationConfig.HEADS_UP_DISAPPEAR_ANIM_TRANSITION_EFFECT;
      this.setChangeTransitionEffectJob();
      clearTimeout(this.bannerAniTimeoutID);
      // ApsUtils.setApsScene(apsManager.SceneAnimation.BANNER_NOTIFICATION, APSSceneState.START_SCENE);
      this.bannerAniTimeoutID = setTimeout(() => {
        // ApsUtils.setApsScene(apsManager.SceneAnimation.BANNER_NOTIFICATION, APSSceneState.END_SCENE);
      }, BANNER_ANI_TIMEOUT_DURATION);
      if (this.ntf?.hashCode !== ntf.hashCode) {
        this.isShowImmersive = this.bannerVm.isInImmersive && !ntf.isLiveView();
      }
    }
    this.ntf = ntf;
    if (this.ntf) {
      await this.refreshMidSceneState();
      this.verticalSwipeVm.updateFloatingWindowStatus(this.ntf, this.isMidScene);
      // 将展开的卡片隐藏起来
      if (this.isShowImmersive) {
        this.vmInjector.getCardVm(this.ntf).position = { x: 0, y: 0 };
        this.vmInjector.getCardVm(this.ntf).opacity = 0;
      }
      this.isImmersiveExpanded = false;
      this.verticalSwipeVm.bannerTransY = 0;
    } else {
      // ntf为空，删除横幅场景，重置相关信息
      this.reset();
      this.verticalSwipeVm.reset();
      this.vmInjector.getImmersiveVm().reset();
    }
  }

  public async refreshMidSceneState(): Promise<void> {
    this.isMidScene = await SceneSessionAdapter.getIsMidScene(sharedData.bannerScreenId);
    log.showInfo(TAG, `update isMidScene: ${this.isMidScene}`);
  }

  reset(): void {
    this.isShowImmersive = false;
    this.containerMarginTop = this.bannerVm.containerMarginTop;
  }

  resetWatcher(): void {
    this.headsUpVM.resetWatcher();
  }

  removeWatcher(): void {
    this.headsUpVM.removeWatcher(this);
  }

  addWatcher(): void {
    this.headsUpVM.addWatcher(this);
  }

  onHideBanner(): void {
    // 上报横幅上滑收起
    HiDfxEventUtil.reportSwipeIgnoreBannerNotification(this.ntf?.creatorBundleName);
    NotificationSysEventReporter.notificationBannerSlipUp({
      CREATOR_BUNDLE_NAME: this.ntf?.creatorBundleName,
      NOTIFICATION_ID: this.ntf?.id,
      NOTIFICATION_SLOT_TYPE: this.ntf?.slotType,
      TRACE_ID: this.ntf?.traceId
    });

    // 上滑打断铃声和振动
    InnerEventUtil.post(BannerSlideUpEvent, new BannerSlideUpEvent());

    // 上滑忽略横幅通知，记录抑制横幅1分钟
    this.headsUpVM.setIgnoreNtf();

    if (this.headsUpTEChange) {
      this.headsUpTransitionEffect = NotificationConfig.HEADS_UP_HIDE_ANIM_TRANSITION_EFFECT;
      setTimeout(() => {
        this.headsUpVM.hideHeadsUpWindowWithDelay();
      }, HEADS_UP_TRANSITION_EFFECT_CHANGE_DELAY);
      this.headsUpTEChange = false;
      if (this.timeId != undefined) {
        clearTimeout(this.timeId);
        this.timeId = undefined;
      }
    } else {
      this.headsUpVM.hideHeadsUpWindowWithDelay();
    }
  }

  releasePanel(): void {
    // 横幅立即隐藏，普通横幅延迟隐藏
    if (this.ntf?.isDeliverNotification) {
      this.headsUpVM.releasePanel();
    } else {
      this.headsUpVM.hideHeadsUpWindow();
    }
  }

  updateHeadsUpTransitionEffect(isNtfCancel?: boolean): boolean {
    let needDelay = false;
    if (!this.headsUpTEChange) {
      this.headsUpTransitionEffect = NotificationConfig.HEADS_UP_DISAPPEAR_ANIM_TRANSITION_EFFECT;
      this.headsUpTEChange = true;
      needDelay = true;
    }
    return needDelay;
  }

  private setChangeTransitionEffectJob(): void {
    if (this.timeId != undefined) {
      clearTimeout(this.timeId);
      this.timeId = undefined;
    }
    this.timeId = setTimeout(() => {
      this.headsUpTransitionEffect = NotificationConfig.HEADS_UP_HIDE_ANIM_TRANSITION_EFFECT;
      this.headsUpTEChange = false;
      this.timeId = undefined;
    }, HEADS_UP_DURATION * 0.95);
  }

  @Monitor('bannerVm.containerMarginTop','verticalSwipeVm.isDeformFlag')
  public setContainerMarginTop(): void {
    if (!this.notificationBannerStyle || this.containerMarginTop === this.getMarginTop()) {
      return;
    }
    // 横幅没在前台，不执行动效
    if (!BannerVm.instance.isHeadsUp()) {
      this.containerMarginTop = this.getMarginTop();
      return;
    }
    // 规避V2动效bug
    setTimeout(() => {
      animateTo({ curve: curves.springCurve(0, 1, 500, 30) }, () => {
        this.containerMarginTop = this.bannerVm?.containerMarginTop ?? 0;
      })
    })
  }

  /**
   * 横幅形变成悬浮窗开始时，固定顶部边距，避免蒙版受状态栏显隐影响发生位置错乱和跳变
   * @returns
   */
  public getMarginTop(): number {
    if (this.verticalSwipeVm.isDeformFlag) {
      return this.recordMargin;
    } else {
      this.recordMargin = this.bannerVm.containerMarginTop;
    }
    return this.recordMargin;
  }

  public onBannerTypeChange = (): void => {
    if (this.isHeadsUpVisibility && !BannerVm.instance.isHeadsUp()) {
      this.notifyNtfEntryChange(undefined);
    }
    this.isHeadsUpVisibility = BannerVm.instance.isHeadsUp();
  };

  /**
   * 预置点击显示悬浮窗动效，等窗口尺寸回调后再以回调传回来的尺寸进行动效
   */
  private presetClickToFloatingAnimation(): void {
    this.floatingRectCallbackPromise?.clear();
    this.floatingRectCallbackPromise = new TimeoutPromise<void>('PresetClickToFloatingAnimation')
      .addRemovePromiseCallback(this.clearFloatingRectCallbackPromise)
      .addThenCallback(this.doClickToFloating)
      .startTimeout(CLICK_TO_FLOATING_ANIMATION_MAX_WAIT_TIME);
  }

  private clearFloatingRectCallbackPromise = (promise: TimeoutPromise<void>) => {
    if (this.floatingRectCallbackPromise === promise) {
      log.showInfo(TAG, 'Clear floatingRectCallbackPromise');
      this.floatingRectCallbackPromise = undefined;
    } else {
      log.showWarn('Clear floatingRectCallbackPromise fail. curr: %{public}s, target: %{public}s',
        this.floatingRectCallbackPromise?.toString(), promise.toString());
    }
  }

  private doClickToFloating = () => {
    // 2、点击展示悬浮窗动效
    log.showInfo(TAG, `headsUpStyle: out this.getFloatRect=${this.floatingRect}`)
    this.verticalSwipeVm.bannerDeformState.bannerToFloating = true;
    this.headsUpTransitionEffect = TransitionEffect.IDENTITY;
    this.verticalSwipeVm.clickToFloating(this.floatingRect);
  };

  private getFloatRect: (rect: RectItem)=> void = (rect: RectItem) => {
    this.floatingRect = new RectItem(rect.left, rect.top, rect.right, rect.bottom);
    this.floatingRectCallbackPromise?.manuallyResolve('OnGetFloatingRectCallback');
    log.showInfo(TAG, `headsUpStyle: in this.getFloatRect=${this.floatingRect}`);
  }

  public isStartingFloatingWindow(): boolean {
    log.showInfo(TAG, `is starting floating window ${this.verticalSwipeVm.bannerDeformState.bannerToFloating}`);
    return this.verticalSwipeVm.bannerDeformState.bannerToFloating;
  }

  private initFloatingDeformParam(): void {
    this.verticalSwipeVm.initBannerDeformParam(0);
    this.verticalSwipeVm.isDeformFlag = true;
    this.verticalSwipeVm.isInitParam = true;
    this.vmInjector.getImmersiveVm().cardHeight = '100%';
  }

  /**
   * 广播横幅上滑收起事件
   */
  private broadcastHideBanner(): void {
    if (!this.ntf?.isLiveView()) {
      log.showInfo(TAG, `broadcastHideBanner fail, ntfEntry is ${this.ntf?.toSimpleString()}`);
      return;
    }
    log.showInfo(TAG, `broadcastHideBanner hide headsup ${this.ntf?.toSimpleString()}`);
    let dataBanner: Map<string, string> = new Map();
    dataBanner.set('id', `${this.ntf?.id}`);
    dataBanner.set('creatorBundleName', `${this.ntf?.creatorBundleName}`);

    EventBroadcast.broadcastEvent(SysUiWindowType.WINDOW_BANNER, false, dataBanner);
  }

  clearChangeTransitionEffectJob(): void {
    clearTimeout(this.timeId);
  }

  /**
   * 设置超时收起兜底计时任务
   */
  public setHideMaskTimer = (): void => {
    this.clearHideMaskTimer();
    // 抬手后3s如果计时器还没有被清理, 就主动调用onVanish收起蒙版, 避免窗口不回调导致横幅不出现/无法下拉等异常情况
    log.showWarn(TAG, 'cur going to floating, set timer to hide banner mask');
    this.hideMaskTimer = setTimeout(() => {
      log.showWarn(TAG, 'hide banner mask for time out');
      this.verticalSwipeVm.onVanish();
    }, ACTION_END_HIDE_BANNER_PANEL_LIMIT);
  }

  /**
   * 清理超时收起兜底计时任务
   */
  private clearHideMaskTimer = (): void => {
    if (this.hideMaskTimer !== undefined) {
      clearTimeout(this.hideMaskTimer);
      this.hideMaskTimer = undefined;
    }
  }

  private startFloatingEventReport() {
    NotificationSysEventReporter.notificationBannerToFloating({
      CREATOR_BUNDLE_NAME: this.ntf?.creatorBundleName,
      NOTIFICATION_ID: this.ntf?.id,
      NOTIFICATION_SLOT_TYPE: this.ntf?.slotType,
      OPERATION: FloatingOperationType.CLICK,
      TRACE_ID: this.ntf?.traceId
    });
  }
}