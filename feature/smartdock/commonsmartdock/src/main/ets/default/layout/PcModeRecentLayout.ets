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

import {
  LogDomain,
  RectInfo,
  LogHelper,
  StartType,
  CheckEmptyUtils,
  SingleContext
} from '@ohos/basicutils';
import {
  ViewCallback,
  viewMgrPolicy,
  ViewType,
  GlobalContext,
  HiSysEventUtil,
  ApsUtils,
  ResourceManager,
  HiDfxEventUtil,
  SCBWindowSceneConfig,
  IconResourceManager,
  localEventManager
} from '@ohos/frameworkwrapper';
import { NumberConstants, SCBConstants } from '@ohos/commonconstants';
import { ItemUtils } from '@ohos/componenthelper';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import {
  SCBTransitionManager,
  SCBUnlockTransitionController,
  SCBExpandController
} from '@ohos/windowscene';
import {
  AppIconEventData,
  CommonConstants,
  DockContinuableInfo,
  DockItemInfo,
  layoutConfigManager,
  MenuInfo,
  StyleConstants,
  SCBHiSysEventUtil,
  HiSysContinueSceneStageData,
  HiSysContinueFuncResult,
  EventConstants,
  DockUtils,
  GridLayoutUtil,
  ScreenSplitUtil,
  SnapshotInfo,
  RecentBundleMissionInfo,
  AppStatus,
  AppGalleryDownloadManager,
  DownloadStatusInfo,
  DeliverUtil,
  GridLayoutItemInfo,
  AppDataWrapper,
  AppInstallUtils,
  SmartDockZoomFeatureSwitch,
  AppModel
} from '@ohos/launchercommon';
import {
  AppMenu,
  AppName,
  BadgeAnimationType,
  ItemAnimationParams,
  RunningTask,
  PageDesktopOneShotManager,
  HoverAnimationUtil,
  AppIconCommonView,
  AppIconConfig,
  FoldAnimationConstants,
  AppIconCommonEvent
} from '@ohos/launchercommon/Index';
import curves from '@ohos.curves';
import DesktopUtils from '@ohos/pagedesktop/src/main/ets/default/common/DesktopUtils';
import { SmartDockStyleConfig } from '../common/SmartDockStyleConfig';
import FeatureConstants from '../common/constants/FeatureConstants';
import SmartDockConstants from '../common/constants/SmartDockConstants';
import BackPlane from '../common/component/BackPlane';
import type ServiceExtensionContext from 'application/ServiceExtensionContext';
import RecentDockModel from '../model/RecentDockModel';
import { EditModeState } from '@ohos/launchercommon/src/main/ets/editmode/data/EditModeState';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import { PageDesktopDragHandler, PageDesktopViewModel } from '@ohos/pagedesktop';
import SmartDockViewModel from '../viewmodel/SmartDockViewModel';
import { PcModeDockPopupController, PcModeDockPopupMgr } from '../manager/PcModeDockPopupMgr';
import { ScrollerComponent } from './ScrollerComponent';
import { PcModeDockUtils } from '../utils/PcModeDockUtils';
import BundleManager from '@ohos.bundle.bundleManager';
import { CommonConstants as LockCommonConstants } from '@ohos/screenlockcommon';
import { SpaceAnimationUtils } from '@ohos/launchercommon/src/main/ets/animation/SpaceAnimationUtils';
import { AppIconBadgeVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconBadgeVm';
import { AppIconMenuVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconMenuVm';
import { IconType } from '@ohos/launchercommon/src/main/ets/bean/DockItemInfo';
import { LengthMetrics } from '@kit.ArkUI';
import PcModeContinuableModel from '../pcmode/model/PcModeContinuableModel';
import { SmartDockObserver } from '../viewmodel/smartDockObserver';
import lazy { SmartDockZoomEvent } from '../viewmodel/SmartDockZoomEvent';
import { SmartDockZoomAnimationConfig } from '../common/SmartDockZoomAnimationConfig';
import { DockRegionAnimationEvent } from '../viewmodel/DockRegionAnimationEvent';
import { DockRegionLayoutPropertyVm } from '../viewmodel/DockRegionLayoutPropertyVm';
import { DockRegionAnimationVm } from '../viewmodel/DockRegionAnimationVm';
import { DockItemAnimationVm } from '../viewmodel/DockItemAnimationVm';
import { DockItemAnimationEvent } from '../viewmodel/DockItemAnimationEvent';
import { DockRegionType } from '../common/enum/SmartDockEnum';
import { DockRegionLayoutModel } from '../model/DockRegionLayoutModel';
import lazy { SmartDockAnimationType,
  SmartDockZoomAnimationManager } from '../viewmodel/SmartDockZoomAnimationManager';
import {
  AppIconActiveEventIface
} from '@ohos/launchercommon/src/main/ets/launchericon/interface/AppIconActiveEventIface';

const TAG = 'PcModeRecentLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const ID_DOCK_DIVIDER = `${TAG}_DOCK_DIVIDER`;

/**
 * PcModeRecentLayout
 *
 * @since 2024-8-24
 */
@Component
export struct PcModeRecentLayout {
  mRecentDockMaxNumber: number = CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;
  @Prop singleContext?: SingleContext;
  mSmartDockStyleConfig: SmartDockStyleConfig =
    layoutConfigManager.getStyleConfig(SmartDockStyleConfig.APP_LIST_STYLE_CONFIG, FeatureConstants.FEATURE_NAME);
  onItemClick?: Function;
  buildMenu?: Function;
  private recentDockModel: RecentDockModel = RecentDockModel.getInstance(this.singleContext);
  private deviceType: string = '';
  private unLockTransitionController: SCBUnlockTransitionController = {
    name: `${TAG}_smartdock`,
    onLock: (): void => this.residentOnLockReceived(),
    onUnlock: (): void => this.residentOnUnLockReceived()
  };
  private keyguardCallback: ViewCallback = {
    onHide: (): void => this.onScreenOn()
  };
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private isHasDragDivider: boolean = false; //只要进行了拖拽 ，最近区长度不再进行动态变化
  private expandController?: SCBExpandController;
  private centerX: string | number = 0;
  private centerY: string | number = 0;
  private mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance(this.singleContext);
  private continuableModel: PcModeContinuableModel = PcModeContinuableModel.getInstance();

  @StorageLink('screenWidth') @Watch('updateRecentDockWithOutAnimation') mScreenWidth: number = AppStorage.get<number>('screenWidth') as number;
  @StorageLink('screenHeight') mScreenHeight: number = AppStorage.get<number>('screenHeight') as number;
  @StorageLink('isPortrait') @Watch('onPortraitStatusChange') mIsPortrait: boolean = true;
  @StorageLink('isContinueItemAnimating') isContinueItemAnimating: boolean = false;
  @State layoutPropertyVm: DockRegionLayoutPropertyVm = SmartDockObserver.getInstance().getLayoutPropertyVm();
  // 接续图标显示状态管理, 非接续合并图标
  private isShowContinuableItem: boolean = false;
  @State spaceValue: number = 0;
  @State blurRadius: number = 0;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @StorageLink('residentList') @Watch('updateRecentDockWithOutAnimation') appList: DockItemInfo[] = [];
  @State @Watch('onUnLockReceived') isUnLockReceived: boolean = false;
  @State @Watch('onLockReceived') isLockReceived: boolean = false;
  @StorageLink('pcModeRecentWidth') recentLayoutWidth: number = 0;
  @State dividerScale: number = 1;
  @StorageProp('dividerWidth') dividerWidth: number = 0;
  @State isTouchDivider: boolean = false;
  @StorageProp('themeStyle') @Watch('onThemeChange') themeStyle: string = '';
  @StorageProp('desktopIconChange') @Watch('onThemeChange') desktopIconChange: number = 0;
  @StorageProp('themeStylePreview') @Watch('onPreviewThemeChange') themeStylePreview: boolean = false;
  @StorageLink('screenWidth') screenWidth: number = 0;
  @StorageLink('screenHeight') screenHeight: number = 0;
  @State iconSize: number = this.mSmartDockStyleConfig.mIconSize;
  @State iconRadius: number = this.mSmartDockStyleConfig.mIconRadius;
  @State mDockHeight: number = this.mSmartDockStyleConfig.mDockHeight;
  @State mDockRadius: number = this.mSmartDockStyleConfig.mDockRadius;
  private onDesktopModeChangeEvent: Function = (): void => this.updateLayoutOnModeChange();
  private onMultiWindowExitEvent: Function = (): void => this.onMultiWindowExitEventCallback();
  private onIconSizeChangeEvent: Function = (): void => this.updateLayoutParams();
  private onScaleChangeEvent: (index: number) => void = () => this.onScaleChange();
  private leftArrowPath: string = StyleConstants.DEFAULT_ARROW_LEFT;
  private rightArrowPath: string = StyleConstants.DEFAULT_ARROW_RIGHT;
  @State leftArrowBgColor: Resource | null = null;
  @State rightArrowBgColor: Resource | null = null;
  @State leftArrowOpacity: Resource | number = 1;
  @State rightArrowOpacity: Resource | number = 1;
  private isLeftArrowClickable: boolean = true;
  private isRightArrowClickable: boolean = true;
  private isLeftArrowHover: boolean = false;
  private isRightArrowHover: boolean = false;
  private mRecentScroller: Scroller = new Scroller();
  private scrollAnimDuration: number = 600;
  @State isArrowShow: boolean = false;
  private arrowStartIndex: number = 0;
  @StorageLink('recentList') @Watch('updateRecentDockWithAnimation') globalRecentList: DockItemInfo[] = [];
  @State localRecentList: DockItemInfo[] = [];
  @State recentNum: number = 0;
  @State isShowContinuableItemPopup: boolean = false;
  @State appListWidth: number = 0;
  @State @Watch('onAnimationChange') animationVm: DockRegionAnimationVm = new DockRegionAnimationVm();
  private animationEvent: DockRegionAnimationEvent = new DockRegionAnimationEvent(this.animationVm);
  private region: DockRegionType = DockRegionType.RECENT;
  private scrollSource: ScrollSource = ScrollSource.DRAG
  private recentStartIndex: number = 0;
  private oldDeviceInfoBundleName: string = ''; // 记录上一次接续应用包名

  onPortraitStatusChange(): void {
    log.showInfo('onPortraitStatusChange update');
    this.updateLayoutParams();
  }

  private updateLayoutOnModeChange(): void {
    log.showInfo('onDesktopModeChangeEvent update');
    this.updateLayoutParams();
  }

  private updateLayoutParams(): void {
    this.initAssignment();
    this.iconSize = this.layoutPropertyVm.iconSize;
    this.onRecentDockListChange();
    this.mDockHeight = this.layoutPropertyVm.dockHeight;
    log.showInfo(`spaceValue:${this.spaceValue}` +
      ` recentLayoutWidth:${this.recentLayoutWidth} iconSize:${this.iconSize} mDockHeight:${this.mDockHeight} ` +
      `iconRadius:${this.iconRadius} onPortraitStatusChange ${this.mIsPortrait}`);
  }

  private onMultiWindowExitEventCallback(): void {
    log.showInfo(`exit multiWindowMode`);
    this.updateLayoutParams();
  }

  private onScaleChange(): void {
    SCBSceneSessionManager.getInstance().pcModeDockAreaOffsetY =
      (this.mSmartDockStyleConfig.mDockHeight - this.layoutPropertyVm.dockHeight);
    animateTo({
      duration: SmartDockZoomAnimationConfig.getAnimationDuration(),
      curve: SmartDockZoomAnimationConfig.getAnimationCurve(),
    }, (): void => {
      this.appListWidth = this.getAppListWidth();
      this.recentLayoutWidth = this.getListWidth();
    })
  }

  residentOnLockReceived() {
    this.isLockReceived = true;
    this.isUnLockReceived = false;
  }

  residentOnUnLockReceived() {
    this.isUnLockReceived = true;
    HiDfxEventUtil.reportUnlockToDesktop(HiDfxEventUtil.UNLOCK_TO_DOCK_ANIMATION_BEGIN, CommonConstants.INVALID_VALUE);
  }

  private isInDockList(appList: DockItemInfo[], bundleName: string): boolean {
    let index = -1;
    if (!CheckEmptyUtils.isEmptyArr(appList)) {
      index = appList.findIndex((item) => item.bundleName === bundleName && (item.appIndex ?? 0) === 0);
    }
    return index >= 0;
  }

  private initEventhubEvent(): void {
    let isDeleteRecentApp: string = `${TAG}DeleteApp`;
    this.desktopContext?.eventHub.off(isDeleteRecentApp);
    this.desktopContext?.eventHub.on(isDeleteRecentApp, (): void => this.isHasDragDividerStatusChangeEvent());
    log.showInfo(`isHasDragDividerStatusChangeEvent for Event ${isDeleteRecentApp}`);
  }

  private isHasDragDividerStatusChangeEvent(): void {
    //移除过图标后，不再锁定最近区
    this.isHasDragDivider = false;
  }

  private initAssignment() {
    this.spaceValue = this.recentDockModel.getDockSpace(this.globalRecentList);
    this.dividerWidth = this.recentDockModel.getDividerWidth();
  }

  // fold screen animation
  private expandedAnimation(): void {
    log.showInfo('recent execute expandedAnimation');
    this.animationVm.translateX = FoldAnimationConstants.EXPAND_FACTOR * this.mScreenWidth;
    this.animationVm.scaleSizeX = 1;
    this.animationVm.alpha = 0;
    let recentBgInfo: RectInfo = ItemUtils.getRectById(ID_DOCK_DIVIDER);
    let recentBgDelay = (this.mScreenWidth - recentBgInfo.right) / this.mScreenWidth *
    FoldAnimationConstants.EXPAND_DELAY;
    let scaleX: number = (this.recentLayoutWidth - FoldAnimationConstants.INIT_DOCK_BG_WIDTH) /
    FoldAnimationConstants.DIFF_DOCK_BG_WIDTH * FoldAnimationConstants.DIFF_DOCK_BG_SCALE + 2;

    animateTo({
      curve: FoldAnimationConstants.SCALE_CURVES,
    }, () => {
      this.animationVm.scaleSizeX = scaleX;
    })
    animateTo({
      curve: FoldAnimationConstants.SCALE_CURVES,
      delay: FoldAnimationConstants.RECENT_BG_DELAY,
    }, () => {
      this.animationVm.scaleSizeX = 1;
    })

    animateTo({
      curve: FoldAnimationConstants.TRANSLATE_CURVES,
      delay: recentBgDelay,
    }, () => {
      this.animationVm.translateX = 0;
    })
    animateTo({
      curve: FoldAnimationConstants.ALPHA_CURVES,
      delay: recentBgDelay,
    }, () => {
      this.animationVm.alpha = 1;
    })
  }

  // ScreenOn 状态，主要避免锁屏状态下三方应用拉起，桌面无锁屏通知无法刷新界面
  private onScreenOn(): void {
    if (this.animationVm.visible != Visibility.Visible) {
      log.showInfo('Screen On and show SmartDock')
      this.animationVm.visible = Visibility.Visible;
    }
  }

  private onLockReceived():void {
    log.showInfo('onLockReceived isLockReceived: ' + this.isLockReceived);
    if (!this.isLockReceived) {
      return;
    }
    this.animationEvent.lockAnimation(this.screenWidth, this.screenHeight, SmartDockConstants.PC_MODE_DOCK_RECENT_BG_ID);
  }

  private onUnLockReceived(): void {
    log.showInfo('onUnLockReceived isUnLockReceived: ' + this.isUnLockReceived);
    if (!this.isUnLockReceived) {
      this.animationVm.visible = Visibility.Hidden;
      return;
    }
    this.animationEvent.unlockAnimation(this.screenWidth, this.screenHeight, SmartDockConstants.PC_MODE_DOCK_RECENT_BG_ID);
  }

  async setContinueShow(): Promise<void> {
    log.showInfo(`setContinueShow isShow ${this.isShowContinuableItem}`);
    animateTo({
      duration: SmartDockConstants.CONTINUABLE_ICON_SHOW_DURATION,
      curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1),
    }, () => {
      if (!this.isShowContinuableItem && this.isContinueItemAnimating) {
        this.isContinueItemAnimating = false;
        AppStorage.setOrCreate('isContinueItemAnimating', false);
      }
      this.onRecentDockListChange(false, this.isShowContinuableItem);
    })
  }

  private isUpdateRecentDockList(localRecentList: DockItemInfo[]): boolean {
    if (!CheckEmptyUtils.isEmptyArr(this.localRecentList) && !CheckEmptyUtils.isEmptyArr(localRecentList)) {
      if (this.localRecentList.length < localRecentList.length) {
        return true;
      }
    } else if (CheckEmptyUtils.isEmptyArr(this.localRecentList) && !CheckEmptyUtils.isEmptyArr(localRecentList)) {
      return true;
    }
    return false;
  }

  private updateLocalRecentList(isAddContinuableItem: boolean = false): void {
    let localRecentList: DockItemInfo[] = [];
    for (let i = 0; i < this.globalRecentList.length; i++) {
      localRecentList.push(this.globalRecentList[i]);
    }
    if (this.isUpdateRecentDockList(localRecentList)) {
      this.recentDockModel.addToRecentDockList(localRecentList[localRecentList.length - 1].bundleName);
    }
    if (localRecentList.length > 0 && SCBSceneSessionManager.getInstance().isPcMode()) {
      SCBSceneSessionManager.getInstance().addGestureDockRecentItem(
        localRecentList[localRecentList.length - 1].bundleName,
        localRecentList[localRecentList.length - 1].appIndex);
    }
    this.localRecentList = localRecentList;
  }

  private getListWidth(): number {
    let width: number = 0;
    if (this.globalRecentList?.length === 0) {
      this.isHasDragDivider = false;
      return width * this.layoutPropertyVm.scale;
    }

    if (this.recentNum > this.mRecentDockMaxNumber) {
      width = this.mRecentDockMaxNumber * this.mSmartDockStyleConfig.mListItemWidth +
        (this.mRecentDockMaxNumber - 1) * this.spaceValue + 2 * StyleConstants.DEFAULT_32 +
        4 * StyleConstants.DEFAULT_12;
    } else {
      width = this.recentNum * this.mSmartDockStyleConfig.mListItemWidth + (this.recentNum - 1) * this.spaceValue +
        2 * StyleConstants.DEFAULT_12;
    }

    if (this.isHasDragDivider && width >= this.recentLayoutWidth) {
      return this.recentLayoutWidth;
    }
    return width * this.layoutPropertyVm.scale;
  }

  private getAppListWidth(): number {
    let width: number = 0;
    if (this.globalRecentList?.length === 0) {
      this.isHasDragDivider = false;
      return width * this.layoutPropertyVm.scale;
    }
    if (this.recentNum > this.mRecentDockMaxNumber) {
      width = this.mRecentDockMaxNumber * this.mSmartDockStyleConfig.mListItemWidth +
        (this.mRecentDockMaxNumber - 1) * this.spaceValue + 2 * StyleConstants.DEFAULT_12;
    } else {
      width = this.recentNum * this.mSmartDockStyleConfig.mListItemWidth + (this.recentNum - 1) * this.spaceValue +
        2 * StyleConstants.DEFAULT_12;
    }
    return width * this.layoutPropertyVm.scale;
  }

  private isItemEqual(item1: DockItemInfo, item2: DockItemInfo): boolean {
      if (!item1 || !item2) {
        return false;
      }
      // 比较基础属性
      const keys: string[] = [
        'appName', 'bundleName', 'appIconId', 'abilityName', 'moduleName',
        'keyName', 'appLabelId'
      ];
      for (const key of keys) {
        if (item1?.[key] !== item2?.[key]) {
          return false;
        }
      }
      return true;
  }

  /**
   * 切语言场景, 会调用updateRecentDockWithAnimation方法导致dock出现闪动的动画, 判断运行区是否有修改，如果无修改无需执行更新动画
   * @returns 运行区的图标与之前的是否相等
   */
  private isRecentListChange(): boolean {
    if (this.globalRecentList.length !== this.localRecentList.length) {
      return false;
    }
    return this.globalRecentList.every((item: DockItemInfo, index: number) => {
      return this.isItemEqual(item, this.localRecentList[index]);
    })
  }

  private updateRecentDockWithAnimation() {
    log.showInfo(`recentList change, resident: ${this.appList?.length}, recent: ${this.globalRecentList?.length}, localRecentList: ${this.localRecentList.length}`);
    if (this.isRecentListChange()) {
      log.showInfo('globalRecentList is equal to localRecentList');
      return;
    }
    this.onRecentDockListChange(true);
  }

  private updateRecentDockWithOutAnimation() {
    log.showInfo(`residentList change, resident: ${this.appList?.length}, recent: ${this.globalRecentList?.length}`);
    SmartDockViewModel.getInstance(this.singleContext)
      .initRecentDataList(SCBSceneSessionManager.getInstance().getContainerSessionList());
  }

  private onRecentSizeChange(currentRecentNum: number) {
    log.showInfo('list number change by recent, to %{public}d', currentRecentNum);
    const dockRegionLayoutModel = DockRegionLayoutModel.getInstance();
    const listNumberBefore: number = dockRegionLayoutModel.getListCount();
    dockRegionLayoutModel.updateRegionLayoutLength(this.region, currentRecentNum);
    const listNumber: number = dockRegionLayoutModel.getListCount();
    const isRequiredZoom: boolean = Math.max(listNumberBefore, listNumber) > SmartDockZoomEvent.getInstance().getMinZoomLimit();
    if (isRequiredZoom || (dockRegionLayoutModel.getScale() < StyleConstants.DEFAULT_1)) {
      SmartDockZoomAnimationManager.getInstance().runAnimation('onRecentSizeChange', this.region, SmartDockAnimationType.IMMEDIATELY);
    }
  }

  private async onRecentDockListChange(isNeedAnimation: boolean = false, isAddContinuableItem: boolean = false) {
    if (!SCBSceneSessionManager.getInstance().isPcMode()) {
      log.showInfo('not in pcMode, dont change');
      return;
    }
    this.initAssignment();
    this.updateLocalRecentList(isAddContinuableItem);
    const currentRecentNum: number = this.localRecentList.length;
    if (SmartDockZoomFeatureSwitch.isSupportZoom()) {
      // 触发运行区双箭头临界值需要重新计算缩放最大值
      const isNeedCalZoomLimit: boolean =
        (this.recentNum === this.mRecentDockMaxNumber &&  currentRecentNum === (this.mRecentDockMaxNumber + StyleConstants.DEFAULT_1)) ||
        (this.recentNum === (this.mRecentDockMaxNumber + StyleConstants.DEFAULT_1) && currentRecentNum === this.mRecentDockMaxNumber) ||
        (this.recentNum === StyleConstants.DEFAULT_0 && currentRecentNum === StyleConstants.DEFAULT_1);
      if (isNeedCalZoomLimit) {
        DockRegionLayoutModel.getInstance().updateRegionLayoutLength(this.region, currentRecentNum);
        SmartDockZoomEvent.getInstance().setMinZoomLimit();
      }
      this.onRecentSizeChange(currentRecentNum);
      this.layoutPropertyVm.reloadLayoutProperties(currentRecentNum);
    }
    this.recentNum = currentRecentNum;
    log.showInfo(`onRecentDockListChange recentNum: ${this.recentNum}, isNeedAnimation: ${isNeedAnimation}`);
    if (isNeedAnimation) {
      animateTo({
        duration: 300,
        curve: Curve.Sharp,
        iterations: 1,
        playMode: PlayMode.Normal,
      }, (): void => {
        this.initArrowState();
        this.appListWidth = this.getAppListWidth();
        this.recentLayoutWidth = this.getListWidth();
        log.showInfo(`appListWidth: ${this.appListWidth}, recentLayoutWidth: ${this.recentLayoutWidth}`);
      })
    } else {
      this.initArrowState();
      this.appListWidth = this.getAppListWidth();
      this.recentLayoutWidth = this.getListWidth();
    }
  }

  private onThemeChange(): void {
    this.onRecentDockListChange();
    this.iconSize = this.layoutPropertyVm.iconSize;
    this.iconRadius = this.layoutPropertyVm.iconRadius;
    this.mDockHeight = this.layoutPropertyVm.dockHeight;
    this.mDockRadius = this.layoutPropertyVm.dockRadius;
    log.showInfo('Theme style change.')
  }

  private onPreviewThemeChange(): void {
    this.onRecentDockListChange();
    this.iconSize = this.layoutPropertyVm.iconSize;
    this.iconRadius = this.layoutPropertyVm.iconRadius;
    this.mDockHeight = this.layoutPropertyVm.dockHeight;
    this.mDockRadius = this.layoutPropertyVm.dockRadius;
    log.showInfo('Preview theme style change.');
  }

  private onAnimationChange(): void {
    log.showInfo('onAnimationChange, animationVm translateX:%{public}d, translateY:%{public}d, scaleSizeX:%{public}d' +
      ', scaleSizeY:%{public}d, centerX:%{public}s, centerY:%{public}s.', this.animationVm.translateX,
      this.animationVm.translateY, this.animationVm.scaleSizeX, this.animationVm.scaleSizeY,
      this.animationVm.centerX.toString(), this.animationVm.centerY.toString());
  }

  private initArrowState(): void {
    if (this.recentNum <= this.mRecentDockMaxNumber) {
      this.isArrowShow = false;
    } else {
      this.isArrowShow = true;
      this.updateRecentArrowState(0);
    }
  }

  private getArrowPath(isLeft: boolean): string {
    return isLeft ? this.leftArrowPath : this.rightArrowPath;
  }

  private getArrowOpacity(isLeft: boolean): Resource | number {
    return isLeft ? this.leftArrowOpacity : this.rightArrowOpacity;
  }

  private getArrowBackgroundColor(isLeft: boolean): Resource | null {
    return isLeft ? this.leftArrowBgColor : this.rightArrowBgColor;
  }

  private onHoverArrow(isLeft: boolean, isHover: boolean): void {
    if (isLeft) {
      this.isLeftArrowHover = isHover;
      if (this.isLeftArrowClickable) {
        this.refreshArrowBgColor();
      }
    } else {
      this.isRightArrowHover = isHover;
      if (this.isRightArrowClickable) {
        this.refreshArrowBgColor();
      }
    }
  }

  private refreshArrowBgColor(): void {
    if (this.isLeftArrowClickable) {
      this.leftArrowBgColor = this.isLeftArrowHover ? $r('sys.color.ohos_id_color_hover') : null;
      this.leftArrowOpacity = 1;
    } else {
      this.leftArrowBgColor = null;
      this.leftArrowOpacity = $r('sys.float.ohos_id_alpha_disabled');
    }
    if (this.isRightArrowClickable) {
      this.rightArrowBgColor = this.isRightArrowHover ? $r('sys.color.ohos_id_color_hover') : null;
      this.rightArrowOpacity = 1;
    } else {
      this.rightArrowBgColor = null;
      this.rightArrowOpacity = $r('sys.float.ohos_id_alpha_disabled');
    }
  }

  private doScroll(scroller: Scroller, xOffset: number): void {
    scroller?.scrollTo({
      xOffset: xOffset,
      yOffset: 0,
      animation: {
        duration: this.scrollAnimDuration,
        curve: Curve.Friction
      }
    });
  }

  private getMaxRecentScrollWidth(): number {
    let width: number = 0;
    let scrollNum: number = this.recentNum - this.mRecentDockMaxNumber;
    width = scrollNum * (DockRegionLayoutModel.getInstance().getListItemWidth() + DockRegionLayoutModel.getInstance().getSpace(this.recentNum));
    return width;
  }

  private updateRecentArrowState(offsetX: number): void {
    if (this.recentNum <= this.mRecentDockMaxNumber) {
      this.isArrowShow = false;
      return;
    }
    let currentOffset: OffsetResult = this.mRecentScroller.currentOffset();
    if (!currentOffset) {
      return;
    }
    let finalOffSetX: number = (currentOffset.xOffset) + offsetX;
    let scrollDelta: number = 2;
    let start: number = scrollDelta;
    let end: number = this.getMaxRecentScrollWidth() - scrollDelta;
    this.isLeftArrowClickable = true;
    this.isRightArrowClickable = true;
    if (finalOffSetX <= start) {
      this.isLeftArrowClickable = false;
    } else if (finalOffSetX >= end) {
      this.isRightArrowClickable = false;
    }
    this.refreshArrowBgColor();
  }

  private onClickArrow(isLeft: boolean): void {
    log.showDebug(`onClickArrow isLeft: ${isLeft}`);
    if (isLeft) {
      if (!this.isLeftArrowClickable) {
        return;
      }
      let currentOffset: number = this.mRecentScroller.currentOffset().xOffset;
      let itemWidth: number = DockRegionLayoutModel.getInstance().getListItemWidth() + DockRegionLayoutModel.getInstance().getSpace(this.recentNum);
      let index: number = Math.round(Math.ceil(currentOffset) / itemWidth);
      this.doScroll(this.mRecentScroller, (index - 1) * itemWidth);
      this.updateRecentArrowState(-itemWidth);
      this.arrowStartIndex = index - 1 > 0 ? index - 1 : 0;
      log.showInfo(` ${currentOffset},${this.arrowStartIndex}`);
    } else {
      if (!this.isRightArrowClickable) {
        return;
      }
      const currentOffset: number = this.mRecentScroller.currentOffset().xOffset;
      const itemWidth: number = DockRegionLayoutModel.getInstance().getListItemWidth() + DockRegionLayoutModel.getInstance().getSpace(this.recentNum);
      const index: number = Math.round(Math.floor(currentOffset) / itemWidth);
      this.doScroll(this.mRecentScroller, (index + 1) * itemWidth);
      this.updateRecentArrowState(itemWidth);
      this.arrowStartIndex = index + 1 < this.localRecentList.length - this.mRecentDockMaxNumber ?
        index + 1 : this.localRecentList.length - this.mRecentDockMaxNumber;
      log.showInfo(` ${currentOffset},${this.arrowStartIndex}`);
    }
  }

  private onTouchArrow(isLeft: boolean, event?: TouchEvent): void {
    if (isLeft) {
      if (!this.isLeftArrowClickable) {
        return;
      }
      if (event?.type === TouchType.Down) {
        this.leftArrowBgColor = $r('sys.color.ohos_id_color_click_effect');
      }
      if (event?.type === TouchType.Up) {
        if (this.isLeftArrowHover) {
          this.leftArrowBgColor = $r('sys.color.ohos_id_color_hover');
        } else {
          this.leftArrowBgColor = null;
        }
      }
    } else {
      if (!this.isRightArrowClickable) {
        return;
      }
      if (event?.type === TouchType.Down) {
        this.rightArrowBgColor = $r('sys.color.ohos_id_color_click_effect');
      }
      if (event?.type === TouchType.Up) {
        if (this.isRightArrowHover) {
          this.rightArrowBgColor = $r('sys.color.ohos_id_color_hover');
        } else {
          this.rightArrowBgColor = null;
        }
      }
    }
  }

  private onAreaReachStart(): void {
    if (this.recentNum <= this.mRecentDockMaxNumber) {
      return;
    }
    this.isLeftArrowClickable = false;
    this.isRightArrowClickable = true;
    this.updateRecentArrowState(0);
  }

  private onAreaReachEnd(): void {
    if (this.recentNum <= this.mRecentDockMaxNumber) {
      return;
    }
    this.isLeftArrowClickable = true;
    this.isRightArrowClickable = false;
    this.updateRecentArrowState(0);
  }

  private calculateAreaStartIndex(): void {
    const scroller: Scroller = this.mRecentScroller;
    const currentOffset: number = scroller.currentOffset().xOffset;
    const itemWidth: number = DockRegionLayoutModel.getInstance().getListItemWidth() + DockRegionLayoutModel.getInstance().getSpace(this.recentNum);
    const index: number = Math.round(Math.floor(currentOffset) / itemWidth);
    this.recentStartIndex = index;
  }

  private checkStartIndexOffset(): void {
    const itemWidth: number = DockRegionLayoutModel.getInstance().getListItemWidth() + DockRegionLayoutModel.getInstance().getSpace(this.recentNum);
    const currentOffset: number = this.mRecentScroller.currentOffset().xOffset;
    const disOffset: number = this.recentStartIndex * itemWidth - currentOffset;
    log.showInfo(`checkStartIndexOffset disOffset: ${disOffset}, scrollSource: ${this.scrollSource}`);
    if (this.scrollSource === ScrollSource.OTHER_USER_INPUT && Math.abs(disOffset) > 0.1) {
      this.doScroll(this.mRecentScroller, this.recentStartIndex * itemWidth);
      this.updateRecentArrowState(0);
    }
  }

  @Builder
  arrowBuilder(isLeft: boolean) {
    Row() {
      Image(this.getArrowPath(isLeft))
        .draggable(false)
        .id('RecentLayout_Image_' + (isLeft ? 'leftArrowPath' : 'rightArrowPath'))
        .objectFit(ImageFit.Fill)
        .width(StyleConstants.DEFAULT_24 * this.layoutPropertyVm.scale)
        .height(StyleConstants.DEFAULT_24 * this.layoutPropertyVm.scale)
        .fillColor($r('sys.color.ohos_id_color_secondary'))
        .opacity(this.getArrowOpacity(isLeft))
        .matchTextDirection(true)
    }
    .width(StyleConstants.DEFAULT_32 * this.layoutPropertyVm.scale)
    .height(StyleConstants.DEFAULT_32 * this.layoutPropertyVm.scale)
    .backgroundColor(this.getArrowBackgroundColor(isLeft))
    .margin({
      start: LengthMetrics.vp(isLeft ? StyleConstants.DEFAULT_12 * this.layoutPropertyVm.scale : 0),
      end: LengthMetrics.vp(isLeft ? 0 : StyleConstants.DEFAULT_12 * this.layoutPropertyVm.scale)
    })
    .clip(
      new Circle({
        width: StyleConstants.DEFAULT_32 * this.layoutPropertyVm.scale,
        height: StyleConstants.DEFAULT_32 * this.layoutPropertyVm.scale
      })
    )
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.onClickArrow(isLeft);
    })
    .onTouch((event?: TouchEvent) => {
      this.onTouchArrow(isLeft, event);
    })
    .transition(TransitionEffect.asymmetric(
      TransitionEffect.scale({ x: 0.6, y: 0.6 })
        .combine(TransitionEffect.translate({ x: -StyleConstants.DEFAULT_32 }))
        .combine(TransitionEffect.opacity(0.0))
        .combine(TransitionEffect.scale({ x: 1.0, y: 1.0 }))
        .combine(TransitionEffect.opacity(1.0)),
      TransitionEffect.scale({ x: 0.6, y: 0.6 })
        .combine(TransitionEffect.translate({ x: -StyleConstants.DEFAULT_32 }))
        .combine(TransitionEffect.opacity(0.0)
        )
    ))
  }

  aboutToAppear(): void {
    if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
      log.showInfo('hide the PcModeRecentLayout for first enter desktop');
      this.animationVm.visible = Visibility.Hidden;
    }
    this.mRecentDockMaxNumber = this.mSmartDockStyleConfig.mRecentDockMaxNumber;
    this.onRecentDockListChange();
    if (SmartDockZoomFeatureSwitch.isSupportZoom()) {
      SmartDockZoomEvent.getInstance().setMinZoomLimit();
    }
    SCBSceneSessionManager.getInstance().registerUnlockTransitionCallback(this.unLockTransitionController);
    this.initAssignment();
    viewMgrPolicy.registerViewCallback(ViewType.KEYGUARD, this.keyguardCallback);
    this.expandController = {
      itemId: `${TAG}_recent`,
      onExpandAnimation: () => this.expandedAnimation(),
    };
    SCBTransitionManager.getInstance().registerExpandAnimationController(this.expandController);
    this.initEventhubEvent();
    this.desktopContext?.eventHub.on(EventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopModeChangeEvent);
    this.desktopContext?.eventHub.on(SmartDockConstants.MULTI_WINDOW_EXIT_TRIGGER_RESHAPE_EVENT,
      this.onMultiWindowExitEvent);
    this.desktopContext?.eventHub.on(SmartDockConstants.ICON_SIZE_CHANGE_EVENT, this.onIconSizeChangeEvent);
    this.desktopContext?.eventHub.on(SmartDockConstants.DOCK_ZOOM_EVENT, this.onScaleChangeEvent);
  }

  aboutToDisappear() {
    log.showInfo('RecentLayout aboutToDisappear');
    SCBSceneSessionManager.getInstance().unregisterUnlockTransitionCallback(this.unLockTransitionController);
    viewMgrPolicy.unRegisterViewCallback(ViewType.KEYGUARD, this.keyguardCallback);
    SCBTransitionManager.getInstance().unRegisterExpandAnimationController(this.expandController);
    this.desktopContext?.eventHub.off(EventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopModeChangeEvent);
    this.desktopContext?.eventHub.off(SmartDockConstants.MULTI_WINDOW_EXIT_TRIGGER_RESHAPE_EVENT,
      this.onMultiWindowExitEvent);
    this.desktopContext?.eventHub.off(SmartDockConstants.ICON_SIZE_CHANGE_EVENT, this.onIconSizeChangeEvent);
    this.desktopContext?.eventHub.off(SmartDockConstants.DOCK_ZOOM_EVENT, this.onScaleChangeEvent);
  }

  build() {
    if (!CheckEmptyUtils.isEmptyArr(this.localRecentList)) {
      Row() {
        Column() {
          Divider()
            .vertical(true)
            .color($r('app.color.dock_divider_color'))
            .strokeWidth(SmartDockConstants.RECENT_DOCK_DIVIDER_WIDTH)
            .height(SmartDockConstants.RECENT_DOCK_DIVIDER_HEIGHT)
            .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
            .margin({ top: (this.layoutPropertyVm.dockHeight - SmartDockConstants.RECENT_DOCK_DIVIDER_HEIGHT * this.layoutPropertyVm.scale) /
            NumberConstants.CONSTANT_NUMBER_TWO * this.layoutPropertyVm.scale })
            .translate({ x:this.animationVm.translateX, y:this.animationVm.translateY })
            .scale({
              x: this.animationVm.dividerScale,
              y: this.animationVm.dividerScale,
              centerX: this.animationVm.centerX,
              centerY: this.animationVm.centerY,
            })
            .shadow({
              radius: SmartDockConstants.DOCK_ITEM_SHADOW_RADIUS,
              color: $r('sys.color.ohos_id_color_mask_light'),
              offsetY: 1
            })
            .opacity(this.animationVm.alpha)
            .visibility(this.animationVm.visible)
            .lineCap(LineCapStyle.Round)
            .id(ID_DOCK_DIVIDER)
        }
        .width(this.layoutPropertyVm.dividerWidth)
        .height(this.layoutPropertyVm.dockHeight)
        .borderRadius(this.mDockRadius)

        Stack() {
          BackPlane({
            mDockHeight: this.layoutPropertyVm.dockHeight,
            mDockRadius: this.layoutPropertyVm.dockRadius,
            backPlaneWidth: this.recentLayoutWidth,
            backPlaneId: SmartDockConstants.PC_MODE_DOCK_RECENT_BG_ID,
            backPlaneTranslate: { x:this.animationVm.translateX, y:this.animationVm.translateY },
            backPlaneScale: {
              x:this.animationVm.scaleSizeX,
              y:this.animationVm.scaleSizeY,
              centerX: this.animationVm.isUnlocking ? this.animationVm.centerX : '100%',
              centerY: this.animationVm.centerY,
            },
            backPlaneOpacity: this.animationVm.alpha,
            backPlaneVisibility: this.animationVm.visible,
            backPlaneBlur: this.animationVm.blurRadius,
            backPlaneUseEffect: true
          })

          Flex({
            direction: FlexDirection.Row,
            justifyContent: FlexAlign.Center,
            alignItems: ItemAlign.Center
          }) {
            if (this.isArrowShow) {
              this.arrowBuilder(true);
            }

            List({ scroller: this.mRecentScroller, space: this.layoutPropertyVm.space }) {
              ForEach(this.localRecentList, (item: DockItemInfo, index) => {
                AppItem({
                  singleContext: this.singleContext,
                  appInfo: item,
                  index: index,
                  buildMenu: this.buildMenu,
                  isUnLockReceived: $isUnLockReceived,
                  isLockReceived: $isLockReceived,
                  mSmartDockStyleConfig: this.mSmartDockStyleConfig,
                  mIconSize: this.layoutPropertyVm.iconSize,
                  itemOnClick: (event?: ClickEvent) => {
                    if (editModeManager.isInEditMode()) {
                      return;
                    }
                    if (this.onItemClick) {
                      this.onItemClick(event, item);
                    }
                    HiSysEventUtil.reportDockRecentAppClick(item.bundleName);
                  }
                })
              }, (item: DockItemInfo, index: number) => {
                let thStyleKey = this.themeStyle + this.desktopIconChange;
                const itemKey = `${item.keyName}_${thStyleKey}_`;
                const appKey = itemKey + `${item.installTime}_${item.appIconId}`;
                return appKey;
              })
            }
            .alignListItem(ListItemAlign.Center)
            .clip(false)
            .edgeEffect(EdgeEffect.None)
            .width(this.appListWidth)
            .height(this.layoutPropertyVm.dockHeight)
            .padding({
              left: StyleConstants.DEFAULT_12 * this.layoutPropertyVm.scale,
              right: StyleConstants.DEFAULT_12 * this.layoutPropertyVm.scale
            })
            .scrollSnapAlign(ScrollSnapAlign.START)
            .animation({
              duration: SmartDockConstants.CONTINUABLE_ICON_SHOW_DURATION,
              curve: Curve.Friction
            })
            .listDirection(this.mSmartDockStyleConfig.mListDirection)
            .onScrollStart(() => {
              log.showInfo('onScrollStart');
              AppStorage.setOrCreate('isDockItemMove', true);
            })
            .onWillScroll((scrollOffset: number, scrollState: ScrollState, scrollSource: ScrollSource) => {
              this.scrollSource = scrollSource;
            })
            .onScrollStop(() => {
              log.showInfo('onScrollStop');
              AppStorage.setOrCreate('isDockItemMove', false);
              this.updateRecentArrowState(0);
              this.calculateAreaStartIndex();
              this.checkStartIndexOffset();
            })
            .onReachStart(() => {
              log.showDebug(`onReachStart`);
              this.onAreaReachStart();
              this.calculateAreaStartIndex();
            })
            .onReachEnd(() => {
              log.showDebug(`onReachEnd`);
              this.onAreaReachEnd();
              this.calculateAreaStartIndex();
            })
            .scrollBar(BarState.Off)
            .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
            .onClick(() => {
              // 消费onClick事件，避免编辑模式下，onClick事件透传导致退出编辑模式
              if (editModeManager.isInEditMode()) {
                return;
              }
            })
            .visibility(this.animationVm.visible)

            if (this.isArrowShow) {
              this.arrowBuilder(false);
            }
          }
          .width(this.recentLayoutWidth)
        }
        .clip(CommonConstants.DEFAULT_CLIP_FALSE)
        .borderRadius(this.layoutPropertyVm.dockRadius)
        .alignContent(Alignment.Top)
        .width(this.recentLayoutWidth)
        .height(this.layoutPropertyVm.dockHeight)
        .visibility(this.recentLayoutWidth === 0 ? Visibility.None : Visibility.Visible)
        .foregroundEffect({ radius: this.animationVm.blurRadius })
      }
      .id('PcModeRecentLayout')
      .clip(CommonConstants.DEFAULT_CLIP_FALSE)
      .offset({
        top: this.mSmartDockStyleConfig.mDockHeight - this.layoutPropertyVm.dockHeight
      })
      .height(this.layoutPropertyVm.dockHeight)
      .width(this.recentLayoutWidth + this.layoutPropertyVm.dividerWidth)
      .hitTestBehavior(HitTestMode.Default)
      .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
    }
  }
}

