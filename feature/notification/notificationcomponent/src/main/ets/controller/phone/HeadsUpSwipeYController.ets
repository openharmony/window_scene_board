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
import Curves from '@ohos.curves'
import { LogDomain, LogHelper, RectItem } from '@ohos/basicutils';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { NotificationConfig } from '../../common/NotificationConfig';
import { BannerFloatingController } from '../BannerFloatingController';
import { NotificationEntry } from '../../model/NotificationEntry';
import { BannerDeformState, bannerMgr, BannerStyleState, LayoutUtils,
  SysTypeCode, VibratorUtil, XTLayoutType } from '@ohos/systemuicommon';
import curves from '@ohos.curves';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';

const TAG = 'HeadsUpSwipeYController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

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
 * 图标左侧Margin
 */
const ICON_MARGIN_LEFT = 12;

/**
 * 指纹键下拉阈值40pixel
 */
const FINGERPRINT_DISTANCE_SLOP = ArkUIAdapter.px2vp(40);

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

/**
 * 横幅条目竖滑控制器
 *
 * @since 2023-01-11
 */
export class HeadsUpSwipeYController {
  /**
   * 图标大小
   */
  private iconSize = 32;

  /**
   * 竖滑回调集
   */
  private swipeCallbacks: Set<SwipeCallback> = new Set();

  /**
   * 通知条目当前竖向平移距离
   */
  private itemTranY: number = 0;

  /**
   * 开始滑动前，条目平移位置
   */
  private startAnimItemTranY: number = 0;

  /**
   * 当次滑动是否为竖向滑动
   */
  private isVertical: boolean = false;

  private realBannerDeformState: BannerDeformState = new BannerDeformState();

  /**
   * 记录原始形变动效相关参数
   */
  private originalBannerDeformState: BannerDeformState = new BannerDeformState();

  /**
   * 记录桌面图标大小
   */
  private desktopIconSize: number = 54;

  /**
   * 记录通知横幅与外容器top margin
   */
  private bannerTopMargin: number = 47;

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

  /**
   * 横幅悬浮窗
   */
  public floatingController: BannerFloatingController = new BannerFloatingController();

  /**
   * 是否中景窗态
   */
  public isMidScene: boolean = false;

  /**
   * 是不是需要开启震感提示
   */
  private isStartVibration: boolean = false;

  /**
   * 注册滑动监听器
   *
   * @param swipeCallback 回调器
   */
  registerSwipeCallback(swipeCallback: SwipeCallback): void {
    this.swipeCallbacks.add(swipeCallback);
  }

  /**
   * 注销滑动监听器
   *
   * @param swipeCallback 回调器
   */
  unregisterSwipeCallback(swipeCallback: SwipeCallback): void {
    this.swipeCallbacks.delete(swipeCallback);
  }

  /**
   * 重置通知横幅参数
   */
  resetBannerDeformState(): void {
    this.realBannerDeformState.reset();
  }

