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
  BannerDeformState,
  BannerPanelTypeState,
  BannerStyleState,
  BannerPanelType,
  BannerState,
  capsuleStateMgr,
  APSSceneState,
  LiveUseScene,
  TimeoutPromise,
  AnimDataScene,
  LiveAnimScene,
  SysTypeCode,
  BannerStyle
} from '@ohos/systemuicommon';
import { bannerMgr } from '@ohos/systemuicommon';
import { CommonUtils, LogHelper, LogDomain, RectItem } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { HiDfxEventUtil, DeviceHelper, ApsUtils } from '@ohos/frameworkwrapper';
import {
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  FloatingSceneCommonStyle,
  FloatSceneSizeData,
  FloatingScenePadLayoutStyle,
  FloatSizeState
} from '@ohos/windowscene';
import { NtfItemSwipeController } from '../../controller/NtfItemSwipeController';
import { HeadsUpSwipeYController } from '../../controller/phone/HeadsUpSwipeYController';
import { NotificationEntry } from '../../model/NotificationEntry';
import { HeadsUpCallback,
  HEADS_UP_DURATION,
  HEADS_UP_TRANSITION_EFFECT_CHANGE_DELAY,
  PhoneNtfHeadsUpVm } from '../../vm/phone/PhoneNtfHeadsUpVM';
import { NotificationHeadsUp } from './NotificationHeadsUp';
import { NotificationConfig } from '../../common/NotificationConfig';
import { NotificationType } from '../../common/NotificationType';
import { ntfMgr } from '../../model/NotificationManager';
import { NtfSingleItemVM } from '../../vm/NtfSingleItemVM';
import { DarkModeState, ImmersiveBaseState,
  StateType } from '@ohos/systemuicommon';