@Component
struct AppItem {
  buildMenu?: Function;
  @Prop singleContext?: SingleContext;
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private mSmartDockStyleConfig: SmartDockStyleConfig =
    layoutConfigManager.getStyleConfig(SmartDockStyleConfig.APP_LIST_STYLE_CONFIG, FeatureConstants.FEATURE_NAME);
  private expandController?: SCBExpandController;
  private continuableModel: PcModeContinuableModel = PcModeContinuableModel.getInstance();
  private appIconConfig: AppIconConfig = new AppIconConfig();
  private appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
  private index: number = -1;
  @State blurRadius: number = 0;
  @Link @Watch('onUnLockReceived') isUnLockReceived: boolean;
  @Link @Watch('onLockReceived') isLockReceived: boolean;
  @StorageProp('screenWidth') screenWidth: number = 0;
  @StorageProp('screenHeight') screenHeight: number = 0;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @State appInfo: DockItemInfo = new DockItemInfo();
  @State menuInfo: MenuInfo[] = [];
  @State editModeState: EditModeState = editModeManager.getEditModeState();
  @State badgeAnimate: BadgeAnimationType = BadgeAnimationType.DEFAULT;
  @Prop mIconSize: number = 0;
  itemOnClick: Function = (event: ClickEvent) => {};
  private onDockMenuChangeEvent: Function = (bundleName: string): void => this.dockMenuChangeEvent(bundleName);
  @StorageLink('isScreenSplit') isScreenSplit: boolean = false;
  @State isMenuShow: boolean = false;
  private hoverDelayTimer: number | null = null;
  @State isPopupShow: boolean = false;
  private isHover: boolean = false;
  @StorageLink('isDockMenuShow') isDockMenuShow: boolean = false;
  @StorageLink('isHoverSnapshot') isHoverSnapshot: boolean = false;
  @StorageLink('isDockItemMove') isDockItemMove: boolean = false;
  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext().config.colorMode as number;
  private popupMgr: PcModeDockPopupMgr = PcModeDockPopupMgr.getInstance();
  @State isUnLocking: boolean = false;
  @StorageLink('isContinueItemAnimating') isContinueItemAnimating: boolean = false;
  @State iconBadgeVm: AppIconBadgeVm = new AppIconBadgeVm();
  @State continueBadgeVisible: boolean = true;
  private iconMenuVm: AppIconMenuVm = new AppIconMenuVm();
  @State isShowContinuableItemPopup: boolean = false;
  @State layoutPropertyVm: DockRegionLayoutPropertyVm = SmartDockObserver.getInstance().getLayoutPropertyVm();
  @State animationVm: DockItemAnimationVm = new DockItemAnimationVm();
  private animationEvent: DockItemAnimationEvent = new DockItemAnimationEvent(this.animationVm);
  private onScaleChangeEvent: (index: number) => void = () => this.onScaleChange();

