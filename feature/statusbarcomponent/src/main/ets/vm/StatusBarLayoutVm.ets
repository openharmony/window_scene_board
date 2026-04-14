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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  EvtBus,
  PluginSlot,
  DeviceHelper,
  PluginInfo,
  obtainLocalEvent,
  sEventManager,
  ViewType
} from '@ohos/frameworkwrapper';
import { ResUtils, SCBSceneSessionManager } from '@ohos/windowscene';
import {
  CutoutPosition,
  CutoutVm,
  DeviceInfoVm,
  IStatusBarLayoutVm,
  StatusBarBaseVm,
  StatusBarCapsulePosition,
  DEFAULT_ICON_WIDTH_MAP,
  IStatusBarIconAnimVm,
  AnimateParams,
  DropdownVm,
  ResourceVm,
  IStatusBarPaddingVm,
} from '@ohos/systemuicommon/newIndex';
import { StatusBarClockIconVm } from './StatusBarClockIconVm';
import { StatusBarNotificationIconVm } from './StatusBarNotificationIconVm';
import {
  PluginWidthChangeEvent,
  StatusBarType,
  SystemUICommonUtil,
  StatusBarLayoutFinishedEvent,
  scbStatusBarStatusManager,
  StackSignalInfo,
  StatusBarBlurEvent,
  ViewManagerAdapter,
  ViewMgrPolicyViewCallback
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { InnerEventUtil } from '@ohos/systemuicommon/newTsIndex'
import { StatusBarIconBaseVm } from './StatusBarIconBaseVm';
import { LiveStyle } from '@ohos/systemuicommon/src/main/ets/live/constants/LiveStyle';
import {
  ClockShowType,
  ClockWidth,
  STATUSBAR_CLOCK_EDGE_SPACE,
  IconFilterType
} from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarEnum';
import { LiveCapsuleLayoutInfo } from '@ohos/systemuicommon/src/main/ets/live/model/LiveCommonModel';
import { StatusBarMoveDownVmV2 } from '@ohos/systemuicommon/src/main/ets/statusbar/vm/StatusBarMoveDownVm';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { CAPSULE_RIGHT_X } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusbarConstants';
import { sharedData } from '@ohos/systemuicommon/src/main/ets/model/SendableData';

const TAG = 'StatusBarLayoutVm'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const TITLE_BAR_RESPONSE_WIDTH: number = 48;
const TITLE_BAR_RESPONSE_SAFE_GAP: number = 8;
const NTF_DEFAULT_COUNT = 5;
const MIN_CAPSULE_SPACE = 57;
const animateDurationMs: number = 333;
const filterChangeDurationMs: number = 167;

export class LayoutSnapShot {
  // 场景快照数据
  public snapShotIsMiddleCutout: boolean = false;
  public snapShotCutoutRight: number = 0;
  public snapShotCapsuleLeft: number = 0;
  public snapShotCapsuleRight: number = 0;
  // 计算缓存数据
  public snapShotNewIconFilterRule: IconFilterType = IconFilterType.DEFAULT;
  public cacheLayoutIsVisibleIcons: Set<string> = new Set();
  public ntfShowCount: number = -1;
  public clockShowType: ClockShowType = ClockShowType.NORMAL_SHOW;
  public avoidIconName: string = '';
  public avoidIconMargin: number = 0;

  public isSameResult(otherObj: LayoutSnapShot): boolean {
    if (this.ntfShowCount != otherObj.ntfShowCount) {
      log.showInfo(`Nft count change!`);
      return false;
    }
    if (this.snapShotNewIconFilterRule != otherObj.snapShotNewIconFilterRule) {
      log.showInfo(`Filter Rule change!`);
      return false;
    }
    if (this.cacheLayoutIsVisibleIcons.size !== otherObj.cacheLayoutIsVisibleIcons.size) {
      log.showInfo(`visible icons size diff!`);
      return false;
    }
    for(let pluginName of this.cacheLayoutIsVisibleIcons) {
      if (otherObj.cacheLayoutIsVisibleIcons.has(pluginName)) {
        continue;
      }
      log.showInfo(`visible icons diff!`);
      return false;
    }
    if (this.clockShowType != otherObj.clockShowType) {
      log.showInfo(`clockShowType diff!`);
      return false;
    }
    if (this.avoidIconName !== otherObj.avoidIconName || this.avoidIconMargin !== otherObj.avoidIconMargin) {
      log.showInfo(`avoid icon diff!`);
      return false;
    }

    return true;
  }

  public isDropDownRule() {
    return this.snapShotNewIconFilterRule === IconFilterType.DROPDOWN;
  }
}


@ObservedV2
export class StatusBarLayoutVm extends StatusBarBaseVm implements IStatusBarLayoutVm {
  public readonly capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
  @Trace public capsuleLeftX: number = 0;
  @Trace public capsuleRightX: number = 0;
  @Trace public systemIconLeftX: number = 0;
  @Trace public statusBarPaddingLeft: number = 0;
  @Trace public isShowFullScreenTitleBar: boolean = false;
  @Trace public moveDownVm: StatusBarMoveDownVmV2 = StatusBarMoveDownVmV2.getInstance();
  @Trace public statusBarMarginTop: number = this.moveDownVm.getTopPadding();
  @Trace public isInstantShowing: boolean = false;
  @Trace public statusBarViewLayoutEnable: boolean = false;
  @Trace public layoutIsVisibleIcons: Set<string> = new Set();
  @Trace public iconTempHideInfo: Set<string> = new Set();
  @Trace public avoidIconName: string = '';
  @Trace public avoidIconMargin: number = 0;
  @Trace public isShowBlur = false;
  @Trace public iconFilterRule: IconFilterType = IconFilterType.DEFAULT;
  public enableBlurTransition = false;
  private animationRunningCount: number = 0;
  private hasNotAnimationRefresh: boolean = false;
  protected lastLayoutSnapShotObj: LayoutSnapShot = new LayoutSnapShot();
  protected currentLayoutSnapShotObj: LayoutSnapShot = new LayoutSnapShot();
  public dropdownVm = DropdownVm.instance;
  public iconGap: number = ArkUIAdapter.px2vp(Math.floor(ArkUIAdapter.vp2px(2)));
  public iconCapsuleGap: number = ArkUIAdapter.px2vp(Math.floor(ArkUIAdapter.vp2px(6)));
  private statusBarGroupHeight: number = ResUtils.getNumber($r('app.float.status_bar_default_height'));
  private leftCutoutPadding: number = ResUtils.getNumber($r('app.float.left_cutout_padding'));
  public isExistCapsule: boolean = false;
  private lastCapsuleLeftX: number = 0;
  private lastCapsuleRightX: number = 0;
  protected deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
  protected cutoutVm: CutoutVm = CutoutVm.instance;
  private animateIconVm: IStatusBarIconAnimVm = this.vmInjector.getStatusBarIconAnimVm();
  /**
   * 融球与挖孔半径差值
   */
  protected metaBallPadding: number = LiveStyle.CAPSULE_HEIGHT / 2 - this.cutoutVm.holeRadius;
  private lastClockShowType: ClockShowType = ClockShowType.NORMAL_SHOW;
  private readonly clockHideScale: number = 0.25;
  private readonly clockTextExtrudeScale: number = 0.78;
  private readonly clockHideOpacity: number = 0;
  private readonly clockHideOffset: number = 0;
  /**
   * 状态栏时钟宽度
   */
  protected statusBarClockNormalWidth: number = ClockWidth.NORMAL_WIDTH;
  private statusBarClockExtrudeWidth: number = ClockWidth.EXTRUDE_WIDTH;
  protected resourceVm = ResourceVm.instance;
  private rightLimitWithTitleBar: number = 0;

  init(): void {
    log.showInfo(`init StatusBarLayoutVm`);
    InnerEventUtil.on(PluginWidthChangeEvent, this.onPluginWidthChangeEvent);
    if (DeviceHelper.isPad()) {
      SCBSceneSessionManager.getInstance().registerFullScreenTitleBarAppearCallback(() => {
        log.showInfo('fullScreenTitleBar change to show');
        this.isShowFullScreenTitleBar = true;
      });
      SCBSceneSessionManager.getInstance().registerHotRegionStateChangeCallback(() => {
        log.showInfo('fullScreenTitleBar change to hide');
        this.isShowFullScreenTitleBar = false;
      });
    }
    ViewManagerAdapter.registerViewCallback(this.viewVisibleChangeCallback, `${TAG}_registerViewCallback`);
  }

  /**
   * 状态栏界面显隐
   */
  private viewVisibleChangeCallback: ViewMgrPolicyViewCallback = {
    viewType: ViewType.STATUS_BAR,
    onShow: () => {
      this.statusBarViewLayoutEnable = true;
      log.showInfo(`viewVisibleChangeCallback ${this.statusBarViewLayoutEnable}`);
      this.recalculateLayout(false);
    },
    onHide: () => {
      this.statusBarViewLayoutEnable = false;
      log.showInfo(`viewVisibleChangeCallback ${this.statusBarViewLayoutEnable}`);
    }
  }

  @Computed
  get statusBarPaddingVm(): IStatusBarPaddingVm {
    return this.vmInjector.getStatusBarPaddingVm();
  }

  public onCapsulePositionChange = (layoutInfo: LiveCapsuleLayoutInfo): void => {
    const capsulePositionRight = this.capsulePosition.left + this.capsulePosition.width;
    this.capsuleLeftX = Math.min(layoutInfo?.left, this.capsulePosition.left);
    this.capsuleRightX = Math.max(layoutInfo?.right, capsulePositionRight);
    this.postCapsuleRightXToStatusbar(this.capsuleRightX);
    if (CutoutVm.instance.isMiddleCutout()) {
      const clockWidth: number = this.statusBarClockNormalWidth + this.statusBarPaddingVm.statusBarLeftPadding;
      // instrument ignore if
      if (layoutInfo.isInstantOrPersistentShowing && clockWidth > this.capsuleLeftX) {
        // 针对及时和长时场景，若区域与时间/运营商重叠则直接隐藏左侧所有内容,所以将 capsuleLeftX 置为0
        log.showInfo('hide all left icon');
        this.capsuleLeftX = 0;
      }
    }
    this.isInstantShowing = layoutInfo.isInstantOrPersistentShowing;
    log.showInfo(`isInstantShowing ${this.isInstantShowing}`)
    log.showInfo(`hasCapsuleShow: ${layoutInfo.hasCapsuleShow} left:${this.capsuleLeftX}, lastLeft: ${this.lastCapsuleLeftX},  right:${this.capsuleRightX}, last right: ${this.lastCapsuleRightX}`);
    // 胶囊回调位置发生变化，且影响到状态栏布局
    if (this.capsuleLeftX !== this.lastCapsuleLeftX || this.capsuleRightX !== this.lastCapsuleRightX) {
      this.lastCapsuleLeftX = this.capsuleLeftX;
      this.lastCapsuleRightX = this.capsuleRightX;
      this.isExistCapsule = layoutInfo?.hasCapsuleShow;
      sharedData.isAodShowCapsule = this.vmInjector.getStatusBarLayoutVm().isExistCapsule;
      sharedData.isAodShowNtf = !this.vmInjector.getStatusBarLayoutVm().isExistCapsule;
      const needAnimation = layoutInfo?.needAnimation ?? true; // 默认需要增加动效
      this.recalculateLayout(needAnimation, layoutInfo?.delay);
    }
  };

  private postCapsuleRightXToStatusbar(capsuleRightX: number): void {
    sEventManager.publish(obtainLocalEvent(CAPSULE_RIGHT_X, capsuleRightX));
  }

  /**
   * 布局获取时间或运营商的占用宽度（包含LeftPadding）
   */
  getClockOrOperatorWidth() {
    let leftWidth = 0;
    let isDropdown: boolean = StatusBarType.isDropdown(this.vmInjector.getStatusBarIconListVm().statusBarType);
    if (isDropdown) {
      let iconVm = this.vmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_OPERATOR);
      leftWidth = iconVm.width;
    } else {
      // 时间的宽度需要是未压缩的宽度
      leftWidth = this.statusBarClockNormalWidth;
    }
    return leftWidth + this.statusBarPaddingVm.statusBarLeftPadding;
  }

  /**
   * 纯净显示改变，定位和 超级隐私图标需要先隐藏
   */
  public hideIconForWhile(): void {
    // 图标暂时隐藏：由于在纯净显示布局变化时，定位图标和超级隐私由于不受纯净显示影响，所以这俩个图标会被挤压到其他位置，图标就会闪一下
    const locationIconVM = this.vmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_LOCATION);
    const superPrivacyIconVM = this.vmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_SUPER_PRIVACY);
    locationIconVM.iconDelayShowOpacity = 0;
    superPrivacyIconVM.iconDelayShowOpacity = 0;
    setTimeout(() => {
      locationIconVM.iconDelayShowOpacity = 1;
      superPrivacyIconVM.iconDelayShowOpacity = 1;
    }, 30)
  }

  /**
   * 初始化布局快照
   */
  private initSnapShot(): void {
    const layoutSnapShotObj: LayoutSnapShot = new LayoutSnapShot();
    layoutSnapShotObj.snapShotIsMiddleCutout = this.cutoutVm.isMiddleCutout()
    layoutSnapShotObj.snapShotCutoutRight = this.cutoutVm.right;
    layoutSnapShotObj.snapShotCapsuleLeft = this.capsuleLeftX;
    layoutSnapShotObj.snapShotCapsuleRight = this.capsuleRightX;
    layoutSnapShotObj.snapShotNewIconFilterRule =
      this.vmInjector.getStatusBarSettingVm()
        .checkIconFilterRule(this.vmInjector.getStatusBarIconListVm().statusBarType);
    log.showInfo(`InitSnapShot filter rule: ${layoutSnapShotObj.snapShotNewIconFilterRule}`)
    this.currentLayoutSnapShotObj = layoutSnapShotObj
  }

  protected iconMarginEndCheck(iconLeft: number, iconRight: number): number {
    // 正常场景无额外MarginEnd控制、特殊需要跨孔场景重写该方法
    return 0;
  }

  /**
   * 判定状态栏图标的重叠情况
   * @returns 是否重叠
   */
  private checkIconIsOverLap(iconLeft: number, iconRight: number,
    pluginName: string): boolean {
    // 优先检查是否和挖孔重叠
    if (this.checkOverlapWithCutout(iconLeft, pluginName)) {
      return true;
    }
    // 其次检查是否和胶囊重叠
    if (this.checkOverlapWithCapsule(iconLeft, pluginName)) {
      return true;
    }
    // 最后检查是否和左侧系统图标（时间、运营商）重叠
    return this.checkOverlapWithLeftIcon(iconLeft, iconRight, pluginName);
  }

  protected checkOverlapWithCutout(iconLeft: number, pluginName: string): boolean {
    const isMiddleCutout = this.currentLayoutSnapShotObj.snapShotIsMiddleCutout;
    const isDropDownFilterRule = this.currentLayoutSnapShotObj.isDropDownRule();
    const cutoutRight = this.currentLayoutSnapShotObj.snapShotCutoutRight + this.metaBallPadding;
    // 挖孔重叠检查
    if (isMiddleCutout && !isDropDownFilterRule && iconLeft < cutoutRight) {
      log.showInfo(`cutout overlap ${pluginName}, iconLeft: ${iconLeft}, coutoutRight: ${cutoutRight}`);
      return true;
    }
    return false;
  }

  protected checkOverlapWithCapsule(iconLeft: number, pluginName: string): boolean {
    const capsuleRight = this.currentLayoutSnapShotObj.snapShotCapsuleRight;
    const isDropDownFilterRule = this.currentLayoutSnapShotObj.isDropDownRule();
    const capsuleIsShow = this.currentLayoutSnapShotObj.cacheLayoutIsVisibleIcons.has(PluginSlot.LIVE_VIEW_CAPSULE);
    // 若图标与胶囊无重叠则不隐藏
    if (iconLeft >= capsuleRight || !this.isExistCapsule || !(this.cutoutVm.isMiddleCutout() || capsuleIsShow)) {
      return false;
    }
    // 非下拉场景，重叠需要隐藏
    if (!isDropDownFilterRule) {
      log.showInfo(`Capsule overlap ${pluginName}, iconLeft: ${iconLeft}, capsuleRight: ${capsuleRight} not drop down`);
      return true;
    }
    // 下拉场景，若设备图标不下沉，需要隐藏
    if (!StatusBarMoveDownVmV2.getInstance().checkNeedMoveDown()) {
      log.showInfo(`Capsule overlap ${pluginName}, iconLeft: ${iconLeft}, capsuleRight: ${capsuleRight} not move down`);
      return true;
    }
    return false;
  }

  protected checkOverlapWithLeftIcon(iconLeft: number, iconRight: number,
    pluginName: string): boolean {
    // 时间 或 运营商 重叠判定
    let leftLimitWidth = 0;
    if (this.currentLayoutSnapShotObj.snapShotNewIconFilterRule === IconFilterType.DROPDOWN) {
      leftLimitWidth = this.vmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_OPERATOR).width;
    } else {
      leftLimitWidth = this.statusBarClockNormalWidth;
    }
    leftLimitWidth += this.statusBarPaddingVm.statusBarLeftPadding;
    if (leftLimitWidth > iconLeft || iconRight < 0) {
      log.showInfo(`Left group overlap ${pluginName} ${leftLimitWidth} ${iconLeft} ${iconRight}`);
      return true;
    }
    return false;
  }

  private checkIconCanShow(pluginName: string, filterRule: IconFilterType): boolean {
    const settingVm = this.vmInjector.getStatusBarSettingVm();
    const iconListVm = this.vmInjector.getStatusBarIconListVm();
    if (!iconListVm.iconSwitchOnInfo.has(pluginName)) {
      return false;
    }
    if (!settingVm.isShouldShowInStatusBar(pluginName, filterRule)) {
      return false;
    }
    return true;
  }

  protected checkLeftIconVisible() {
    const iconListVm = this.vmInjector.getStatusBarIconListVm();
    const settingVm = this.vmInjector.getStatusBarSettingVm();
    iconListVm.leftIcons.forEach((pluginInfo: PluginInfo) => {
      const pluginName = pluginInfo.pluginParseInfo.pluginSlot as string;
      if (settingVm.isShouldShowInStatusBar(pluginName, this.currentLayoutSnapShotObj.snapShotNewIconFilterRule)) {
        this.currentLayoutSnapShotObj.cacheLayoutIsVisibleIcons.add(pluginName);
      } else {
        this.currentLayoutSnapShotObj.cacheLayoutIsVisibleIcons.delete(pluginName);
      }
    })
  }

  protected checkRightIconVisible(): number {
    const iconListVm = this.vmInjector.getStatusBarIconListVm();
    let iconLeft = ArkUIAdapter.px2vp(this.deviceInfoVm.width) - this.statusBarPaddingVm.statusBarRightPadding;
    let iconRight = ArkUIAdapter.px2vp(this.deviceInfoVm.width) - this.statusBarPaddingVm.statusBarRightPadding;
    let fixLeft = 0;
    let occupySpace = this.statusBarPaddingVm.statusBarRightPadding;
    let avoidCutoutPadding: number = 0;
    let signalInfo: StackSignalInfo = { actualWidth: 0, isHide: false }; // 信号图标
    const rightIcons = iconListVm.rightIcons;
    for (let i = rightIcons.length - 1; i >= 0; i--) {
      const pluginName = rightIcons[i].pluginParseInfo.pluginSlot as string;
      if (!this.checkIconCanShow(pluginName, this.currentLayoutSnapShotObj.snapShotNewIconFilterRule)) {
        continue;
      }
      let iconVm = this.vmInjector.getStatusBarIconVm(pluginName);
      iconVm.marginEnd = 0;
      iconRight = iconLeft;
      if (pluginName === PluginSlot.SLOT_STATUS_SIGNAL) {
        signalInfo = this.getSignalDynamicWidthOffset(iconRight);
        iconLeft = iconLeft - signalInfo.actualWidth;
      } else {
        iconLeft = iconLeft - iconVm.width;
      }
      fixLeft = iconLeft + this.iconGap; // 由于图标间距算在了图标的left padding内，所以再实际计算的时候需要移除其影响
      if (avoidCutoutPadding === 0) {
        avoidCutoutPadding = this.iconMarginEndCheck(fixLeft, iconRight);
        if (avoidCutoutPadding > 0) {
          this.currentLayoutSnapShotObj.avoidIconName = pluginName;
          this.currentLayoutSnapShotObj.avoidIconMargin = avoidCutoutPadding;
          log.showDebug(`avoidCutoutPadding ${avoidCutoutPadding}`);
        }
        iconLeft = iconLeft - avoidCutoutPadding;
        fixLeft = fixLeft - avoidCutoutPadding;
      }
      if (avoidCutoutPadding > 0 && !this.currentLayoutSnapShotObj.isDropDownRule()) {
        this.currentLayoutSnapShotObj.cacheLayoutIsVisibleIcons.delete(pluginName);
        log.showDebug(`avoid cutout hide ${pluginName}`);
        continue;
      }
      log.showDebug(`PluginName: ${pluginName} fixLeft ${fixLeft} iconRight: ${iconRight} iconWidth: ${iconVm.width}`);
      if (![PluginSlot.SLOT_STATUS_WIFI].includes(pluginName) && signalInfo.hideSignal) {
        this.currentLayoutSnapShotObj.cacheLayoutIsVisibleIcons.delete(pluginName);
      } else if (![PluginSlot.SLOT_STATUS_WIFI, PluginSlot.SLOT_STATUS_SIGNAL].includes(pluginName) &&
        signalInfo.isHide) {
        log.showDebug(`Signal stack hide ${pluginName}`);
        this.currentLayoutSnapShotObj.cacheLayoutIsVisibleIcons.delete(pluginName);
      } else if (this.checkIconIsOverLap(fixLeft, iconRight, pluginName)) {
        this.currentLayoutSnapShotObj.cacheLayoutIsVisibleIcons.delete(pluginName);
      } else {
        log.showDebug(`Icon show ${pluginName}`);
        this.currentLayoutSnapShotObj.cacheLayoutIsVisibleIcons.add(pluginName);
        occupySpace += (iconVm.width)
      }
    }
    log.showInfo(`ActualWidth: ${signalInfo.actualWidth}`)
    return occupySpace;
  }

  private checkIconVisible(): number {
    this.checkLeftIconVisible();
    let occupySpace = this.statusBarPaddingVm.statusBarRightPadding;
    occupySpace = this.checkRightIconVisible();
    return occupySpace
  }

  // step 1： 预处理状态栏布局
  private async preDealWithStatusBarLayout(needAnimation: boolean, delay: number): Promise<void> {
    log.showInfo(`---layout refresh prepare: ${needAnimation} delay: ${delay}`);
    // 创建状态栏布局数据快照
    this.initSnapShot()
    // 屏幕总宽度
    let freeSpace = ArkUIAdapter.px2vp(this.deviceInfoVm.width);
    // 减去时间或运营商的宽度
    freeSpace -= this.getClockOrOperatorWidth();
    // 遍历右侧图标筛选出与挖孔和胶囊重叠的图标
    freeSpace -= this.checkIconVisible();
    // 更新胶囊最大可用区域计算
    this.capsuleLimitRefresh();
    // 计算通知图标可用个数
    if (this.currentLayoutSnapShotObj.snapShotNewIconFilterRule === IconFilterType.DROPDOWN) {
      // 下拉的场景不用更新通知图标数量
      this.currentLayoutSnapShotObj.ntfShowCount = -1;
    } else {
      this.currentLayoutSnapShotObj.ntfShowCount = this.ntfSpaceCalculate(freeSpace);
    }
    this.checkNtfIconVisible();
    // 时间堆叠状态检查
    this.currentLayoutSnapShotObj.clockShowType = this.getCurrentClockShowType();
    // 若检查没有变化则不执行布局刷新
    if (this.lastLayoutSnapShotObj.isSameResult(this.currentLayoutSnapShotObj)) {
      log.showInfo(`isSameResult ignore!`)
      return Promise.resolve();
    }
    const canPlayAnimation: boolean = this.checkCanPlayAnimation();
    if (canPlayAnimation && delay > 0 && this.lastLayoutSnapShotObj.isDropDownRule() &&
      this.currentLayoutSnapShotObj.snapShotNewIconFilterRule === IconFilterType.DEFAULT) {
      // 下拉返回场景 图标刷新不能有延迟，否则导致图标与挖孔重叠
      delay = 0;
    }

    log.showInfo(`Refresh layout: Param: ${this.currentLayoutSnapShotObj.snapShotNewIconFilterRule}, ${needAnimation},
    ${delay} ${canPlayAnimation} ${this.currentLayoutSnapShotObj.clockShowType}`);
    log.showInfo(`Refresh layout: NtfMaxCount ${this.currentLayoutSnapShotObj.ntfShowCount} freeSpace:${freeSpace}`);
    log.showInfo(`Refresh layout: Visible icons： ` +
      `${Array.from(this.currentLayoutSnapShotObj.cacheLayoutIsVisibleIcons).map((plugin)=>plugin).join(',')}`);
    log.showInfo(`Refresh layout: iconSwitchOnInfo： ` +
      `${Array.from(this.vmInjector.getStatusBarIconListVm().iconSwitchOnInfo).map((plugin)=>plugin).join(',')}`);
    const lastAvoidIconName = this.lastLayoutSnapShotObj.avoidIconName;
    this.lastLayoutSnapShotObj = this.currentLayoutSnapShotObj;
    this.iconFilterRule = this.lastLayoutSnapShotObj.snapShotNewIconFilterRule;
    this.vmInjector.getStatusBarSettingVm().iconFilterType = this.currentLayoutSnapShotObj.snapShotNewIconFilterRule;
    if (canPlayAnimation && needAnimation) {
      // 出现跨孔的图标要现隐藏
      await this.doAnimation(delay, lastAvoidIconName);
    } else {
      this.refreshLayout();
    }
    // 基础布局变化完成，通知状态栏显示
    this.notifyStatusBarLayoutFinished();
    log.showInfo(`Refresh layout finish`);
    return Promise.resolve();
  }

  private avoidIconCheck(lastAvoidIconName: string): Set<string> {
    const newAvoidName: string = this.currentLayoutSnapShotObj.avoidIconName;
    if (lastAvoidIconName.length <= 0 && newAvoidName.length <= 0) {
      return new Set();
    }
    if (lastAvoidIconName === newAvoidName) {
      return new Set();
    }
    return this.getTempHideIcons(lastAvoidIconName, newAvoidName);
  }

  private getTempHideIcons(lastAvoidIconName: string, newAvoidName: string): Set<string>  {
    const iconTempHideInfo: Set<string> = new Set();
    const rightIcons = this.vmInjector.getStatusBarIconListVm().rightIcons;
    let startHideIcon: boolean = false;
    for (let i = rightIcons.length - 1; i >= 0; i--) {
      const pluginName = rightIcons[i].pluginParseInfo.pluginSlot as string;
      if (pluginName === lastAvoidIconName || pluginName === newAvoidName) {
        startHideIcon = !startHideIcon;
      }
      if (startHideIcon) {
        iconTempHideInfo.add(pluginName);
      }
    }
    return iconTempHideInfo;
  }

  protected checkCanPlayAnimation(): boolean {
    if (DeviceHelper.is2In1DevicePadType()) {
      return false;
    }
    return true;
  }

  // 无动效刷新布局
  private refreshLayout() {
    log.showInfo(`No animation refreshLayout`)
    this.updateClockStateWithoutAnimation(this.currentLayoutSnapShotObj.clockShowType);
    this.lastClockShowType = this.currentLayoutSnapShotObj.clockShowType;
    this.layoutIsVisibleIcons = this.currentLayoutSnapShotObj.cacheLayoutIsVisibleIcons;
    this.avoidIconName = this.currentLayoutSnapShotObj.avoidIconName;
    this.avoidIconMargin = this.currentLayoutSnapShotObj.avoidIconMargin;
    if (this.currentLayoutSnapShotObj.ntfShowCount >= 0) {
      const ntfVm =
        this.vmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_NOTIFICATION) as StatusBarNotificationIconVm;
      ntfVm.updateShowMaxIconCount(this.currentLayoutSnapShotObj.ntfShowCount);
    }
  }

  // step 2: 预处理完成后使用预处理数据，对所有当前图标进行布局变更\动效
  private async doAnimation(delay: number, lastAvoidIconName: string): Promise<void> {
    let cmds: AnimateParams[] = [];
    // 时间压缩动效
    this.updateClockState(animateDurationMs, cmds, delay);
    // 系统图标展开/收起动效
    const animateDuration = delay ? animateDurationMs : filterChangeDurationMs;
    const tempHideInfo = this.avoidIconCheck(lastAvoidIconName);
    const tempLayoutIsVisibleIcons = new Set(Array.from(this.currentLayoutSnapShotObj.cacheLayoutIsVisibleIcons));
    this.animateIconVm.getVisibleChangeParam(cmds, animateDuration, delay,
      tempLayoutIsVisibleIcons, this.currentLayoutSnapShotObj.avoidIconName,
      this.currentLayoutSnapShotObj.avoidIconMargin, tempHideInfo);
    // 通知图标数量变化
    const ntfVm =
      this.vmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_NOTIFICATION) as StatusBarNotificationIconVm;
    if (ntfVm && this.currentLayoutSnapShotObj.ntfShowCount >= 0) {
      const ntfCount: number = ntfVm.notificationList.length;
      const ntfShowCount: number = this.currentLayoutSnapShotObj.ntfShowCount;
      const oldShowCount: number = Math.min(ntfCount, ntfVm.showMaxIconCount);
      const newShowCount: number = Math.min(ntfCount, ntfShowCount);
      if (oldShowCount !== newShowCount) {
        // 新旧状态 显示的通知图标数量有变化，则执行动效。
        cmds.push(this.animateIconVm.getNtfIconAnimateParam(ntfVm, ntfShowCount, delay));
      } else if (ntfVm.showMaxIconCount !== ntfShowCount) {
        // 可显示图标数量有变化，刷新数据，不执行动效。
        ntfVm.updateShowMaxIconCount(ntfShowCount);
      }
    }
    // 执行动效
    if (cmds.length > 0) {
      log.showInfo(`Do animation ${cmds.length}`)
      await this.animateIconVm.executeAnimation(cmds);
    }
    return Promise.resolve();
  }

  // instrument ignore next
  public recalculateBaseLayout = SystemUICommonUtil.debounce(() => {
    this.recalculateLayout(true);
  }, 0);

  public recalculateBaseLayoutWithoutAnimation = SystemUICommonUtil.debounce(() => {
    this.recalculateLayout(false);
  }, 0);

  /**
   * 胶囊影响导致的状态栏布局变更计算、动效可相互打断、但无动效刷新，必须等待所有动效执行完成后再执行
   */
  public async recalculateLayout(needAnimation: boolean, delay: number = 0): Promise<void> {
    // 状态栏界面未初始化完成不执行布局计算
    if (!this.statusBarViewLayoutEnable) {
      log.showInfo(`statusBarView Init Not Finish`);
      return Promise.resolve();
    }
    if (!needAnimation) {
      delay = 0;
    }
    // 不带动效的布局计算已有缓存
    if (!needAnimation && this.hasNotAnimationRefresh) {
      return Promise.resolve();
    }
    // 动效执行期间，无动效布局刷新标记缓存后，等待动效执行完成后再执行
    if (!needAnimation && this.animationRunningCount > 0) {
      this.hasNotAnimationRefresh = true;
      return Promise.resolve();
    }
    if (needAnimation) {
      this.animationRunningCount += 1
    }
    await this.preDealWithStatusBarLayout(needAnimation, delay);
    if (needAnimation) {
      this.animationRunningCount -= 1
      if (this.animationRunningCount <= 0 && this.hasNotAnimationRefresh) {
        this.hasNotAnimationRefresh = false;
        this.preDealWithStatusBarLayout(false, 0);
      }
    }
    // 当布局计算完成后，若没有其他布局在执行，则清理要下树的组件
    if (this.animationRunningCount <= 0) {
      const iconListVm = this.vmInjector.getStatusBarIconListVm();
      const allIcons = [...iconListVm.rightIcons, ...iconListVm.leftIcons]
      allIcons.forEach((pluginInfo: PluginInfo) => {
        const pluginName = pluginInfo.pluginParseInfo.pluginSlot;
        const iconVm = this.vmInjector.getStatusBarIconVm(pluginName);
        const isOnTheTree = iconListVm.iconSwitchOnInfo.has(pluginName);
        if (isOnTheTree !== iconVm.isOnTheTree) {
          iconVm.isOnTheTree = isOnTheTree;
          log.showInfo(`Refresh layout isOnTheTree: ${iconVm.isOnTheTree} ${pluginName} `);
        }
      })
    }
  }

  private notifyStatusBarLayoutFinished(): void {
    const layoutInfo: StatusBarLayoutFinishedEvent = new StatusBarLayoutFinishedEvent();
    layoutInfo.isFinished = true;
    log.showInfo('notify statusbar show');
    EvtBus.post(StatusBarLayoutFinishedEvent, layoutInfo);
  }

  public onDropdownShowChange(): void {
    if (!this.cutoutVm.isMiddleCutout()) {
      this.capsulePosition.left = this.computeLeftGroupWidth();
      log.showWarn(`capsulePosition.left: ${this.capsulePosition.left}`);
    }
  }


  public onLanguageChange() {
    this.statusBarPaddingVm.updateStatusBarPadding();
    this.refreshCapsulePosition();
  }

  /**
   * 状态栏实况界面刷新队列，数据相互依赖，刷新流程调整需要谨慎！
   */
  public statusbarLayoutRefresh() {
    this.capsuleLimitRefresh(); // 刷新状态栏左右limit
    this.refreshCapsulePosition(); // 基于上方状态栏基础布局和新挖孔信息 更新胶囊Position
  }

  public updateClockWidth(normalWidth: number, extrudeWidth: number): void {
    log.showInfo(`updateClockWidth normalWidth: ${normalWidth}, extrudeWidth: ${extrudeWidth}`);
    if (this.statusBarClockNormalWidth !== normalWidth) {
      this.statusBarClockExtrudeWidth = extrudeWidth;
      this.statusBarClockNormalWidth = normalWidth;
      this.statusbarLayoutRefresh();
    }
  }

  protected refreshCapsulePosition(): void {
    if (this.cutoutVm.isInStatusBar() && this.cutoutVm.position === CutoutPosition.MIDDLE) {
      this.metaBallPadding = LiveStyle.CAPSULE_HEIGHT / 2 - this.cutoutVm.holeRadius;
      this.capsulePosition.left = this.cutoutVm.left - this.metaBallPadding;
      this.capsulePosition.top = this.cutoutVm.top - this.metaBallPadding;
      this.capsulePosition.width = this.cutoutVm.width + this.metaBallPadding * 2;
      this.capsulePosition.height = this.cutoutVm.height + this.metaBallPadding * 2;
      this.capsulePosition.holes = this.cutoutVm.holes;
    } else {
      this.capsulePosition.left = this.computeLeftGroupWidth();
      this.capsulePosition.top = this.statusBarPaddingVm.statusBarTopPadding;
      this.capsulePosition.width = 0;
      this.capsulePosition.height = this.statusBarGroupHeight;
      this.capsulePosition.holes = [];
    }
    this.capsulePosition.statusBarClockLeftSpace = this.statusBarPaddingVm.statusBarLeftPadding;
    log.showInfo(`refreshCapsulePosition left: ${this.capsulePosition.left}, top: ${this.capsulePosition.top}` +
      `, width: ${this.capsulePosition.width}, height: ${this.capsulePosition.height}`);
  }

  private onPluginWidthChangeEvent = (event: PluginWidthChangeEvent): void => {
    const pluginName = event?.pluginSlot!;
    let newWidth = event.getWidth();
    let delta = pluginName === PluginSlot.SLOT_STATUS_SIGNAL ?
      (newWidth - this.vmInjector.getStatusBarIconVm(pluginName).width) : event.getChangeDelta();
    // instrument ignore if
    if (delta === 0) {
      return;
    }
    // 如果加上delta后超出图标最大宽度，不更新宽度
    // instrument ignore if
    if (this.vmInjector.getStatusBarIconVm(pluginName).width + delta > (DEFAULT_ICON_WIDTH_MAP.get(pluginName) ?? 0)) {
      return;
    }
    log.showInfo(`pluginWidth change, slot: ${event.pluginSlot}, width: ${this.vmInjector.getStatusBarIconVm(pluginName)
      .width}, delta: ${delta}, event width: ${newWidth}`);
    this.vmInjector.getStatusBarIconVm(pluginName).width += delta;
    this.recalculateLayout(false);
  }

  /**
   *挖孔重叠检查
   */
  protected checkOverlapCutout(iconLeft: number): boolean {
    const isDropdown: boolean = StatusBarType.isDropdown(this.vmInjector.getStatusBarIconListVm().statusBarType);
    const metaBallRight = this.cutoutVm.right + this.metaBallPadding;
    const isMiddleCutout = this.cutoutVm.isMiddleCutout();
    // 中挖孔场景下, 下拉面板 或 图标
    return isMiddleCutout && !isDropdown && iconLeft < metaBallRight
  }

  /**
   * 时间和运营商名称重叠检查
   */
  protected checkOverlapClockOrOperator(iconLeft: number, iconRight: number) {
    const clockOrOperatorWidth = this.getClockOrOperatorWidth();
    return !(iconLeft > clockOrOperatorWidth || iconRight < 0);
  }

  /**
   * 通知图标可显示数量计算
   */
  private ntfSpaceCalculate(freeSpace: number): number {
    const isMiddleCutout = this.cutoutVm.isMiddleCutout();
    let ntfShowCount: number = -1;
    // 通知图标可用空间
    const ntfVm =
      this.vmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_NOTIFICATION) as StatusBarNotificationIconVm;
    if (ntfVm) {
      if (isMiddleCutout) {
        const leftLimit = this.capsuleLeftX - this.getClockOrOperatorWidth();
        freeSpace = Math.min(freeSpace, leftLimit)
      }
      if (!isMiddleCutout && this.isExistCapsule && this.capsuleRightX - this.capsuleLeftX >= 28) {
        // 非中挖孔、胶囊宽度大于等于28 认为当前状态栏里边有胶囊显示,
        freeSpace -= (this.capsuleRightX - this.capsuleLeftX);
      }
      if (this.isExistCapsule && this.isShowFullScreenTitleBar) {
        const leftLimit = this.rightLimitWithTitleBar - this.capsuleRightX;
        freeSpace = Math.min(freeSpace, leftLimit);
      }
      let ntfCount = Math.floor(Math.max(freeSpace, 0) / ntfVm.getNtfIconWidth());
      // 存在胶囊场景：通知图标在剩余空间足够放下俩个图标时才显示，且最多显示2个通知图标。XT设备G态非镜像语言除外
      if (this.isExistCapsule && !(this.deviceInfoVm.isXTLandscapeInvertedStatus() && !ResourceVm.instance.isRTL)) {
        ntfCount = ntfCount >= 2 ? 2 : 0;
      }
      ntfShowCount = Math.min(Math.max(ntfCount, 0), NTF_DEFAULT_COUNT);
    }
    return ntfShowCount;
  }

  // instrument ignore next
  protected capsuleLimitRefresh() {
    // 左侧限制区域计算
    let leftLimit = this.cutoutVm.isMiddleCutout() ? this.statusBarClockExtrudeWidth : this.statusBarClockNormalWidth;
    this.capsulePosition.capsuleLeftMax = this.statusBarPaddingVm.statusBarLeftPadding + this.statusBarClockNormalWidth;
    this.capsulePosition.capsuleLeftMinWithoutTime = this.statusBarPaddingVm.statusBarLeftPadding;
    this.capsulePosition.capsuleLeftMin = leftLimit + this.statusBarPaddingVm.statusBarLeftPadding -
      STATUSBAR_CLOCK_EDGE_SPACE;
    // 右侧限制区域计算
    // 胶囊右侧可用空间计算需要调整：胶囊右侧  ~  电池 + 一个信号堆叠的宽度（需要预测堆叠宽度）
    let rightLimit = ArkUIAdapter.px2vp(this.deviceInfoVm.width) - this.statusBarPaddingVm.statusBarRightPadding;
    this.capsulePosition.capsuleRightAllMax = rightLimit;
    let batteryIconVm = this.vmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_BATTERY);
    rightLimit -= (batteryIconVm.width);
    if (!this.cutoutVm.isMiddleCutout()) {
      this.capsulePosition.capsuleRightMax = rightLimit - this.iconCapsuleGap;
      if (this.isShowFullScreenTitleBar) {
        this.rightLimitWithTitleBar =
          (ArkUIAdapter.px2vp(this.deviceInfoVm.width) - TITLE_BAR_RESPONSE_WIDTH) / 2 - TITLE_BAR_RESPONSE_SAFE_GAP;
        this.capsulePosition.capsuleRightAllMax = this.rightLimitWithTitleBar;
        this.capsulePosition.capsuleRightMax = this.rightLimitWithTitleBar;
      }
    } else {
      // 确保给的宽度大于胶囊最小宽度
      const minCapsuleSpace = this.cutoutVm.left + this.cutoutVm.width + MIN_CAPSULE_SPACE;
      this.capsulePosition.capsuleRightMax = Math.max(rightLimit, minCapsuleSpace);
    }
    log.showInfo(`capsule limit left: ${this.capsulePosition.capsuleLeftMin} right: ${this.capsulePosition.capsuleRightMax}`)
  }

  private getSignalDynamicWidthOffset(iconRight: number): StackSignalInfo {
    // 信号可用空间
    const iconListVm = this.vmInjector.getStatusBarIconListVm();
    let signalIconWidth = this.vmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_SIGNAL).width - this.iconGap;
    let signalCanUseSpace = iconRight - this.capsuleRightX;
    const shouldShow =
      this.checkIconCanShow(PluginSlot.SLOT_STATUS_WIFI, this.currentLayoutSnapShotObj.snapShotNewIconFilterRule);
    if (shouldShow && iconListVm.iconSwitchOnInfo.has(PluginSlot.SLOT_STATUS_WIFI)) {
      let wifiIconVm = this.vmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_WIFI);
      signalCanUseSpace -= (wifiIconVm.width);
    }
    if (!this.checkNeedStack()) {
      signalCanUseSpace = 100;
    }
    let actualUsedInfo: StackSignalInfo = { actualWidth: 0, isHide: false, hideSignal: false };
    const signalCallback = scbStatusBarStatusManager.getSignalCallback();
    if (signalCallback !== null && signalCallback.stackSignal) {
      actualUsedInfo = signalCallback.stackSignal(signalCanUseSpace - this.getSignalOffset());
      actualUsedInfo.actualWidth += this.iconGap;
      actualUsedInfo.hideSignal = actualUsedInfo.hideSignal ?? false;
    } else {
      actualUsedInfo.actualWidth = signalIconWidth;
      actualUsedInfo.isHide = false;
    }
    log.showInfo(`signalCanUseSpace ${signalCanUseSpace} actual: ${actualUsedInfo.actualWidth} ${signalIconWidth}`);
    return actualUsedInfo;
  }

  protected checkNeedStack(): boolean {
    // 在双中心不堆叠,回合时要去掉这个条件
    if ((this.currentLayoutSnapShotObj.isDropDownRule() && StatusBarMoveDownVmV2.getInstance().checkNeedMoveDown()) ||
      !this.isExistCapsule) {
      return false;
    }
    return true;
  }

  protected getSignalOffset(): number {
    return 0;
  }

  /**
   * 时间和运营商名称与胶囊重叠的显隐控制
   */
  private updateClockState(duration: number, cmds: AnimateParams[], delay: number) {
    let clockShowType = this.currentLayoutSnapShotObj.clockShowType;
    log.showInfo(`updateClockState from ${this.lastClockShowType} to ${clockShowType}.`);
    if (this.lastClockShowType === clockShowType) {
      return;
    }
    if (duration <= 0) {
      this.updateClockStateWithoutAnimation(clockShowType);
      return;
    }
    const clockIconVm = this.vmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_CLOCK) as StatusBarClockIconVm;
    const ntfIconVm = this.vmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_NOTIFICATION);
    const targetOpacity = clockShowType !== ClockShowType.HIDE ? 1 : this.clockHideOpacity;
    if (targetOpacity !== clockIconVm.capsuleLayoutOpacity) {
      if (targetOpacity === 1) {
        /* 根据当前clockShowType设置动效的起点参数 */
        this.initAnimationParamByClockShowType(clockShowType);
        const ntfTargetOffset =
          clockShowType === ClockShowType.NORMAL_SHOW ? 0 :
            -(this.statusBarClockNormalWidth - this.statusBarClockExtrudeWidth);
        cmds.push(this.animateIconVm.getSystemIconAnimatePara(clockIconVm, 1, 1, 0, delay));
        cmds.push(this.animateIconVm.getSystemIconAnimatePara(ntfIconVm, 1, 1, ntfTargetOffset, delay));
      } else {
        cmds.push(this.animateIconVm.getSystemIconAnimatePara(clockIconVm, this.clockHideOpacity, this.clockHideScale,
          0, delay));
        const animateVm = this.vmInjector.getStatusBarIconAnimVm();
        const ntfTargetOffset =
          (animateVm.isExtrudeType ? -this.statusBarClockExtrudeWidth : -this.statusBarClockNormalWidth) *
            (1 - this.clockHideScale);
        cmds.push(this.animateIconVm.getSystemIconAnimatePara(ntfIconVm, 1, 1, ntfTargetOffset, delay));
      }
      this.lastClockShowType = clockShowType;
      return;
    }

    const ntfTargetOffset: number =
      clockShowType === ClockShowType.EXTRUDE_SHOW ?
        -(this.statusBarClockNormalWidth - this.statusBarClockExtrudeWidth) : 0;
    cmds.push(this.animateIconVm.getSystemIconAnimatePara(ntfIconVm, 1, 1, ntfTargetOffset, delay));
    cmds.push(...this.vmInjector.getStatusBarIconAnimVm().getClockAnimateParam(
      clockIconVm, clockShowType, this.clockTextExtrudeScale, delay
    ));

    this.lastClockShowType = clockShowType;
  }

  private updateClockStateWithoutAnimation(clockShowType: ClockShowType) {
    const animateVm = this.vmInjector.getStatusBarIconAnimVm();
    const clockIconVm = this.vmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_CLOCK) as StatusBarClockIconVm;
    const ntfIconVm = this.vmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_NOTIFICATION);
    const isShowIcon = clockShowType !== ClockShowType.HIDE;
    const targetScale = isShowIcon ? 1 : this.clockHideScale;
    const targetOpacity = isShowIcon ? 1 : this.clockHideOpacity;
    animateVm.isExtrudeType = clockShowType === ClockShowType.EXTRUDE_SHOW;
    animateVm.clockTextScale = clockShowType === ClockShowType.EXTRUDE_SHOW ? this.clockTextExtrudeScale : 1;
    clockIconVm.separatorOpacity = clockShowType === ClockShowType.EXTRUDE_SHOW ? 0 : 1;
    clockIconVm.capsuleLayoutOpacity = targetOpacity;
    clockIconVm.scaleX = targetScale;
    clockIconVm.scaleY = targetScale;
    clockIconVm.offset = 0;
    ntfIconVm.offset = this.getNtfTargetOffsetForClock(clockShowType, targetScale);
  }

  private initAnimationParamByClockShowType(clockShowType: ClockShowType) {
    const animateVm = this.vmInjector.getStatusBarIconAnimVm();
    const clockIconVm = this.vmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_CLOCK) as StatusBarClockIconVm;
    const ntfIconVm = this.vmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_NOTIFICATION);
    animateVm.isExtrudeType = clockShowType === ClockShowType.EXTRUDE_SHOW;
    animateVm.clockTextScale = clockShowType === ClockShowType.EXTRUDE_SHOW ? this.clockTextExtrudeScale : 1;
    clockIconVm.separatorOpacity = clockShowType === ClockShowType.EXTRUDE_SHOW ? 0 : 1;
    clockIconVm.capsuleLayoutOpacity = this.clockHideOpacity;
    clockIconVm.scaleX = this.clockHideScale;
    clockIconVm.scaleY = this.clockHideScale;
    clockIconVm.offset = this.clockHideOffset;
    ntfIconVm.offset =
      (clockShowType === ClockShowType.EXTRUDE_SHOW ? -this.statusBarClockExtrudeWidth :
        -this.statusBarClockNormalWidth) * (1 - this.clockHideScale);
  }

  private getCurrentClockShowType(): ClockShowType {
    let clockShowType: ClockShowType = ClockShowType.NORMAL_SHOW;
    const hasSpace: number =
      this.currentLayoutSnapShotObj.snapShotCapsuleLeft - this.statusBarPaddingVm.statusBarLeftPadding;
    if (!this.currentLayoutSnapShotObj.snapShotIsMiddleCutout) {
      // 非中挖孔，时间不会隐藏和压缩
      clockShowType = ClockShowType.NORMAL_SHOW;
    } else if (hasSpace < this.statusBarClockExtrudeWidth - STATUSBAR_CLOCK_EDGE_SPACE) {
      clockShowType = ClockShowType.HIDE; // 时间隐藏
    } else if (hasSpace < (this.statusBarClockNormalWidth)) {
      clockShowType = ClockShowType.EXTRUDE_SHOW; // 时间压缩
    }
    return clockShowType;
  }

  private getNtfTargetOffsetForClock(clockShowType: ClockShowType, targetScale: number): number {
    if (clockShowType === ClockShowType.NORMAL_SHOW) {
      return 0;
    }

    if (clockShowType === ClockShowType.EXTRUDE_SHOW) {
      return -(this.statusBarClockNormalWidth - this.statusBarClockExtrudeWidth);
    }
    const animateVm = this.vmInjector.getStatusBarIconAnimVm();
    return -(animateVm.isExtrudeType ? -this.statusBarClockExtrudeWidth :
      -this.statusBarClockNormalWidth) * (1 - targetScale);
  }

  /**
   * 计算状态栏左侧区域的图标的实际显示情况占用宽度：
   * @returns
   */
  protected computeLeftGroupWidth(): number {
    let resultWidth: number = this.statusBarPaddingVm.statusBarLeftPadding;
    // 时间
    if (this.dropdownVm.isDropDown) {
      const operatorVm = this.vmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_OPERATOR) as StatusBarIconBaseVm;
      resultWidth = resultWidth + operatorVm.width;
    } else {
      resultWidth += this.statusBarClockNormalWidth;
    }
    return resultWidth > 0 ? resultWidth : 0;
  }

  protected checkNtfIconVisible() {

  }
}