  /**
   * 获取控制器中的形变参数
   *
   * @return 形变参数
   */
  getBannerDeformState(): BannerDeformState | null {
    return this.realBannerDeformState;
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

  private isImmersivePhoneCall(ntfEntry?: NotificationEntry | null): boolean {
    if (!ntfEntry) {
      log.showInfo(`no entry`);
      return false;
    }

    // 对于设置了固定值的设备使用固定值: 平板，XT
    if (LayoutUtils.isPadLayout() || LayoutUtils.isMatchXTFoldMode(XTLayoutType.M)) {
      log.showInfo(`device has fixed banner width`);
      return false;
    }

    return Boolean(bannerMgr.getBannerState().immersiveState.isInImmersive && ntfEntry.isLiveType() &&
      ntfEntry.liveViewData?.sysTypeCode === SysTypeCode.PHONE);
  }

  private getPhoneImmersiveBannerStyle(): number {
    // 通话横幅横屏沉浸式下宽度定制为竖屏宽度
    let screenWidth = px2vp(bannerMgr.getBannerState().displaySizeState.displayWidth);
    let screenHeight = px2vp(bannerMgr.getBannerState().displaySizeState.displayHeight);
    let minDisplayWidth = screenWidth > screenHeight ? screenHeight : screenWidth;
    let itemWidth = minDisplayWidth - (bannerMgr.getBannerDefaultStyle().marginLeftRight * 2);
    log.showWarn(`PhoneBannerImmersiveStyle itemWidth: ${itemWidth}`);
    return itemWidth;
  }

  /**
   * 初始化参数
   *
   * @param headsUpStyle 当前通知横幅基本参数
   */
  initParams(headsUpStyle: BannerStyleState, floatingRect: RectItem, screenWidth: number,
             screenHeight: number, useSmallIcon: boolean, bannerHeight: number, ntfEntry?: NotificationEntry | null) {
    log.showInfo(`floatingRect: floatingRect.left=${floatingRect.left} floatingRect.right=${floatingRect.right}`);
    log.showInfo(`floatingRect: floatingRect.top=${floatingRect.top} floatingRect.bottom=${floatingRect.bottom}`);
    this.originalBannerDeformState.bannerWidth = this.isImmersivePhoneCall(ntfEntry)
      ? this.getPhoneImmersiveBannerStyle() : headsUpStyle.itemWidth;
    // 获取当前屏幕高宽
    this.screenWidth = screenWidth;
    this.screenHeight = screenHeight;
    this.floatingRect = floatingRect;
    this.screenWidth = headsUpStyle.containerWidth + headsUpStyle.containerMarginLeft +
    headsUpStyle.containerMarginRight;

    this.calculateDesktopIconSize(this.screenWidth, this.screenHeight);

    // 获取当前通知横幅的高度
    if (bannerHeight > 0) {
      this.originalBannerDeformState.bannerHeight = bannerHeight;
    }
    this.iconSize = useSmallIcon ? 20 : 32;
    this.realBannerDeformState.update(this.originalBannerDeformState);
    // 获取当前横幅外容器top margin
    this.bannerTopMargin = headsUpStyle.containerMarginTop;
    log.showInfo(`headsUpStyle: itemWidth=${headsUpStyle.itemWidth} containerWidth=${headsUpStyle.containerWidth}`);
    log.showInfo(`headsUpStyle: containerMarginTop=${headsUpStyle.containerMarginTop} containerMarginBottom=${headsUpStyle.containerMarginBottom}`);
    log.showInfo(`headsUpStyle: containerMarginLeft=${headsUpStyle.containerMarginLeft} containerMarginRight=${headsUpStyle.containerMarginRight}`);
  }

  /**
   * 开始竖滑
   *
   * @param event 手势事件
   */
  onStartSwipe(event: GestureEvent): void {
    // 初始判断是否为竖向滑动
    this.isVertical = this.isVerticalSwipe(event);
    // 只处理竖滑
    if (!this.isVertical) {
      return;
    }
    // 开始滑动时，记录条目平移位置
    this.startAnimItemTranY = event.offsetY;
    // 刷新位移，无需动效
    this.notifyTranYChange(event.offsetY);
  }

  /**
   * 更新竖滑
   *
   * @param event 手势事件
   */
  onUpdateSwipe(event: GestureEvent): void {
    // 横滑不处理
    if (!this.isVertical) {
      return;
    }
    if (this.canOpenFloating(true) && event.offsetY > 0) {
      this.notifyDeformChange(event.offsetY, this.originalBannerDeformState.bannerHeight);
    } else {
      // 刷新位移，无需动效
      this.notifyTranYChange(event.offsetY);
    }
  }

  updateMidScene(screenId: number): void {
    let containerSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList(screenId);
    let curSession = containerSessionList.getTopActiveSession();
    this.isMidScene = !!curSession?.isMidScene;
    log.showInfo(`update isMidScene: ${this.isMidScene}}`)
  }
  /**
   * 结束竖滑
   *
   * @param event 手势事件
   */
  onEndSwipe(event: GestureEvent, isImmersive: boolean = false): void {
    // 横滑不处理
    if (!this.isVertical) {
      return;
    }
    log.showInfo(TAG, `onEndSwipe: ${event.offsetY}`)
    if (this.canOpenFloating(true) && event.offsetY > 0) {
      this.handleSwipeTouchEndWithDeform(event.offsetY);
    } else {
      // 刷新位移，无需动效
      this.notifyTranYChange(event.offsetY);
      // 结束滑动
      this.handleSwipeTouchEnd(isImmersive);
    }
  }

  /**
   * 竖滑被取消
   */
  onCancelSwipe(): void {
    // 横滑不处理
    if (!this.isVertical) {
      return;
    }
    if (this.canOpenFloating(true)) {
      this.handleSwipeTouchEndWithDeform(0);
    } else {
      // 结束滑动
      this.handleSwipeTouchEnd();
    }
  }

  onVanish(): void {
    this.realBannerDeformState.bannerOpacity = 0;
    this.realBannerDeformState.bannerIconScale = 1.2 * this.desktopIconSize / this.iconSize;
    this.swipeCallbacks.forEach((callback) => {
      callback.onItemVanishAnim?.(this.realBannerDeformState);
    });
  }

  /**
   * 更新点击形变事件
   */
  clickToFloating(floatingRect: RectItem): void {
    if (floatingRect.width() != 0 && floatingRect.height() != 0) {
      this.floatingRect.left = ArkUIAdapter.px2vp(floatingRect.left);
      this.floatingRect.top = ArkUIAdapter.px2vp(floatingRect.top);
      this.floatingRect.right = ArkUIAdapter.px2vp(floatingRect.right);
      this.floatingRect.bottom = ArkUIAdapter.px2vp(floatingRect.bottom);
    }

    // 初始化
    let bannerDeformState = new BannerDeformState();
    bannerDeformState.update(this.originalBannerDeformState);
    bannerDeformState.useFakerIcon = true;
    bannerDeformState.bannerMaskingVisibility = true;

    // 横幅位移
    bannerDeformState.bannerTranX = this.floatingRect.left - (this.screenWidth - this.floatingRect.width()) / 2;
    bannerDeformState.bannerTranY = this.floatingRect.top - this.bannerTopMargin;
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
    this.notifyClickDeformAnim(bannerDeformState);
  }

  /**
   * 结束竖滑. 确定拉起悬浮窗时，如果是指纹发起，要震动提醒
   *
   */
  onEndSwipeWithFloatingWindow(isFingerSwipe: boolean): void {
    if (this.floatingController.canOpenFloating(true)) {
      isFingerSwipe && VibratorUtil.startFingerprintVibration();
      log.showInfo('onEndSwipeWithFloatingWindow startFloatingWindowForSwipe');
      this.floatingController.startFloatingWindowForSwipe();
      return;
    }
  }

  // 指纹下拉
  onStartSwipeFinger(screenY: number): void {
    this.startAnimItemTranY = screenY;
    this.notifyTranYChange(screenY);
    this.isStartVibration = true;
  }

  onUpdateSwipeFinger(screenY: number, vibratorFunc?: () => void): void {
    if (this.canOpenFloating(true) && screenY > 0) {
      this.notifyDeformChange(screenY, FINGERPRINT_DISTANCE_SLOP, vibratorFunc);
    } else {
      this.notifyTranYChange(screenY);
    }
  }

  onEndSwipeFinger(screenY: number): void {
    log.showInfo(`onEndSwipeFinger: ${screenY}`);

    if (this.canOpenFloating(true) && screenY > 0) {
      this.handleSwipeTouchEndWithDeform(screenY);
    } else {
      this.notifyTranYChange(screenY);
      this.handleSwipeTouchEnd();
    }
  }

  onCancelSwipeFinger(): void {
    if (this.canOpenFloating(true)) {
      this.handleSwipeTouchEndWithDeform(0);
    } else {
      this.handleSwipeTouchEnd();
    }
  }

  public startFloatingWindowForClick() {
    this.floatingController.startFloatingWindowForClick();
  }

  public updateFloatingWindowStatus(entry: NotificationEntry): void {
    this.floatingController.updateFloatingWindowStatus(entry, this.isMidScene);
  }

  public canOpenFloating(isSwipe: boolean, isImmersive?: boolean): boolean {
    if (this.isMidScene) {
      // 中景窗状态不显示悬浮窗
      return false
    }
    return this.floatingController.canOpenFloating(isSwipe, isImmersive);
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

  /**
   * 处理touch滑动结束事件
   */
  private handleSwipeTouchEnd(isImmersive?: boolean): void {
    log.showDebug('handleSwipeTouchEnd: ');
    // 结束滑动时，向上滑，需要达到一定值才隐藏通知，否则回归原位
    if (this.itemTranY < 0) {
      // 默认回归原位
      let endTranY: number = 0;
      // 隐藏通知
      let hideDistance = isImmersive ? NotificationConfig.HIDE_HEADS_UP_DISTANCE_IMMERSIVE :
      NotificationConfig.HIDE_HEADS_UP_DISTANCE;
      if (Math.abs(this.itemTranY) > hideDistance) {
        // 上滑不能只依赖于横幅entry=null时的消失动效，滑动结束到entryChange=null中间会有延迟
        this.startTranYAnim(NotificationConfig.HIDE_HEADS_UP_ANIM_DISTANCE, true);
        this.notifyHideBanner();
      } else {
        // 开始位移动画
        this.startTranYAnim(endTranY);
      }
      log.showDebug(`handleSwipeTouchEnd: endTranY=${endTranY} itemTranY=${this.itemTranY}`);

    } else {
      log.showDebug('handleSwipeTouchEnd: down , return to 0');
      // 往下滑，默认回归原位
      this.startTranYAnim(0);
    }
  }

  /**
   * 处理touch滑动结束事件(带形变)
   */
  private handleSwipeTouchEndWithDeform(offSetY: number): void {
    log.showDebug('handleSwipeTouchEndWithDeform: ');
    // 结束滑动时，向上滑，需要达到一定值才隐藏通知，否则回归原位
    if (offSetY < 0) {
      // 默认回归原位
      let endTranY: number = 0;
      this.realBannerDeformState.endTranY = endTranY;
      // 隐藏通知
      if (Math.abs(offSetY) > NotificationConfig.HIDE_HEADS_UP_DISTANCE) {
        this.startTranYAnim(NotificationConfig.HIDE_HEADS_UP_ANIM_DISTANCE, true)
        this.notifyHideBanner();
      } else {
        this.notifyDeformChange(0, this.originalBannerDeformState.bannerHeight);
      }
      log.showDebug(`handleSwipeTouchEndWithDeform: endTranY=${endTranY} itemTranY=${offSetY}`);
    } else {
      log.showDebug('handleSwipeTouchEndWithDeform: down , return to 0');
      // 往下滑，默认回归原位
      this.notifyDeformChange(0, this.originalBannerDeformState.bannerHeight);
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
      duration: Math.round(Math.abs(endTranY - this.itemTranY)) * 10,
      curve: Curves.springCurve(0, 1, 80, 14),
    }
    if (isHideEntry) {
      anim = { curve: curves.springMotion() }
    }
    // 开始位移
    this.notifyTranYEndValue(endTranY, anim);
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
      log.showInfo(`up oriItemTranY:${oriItemTranY} realItemTranY:${realItemTranY}`);
    } else { // 向下偏移
      realItemTranY = oriItemTranY * SWIPE_DAMP_DOWN;
      if (realItemTranY > BANNER_DOWN_MAX_OFFSET) {
        realItemTranY = BANNER_DOWN_MAX_OFFSET;
      }
      log.showInfo(`down oriItemTranY:${oriItemTranY} realItemTranY:${realItemTranY}`);
    }
    log.showInfo(`notifyTranYChange:${tranY} realItemTranY:${realItemTranY}`);
    // 回调，无需动效
    this.notifyTranYEndValue(realItemTranY);
  }

  /**
   * 形变回调
   *
   * @param tranY 触摸竖移距离
   */
  private notifyDeformChange(tranY: number, threshold: number, vibratorFunc?: () => void): void {
    let oriItemTranY = tranY + this.startAnimItemTranY;
    // 初始化
    let bannerDeformState = new BannerDeformState();
    bannerDeformState.update(this.originalBannerDeformState);
    bannerDeformState.useFakerIcon = true;
    bannerDeformState.bannerMaskingVisibility = true;

    if (oriItemTranY < 0) {
      // 位移
      bannerDeformState.bannerTranY = oriItemTranY * SWIPE_DAMP;
      log.showInfo(`up oriItemTranY:${oriItemTranY} realItemTranY:${bannerDeformState.bannerTranY}`);
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
      bannerDeformState.bannerTranY = this.floatingRect.top - this.bannerTopMargin;
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
        log.showInfo(`startFingerprintVibration, distanceY:${ArkUIAdapter.vp2px(Math.abs(oriItemTranY))}`);
        vibratorFunc && vibratorFunc();
        this.isStartVibration = false;
      }
    }
    this.notifyDropDeformAnim(bannerDeformState);
  }