  private popupController: PcModeDockPopupController = {
    popupAndMenuClose: () => {
      if (this.isPopupShow) {
        this.isPopupShow = false;
        log.showDebug(`popupClose, bundleName: ${this.appInfo?.bundleName}`);
      }
      this.clearHoverDelayTimer();
      // 收到dock隐藏动效通知, 关闭菜单显示
      if (this.isMenuShow) {
        this.setMenuShowStatus(false);
      }
    },
  };

  // fold screen animation
  private expandedAnimation(): void {
    log.showInfo('recent execute expandedAnimation');
    this.animationVm.translateX = FoldAnimationConstants.EXPAND_FACTOR * this.screenWidth;
    this.animationVm.alpha = 0;
    let rectInfo: RectInfo = ItemUtils.getRectById(DockUtils.getDockItemId(this.appInfo));
    let recentDelay = (this.screenWidth - rectInfo.right + (rectInfo.right - rectInfo.left) / 2) / this.screenWidth *
    FoldAnimationConstants.EXPAND_DELAY;
    animateTo({
      curve: FoldAnimationConstants.TRANSLATE_CURVES,
      delay: recentDelay,
    }, () => {
      this.animationVm.translateX = 0;
    })
    animateTo({
      curve: FoldAnimationConstants.ALPHA_CURVES,
      delay: recentDelay,
    }, () => {
      this.animationVm.alpha = 1;
    })
  }