import { baseStateMgr } from '@ohos/systemuicommon';
import curves from '@ohos.curves';
import { ScreenLockNotificationConst } from '@ohos/screenlockcommon/src/main/ets/constants/ScreenLockNotificationConstants';
import { CommonData } from '@ohos/controlcentercommon/Index';
import { default as SysFloatTipDialog } from '@ohos/screenlockcommon/src/main/ets/templateView/SysFloatTipDialog';
import { NtfCloseVM } from '../../vm/NtfCloseVM';
import { NotificationSysEventReporter, FloatingOperationType } from '@ohos/systemuicommon';
import { EventBroadcast, OhterCardExtendAnimVm, ProgressCardAnimVm, SysUiWindowType } from '@ohos/systemuicommon/Index';
import { NtfColorModeVM } from '../../vm/NtfColorModeVM';
import { NtfListContentConfig } from '../../vm/config/NtfViewConfig';
import { ntfViewConfigManager } from '../../vm/config/NtfViewConfigManager';
import { ItemGestureModifier } from '../../model/NotificationGestureModifier';
import { LayoutUtils, XTLayoutType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { AccessibilityUtil } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { InnerEventUtil } from '@ohos/systemuicommon/newTsIndex';
import { BannerSlideUpEvent } from '@ohos/systemuicommon/src/main/ets/event/NotificationEvent';

const TAG = 'BannerHeadsUpContent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const PHONE_STATUS_BAR_HEIGHT: number = 39;
const PANEL_TYPE = 'banner';
const BANNER_ANI_TIMEOUT_DURATION = 1000;
const DISAPPEAR_EXPIRE_TIME = 2000;
const CLICK_TO_FLOATING_ANIMATION_MAX_WAIT_TIME = 100;
const ACCESSIBILITY_DELAY_FOCUS = 10;
/**
 * 扩展新形态小折叠产品外屏横幅与顶部的间距
 */
const OUTER_HOME_FOLD_MARGIN_TOP = 36;
/**
 * 抬手后收起悬浮窗蒙版兜底计时
 */
const ACTION_END_HIDE_BANNER_PANEL_LIMIT = 3000;

/**
 * 横幅通知内容组件，横幅根布局
 */
@Component
export struct BannerHeadsUpContent {
  /**
   * banner面板横幅样式
   */
  @ObjectLink @Watch('headsUpStyleChange') headsUpStyle: BannerStyleState;

  /**
   * 组件顶边距,使用弹簧曲线赋值
   */
  @State marginTop: number = 0;

  /**
   * banner面板当前面板类型
   */
  @ObjectLink @Watch('onBannerPanelTypeChange') bannerPanelType: BannerPanelTypeState;

  private isHeadsUpVisibility: boolean = false;

  @StorageLink('DarkModeModel_DarkModeStatus') darkModePc: CommonData = new CommonData();

  /**
   * 深色模式
   */
  @StorageLink('Notification_DarkModeModel_DarkModeStatus') darkMode: DarkModeState = new DarkModeState();

  /**
   * 沉浸式
   */
  @ObjectLink immersive: ImmersiveBaseState;

  /**
   * 是否开启辅助功能朗读模式
   */
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;

  /**
   * 通知数据
   */
  @State ntfEntry: NotificationEntry | null = null;

  /**
   * 通知列表类型
   */
  @Provide notificationType: number = NotificationType.TYPE_PHONE_DROPDOWN;

  /**
   * 面板触摸事件down点，仅用于适配NotificationSingleItem
   */
  @Provide panelDownGlobalY: number = -1;

  // 面板触摸down点，全局X轴点，-1无触摸
  @Provide panelDownGlobalX: number = -1;

  /**
   * 窗口是否可见，仅用于适配NotificationSingleItem
   */
  @Provide isNtfWindowShow: boolean = false;

  /**
   * 记录左滑状态的通知的哈希值，用于左滑状态互斥（同一时刻，只允许一条通知左滑）
   * 仅用于适配NotificationSingleItem
   */
  @Provide swipeHashCode: string = '';

  /**
   * 是否正在从左往右移动
   */
  @State isLeftToRight: boolean = false;

  @State itemScaleX: number = 1;

  /**
   * 横幅通知VM
   */
  private headsUpVM: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();

  /**
   * 竖滑控制器
   */
  private swipeController: HeadsUpSwipeYController = new HeadsUpSwipeYController();

  /**
   * 横滑控制器
   */
  private horizontalSwipeController: NtfItemSwipeController = new NtfItemSwipeController();

  /**
   * 下拉时，标识下拉进度是否足以展示悬浮窗。上滑回到阈值前/悬浮窗拉起后 复位
   */
  private showFloatingWindow: boolean = false;
  /**
   * 条目VM
   */
  private itemVm: NtfSingleItemVM = new NtfSingleItemVM();

  /*
   * banner、实况窗口状态管理
   */
  private bannerState: BannerState = bannerMgr.getBannerState();

  /*
   * banner默认样式
   */
  private bannerDefaultStyle: BannerStyle = bannerMgr.getBannerDefaultStyle();

  /**
   * 待删除的悬浮窗消息
   */
  private needDeleteFloatingEntry: NotificationEntry | null = null;

  persistentId: number = 0;

  private screenId: number = 0;

  private touchStartX: number = 0;
  private touchStartY: number = 0;

  /**
   * close按钮VM
   */
  @Provide private closeVM?: NtfCloseVM = undefined;

  /**
   * 判断悬浮窗形变参数是否更新
   */
  private isUpdateDeformFlag: boolean = false;

  /**
   * 形变相关参数
   */
  @State bannerDeformState: BannerDeformState = new BannerDeformState();

  @State floatingRect: RectItem = new RectItem(0, 0, 0, 0);

  private floatingRectCallbackPromise?: TimeoutPromise<void>;

  /**
   * 是否处于下拉形变流程
   */
  @State @Watch('headsUpStyleChange') isDeformFlag: boolean = false;

  @State isInitParam: boolean = false;

  @State dropAnimEnd: boolean = false;

  @State dropActionEnd: boolean = false;

  private dropAnimCnt: number = 0;

  @State headsUpTransitionEffect: TransitionEffect = NotificationConfig.HEADS_UP_DISAPPEAR_ANIM_TRANSITION_EFFECT;

  private defaultFloatingRect: RectItem = new RectItem(0, 0, 0, 0);

  private timeId?: number;

  private headsUpTEChange: boolean = false;
  /**
   * 记录展示按钮的通知的哈希值，用于互斥操作
   */
  @Provide displayButtonsHashCode: string = '';

  @State isHidingHeadsUp: boolean = false;
  /**
   * 本次横幅下拉是由侧边指纹发起的
   */
  private isFingerSwipe: boolean = false;

  /**
   * 多语言镜像
   */
  private isRTL: boolean = RTLUtil.isRTL();

  /**
   * 触摸滑动横幅锁
   */
  private touchOperLock: boolean = false;

  @State private colorModeVM: NtfColorModeVM = new NtfColorModeVM();
  /**
   * 位移
   */
  @State headsUpItemTranX: number = 0;
  @Prop @Watch('updateIsSupportDouble') isNeedBannerInScreenLock: boolean = false;
  @Prop isShowBannerFromScreenLock: boolean = false;
  @Prop @Watch('updateIsSupportDouble') isLockScreen: boolean = false;
  @Prop @Watch('updateIsSupportDouble') isSecureAndLocked: boolean = false;
  @State itemGestureModifier: ItemGestureModifier = new ItemGestureModifier();
  /**
   * 是否删除
   */
  @State isRemoveEntry: boolean = false;

  private tempEntry?: NotificationEntry;

  /**
   * 组件是否删除，避免连续渲染组件
   */
  private isDisappear = false;

  /**
   * 上一次消失开始时间
   */
  private lastDisappearTime?: number;

  private onEndFloatingOpen: () => void = () => {
    // call悬浮窗消失动效
    this.swipeController.onVanish();
  }

  private onThemeChange = (): void => {
    log.showInfo(`onColorModeChange`);
    this.colorModeVM.updateThemeColor();
  };

  private bannerAniTimeoutID: number = 0;

  /**
   * 下拉开始时记录的边距,此次下拉结束前不再更新,避免蒙版跳变
   */
  private recordMargin: number = 0;

  /**
   * 下拉手势生效时如果当前正处在阈值到拉起悬浮窗的流程中，此次手势不响应. 抬手之后复位
   */
  private invalidSwipe: boolean = false;
  /**
   * 下拉悬浮窗抬手后，收起蒙版的计时器
   */
  private hideMaskTimer: number | undefined = undefined;

  private removeEntry(): void {
    // removeEntry
    if (this.ntfEntry?.hashCode) {
      ntfMgr.removeNotificationByCancel(this.ntfEntry);
    } else if (this.needDeleteFloatingEntry) {
      log.showInfo(`remove needDeleteFloatingEntry: ${this.needDeleteFloatingEntry?.hashCode}`);
      ntfMgr.removeNotificationByCancel(this.needDeleteFloatingEntry);
      this.needDeleteFloatingEntry = null;
    }
    this.headsUpVM?.resetWatcher();
  }

  aboutToAppear() {
    log.showInfo(`aboutToAppear Start`);
    // 初始化
    this.headsUpVM.init(this as HeadsUpCallback);

    // 竖滑监听
    this.swipeController?.registerSwipeCallback(this);

    // 横滑监听
    this.horizontalSwipeController?.registerSwipeCallback(this);
    this.horizontalSwipeController?.setHeadsUpNtf(true);
    SCBSceneSessionManager.getInstance().registerOnNtfFloatingWindowCallback(this.onEndFloatingOpen);
    this.swipeController.updateFloatingWindowStatus(this.ntfEntry!);
    SCBSceneSessionManager.getInstance().registerOnGetFloatingRectCallback(this.getFloatRect);
    this.itemVm.init(this);
    this.colorModeVM.init(undefined, undefined, this.onThemeChange);
    this.initItemGestureModifier();
    this.marginTop = this.headsUpStyle.containerMarginTop;
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisAppear`);
    this.headsUpVM.onDestroy();
    this.horizontalSwipeController?.unregisterSwipeCallback(this);
    this.swipeController?.unregisterSwipeCallback(this);
    this.itemVm.onDestroy();
    SCBSceneSessionManager.getInstance().unregisterOnNtfFloatingWindowCallback(this.onEndFloatingOpen);
    // 使用null覆盖回调函数以解注册
    SCBSceneSessionManager.getInstance().registerOnGetFloatingRectCallback(null);
    this.colorModeVM.deinit();
    this.deinitItemGestureModifier();
  }

  private initItemGestureModifier() {
    this.itemGestureModifier.callback = {
      handleDoubleTwiceClick: () => this.bannerClickEvent(2),
      handleDoubleOnceClick: () => this.bannerClickEvent(1),
      handleSingleClick: () => this.bannerClickEvent(2),
    };
    this.updateIsSupportDouble();
  }

  private deinitItemGestureModifier() {
    this.itemGestureModifier.callback = undefined;
  }

  private updateIsSupportDouble(): void {
    this.itemGestureModifier.isSupportDouble = bannerMgr.isSupportDouble(this.isNeedBannerInScreenLock,
      this.isLockScreen, this.isSecureAndLocked);
  }

  /**
   * entry数据变化
   */
  private onNtfEntryChanged(): void {
    if (this.ntfEntry === null) {
      this.isDeformFlag = false;
      this.isInitParam = false;
      this.headsUpItemTranX = 0;
      this.headsUpStyle.containerWidth = this.headsUpStyle.itemWidth;
      this.horizontalSwipeController?.resetStartPosition();
    } else {
      this.touchOperLock = false;
      // 更新通知数据重置观察者，防止按住通知时切换数据导致后续通知观察者数量始终不清零，导致无法到时自动收起
      this.headsUpVM?.resetWatcher();
      this.headsUpStyle.bannerTranY = 0;
    }
    this.swipeController.updateMidScene(this.screenId);
    this.headsUpVM.setIsMidScene(this.swipeController.isMidScene);
    this.swipeController.updateFloatingWindowStatus(this.ntfEntry!);
  }

  isExpandStateExceptSmallFold(): boolean {
    return !DeviceHelper.isSmallFoldProduct() &&
    SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
  }

  initDeformParam(bannerHeight: number): void {
    // 初始化参数
    let screenWidth = ArkUIAdapter.px2vp(this.bannerState.displaySizeState.displayWidth);
    let screenHeight = ArkUIAdapter.px2vp(this.bannerState.displaySizeState.displayHeight);
    let screenWidthPx = this.bannerState.displaySizeState.displayWidth;
    let screenHeightPx = this.bannerState.displaySizeState.displayHeight;
    let state: FloatSizeState;
    if (LayoutUtils.isPadLayout()) {
      state = screenWidthPx < screenHeightPx ? FloatSizeState.PORTRAIT_PAD : FloatSizeState.LANDSCAPE_PAD;
    } else if (this.isExpandStateExceptSmallFold() && !LayoutUtils.isMatchXTFoldMode(XTLayoutType.F)) {
      // 折叠屏展开态
      state = screenWidthPx < screenHeightPx ? FloatSizeState.EXPAND_PORTRAIT : FloatSizeState.EXPAND_LANDSCAPE;
      // 横屏状态
    } else if (this.bannerState.displaySizeState.isWidestScreenByVp(ArkUIAdapter.px2vp(
        this.bannerState.displaySizeState.displayWidth))) {
      state = FloatSizeState.LANDSCAPE;
      // 竖屏状态
    } else {
      state = FloatSizeState.PORTRAIT;
    }
    ArkUIAdapter.runWithScope(() => {
      let floatingRect = FloatSceneSizeData.getDefaultRect(state, screenWidthPx, screenHeightPx);
      let floatWidth = ArkUIAdapter.px2vp(floatingRect.width());
      let floatHeight = ArkUIAdapter.px2vp(floatingRect.height());
      this.defaultFloatingRect = new RectItem(
        (screenWidth - floatWidth) / 2, (screenHeight - floatHeight) / 2,
        (screenWidth + floatWidth) / 2, (screenHeight + floatHeight) / 2);
      let immersiveState = baseStateMgr.getBaseState(StateType.TYPE_IMMERSIVE) as ImmersiveBaseState;
      let useSmallIcon = immersiveState?.isImmersive ? true : false;
      this.swipeController?.initParams(this.headsUpStyle,
        this.defaultFloatingRect,
        screenWidth,
        screenHeight,
        useSmallIcon,
        bannerHeight,
        this.ntfEntry,
      );
    });
    this.bannerDeformState.update(this.swipeController?.getBannerDeformState());
    log.showInfo(`defaultFloatingRect: ${this.defaultFloatingRect}`);
  }

  /**
   * 获取通知数据
   * HeadsUpCallback
   *
   * @return 通知数据
   */
  getNtfEntry(): NotificationEntry | null {
    return this.ntfEntry;
  }

  /**
   * 获取通知面板类型
   * SingleItemCallback
   *
   * @return 通知面板类型
   */
  getNtfType(): number {
    return this.notificationType;
  }

  getIsMidScene(): boolean {
    return !!this.swipeController.isMidScene
  }
  /**
   * 获取通知面板缩放尺寸
   * HeadsUpCallback
   *
   * @return 通知面板缩放尺寸
   */
  setNtfItemScale(ntfItemScaleValue: number): void {
    this.itemScaleX = ntfItemScaleValue;
  }

  /**
   * 获取是否橫屏
   * HeadsUpCallback
   *
   * @return 获取是否橫屏
   */
  getIsWidestScreen(): boolean {
    return this.bannerState.displaySizeState.isWidestScreen()
  }

  /**
   * 通知数据变更
   * HeadsUpCallback
   *
   * @param ntfEntry 通知数据
   */
  notifyNtfEntryChange(ntfEntry: NotificationEntry | null): void {
    if (SystemUICcmConfig.instance.isEnabledLive2 && ntfEntry) {
      import('@ohos/systemuicommon/src/main/ets/vm/BannerVm').then((mod) => {
        mod.BannerVm.instance.headsUpNtfHashCode = ntfEntry?.hashCode;
      });
    }
    this.clearHideMaskTimer();
    if (ntfEntry && this.isDisappearEffect()) {
      log.showInfo(`Last entry not disappear, cache new entry ${ntfEntry.hashCode}`);
      this.tempEntry = ntfEntry;
      return;
    }
    if (!ntfEntry && this.ntfEntry) {
      log.showInfo(`banner is disappearing`);
      this.isDisappear = true;
      this.lastDisappearTime = new Date().getTime();
    }
    log.showInfo(`notifyNtfEntryChange: ${ntfEntry?.toSimpleString()}`);
    if (ntfEntry != null && ntfEntry !== undefined) {
      this.isHidingHeadsUp = false;
      this.headsUpTransitionEffect = NotificationConfig.HEADS_UP_DISAPPEAR_ANIM_TRANSITION_EFFECT;
      this.setChangeTransitionEffectJob();
      clearTimeout(this.bannerAniTimeoutID);
      this.bannerAniTimeoutID = setTimeout(() => {
      }, BANNER_ANI_TIMEOUT_DURATION);
    }
    if (!ntfEntry?.hashCode && this.touchOperLock) {
      this.touchOperLock = false;
    }
    if (!CommonUtils.isInvalid(this.ntfEntry) && CommonUtils.isInvalid(ntfEntry)) {
      this.broadcastHideBanner();
    }

    if (ntfEntry?.isLiveType()) {
      // 中断当前应用强提醒duration时间
      const liveView = ntfEntry.liveViewData;
      if (liveView?.hashCode === capsuleStateMgr.getCapsuleState().remindCapsule?.hashCode) {
        log.showInfo(`stop remind duration time, hashCode: ${liveView?.hashCode}`);
      }

      // 中断实况列表动效
      if (capsuleStateMgr.getCapsuleState().hasAnimScene(AnimDataScene.SCENE_LIVE_BANNER)) {
        log.showInfo(`stop live list hide anim`);
        // 关闭实况列表
        bannerMgr.releasePanelCapsuleList();
        // 清除动效胶囊
        capsuleStateMgr.getCapsuleState().setAnimCapsuleData(AnimDataScene.SCENE_LIVE_BANNER, null);
      }

      // 进度类模板动效
      if (!this.ntfEntry) {
        setTimeout(() => {
          this.resetExpandCardAnimation(liveView?.hashCode ?? '');
          this.cardExpandWithAnimation(liveView?.hashCode ?? '', 500);
        }, 50);
      }
    }

    this.ntfEntry = ntfEntry;
    this.horizontalSwipeController?.setNtfEntry(ntfEntry);
    this.onNtfEntryChanged();
  }

  private resetExpandCardAnimation(hashcode: string) {
    const progressVm = ProgressCardAnimVm.getInstanceByScene(hashcode, LiveUseScene.SCENE_HEADS_UP);
    const otherCardVm = OhterCardExtendAnimVm.getInstanceByScene(hashcode, LiveUseScene.SCENE_HEADS_UP);
    progressVm?.reset();
    otherCardVm?.reset();
  }

  /**
   * 三方卡片胶囊展开横幅完成动效
   * @param hashcode
   */
  private cardExpandWithAnimation(hashcode: string, delay: number) {
    log.showInfo(`live view cardExpandWithAnimation HEADS_UP`);

    const progressVm = ProgressCardAnimVm.getInstanceByScene(hashcode, LiveUseScene.SCENE_HEADS_UP);
    const begin = ProgressCardAnimVm.getInitialProgress(progressVm);
    progressVm?.setAnimation(begin, delay);
    progressVm?.startAnimation();

    const otherCardVm = OhterCardExtendAnimVm.getInstanceByScene(hashcode, LiveUseScene.SCENE_HEADS_UP);
    otherCardVm?.setAnimation(delay)
    otherCardVm?.startAnimation();
  }

  private isDisappearEffect(): boolean {
    if (!this.isDisappear) {
      this.lastDisappearTime = undefined;
      return false;
    }
    let currentTime: number = new Date().getTime();
    log.showInfo(`isDisappearEffect, current: ${currentTime}, last: ${this.lastDisappearTime}`);
    if (this.lastDisappearTime && currentTime - this.lastDisappearTime > DISAPPEAR_EXPIRE_TIME) {
      log.showInfo(`last banner on disappear expired`);
      this.isDisappear = false;
      this.lastDisappearTime = undefined;
      return false;
    }
    return true;
  }

  /**
   * 更新横幅隐藏动画
   */
  updateHeadsUpTransitionEffect(): boolean {
    let needDelay = false;
    if (!this.headsUpTEChange) {
      this.headsUpTransitionEffect = NotificationConfig.HEADS_UP_DISAPPEAR_ANIM_TRANSITION_EFFECT;
      this.headsUpTEChange = true;
      needDelay = true;
    }

    if (this.headsUpTransitionEffect != NotificationConfig.HEADS_UP_HIDE_ANIM_TRANSITION_EFFECT) {
      log.showInfo(`find current still need hide. `);
      this.isHidingHeadsUp = true;
    }
    return needDelay;
  }

  async setChangeTransitionEffectJob(): Promise<void> {
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

  isStartingFloatingWindow(): boolean {
    return this.bannerDeformState.useFakerIcon;
  }

  @Builder
  notificationSingleItemComponent() {
    NotificationHeadsUp({
      ntfEntry: this.getNtfEntry(),
      colorModeVM: this.colorModeVM,
      bannerDeformState: this.bannerDeformState,
      isInitParam: this.isInitParam,
      persistentId: this.persistentId,
      isHidingHeadsUp: this.isHidingHeadsUp,
      bannerFloatingController: this.swipeController.floatingController,
      itemWidth: this.getNtfHeadsUpWidth(),
      headsUpItemTranX: this.headsUpItemTranX,
      isRemoveEntry: this.isRemoveEntry,
      ntfItemVM: this.itemVm,
      screenId: this.screenId,
      isNeedBannerInScreenLock: this.isNeedBannerInScreenLock,
      isShowBannerFromScreenLock: this.isShowBannerFromScreenLock,
      isLockScreen: this.isLockScreen
    })
      .width(this.getNtfHeadsUpWidth())
      .onAreaChange((old, newArea) => {
        if (Number(newArea.width) === Number(old.width) && Number(newArea.height) === Number(old.height) &&
          Number(newArea.globalPosition?.y) === Number(old.globalPosition?.y) &&
          Number(newArea.globalPosition?.x) === Number(old.globalPosition?.x)) {
          return;
        }
        // 未初始化参数时
        if (!this.isInitParam && !CommonUtils.isInvalid(this.ntfEntry)) {
          this.initDeformParam(Number(newArea.height));
        }

        // 设置条目宽度
        this.horizontalSwipeController?.setItemWidth(newArea.width as number);
        bannerMgr.setResponseRegion(newArea, BannerPanelType.TYPE_HEADS_UP);
      })
  }

  @Styles
  panGestureStyle() {
    .gesture(
      GestureGroup(GestureMode.Exclusive,
        GestureGroup(GestureMode.Parallel,
          // 横滑触摸手势
          PanGesture({ direction: PanDirection.Horizontal, distance: NtfItemSwipeController.SWIPE_DISTANCE })
            .onActionStart((event) => {
              this.itemScaleX = 1;
              this.isDeformFlag = false; // 横滑标志
              this.isInitParam = false;
              this.isRTL = RTLUtil.isRTL();
              this.horizontalSwipeController?.onStartSwipe(event);
              this.headsUpVM?.addWatcher(this);
            })
            .onActionUpdate((event) => {
              this.horizontalSwipeController?.onUpdateSwipe(event);
            })
            .onActionEnd((event) => {
              this.horizontalSwipeController?.onEndSwipe(event);
              this.headsUpVM?.removeWatcher(this);
            })
            .onActionCancel(() => {
              this.horizontalSwipeController?.onCancelSwipe();
              this.headsUpVM?.removeWatcher(this);
            })
        ),
        PanGesture({ direction: PanDirection.Vertical, distance: NtfItemSwipeController.VERTICAL_DISTANCE })
          .onActionStart((event) => this.onActionStartByPanGesture(event))
          .onActionUpdate((event) => this.onUpdateSwipe(event))
          .onActionEnd((event) => {
            log.showInfo(`onActionEnd`);
            this.onEndSwipe(event);
            // 当前动作不能拉起悬浮窗时,抬手延迟100ms,等待当前动效完成后解冻。可以拉起悬浮窗时，由窗口回调收起横幅面板时解冻
            if (!this.showFloatingWindow) {
              setTimeout(() => {
                this.releaseDeformFloatingFreeze();
              }, 100);
            } else {
              this.setHideMaskTimer();
            }
            this.invalidSwipe = false;
          })
          .onActionCancel(() => this.onActionCancelByPanGesture()),
      ))
  }

  build() {
    // 该判断必须放外层，否则横幅收起动效不生效
    if (!CommonUtils.isInvalid(this.ntfEntry)) {
      Column() {
        Row() {
          this.notificationSingleItemComponent()
        }
        .id(this.getHeadsUpContentId())
        .width(this.isDeformFlag ? this.bannerDeformState.bannerWidth : this.headsUpStyle.containerWidth)
        .height(this.isInitParam ? this.bannerDeformState.bannerHeight : undefined)
        .align(Alignment.Start)
        .justifyContent(this.isPhoneCall() ? FlexAlign.Center : FlexAlign.Start)
        .margin(this.getHeadsUpMargin())
        .gestureModifier(this.itemGestureModifier)
        .onAppear(() => {
          setTimeout(() => {
            AccessibilityUtil.requestFocusAccessibility(this.getHeadsUpContentId());
          }, ACCESSIBILITY_DELAY_FOCUS);
        })
      }
      .overlay(!bannerMgr.isSupportDouble(this.isNeedBannerInScreenLock, this.isLockScreen
        , this.isSecureAndLocked) ? undefined : this.buildSysFloatTipDialog(), { align: Alignment.Bottom })
      .scale({ x: this.itemScaleX, y: this.itemScaleX })
      .width('100%')
      .height(!bannerMgr.isSupportDouble(this.isNeedBannerInScreenLock, this.isLockScreen
        , this.isSecureAndLocked) ? undefined : '100%')
      .onTouch(this.ntfOnTouch)
      .panGestureStyle()
      .onClick(this.isAccessibilityMode ? () => this.bannerClickEvent(2) : undefined)
      .alignItems(this.isDeformFlag ? HorizontalAlign.Center :
        (this.isLeftToRight ? HorizontalAlign.End : HorizontalAlign.Start))
      .position({ x: 0, y: 0 })
      // 整体竖向位移
      .translate({
        x: this.bannerDeformState.bannerTranX,
        y: this.isDeformFlag ? this.bannerDeformState.bannerTranY : this.headsUpStyle.bannerTranY
      })
      // 横幅弹出、收起动效
      .transition(TransitionEffect.asymmetric(
        TransitionEffect.translate({ x: 0, y: NotificationConfig.HEADS_UP_EFFECT_TRAN_Y })
          .animation(NotificationConfig.HEADS_UP_SHOW_ANIM_PARAM),
        this.bannerPanelType.isPanelLiveList() ? TransitionEffect.IDENTITY : this.headsUpTransitionEffect))
      .opacity(this.bannerDeformState.bannerOpacity)
      .visibility(this.getHeadsUpVisibility())
      .onDisAppear(() => {
        setTimeout(() => {
          log.showInfo('Entry disappeared');
          this.isDisappear = false;
          this.lastDisappearTime = undefined;
          if (this.tempEntry) {
            this.notifyNtfEntryChange(this.tempEntry);
            this.tempEntry = undefined;
          }
        });
      })
    }
  }

  @Builder
  buildSysFloatTipDialog() {
    SysFloatTipDialog({ componentId: ScreenLockNotificationConst.NTF_OUT_HEADS_UP_KEY_GUARD_TIP, tipMarginBottom: 24 })
      .width('100%')
      .height('100%')
      .hitTestBehavior(HitTestMode.None)
  }

  private getHeadsUpContentId(): string {
    if (this.ntfEntry) {
      return this.itemVm?.getCardComponentId(LiveUseScene.SCENE_HEADS_UP, this.ntfEntry);
    }
    return 'HeadsUpNTF';
  }

  private ntfOnTouch = (event: TouchEvent) => {
    if (event == null) {
      return;
    }
    if (event.type == TouchType.Down) {
      // 锁住指纹
      this.touchOperLock = true;
      animateTo(NotificationConfig.NOTIFICATION_CLICK_ANIM, () => {
        this.itemScaleX = 0.95;
      });
      this.touchStartX = event.changedTouches[0].windowX;
      this.touchStartY = event.changedTouches[0].windowY;
    }
    if (event.type === TouchType.Move) {
      if (Math.abs(this.touchStartX - event.changedTouches[0].windowX) > 4 ||
        Math.abs(this.touchStartY - event.changedTouches[0].windowY) > 4) {
        animateTo(NotificationConfig.NOTIFICATION_CLICK_ANIM, () => {
          this.itemScaleX = 1;
        });
      }
      return;
    }
    if (event.type == TouchType.Up) {
      // 响应指纹
      animateTo(NotificationConfig.NOTIFICATION_CLICK_ANIM, () => {
        this.itemScaleX = 1;
      });
    }
  }

  /**
   * 更新通知条目竖向移动距离
   * 复写接口HeadsUpSwipeYController.SwipeCallback
   *
   * @param tranY 移动距离
   * @param itemAnim 动效参数
   */
  onUpdateItemTranY(tranY: number, itemAnim?: AnimateParam): void {
    // 无动效，直接赋值
    if (CommonUtils.isInvalid(itemAnim)) {
      animateTo( { curve: curves.responsiveSpringMotion() }, () => {
        this.headsUpStyle.bannerTranY = tranY;
      })
    } else {
      animateTo(itemAnim as AnimateParam, () => {
        this.headsUpStyle.bannerTranY = tranY;
      });
    }
  }

  releaseDeformFloatingFreeze(): void {
    this.headsUpVM.releaseDeformFreeze();
  }

  onDropDeformAnim(bannerDeformState: BannerDeformState): void {
    this.dropAnimCnt++;
    this.showFloatingWindow = bannerDeformState.bannerToFloating;
    this.bannerDeformState.useFakerIcon = true;
    this.bannerDeformState.bannerMaskingVisibility = true;
    animateTo({
      curve: curves.springMotion(0.5, 0.8),
      onFinish: () => {
        this.dropAnimCnt--;
        if (this.dropAnimCnt === 0) {
          // start floating when can show floating and drop action end
          if (this.dropActionEnd && this.showFloatingWindow) {
            this.swipeController.onEndSwipeWithFloatingWindow(this.isFingerSwipe);
            this.isFingerSwipe = false;
            // 悬浮窗下拉后取消上滑退出动效
            this.headsUpTransitionEffect = TransitionEffect.IDENTITY;
            this.dropActionEnd = false; // reset after start floating window
            this.dropAnimEnd = false; // reset after start floating window
            this.startFloatingEventReport(FloatingOperationType.PULL_DOWN)
          } else {
            this.dropAnimEnd = this.showFloatingWindow; // set true when can show floating
          }
        }
      }}, () => {
      this.bannerDeformState.update(bannerDeformState);
      // 横幅回到原点的动画结束后，将蒙层图标调整为透明
      if (this.bannerDeformState.endTranY === 0) {
        this.bannerDeformState.useFakerIcon = false;
      }
    });
  }

  onClickDeformAnim(bannerDeformState: BannerDeformState): void {
    this.showFloatingWindow = bannerDeformState.bannerToFloating;
    this.bannerDeformState.useFakerIcon = true;
    this.bannerDeformState.bannerMaskingVisibility = true;
    animateTo({
      curve: curves.springMotion(0.5, 0.8),
      onFinish: () => {
        SCBSceneSessionManager.getInstance().notifyAnimationFinishedCallback(true);
      }
    }, () => {
      this.bannerDeformState.update(bannerDeformState);
    });
  }

  onItemVanishAnim(bannerDeformState: BannerDeformState): void {
    if (this.ntfEntry?.hashCode) {
      this.needDeleteFloatingEntry = this.ntfEntry;
      this.headsUpTransitionEffect = TransitionEffect.IDENTITY
    }
    // 白板消失动画
    animateTo({
      curve: curves.springMotion(0.4, 1.0),
      onFinish: () => {
        // 移除通知
        log.showInfo(`removeEntry when itemVanishAnim finish: ${this.ntfEntry?.hashCode}`);
        this.headsUpVM.releaseUpdateFreeze('clickFloating');
        if (this.ntfEntry?.isLiveType() || this.needDeleteFloatingEntry?.isLiveType()) {
          log.showInfo(`release banner live.`);
          bannerMgr.releasePanelHeadsUp();
          this.needDeleteFloatingEntry = null;
        } else {
          this.removeEntry();
        }
        this.releaseDeformFloatingFreeze();
        this.showFloatingWindow = false;
      }
    }, () => {
      this.bannerDeformState.bannerOpacity = bannerDeformState.bannerOpacity;
    });
    // 中心图标放大动画
    animateTo({curve: curves.springMotion(0.25, 1.0)}, () => {
      this.bannerDeformState.bannerIconScale = bannerDeformState.bannerIconScale;
    });
  }

  /**
   * 更新通知条目隐藏事件
   * 复写接口HeadsUpSwipeYController.SwipeCallback
   */
  onHideBanner(): void {
    if (CommonUtils.isInvalid(this.ntfEntry)) {
      return;
    }

    // 上报横幅上滑收起
    HiDfxEventUtil.reportSwipeIgnoreBannerNotification(this.ntfEntry?.creatorBundleName);
    NotificationSysEventReporter.notificationBannerSlipUp({
      CREATOR_BUNDLE_NAME: this.ntfEntry?.creatorBundleName,
      NOTIFICATION_ID: this.ntfEntry?.id,
      NOTIFICATION_SLOT_TYPE: this.ntfEntry?.slotType,
      TRACE_ID: this.ntfEntry?.traceId
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

  /**
   * 横幅横滑回调
   * 复写NtfItemSwipeController.SwipeCallback
   *
   * @param tranX 横向位移
   * @param isRemoveEntry 是否移除
   * @param itemAnim 动画参数
   */
  onExtendUpdateItemTranX(tranX: number, isRemoveEntry: boolean, itemAnim?: AnimateParam): void {
    // 条目向右移时，直接移动item，不更新容器宽度
    let itemTranX = 0;
    this.isLeftToRight = this.isRTL ? tranX < 0 : tranX > 0
    itemTranX = tranX;

    // 容器宽度根据平移缩小
    let containerWidth = Math.max(0, this.headsUpStyle.itemWidth - Math.abs(tranX));

    // 无动效
    if (CommonUtils.isInvalid(itemAnim)) {
      this.headsUpItemTranX = itemTranX;
      if (!this.isLeftToRight) {
        // 向右移动时不更新容器宽度，否则会造成两倍手指移动距离的效果
        this.headsUpStyle.containerWidth = containerWidth;
      }
      this.isRemoveEntry = isRemoveEntry;
    } else {
      animateTo(itemAnim as AnimateParam, () => {
        this.headsUpItemTranX = itemTranX;
        this.headsUpStyle.containerWidth = containerWidth;
        this.isRemoveEntry = isRemoveEntry;
      });
    }
  }

  /**
   * 广播横幅上滑收起事件
   */
  private broadcastHideBanner(): void {
    if (!this.ntfEntry?.isLiveType()) {
      log.showInfo(`broadcastHideBanner fail, ntfEntry is ${this.ntfEntry?.toSimpleString()}`);
      return;
    }
    log.showInfo(`broadcastHideBanner hide headsup ${this.ntfEntry?.toSimpleString()}`);
    let dataBanner: Map<string, string> = new Map();
    dataBanner.set('id', `${this.ntfEntry?.id}`);
    dataBanner.set('creatorBundleName', `${this.ntfEntry?.creatorBundleName}`);

    EventBroadcast.broadcastEvent(SysUiWindowType.WINDOW_BANNER, false, dataBanner);
  }

  /**
   * 获取面板可见性
   *
   * @returns 可见性
   */
  private getHeadsUpVisibility(): Visibility {
    const isHeadsUpVisibility = this.bannerPanelType.isPanelHeadsUp();
    if (isHeadsUpVisibility !== this.isHeadsUpVisibility) {
      this.isHeadsUpVisibility = isHeadsUpVisibility;
    }
    // 横幅面板状态时可见
    return isHeadsUpVisibility ? Visibility.Visible : Visibility.None;
  }

  /**
   * 获取面板边距
   *
   * @returns 边距
   */
  private getHeadsUpMargin(): Margin {
    return {
      top: this.marginTop,
      bottom: this.headsUpStyle.containerMarginBottom,
      left: this.headsUpStyle.containerMarginLeft,
      right: this.headsUpStyle.containerMarginRight
    };
  }

  private getMarginTop(): number {
    // 此时正在下拉形变,停止更新顶部边距,防止蒙版受到状态栏显隐发生跳变
    if (this.isDeformFlag) {
      return this.recordMargin;
    } else {
      const isOuterHomeFold = !DeviceHelper.isFoldExpandedOrHalf();
      if (isOuterHomeFold) {
        this.recordMargin = OUTER_HOME_FOLD_MARGIN_TOP;
      } else {
        this.recordMargin = this.headsUpStyle.containerMarginTop;
      }
      return this.recordMargin;
    }
  }

  /**
   * 当前是否深色模式场景
   *
   * @returns true 深色模式
   */
  private isDarkMode(): boolean {
    return this.darkMode?.isDarkMode ?? false;
  }

  /**
   * 当前是否沉浸式场景
   *
   * @returns true 沉浸式
   */
  private isImmersive(): boolean {
    return this.immersive?.isImmersive ?? false;
  }

  private onUpdateSwipe(event: GestureEvent): void {
    if (this.invalidSwipe) {
      return;
    }
    // 下滑时更新悬浮窗参数
    if (event.offsetY > 0 && !this.isUpdateDeformFlag) {
      this.initDeformParam(0); // 更新此时的通知参数
      this.isDeformFlag = this.swipeController.canOpenFloating(true); // 竖滑标志
      this.isInitParam = this.isDeformFlag; // disable height control when no floating scene
      this.isUpdateDeformFlag = true;
    }
    this.swipeController.onUpdateSwipe(event);
  }

  private onEndSwipe(event: GestureEvent): void {
    if (this.invalidSwipe) {
      return;
    }
    // 下滑打点
    if (event.offsetY > 0) {
      NotificationSysEventReporter.notificationBannerDropdown({
        CREATOR_BUNDLE_NAME: this.ntfEntry?.creatorBundleName,
        NOTIFICATION_ID: this.ntfEntry?.id,
        NOTIFICATION_SLOT_TYPE: this.ntfEntry?.slotType,
        TRACE_ID: this.ntfEntry?.traceId
      });
    }

    // 拉起悬浮窗
    if (this.showFloatingWindow && this.swipeController.canOpenFloating(true) && event.offsetY > 0) {
      log.showInfo('onEndSwipe show Floating window, dropAnimEnd is ', this.dropAnimEnd);
      if (this.dropAnimEnd) {
        this.swipeController.onEndSwipeWithFloatingWindow(false);
        this.dropActionEnd = false; // reset after start floating window
        this.dropAnimEnd = false; // reset after start floating window
        this.startFloatingEventReport(FloatingOperationType.PULL_DOWN)
      } else {
        this.dropActionEnd = true; // set drop action true end when drop anim not end
      }
      // 悬浮窗下拉后取消上滑退出动效
      this.headsUpTransitionEffect = TransitionEffect.IDENTITY;
      return;
    }
    // 松手时不能拉起悬浮窗,将悬浮窗标志位复位
    this.isDeformFlag = false;
    this.showFloatingWindow = false;
    this.isInitParam = false;
    // 沉浸态横屏条件下marginTop为8
    let immersiveTop = this.headsUpStyle.containerMarginTop < 20;
    this.swipeController.onEndSwipe(event, immersiveTop);
    this.headsUpVM?.removeWatcher(this);
  }

  private bannerClickEvent = (clickCount: number): void => {
    if (this.bannerDeformState?.bannerToFloating) {
      return;
    }
    this.swipeController.updateMidScene(this.screenId);
    this.headsUpVM.setIsMidScene(this.swipeController.isMidScene);
    log.showInfo('on banner click: ' + this.ntfEntry?.toSimpleString());
    if (this.swipeController.canOpenFloating(false, this.isImmersive())) {
      if (this.ntfEntry?.hashCode) {
        this.needDeleteFloatingEntry = this.ntfEntry;
      }
      this.initDeformParam(0); // 更新此时的通知参数
      this.isDeformFlag = true;
      this.isInitParam = true;
      // 0、预置点击显示悬浮窗动效
      this.presetClickToFloatingAnimation();
      // 1、拉起悬浮窗
      this.setChangeTransitionEffectJob();
      this.swipeController.startFloatingWindowForClick();
      this.startFloatingEventReport(FloatingOperationType.CLICK);
      this.headsUpVM.setUpdateFreeze('clickFloating');
      this.setHideMaskTimer();
      return;
    }
    if (this.swipeController.isMidScene) {
      this.headsUpTransitionEffect = NotificationConfig.HEADS_UP_MIDSCENE_DISAPPEAR_ANIM_TRANSITION_EFFECT;
    }
    this.itemVm?.onItemClick(true, clickCount, this.isSecureAndLocked,
      this.isNeedBannerInScreenLock && this.isLockScreen);
  }

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

  private doClickToFloating = () => {
    // 2、点击展示悬浮窗动效
    log.showInfo(`headsUpStyle: out this.getFloatRect=${this.floatingRect}`)
    this.headsUpTransitionEffect = TransitionEffect.IDENTITY;
    this.swipeController.clickToFloating(this.floatingRect);
  }

  private clearFloatingRectCallbackPromise = (promise: TimeoutPromise<void>) => {
    if (this.floatingRectCallbackPromise === promise) {
      log.showInfo('Clear floatingRectCallbackPromise');
      this.floatingRectCallbackPromise = undefined;
    } else {
      log.showWarn('Clear floatingRectCallbackPromise fail. curr: %{public}s, target: %{public}s',
        this.floatingRectCallbackPromise?.toString(), promise.toString());
    }
  }

  private startFloatingEventReport(operation: FloatingOperationType) {
    if (!this.ntfEntry) {
      return;
    }
    // 用户行为打点
    NotificationSysEventReporter.notificationBannerToFloating({
      CREATOR_BUNDLE_NAME: this.ntfEntry?.creatorBundleName,
      NOTIFICATION_ID: this.ntfEntry?.id,
      NOTIFICATION_SLOT_TYPE: this.ntfEntry?.slotType,
      OPERATION: operation,
      TRACE_ID: this.ntfEntry?.traceId
    });
  }

  private getFloatRect: (rect: RectItem)=> void = (rect: RectItem) => {
    this.floatingRect = rect;
    this.floatingRectCallbackPromise?.manuallyResolve('OnGetFloatingRectCallback');
    log.showInfo(`headsUpStyle: in this.getFloatRect=${this.floatingRect}`)
  }

  private onActionStartByPanGesture(event: GestureEvent): void {
    log.showInfo(`onActionStart`);
    this.invalidSwipe = false;
    if (this.showFloatingWindow) {
      log.showWarn('cur is going to floating');
      this.invalidSwipe = true;
      return;
    }
    this.swipeController.updateMidScene(this.screenId);
    this.headsUpVM.setIsMidScene(this.swipeController.isMidScene);
    this.isUpdateDeformFlag = false;
    this.isDeformFlag = false;
    this.isInitParam = false;
    this.headsUpTransitionEffect = NotificationConfig.HEADS_UP_HIDE_ANIM_TRANSITION_EFFECT;
    this.swipeController?.onStartSwipe(event);
    this.headsUpVM?.addWatcher(this);
    if (this.swipeController.canOpenFloating(true)) {
      log.showWarn(`canOpenFloating, setDeformFreeze`);
      this.headsUpVM?.setDeformFreeze();
    }
  }

  /**
   * 组件销毁时仍在操作的场景会触发
   */
  private onActionCancelByPanGesture(): void {
    log.showInfo(`onActionCancel`);
    this.swipeController?.onCancelSwipe();
    this.headsUpVM?.removeWatcher(this);
    // 组件退场，不再继续拉起悬浮窗 重置关键变量
    this.showFloatingWindow = false;
    this.releaseDeformFloatingFreeze();
    this.invalidSwipe = false;
  }

  onFingerEventReSet(screenY?: number) {
    this.endSwipe(screenY ? screenY : 0);
  }

  // 指纹下拉
  onUpdateSwipeFinger(screenY: number, vibratorFunc: () => void): void {
    if (screenY > 0 && !this.isUpdateDeformFlag) {
      this.initDeformParam(0); // 更新此时的通知参数
      this.isDeformFlag = this.swipeController.canOpenFloating(true); // 竖滑标志
      this.isInitParam = this.isDeformFlag; // disable height control when no floating scene
      this.isUpdateDeformFlag = true;
    }
    if (screenY < 0) {
      this.headsUpTransitionEffect = NotificationConfig.HEADS_UP_HIDE_ANIM_TRANSITION_EFFECT;
    }
    this.itemScaleX = 1;
    this.swipeController.onUpdateSwipeFinger(screenY, vibratorFunc);
  }

  onEndSwipeFinger(screenY: number): void {
    // 打点上报
    NotificationSysEventReporter.notificationBannerDropdownByFinger({
      CREATOR_BUNDLE_NAME: this.ntfEntry?.creatorBundleName,
      NOTIFICATION_ID: this.ntfEntry?.id,
      NOTIFICATION_SLOT_TYPE: this.ntfEntry?.slotType,
      OPERATION: screenY > 0 ? 'pullDown' : 'pullUp',
      PANEL_TYPE: PANEL_TYPE
    });
    this.endSwipe(screenY)
  }

  endSwipe(screenY: number): void {
    this.isFingerSwipe = true;
    this.itemScaleX = 1;
    if (this.showFloatingWindow && this.swipeController.canOpenFloating(true) && screenY > 0) {
      if (this.dropAnimEnd) {
        this.swipeController.onEndSwipeWithFloatingWindow(true);
        this.isFingerSwipe = false;
        // 悬浮窗下拉后取消上滑退出动效
        this.headsUpTransitionEffect = TransitionEffect.IDENTITY;
        this.dropActionEnd = false; // reset after start floating window
        this.dropAnimEnd = false; // reset after start floating window
        this.startFloatingEventReport(FloatingOperationType.PULL_DOWN);
      } else {
        this.dropActionEnd = true; // set drop action true end when drop anim not end
      }
      return;
    }
    this.swipeController.onEndSwipeFinger(screenY);
    this.headsUpVM?.removeWatcher(this);
  }

  onActionCancelByFinger(): void {
    log.showInfo(`onActionCancelByFinger`);
    this.swipeController?.onCancelSwipeFinger();
    this.headsUpVM?.removeWatcher(this);
    this.itemScaleX = 1;
  }

  onActionStartByFingerPrint(screenY: number): void {
    // 按压态
    this.itemScaleX = 0.95;
    this.isDeformFlag = false;
    this.isInitParam = false;
    this.isUpdateDeformFlag = false;
    this.swipeController?.onStartSwipeFinger(screenY);
    this.headsUpVM?.addWatcher(this);
  }

  getBannerTouchLocker(): boolean {
    return this.touchOperLock
  }

  getHeadsUpVm(): PhoneNtfHeadsUpVm {
    return this.headsUpVM;
  }

  private isFixedWidthDevice(): boolean {
    // 横幅宽度使用固定值的设备：平板，XT，大折叠
    return LayoutUtils.isPadLayout() || LayoutUtils.isMatchXTFoldMode(XTLayoutType.M) || (
      DeviceHelper.isFoldExpanded() && !(DeviceHelper.isSmallFoldProduct()));
  }

  private isPhoneCall(): boolean {
    if (this.isFixedWidthDevice()) {
      return false;
    }
    return Boolean(this.ntfEntry?.isLiveType() && this.ntfEntry?.liveViewData?.sysTypeCode === SysTypeCode.PHONE);
  }

  private isImmersivePhoneCall(): boolean {
    if (this.isFixedWidthDevice()) {
      return false;
    }
    return Boolean(this.bannerState.immersiveState.isInImmersive && this.ntfEntry?.isLiveType() &&
      this.ntfEntry?.liveViewData?.sysTypeCode === SysTypeCode.PHONE);
  }

  private getPhoneImmersiveBannerStyle(): number {
    // 通话横幅横屏沉浸式下宽度定制为竖屏宽度
    let screenWidth = ArkUIAdapter.px2vp(this.bannerState.displaySizeState.displayWidth);
    let screenHeight = ArkUIAdapter.px2vp(this.bannerState.displaySizeState.displayHeight);
    let minDisplayWidth = screenWidth > screenHeight ? screenHeight : screenWidth;
    let itemWidth = minDisplayWidth - (this.bannerDefaultStyle.marginLeftRight * 2);
    log.showWarn(`PhoneBannerImmersiveStyle itemWidth: ${itemWidth}`);
    return itemWidth;
  }

  private getNtfHeadsUpWidth(): number {
    if (this.isImmersivePhoneCall() && !this.isInitParam) {
      return this.getPhoneImmersiveBannerStyle();
    }
    return this.isDeformFlag ? this.bannerDeformState.bannerWidth : this.headsUpStyle.itemWidth;
  }

  private onBannerPanelTypeChange(): void {
    if (this.isHeadsUpVisibility && !this.bannerPanelType.isPanelHeadsUp()) {
      this.notifyNtfEntryChange(null);
    }
  }

  private headsUpStyleChange() {
    if (this.marginTop === this.getMarginTop()) {
      return;
    }
    const isOuterHomeFold =
      ntfViewConfigManager.getListContentConfig().isOuterHome && !DeviceHelper.isFoldExpandedOrHalf();
    // 横幅没在前台，不执行动效
    if (!bannerMgr.isBannerPanelType(BannerPanelType.TYPE_HEADS_UP) || isOuterHomeFold) {
      this.marginTop = this.getMarginTop();
      return;
    }
    animateTo({ curve: curves.springCurve(0, 1, 500, 30) }, () => {
      this.marginTop = this.getMarginTop();
    })
  }

  /**
   * 清除超时收起兜底计时任务
   */
  private clearHideMaskTimer = (): void => {
    if (this.hideMaskTimer !== undefined) {
      clearTimeout(this.hideMaskTimer);
      this.hideMaskTimer = undefined;
    }
  }
  /**
   * 设置超时收起兜底计时任务
   */
  private setHideMaskTimer = (): void => {
    this.clearHideMaskTimer();
    // 抬手后3s如果计时器还没有被清理, 就主动调用onVanish收起蒙版, 避免窗口不回调导致横幅不出现/无法下拉等异常情况
    log.showWarn('cur going to floating, set timer to hide banner mask');
    this.hideMaskTimer = setTimeout(() => {
      log.showWarn('hide banner mask for time out');
      this.swipeController.onVanish();
    }, ACTION_END_HIDE_BANNER_PANEL_LIMIT);
  }
}