  /**
   * 回调竖移最终值
   *
   * @param endTranY 最终值
   * @param itemAnim 动效参数
   */
  private notifyTranYEndValue(endTranY: number, itemAnim?: AnimateParam): void {
    // 有变化，回调
    if (this.itemTranY !== endTranY) {
      this.itemTranY = endTranY;
      this.swipeCallbacks.forEach((callback) => {
        callback.onUpdateItemTranY?.(endTranY, itemAnim);
      });
    }
  }

  /**
   * 回调下拉形变最终值
   *
   * @param bannerDeformState 形变参数
   */
  notifyDropDeformAnim(bannerDeformState: BannerDeformState): void {
    // 有变化，回调
    if (!this.realBannerDeformState.equal(bannerDeformState)) {
      this.realBannerDeformState.update(bannerDeformState);
      this.swipeCallbacks.forEach((callback) => {
        callback.onDropDeformAnim?.(bannerDeformState);
      });
    }
  }

  /**
   * 回调点击形变最终值
   *
   * @param bannerDeformState 形变参数
   */
  notifyClickDeformAnim(bannerDeformState: BannerDeformState): void {
    // 有变化，回调
    if (!this.realBannerDeformState.equal(bannerDeformState)) {
      this.realBannerDeformState.update(bannerDeformState);
      this.swipeCallbacks.forEach((callback) => {
        callback.onClickDeformAnim?.(bannerDeformState);
      });
    }
  }

  /**
   * 隐藏事件回调
   */
  private notifyHideBanner(): void {
    this.swipeCallbacks.forEach((callback) => {
      callback.onHideBanner?.();
    });
  }
}

/**
 * swipe处理结果回调
 */
export interface SwipeCallback {
  /**
   * 更新通知条目竖向移动距离
   * 带有动画参数则启动动效，否则直接变更tranY属性
   *
   * @param tranY 移动距离
   * @param itemAnim 动画参数
   */
  onUpdateItemTranY?(tranY: number, itemAnim?: AnimateParam): void;

  /**
   * 更新下拉通知条目形变参数
   *
   * @param bannerDeformState 形变参数
   */
  onDropDeformAnim?(bannerDeformState: BannerDeformState): void;

  /**
   * 更新点击通知条目形变参数
   *
   * @param bannerDeformState 形变参数
   */
  onClickDeformAnim?(bannerDeformState: BannerDeformState): void;

  /**
   * 更新通知条目消失形变参数
   *
   * @param bannerDeformState 形变参数
   */
  onItemVanishAnim?(bannerDeformState: BannerDeformState): void;

  /**
   * 更新通知条目隐藏事件
   */
  onHideBanner?(): void;
}