  private keyguardCallback: ViewCallback = {
    onHide: (): void => this.onScreenOn(),
    onShow: (): void => this.onScreenOff()
  };

  private onScreenOff(): void {
    log.showInfo('onScreenOff');
    this.isUnLockReceived = false;
  }

  // ScreenOn 状态，主要避免锁屏状态下三方应用拉起，桌面无锁屏通知无法刷新界面
  // 此次修改和需要this.visible协同
  private onScreenOn(): void {
    log.showInfo(' onScreenOn');
    if (this.animationVm.visible != Visibility.Visible) {
      log.showInfo(' Screen On and show SwiperPage and SmartDock');
      this.animationVm.visible = Visibility.Visible;
    }
  }

  private onScaleChange(): void {
    this.iconBadgeVm.ratio = this.layoutPropertyVm.scale;
  }

  private onLockReceived() {
    if (!this.isLockReceived) {
      return;
    }
    this.animationEvent.lockAnimation(this.screenWidth, this.screenHeight, DockUtils.getDockItemId(this.appInfo));
  }

  private onUnLockReceived() {
    if (!DesktopUtils.isSupportLockAnimation()) {
      return;
    }
    log.showInfo(`pcmode ${this.appInfo.bundleName} onUnLockReceived ${this.isUnLockReceived}`);
    if (this.isUnLockReceived === false) {
      return;
    }
    this.isUnLocking = true;
    this.animationEvent.unlockAnimation(this.screenWidth, this.screenHeight, DockUtils.getDockItemId(this.appInfo),
      () => this.isUnLocking = false);
  }

