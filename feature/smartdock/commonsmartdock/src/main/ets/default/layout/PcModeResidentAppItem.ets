/**
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
  CheckEmptyUtils,
  LogDomain,
  CompanionIconInfo,
  LogHelper,
  AnimateToScheduleUtils,
  TraceUtil,
  DomainName,
  StartType,
  RectInfo,
  SingleContext
} from '@ohos/basicutils';
import {
  dropAnimationManager,
  GravityAnimationComponent,
  gravityAnimationManager,
  GravityAnimationPage,
  GravityAnimationParameter
} from '@ohos/componentanimator/Index';
import {
  DeviceHelper,
  ViewCallback,
  GlobalContext,
  ResourceManager,
  SCBWindowSceneConfig,
  viewMgrPolicy,
  ViewType,
  DownloadStatusChangeEvent,
  DownloadingProgressChangeEvent,
  localEventManager,
  HiSysEventUtil,
  HiDfxEventUtil,
  IconResourceManager,
  InstallStatusChangeEvent
} from '@ohos/frameworkwrapper';
import {
  desktopUtil,
  dragSnapshotHelper,
  SnapshotType,
  ObjectCopyUtil,
  ItemUtils,
  StateEx,
  DragAccessibilityUtils,
  SCBVisualEffectMgr,
  RTLUtil
} from '@ohos/componenthelper';
import { SCBConstants, NumberConstants, VisualEffectConstants } from '@ohos/commonconstants';
import {
  DragExtraInfo,
  DragDataType,
  DragEventManager,
  DragEventCallback,
  DragItemPosition,
} from '@ohos/componentdrag';
import {
  SCBTransitionManager,
  SCBExpandController,
  SCBFoldController,
  SCBSceneSessionManager,
  scbEventExclusiveManager,
  EventType,
  ResUtils
} from '@ohos/windowscene';
import { DropAnimationScene, } from '@ohos/componentanimator';
import {
  AppItemInfo,
  MenuInfo,
  layoutConfigManager,
  PresetStyleConstants,
  DeliverUtil,
  GrayAppListManager,
  DockUtils,
  AppGalleryDownloadManager,
  UninstallDialogStatus,
  RecentBundleMissionInfo,
  DesktopFontScaleState,
  desktopFontScaleManager,
  DockContinuableInfo,
  SCBHiSysEventUtil,
  HiSysContinueFuncResult,
  AppDataWrapper,
  ShortcutViewModel,
  AppIconModel,
  AppInstallUtils,
  AppModel,
  ResidentLayoutCacheMgr,
  FolderManager,
  layoutLockUtil,
  NotHarmonyUtil,
  SmartDockZoomFeatureSwitch
} from '@ohos/launchercommon';
import {
  ItemAnimationParams,
  LongPressAppIconInfo,
  FolderViewData,
  AppName,
  HoverAnimationUtil,
  BadgeAnimationType,
  RunningTask,
  PageDesktopOneShotManager,
  AppIconCommonView,
  AppIconConfig,
  AppIconCommonEvent,
  AppIconContainerModifier,
  FolderStyleManager,
  ContractedFolder,
  DeskTopItemStyle,
  FoldAnimationConstants,
} from '@ohos/launchercommon/Index';
import curves from '@ohos.curves';
import SmartDockConstants from '../common/constants/SmartDockConstants';
import {
  EventConstants,
  StyleConstants,
  CommonConstants,
  DockItemInfo,
  SettingsModel,
  LayoutViewModel,
  AppIconEventData,
  FolderItemInfo,
  SnapshotInfo
} from '@ohos/launchercommon';
import { PcModeDockPopupController, PcModeDockPopupMgr } from '../manager/PcModeDockPopupMgr';
import measure from '@ohos.measure';
import { ScrollerComponent } from './ScrollerComponent';
import { PcModeDockUtils } from '../utils/PcModeDockUtils';
import { AppMenu } from '@ohos/launchercommon/Index';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { PageDesktopDragHandler, DesktopUtils, PageDesktopViewModel } from '@ohos/pagedesktop';
import { SmartDockStyleConfig } from '../common/SmartDockStyleConfig';
import SmartDockDragHandler from '../common/SmartDockDragHandler';
import FeatureConstants from '../common/constants/FeatureConstants';
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import { GridLayoutUtil } from '@ohos/launchercommon';
import { AppGalleryEventInfo, DeviceState } from '@ohos/launchercommon';
import { BigFolderViewModel } from '@ohos/bigfolder';
import { vibratorMgr } from '@ohos/launchercommon';
import { AppStatus, DownloadStatusInfo } from '@ohos/launchercommon';
import SmartDockViewModel from '../viewmodel/SmartDockViewModel';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { FolderDataModelManager } from '@ohos/launchercommon';
import { EditModeState } from '@ohos/launchercommon/src/main/ets/editmode/data/EditModeState';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import { FolderLayoutChangeListener } from '@ohos/launchercommon/src/main/ets/folder/FolderViewModel';
import BundleManager from '@ohos.bundle.bundleManager';
import { CommonConstants as LockCommonConstants } from '@ohos/screenlockcommon';
import { SpaceAnimationUtils } from '@ohos/launchercommon/src/main/ets/animation/SpaceAnimationUtils';
import { FixedDockResource } from '../common/constants/PcModeDockConstants';
import { BusinessError } from '@kit.BasicServicesKit';
import { SmartDockEventMgr } from '../manager/SmartDockEventMgr';
import { AppIconData } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconData';
import { AppIconMenuVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconMenuVm';
import {
  AppIconHoverEventIface
} from '@ohos/launchercommon/src/main/ets/launchericon/interface/AppIconHoverEventIface';
import {
  AppIconActiveEventIface
} from '@ohos/launchercommon/src/main/ets/launchericon/interface/AppIconActiveEventIface';
import { AppIconBadgeVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconBadgeVm';
import { LengthMetrics } from '@kit.ArkUI';
import PcModeContinuableModel from '../pcmode/model/PcModeContinuableModel';
import lazy { SmartDockZoomManager } from '@ohos/launchercommon/src/main/ets/dock/common/SmartDockZoomManager';
import { DockRegionLayoutModel } from '../model/DockRegionLayoutModel';
import { DockRegionLayoutPropertyVm } from '../viewmodel/DockRegionLayoutPropertyVm';
import { SmartDockObserver } from '../viewmodel/smartDockObserver';
import { DockItemAnimationEvent } from '../viewmodel/DockItemAnimationEvent';
import { DockItemAnimationVm } from '../viewmodel/DockItemAnimationVm';
import { SmartDockStyleMgr } from '../manager/SmartDockStyleMgr';

const TAG = 'PcModeResidentAppItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const BACK_PLANE_ANIM_DURATION: number = 400;
const ICON_ALPHA_ANIM_DURATION: number = 400;
const I_CURVE:ICurve = curves.cubicBezierCurve(0.40, 0, 0.40, 1);


@Component
export struct PcModeResidentAppItem {
  @Prop singleContext?: SingleContext;
  @StorageLink('dragItemType') dragItemType: number = CommonConstants.DRAG_FROM_DOCK;
  @Consume('convertFolderId') convertFolderId : string;
  @Consume('startConvert') startConvert: number;
  @State isShow: boolean = false;
  @State itemScale: number = 1;
  @State blurRadius: number = 0;
  @Link @Watch('onUnLockReceived') isUnLockReceived: boolean;
  @Link @Watch('onLockReceived') isLockReceived: boolean;
  @StorageProp('screenWidth') screenWidth: number = 0;
  @StorageProp('screenHeight') screenHeight: number = 0;
  @StorageLink('residentList') @Watch('onDockListChange') appList: Array<DockItemInfo> = [];
  appInfo: DockItemInfo = new DockItemInfo();
  buildMenu?: Function;
  @State menuInfo: MenuInfo[] = [];
  @State dockItemPotentialLocationOpacityOn: number = 0;
  @State dockItemPotentialLocationOpacityOff: number = 1;
  private delayValue: number = 0;
  private curveValue: number = 0;
  @State badgeAnimate: BadgeAnimationType = BadgeAnimationType.DEFAULT;
  @State mSmartDockStyleConfig: SmartDockStyleConfig =
    layoutConfigManager.getStyleConfig(SmartDockStyleConfig.APP_LIST_STYLE_CONFIG, FeatureConstants.FEATURE_NAME);
  private mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance(this.singleContext);
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  @State private mFolderItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
  private mFolderViewModel: BigFolderViewModel = BigFolderViewModel.getInstance();
  @State appBubbleBackplaneRatio: number = 1;
  @State isGrayIcon: boolean = false;
  @State editModeState: EditModeState = editModeManager.getEditModeState();
  @Consume isShowingUninstallDialog: number;
  @Consume dragToUninstallItemInfo: DockItemInfo;
  @Consume('isFromDock') isFromDock: boolean;
  @StorageLink('isConvertFromDock') isConvertDock: boolean = false;
  private region: number = 0;
  @State appName: string = '';
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @StorageLink('isDrag') isDrag: boolean = false;
  @StorageLink('closeBigFolder') @Watch('closeFolder') closeBigFolder: boolean = false;
  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext().config.colorMode as number;
  private foldController?: SCBFoldController;
  private expandController?: SCBExpandController;

  @State toBigTranslateX: number = 0;
  @State toBigTranslateY: number = 0;
  @State startPositionX: number = 0;
  @State startPositionY: number = 0;


  @Prop mIconSize: number = StyleConstants.DEFAULT_APP_ICON_SIZE_WIDTH;
  private mAppNameHeight: number = StyleConstants.DEFAULT_APP_NAME_HEIGHT;
  private mAppNameWidth: number = StyleConstants.DEFAULT_APP_NAME_WIDTH;
  private mAppNameSize: number = StyleConstants.DEFAULT_APP_NAME_SIZE;

  private bigGridGap: number = 0;
  private bigIconNameMarginTop: number = 0;
  private bigGridMargin: number = 0;
  private bigIconNameMargin: number = 0;
  private mItemPadding: number = 0;
  private mGridWidth: number = 0;
  private mGridSize: number = 0;
  private mFolderAppSize: number = 0;
  private mFolderRadius: number = 0;
  private appIconWidth: number = 0;
  private appIconHeight: number = 0;
  private smallGridGap: number = 0;
  private smallGridPadding: number = 0;
  private smallFolderSize: number = 0;
  private mSmallFolderRadius = 0;
  private mSmallFolderIconRadius: number = 0;
  private mClosedFolderIconRadius: number = 0;
  @State @Watch('onAppStatusChange') itemAppStatus: AppStatus = AppStatus.INSTALLED;
  private notInstalledMenuMap: Map<AppStatus, MenuInfo[]> = new Map();
  @State isMenuShow: boolean = false;
  @State iconMenuVm: AppIconMenuVm = new AppIconMenuVm();
  @State iconData: AppIconData = new AppIconData();
  @State isAppBackplaneAppear: boolean = false;
  @State isInAppBackplaneBigAnimation: boolean = false;
  @State isInAppBackplaneSmallAnimation: boolean = false;
  @Consume @Watch('dockItemOpacityAnimation') companionIconInfo: CompanionIconInfo;
  private isBackplaneExist: boolean = false;
  private dragEventCallback: DragEventCallback = {};
  private itemKey: string = '';
  private appGalleryStatusChangeEventId: string = '';

  itemOnClick: Function = (event?: ClickEvent) => {};

  // 是否开始拖拽，起拖后置为true，开始落位时置为false
  @Provide isDragStart: boolean = false;

  // 是否处于拖拽过程中，起拖后置为true，落位动效完成时置为false
  @Provide @Watch('onEqualToDropItemChange') isInDrag: boolean = false;

  // 小转大，大文件夹参数
  @Provide mViewData: FolderViewData = new FolderViewData();

  /* swiper page图标落位到桌面时，dock的图标也要受引力动效影响，因此也要注册 */
  private gravity: GravityAnimationComponent | null = null;

  @Provide isOnPreDrag: StateEx<boolean> = new StateEx(false, 'folder preDragStatus');
  @Provide isHideFolderOnConvert: boolean = true;
  private onDockMenuChangeEvent: Function = (bundleName: string): void => this.dockMenuChangeEvent(bundleName);
  private iconReductionEvent: (index: number) => void = (index) => this.onDockIconReduction(index);
  private onScaleChangeEvent: (index: number) => void = () => this.onScaleChange();
  private startSqueezeEvent: Function =
    (center: number, immediate: boolean): void => this.dockItemMoveAnimationFunc(center, immediate);
  private cancelSqueezeEvent: Function = (): void => { this.animationVm.translateX = 0 };
  private coveredItemEvent: Function = (isShow: boolean): void => this.onEventhubCoveredItemEvent(isShow);
  private cancelItemEvent: Function = (isCancel: boolean): void => this.onEventhubCancelItemEvent(isCancel);

  @State isPcMode: boolean = SCBSceneSessionManager.getInstance().isPcMode();
  private isHover: boolean = false;
  private hoverDelayTimer: number | null = null;
  @State isPopupShow: boolean = false;
  @State iconBadgeVm: AppIconBadgeVm = new AppIconBadgeVm();
  @State continueBadgeVisible: boolean = true;
  @StorageLink('isDockMenuShow') isDockMenuShow: boolean = false;
  @StorageLink('isHoverSnapshot') isHoverSnapshot: boolean = false;
  private popupMgr: PcModeDockPopupMgr = PcModeDockPopupMgr.getInstance();
  private isAppIconDrag: boolean = true;
  private appIconConfig: AppIconConfig = new AppIconConfig();
  private appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
  @State isUnLocking: boolean = false;
  @State fontScaleState: DesktopFontScaleState = desktopFontScaleManager.getSysFontScaleState();
  @StorageLink('continueDeviceInfo') @Watch('onContinueDeviceChange') deviceInfo: DockContinuableInfo =
    new DockContinuableInfo();
  @State desktopStyle: DeskTopItemStyle | undefined = undefined;
  @Provide translateX: number = 0;
  @Provide translateY: number = 0;
  @State layoutPropertyVm: DockRegionLayoutPropertyVm = SmartDockObserver.getInstance().getLayoutPropertyVm();
  @State animationVm: DockItemAnimationVm = new DockItemAnimationVm();
  private animationEvent: DockItemAnimationEvent = new DockItemAnimationEvent(this.animationVm);

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

  private onScaleChange(): void {
    this.iconBadgeVm.ratio = this.layoutPropertyVm.scale;
  }

  private onContinueDeviceChange(): void {
    let isIconBadgeCustom = this.isContinueMerged(this.appInfo);
    log.showWarn(`ContinuableViewModel : onContinueDeviceChange ,${this.appInfo.bundleName} - ${isIconBadgeCustom} -${this.iconBadgeVm.isCustom}`);
    if (isIconBadgeCustom && !this.iconBadgeVm.isCustom) {
      animateTo({
        duration: 250,
        curve: curves.cubicBezierCurve(0.33, 0, 0.2, 1),
      }, () => {
        this.iconBadgeVm.animate = BadgeAnimationType.HIDE_WITHOUT_ANIM;
        this.iconBadgeVm.isCustom = isIconBadgeCustom;
      })
    }
    if (this.iconBadgeVm.isCustom && !isIconBadgeCustom && !this.isDrag) {
      log.showInfo(`ContinuableViewModel : deviceTypeIcon disappear `);
      this.iconBadgeVm.isCustom = isIconBadgeCustom;
      this.iconBadgeVm.animate = BadgeAnimationType.DEFAULT;
    }
  }

  private isContinueMerged(appInfo: DockItemInfo): boolean {
    return this.deviceInfo && this.deviceInfo.bundleName === appInfo.bundleName && appInfo.appIndex === 0 &&
      appInfo.typeId === CommonConstants.TYPE_APP;
  }

  /**
   * 应用回桌面dock时，图标需要隐藏
   */
  private dockItemOpacityAnimation(): void {
    if (this.companionIconInfo === null) {
      this.animationVm.alpha = 1;
    } else if (this.appInfo.bundleName === this.companionIconInfo.bundleName) {
      const compainionIconKeyName = AppItemInfo.getKeyName(this.companionIconInfo);
      const appKeyName = AppItemInfo.getKeyName(this.appInfo);
      if (compainionIconKeyName === appKeyName) {
        this.alphaAnimate();
      }
    }
  }

  private alphaAnimate(): void {
    animateTo({
      duration: ICON_ALPHA_ANIM_DURATION,
      curve: curves.springMotion(0.1, 1),
    }, () => {
      this.animationVm.alpha = 0;
    })
  }

  /**
   * 拖拽落位过程中显隐角标
   */
  private onEqualToDropItemChange(): void {
    log.showInfo(`onEqualToDropItemChange, isInDrag: ${this.isInDrag}`);
    if (this.isContinueMerged(this.appInfo)) {
      this.continueBadgeVisible = !this.isInDrag;
    }
    if (this.isInDrag) {
      this.badgeAnimate = BadgeAnimationType.DEFAULT;
    } else {
      this.badgeAnimate = BadgeAnimationType.DRAG_DROP;
    }
  }

  private dockMenuChangeEvent(bundleName: string): void {
    if (this.appInfo.bundleName === bundleName) {
      log.showInfo(`dockMenuChangeEvent buneldName: ${bundleName}`);
      try {
        this.menuInfo = this.buildMenu?.(this.appInfo);
        log.showInfo(`dockMenuChangeEvent: length: ${this.menuInfo.length}`);
      } catch (e) {
        log.showError('execute dockMenuChangeEvent is error, error message:' + e.message);
      }
    }
  }

  private onAppStatusChange(): void {
    log.showInfo(`onAppStatusChange change ${this.itemAppStatus}`);
    if (this.itemAppStatus !== AppStatus.INSTALLED && !this.isMenuShow) {
      this.menuInfo = this.notInstalledMenuMap.get(this.itemAppStatus) ?? [];
    } else if (this.itemAppStatus === AppStatus.INSTALLED && !this.isMenuShow) {
      if (this.buildMenu) {
        this.menuInfo = this.buildMenu();
      }
    }
  }

  /**
   * 拖动app到app触发动效：APP背板放大 || 缩小
   *
   * @param isAppBackplaneOpen app背板是否放大
   */
  private showAppBackplaneAnimate(isAppBackplaneOpen: boolean): void {
    if (isAppBackplaneOpen) {
      log.showInfo('showAppBackplaneAnimate start');
      this.isAppBackplaneAppear = true;
      this.isInAppBackplaneSmallAnimation = false;
      animateTo({
        curve: curves.springCurve(1.5, 1.5, 230, 25),
      }, () => {
        this.isInAppBackplaneBigAnimation = true;
        this.appBubbleBackplaneRatio = 1.15;
      })
    } else {
      log.showInfo('showAppBackplaneAnimate end');
      this.isAppBackplaneAppear = true;
      this.isInAppBackplaneBigAnimation = false;
      animateTo({
        curve: curves.springCurve(1.5, 1.5, 230, 25),
        onFinish: ()=> {
          this.isInAppBackplaneSmallAnimation = false;
          if (!this.isInAppBackplaneBigAnimation && !this.isInAppBackplaneSmallAnimation) {
            this.isAppBackplaneAppear = false;
          }
        }
      }, () => {
        this.isInAppBackplaneSmallAnimation = true;
        this.appBubbleBackplaneRatio = 1;
      })
    }
  }

  private onEventhubCoveredItemEvent(isShow: boolean): void {
    log.showInfo(`onEventhubCoveredItemEvent item:${this.appInfo.keyName}, isShow:${isShow}`);
    this.showAppBackplaneAnimate(isShow);
  }

  private onEventhubCancelItemEvent(isCancel: boolean): void {
    log.showInfo(`onEventhubCancelItemEvent item:${this.appInfo.keyName}, isCancel:${isCancel}`);
    this.animationVm.scaleSize = 0;
    this.showAppFromDialog(isCancel);
  }

  private getAppItemAccessibilityLevel(item: DockItemInfo) {
    if (this.isAccessibilityMode) {
      return GridLayoutUtil.isSmallFolder(item) ? 'no' : 'yes';
    }
    return 'auto';
  }

  private async updateAppNameFromCache(): Promise<void> {
    const item: DockItemInfo = this.appInfo;
    let cacheAppName = await ResourceManager.getInstance().getAppNameSync(item.appLabelId, item.bundleName,
      item.moduleName, item.appName);
    log.showInfo(`updateAppNameFromCache, appName: ${cacheAppName}, bundleName: ${item.bundleName}}`);
    this.appName = cacheAppName;
  }

  private showAppFromDialog(isCancel: boolean): void {
    if (isCancel) {
      animateTo({
        curve: curves.springMotion(0.468, 0.63),
        onFinish: ()=> {
          this.isShowingUninstallDialog = UninstallDialogStatus.INITIAL_STATE;
          this.dragToUninstallItemInfo = new DockItemInfo();
        }
      }, ()=> {
        this.animationVm.scaleSize = 1;
      })
    }
  }

  private dockAppIconOpacity: Function = (opacityScale: number): void => {
    this.animationVm.alpha = opacityScale;
  };

  /* 提供在非拖拽场景的index/column索引接口 */
  private getIndex(): number {
    return this.appList.findIndex((item) => {
      if (item.itemType === CommonConstants.TYPE_APP) {
        return item.keyName === this.appInfo.keyName;
      }
      if (item.itemType === CommonConstants.TYPE_FOLDER) {
        return item.keyName === this.appInfo.keyName;
      }
      return false;
    })
  }

  private updatePosition(): void {
    if (this.gravity) {
      const index = this.getIndex();
      const pos: number[] = SmartDockDragHandler.getInstance(this.singleContext).getDockItemPosition(index);
      log.showInfo('update dock-item gravity animation with type: %{public}d, id: %{public}s, page: %{public}d, ' +
        'index: %{public}d, size %{public}d * %{public}d, x: %{public}d, y: %{public}d',
        this.appInfo.typeId, this.itemKey, -1, index,
        1, 1, pos[0], pos[1]);

      this.gravity.setLayoutInfo(GravityAnimationPage.FOREVER_TRIGGER, 1, index, 1, 1);
      this.gravity.setPosition(pos[0], pos[1]);
    }
  }

  private startGravityRestoreAnimation(param: GravityAnimationParameter): void {
    log.showInfo('start to restore dock-item gravity animation on %{public}s, duration %{public}d',
      this.appInfo.bundleName, param.waveDuration);

    const id = 'DockItemGravityAnimationBack.' + this.appInfo.bundleName + '.' + this.appInfo.keyName;
    TraceUtil.startTraceWithTaskId(DomainName.HOME, id, 1);
    animateTo({
      curve: param.waveCurve,
      duration: param.waveDuration,
      onFinish: () => {
        TraceUtil.endTraceWithTaskId(DomainName.HOME, id, 1);
        gravityAnimationManager.markFinish(param);
      }
    }, () => {
      this.animationVm.translateX = 0;
      this.animationVm.translateY = 0;
    })
  }

  private startGravityAnimation(param: GravityAnimationParameter): void {
    log.showInfo('start dock-item gravity animation on %{public}s, delay %{public}d, duration %{public}d, ' +
      'from [%{public}d, %{public}d] -> [%{public}d, %{public}d]', this.appInfo.bundleName, param.delay,
      param.waveDuration, param.now.x, param.now.y, param.waveCrest.x, param.waveCrest.y);
    const id = 'DockItemGravityAnimation.' + this.appInfo.bundleName + '.' + this.appInfo.keyName;
    TraceUtil.startTraceWithTaskId(DomainName.HOME, id, 1);
    animateTo({
      curve: param.waveCurve,
      delay: param.delay * 1000,
      duration: param.waveDuration,
      onFinish: () => {
        this.startGravityRestoreAnimation(param);
        TraceUtil.endTraceWithTaskId(DomainName.HOME, id, 1);
      }
    }, () => {
      this.animationVm.translateX = param.waveCrest.x - param.now.x;
      this.animationVm.translateY = param.waveCrest.y - param.now.y;
    });
  }

  private updateCurrentData(folder: GridLayoutItemInfo): void {
    log.showInfo('resident folder updateCurrentData');
    if (!folder || folder.layoutInfo == null) {
      return;
    }
    this.mFolderItemInfo.layoutInfo = folder.layoutInfo;
  }

  private registerGravityAnimation(): void {
    /*
     * 应用内dock不注册引力动效：
     * 1. 本身应用内dock没有受引力动效的场景
     * 2. 如果要注册，这里不能用FOREVER_TRIGGER，否则会导致桌面dock的item被刷掉
     */
    if (this.appInfo.column !== undefined) {
      const index = this.getIndex();
      const pos: number[] = SmartDockDragHandler.getInstance(this.singleContext).getDockItemPosition(index);
      log.showInfo('create dock-item gravity animation with type: %{public}d, id: %{public}d, page: %{public}d, ' +
        'row: %{public}d, column: %{public}d, size %{public}d * %{public}d, x: %{public}d, y: %{public}d',
        this.appInfo.typeId, this.itemKey, -1, 1, index,
        this.appInfo.area?.[0], this.appInfo.area?.[1], pos[0], pos[1]);
      // 注册precallback： 解决: 1. dock 初始化时XY不正确；2. 拖拽到dock场景
      this.gravity = new GravityAnimationComponent(
        (param: GravityAnimationParameter) => { this.startGravityAnimation(param); },
        () => { this.updatePosition(); });
      this.gravity.setLayoutInfo(GravityAnimationPage.FOREVER_TRIGGER, 1, index, 1, 1);
      this.gravity.setPosition(pos[0], pos[1]);
      this.gravity.setActive(!this.isInDrag);
      gravityAnimationManager.addComponent(this.gravity);
    }
  }

  private unregisterGravityAnimation(): void {
    if (this.gravity) {
      gravityAnimationManager.removeComponent(this.gravity);
      this.gravity = null;
    }
  }

  folderLayoutChangeListener: FolderLayoutChangeListener = {
    rename: (name: string) => {
      log.showInfo('rename to: ' + name + ', old name: ' + this.mFolderItemInfo.folderName);
      this.mFolderItemInfo.folderName = name;
    }
  };

  private initContinueBadgeStatus(): void {
    if (this.isContinueMerged(this.appInfo)) {
      log.showInfo(`Continuable item appear, ${this.appInfo.bundleName}`);
      this.iconBadgeVm.isCustom = true;
    }
  }

  aboutToAppear(): void {
    let styleConfig = this.mPageDesktopViewModel.getPageDesktopStyleConfig();
    let folderStyleConfig = FolderStyleManager.getInstance().getFolderStyleConfig();
    this.mAppNameHeight = styleConfig.mNameHeight as number;
    this.mAppNameWidth = styleConfig.mNameWidth as number;
    this.mAppNameSize = styleConfig.mNameSize as number;
    this.bigGridGap = folderStyleConfig.mFolderGridGap ?? 0;
    this.bigGridMargin = folderStyleConfig.mGridMargin ?? 0;
    this.bigIconNameMargin = folderStyleConfig.mIconNameMargin ?? 0;
    this.bigIconNameMarginTop = folderStyleConfig.mIconNameMargin ?? 0;
    this.mItemPadding = styleConfig.mItemPadding as number;
    this.mGridWidth = styleConfig.mGridWidth;
    this.mGridSize = folderStyleConfig.mGridSize;
    this.mFolderAppSize = folderStyleConfig.mFolderAppSize;
    this.mFolderRadius = folderStyleConfig.mFolderRadius as number;
    this.mClosedFolderIconRadius = folderStyleConfig.mClosedFolderIconRadius ?? 0;
    this.mIconSize = DockRegionLayoutModel.getInstance().getIconSize();
    this.iconBadgeVm.ratio = DockRegionLayoutModel.getInstance().getScale();
    if (GridLayoutUtil.isAppInstalled(this.appInfo)) {
      this.menuInfo = this.buildMenu?.(this.appInfo);
      log.showInfo(`aboutToAppear: length: ${this.menuInfo.length}`);
    } else {
      this.menuInfo = this.notInstalledMenuMap.get(this.appInfo.appStatus as AppStatus) ?? [];
      let downloadInfo: DownloadStatusInfo | undefined =
        AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo(this.appInfo.bundleName);
      this.itemAppStatus = (downloadInfo ? downloadInfo.status : this.appInfo.appStatus) as AppStatus;
    }
    this.getSmallFolderItem();
    if (this.appInfo.itemType === CommonConstants.TYPE_FOLDER) {
      FolderDataModelManager.getInstance().updateFolderDataModel(this.mFolderItemInfo);
      this.mFolderViewModel.registerFolderLayoutChangeListener(this.mFolderItemInfo, this.folderLayoutChangeListener);
    }
    log.showDebug(`aboutToAppear: appInfo: ${JSON.stringify(this.appInfo)}`);

    if (!GridLayoutUtil.isAppInstalled(this.appInfo)) {
      if (this.appInfo.bundleName) {
        this.appGalleryStatusChangeEventId = `appGalleryStatusChange${this.appInfo.bundleName}${this.appInfo.appIndex}item`;
        this.desktopContext?.eventHub.off(this.appGalleryStatusChangeEventId);
        this.desktopContext?.eventHub.on(this.appGalleryStatusChangeEventId,
          (eventInfo: AppGalleryEventInfo): void => this.appGalleryStatusChangeEvent(eventInfo));
        log.showInfo(`onEventhubAppDownloadStatusChangedEvent for AppName ${this.appGalleryStatusChangeEventId}`);
      }
    }
    viewMgrPolicy.registerViewCallback(ViewType.KEYGUARD, this.keyguardCallback);
    this.updateAppNameFromCache();
    // fold screen animation
    this.foldController = {
      itemId: `${TAG}_dock`,
      onFoldAnimation: () => this.foldedAnimation(),
    };
    this.expandController = {
      itemId: `${TAG}_dock`,
      onExpandAnimation: () => this.expandedAnimation(),
    };
    SCBTransitionManager.getInstance().registerFoldAnimationController(this.foldController);
    SCBTransitionManager.getInstance().registerExpandAnimationController(this.expandController);
    this.registerEventhub();
    this.registerDragEvent();
    this.initDragParam();
    this.initRecentTaskImage();
    this.initAppIconConfig();
    this.initContinueBadgeStatus();
    this.registerGravityAnimation();
    let iconOpacity: string = `Opacity_${DockUtils.getDockItemId(this.appInfo)}.${this.appInfo.abilityName}.` +
      `${this.appInfo.moduleName}.${this.appInfo.typeId}`;
    this.desktopContext?.eventHub.on(iconOpacity, this.dockAppIconOpacity);
    if (SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType === SCBConstants.UITYPE_PAD) {
      this.desktopContext?.eventHub.on(SmartDockConstants.DOCK_MENU_CHANGE_EVENT, this.onDockMenuChangeEvent);
    }
    this.animationVm.translateX =
      SmartDockDragHandler.getInstance(this.singleContext).getDockItemTranslate(this.appInfo.keyName ?? '');
    if (this.appInfo.itemType !== CommonConstants.TYPE_FOLDER) {
      this.popupMgr.registerPopupController(this.appInfo, this.popupController);
    }
  }

  private initDragParam() {
    const dragItemInfo: GridLayoutItemInfo = AppStorage.get<GridLayoutItemInfo>('dragItemInfo') as GridLayoutItemInfo;
    const isInDropAnimation = dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP, this.itemKey);
    this.isDragStart = GridLayoutUtil.generateUniqueKey(dragItemInfo) === this.itemKey && !isInDropAnimation;
    this.isInDrag = this.isDragStart || isInDropAnimation;
    log.showInfo(`initDragParam key:${this.itemKey} isDragStart:${this.isDragStart} isInDrag:${this.isInDrag}`);
  }

  private registerDragEvent() {
    if (this.appInfo.typeId === CommonConstants.TYPE_FOLDER) {
      this.itemKey = GridLayoutUtil.generateUniqueKey(this.mFolderItemInfo);
    } else {
      this.itemKey = GridLayoutUtil.generateUniqueKey(this.appInfo as Object as GridLayoutItemInfo);
    }
    this.dragEventCallback = {
      onItemDragStartEvent: (): void => {
        log.showInfo('onItemDragStartEvent, itemKey = %{public}s', this.itemKey);
        this.isInDrag = true;
        this.isDragStart = true;
        /* 拖拽时使自身不可参与引力动效 */
        this.gravity?.setActive(false);
      },
      onItemDropStartEvent: (): void => {
        log.showInfo('onItemDropStartEvent, itemKey = %{public}s', this.itemKey);
        this.isDragStart = false;
      },
      onItemDropEndEvent: (): void => {
        log.showInfo('onItemDropEndEvent, itemKey = %{public}s', this.itemKey);
        this.isInDrag = false;
        this.gravity?.setActive(true);
        dragSnapshotHelper.releaseSnapshot(SnapshotType.BOTH, this.itemKey);
      }
    };
    DragEventManager.getInstance().registerDragEvent(this.dragEventCallback, this.itemKey);
  }

  private unregisterDragEvent() {
    DragEventManager.getInstance().unRegisterDragEvent(this.dragEventCallback, this.itemKey);
  }

  private registerEventhub(): void {
    if (CheckEmptyUtils.isEmpty(this.appInfo.keyName)) {
      log.showWarn('registerEventhub interrupt with invalid keyName');
    }

    let coveredItemEventId: string = `coveredApp${this.appInfo.keyName}`;
    this.desktopContext?.eventHub.on(coveredItemEventId, this.coveredItemEvent);

    let cancelItemEventId: string = `cancelUninstall${this.appInfo.keyName}`;
    this.desktopContext?.eventHub.on(cancelItemEventId, this.cancelItemEvent);

    let startSqueezeEventId: string = `${SmartDockConstants.DOCK_ITEM_SQUEEZE_START}${this.appInfo.keyName}`;
    this.desktopContext?.eventHub.on(startSqueezeEventId, this.startSqueezeEvent);

    this.desktopContext?.eventHub.on(CommonConstants.DOCK_ITEM_SQUEEZE_CANCEL, this.cancelSqueezeEvent);
    log.showInfo('registerEventhub finish, keyName: %{public}s', this.appInfo.keyName);
    this.desktopContext?.eventHub.on(CommonConstants.DOCK_ICON_REDUCTION, this.iconReductionEvent);
    this.desktopContext?.eventHub.on(SmartDockConstants.DOCK_ZOOM_EVENT, this.onScaleChangeEvent);
  }

  private unregisterEventhub(): void {
    if (CheckEmptyUtils.isEmpty(this.appInfo.keyName)) {
      log.showWarn('unregisterEventhub interrupt with invalid keyName');
    }

    let coveredItemEventId: string = `coveredApp${this.appInfo.keyName}`;
    this.desktopContext?.eventHub.off(coveredItemEventId, this.coveredItemEvent);

    let cancelItemEventId: string = `cancelUninstall${this.appInfo.keyName}`;
    this.desktopContext?.eventHub.off(cancelItemEventId, this.cancelItemEvent);

    let startSqueezeEventId: string = `${SmartDockConstants.DOCK_ITEM_SQUEEZE_START}${this.appInfo.keyName}`;
    this.desktopContext?.eventHub.off(startSqueezeEventId, this.startSqueezeEvent);

    this.desktopContext?.eventHub.off(CommonConstants.DOCK_ITEM_SQUEEZE_CANCEL, this.cancelSqueezeEvent);
    log.showInfo('unregisterEventhub finish, keyName: %{public}s', this.appInfo.keyName);
    this.desktopContext?.eventHub.off(CommonConstants.DOCK_ICON_REDUCTION, this.iconReductionEvent);
    this.desktopContext?.eventHub.off(SmartDockConstants.DOCK_ZOOM_EVENT, this.onScaleChangeEvent);
  }

  // fold screen animation
  private foldedAnimation(): void {
    log.showInfo('dock execute foldedAnimation');
    this.animationVm.translateX = FoldAnimationConstants.FOLD_FACTOR * this.screenWidth;
    this.animationVm.alpha = 0;
    let itemColumn: number = 0;
    if (this.appInfo.column) {
      itemColumn = this.appInfo.column;
    }
    let dockDelay: number = (this.getTotalColumns() - 1 - itemColumn) * FoldAnimationConstants.FOLD_DELAY /
      (this.getTotalColumns() - 1);
    animateTo({
      curve: FoldAnimationConstants.TRANSLATE_CURVES,
      delay: dockDelay,
    }, () => {
      this.animationVm.translateX = 0;
    })
    animateTo({
      curve: FoldAnimationConstants.ALPHA_CURVES,
      delay: dockDelay,
    }, () => {
      this.animationVm.alpha = 1;
    })
  }

  private expandedAnimation(): void {
    log.showInfo('dock execute expandedAnimation');
    this.animationVm.translateX = FoldAnimationConstants.EXPAND_FACTOR * this.screenWidth;
    this.animationVm.alpha = 0;
    let rectInfo: RectInfo = ItemUtils.getRectById(DockUtils.getDockItemId(this.appInfo));
    let dockDelay = (this.screenWidth - rectInfo.right + (rectInfo.right - rectInfo.left) / 2) / this.screenWidth *
    FoldAnimationConstants.EXPAND_DELAY
    animateTo({
      curve: FoldAnimationConstants.TRANSLATE_CURVES,
      delay: dockDelay,
    }, () => {
      this.animationVm.translateX = 0;
    })
    animateTo({
      curve: FoldAnimationConstants.ALPHA_CURVES,
      delay: dockDelay,
    }, () => {
      this.animationVm.alpha = 1;
    })
  }

  private getTotalColumns(): number {
    const result = LayoutViewModel.getInstance(this.singleContext).calculateDesktop();
    return (result.mColumns === undefined) ? 4 : result.mColumns
  }

  private appGalleryStatusChangeEvent(eventInfo: AppGalleryEventInfo): void {
    switch (eventInfo.eventType) {
      case DownloadStatusChangeEvent.DOWNLOAD_STATUS_CHANGE:
      case InstallStatusChangeEvent.INSTALL_STATUS_CHANGE:
        let appStatus: AppStatus = eventInfo.status as AppStatus;
        this.itemAppStatus = appStatus;
        break;
      case DownloadingProgressChangeEvent.DOWNLOAD_PROGRESS_CHANGE:
        break;
      default:
        break;
    }
  }

  private keyguardCallback: ViewCallback = {
    onHide: (): void => this.onScreenOn(),
    onShow: (): void => this.onScreenOff()
  };

  private getSmallFolderItem(): void {
    if (this.appInfo.itemType === CommonConstants.TYPE_FOLDER) {
      this.mFolderItemInfo = new GridLayoutItemInfo();
      this.mFolderItemInfo.itemType = CommonConstants.TYPE_FOLDER;
      this.mFolderItemInfo.typeId = CommonConstants.TYPE_FOLDER;
      this.mFolderItemInfo.folderId = this.appInfo.keyName;
      this.mFolderItemInfo.bundleName = this.appInfo.bundleName;
      this.mFolderItemInfo.moduleName = this.appInfo.moduleName;
      this.mFolderItemInfo.abilityName = this.appInfo.abilityName;
      this.mFolderItemInfo.appIconId = this.appInfo.appIconId;
      this.mFolderItemInfo.appLabelId = this.appInfo.appLabelId;
      this.mFolderItemInfo.applicationLabelId = this.appInfo.applicationLabelId;
      this.mFolderItemInfo.appName = this.appInfo.appName;
      this.mFolderItemInfo.folderName = this.appInfo.appName;
      this.mFolderItemInfo.areaType = this.appInfo.areaType;
      this.mFolderItemInfo.keyName = this.appInfo.keyName;
      this.mFolderItemInfo.layoutInfo = this.appInfo.layoutInfo;
      this.mFolderItemInfo.container = CommonConstants.CONTAINER_SMARTDOCK;
      this.mFolderItemInfo.hasContainerBackplane = this.isBackplaneExist;
      this.mFolderItemInfo.area = [1, 1];
      this.mFolderItemInfo.row = this.appInfo.row;
      this.mFolderItemInfo.column = this.appInfo.column;
      this.mFolderItemInfo.badgeNumber = this.appInfo.badgeNumber;
      this.mFolderItemInfo.isInDock = true;
      this.mFolderItemInfo.dockRegion = this.region;
      this.mFolderItemInfo.id = this.appInfo.id;
      log.showInfo(`the mFolderItemInfo is ${this.mFolderItemInfo.layoutInfo?.flat().length}`);
    }
  }

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

  aboutToDisappear(): void {
    viewMgrPolicy.unRegisterViewCallback(ViewType.KEYGUARD, this.keyguardCallback);
    SCBTransitionManager.getInstance().unRegisterFoldAnimationController(this.foldController);
    SCBTransitionManager.getInstance().unRegisterExpandAnimationController(this.expandController);
    this.unregisterDragEvent();
    this.unregisterGravityAnimation();
    this.unregisterEventhub();
    let iconOpacity: string = `Opacity_${DockUtils.getDockItemId(this.appInfo)}.${this.appInfo.abilityName}.` +
      `${this.appInfo.moduleName}.${this.appInfo.typeId}`;
    this.desktopContext?.eventHub.off(iconOpacity, this.dockAppIconOpacity);
    if (SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType === SCBConstants.UITYPE_PAD) {
      this.desktopContext?.eventHub.off(SmartDockConstants.DOCK_MENU_CHANGE_EVENT, this.onDockMenuChangeEvent);
    }
    if (!CheckEmptyUtils.isEmpty(this.appGalleryStatusChangeEventId)) {
      this.desktopContext?.eventHub.off(this.appGalleryStatusChangeEventId);
    }
    if (this.appInfo.itemType === CommonConstants.TYPE_FOLDER) {
      this.mFolderViewModel.unregisterFolderLayoutChangeListener(this.mFolderItemInfo, this.folderLayoutChangeListener);
    } else {
      this.popupMgr.unRegisterPopupController(this.appInfo, this.popupController);
    }
  }

  private onLockReceived() {
    if (!this.isLockReceived) {
      return;
    }
    let isBaseDeskPage: boolean = PageDesktopOneShotManager.getInstance().getIsBaseDeskPage();
    if (!DesktopUtils.isSupportLockAnimation()) {
      return;
    }
    log.showInfo(`pcmode onLock ${this.appInfo.bundleName}`);
    if (!isBaseDeskPage) {
      return;
    }
    this.onLockWithSpaceAnimation();
  }

  private onLockWithSpaceAnimation() {
    log.showDebug(`onLockReceived, isLockReceived: ${this.isLockReceived}`);
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
      () => {
        this.isUnLocking = false;
        let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
        if (residentList.length <= 0) {
          return;
        }
        if (residentList[residentList.length - 1]?.keyName === this.appInfo.keyName) {
          HiDfxEventUtil.reportUnlockToDesktop(HiDfxEventUtil.UNLOCK_TO_DOCK_ANIMATION_END,
            CommonConstants.INVALID_VALUE);
        }
      });
  }

  private dockItemMoveAnimationFunc(newCenterX: number, immediate: boolean): void {
    const oldIndex: number = this.appList.findIndex((item: DockItemInfo) => item.keyName === this.appInfo.keyName);
    if (SmartDockZoomManager.isZoom()) {
      const offsetForScaleChange: number = this.layoutPropertyVm.listPadding *
        (this.layoutPropertyVm.scale -
        DockRegionLayoutModel.getInstance().calculateScaleWithRegionNum(this.appList.length)) /
      this.layoutPropertyVm.scale;
      this.animationEvent.moveAnimation(newCenterX + offsetForScaleChange, immediate, this.appInfo.keyName ?? '',
        this.appList.length, oldIndex);
      return;
    }
    this.animationEvent.moveAnimation(newCenterX, immediate, this.appInfo.keyName ?? '', this.appList.length, oldIndex);
  }

  private getLongPress(): boolean {
    return AppStorage.get<boolean>('isLongPress') as boolean;
  }

  private getMenuInfoList(): MenuInfo[] {
    if (this.isPcMode) {
      let menu: MenuInfo[] = [];
      const missionInfoList = AppStorage.get('missionInfoList') as Array<RecentBundleMissionInfo>;
      const item = missionInfoList.find(item => item.bundleName === this.appInfo.bundleName);
      let queryKey = this.appInfo.bundleName + this.appInfo.moduleName + this.appInfo.abilityName;
      const launchType = SCBSceneSessionManager.getInstance().getAbilityLaunchType(queryKey);
      this.menuInfo.forEach((item) => {
        menu.push(item);
      })
      if (!CheckEmptyUtils.isEmpty(item)) {
        if (PcModeDockUtils.isSupportOpenMultiWindow(launchType, this.appInfo)) {
          menu.push(SmartDockViewModel.getInstance(this.singleContext).getOpenNewWindowMenu(this.appInfo));
        }
        if (!(this.appInfo?.bundleName === 'cn.wps.office.hap' && this.appInfo?.abilityName === 'PromeAbility')) {
          menu.push(SmartDockViewModel.getInstance(this.singleContext).getExitMenu(this.appInfo));
        }
      } else {
        menu.push(SmartDockViewModel.getInstance(this.singleContext).getOpenMenu(this.appInfo));
      }
      return menu;
    } else {
      return this.menuInfo;
    }
  }

  private initMenuInfo(isUpdateImmediately: boolean = true): void {
    if (GridLayoutUtil.isAppInstalled(this.appInfo)) {
      this.menuInfo = this.buildMenu?.(this.appInfo);
      if (isUpdateImmediately) {
        this.iconMenuVm.setMenuInfo(this.getMenuInfoList());
      }
    } else {
      this.menuInfo = this.notInstalledMenuMap.get(this.appInfo.appStatus as AppStatus) ?? [];
    }
  }

  private setMenuShowStatus(isShow: boolean): void {
    this.isMenuShow = isShow;
    this.isDockMenuShow = isShow;
    if (isShow) {
      AppStorage.setOrCreate('isDockMissionsPopupShow', false);
    }
  }

  @Builder MenuBuilder() {
    AppMenu({
      menuInfoList: this.getMenuInfoList(),
      closeMenu: () => {
        this.isShow = false;
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
        this.desktopContext?.eventHub.emit('NAVIBarShow', true);
        HiSysEventUtil.reportGoIntoAppShortcutMenu(this.appInfo.bundleName, this.appInfo.appName, 'LAUNCHER');
      })
      .onDisAppear(() => {
        log.showInfo('dockMenu onDisAppear');
        this.setMenuShowStatus(false);
        this.desktopContext?.eventHub.emit('NAVIBarShow', false);
        localEventManager.sendLocalEvent(EventConstants.EVENT_RESET_HIDE_DOCK_AFTER_POPUP_STATE_CALLBACK);
        AppStorage.setOrCreate<string>('notifyEnterFormManagerAnimate', String(this.appInfo.appIconId));
      })
  }

  @Builder IconBuilder(resource: string | PixelMap) {
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
      .visibility(this.isGrayIcon ? Visibility.Visible : Visibility.Hidden)
      .borderRadius(CommonConstants.DEFAULT_ICON_RADIUS)
  }

  private isSyncLoad(resource: string | PixelMap): boolean {
    return (typeof resource !== 'string') || GridLayoutUtil.isImageSyncLoad(resource);
  }

  public updateIconImage(): string | PixelMap {
    if (this.appInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      return ResourceManager.getInstance().getCachedAppIcon(this.appInfo.appIconId,
        this.appInfo.bundleName as string, this.appInfo.moduleName as string);
    } else {
      return IconResourceManager.getInstance().getCachedCombIconSync(this.appInfo.bundleName,
        this.appInfo.moduleName as string, this.appInfo.abilityName);
    }
  }

  @Builder AppPixmapCreator() {
    Stack() {
      if (this.itemAppStatus !== AppStatus.INSTALLED) {
        if (this.appInfo.iconResource) {
          this.IconBuilder(this.appInfo.iconResource);
        }
      } else if (this.appInfo?.abilityName !== CommonConstants.RECENT_ABILITY) {
        this.IconBuilder(this.updateIconImage());
      }
    }
  }

  @Builder FolderPixmapCreator(cachedIcon: string) {
    this.IconBuilder(cachedIcon);
  }

  private isPcOrPadLauncher() {
    return SettingsModel.getInstance().getDevice() !== CommonConstants.DEFAULT_DEVICE_TYPE &&
      this.appInfo.bundleName === CommonConstants.LAUNCHER_BUNDLE;
  }

  private getAppIcon() {
    if (this.isPcOrPadLauncher() && this.appInfo.abilityName === CommonConstants.APPCENTER_ABILITY) {
      return StyleConstants.DEFAULT_ALL_APP_IMAGE;
    } else if (this.isPcOrPadLauncher() && this.appInfo.abilityName === CommonConstants.RECENT_ABILITY) {
      return StyleConstants.DEFAULT_TASK_IMAGE;
    } else {
      return ResourceManager.getInstance().getCachedAppIcon(this.appInfo.appIconId,
        this.appInfo.bundleName as string, this.appInfo.moduleName as string);
    }
  }

  private onDockListChange(): void {
    const folderMgr: FolderManager = FolderManager.getInstance();
    const isFolderOpen: boolean = folderMgr.isFolderOpen();
    this.appList.forEach((info: DockItemInfo, index: number) => {
      if (info.itemType === CommonConstants.TYPE_FOLDER && info.keyName === this.appInfo.keyName) {
        info.column = index;
        this.appInfo = info;
        this.getSmallFolderItem();
        log.showInfo(`onDockListChange  ${this.mFolderItemInfo.layoutInfo?.flat().length}`);
      }
    });
  }

  dragStart(event?: DragEvent): DragItemInfo {
    this.setMenuShowStatus(false);
    AppStorage.setOrCreate('isDrag', true);
    this.dragItemType = CommonConstants.DRAG_FROM_DOCK;
    this.appInfo.area = [1, 1];
    if (this.appInfo.typeId === CommonConstants.TYPE_FOLDER) {
      SettingsModel.getInstance().getResidentList().forEach((dockItem: DockItemInfo) => {
        if (dockItem?.keyName === this.mFolderItemInfo?.keyName && dockItem.typeId === CommonConstants.TYPE_FOLDER) {
          log.showInfo('dragStart update folder name, before: ' + this.mFolderItemInfo.appName + ', after: ' + dockItem.appName);
          this.mFolderItemInfo.appName = dockItem.appName;
          this.mFolderItemInfo.folderName = dockItem.appName;
        }
      })
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, this.itemKey)
      ?.setWidth(this.mIconSize)
        .setHeight(this.mIconSize)
        .setRadius(this.mSmallFolderRadius)
        .setUseEffect(!SCBVisualEffectMgr.isFolderSolidColor());
      AppStorage.setOrCreate<GridLayoutItemInfo>('dragItemInfo', this.mFolderItemInfo);
    } else {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, this.itemKey)
      ?.setWidth(this.mIconSize)
        .setHeight(this.mIconSize)
        .setRadius(this.mSmartDockStyleConfig.mIconRadius);
      AppStorage.setOrCreate<DockItemInfo>('dragItemInfo', this.appInfo);
    }

    if (editModeManager.isInEditMode()) {
      this.dragToUninstallItemInfo = new DockItemInfo();
      ObjectCopyUtil.deepClone(this.appInfo, this.dragToUninstallItemInfo);
      this.isShowingUninstallDialog = UninstallDialogStatus.INITIAL_STATE;
    }
    log.showInfo('onDragStart typeId:%{public}d keyName:%{public}s row:%{public}d column:%{public}d',
      this.appInfo.typeId, this.appInfo.keyName, this.appInfo.row, this.appInfo.column);
    if (event) {
      const center: number[] = SmartDockDragHandler.getInstance(this.singleContext)
        .getDockItemPosition(this.getIndex());
      const startPosition : DragItemPosition = {
        page: desktopUtil.getPageIndexValue(),
        row: this.appInfo.row!,
        column: this.appInfo.column!,
        x: center[0],
        y: center[1],
        isInDock: true
      };
      AppStorage.setOrCreate<Object>('startPosition', startPosition);
      SmartDockDragHandler.getInstance(this.singleContext).onDragStart();
    } else {
      log.showWarn('dragStart: event is undefined');
    }
    DragEventManager.getInstance().dragStartInDesktop(this.itemKey);
    let dragItemInfo: DragItemInfo;
    let extraInfo: DragExtraInfo;
    if (this.appInfo.typeId === CommonConstants.TYPE_FOLDER && !SCBVisualEffectMgr.isFolderSolidColor()) {
      extraInfo = new DragExtraInfo(DragDataType.FOLDER)
        .setBlurStyle(BlurStyle.Thin)
        .setRadius(this.mSmallFolderRadius);
    } else {
      extraInfo = new DragExtraInfo(DragDataType.APP)
        .setRadius(CommonConstants.DEFAULT_ICON_RADIUS);
    }
    dragItemInfo = {
      extraInfo: extraInfo.toString(),
      pixelMap: dragSnapshotHelper.getSnapshot(SnapshotType.DRAG, this.itemKey),
    }
    return dragItemInfo;
  }

  /**
   * When rename is clicked, call this function to change folder state.
   */
  private renameClick() {
    log.showInfo('click menu folder rename');
    this.desktopContext?.eventHub.off(CommonConstants.EVENTHUB_FOLDER_MENU_DISAPPEAR);
    this.desktopContext?.eventHub.on(CommonConstants.EVENTHUB_FOLDER_MENU_DISAPPEAR, () => {
      this.desktopContext?.eventHub.off(CommonConstants.EVENTHUB_FOLDER_MENU_DISAPPEAR);
      AppStorage.setOrCreate('overlayMode', CommonConstants.OVERLAY_TYPE_HIDE);
      AppStorage.setOrCreate(CommonConstants.OPEN_SOURCES, true);
      AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_START);
      this.mFolderViewModel.openFolder(true, this.mFolderItemInfo, true);
      this.desktopContext?.eventHub.emit(CommonConstants.DESKTOP_INVISIBLE_STATE);
    })
  }

  private convertToBigFolder() {
    this.desktopContext?.eventHub.off(CommonConstants.EVENTHUB_FOLDER_MENU_DISAPPEAR);
    this.desktopContext?.eventHub.on(CommonConstants.EVENTHUB_FOLDER_MENU_DISAPPEAR, () => {
      this.desktopContext?.eventHub.off(CommonConstants.EVENTHUB_FOLDER_MENU_DISAPPEAR);
      this.isFromDock = true;
      this.isHideFolderOnConvert = false;

      let mTempFolderItemInfo = ObjectCopyUtil.deepClone(this.mFolderItemInfo);
      let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      let index: number = residentList.findIndex((item) => {
        return item.keyName === this.mFolderItemInfo.keyName;
      });
      let fallPosition: number[] = SmartDockDragHandler.getInstance(this.singleContext).getDockItemPosition(index);
      this.mFolderItemInfo.container = CommonConstants.CONTAINER_DESKTOP;
      this.mFolderItemInfo.isInDock = false;
      const folderInfo: GridLayoutItemInfo = JSON.parse(JSON.stringify(this.mFolderItemInfo));
      let isStartAnimate = this.mFolderViewModel.isConvertToBigFolder(folderInfo, true, mTempFolderItemInfo);
      if (!isStartAnimate) {
        this.mFolderItemInfo.container = CommonConstants.CONTAINER_SMARTDOCK;
        this.mFolderItemInfo.isInDock = true;
        return;
      }
      // 大文件位置，folderInfo.page在上边方法isConvertToBigFolder中更新为大文件夹落位页数
      const convertItemInfo = AppStorage.get<GridLayoutItemInfo>('convertItemInfo') as GridLayoutItemInfo;
      let bigRow = convertItemInfo.row;
      let bigColumn = convertItemInfo.column;
      let appBigElements = GridLayoutUtil.getIconCenterPosition(bigRow, bigColumn, [2, 2], folderInfo.page);
      this.toBigTranslateX = appBigElements[0] - fallPosition[0];
      this.toBigTranslateY = appBigElements[1] - fallPosition[1];
      // dock区文件夹FolderImage位置为当前位置，没有使用FolderChangeComponent
      // 桌面的文件夹FolderImage的位置为相对屏幕位置位置，使用了FolderChangeComponent
      this.startPositionX = 0;
      this.startPositionY = 0;
      this.startConvert = CommonConstants.START_CONVERT_ANIMATE;
      this.convertFolderId = convertItemInfo.folderId ?? CommonConstants.DEFAULT_ID;
    });
  }

  private isShowCancelDialog(): boolean {
    return (this.isShowingUninstallDialog === UninstallDialogStatus.CONFIRM_STATE ||
      this.isShowingUninstallDialog === UninstallDialogStatus.UNINSTALLING_STATE) &&
      this.dragToUninstallItemInfo?.keyName === this.appInfo.keyName &&
      this.dragToUninstallItemInfo?.typeId === CommonConstants.TYPE_APP;
  }

  private openFolderClickCallBack(event: ClickEvent, folderItem: GridLayoutItemInfo): void {
    log.showInfo(`onOpenSmallFolderClick folderName:${folderItem.folderName} folderId:${folderItem.folderId}`);
    AppStorage.setOrCreate(CommonConstants.OPEN_SOURCES, true);
    AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_START);
    // 关闭所有在前台的窗口
    AppStorage.setOrCreate('isFolderOpen', true);
    SmartDockEventMgr.getInstance(this.singleContext).closeFrontWindow();
    BigFolderViewModel.getInstance().openFolder(false, folderItem);
  }

  private closeFolder(): void {
    if (this.closeBigFolder) {
      SmartDockEventMgr.getInstance(this.singleContext).openFrontWindow();
    }
    AppStorage.setOrCreate('isFolderOpen', false);
    AppStorage.setOrCreate('closeBigFolder', false);
  }

  private onDockIconReduction(index: number): void {
    if (DeviceHelper.isPhone() && !GridLayoutUtil.isLargeFoldOrTrifoldExpanded()) {
      // 直板机暂无适配方案，后续补充
      return;
    }
    // dock应用消失或文件夹小转大后，列表数量已经变少了，但需要当前图标位置暂时不变，因此用当前应用数量+1的数字进行位置计算
    const length: number = this.appList.length + 1;
    let offset: number = 0;
    const currentIndex: number = this.getIndex()
    if (currentIndex >= index) {
      offset = 1;
    }
    let oldCenterX: number = SmartDockStyleMgr.getInstance().getDockItemCenter(length, currentIndex);
    let newCenterX: number = SmartDockStyleMgr.getInstance().getDockItemCenter(length, currentIndex + offset);
    let translateX: number = newCenterX - oldCenterX;
    if (SmartDockZoomFeatureSwitch.isSupportZoom()) {
      //嵌套if用于SmartDockZoomManager懒加载
      if (SmartDockZoomManager.isZoom()) {
        translateX = offset * (this.layoutPropertyVm.space + this.layoutPropertyVm.iconSize);
        // dock应用消失或文件夹小转大后，列表数量已经变少了，如果处于缩放状态，scale已经变化，需要做位置补偿
        // 位置补偿值为两种scale对两个应用间距的影响的差值，即一个图标长度加一个图标间隔的原始长度与两个scale的差值的乘积
        const offsetForScaleChange: number = (this.layoutPropertyVm.listPadding + this.layoutPropertyVm.iconSize) *
          (this.layoutPropertyVm.scale - DockRegionLayoutModel.getInstance().calculateScaleWithRegionNum(length)) /
        this.layoutPropertyVm.scale;
        log.showInfo(`onDockIconReduction oldCenterX:${oldCenterX} newCenterX:${newCenterX},length:${length} index:${index}`);
        if (Math.abs(translateX) > 1) {
          translateX -= offsetForScaleChange;
        }
      }
    }
    this.animationVm.translateX = translateX;
    this.animationEvent.residentItemMoveAnimation(0);
  }

  private dealDragStart: (event: DragEvent) => CustomBuilder | DragItemInfo = (event: DragEvent) => {
    return this.dragStart(event);
  }

  private dealDragEnd: (event: DragEvent) => void = (event: DragEvent) => {
    log.showInfo('onDragEnd event.x=%{public}d, event.y=%{public}d, event.result=%{public}d', event.getWindowX(),
      event.getWindowY(), event.getResult());
    if (!DragEventManager.getInstance().isDropInDesktop &&
      this.appInfo.abilityName !== CommonConstants.RECENT_ABILITY) {
      log.showInfo(`not dropInDesktop`);
      DragEventManager.getInstance().startDrop(this.itemKey);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_REFRESH, this.appInfo);
    }
    AppStorage.setOrCreate<boolean>('isDrag', false);
    AppStorage.setOrCreate<Object>('dragItemInfo', {});
  }

  @Styles
  itemGesture() {
    .onDragStart(this.dealDragStart)
    .onDragEnd(this.dealDragEnd)
    .visibility(this.animationVm.visible)
    .scale({ x: this.itemScale, y: this.itemScale })
    .parallelGesture(
      LongPressGesture({ repeat: false, duration : 250 })
        .onAction((event?: GestureEvent) => {
          log.showInfo('onAction start');
          this.isShow = true;
          AppStorage.setOrCreate('isLongPress', true);
          let rect: RectInfo = ItemUtils.getRectById(DockUtils.getDockItemId(this.appInfo));
          let appIconInfo: LongPressAppIconInfo = {
            badgeNumber : this.appInfo.badgeNumber as number,
            iconSize: this.mIconSize,
            iconId : this.appInfo.appIconId as number,
            bundleName: this.appInfo.bundleName as string,
            moduleName : this.appInfo.moduleName as string,
            icon : this.getAppIcon(),
            positionX : rect.left,
            positionY : rect.top,
            item : this.appInfo as DockItemInfo
          }
          AppStorage.setOrCreate('appIconInfo', appIconInfo);
        })
    )
    .onTouch((event?: TouchEvent) => {
      log.showInfo(`onTouch event type: ${event?.type}`);
      if (AppStorage.get<boolean>('isDrag')) {
        this.isShow = false;
      }
      if (event?.type === CommonConstants.TOUCH_TYPE_DOWN) {
        log.showInfo('onTouch down start');
        if (DeliverUtil.isSupportAppType(this.appInfo.bundleName) && DeliverUtil.isSupportDeliver()) {
          SCBSceneSessionManager.getInstance().preloadApp(this.appInfo.bundleName);
        }
        const isSmallFolder = this.appInfo.itemType === CommonConstants.TYPE_FOLDER;
        if (isSmallFolder) {
          let smallFolderCachedIcon = ResourceManager.getInstance().getCachedAppIcon(this.appInfo.keyName, '', '');
          if (smallFolderCachedIcon) {
            log.showInfo('start to get small folder snapshot');
            dragSnapshotHelper.snapshotFromBuilder((): void => this.FolderPixmapCreator(smallFolderCachedIcon),
              SnapshotType.DRAG, this.itemKey);
          }
        } else {
          this.isGrayIcon = GrayAppListManager.getInstance().isGrayAppIcon(this.appInfo);
          log.showInfo('start to get app snapshot. isGrayIcon:%{public}s', this.isGrayIcon);
          dragSnapshotHelper.snapshotFromBuilder((): void => this.AppPixmapCreator(), SnapshotType.BOTH,
            this.itemKey);
        }
      }
    })
    .onMouse((event?: MouseEvent) => {
      if (event?.button == MouseButton.Right) {
        log.showInfo('onMouse right click');
        if (event?.stopPropagation) {
          event?.stopPropagation();
        }
        AppStorage.setOrCreate('selectDesktopAppItem', '');
        this.isShow = true;
      }
    })
    .parallelGesture(
      LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_ZOOM_IN })
        .onAction((event?: GestureEvent) => {
          log.showInfo('longPressZoomIn start');
          this.desktopContext?.eventHub.emit(`${CommonConstants.EVENTHUB_APP_ICON_LONG_PRESS}${this.appInfo.keyName}`,
            new AppIconEventData({ bundleName: this.appInfo.bundleName as string, isLongPress: true, type: 'longPressZoomIn' }));
        })
    )
  }

  private handleHoverEvent(isHover: boolean): void {
    HoverAnimationUtil.hoverEffect(isHover, true, (hoverScale: number) => {
      this.itemScale = hoverScale;
    });
  }

  private execOnTouch(event?: TouchEvent): void {
    log.showDebug(`onTouch event type: ${event?.type}`);
    localEventManager.sendLocalEvent(EventConstants.EVENT_RESET_HIDE_DOCK_AFTER_POPUP_STATE_CALLBACK);
    if (AppStorage.get<boolean>('isDrag')) {
      this.isShow = false;
    }
    if (event?.type === CommonConstants.TOUCH_TYPE_DOWN) {
      log.showInfo('onTouch down start');
      if (DeliverUtil.isSupportAppType(this.appInfo.bundleName) && DeliverUtil.isSupportDeliver()) {
        SCBSceneSessionManager.getInstance().preloadApp(this.appInfo.bundleName);
      }
      const isSmallFolder = this.appInfo.itemType === CommonConstants.TYPE_FOLDER;
      if (isSmallFolder) {
        let smallFolderCachedIcon = ResourceManager.getInstance().getCachedAppIcon(this.appInfo.keyName, '', '');
        if (smallFolderCachedIcon) {
          log.showInfo('start to get small folder snapshot');
          dragSnapshotHelper.snapshotFromBuilder((): void => this.FolderPixmapCreator(smallFolderCachedIcon),
            SnapshotType.DRAG, this.itemKey);
        }
      } else {
        this.isGrayIcon = GrayAppListManager.getInstance().isGrayAppIcon(this.appInfo);
        log.showInfo('start to get app snapshot. isGrayIcon:%{public}s', this.isGrayIcon);
        dragSnapshotHelper.snapshotFromBuilder((): void => this.AppPixmapCreator(), SnapshotType.BOTH, this.itemKey);
      }
    } else if (event?.type === CommonConstants.TOUCH_TYPE_UP) {
      if (!editModeManager.isInEditMode()) {
        this.badgeAnimate = BadgeAnimationType.TOUCH_UP;
      }
    }
  }

  private execOnMouse(event?: MouseEvent): void {
    if (event?.button === MouseButton.Right) {
      if (event.action === MouseAction.Press) {
        // 适配菜单应用锁功能, 右键场景需要重新刷新
        this.initMenuInfo();
        this.setMenuShowStatus(false);
      }
      log.showInfo('onMouse right click');
      if (event?.stopPropagation) {
        event?.stopPropagation();
      }
      AppStorage.setOrCreate('selectDesktopAppItem', '');
      this.isShow = true;
    }
  }

  private getContextMenu(): ContextMenuOptions {
    return {
      offset: { x: NumberConstants.CONSTANT_NUMBER_ZERO, y: NumberConstants.CONSTANT_NUMBER_EIGHT },
      placement: Placement.TopLeft,
      backgroundBlurStyle: BlurStyle.NONE,
      preview: () => { this.AppPixmapCreator() },
      aboutToAppear: () => {
        log.showInfo('dockMenu aboutToAppear');
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

  private longPressIconInfo(): void {
    log.showInfo('onAction start');
    this.isShow = true;
    AppStorage.setOrCreate('isLongPress', true);
    let rect: RectInfo = ItemUtils.getRectById(DockUtils.getDockItemId(this.appInfo));
    let appIconInfo: LongPressAppIconInfo = {
      badgeNumber : this.appInfo.badgeNumber as number,
      iconSize: this.mIconSize,
      iconId : this.appInfo.appIconId as number,
      bundleName: this.appInfo.bundleName as string,
      moduleName : this.appInfo.moduleName as string,
      icon : this.getAppIcon(),
      positionX : rect.left,
      positionY : rect.top,
      item : this.appInfo as DockItemInfo
    }
    AppStorage.setOrCreate('appIconInfo', appIconInfo);
  }

  private longPressVibrate(): void {
    if (DeviceHelper.isPhone() && !editModeManager.isInEditMode() &&
      !scbEventExclusiveManager.isExclusive(EventType.DESKTOP_CLICK)) {
      vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_LONG_PRESS,
        CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
    }
    // 拖拽适配无障碍朗读dock栏应用起拖播报
    DragAccessibilityUtils.textAnnouncedForDragStart();
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
      PcModeContinuableModel.getInstance().isOpenPopupOnContinuableItem = this.isContinueMerged(this.appInfo);
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

  @Builder
  iconBackGroundBuilder() {
    // 文件夹形成之前背板（除拖拽图标外）
    Column() {
    }
    .width(this.mIconSize)
    .height(this.mIconSize)
    .scale({ x: this.appBubbleBackplaneRatio, y: this.appBubbleBackplaneRatio })
    .borderRadius(this.layoutPropertyVm.iconRadius * 1.15)
    .backgroundBlurStyle(BlurStyle.Thin, { policy: 1 })
    .translate({ x: this.animationVm.translateX, y: this.animationVm.translateY })
    .id(`${TAG}_Column_backboard`)
  }

  @Styles
  eventStyles() {
    .parallelGesture(
      GestureGroup(GestureMode.Parallel,
        LongPressGesture({ repeat: false, duration : 250 })
          .onAction((event?: GestureEvent) => {
            this.longPressIconInfo();
          }),
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_HIDE_BADGE })
          .onAction((event?: GestureEvent) => {
            if (!this.isDrag && this.appInfo.itemType !== CommonConstants.TYPE_FOLDER &&
              event?.source === SourceType.TouchScreen) {
              this.setMenuShowStatus(true);
            }
            if (!editModeManager.isInEditMode()) {
              this.badgeAnimate = BadgeAnimationType.OPACITY_ZERO;
            }
          })
      )
    )
    .onTouch((event?: TouchEvent) => {
      this.execOnTouch(event);
    })
    .onMouse((event?: MouseEvent) => {
      this.execOnMouse(event);
    })
  }

  private checkVisibility(): Visibility {
    if (this.appInfo?.abilityName === CommonConstants.RECENT_ABILITY) {
      return Visibility.Visible;
    }
    let res: Visibility = this.animationVm.visible === Visibility.Hidden ||
      (AppStorage.get<string>('device') === CommonConstants.DEFAULT_DEVICE_TYPE &&
        (this.isDragStart || this.isShowCancelDialog())) ? Visibility.Hidden : Visibility.Visible;
    log.showInfo(`checkVisibility res: ${res}, device: ${AppStorage.get<string>('device')}, ` +
      `isDragStart: ${this.isDragStart}, isShowCancelDialog: ${this.isShowCancelDialog()}`);
    return res;
  }

  private isRecentAbility(): boolean {
    return this.appInfo.bundleName === CommonConstants.LAUNCHER_BUNDLE &&
      this.appInfo.abilityName === CommonConstants.RECENT_ABILITY;
  }

  private initRecentTaskImage(): void {
    if (this.isRecentAbility()) {
      this.iconData.isLayeredIcons = true;
      this.iconData.backgroundImagePixel = $r('app.media.adaptive_multitask_background');
      this.iconData.foregroundImagePixel = $r('app.media.adaptive_multitask_foreground');
    }
  }

  private initAppIconEvent() {
    const appIconHoverEvent: AppIconHoverEventIface = {
      onHover: (isHover: boolean, event: HoverEvent, updateScale: (scale: number) => void): void => {
        HoverAnimationUtil.hoverEffect(isHover, true, updateScale);
        this.onHoverAppItem(isHover, this.appInfo);
      }
    }
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
    this.appIconCommonEvent.setIconHoverEventIface(appIconHoverEvent);
    this.appIconCommonEvent.setIconActiveEvent(appIconActiveEvent);
  }

  private initAppIconConfig() {
    this.initAppIconEvent();
    const appData: AppDataWrapper = AppDataWrapper.getDefaultAppData(this.appInfo,
      this.mSmartDockStyleConfig.mIconRadius);
    appData
      .setStartType(StartType.DOCK_APP)
      .setAppIconId(AppModel.getInstance().getAppIconContainerId('SmartDock_AppIcon',
        this.appInfo.bundleName, this.appInfo.abilityName, this.appInfo.appIndex))
    this.appIconConfig.setEnableName(false)
      .setEnableMultiSelect(false)
      .setEnableBackplane(false)
      .setEnableHoverAnimation(true)
      .setEnableTouchMask(false)
      .setAppDataOfTransactionController(appData)
      .setIsDesktopItem(false)
      .setEnableSupportCheckAndFix(true)
      .setEnableDrag(this.appInfo.abilityName === CommonConstants.RECENT_ABILITY ? false : true)
      .setExternCb({
        dragStartExtend: (event: DragEvent): void => {
          this.isAppIconDrag = true;
          this.dealDragStart(event)
        },
        dragEndExtend: (event: DragEvent): void => {
          if (!DragEventManager.getInstance().isDropInDesktop) {
            localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_REFRESH,
              this.appInfo);
          }
        },
        getMenuInfo: (): MenuInfo[] => {
          if (!this.isRecentAbility()) {
            return this.getMenuInfoList();
          }
          return [];
        },
        onLongPressPreGatherAction: () => {
          this.initMenuInfo(false);
        },
        onMenuAppear: (isLongPressShow: boolean) => {
          this.setMenuShowStatus(true);
          this.isPopupShow = false;
        },
        onMenuDisappear: (isLongPressShow: boolean) => {
          if (AppStorage.get<boolean>('isDrag') && this.isAppIconDrag) {
            log.showInfo('onMenuDisappear isDrag: true');
            return;
          }
          animateTo({
            duration: 0,
          }, () => {
            this.animationVm.alpha = 1;
          })
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
          this.isAppIconDrag = false;
          PageDesktopDragHandler.getInstance(this.singleContext).onDragStart(x, y);
        }
      })
    // 预览图底部margin设置为0，防止菜单生成时组件位置突变
    // dock在屏幕底端，下方设置有24vp的安全间隔，由于与导航条间隔太近，会使预览图生成的时候往上偏，预期是菜单原地生成，因此将该属性设为0
    this.iconMenuVm.setLayoutRegionMargin({ bottom: 0 });
  }

  @Builder
  pcModeResidentLayoutIconBuilder() {
    ListItem() {
      Column() {
        Flex() {
          AppIconCommonView({
            item: this.appInfo,
            iconData: this.iconData,
            appIconConfig: this.appIconConfig,
            iconRadius: this.layoutPropertyVm.iconRadius,
            iconEvent: this.appIconCommonEvent,
            iconSize: this.mIconSize,
            isInDrag: this.isInDrag,
            isDragStart: this.isDragStart,
            iconBadgeVm: this.iconBadgeVm,
            iconMenuVm: this.iconMenuVm,
          })
        }
        .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
        .width(this.mIconSize)
        .height(this.mIconSize)
        .backgroundColor(this.mSmartDockStyleConfig.mItemBackgroundColor)
        .borderRadius(this.appInfo?.abilityName === CommonConstants.RECENT_ABILITY ?
          CommonConstants.DEFAULT_ICON_RADIUS : this.mSmartDockStyleConfig.mIconRadius)
        .clip(this.appInfo?.abilityName === CommonConstants.RECENT_ABILITY)
        .shadow(this.mSmartDockStyleConfig.mIconRadius === CommonConstants.DEFAULT_ICON_RADIUS ? {
          radius: SmartDockConstants.DOCK_ITEM_SHADOW_RADIUS,
          color: SmartDockConstants.DOCK_ITEM_SHADOW_COLOR,
          offsetY: SmartDockConstants.DOCK_ITEM_SHADOW_OFFSETY_ONE
        } : undefined)
        .visibility(this.checkVisibility())
        .scale(this.getScaleOptions())
        .opacity(this.animationVm.alpha)
        .id(AppModel.getInstance().getAppIconContainerId('SmartDock_AppIcon',
          this.appInfo.bundleName, this.appInfo.abilityName, this.appInfo.appIndex))
        .hitTestBehavior(this.editModeState.isInEditMode() ? HitTestMode.None : HitTestMode.Default)
        .bindContextMenu(this.isRecentAbility() ? this.isMenuShow : false, this.MenuBuilder, this.getContextMenu())
        .eventStyles()
        .bindPopup(this.popupShowJudge(this.appInfo), {
          builder: this.isOnlyTipsApp(this.appInfo) ? this.onlyTipsBuilder(this.appInfo) :
          this.popupBuilder(this.appInfo),
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
          .visibility(this.isInDrag || this.isUnLocking ? Visibility.Hidden : Visibility.Visible)
      }
      .id(DockUtils.getDockItemId(this.appInfo))
      .margin({
        top: this.getBinaryHeight()
      })
    }
    .foregroundEffect({ radius: this.animationVm.blurRadius })
    .translate({ x: this.animationVm.translateX, y: this.animationVm.translateY })
  }

  @Builder onlyTipsBuilder(item: DockItemInfo) {
    Row() {
      Text(this.getPopItemAppName(item)).draggable(false)
        .id(`ResidentLayoutForPC_Text_${this.getPopItemAppName(item)}`)
        .width(this.getAppNameTextWidth(this.getPopItemAppName(item)))
        .height(this.getAppNameTextHeight(this.getPopItemAppName(item)))
        .fontSize(this.fontScaleState.getScaleSize(StyleConstants.DEFAULT_14))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
        .textOverflow({overflow: TextOverflow.Ellipsis})
        .textAlign(TextAlign.Center)
        .maxLines(1)
        .align(Alignment.Center)
    }
    .height(StyleConstants.SCROLLER_POPUP_HEIGHT)
    .justifyContent(FlexAlign.Center)
    .padding({ top: FixedDockResource.TIPS_TEXT_PADDING })
  }

  @Builder popupBuilder(item: DockItemInfo) {
    ScrollerComponent({
      singleContext: this.singleContext,
      mPopItem: item,
      deviceInfo: this.deviceInfo,
      popupOffsetUpdate: (position: Position) => {},
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
      .id(`ScrollerComponent_showPopup`)
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

  private getAppNameTextWidth(appName: string): number | string {
    let width: number | string = 64;
    if (CheckEmptyUtils.checkStrIsEmpty(appName)) {
      return width;
    }
    const maxWidth: number = this.mSmartDockStyleConfig.mScreenWidth * 2 / 3;
    width = this.getTextWidth(appName, width, maxWidth);
    return width;
  }

  private getTextWidth(appName: string, width: number, maxWidth: number): number {
    let needTextWidth: number = Math.round(px2vp(measure.measureTextSize({
      textContent: appName,
      fontSize: this.fontScaleState.getScaleSize(StyleConstants.DEFAULT_14),
      fontWeight: FontWeight.Regular,
      overflow: TextOverflow.Ellipsis,
      maxLines: 1
    }).width as number)) + StyleConstants.DEFAULT_16;
    needTextWidth = needTextWidth > maxWidth ? maxWidth : needTextWidth;
    return needTextWidth > width ? needTextWidth : width;
  }

  private getTextHeight(appName: string, height: number, maxHeight: number): number {
    let needTextHeight: number = Math.round(px2vp(measure.measureTextSize({
      textContent: appName,
      fontSize: this.fontScaleState.getScaleSize(StyleConstants.DEFAULT_14),
      fontWeight: FontWeight.Regular,
      overflow: TextOverflow.Ellipsis,
      maxLines: 1
    }).height as number)) + StyleConstants.DEFAULT_16;
    needTextHeight = needTextHeight > maxHeight ? maxHeight : needTextHeight;
    return needTextHeight > height ? needTextHeight : height;
  }

  private getAppNameTextHeight(appName: string): number | string {
    let height: number | string = FixedDockResource.POPUP_MIN_TEXT_HEIGHT;
    if (CheckEmptyUtils.checkStrIsEmpty(appName)) {
      return height;
    }
    const maxHeight: number = this.mSmartDockStyleConfig.mScreenHeight * 2 / 3;
    height = this.getTextHeight(appName, height, maxHeight);
    return height;
  }

  private getPopItemAppName(item: DockItemInfo): string {
    switch (item?.abilityName) {
      case CommonConstants.APPCENTER_ABILITY:
        return ResUtils.getInnerStringByName('dock_hover_text_appcenter');
      case CommonConstants.RECENT_ABILITY:
        return ResUtils.getInnerStringByName('dock_hover_text_recentcenter');
      case CommonConstants.RECYCLE_BIN_ABILITY:
        return ResUtils.getInnerStringByName('dock_hover_text_recyclebin');
      default:
        return '';
    }
  }

  private isOnlyTipsApp(item: DockItemInfo): boolean {
    log.showInfo(`isOnlyTipsApp abilityName: ${item?.abilityName}`);
    switch (item?.abilityName) {
      case CommonConstants.APPCENTER_ABILITY:
        return true;
      case CommonConstants.RECENT_ABILITY:
        return true;
      case CommonConstants.RECYCLE_BIN_ABILITY:
        return true;
      default:
        return false;
    }
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

    let result: boolean = this.isPopupShow && !this.isDockMenuShow;
    if (this.popupMgr.getCurrItem()?.bundleName != item.bundleName ||
      this.popupMgr.getCurrItem()?.abilityName != item.abilityName) {
      result = false;
    }
    log.showInfo(`popupShowJudge: result: ${result}, isPopupShow: ${this.isPopupShow},` +
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

  private getScaleOptions(): ScaleOptions {
    let centerX : string | number = 0;
    let centerY : string | number = 0;
    if (!(SCBSceneSessionManager.getInstance().isPcMode() && DeviceHelper.isThreeFoldProduct())) {
      centerX = this.animationVm.centerX;
      centerY = this.animationVm.centerY;
    }
    return {
      x: this.animationVm.scaleSize,
      y: this.animationVm.scaleSize,
      centerX: centerX,
      centerY: centerY,
    };
  }

  @Builder
  iconWithBackGround() {
    Stack() {
      if (this.isAppBackplaneAppear) {
        this.iconBackGroundBuilder();
      }
      if (this.isAccessibilityMode) {
        Stack() {
          // 仅用于无障碍屏幕朗读模式下app名称播报
          AppName({
            nameHeight: 0,
            nameWidth: 0,
            nameSize: 0,
            bundleName: this.appInfo.bundleName,
            moduleName: this.appInfo.moduleName,
            parentItem: this.appInfo as AppItemInfo,
            appName: this.appInfo.appName,
            labelId: this.appInfo.appLabelId,
            useCache: true,
            itemStatus: this.appInfo?.appStatus,
            zValue: -1,
          })
          this.pcModeResidentLayoutIconBuilder();
        }
        .accessibilityDescription(ResourceManager.getInstance()
          .getStringByName('tap_with_menu_reader_text'))
        .onClick((event?: ClickEvent)=> {
          this.itemOnClick?.(event);
        })
      } else {
        this.pcModeResidentLayoutIconBuilder();
      }
    }
  }

  build() {
    if (this.appInfo.itemType === CommonConstants.TYPE_FOLDER) {
      ListItem() {
        Stack({ alignContent: Alignment.Top }) {
            ContractedFolder({
              zoomScale: this.layoutPropertyVm.scale,
              folderId: this.mFolderItemInfo.folderId,
              desktopStyle: this.desktopStyle,
              isEnableName: false,
              dragStart: (event: DragEvent): DragItemInfo => this.dragStart(event),
              isInDock: true
            })
              .width(this.mIconSize)
              .height(this.mIconSize)
              .backgroundColor(this.mSmartDockStyleConfig.mItemBackgroundColor)
              .borderRadius(this.layoutPropertyVm.iconRadius)
              .translate({ x: this.animationVm.translateX, y: this.animationVm.translateY })
              .scale(this.getScaleOptions())
              .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
              .opacity(this.animationVm.alpha)
              .id(DockUtils.getDockItemId(this.appInfo))
              .hitTestBehavior(this.editModeState.isInEditMode() ||
                (DeviceHelper.isPhone() && this.isDrag) ? HitTestMode.None : HitTestMode.Default)
        }
        .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
        .itemGesture()
      }
      .scale({
        x: 1,
      })
      .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
    } else {
      this.iconWithBackGround()
    }
  }
}