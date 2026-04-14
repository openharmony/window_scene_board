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
import {
  APSSceneState,
  bannerMgr,
  BannerState,
  VibratorUtil,
  NotificationSysEventReporter,
  FloatingOperationType,
  XTLayoutType,
} from '@ohos/systemuicommon';
import {
  AnimationBase,
  BannerVm,
  EnvVm,
  INotificationVerticalSwipeVm,
  NotificationBannerDeformState,
  NotificationBaseVm
} from '@ohos/systemuicommon/newIndex';
import curves from '@ohos.curves';
import { NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { CommonUtils, LogDomain, Logger, RectItem } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  FloatSceneSizeData,
  FloatSizeState,
} from '@ohos/windowscene/src/main/ets/TsIndex';
import { BannerFloatingController, FloatingCapacityUpdateListener } from '../../../controller/BannerFloatingController';
import { NotificationConfig } from '../../../common/NotificationConfig';
import { NotificationApiUtil } from '../../../utils/NotificationApiUtil';
import { ApsUtils, CustomPromise } from '@ohos/frameworkwrapper';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { ScreenSessionAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/ScreenSessionAdapter';
import { SceneSessionAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/SceneSessionAdapter';
import { LayoutUtils } from '@ohos/systemuicommon/src/main/ets/TsIndex';

const TAG = 'NotificationVerticalSwipeVm';
const log: Logger = Logger.getLogHelper(LogDomain.NC);

/**
 * 图标左侧Margin
 */
const ICON_MARGIN_LEFT = 12;
/**
 * 向上竖滑阻尼系数，竖移值*系数
 */
const SWIPE_DAMP = 0.5;
/**
 * 向下竖滑阻尼系数，竖移值*系数
 */
const SWIPE_DAMP_DOWN = 0.15;

/**
 * 竖滑往下的最大位移
 */
const BANNER_DOWN_MAX_OFFSET = 160;
/**
 * 宽屏判断最小阈值，vp
 * 达到阈值，布局按宽屏布局处理
 */
const WIDTH_THRESHOLD_SMALL: number = 600;

/**
 * 屏幕宽度分级
 */
enum ScreenWidth {
  LARGE = 375,
  MIDDLE = 360
}

/**
 * 不同屏幕宽度下的图标大小
 */
enum IconSize {
  LARGE = 58,
  MIDDLE = 54,
  SMALL = 52
}

@ObservedV2
export class NotificationVerticalSwipeVm extends NotificationBaseVm implements INotificationVerticalSwipeVm,
FloatingCapacityUpdateListener {
  @Trace public bannerTransY: number = 0;

  @Trace public isDeformFlag: boolean = false;

  @Trace public isInitParam: boolean = false;

  /**
   * 形变相关参数
   */
  @Trace public bannerDeformState: NotificationBannerDeformState = new NotificationBannerDeformState();
  @Trace public dropActionEnd: boolean = false;

  @Trace public dropAnimEnd: boolean = false;

  @Trace public isSupportFloating = false;

  /*
   * banner、实况窗口状态管理
   */
  public bannerState: BannerState = bannerMgr.getBannerState();

  public defaultFloatingRect: RectItem = new RectItem(0, 0, 0, 0);

  public dropAnimCnt: number = 0;

  /**
   * 是否展示悬浮窗
   */
  public showFloatingWindow: boolean = false;

  /**
   * 当次滑动是否为竖向滑动
   */
  private isVertical: boolean = false;

  /**
   * 开始滑动前，条目平移位置
   */
  private startAnimItemTranY: number = 0;

  /**
   * 横幅悬浮窗
   */
  public floatingController: BannerFloatingController = new BannerFloatingController();

  /**
   * 待删除的悬浮窗消息
   */
  private needDeleteFloatingEntry: NotificationBase | undefined = undefined;

  /**
   * 判断悬浮窗形变参数是否更新
   */
  private isUpdateDeformFlag: boolean = false;

  /**
   * 记录原始形变动效相关参数
   */
  private originalBannerDeformState: NotificationBannerDeformState = new NotificationBannerDeformState();
  /**
   * 记录桌面图标大小
   */
  private desktopIconSize: number = 54;

  /**
   * 图标大小
   */
  private iconSize = 32;

  /**
   * 记录生成的悬浮窗宽度
   */
  private floatingRect: RectItem = new RectItem(0, 0, 0, 0);

  /**
   * 记录屏幕高度
   */
  private screenHeight: number = 792;

  /**
   * 记录屏幕宽度
   */
  private screenWidth: number = 384;
  private realBannerDeformState: NotificationBannerDeformState = new NotificationBannerDeformState();
  /**
   * 是不是需要开启震感提示
   */
  private isStartVibration: boolean = false;

  /**
   * 本次横幅下拉是由侧边指纹发起的
   */
  private isFingerSwipe: boolean = false;

  init(): void {
    this.floatingController.registerFloatingCapacityChangedListener(this);
  }

  destroy(): void {
    this.floatingController.unregisterFloatingCapacityChangedListener(this);
  }

  /**
   * 是否竖向滑动
   *
   * @param event 滑动事件
   * @return true 竖向
   */
  private isVerticalSwipe(event: GestureEvent): boolean {
    return Math.abs(event.offsetY) > Math.abs(event.offsetX);
  }

  public onFloatingCapacityChanged(isSupportFloating: boolean): void {
    log.showInfo(TAG, `Update isSupportFloating: ${this.isSupportFloating}`)
    this.isSupportFloating = isSupportFloating;
  }

  public async canOpenFloating(isSwipe: boolean): Promise<boolean> {
    if (this.vmInjector.getBannerVm().isMidScene) {
      // 中景窗状态不显示悬浮窗
      return false;
    }
    return await this.floatingController.canOpenFloatingAsync(isSwipe, EnvVm.instance.isImmersive);
  }

  public startFloatingForClick(): void {
    this.floatingController.startFloatingWindowForClick();
  }

  async onEndSwipeWithFloatingWindow(isFingerSwipe: boolean): Promise<void> {
    if (await this.floatingController.canOpenFloatingAsync(true, EnvVm.instance.isImmersive)) {
      isFingerSwipe && VibratorUtil.startFingerprintVibration();
      this.floatingController.startFloatingWindowForSwipe();
      return;
    }
  }

  onPanStart(event: GestureEvent): void {
    log.showInfo(TAG, `onPanStart, offsetY: ${event.offsetY}`);
    this.vmInjector.getBannerVm().refreshMidSceneState();
    this.isUpdateDeformFlag = false;
    this.isDeformFlag = false;
    this.isInitParam = false;
    this.vmInjector.getBannerVm().headsUpTransitionEffect = NotificationConfig.HEADS_UP_HIDE_ANIM_TRANSITION_EFFECT;
    this.isVertical = this.isVerticalSwipe(event);
    // 只处理竖滑
    if (!this.isVertical) {
      return;
    }
    // 开始滑动时，记录条目平移位置
    this.startAnimItemTranY = event.offsetY;
    // 刷新位移，无需动效
    this.notifyTranYChange(event.offsetY);
    this.vmInjector.getBannerVm().addWatcher();
  }

  async onPanUpdate(event: GestureEvent): Promise<void> {
    // 下滑时更新悬浮窗参数
    if (event.offsetY > 0 && !this.isUpdateDeformFlag) {
      this.initDeformParam(0);
      this.isDeformFlag = await this.canOpenFloating(true);
      this.isInitParam = true;
      this.isUpdateDeformFlag = true;
    }
    // 横滑不处理
    if (!this.isVertical) {
      return;
    }
    if (await this.canOpenFloating(true) && event.offsetY > 0) {
      // 处理形变
      if (!this.vmInjector.getBannerVm().deformPromise) {
        this.vmInjector.getBannerVm().deformPromise = new CustomPromise();
      }
      this.vmInjector.getBannerVm().containerClip = true;
      this.notifyDeformChange(event.offsetY, this.originalBannerDeformState.bannerHeight);
    } else {
      // 刷新位移，无需动效
      this.notifyTranYChange(event.offsetY);
    }
  }

  async onPanEnd(event: GestureEvent): Promise<void> {
    log.showInfo(TAG, `onPanEnd, offsetY: ${event.offsetY}`);
    // 下滑打点
    if (event.offsetY > 0) {
      this.dropDownBannerEventReport();
    }
    // 拉起悬浮窗
    if (this.showFloatingWindow && await this.canOpenFloating(true) && event.offsetY > 0) {
      if (this.dropAnimEnd) {
        this.onEndSwipeWithFloatingWindow(false);
        this.dropActionEnd = false; // reset after start floating window
        this.dropAnimEnd = false; // reset after start floating window
        this.startFloatingEventReport(FloatingOperationType.PULL_DOWN);
      } else {
        this.dropActionEnd = true; // set drop action true end when drop anim not end
      }
      this.bannerTransY = 0;
      // 悬浮窗下拉后取消上滑退出动效
      this.vmInjector.getBannerVm().headsUpTransitionEffect = TransitionEffect.IDENTITY;
      // 抬手可以拉起悬浮窗时，设置兜底
      this.vmInjector.getBannerVm().setHideMaskTimer();
      return;
    }
    // 松手时不能拉起悬浮窗,将悬浮窗标志位复位
    this.isDeformFlag = false;
    this.showFloatingWindow = false;
    this.isInitParam = false;
    // 沉浸态横屏条件下marginTop为8
    let immersiveTop = this.vmInjector.getBannerVm().notificationBannerStyle?.containerMarginTop! < 20;
    // 横滑不处理
    if (!this.isVertical) {
      return;
    }
    if (await this.canOpenFloating(true) && event.offsetY > 0) {
      this.handleSwipeTouchEndWithDeform(event.offsetY);
    } else {
      // 刷新位移，无需动效
      this.notifyTranYChange(event.offsetY);
      // 结束滑动
      this.handleSwipeTouchEndY(immersiveTop, event.offsetY);
    }
    if (this.vmInjector.getBannerVm().deformPromise) {
      this.vmInjector.getBannerVm().deformPromise?.resolve();
      this.vmInjector.getBannerVm().deformPromise = undefined;
    }
    this.vmInjector.getBannerVm().removeWatcher();
    this.bannerDeformState.reset();
  }

  onPanCancel(): void {
    log.showInfo(TAG, `onPanCancel`);
    this.onCancelSwipe();
    this.bannerTransY = 0;
    this.vmInjector.getBannerVm().removeWatcher();
    // 形变过程打断兜底
    this.vmInjector.getBannerVm().deformPromise?.resolve();
    this.bannerDeformState.reset();
  }

  initBannerDeformParam(height: number): void {
    if (!this.isInitParam) {
      this.initDeformParam(height);
    }
  }

  /**
   * 移动距离回调
   *
   * @param tranY 触摸竖移距离
   */
  private notifyTranYChange(tranY: number): void {
    let oriItemTranY = tranY + this.startAnimItemTranY;
    let realItemTranY = oriItemTranY;

    if (oriItemTranY < 0) {
      realItemTranY = oriItemTranY * SWIPE_DAMP;
      log.showInfo(TAG, `up oriItemTranY:${oriItemTranY} realItemTranY:${realItemTranY}`);
    } else { // 向下偏移
      realItemTranY = oriItemTranY * SWIPE_DAMP_DOWN;
      if (realItemTranY > BANNER_DOWN_MAX_OFFSET) {
        realItemTranY = BANNER_DOWN_MAX_OFFSET;
      }
      log.showInfo(TAG, `down oriItemTranY:${oriItemTranY} realItemTranY:${realItemTranY}`);
    }
    log.showInfo(TAG, `notifyTranYChange:${tranY} realItemTranY:${realItemTranY}`);
    // 回调，无需动效
    this.notifyTranYEndValue(realItemTranY);
  }

  /**
   * 回调竖移最终值
   *
   * @param endTranY 最终值
   * @param itemAnim 动效参数
   */
  private notifyTranYEndValue(endTranY: number, itemAnim?: AnimateParam): void {
    // 无变化，直接返回
    if (this.bannerTransY === endTranY) {
      return;
    }
    // 无指定动效参数则使用默认弹簧曲线
    if (CommonUtils.isInvalid(itemAnim)) {
      new AnimationBase(AnimationBase.NAMES.LIVE_HEAD_UP_SWIPE_ANIMATION, true).executeAnimation([
        {
          curve: curves.responsiveSpringMotion(),
          event: () => this.bannerTransY = endTranY,
        },
      ]);
    } else {
      new AnimationBase(AnimationBase.NAMES.LIVE_HEAD_UP_SWIPE_ANIMATION, true).executeAnimation([
        {
          curve: itemAnim?.curve,
          duration: itemAnim?.duration,
          event: () => this.bannerTransY = endTranY,
        },
      ]);
    }
  }

  /**
   * 处理touch滑动结束事件，上滑时，根据手指实际滑动距离判断是否收起
   */
  private handleSwipeTouchEndY(isImmersive?: boolean, offsetY?: number): void {
    log.showInfo(TAG, `handleSwipeTouchEnd, bannerTransY:${this.bannerTransY}, offsetY:${offsetY}`);
    // 结束滑动时，向上滑，需要达到一定值才隐藏通知，否则回归原位
    if (this.bannerTransY < 0) {
      // 默认回归原位
      let endTranY: number = 0;
      // 隐藏通知
      let hideDistance = isImmersive ? NotificationConfig.HIDE_HEADS_UP_DISTANCE_IMMERSIVE :
      NotificationConfig.HIDE_HEADS_UP_DISTANCE;
      const curMoveDistance: number = offsetY ?? this.bannerTransY;
      if (Math.abs(curMoveDistance) > hideDistance) {
        // 上滑不能只依赖于横幅entry=null时的消失动效，滑动结束到entryChange=null中间会有延迟
        this.startTranYAnim(NotificationConfig.HIDE_HEADS_UP_ANIM_DISTANCE, true);
        this.vmInjector.getBannerVm().onHideBanner();
      } else {
        // 开始位移动画
        this.startTranYAnim(endTranY);
      }
      log.showInfo(TAG, `handleSwipeTouchEnd: endTranY=${endTranY} itemTranY=${this.bannerTransY}`);

    } else {
      log.showInfo(TAG, `handleSwipeTouchEnd: down , return to 0`);
      // 往下滑，默认回归原位
      this.startTranYAnim(0);
    }
  }

  /**
   * 开启移动动画
   *
   * @param endTranY 移动最终值
   * @param isHideEntry 是否隐藏通知
   */
  private startTranYAnim(endTranY: number, isHideEntry: boolean = false): void {
    // 位移动画
    let anim: AnimateParam = {
      // 距离乘以系数(10)作为毫秒数
      duration: Math.round(Math.abs(endTranY - this.bannerTransY)) * 10,
      curve: curves.springCurve(0, 1, 80, 14),
    }
    if (isHideEntry) {
      anim = { curve: curves.springMotion() }
    }
    // 开始位移
    this.notifyTranYEndValue(endTranY, anim);
  }

  /**
   * 竖滑被取消
   */
  async onCancelSwipe(): Promise<void> {
    // 横滑不处理
    if (!this.isVertical) {
      return;
    }
    if (await this.canOpenFloating(true)) {
      this.handleSwipeTouchEndWithDeform(0);
    } else {
      // 结束滑动
      this.handleSwipeTouchEndY();
    }
  }

  async initDeformParam(bannerHeight: number): Promise<void> {
    // 初始化参数
    let screenWidth = ArkUIAdapter.px2vp(BannerVm.instance.getDisplayWidth());
    let screenHeight = ArkUIAdapter.px2vp(BannerVm.instance.getDisplayHeight());
    let screenWidthPx = BannerVm.instance.getDisplayWidth();
    let screenHeightPx = BannerVm.instance.getDisplayHeight();
    let isXTGDisplay: boolean = LayoutUtils.isMatchXTFoldMode(XTLayoutType.G);
    let state: FloatSizeState;
    if (!isXTGDisplay && LayoutUtils.isPadLayout()) {
      state = screenWidthPx < screenHeightPx ? FloatSizeState.PORTRAIT_PAD : FloatSizeState.LANDSCAPE_PAD;
    } else if (await this.isExpandState() || isXTGDisplay) {
      // 折叠屏展开态
      state = screenWidthPx < screenHeightPx ? FloatSizeState.EXPAND_PORTRAIT : FloatSizeState.EXPAND_LANDSCAPE;
      // 横屏状态
    } else if (this.isWidestScreen()) {
      state = FloatSizeState.LANDSCAPE;
      // 竖屏状态
    } else {
      state = FloatSizeState.PORTRAIT;
    }
    let floatingRect = FloatSceneSizeData.getDefaultRect(state, screenWidthPx, screenHeightPx);
    let floatWidth = ArkUIAdapter.px2vp(floatingRect.width());
    let floatHeight = ArkUIAdapter.px2vp(floatingRect.height());
    this.defaultFloatingRect = new RectItem(
      (screenWidth - floatWidth) / 2, (screenHeight - floatHeight) / 2,
      (screenWidth + floatWidth) / 2, (screenHeight + floatHeight) / 2);
    const bannerStyle = this.vmInjector.getBannerVm().notificationBannerStyle!;
    if (bannerStyle === undefined) {
      log.showWarn(TAG, 'initDeformParam bannerStyle === undefined');
      return;
    }
    let immersiveState = this.bannerState.immersiveState;
    let useSmallIcon = immersiveState?.isImmersive ? true : false;
    this.originalBannerDeformState.bannerWidth = bannerStyle.itemWidth;
    // 获取当前屏幕高宽
    this.screenWidth = screenWidth;
    this.screenHeight = screenHeight;
    this.floatingRect = this.defaultFloatingRect;
    this.calculateDesktopIconSize(this.screenWidth, this.screenHeight);

    // 获取当前通知横幅的高度
    if (bannerHeight > 0) {
      this.originalBannerDeformState.bannerHeight = bannerHeight;
    }
    this.iconSize = useSmallIcon ? 20 : 32;
    this.realBannerDeformState.update(this.originalBannerDeformState);
    this.bannerDeformState.update(this.realBannerDeformState);
  }

  async isExpandState(): Promise<boolean> {
    return await ScreenSessionAdapter.isFoldablePhoneExpandStatus();
  }

  onDropDeformAnim(bannerDeformState: NotificationBannerDeformState): void {
    this.dropAnimCnt++;
    this.showFloatingWindow = bannerDeformState.bannerToFloating;
    this.bannerDeformState.bannerMaskingVisibility = true;
    new AnimationBase(AnimationBase.NAMES.FLOATING_LAYER_ANIMATION, true).executeAnimation([{
      curve: curves.springMotion(0.5, 0.8),
      onFinish: () => {
        this.dropAnimCnt--;
        if (this.dropAnimCnt === 0) {
          // start floating when can show floating and drop action end
          if (this.dropActionEnd && this.showFloatingWindow) {
            this.onEndSwipeWithFloatingWindow(this.isFingerSwipe);
            this.isFingerSwipe = false;
            // 悬浮窗下拉后取消上滑退出动效
            this.vmInjector.getBannerVm().headsUpTransitionEffect = TransitionEffect.IDENTITY;
            this.dropActionEnd = false; // reset after start floating window
            this.dropAnimEnd = false; // reset after start floating window
            this.startFloatingEventReport(FloatingOperationType.PULL_DOWN);
          } else {
            this.dropAnimEnd = this.showFloatingWindow; // set true when can show floating
          }
        }
      }, event: () => {
        this.bannerDeformState.update(bannerDeformState);
      }
    }]);
  }

  onClickDeformAnim(bannerDeformState: NotificationBannerDeformState): void {
    this.showFloatingWindow = bannerDeformState.bannerToFloating;
    this.bannerDeformState.bannerMaskingVisibility = true;
    let ntf = this.vmInjector.getBannerVm().ntf;

    new AnimationBase(AnimationBase.NAMES.FLOATING_LAYER_ANIMATION, true).executeAnimation([{
      curve: curves.springMotion(0.5, 0.8),
      event: () => {
        this.bannerDeformState.update(bannerDeformState);
        if (ntf) {
          this.vmInjector.getCardVm(ntf).opacity = bannerDeformState.bannerOpacity;
        }
      },
      onFinish: () => {
        SceneSessionAdapter.notifyAnimationFinishedCallback(true);
        // ApsUtils.setApsScene(apsManager.SceneAnimation.BANNER_NOTIFICATION, APSSceneState.END_SCENE);
      }
    }]);
  }

  onItemVanishAnim(bannerDeformState: NotificationBannerDeformState): void {
    if (this.vmInjector.getBannerVm().ntf?.hashCode) {
      this.needDeleteFloatingEntry = this.vmInjector.getBannerVm().ntf;
      this.vmInjector.getBannerVm().headsUpTransitionEffect = TransitionEffect.IDENTITY;
    }
    // 白板消失动画
    new AnimationBase(AnimationBase.NAMES.BANNER_MASK_DISAPPEAR_ANIMATION, true).executeAnimation([
      {
        curve: curves.springMotion(0.4, 1.0),
        onFinish: () => {
          // 移除通知
          log.showInfo(TAG, `removeEntry when itemVanishAnim finish: ${this.vmInjector.getBannerVm().ntf?.hashCode}`);
          this.vmInjector.getBannerVm().removeWatcher();
          this.removeEntry();
          this.showFloatingWindow = false;
        },
        event: () => this.bannerDeformState.bannerMaskingOpacity = bannerDeformState.bannerOpacity,
      },
    ]);
    // 中心图标放大动画
    new AnimationBase(AnimationBase.NAMES.BANNER_MASK_ICON_SCALE_ANIMATION, true).executeAnimation([
      {
        curve: curves.springMotion(0.25, 1.0),
        event: () => this.bannerDeformState.bannerIconScale = bannerDeformState.bannerIconScale,
      },
    ]);
  }

  private removeEntry(): void {
    let delList: NotificationBase[] = [];
    if (this.vmInjector.getBannerVm().ntf?.hashCode) {
      delList.push(this.vmInjector.getBannerVm().ntf as NotificationBase);
      NotificationApiUtil.removeNtfByCancel(delList);
    } else if (this.needDeleteFloatingEntry) {
      log.showInfo(TAG, `remove needDeleteFloatingEntry: ${this.needDeleteFloatingEntry?.hashCode}`);
      delList.push(this.needDeleteFloatingEntry);
      NotificationApiUtil.removeNtfByCancel(delList);
      this.needDeleteFloatingEntry = undefined;
    }
    this.vmInjector.getBannerVm().resetWatcher();
  }

  /**
   * 形变回调
   *
   * @param tranY 触摸竖移距离
   */
  private notifyDeformChange(tranY: number, threshold: number, vibratorFunc?: () => void): void {
    // 构建形变参数
    let bannerDeformState = this.buildDeformAnimParam(tranY, threshold, vibratorFunc);

    // 有变化，执行形变动画
    if (!this.realBannerDeformState.equal(bannerDeformState)) {
      this.realBannerDeformState.update(bannerDeformState);
      this.onDropDeformAnim(bannerDeformState);
    }
  }

  private buildDeformAnimParam(tranY: number, threshold: number, vibratorFunc?: (() => void)) {
    let oriItemTranY = tranY + this.startAnimItemTranY;

    let bannerDeformState = new NotificationBannerDeformState();
    bannerDeformState.update(this.originalBannerDeformState);
    bannerDeformState.bannerMaskingVisibility = true;

    if (oriItemTranY < 0) {
      // 位移
      bannerDeformState.bannerTranY = oriItemTranY * SWIPE_DAMP;
      log.showInfo(TAG, `up oriItemTranY:${oriItemTranY} realItemTranY:${bannerDeformState.bannerTranY}`);
    } else if (oriItemTranY < threshold) {
      // situation: 越过阈值后, 又上滑退到阈值前，允许下次越过阈值时再次震动
      this.isStartVibration = true;
      // 横幅位移
      bannerDeformState.bannerTranY = oriItemTranY * 0.5;
      // 横幅形变
      bannerDeformState.bannerHeight = this.originalBannerDeformState.bannerHeight + 0.5 * oriItemTranY;
      // 文字不透明度
      bannerDeformState.bannerTextOpacity = 1 - oriItemTranY / this.originalBannerDeformState.bannerHeight;
      // 蒙版不透明度
      bannerDeformState.bannerMaskingOpacity = oriItemTranY / this.originalBannerDeformState.bannerHeight;
      // 图标尺度变化
      bannerDeformState.bannerIconScale = 1 + (oriItemTranY / this.originalBannerDeformState.bannerHeight) *
        (this.desktopIconSize / this.iconSize - 1);
      // 图标横向位移
      bannerDeformState.bannerIconTranX = ICON_MARGIN_LEFT +
        (oriItemTranY / this.originalBannerDeformState.bannerHeight) *
          ((this.originalBannerDeformState.bannerWidth - this.iconSize) / 2 - ICON_MARGIN_LEFT);
    } else {
      // 横幅位移
      bannerDeformState.bannerTranY = this.floatingRect.top - this.vmInjector.getBannerVm().getMarginTop();
      // 横幅形变
      bannerDeformState.bannerHeight = this.floatingRect.height();
      bannerDeformState.bannerWidth = this.floatingRect.width();
      // 蒙版不透明度
      bannerDeformState.bannerMaskingOpacity = 1;
      // 文字不透明度
      bannerDeformState.bannerTextOpacity = 0;
      // 图标尺度变化
      bannerDeformState.bannerIconScale = this.desktopIconSize / this.iconSize;
      // 图标横向位移
      bannerDeformState.bannerIconTranX = (bannerDeformState.bannerWidth - this.iconSize) / 2;
      // 达到生成悬浮窗条件
      bannerDeformState.bannerToFloating = true;
      // 下拉时增加震感
      if (this.isStartVibration) {
        log.showInfo(TAG, `startFingerprintVibration, distanceY:${ArkUIAdapter.vp2px(Math.abs(oriItemTranY))}`);
        vibratorFunc && vibratorFunc();
        this.isStartVibration = false;
      }
    }
    return bannerDeformState;
  }

  private calculateDesktopIconSize(screenWidth: number, screenHeight: number): void {
    let width = Math.min(screenWidth, screenHeight);
    // 当前复用的桌面图标大小计算逻辑(src/main/ets/SceneBoard/controllers/SceneDesktopController/PhoneLayoutRulesController.ts)
    if (width >= ScreenWidth.LARGE) {
      this.desktopIconSize = IconSize.LARGE;
    } else if (width < ScreenWidth.MIDDLE) {
      this.desktopIconSize = IconSize.SMALL;
    } else {
      this.desktopIconSize = IconSize.MIDDLE;
    }
  }

  /**
   * 回调下拉形变最终值
   *
   * @param bannerDeformState 形变参数
   */
  notifyDropDeformAnim(bannerDeformState: NotificationBannerDeformState): void {
    // 有变化，回调
    if (!this.realBannerDeformState.equal(bannerDeformState)) {
      this.realBannerDeformState.update(bannerDeformState);
      this.onDropDeformAnim(bannerDeformState);
    }
  }

  /**
   * 处理touch滑动结束事件(带形变)
   */
  private handleSwipeTouchEndWithDeform(offSetY: number): void {
    log.showInfo(TAG, 'handleSwipeTouchEndWithDeform, offSetY: %{public}d', offSetY);
    // 结束滑动时，向上滑，需要达到一定值才隐藏通知，否则回归原位
    if (offSetY < 0) {
      // 默认回归原位
      let endTranY: number = 0;
      this.realBannerDeformState.endTranY = endTranY;
      // 隐藏通知
      if (Math.abs(offSetY) > NotificationConfig.HIDE_HEADS_UP_DISTANCE) {
        this.startTranYAnim(NotificationConfig.HIDE_HEADS_UP_ANIM_DISTANCE, true)
        this.vmInjector.getBannerVm().onHideBanner();
      } else {
        this.notifyDeformChange(0, this.originalBannerDeformState.bannerHeight);
      }
      log.showInfo(TAG, `handleSwipeTouchEndWithDeform: endTranY=${endTranY} itemTranY=${offSetY}`);
    } else {
      log.showInfo(TAG, 'handleSwipeTouchEndWithDeform: down , return to 0');
      // 往下滑，默认回归原位
      this.notifyDeformChange(0, this.originalBannerDeformState.bannerHeight);
    }
  }

  public updateFloatingWindowStatus(entry: NotificationBase, isMidScene: boolean): void {
    this.floatingController.updateFloatingWindowStatus(entry, isMidScene);
  }

  public getVerticalSwipeGesture(): GestureGroupHandler {
    const isShowImmersive: boolean = this.vmInjector.getBannerVm().isShowImmersive;
    const isShowExpandIcon: boolean = this.vmInjector.getImmersiveVm().isShowExpandIcon;
    log.showInfo(TAG, 'isShowImmersive: %{public}s, isShowExpandIcon:%{public}s', isShowImmersive, isShowExpandIcon);
    if (isShowImmersive && isShowExpandIcon) {
      return this.getImmersiveVerticalSwipeGesture();
    } else {
      return this.getNormalVerticalSwipeGesture();
    }
  }

  private getNormalVerticalSwipeGesture(): GestureGroupHandler {
    return new GestureGroupHandler({
      mode: GestureMode.Parallel,
      gestures: [new PanGestureHandler({
        direction: PanDirection.Vertical,
      })
        .onActionStart((event: GestureEvent) => this.onPanStart(event))
        .onActionUpdate((event: GestureEvent) => this.onPanUpdate(event))
        .onActionEnd((event: GestureEvent) => this.onPanEnd(event))
        .onActionCancel(() => this.onPanCancel())]
    });
  }

  private getImmersiveVerticalSwipeGesture(): GestureGroupHandler {
    return new GestureGroupHandler({
      mode: GestureMode.Parallel,
      gestures: [this.getImmersiveVerticalDownGesture(), this.getImmersiveVerticalUpGesture()],
    });
  }

  private getImmersiveVerticalDownGesture(): PanGestureHandler {
    return new PanGestureHandler({
      direction: PanDirection.Down,
    })
      .onActionEnd(() => {
        log.showInfo(TAG, `on immversiveVerticalSwipeEnd`);
        this.vmInjector.getImmersiveVm().expandToCard();
      })
      .onActionCancel(() => {
        log.showInfo(TAG, `on immersiveVerticalSwipeCancel`);
        this.vmInjector.getImmersiveVm().expandToCard();
      });
  }

  private getImmersiveVerticalUpGesture(): PanGestureHandler {
    return new PanGestureHandler({
      direction: PanDirection.Up,
    })
      .onActionStart((event: GestureEvent) => this.onPanStart(event))
      .onActionUpdate((event: GestureEvent) => this.onPanUpdate(event))
      .onActionEnd((event: GestureEvent) => this.onPanEnd(event))
      .onActionCancel(() => this.onPanCancel());
  }

  public onVanish(): void {
    this.realBannerDeformState.bannerOpacity = 0;
    this.realBannerDeformState.bannerIconScale = 1.2 * this.desktopIconSize / this.iconSize;
    this.bannerDeformState.bannerOpacity = 0;
    const ntf = this.vmInjector.getBannerVm().ntf;
    if (ntf) {
      this.vmInjector.getCardVm(ntf).opacity = 0;
    }
    this.vmInjector.getBannerVm().clearChangeTransitionEffectJob();
    if (this.vmInjector.getBannerVm().deformPromise) {
      this.vmInjector.getBannerVm().deformPromise?.resolve();
      this.vmInjector.getBannerVm().deformPromise = undefined;
    }
    // 不要删除setTimeout，会导致卡片阴影问题
    setTimeout(() => {
      this.onItemVanishAnim(this.realBannerDeformState);
    })
  }

  /**
   * 更新点击形变事件
   */
  clickToFloating(floatingRect: RectItem): void {
    if (floatingRect.width() !== 0 && floatingRect.height() !== 0) {
      this.floatingRect.left = ArkUIAdapter.px2vp(floatingRect.left);
      this.floatingRect.top = ArkUIAdapter.px2vp(floatingRect.top);
      this.floatingRect.right = ArkUIAdapter.px2vp(floatingRect.right);
      this.floatingRect.bottom = ArkUIAdapter.px2vp(floatingRect.bottom);
    }

    // 初始化
    let bannerClickDeform = new NotificationBannerDeformState();
    bannerClickDeform.update(this.originalBannerDeformState);
    bannerClickDeform.bannerMaskingVisibility = true;

    // 横幅位移
    bannerClickDeform.bannerTranX = this.floatingRect.left - (this.screenWidth - this.floatingRect.width()) / 2;
    bannerClickDeform.bannerTranY = this.floatingRect.top - this.vmInjector.getBannerVm().getMarginTop();
    // 横幅形变
    bannerClickDeform.bannerHeight = this.floatingRect.height();
    bannerClickDeform.bannerWidth = this.floatingRect.width();
    // 蒙版不透明度
    bannerClickDeform.bannerMaskingOpacity = 1;
    // 文字不透明度
    bannerClickDeform.bannerTextOpacity = 0;
    // 图标尺度变化
    bannerClickDeform.bannerIconScale = this.desktopIconSize / this.iconSize;
    // 图标横向位移
    bannerClickDeform.bannerIconTranX = (bannerClickDeform.bannerWidth - this.iconSize) / 2;
    // 达到生成悬浮窗条件
    bannerClickDeform.bannerToFloating = true;
    this.notifyClickDeformAnim(bannerClickDeform);
  }

  /**
   * 回调点击形变最终值
   *
   * @param bannerDeformState 形变参数
   */
  notifyClickDeformAnim(bannerDeformState: NotificationBannerDeformState): void {
    if (!this.realBannerDeformState.equal(bannerDeformState)) {
      this.realBannerDeformState.update(bannerDeformState);
      this.onClickDeformAnim(bannerDeformState);
    }
  }

  reset(): void {
    this.isDeformFlag = false;
    this.isInitParam = false;
  }

  private startFloatingEventReport(operationType: FloatingOperationType) {
    const ntf = this.vmInjector.getBannerVm().ntf;
    NotificationSysEventReporter.notificationBannerToFloating({
      CREATOR_BUNDLE_NAME: ntf?.creatorBundleName,
      NOTIFICATION_ID: ntf?.id,
      NOTIFICATION_SLOT_TYPE: ntf?.slotType,
      OPERATION: operationType,
      TRACE_ID: ntf?.traceId
    });
  }

  private dropDownBannerEventReport() {
    const ntf = this.vmInjector.getBannerVm().ntf;
    NotificationSysEventReporter.notificationBannerDropdown({
      CREATOR_BUNDLE_NAME: ntf?.creatorBundleName,
      NOTIFICATION_ID: ntf?.id,
      NOTIFICATION_SLOT_TYPE: ntf?.slotType,
      TRACE_ID: ntf?.traceId
    });
  }

  /**
   * 是否是宽屏
   * @returns
   */
  public isWidestScreen = (): boolean => {
    return ArkUIAdapter.px2vp(BannerVm.instance.getDisplayWidth()) > WIDTH_THRESHOLD_SMALL;
  }
}