  private dockMenuChangeEvent(bundleName: string): void {
    if (this.appInfo.bundleName === bundleName) {
      log.showInfo(`dockMenuChangeEvent buneldName: ${bundleName}`);
      this.initMenuInfo();
    }
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear ${this.appInfo.bundleName}-${this.appInfo.abilityName}-${this.appInfo.iconType}`);
    this.initMenuInfo();
    this.initAppIconConfig();
    this.iconBadgeVm.ratio = DockRegionLayoutModel.getInstance().getScale();
    viewMgrPolicy.registerViewCallback(ViewType.KEYGUARD, this.keyguardCallback);
    this.expandController = {
      itemId: `${TAG}_recent`,
      onExpandAnimation: () => this.expandedAnimation(),
    };
    SCBTransitionManager.getInstance().registerExpandAnimationController(this.expandController);
    if (SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType === SCBConstants.UITYPE_PAD) {
      this.desktopContext?.eventHub.on(SmartDockConstants.DOCK_MENU_CHANGE_EVENT, this.onDockMenuChangeEvent);
    }
    if (this.appInfo.itemType !== CommonConstants.TYPE_FOLDER) {
      this.popupMgr.registerPopupController(this.appInfo, this.popupController);
    }
    this.desktopContext?.eventHub.on(SmartDockConstants.DOCK_ZOOM_EVENT, this.onScaleChangeEvent);
  }

  aboutToDisappear(): void {
    viewMgrPolicy.unRegisterViewCallback(ViewType.KEYGUARD, this.keyguardCallback);
    SCBTransitionManager.getInstance().unRegisterExpandAnimationController(this.expandController);
    if (SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType === SCBConstants.UITYPE_PAD) {
      this.desktopContext?.eventHub.off(SmartDockConstants.DOCK_MENU_CHANGE_EVENT, this.onDockMenuChangeEvent);
    }
    if (this.appInfo.itemType !== CommonConstants.TYPE_FOLDER) {
      this.popupMgr.unRegisterPopupController(this.appInfo, this.popupController);
    }
    this.desktopContext?.eventHub.off(SmartDockConstants.DOCK_ZOOM_EVENT, this.onScaleChangeEvent);
  }

  aboutToReuse(param: Record<string, object>) {
    this.appInfo = param.appInfo as DockItemInfo;
    this.isUnLockReceived = Boolean(param.isUnLockReceived);
    this.initMenuInfo();
  }

  aboutToRecycle() {
    this.appInfo = new DockItemInfo();
  }

  private initMenuInfo(isUpdateImmediately: boolean = true) {
    this.menuInfo = this.buildMenu?.(this.appInfo);
    log.showInfo(`initMenuInfo length: ${this.menuInfo.length}`);
    if (isUpdateImmediately) {
      this.iconMenuVm.setMenuInfo(this.getMenuInfoList());
    }
  }

  private getMenuInfoList(): MenuInfo[] {
    let menu: MenuInfo[] = [];
    const missionInfoList = AppStorage.get('missionInfoList') as Array<RecentBundleMissionInfo>;
    const item = missionInfoList.find(item => item.bundleName === this.appInfo.bundleName);
    let queryKey = this.appInfo.bundleName + this.appInfo.moduleName + this.appInfo.abilityName;
    const launchType = SCBSceneSessionManager.getInstance().getAbilityLaunchType(queryKey);
    this.menuInfo.forEach((item: MenuInfo) => {
      if ((item.menuText as Resource).id === $r('app.string.delete_app').id) {
        // PC运行区右键菜单会添加"退出"功能，不需要原本的"移除"功能
        return;
      }
      menu.push(item);
    })
    if (!CheckEmptyUtils.isEmpty(item)) {
      if (PcModeDockUtils.isSupportOpenMultiWindow(launchType, this.appInfo)) {
        menu.push(SmartDockViewModel.getInstance(this.singleContext).getOpenNewWindowMenu(this.appInfo));
      }
      if (!(this.appInfo?.bundleName === 'cn.wps.office.hap' && this.appInfo?.abilityName === 'PromeAbility')) {
        menu.push(SmartDockViewModel.getInstance(this.singleContext).getExitMenu(this.appInfo));
      }
    }
    return menu;
  }

  private setMenuShowStatus(isShow: boolean): void {
    this.isMenuShow = isShow;
    this.isDockMenuShow = isShow;
    if (isShow) {
      AppStorage.setOrCreate('isDockMissionsPopupShow', false);
    }
  }

  @Builder
  MenuBuilder() {
    AppMenu({
      menuInfoList: this.getMenuInfoList(),
      closeMenu: () => {
        this.isMenuShow = false;
      },
      menuWidth: StyleConstants.MENU_WIDTH_COLUMNS_PHONE,
      iconSize: this.mIconSize,
      iconRadius: this.mSmartDockStyleConfig.mIconRadius,
      dragStart: (x: number, y: number) => PageDesktopDragHandler.getInstance(this.singleContext).onDragStart(x, y),
      appItem: this.appInfo as Object as GridLayoutItemInfo,
    })
      .onAppear(() => {
        log.showInfo('dockMenu onAppear');
        this.setMenuShowStatus(true);
        this.desktopContext?.eventHub.emit('AIBarShow', true);
        HiSysEventUtil.reportGoIntoAppShortcutMenu(this.appInfo.bundleName, this.appInfo.appName, 'LAUNCHER');
      })
      .onDisAppear(() => {
        log.showInfo('dockMenu onDisAppear');
        this.setMenuShowStatus(false);
        this.desktopContext?.eventHub.emit('AIBarShow', false);
        localEventManager.sendLocalEvent(EventConstants.EVENT_RESET_HIDE_DOCK_AFTER_POPUP_STATE_CALLBACK);
        AppStorage.setOrCreate<string>('notifyEnterFormManagerAnimate', String(this.appInfo.appIconId));
      })
  }

  private getScaleOptions(): ScaleOptions {
    return {
      x: this.animationVm.scaleSize,
      y: this.animationVm.scaleSize,
      centerX: this.animationVm.centerX,
      centerY: this.animationVm.centerY,
    };
  }

  private getIsScreenSplit(label: string): boolean {
    log.showInfo(`label = ${label}, this.isScreenSplit = ${this.isScreenSplit}`);
    return this.isScreenSplit
  }

  private clearHoverDelayTimer(): void {
    log.showDebug(`clearHoverDelayTimer happen`);
    if (this.hoverDelayTimer) {
      clearTimeout(this.hoverDelayTimer);
      this.hoverDelayTimer = null;
    }
  }

  private setShowPopupTrueWithDelay(delay: number): void {
    // hover需要重新延迟
    this.clearHoverDelayTimer();
    this.hoverDelayTimer = setTimeout(() => {
      this.popupMgr.setCurrItem(this.appInfo);
      this.isPopupShow = true;
      this.isHoverSnapshot = false;
      this.clearHoverDelayTimer();
      log.showInfo(`setShowPopupTrueWithDelay happen end, isPopupShow: ${this.isPopupShow}`);
    }, delay);
  }

  private setShowPopupFalseWithDelay(delay: number): void {
    // hover需要重新延迟
    this.clearHoverDelayTimer();
    this.hoverDelayTimer = setTimeout(() => {
      log.showInfo(`setShowPopupFalseWithDelay, ${this.isHoverSnapshot}, ${this.isDockMenuShow}, ${this.isHover}`);
      if (!this.isHoverSnapshot && !this.isDockMenuShow && !this.isHover) {
        const currItem: DockItemInfo | null = this.popupMgr.getCurrItem();
        if (CheckEmptyUtils.isEmpty(currItem) ||
          (currItem?.bundleName === this.appInfo?.bundleName && currItem?.abilityName === this.appInfo?.abilityName)) {
          this.popupMgr.setCurrItem(null);
        }
        this.isPopupShow = false;
        this.clearHoverDelayTimer();
      }
    }, delay);
  }

  private popupShowJudge(item: DockItemInfo): boolean {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showError(`popupShowJudge, item is empty`);
      return false;
    }

    let result: boolean = this.isPopupShow && !this.isDockMenuShow && !this.isDockItemMove;
    if (this.popupMgr.getCurrItem()?.bundleName != item.bundleName ||
      this.popupMgr.getCurrItem()?.abilityName != item.abilityName) {
      result = false;
    }
    // 列表滑动时候, 重置isPopupShow的值
    if (this.isDockItemMove && this.isPopupShow) {
      this.isPopupShow = false;
    }
    log.showInfo(`popupShowJudge: result: ${result}, isPopupShow: ${this.isPopupShow}, isDockItemMove: ${this.isDockItemMove}, ` +
      `isDockMenuShow: ${this.isDockMenuShow},item:${item.abilityName},${this.popupMgr.getCurrItem()?.abilityName}`);
    return result;
  }

  private onHoverAppItem(isHover: boolean | undefined, item: DockItemInfo): void {
    log.showInfo(`onHoverOrDragAppItem, item.bundleName: ${item?.bundleName}, isHover: ${isHover}, ` +
      `isPopupShow: ${this.isPopupShow}, isDockMenuShow: ${this.isDockMenuShow}, ` +
      `isHoverSnapshot:${this.isHoverSnapshot}`);
    if (this.isDockMenuShow) {
      return;
    }
    this.clearHoverDelayTimer();
    this.isHover = isHover as boolean;
    if (isHover) {
      let snapshotList: SnapshotInfo[] = AppStorage.get<SnapshotInfo[]>('snapshotList') as SnapshotInfo[];
      if (!CheckEmptyUtils.isEmptyArr(snapshotList)) {
        log.showInfo(`onHoverAppItem, snapshotList not null, ` +
          `snapshotList.name: ${snapshotList?.[0]?.name}, length: ${snapshotList?.length}`);
        this.clearHoverDelayTimer();
        if (this.isDockItemMove) {
          log.showInfo('onHoverAppItem, isDockItemMove ignore hoverEvent');
          return;
        }
        this.hoverDelayTimer = setTimeout(() => {
          log.showInfo(`onHoverAppItem, delayed, isHoverSnapshot:${this.isHoverSnapshot}`);
          if (!this.isHoverSnapshot) {
            // 150毫秒之内没hover到scrollerComponent就执行这块
            AppStorage.setOrCreate<string>('hoverItemBundleName', item?.bundleName);
            if (this.popupMgr.getCurrItem()?.bundleName === item?.bundleName &&
              this.popupMgr.getCurrItem()?.abilityName === item?.abilityName &&
            this.popupShowJudge(this.appInfo)) {
              log.showInfo(`onHoverAppItem, the same app, directly return ${this.appInfo.bundleName} `);
              return;
            }
            SmartDockViewModel.getInstance(this.singleContext).onHoverEvent?.(item, true);
            this.popupMgr.closeOtherPopups(item);
            this.setShowPopupTrueWithDelay(SmartDockConstants.HOVER_DELAY_TIME);
            this.popupMgr.setCurrItem(item);
          }
        }, SmartDockConstants.HOVER_GAP_TIME);
      } else {
        AppStorage.setOrCreate<string>('hoverItemBundleName', item?.bundleName);
        SmartDockViewModel.getInstance(this.singleContext).onHoverEvent?.(item, true);
        this.popupMgr.closeOtherPopups(item);
        this.setShowPopupTrueWithDelay(SmartDockConstants.HOVER_DELAY_TIME);
        this.popupMgr.setCurrItem(item);
        log.showInfo(`onHoverAppItem, snapshotList null`);
      }
    } else {
      AppStorage.setOrCreate<string>('hoverItemBundleName', '');
      this.setShowPopupFalseWithDelay(600);
    }
  }

  private onItemPopupStateChange(isVisible: boolean, item: DockItemInfo): void {
    log.showError(`onItemPopupStateChange isVisible:${isVisible},bundleName: ${item.keyName},` +
      ` , ${this.popupMgr.getCurrItem()?.keyName}`);
    let isItemOnHover: boolean = item?.keyName === this.popupMgr.getCurrItem()?.keyName;
    if (!isVisible && this.popupShowJudge(this.appInfo)) {
      log.showInfo(`onItemPopupStateChange, onStateChange bundleName:${item?.bundleName}, abilityName:${item?.abilityName}`);
      this.isPopupShow = false;
      this.popupMgr.setCurrItem(null);
      // 此处为了规避快速点击切换时的画面刷新
      PcModeDockUtils.clearSnapshotList();
      AppStorage.setOrCreate('isHoverSnapshot', false);
      AppStorage.setOrCreate('isClickOpenPopup', false);
    } else if (!isVisible && !isItemOnHover) {
      if (CheckEmptyUtils.isEmpty(this.popupMgr.getCurrItem())) {
        PcModeDockUtils.clearSnapshotList();
      }
      AppStorage.setOrCreate('isHoverSnapshot', false);
    }
    PcModeDockUtils.updateDockMissionsPopupShow(isVisible, isItemOnHover, this.popupMgr.getCurrItem());
  }

  private getBinaryHeight(): number {
    return (this.layoutPropertyVm.dockHeight - this.layoutPropertyVm.iconSize) / 2;
  }

  private onClickEvent(item: DockItemInfo): void {
    let itemAppStatus: AppStatus = item.appStatus as AppStatus;
    if (itemAppStatus !== AppStatus.INSTALLED && itemAppStatus !== undefined) {
      let downloadStatusInfo: DownloadStatusInfo | undefined =
        AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo(item.bundleName);
      if (downloadStatusInfo && !item.appIndex) {
        itemAppStatus = downloadStatusInfo.status;
      }
    }
    if (itemAppStatus === AppStatus.INSTALLED || itemAppStatus === undefined) {
      AppStorage.setOrCreate<string>('hoverItemBundleName', item?.bundleName);
      this.isPopupShow = false;
      SmartDockViewModel.getInstance(this.singleContext).pcModeOnItemClick(null, item);
      let isClickOpenPopup: boolean | undefined = AppStorage.get('isClickOpenPopup');
      if (isClickOpenPopup) {
        this.popupMgr.setCurrItem(item);
        this.isPopupShow = true;
        log.showInfo(`onClickItem ${isClickOpenPopup},currItem: ${this.popupMgr.getCurrItem()?.bundleName}`);
      }
      AppStorage.setOrCreate('isClickOpenPopup', false);
    } else if (item.appIndex && item.appIndex > 0) {
      AppInstallUtils.getInstance().clickTwinApp(item.bundleName);
      return;
    } else if (itemAppStatus === AppStatus.DOWNLOADING) {
      AppInstallUtils.getInstance().pauseTask(item.bundleName);
    } else if (itemAppStatus === AppStatus.PENDING || itemAppStatus === AppStatus.WAIT_FOR_HARMONY) {
      AppInstallUtils.getInstance().checkTask(item);
    } else if (itemAppStatus === AppStatus.PAUSING || itemAppStatus === AppStatus.WIFI_WAITING) {
      AppInstallUtils.getInstance().resumeTask(item.bundleName);
    }
  }

  private execOnTouch(event?: TouchEvent): void {
    log.showDebug(`onTouch event type: ${event?.type}`);
    localEventManager.sendLocalEvent(EventConstants.EVENT_RESET_HIDE_DOCK_AFTER_POPUP_STATE_CALLBACK);
    if (event?.type === CommonConstants.TOUCH_TYPE_DOWN) {
      log.showInfo('onTouch down');
      if (DeliverUtil.isSupportAppType(this.appInfo.bundleName) && DeliverUtil.isSupportDeliver()) {
        SCBSceneSessionManager.getInstance().preloadApp(this.appInfo.bundleName);
      }
    } else if (event?.type === CommonConstants.TOUCH_TYPE_UP) {
      log.showInfo('onTouch up');
      if (!editModeManager.isInEditMode()) {
        this.badgeAnimate = BadgeAnimationType.TOUCH_UP;
      }
    }
  }

  private execOnMouse(event?: MouseEvent): void {
    if (event?.button === MouseButton.Right) {
      if (event?.action === MouseAction.Press) {
        // 适配菜单应用锁功能, 右键场景需要重新刷新
        this.initMenuInfo();
        this.setMenuShowStatus(false);
      }
      log.showInfo('onMouse recent right click');
      if (event?.stopPropagation) {
        event?.stopPropagation();
      }
      AppStorage.setOrCreate('selectDesktopAppItem', '');
    }
  }

  private getContextMenu(): ContextMenuOptions {
    return {
      offset: { x: NumberConstants.CONSTANT_NUMBER_ZERO, y: NumberConstants.CONSTANT_NUMBER_EIGHT },
      placement: Placement.TopLeft,
      backgroundBlurStyle: BlurStyle.NONE,
      preview: MenuPreviewMode.IMAGE,
      aboutToAppear: () => {
        log.showError('dockMenu aboutToAppear');
        this.setMenuShowStatus(true);
        this.isPopupShow = false;
      },
      aboutToDisappear: () => {
        log.showInfo('dockMenu aboutToDisappear');
        this.setMenuShowStatus(false);
        this.isPopupShow = false;
        this.desktopContext?.eventHub.emit(CommonConstants.EVENTHUB_MENU_DISAPPEAR);
      }
    };
  }

  private initAppIconEvent() {
    const appIconActiveEvent: AppIconActiveEventIface = {
      useDefaultIconShow: true,
      onActive: (): void => {
        this.continueBadgeVisible = false;
        log.showInfo('onActive');
      },
      onInactive: (): void => {
        this.continueBadgeVisible = true;
        log.showInfo('onInActive');
      }
    }
    this.appIconCommonEvent.setIconActiveEvent(appIconActiveEvent);
  }

  private initAppIconConfig() {
    this.initAppIconEvent();
    const appData: AppDataWrapper = AppDataWrapper.getDefaultAppData(this.appInfo,
      this.mSmartDockStyleConfig.mIconRadius);
    appData.setStartType(StartType.DOCK_APP)
      .setAppIconId(AppModel.getInstance().getAppIconContainerId('SmartDock_AppIcon',
        this.appInfo.bundleName, this.appInfo.abilityName, this.appInfo.appIndex))
    this.appIconConfig.setEnableName(false)
      .setEnableMultiSelect(false)
      .setEnableBackplane(false)
      .setEnableHoverAnimation(true)
      .setEnableTouchMask(false)
      .setAppDataOfTransactionController(appData)
      .setIsDesktopItem(false)
      .setEnableDrag(false)
      .setKeepMenuOrder(true)
      .setEnableContainerOpacityChange(false)
      .setExternCb({
        getMenuInfo: (): MenuInfo[] => {
          return this.getMenuInfoList();
        },
        onLongPressPreGatherAction: () => {
          this.initMenuInfo(false);
        },
        onMenuAppear: (isLongPressShow: boolean) => {
          this.setMenuShowStatus(true);
          this.isPopupShow = false;
        },
        onMenuDisappear: (isLongPressShow: boolean) => {
          animateTo({
            duration: 0,
          }, () => {
            this.animationVm.alpha = 1;
          });
          this.setMenuShowStatus(false);
          this.isPopupShow = false;
          this.desktopContext?.eventHub.emit(CommonConstants.EVENTHUB_MENU_DISAPPEAR);
        },
        onIconClick: (event?: ClickEvent, fingers?: number): void => {
          log.showInfo('onClick icon');
          if (editModeManager.isInEditMode()) {
            return;
          }
          this.onClickEvent(this.appInfo);
        },
        onMenuDragStart: (x: number, y: number): void => {
          PageDesktopDragHandler.getInstance().onDragStart(x, y);
        }
      })
    // 预览图底部margin设置为0，防止菜单生成时组件位置突变
    // dock在屏幕底端，下方设置有24vp的安全间隔，由于与导航条间隔太近，会使预览图生成的时候往上偏，预期是菜单原地生成，因此将该属性设为0
    this.iconMenuVm.setLayoutRegionMargin({ bottom: 0 });
  }

  @Builder
  popupBuilder(item: DockItemInfo) {
    ScrollerComponent({
      singleContext: this.singleContext,
      mPopItem: item,
      popupOffsetUpdate: (position: Position) => {
      },
      updateData: (show: boolean, bundleName: number, callback: Callback<void>) => {
        log.showInfo(`updateData ${show}, ${bundleName}`);
        if (show) {
          callback();
          this.popupMgr.closeOtherPopups(item);
          this.setShowPopupTrueWithDelay(SmartDockConstants.HOVER_DELAY_TIME);
        } else {
          callback();
          log.showInfo(`updateData isPopupShow false`);
          this.isPopupShow = false;
        }
      },
      popupHide: () => {
        if (!(this.isHover)) {
          log.showInfo(`updateData popupHide false`);
          this.isPopupShow = false;
          this.popupMgr.setCurrItem(null);
          PcModeDockUtils.clearSnapshotList();
        }
      }
    })
  }

  @Styles
  eventStyles() {
    .parallelGesture(
      GestureGroup(GestureMode.Parallel,
        LongPressGesture({ repeat: false, duration: 250 })
          .onAction((event?: GestureEvent) => {
            log.showInfo('recent long press start');
            AppStorage.setOrCreate('isLongPress', true);
          }),
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_HIDE_BADGE })
          .onAction((event?: GestureEvent) => {
            if (!this.isScreenSplit && event?.source === SourceType.TouchScreen) {
              this.setMenuShowStatus(true);
            }
            this.badgeAnimate = BadgeAnimationType.OPACITY_ZERO;
          })
      )
    )
    .onTouch((event?: TouchEvent) => {
      this.execOnTouch(event);
    })
    .onMouse((event: MouseEvent) => {
      this.execOnMouse(event);
    })
  }

  @Builder
  accessibilityNameBuilder() {
    if (this.isAccessibilityMode) {
      // 仅用于无障碍屏幕朗读模式下app名称播报
      AppName({
        nameHeight: 0,
        nameWidth: 0,
        nameSize: 0,
        bundleName: this.appInfo.bundleName,
        moduleName: this.appInfo.moduleName,
        parentItem: this.appInfo,
        appName: this.appInfo.appName,
        labelId: this.appInfo.appLabelId,
        useCache: true,
        itemStatus: this.appInfo?.appStatus,
        zValue: -1,
      })
    }
  }

  @Builder
  appIconBuilder() {
    Column() {
      Flex() {
        AppIconCommonView({
          iconSize: this.mIconSize,
          appIconConfig: this.appIconConfig,
          iconEvent: this.appIconCommonEvent,
          item: this.appInfo,
          iconRadius: this.layoutPropertyVm.iconRadius,
          iconBadgeVm: this.iconBadgeVm,
          iconMenuVm: this.iconMenuVm,
        })
      }
      .id(AppModel.getInstance().getAppIconContainerId('SmartDock_AppIcon',
        this.appInfo.bundleName, this.appInfo.abilityName, this.appInfo.appIndex))
      .width(this.mIconSize)
      .height(this.mIconSize)
      .backgroundColor(this.mSmartDockStyleConfig.mItemBackgroundColor)
      .borderRadius(this.mSmartDockStyleConfig.mIconRadius)
      .shadow(this.mSmartDockStyleConfig.mIconRadius === CommonConstants.DEFAULT_ICON_RADIUS ? {
        radius: SmartDockConstants.DOCK_ITEM_SHADOW_RADIUS,
        color: SmartDockConstants.DOCK_ITEM_SHADOW_COLOR,
        offsetY: SmartDockConstants.DOCK_ITEM_SHADOW_OFFSETY_ONE
      } : undefined)
      .scale(this.getScaleOptions())
      .translate({ x: this.animationVm.translateX, y: this.animationVm.translateY })
      .opacity(this.animationVm.alpha)
      .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
      .transition(TransitionEffect.IDENTITY)
      .hitTestBehavior(this.editModeState.isInEditMode() ? HitTestMode.None : HitTestMode.Default)
      .draggable(false)
      .eventStyles()
      .onHover((isHover?: boolean) => {
        this.onHoverAppItem(isHover, this.appInfo);
      })
      .bindPopup(this.popupShowJudge(this.appInfo), {
        builder: this.popupBuilder(this.appInfo),
        placement: Placement.Top,
        mask: false,
        enableArrow: true,
        autoCancel: true,
        onStateChange: (e) => {
          this.onItemPopupStateChange(e.isVisible, this.appInfo);
        },
        showInSubWindow: true,
        offset: { x: 0, y: -this.getBinaryHeight() },
        radius: StyleConstants.DEFAULT_8,
        shadow: ShadowStyle.OUTER_DEFAULT_SM,
        backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR
      })

      RunningTask({
        appInfo: this.appInfo,
        currColorMode: this.currColorMode,
        ratio: this.layoutPropertyVm.scale
      })
        .height(this.getBinaryHeight())
        .padding({ top: StyleConstants.DEFAULT_5 * this.layoutPropertyVm.scale })
        .visibility(this.isUnLocking ? Visibility.Hidden : Visibility.Visible)
    }
    .margin({
      top: this.getBinaryHeight()
    })
  }

  @Builder
  AppPixmapCreator() {
    Stack() {
      this.IconBuilder(this.updateIconImage());
    }
  }

  public updateIconImage(): string | PixelMap {
    if (this.appInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      return ResourceManager.getInstance().getCachedAppIcon(this.appInfo.appIconId,
        this.appInfo.bundleName as string, this.appInfo.moduleName as string)
    } else {
      return IconResourceManager.getInstance().getCachedCombIconSync(this.appInfo.bundleName,
        this.appInfo.moduleName as string, this.appInfo.abilityName);
    }
  }

  @Builder
  IconBuilder(resource: string | PixelMap) {
    Image(resource)
      .draggable(false)
      .width(this.mIconSize)
      .height(this.mIconSize)
      .borderRadius(this.mSmartDockStyleConfig.mIconRadius)
      .backgroundColor(this.appInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON ?
      StyleConstants.SHORTCUT_ICON_BG : null)
      .syncLoad(this.isSyncLoad(resource))
      .interpolation(ImageInterpolation.Medium)
      .autoResize(false)
    Column()
      .width(this.mIconSize)
      .height(this.mIconSize)
      .backgroundColor(StyleConstants.APP_ICON_GRAY_COLOR)
      .visibility(Visibility.Hidden)
      .borderRadius(CommonConstants.DEFAULT_ICON_RADIUS)
  }

  private isSyncLoad(resource: string | PixelMap): boolean {
    return (typeof resource !== 'string') || GridLayoutUtil.isImageSyncLoad(resource);
  }

  @Builder
  ContinueItemPopupBuilder(info: DockContinuableInfo) {
    Column() {
      Text(info.appName)
        .draggable(false)
        .fontSize(SmartDockConstants.CONTINUABLE_ICON_POPUP_TITLE_SIZE)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .margin(SmartDockConstants.CONTINUABLE_ICON_POPUP_TEXT_MARGIN)
      Text($r('app.string.continue_hap_come_from', info.sourceDeviceName))
        .draggable(false)
        .fontSize(SmartDockConstants.CONTINUABLE_ICON_POPUP_DESC_SIZE)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .margin(SmartDockConstants.CONTINUABLE_ICON_POPUP_TEXT_MARGIN)
    }
    .alignItems(HorizontalAlign.Start)
    .padding(SmartDockConstants.CONTINUABLE_ICON_POPUP_PADDING)
  }

  build() {
      ListItem() {
        // 开启无障碍屏幕朗读模式
        if (this.isAccessibilityMode) {
          Stack({ alignContent: Alignment.Center }) {
            // 仅用于无障碍屏幕朗读模式下app名称播报
            this.accessibilityNameBuilder()
            this.appIconBuilder()
          }
          .accessibilityDescription(ResourceManager.getInstance().getStringByName('tap_with_menu_reader_text'))
          .width(this.mIconSize)
        } else {
          this.appIconBuilder()
        }
      }
      .foregroundEffect({ radius: this.animationVm.blurRadius })
      .id(DockUtils.getDockItemId(this.appInfo))
      .width(this.mIconSize)
      .visibility(this.animationVm.visible)
  }
}
