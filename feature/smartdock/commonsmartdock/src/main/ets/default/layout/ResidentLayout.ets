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

import { AlertDialog, LengthMetrics } from '@kit.ArkUI';
import {
  AnimateToScheduleUtils,
  CheckEmptyUtils,
  CompanionIconInfo,
  LogDomain,
  LogHelper,
  ObjUtil,
  RectInfo,
  SingleContext,
} from '@ohos/basicutils';
import { NumberConstants, SCBConstants } from '@ohos/commonconstants';
import { DropAnimationScene } from '@ohos/componentanimator';
import {
  ApsUtils,
  DeviceHelper,
  DownloadingProgressChangeEvent,
  DownloadStatusChangeEvent,
  GlobalContext,
  HiDfxEventUtil,
  HiSysEventUtil,
  IconResourceManager,
  InstallStatusChangeEvent,
  localEventManager,
  ResourceManager,
  SCBDesktopCacheManager,
  SCBWindowSceneConfig,
  ScreenState,
  ViewCallback,
  viewMgrPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import {
  SCBExpandController,
  SCBFoldController,
  SCBSceneMode,
  SCBSceneSessionManager,
  SCBTransitionManager,
  SCBUnlockTransitionController,
  StartAbilityUtil,
} from '@ohos/windowscene';
import {
  desktopUtil,
  dragSnapshotHelper,
  ItemUtils,
  ObjectCopyUtil,
  SCBVisualEffectMgr,
  SnapshotType,
  StateEx
} from '@ohos/componenthelper';
import {
  DragDataType,
  DragEventCallback,
  DragEventManager,
  DragExtraInfo,
  DragItemPosition
} from '@ohos/componentdrag';
import {
  AppDataWrapper,
  AppGalleryDownloadManager,
  AppGalleryEventInfo,
  AppIconEventData,
  AppInstallUtils,
  AppItemInfo,
  AppStatus,
  AppToHapMappingManager,
  CommonConstants,
  DesktopManager,
  DeviceState,
  DockContinuableInfo,
  DockItemInfo,
  DockUtils,
  DownloadStatusInfo,
  EventConstants,
  FolderDataModelManager,
  FolderItemInfo,
  GrayAppListManager,
  GridLayoutItemInfo,
  GridLayoutUtil,
  HiSysContinueFuncResult,
  LaunchLayoutCacheManager,
  layoutConfigManager,
  layoutLockUtil,
  LayoutViewModel,
  MenuInfo,
  NotHarmonyUtil,
  PresetStyleConstants,
  PriorityLevel,
  ResidentLayoutCacheMgr,
  SCBHiSysEventUtil,
  SettingsModel,
  ShortcutViewModel,
  SmallFolderRegion,
  SmartDockZoomFeatureSwitch,
  StyleConstants,
  UninstallDialogStatus,
  PreInstallUtils,
  LayoutDescription,
  DesktopLayoutState,
  FolderManager,
  SmallFolderStyleConfig,
  lockLayoutManager,
  InstalledDialogType,
  DeleteDockItem,
  SmallFolderConstants,
  DesktopUtils,
} from '@ohos/launchercommon';
import lazy { SmartDockZoomManager }from '@ohos/launchercommon/src/main/ets/dock/common/SmartDockZoomManager';
import { DeleteAction } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import {
  AppIconCommonEvent,
  AppIconCommonView,
  AppIconConfig,
  AppIconDefaultModifier,
  BadgeAnimationType,
  ContractedFolder,
  DeskTopItemStyle,
  FolderStyleManager,
  FolderViewData,
  HoverAnimationUtil,
  LongPressAppIconInfo,
  UninstallDialog,
  AppNameVm
} from '@ohos/launchercommon/Index';
import curves from '@ohos.curves';
// import apsManager from '@hms.graphic.apsManager';
import { AppIconBadgeVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconBadgeVm';
import { AppIconMenuVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconMenuVm';
import SmartDockConstants from '../common/constants/SmartDockConstants';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { PageDesktopDragHandler, PageDesktopViewModel } from '@ohos/pagedesktop';
import { SmartDockStyleConfig } from '../common/SmartDockStyleConfig';
import SmartDockDragHandler from '../common/SmartDockDragHandler';
import BackPlane from '../common/component/BackPlane';
import FeatureConstants from '../common/constants/FeatureConstants';
import { BigFolderViewModel } from '@ohos/bigfolder';
import SmartDockViewModel from '../viewmodel/SmartDockViewModel';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { EditModeState } from '@ohos/launchercommon/src/main/ets/editmode/data/EditModeState';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import {
  AppIconActiveEventIface
} from '@ohos/launchercommon/src/main/ets/launchericon/interface/AppIconActiveEventIface';
import {
  dropAnimationManager,
  GravityAnimationComponent,
  gravityAnimationManager,
  GravityAnimationPage,
  GravityAnimationParameter
} from '@ohos/componentanimator/Index';
import { FolderLayoutChangeListener } from '@ohos/launchercommon/src/main/ets/folder/FolderViewModel';
import lazy { PcModeResidentAppItem } from './PcModeResidentAppItem';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';
import {
  SlMainStateType,
  SlStaticStateType,
  SlSubStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { SmartDockEventMgr } from '../manager/SmartDockEventMgr';
import { DockRegionAnimationVm } from '../viewmodel/DockRegionAnimationVm';
import { DockRegionAnimationEvent } from '../viewmodel/DockRegionAnimationEvent';
import { DockItemAnimationVm } from '../viewmodel/DockItemAnimationVm';
import { DockItemAnimationEvent } from '../viewmodel/DockItemAnimationEvent';
import { DockRegionLayoutPropertyVm } from '../viewmodel/DockRegionLayoutPropertyVm';
import { DragItemPlaceVm } from '../viewmodel/DragItemPlaceVm';
import lazy { SCBTripleController } from '@ohos/windowscene/src/main/ets/animation/SCBTransitionController';
import lazy {
  SCBTripleStateChange,
  UltraScreenExpandAnimUtils,
} from '@ohos/launchercommon/src/main/ets/utils/UltraScreenExpandAnimUtils';
import lazy {
  UltraScreenAnimationConstants
} from '@ohos/launchercommon/src/main/ets/constants/UltraScreenAnimationConstants';
import { DockRegionLayoutModel } from '../model/DockRegionLayoutModel';
import { AppInstallingDataManager } from '@ohos/launchercommon/src/main/ets/appinstall/AppInstallingDataManager';
import { SmartDockObserver } from '../viewmodel/smartDockObserver';
import { SmartDockZoomAnimationConfig } from '../common/SmartDockZoomAnimationConfig';
import lazy { SmartDockZoomEvent } from '../viewmodel/SmartDockZoomEvent';
import { DockRegionType } from '../common/enum/SmartDockEnum';
import { SmartDockStyleMgr } from '../manager/SmartDockStyleMgr';

const TAG = 'SmartDock_V_ResidentLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const BACK_PLANE_ANIM_DURATION: number = 400;
const ICON_ALPHA_ANIM_DURATION: number = 400;
const I_CURVE: ICurve = curves.cubicBezierCurve(0.40, 0, 0.40, 1);

/**
 * ResidentLayout
 *
 * @since 2022-10-09
 */
@Component
export default struct ResidentLayout {
  @Prop singleContext?: SingleContext;
  mResidentMaxNum: number = 0;
  mSmartDockStyleConfig: SmartDockStyleConfig =
    layoutConfigManager.getStyleConfig(SmartDockStyleConfig.APP_LIST_STYLE_CONFIG, FeatureConstants.FEATURE_NAME);
  onItemClick?: Function;
  buildMenu?: Function;
  onHoverEvent?: Function;
  onDockListChangeFunc?: Function;
  isScrollHover: boolean = false;
  onClickWithPopup: boolean = false;
  autoCancel: boolean = false;
  private clickItem: DockItemInfo = new DockItemInfo();
  private mSmartDockViewModel: SmartDockViewModel = SmartDockViewModel.getInstance(this.singleContext);
  private deviceType: string = '';
  private unLockTransitionController: SCBUnlockTransitionController = {
    name: `${TAG}_smartdock`,
    onLock: (): void => {
    },
    onUnlock: (): void => {},
    onUnlockStartScene: (): void => this.onUnlockStartSceneReceived(),
    onUnlockAnimation: (): void => this.residentOnUnLockReceived(),
  };
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  @State private appIconWidth: number = SmallFolderConstants.DEFAULT_APP_ICON_WIDTH;
  @State private appIconHeight: number = SmallFolderConstants.DEFAULT_APP_ICON_HEIGHT;
  private gridPadding: number = SmallFolderConstants.DEFAULT_FOLDER_GRID_PADDING;
  private gridGap: number = SmallFolderConstants.DEFAULT_FOLDER_GRID_GAP;
  private smallFolderSize: number = SmallFolderConstants.DEFAULT_FOLDER_WIDTH;
  @State mSmallFolderRadius: number = 0;
  @State mSmallFolderIconRadius: number = 0;
  private mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance(this.singleContext);
  protected mSmartDockEventMgrIns: SmartDockEventMgr = SmartDockEventMgr.getInstance(this.singleContext);
  @StorageLink('residentLayoutAdditionWidth') residentLayoutAdditionWidth: number = 0;

  /*
   * 移除菜单弹框，CustomDialogController必须在@Component struct内部定义时赋值才有效
   */
  private removeDialogController: CustomDialogController = new CustomDialogController({
    builder: UninstallDialog({
      singleContext: this.singleContext,
      fromRemoveAction: DeleteAction.ACTION_REMOVE,
      cancel: () => {
      },
      confirm: () => {
        this.mSmartDockEventMgrIns.deleNotInstallApp();
      },
      dialogName: this.mSmartDockEventMgrIns.getRemoveDialogName(),
      dialogContent: $r('app.string.remove_content'),
      isFromDesktop: true
    }),
    cancel: () => {
      log.showInfo('cancel app uninstall dialog');
    },
    autoCancel: true,
    showInSubWindow: true,
    alignment: DialogAlignment.Center,
  });
  private keyguardCallback: ViewCallback = {
    onHide: (): void => this.onScreenOn()
  };
  private expandController?: SCBExpandController;
  private tripleController?: SCBTripleController;
  @Provide changeSizeAnimating: boolean = false;
  @StorageLink('continueDeviceInfo') @Watch('onContinueDeviceChange') deviceInfo: DockContinuableInfo =
    new DockContinuableInfo();
  @StorageLink('dockPadding') dockPadding: RectInfo = new RectInfo();
  @StorageLink('screenWidth') @Watch('onDockListChange') mScreenWidth: number =
    AppStorage.get<number>('screenWidth') as number;
  @StorageLink('screenHeight') mScreenHeight: number = AppStorage.get<number>('screenHeight') as number;
  @StorageLink('dockHeight') dockHeight: number = 0;
  @Consume('clearDesktopMemory') @Watch('trimSmartDock') trimSmartDockMemory: boolean;
  @Consume('releaseDesktopMemory') @Watch('releaseSmartDock') releaseSmartDockMemory: boolean;
  @State isHover: boolean = false;
  @State showPopup: boolean = false;
  @State onHoverItem: string = '';
  @State isShowContinuableItem: boolean = false;
  @State paddingValue: RectInfo = new RectInfo();
  @StorageLink('residentList') @Watch('onDockListChange') appList: Array<DockItemInfo> = [];
  @StorageLink('folderStatus') @Watch('folderStatusChange') folderStatus: number =
    AppStorage.get<number>('folderStatus') as number;
  @StorageLink('foldStatusForOuterScreen') @Watch('folderStatusChange') foldStatusForOuterScreen: number =
    AppStorage.get<number>('foldStatusForOuterScreen') as number;
  @StorageLink('isPortrait') @Watch('onPortraitStatusChange') mIsPortrait: boolean = true;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @StorageLink('isContinueItemAnimating') isContinueItemAnimating: boolean = false;
  @State smallFolderText: string = '';
  @State @Watch('onUnLockReceived') isUnLockReceived: boolean = false;
  @State @Watch('onLockReceived') isLockReceived: boolean = false;
  @State isBackplaneExist: boolean = desktopUtil.isFoldExpandStatus() || DeviceHelper.isPad();
  @StorageLink('isDrag') @Watch('refreshWhiteBoxVisibility') isDrag: boolean = false;
  @State residentListWidth: number = 0;
  @StorageLink('residentLayoutWidth') residentLayoutWidth: number = 0;
  @Provide folderTitleOpacity: number = StyleConstants.DEFAULT_1;
  @Provide isFolderNameExit: boolean = false; // 文件夹名称退场
  @Provide folderScaleX: number = 1;
  @Provide folderScaleY: number = 1;
  @Provide radiusScale: number = 1;
  @Provide appIconScale: number = 1;
  @Provide paddingScale: number = 1;
  @Provide gridGapScale: number = 1;
  @Provide superposeStateChange: boolean = false;
  @StorageProp('themeStyle') @Watch('onThemeChange') themeStyle: string = '';
  @StorageProp('desktopIconChange') @Watch('onThemeChange') desktopIconChange: number = 0;
  @StorageProp('themeStylePreview') @Watch('onThemeChange') themeStylePreview: boolean = false;
  @State dragItemPlaceVm: DragItemPlaceVm = new DragItemPlaceVm();
  @State layoutPropertyVm: DockRegionLayoutPropertyVm = SmartDockObserver.getInstance().getLayoutPropertyVm();
  @State @Watch('onAnimationChange') animationVm: DockRegionAnimationVm = new DockRegionAnimationVm();
  private animationEvent: DockRegionAnimationEvent = new DockRegionAnimationEvent(this.animationVm);
  private onDesktopModeChangeEvent: Function = (): void => {
    this.updateLayoutParams();
  }
  private onIconSizeChangeEvent: Function = (): void => this.updateLayoutParams();
  private onMultiWindowExitEvent: Function = (): void => this.onMultiWindowExitEventCallback();
  private dockHolderNotifyEvent: Function =
    (center: number, isShow: boolean, immediate: boolean) => this.onDockHolderIndexChange(center, isShow, immediate);
  private residentReshapeEvent: Function = (length: number) => this.onResidentReshape(length);
  @State isPcMode: boolean = SCBSceneSessionManager.getInstance().isPcMode();
  private singleHandChange: () => void = () => this.folderStatusChange();
  private iconReductionEvent: () => void = () => this.onDockIconReduction();
  private onScaleChangeEvent: (dockRegionType: DockRegionType) => void =
    (dockRegionType) => this.onScaleChange(dockRegionType);
  private onDockIconReduction(): void {
    const num: number = this.appList.length;
    let isNeedAnimation: boolean = !DeviceHelper.isPhone() || GridLayoutUtil.isLargeFoldOrTrifoldExpanded();
    if (SmartDockZoomFeatureSwitch.isSupportZoom()) {
      isNeedAnimation = SmartDockZoomEvent.getInstance().onSmallFolderConvertToBig(num);
    }
     if (!isNeedAnimation || num === 0) {
       log.showInfo('no need to do dock icon reduction animation');
       return;
    }
    this.residentLayoutWidth = this.layoutPropertyVm.calculateRegionWidth(num + 1);
    this.residentListWidth = this.residentLayoutWidth;
    animateTo({
      duration: SmartDockZoomAnimationConfig.getAnimationDuration(),
      curve: SmartDockZoomAnimationConfig.getAnimationCurve(),
    }, () => {
      this.residentLayoutWidth = this.layoutPropertyVm.calculateRegionWidth(num);
      this.residentListWidth = this.residentLayoutWidth;
      this.paddingValue = this.getListPadding();
    });
  }

  private refreshSmallFolderStyleConfig(): void {
    const styleConfig: SmallFolderStyleConfig = FolderStyleManager.getInstance().getSmallFolderStyleConfig();
    this.appIconWidth = styleConfig.mFolderAppSize * this.layoutPropertyVm.scale ?? 0;
    this.appIconHeight = styleConfig.mFolderAppSize * this.layoutPropertyVm.scale ?? 0;
    this.gridPadding = styleConfig.mGridMargin * this.layoutPropertyVm.scale ?? 0;
    this.gridGap = styleConfig.mFolderGridGap * this.layoutPropertyVm.scale ?? 0;
    this.smallFolderSize = this.mSmartDockStyleConfig.mIconSize ?? 0;
    this.mSmallFolderRadius = styleConfig.mSmallFolderRadius ?? 0;
    this.mSmallFolderIconRadius = styleConfig.mSmallFolderIconRadius * this.layoutPropertyVm.scale ?? 0;
  }

  private onScaleChange(dockRegionType: DockRegionType): void {
    if (!this.isBackplaneExist) {
      return;
    }
    if (this.isDrag && dockRegionType === DockRegionType.RESIDENT) {
      this.residentListWidth = this.getResidentWidth();
    } else {
      this.refreshSmallFolderStyleConfig();
      animateTo({
        duration: SmartDockZoomAnimationConfig.getAnimationDuration(),
        curve: SmartDockZoomAnimationConfig.getAnimationCurve(),
      }, (): void => {
        this.residentLayoutWidth = this.getResidentWidth();
        this.residentListWidth = this.residentLayoutWidth;
        this.paddingValue = this.getListPadding();
      })
    }
  }

  private async getSmallFolderText(): Promise<void> {
    this.smallFolderText = await ResourceManager.getInstance().getStringByIdSync($r('app.string.small_folder').id);
  }

  // fold screen animation
  private expandedAnimation(): void {
    this.animationEvent.expandedAnimation(this.mScreenWidth, this.getResidentWidth(),
      SmartDockConstants.DOCK_RESIDENT_BG_ID, true, () => {
        performanceMonitor.end('FOLD_TO_EXPAND_DOCK_BACKGROUND_SCALE_TWO');
        SCBDesktopCacheManager.getInstance().resetFreezeStateOnly('FOLD_TO_EXPAND_DOCK_BACKGROUND');
        // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLDING_SCREEN, StyleConstants.DEFAULT_0);
      });
  }

  private tripleAnimation(oldState: ScreenState, newState: ScreenState, isNeedAnimation: boolean): void {
    log.showInfo(`resident dock bg execute tripleAnimation, oldState is ${oldState}, newState is ${newState}`);
    let stateChange: SCBTripleStateChange = UltraScreenExpandAnimUtils.getTripleDesktopStateChange(newState, oldState);
    if (!isNeedAnimation) {
      this.animationVm.alpha = UltraScreenExpandAnimUtils.getTripleDockBgAnimEndAlpha(stateChange);
      SCBDesktopCacheManager.getInstance().resetFreezeStateOnly('FOLD_TO_EXPAND_DOCK_BACKGROUND');
      log.showInfo(`resident dock bg noneed tripleAnimation`);
      return;
    }
    animateTo({
      duration: 0,
    }, () => {
      this.animationVm.translateX =
        UltraScreenExpandAnimUtils.initTripleDockAnimTranslateX(this.mScreenWidth, stateChange);
      this.animationVm.alpha = UltraScreenExpandAnimUtils.initTripleDockBgAnimAlpha(stateChange);
    });
    animateTo({
      curve: UltraScreenAnimationConstants.TRANSLATE_CURVES,
      duration: UltraScreenAnimationConstants.ANIMATION_DURATION,
    }, () => {
      this.animationVm.translateX = 0;
    });
    animateTo({
      curve: Curve.Linear,
      duration: UltraScreenAnimationConstants.DOCK_BG_ALPHA_DURATION,
      onFinish: () => {
        SCBDesktopCacheManager.getInstance().resetFreezeStateOnly('FOLD_TO_EXPAND_DOCK_BACKGROUND');
      }
    }, () => {
      this.animationVm.alpha = UltraScreenExpandAnimUtils.getTripleDockBgAnimEndAlpha(stateChange);
    });
  }

  onPortraitStatusChange(): void {
    if (SmartDockZoomFeatureSwitch.isSupportZoom()) {
      SmartDockZoomEvent.getInstance().onPortraitStatusChange();
    }
    this.onDockListChange();
    log.showInfo('portraitChange, length: %{public}d, width: %{public}d, iconSize: %{public}d, space: %{public}d' +
      ', dockHeight: %{public}d,portraitStatus: %{public}s', this.appList?.length, this.residentLayoutWidth,
      this.layoutPropertyVm.iconSize, this.layoutPropertyVm.space, this.layoutPropertyVm.dockHeight, this.mIsPortrait);
  }

  private registerUnlockTransitionController(): void {
    SCBSceneSessionManager.getInstance().registerUnlockTransitionCallback(this.unLockTransitionController);
  }

  private trimSmartDock(): void {
    log.showInfo(` trimi SmartDock memory`);
  }

  private releaseSmartDock(): void {
    log.showInfo(` release SmartDock memory`);
  }

  private slStaticStateListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_STATIC_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === SlStaticStateType.SL_LOCK_STATE) {
        let isLocked = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE)
        ?.getSlState(SlStaticStateType.SL_LOCK_STATE) as boolean;
        log.showInfo(`ResidentLayout received slStaticStateListener isLocked is ${isLocked}`);
        if (isLocked) {
          this.residentOnLockReceived();
        }
      }
    }
  };

  residentOnLockReceived(): void {
    this.isLockReceived = true;
    this.isUnLockReceived = false;
  }
  private onUnlockStartSceneReceived(){
    this.animationEvent.setVisible(Visibility.Hidden);
  }

  residentOnUnLockReceived(): void {
    this.isUnLockReceived = true;
    this.isLockReceived = false;
    this.animationEvent.setVisible(Visibility.Visible);
    HiDfxEventUtil.reportUnlockToDesktop(HiDfxEventUtil.UNLOCK_TO_DOCK_ANIMATION_BEGIN, CommonConstants.INVALID_VALUE);
  }

  // ScreenOn 状态，主要避免锁屏状态下三方应用拉起，桌面无锁屏通知无法刷新界面
  private onScreenOn(): void {
    this.animationEvent.onScreenOn();
  }

  private onLockReceived(): void {
    if (!this.isLockReceived) {
      return;
    }
    log.showInfo('onLockReceived');
    this.animationEvent.lockAnimation(this.mScreenWidth, this.mScreenHeight, SmartDockConstants.DOCK_RESIDENT_BG_ID);
  }

  private onUnLockReceived(): void {
    if (!this.isUnLockReceived) {
      return;
    }
    log.showInfo('onUnLockReceived');
    if (!(AppStorage.get<boolean>('shieldAnim') ?? false)) {
      this.animationEvent.unlockAnimation(this.mScreenWidth, this.mScreenHeight, SmartDockConstants.DOCK_RESIDENT_BG_ID);
    }
  }

  private onDockHolderIndexChange(newCenterX: number, isShow: boolean, immediate: boolean): void {
    // 落位白框默认位置为dock栏中心点位置，与dock栏中仅有一个元素时该元素中心点相同，此处通过获取该元素中心点来获取落位白框位置
    let oldCenterX: number = this.mSmartDockViewModel.getDockItemCenter(this.showContinuableItem() ? 0 : 1, 0);
    log.showInfo('onDockHolderIndexChange oldCenterX: %{public}d, newCenterX: %{public}d, isShow: %{public}s, immediate: %{public}s',
      oldCenterX, newCenterX, isShow, immediate);
    this.dragItemPlaceVm.onDockHolderIndexChange(newCenterX, oldCenterX, isShow, immediate);
  }

  private showContinuableItem(): boolean {
    return this.isShowContinuableItem && !this.isBackplaneExist;
  }

  private getVisibleCount(): number {
    return this.appList.length + (this.showContinuableItem() ? 1 : 0);
  }

  getRegion(index: number): number {
    let halfIndex = this.appList.length / 2;
    if (this.appList.length % 2 === 0) {
      return (index < halfIndex) ? SmallFolderRegion.LEFT_DOWN_REGION : SmallFolderRegion.RIGHT_DOWN_REGION;
    } else {
      return (index <= halfIndex) ? SmallFolderRegion.LEFT_DOWN_REGION : SmallFolderRegion.RIGHT_DOWN_REGION;
    }
  }

  private refreshWhiteBoxVisibility(): void {
    log.showWarn('refreshWhiteBoxVisibility isDrag:%{public}s whiteSpaceOpacity:%{public}d', this.isDrag,
      this.dragItemPlaceVm.opacity);
    this.dragItemPlaceVm.refreshVisibility(this.isDrag);
    if(SmartDockZoomFeatureSwitch.isSupportZoom()) {
      //嵌套if用于SmartDockZoomManager懒加载
      if (SmartDockZoomManager.isZoom() && this.residentListWidth !== this.residentLayoutWidth) {
        this.residentListWidth = this.residentLayoutWidth;
        this.paddingValue = this.getListPadding();
      }
    }
  }

  @Builder
  dragItemPlaceHolder() {
    Column()
      .id(`${TAG}_Rect_placeholder`)
      .border({ width: StyleConstants.SQUEEZE_BORDER_WIDTH, color: '#33ffffff' })
      .borderRadius(this.layoutPropertyVm.iconRadius)
      .width(this.layoutPropertyVm.iconSize)
      .height(this.layoutPropertyVm.iconSize)
      .accessibilityLevel(this.isAccessibilityMode ? 'no-hide-descendants' : 'auto')
      .margin({
        top: DeviceHelper.isPad() ? this.layoutPropertyVm.listPadding :
          SmartDockConstants.DEFAULT_DOCK_ICON_MARGIN_TOP,
        bottom: DeviceHelper.isPad() ? this.layoutPropertyVm.listPadding :
          SmartDockConstants.DEFAULT_DOCK_ICON_MARGIN_TOP
      })
      .backgroundColor('#0dffffff')
      .opacity(this.dragItemPlaceVm.opacity)
      .translate({ x: this.dragItemPlaceVm.translateX })
      .hitTestBehavior(HitTestMode.None)
  }

  private updateLayoutParams(): void {
    log.showInfo('updateLayoutParams');
    this.onDockListChange();
  }

  private onMultiWindowExitEventCallback(): void {
    log.showWarn('onMultiWindowExitEventCallback happen');
    if (DeviceHelper.isPad() && !SCBSceneSessionManager.getInstance().isPcMode()) {
      let dockItemInfo: DockItemInfo = new DockItemInfo();
      dockItemInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
      dockItemInfo.abilityName = CommonConstants.RECENT_ABILITY;
      dockItemInfo.typeId = CommonConstants.TYPE_APP;
      dockItemInfo.itemType = CommonConstants.TYPE_FUNCTION;
      dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
      dockItemInfo.appIndex = 0;
      dockItemInfo.keyName = CommonConstants.LAUNCHER_BUNDLE + CommonConstants.RECENT_ABILITY;
      this.mSmartDockViewModel.deleteDockItem(dockItemInfo as DeleteDockItem, SmartDockConstants.RESIDENT_DOCK_TYPE);
      log.showInfo('onMultiWindowExitEventCallback delete recent center');
    }
    AppStorage.setOrCreate('dockHeight', LayoutViewModel.getInstance(this.singleContext).getDockHeight());
    this.updateLayoutParams();
  }

  aboutToAppear(): void {
    if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
      log.showInfo('hide the ResidentLayout for first enter desktop');
      this.isUnLockReceived = false;
    }
    DesktopManager.getInstance().registerScreenChangeListener(this.singleHandChange);
    this.mResidentMaxNum = this.mSmartDockStyleConfig.mMaxDockNum;
    this.onDockListChange();
    log.showInfo(`residentListWidth: ${this.residentListWidth}, residentLayoutWidth: ${this.residentLayoutWidth},
     isBackplaneExist: ${this.isBackplaneExist}`);
    this.refreshSmallFolderStyleConfig();
    // 手动触发判断接续应用是否存在
    this.onContinueDeviceChange();
    slUiStateMgr.registerSlStateChangeListener(this.slStaticStateListener);

    this.getSmallFolderText();

    this.registerUnlockTransitionController();
    viewMgrPolicy.registerViewCallback(ViewType.KEYGUARD, this.keyguardCallback);
    this.expandController = {
      itemId: `${TAG}_dock`,
      onExpandAnimation: () => this.expandedAnimation(),
    };
    SCBTransitionManager.getInstance().registerExpandAnimationController(this.expandController);
    if (DeviceHelper.isUltraScreenProduct()) {
      this.tripleController = {
        itemId: `${TAG}_dock`,
        onTripleAnimation: (oldState: ScreenState, newState: ScreenState, isNeedAnimation: boolean) =>
        this.tripleAnimation(oldState, newState, isNeedAnimation),
      };
      SCBTransitionManager.getInstance().registerTripleAnimationController(this.tripleController);
    }
    this.desktopContext?.eventHub.on(SmartDockConstants.DOCK_HOLDER_NOTIFY_EVENT, this.dockHolderNotifyEvent);
    this.desktopContext?.eventHub.on(SmartDockConstants.RESIDENT_RESHAPE_EVENT, this.residentReshapeEvent);
    this.desktopContext?.eventHub.on(SmartDockConstants.MULTI_WINDOW_EXIT_TRIGGER_RESHAPE_EVENT,
      this.onMultiWindowExitEvent);
    this.desktopContext?.eventHub.on(EventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopModeChangeEvent);
    this.desktopContext?.eventHub.on(SmartDockConstants.ICON_SIZE_CHANGE_EVENT, this.onIconSizeChangeEvent);
    this.desktopContext?.eventHub.on(CommonConstants.DOCK_ICON_REDUCTION, this.iconReductionEvent);
    this.desktopContext?.eventHub.on(SmartDockConstants.DOCK_ZOOM_EVENT, this.onScaleChangeEvent);
  }

  aboutToDisappear(): void {
    log.showInfo('Residentlayout aboutToDisappear');
    DesktopManager.getInstance().unregisterScreenChangeListener(this.singleHandChange);
    SCBSceneSessionManager.getInstance().unregisterUnlockTransitionCallback(this.unLockTransitionController);
    viewMgrPolicy.unRegisterViewCallback(ViewType.KEYGUARD, this.keyguardCallback);
    SCBTransitionManager.getInstance().unRegisterExpandAnimationController(this.expandController);
    if (DeviceHelper.isUltraScreenProduct()) {
      SCBTransitionManager.getInstance().unRegisterTripleAnimationController(this.tripleController);
    }
    this.desktopContext?.eventHub.off(SmartDockConstants.DOCK_HOLDER_NOTIFY_EVENT, this.dockHolderNotifyEvent);
    this.desktopContext?.eventHub.off(SmartDockConstants.RESIDENT_RESHAPE_EVENT, this.residentReshapeEvent);
    this.desktopContext?.eventHub.off(SmartDockConstants.MULTI_WINDOW_EXIT_TRIGGER_RESHAPE_EVENT,
      this.onMultiWindowExitEvent);
    this.desktopContext?.eventHub.off(EventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopModeChangeEvent);
    this.desktopContext?.eventHub.off(SmartDockConstants.ICON_SIZE_CHANGE_EVENT, this.onIconSizeChangeEvent);
    this.desktopContext?.eventHub.off(CommonConstants.DOCK_ICON_REDUCTION, this.iconReductionEvent);
    this.desktopContext?.eventHub.off(SmartDockConstants.DOCK_ZOOM_EVENT, this.onScaleChangeEvent);
    this.uninstallDialogController = null;
    slUiStateMgr.unregisterSlStateChangeListener(this.slStaticStateListener);
  }

  private uninstallDialogController: CustomDialogController | null = new CustomDialogController({
    builder: UninstallDialog({
      cancel: () => {
        this.uninstallDialogController?.close()
      },
      confirm: () => {
        if (DeviceHelper.isPad()) {
          this.mSmartDockViewModel.deleteDockItem(this.clickItem as DeleteDockItem, SmartDockConstants.RESIDENT_DOCK_TYPE);
        } else {
          this.mSmartDockViewModel.uninstallApp(this.clickItem.bundleName as string,
            this.clickItem.isUninstallAble as boolean, this.clickItem.appIndex as number);
          // 卸载主应用时，同步移除未安装的分身应用
          if (this.clickItem.appIndex === 0) {
            this.mSmartDockViewModel.deleteNotInstallApp(true, this.clickItem.bundleName,
              this.clickItem.appIndex, false);
          }
        }
        this.uninstallDialogController?.close()
      },
      dialogName: DeviceHelper.isPad() ?
      $r('app.string.is_delete_form', this.clickItem.appName) : $r('app.string.isUninstall', this.clickItem.appName),
    }),
    cancel: () => {
    },
    autoCancel: true,
    showInSubWindow: true,
    alignment: DialogAlignment.Center,
  });

  sendTouchDownEvent(touchEvent: TouchEvent): void {
    if (touchEvent?.type === TouchType.Down && editModeManager.isInEditMode()) {
      localEventManager.sendLocalEventAsync(EventConstants.EVENT_EDIT_MODE_TOUCH_DOWN_ITEM);
    }
  }

  private getItemKey(item: DockItemInfo): string {
    const itemKey = `${item.keyName}_`;
    return itemKey + `${item.installTime}_${item.appIconId}_${item.iconResource}_${item.appStatus}`;
  }

  private getListOffset(): number {
    return this.mSmartDockStyleConfig.mDockHeight - this.layoutPropertyVm.dockHeight -
      DockRegionLayoutModel.getInstance().getSimpleModeMarginTop();
  }

  @Builder
  backPlaneBuilder() {
    BackPlane({
      mDockHeight: this.layoutPropertyVm.dockHeight,
      mDockRadius: this.layoutPropertyVm.dockRadius,
      backPlaneWidth: SmartDockConstants.PERCENTAGE_100,
      backPlaneId: SmartDockConstants.DOCK_RESIDENT_BG_ID,
      backPlaneTranslate: { x: this.animationVm.translateX, y: this.animationVm.translateY },
      backPlaneScale: {
        x: this.animationVm.scaleSizeX,
        y: this.animationVm.scaleSizeY,
        centerX: this.animationVm.isUnlocking ? this.animationVm.centerX : '100%',
        centerY: this.animationVm.centerY,
      },
      backPlaneOpacity: this.animationVm.alpha,
      backPlaneVisibility: this.animationVm.visible,
      backPlaneBlur: this.animationVm.blurRadius,
      backPlaneUseEffect: true
    })
  }

  build() {
    Stack() {
      // inner border and blur container
      if (this.isBackplaneExist) {
        this.backPlaneBuilder();
      }

      // SmartDock 拖拽落位白框
      this.dragItemPlaceHolder()

      List({ space: this.layoutPropertyVm.space }) {
        if (this.isPcMode) {
          ForEach(this.appList, (item: DockItemInfo, index: number) => {
            PcModeResidentAppItem({
              singleContext: this.singleContext,
              appIconWidth: this.appIconWidth,
              appIconHeight: this.appIconHeight,
              smallGridPadding: this.gridPadding,
              smallGridGap: this.gridGap,
              smallFolderSize: this.layoutPropertyVm.iconSize,
              mSmallFolderRadius: this.layoutPropertyVm.iconRadius,
              mSmallFolderIconRadius: this.mSmallFolderIconRadius,
              appInfo: item,
              buildMenu: this.buildMenu,
              notInstalledMenuMap: this.mSmartDockViewModel.buildNotInstalledAppMenu(item, this.removeDialogController),
              isUnLockReceived: $isUnLockReceived,
              isLockReceived: $isLockReceived,
              mSmartDockStyleConfig: this.mSmartDockStyleConfig,
              region: this.getRegion(index),
              mIconSize: this.layoutPropertyVm.iconSize,
              isBackplaneExist: this.isBackplaneExist,
              itemOnClick: (event?: ClickEvent) => {
                if (editModeManager.isInEditMode()) {
                  return;
                }
                this.checkClickEvent(event as ClickEvent, item);
              }
            })
          }, (item: DockItemInfo, index: number) => {
            return this.getItemKey(item);
          })
        } else {
          ForEach(this.appList, (item: DockItemInfo, index: number) => {
            AppItem({
              singleContext: this.singleContext,
              appIconWidth: this.appIconWidth,
              appIconHeight: this.appIconHeight,
              smallGridPadding: this.gridPadding,
              smallGridGap: this.gridGap,
              smallFolderSize: this.layoutPropertyVm.iconSize,
              mSmallFolderRadius: this.layoutPropertyVm.iconRadius,
              mSmallFolderIconRadius: this.mSmallFolderIconRadius,
              smallFolderText: this.smallFolderText,
              appInfo: item,
              buildMenu: this.buildMenu,
              notInstalledMenuMap: GridLayoutUtil.isAppInstalled(item) ? new Map() :
                this.mSmartDockViewModel.buildNotInstalledAppMenu(item, this.removeDialogController),
              isUnLockReceived: $isUnLockReceived,
              isLockReceived: $isLockReceived,
              mSmartDockStyleConfig: this.mSmartDockStyleConfig,
              region: this.getRegion(index),
              mIconSize: this.layoutPropertyVm.iconSize,
              isBackplaneExist: this.isBackplaneExist,
              itemOnClick: (event?: ClickEvent) => {
                if (editModeManager.isInEditMode()) {
                  return;
                }
                this.checkClickEvent(event as ClickEvent, item);
              }
            })
          }, (item: DockItemInfo, index: number) => {
            return this.getItemKey(item);
          })
        }
      }
      .alignListItem(ListItemAlign.Center)
      .enableScrollInteraction(false)
      .clip(CommonConstants.DEFAULT_CLIP_FALSE)
      .width(this.residentListWidth + this.residentLayoutAdditionWidth)
      .height(this.layoutPropertyVm.dockHeight)
      .padding(this.paddingValue)
      .listDirection(this.mSmartDockStyleConfig.mListDirection)
      .editMode(true)
      .scrollBar(BarState.Off)
      .visibility(this.animationVm.visible)
      .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
    }
    .id(this.isPcMode ? 'PcModeResidentLayout' : 'ResidentLayout')
    .foregroundEffect({ radius: this.animationVm.blurRadius })
    .clip(CommonConstants.DEFAULT_CLIP_FALSE)
    .hitTestBehavior(HitTestMode.Default)
    .alignContent(Alignment.Top)
    .offset({
      top: this.getListOffset()
    })
    .height(this.mSmartDockStyleConfig.mDockHeight)
    .width(this.residentLayoutWidth + this.residentLayoutAdditionWidth)
    .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
    .visibility(Visibility.Visible)
  }

  private checkClickEvent(event: ClickEvent, item: DockItemInfo): void {
    let itemAppStatus: AppStatus = item.appStatus as AppStatus;
    if (itemAppStatus !== AppStatus.INSTALLED && itemAppStatus !== undefined) {
      let downloadStatusInfo: DownloadStatusInfo | undefined =
        AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo(item.bundleName);
      if (downloadStatusInfo && !item.appIndex) {
        itemAppStatus = downloadStatusInfo.status;
      }
    }
    // 如果应用正在安装（更新过程中的安装，第一次下载应用安装由于有动效不需要toast），点击应用弹出toast
    if (AppInstallingDataManager.getInstance().isInstalling(item.bundleName)) {
      AppInstallingDataManager.getInstance().toastInstalling(item.bundleName);
      return;
    }
    if (itemAppStatus === AppStatus.INSTALLED || itemAppStatus === undefined) {
      if (this.onItemClick) {
        this.onItemClick(event, item);
      }
      this.onClickWithPopup = AppStorage.get<boolean>('isClickOpenPopup') as boolean;
      HiSysEventUtil.reportClickAppInDock(item.appName);
      if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        HiSysEventUtil.reportClickShortcut(item.bundleName, item.shortcutId, 'hoteast', '-1',
          '-1', '-1', '-1');
      }
      log.showInfo(`onClick this.onClickWithPopup: ${this.onClickWithPopup}`);
      if (this.onClickWithPopup) {
        this.autoCancel = true;
        this.showPopup = true
        this.onHoverItem = item.bundleName as string;
      }
      AppStorage.setOrCreate('isClickOpenPopup', false);
      return;
    } else if ((item.appIndex && item.appIndex > 0) ||
      item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      // 升级数据迁移，分身应用未安装完成，不响应点击事件
      AppInstallUtils.getInstance().clickTwinApp(item.bundleName);
      return;
    }
    if (itemAppStatus === AppStatus.DOWNLOADING || itemAppStatus === AppStatus.UPDATING) {
      //  调用暂停接口
      AppInstallUtils.getInstance().pauseTask(item.bundleName);
    } else if (itemAppStatus === AppStatus.PENDING || itemAppStatus === AppStatus.WAIT_FOR_HARMONY) {
      if (PreInstallUtils.checkIsNeedInstallAppByIntent(item)) {
        AppInstallUtils.getInstance().requestTask(item);
        this.reportClickAppIcon(item);
      } else {
        //  调用检查接口
        AppInstallUtils.getInstance().checkTask(item);
      }
    } else if (itemAppStatus === AppStatus.PAUSING || itemAppStatus === AppStatus.WIFI_WAITING) {
      //  调用恢复接口
      AppInstallUtils.getInstance().resumeTask(item.bundleName);
    } else if (itemAppStatus === AppStatus.WAITING) {
      AppInstallUtils.getInstance().dealClickPreDownload(item as Object as GridLayoutItemInfo);
    }
  }

  private async reportClickAppIcon(appItem: AppItemInfo | GridLayoutItemInfo): Promise<void> {
    const component: string = appItem.bundleName;
    let containerType: string = 'dock';
    let description: LayoutDescription = LaunchLayoutCacheManager.getInstance().selectLayoutDescription();
    const screenPageCount: number = description ? description.pageCount : 0;
    let position: string = `SCREENCOUNT: ${screenPageCount}SCREENINDEX:${appItem.page}` +
      `CELLX:${appItem.column}CELLY:${appItem.row}isInDock:true`;
  }


  private onInstalledAppClick(event: ClickEvent, item: DockItemInfo): void {
    if (this.onItemClick) {
      this.onItemClick(event, item);
    }
    this.onClickWithPopup = AppStorage.get<boolean>('isClickOpenPopup') as boolean;
    HiSysEventUtil.reportClickAppInDock(item.appName);
    log.showInfo(`onClick this.onClickWithPopup: ${this.onClickWithPopup}`);
    if (this.onClickWithPopup) {
      this.autoCancel = true;
      this.showPopup = true;
      this.onHoverItem = item.bundleName as string;
    }
    AppStorage.setOrCreate('isClickOpenPopup', false);
  }

  onContinueDeviceChange(): void {
    if (ObjUtil.isInvalid(this.deviceInfo) || ObjUtil.isInvalid(this.deviceInfo.bundleName) ||
    ObjUtil.isInvalid(this.deviceInfo.sourceDeviceName)) {
      log.showInfo('onContinueDeviceChange set false');
      if (!this.isShowContinuableItem) {
        return;
      }
      this.setContinueShow(false);
    } else {
      log.showInfo('onContinueDeviceChange set true: ' + this.deviceInfo.bundleName);
      if (this.isBackplaneExist) {
        return;
      }
      this.setContinueShow(true);
    }
  }

  setContinueShow(isShow: boolean): void {
    if (isShow) {
      animateTo({
        duration: SmartDockConstants.CONTINUABLE_ICON_SHOW_DURATION,
        curve: SmartDockConstants.CONTINUABLE_ICON_SHOW_ANIMATION,
        onFinish: () => {
          log.showInfo(`setContinueShow isShow = ${this.isShowContinuableItem}`);
        }
      }, () => {
        let isMergeContinueItem: boolean = this.findContinueItemInResident();
        this.isShowContinuableItem = isShow && !isMergeContinueItem;
        this.refreshLayout();
      });
      AppStorage.setOrCreate('isShowContinuableItem', this.showContinuableItem());
      return;
    }

    AppStorage.setOrCreate('isShowContinuableItem', false);
    animateTo({
      duration: SmartDockConstants.CONTINUABLE_ICON_MOVE_DURATION,
      curve: SmartDockConstants.CONTINUABLE_ICON_SHOW_ANIMATION,
      onFinish: () => {
        log.showInfo(`setContinueShow isShow = ${this.isShowContinuableItem}`);
      }
    }, () => {
      this.isShowContinuableItem = isShow;
    })

    animateTo({
      duration: SmartDockConstants.CONTINUABLE_ICON_MOVE_DURATION,
      curve: SmartDockConstants.CONTINUABLE_ICON_SHOW_ANIMATION,
      delay: SmartDockConstants.CONTINUABLE_ICON_MOVE_DELAY
    }, () => {
      this.refreshLayout();
    })
  }

  private getResidentWidth(): number {
    if (!this.isBackplaneExist) {
      return this.mScreenWidth;
    }
    let num = this.getVisibleCount();
    if (num > this.mResidentMaxNum && !SmartDockZoomFeatureSwitch.isSupportZoom()) {
      num = this.mResidentMaxNum;
    }
    // 列表为空时，默认保持一个图标的宽度
    if (num === 0) {
      num = 1;
    }
    // dock栏内拖拽创建或者添加进文件夹时，dock栏需要保持落位前宽度，文件夹相关动效完成后复原
    if (SmartDockDragHandler.getInstance(this.singleContext).getEmptyItemExist()) {
      num += 1;
    }
    return this.layoutPropertyVm.calculateRegionWidth(num);
  }

  private getListPadding(): RectInfo {
    let screenWidth: number = AppStorage.get<number>('screenWidth') as number;
    if (this.isBackplaneExist) {
      screenWidth = this.residentLayoutWidth;
    }
    let num: number = this.appList.length;
    if (num < this.mSmartDockStyleConfig.mMaxDockNum) {
      num += this.showContinuableItem() ? 1 : 0;
    }
    const layoutModel = DockRegionLayoutModel.getInstance();
    const padding: number =
      (screenWidth - (num * layoutModel.getListItemWidth() + (num - 1) * layoutModel.getSpace(num))) / 2;
    let rectInfo = new RectInfo();
    rectInfo.left = padding;
    rectInfo.right = padding;
    return rectInfo;
  }

  private findContinueItemInResident(): boolean {
    let item = this.appList.find((value) =>
    value.bundleName === this.deviceInfo.bundleName && value.appIndex === 0 && value.typeId === 0
    );
    log.showWarn(`deviceInfo: ${this.deviceInfo.bundleName}, find continueItem in resident ${CheckEmptyUtils.isEmpty(item)}`);
    return !CheckEmptyUtils.isEmpty(item);
  }

  private onDockListChange(): void {
    SettingsModel.getInstance().setResidentList(this.appList);
    if (this.onDockListChangeFunc) {
      this.onDockListChangeFunc();
    }
    // 拖拽场景通过onScaleChange缩放
    if (SmartDockZoomFeatureSwitch.isSupportZoom() && !this.isDrag) {
      SmartDockZoomEvent.getInstance().onDockRefresh(DockRegionType.RESIDENT, this.getVisibleCount());
      this.refreshSmallFolderStyleConfig();
    }
    this.refreshLayout();
    if (this.isBackplaneExist) {
      return;
    }
    // 接续组网状态时，有两个场景需要接续图标不显示：1.合并接续图标合成文件夹时 2.接续图标在文件夹里并被拖出到dock
    let needToShowContinuableItem: boolean =
      !!this.deviceInfo && !!this.deviceInfo.bundleName &&
      !this.isDrag && !SmartDockDragHandler.getInstance(this.singleContext).getEmptyItemExist();
    if (this.findContinueItemInResident()) {
      this.setContinueShow(false);
    } else if (needToShowContinuableItem) {
      this.isShowContinuableItem = true;
      this.refreshLayout();
      AppStorage.setOrCreate('isShowContinuableItem', this.showContinuableItem());
    }
    log.showInfo(`dockListChange, length: ${this.appList?.length}, width: ${this.residentLayoutWidth},` +
      ` listWidth: ${this.residentListWidth}, iconSize: ${this.layoutPropertyVm.iconSize},` +
      ` padding: ${this.paddingValue},  space: ${this.layoutPropertyVm.space}`);
  }

  private folderStatusChange(): void {
    if (this.folderStatus === DeviceState.DEFAULT_STATE) {
      this.isBackplaneExist = false;
    } else {
      this.isBackplaneExist = true;
    }
    this.onDockListChange();
    AppStorage.setOrCreate('isShowContinuableItem', this.showContinuableItem());
    log.showInfo(`folderStatusChange, length: ${this.appList?.length}, width: ${this.residentLayoutWidth},` +
      ` iconSize: ${this.layoutPropertyVm.iconSize}, space: ${this.layoutPropertyVm.space},` +
      ` folderStatus: ${this.folderStatus}`);
  }

  private onResidentReshape(num: number): void {
    if (!this.isBackplaneExist) {
      return;
    }
    if (SmartDockZoomFeatureSwitch.isSupportZoom()) {
      SmartDockZoomEvent.getInstance().onDragSqueezing(num);
    }
    // 在dock区存在backplane时，接续图标显示在recent区，拖拽过程中dock区宽度只与solution中图标数相关
    let oldWidth: number = this.residentLayoutWidth;
    let newWidth: number = this.layoutPropertyVm.calculateRegionWidth(num);
    // 过滤solution长度为0和dock栏宽度无变化的场景（solution中图标为0时，默认保持一个图标宽度）
    if (num === 0 || oldWidth === newWidth) {
      return;
    }

    log.showInfo('onResidentReshape start, oldWidth: %{public}d newWidth: %{public}d', oldWidth, newWidth);
    animateTo({
      duration: SmartDockZoomAnimationConfig.getAnimationDuration(),
      curve: SmartDockZoomAnimationConfig.getAnimationCurve(),
    }, () => {
      this.residentLayoutWidth = newWidth;
    })
  }

  private refreshLayout(): void {
    this.layoutPropertyVm.reloadLayoutProperties(this.getVisibleCount())
    this.residentLayoutWidth = this.getResidentWidth();
    this.residentListWidth = this.residentLayoutWidth;
    this.paddingValue = this.getListPadding();
  }

  private onThemeChange(): void {
    this.refreshSmallFolderStyleConfig();
    this.refreshLayout();
    log.showInfo('Theme style change, length: %{public}d, width: %{public}d, iconSize: %{public}d, space: %{public}d' +
      ', dockHeight: %{public}d', this.appList?.length, this.residentLayoutWidth, this.layoutPropertyVm.iconSize,
      this.layoutPropertyVm.space, this.layoutPropertyVm.dockHeight);
  }

  private onAnimationChange(): void {
    log.showInfo('onAnimationChange, animationVm translateX:%{public}d, translateY:%{public}d, scaleSizeX:%{public}d' +
      ', scaleSizeY:%{public}d, centerX:%{public}s, centerY:%{public}s.', this.animationVm.translateX,
      this.animationVm.translateY, this.animationVm.scaleSizeX, this.animationVm.scaleSizeY,
      this.animationVm.centerX.toString(), this.animationVm.centerY.toString());
  }
}

@Component
struct AppItem {
  @StorageLink('dragItemType') dragItemType: number = CommonConstants.DRAG_FROM_DOCK;
  @Prop singleContext?: SingleContext;
  @Consume('convertFolderId') convertFolderId: string;
  @Consume('startConvert') startConvert: number;
  @State isShow: boolean = false;
  @State itemScale: number = 1;
  @Link @Watch('onUnLockReceived') isUnLockReceived: boolean;
  @Link @Watch('onLockReceived') isLockReceived: boolean;
  @StorageProp('screenWidth') screenWidth: number = 0;
  @StorageProp('screenHeight') screenHeight: number = 0;
  @StorageLink('residentList') @Watch('onDockListChange') appList: Array<DockItemInfo> = [];
  appInfo: DockItemInfo = new DockItemInfo();
  buildMenu?: Function;
  @State dockItemPotentialLocationOpacityOn: number = 0;
  @State dockItemPotentialLocationOpacityOff: number = 1;
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
  @State isRemoved: boolean = false;
  private region: number = 0;
  @Prop smallFolderText: string = '';
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @StorageLink('isDrag') isDrag: boolean = false;
  private foldController?: SCBFoldController;
  private expandController?: SCBExpandController;
  private tripleController?: SCBTripleController;
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
  private mGridSize: number = 0;
  private mFolderAppSize: number = 0;
  private mFolderRadius: number = 0;
  @Prop appIconWidth: number = 0;
  @Prop appIconHeight: number = 0;
  @Prop smallGridGap: number = 0;
  @Prop smallGridPadding: number = 0;
  @Prop smallFolderSize: number = 0;
  @Prop mSmallFolderRadius: number = 0;
  @Prop mSmallFolderIconRadius: number = 0;
  private mClosedFolderIconRadius: number = 0;
  @State itemAppStatus: AppStatus = AppStatus.INSTALLED;
  private notInstalledMenuMap: Map<AppStatus, MenuInfo[]> = new Map();
  @State isMenuShow: boolean = false;
  @State isAppBackplaneAppear: boolean = false;
  @State isInAppBackplaneBigAnimation: boolean = false;
  @State isInAppBackplaneSmallAnimation: boolean = false;
  @Consume @Watch('dockItemOpacityAnimation') companionIconInfo: CompanionIconInfo;
  private isBackplaneExist: boolean = false;
  private dragEventCallback: DragEventCallback = {};
  private itemKey: string = '';
  private appGalleryStatusChangeEventId: string = '';
  private isTouchUp = false;
  private appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
  private iconReductionEvent: (index: number) => void = (index) => this.onDockIconReduction(index);
  private onScaleChangeEvent: (index: number) => void = () => this.onScaleChange();
  private appIconActiveEvent: AppIconActiveEventIface = {
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
  itemOnClick: Function = (event?: ClickEvent) => {
  };
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
  @StorageLink('folderStatusMenu') @Watch('folderStatusChange') folderStatus: number = DeviceState.DEFAULT_STATE;
  @StorageLink('continueDeviceInfo') @Watch('onContinueDeviceChange') deviceInfo: DockContinuableInfo =
    new DockContinuableInfo();
  @State isHiddenEffect: boolean = false;
  @State dragIcon: string | PixelMap = this.updateIconImage();
  @State iconBadgeVm: AppIconBadgeVm = new AppIconBadgeVm();
  @State continueBadgeVisible: boolean = true;
  @State animationVm: DockItemAnimationVm = new DockItemAnimationVm();
  @State layoutPropertyVm: DockRegionLayoutPropertyVm = SmartDockObserver.getInstance().getLayoutPropertyVm();
  private animationEvent: DockItemAnimationEvent = new DockItemAnimationEvent(this.animationVm);
  @State desktopStyle: DeskTopItemStyle | undefined = undefined;
  @Provide translateX: number = 0;
  @Provide translateY: number = 0;
  deviceType: string = '';
  private startSqueezeEvent: Function =
    (center: number, immediate: boolean): void => this.dockItemMoveAnimationFunc(center, immediate);
  private cancelSqueezeEvent: Function = (): void => {
    this.animationVm.translateX = 0
  };
  private coveredItemEvent: Function = (isShow: boolean): void => this.onEventhubCoveredItemEvent(isShow);
  private cancelItemEvent: Function = (isCancel: boolean): void => this.onEventhubCancelItemEvent(isCancel);
  private appIconConfig: AppIconConfig = new AppIconConfig();
  private isAppIconDrag: boolean = true;
  private appIconMenuVm = new AppIconMenuVm();
  private appNameVm: AppNameVm = new AppNameVm();
  private iconModifier: AppIconDefaultModifier = new AppIconDefaultModifier();

  private folderStatusChange(): void {
    if (this.isMenuShow) {
      this.isHiddenEffect = true;
    }
  }

  private onScaleChange(): void {
    this.iconBadgeVm.ratio = this.layoutPropertyVm.scale;
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

  /**
   * 拖拽落位过程中显隐角标
   */
  private onEqualToDropItemChange(): void {
    log.showInfo(`onEqualToDropItemChange, isInDrag: ${this.isInDrag},Continuable`);
    if (this.isContinueMerged(this.appInfo)) {
      this.continueBadgeVisible = !this.isInDrag;
    }
    if (this.isInDrag) {
      this.badgeAnimate = BadgeAnimationType.DEFAULT;
    } else {
      this.badgeAnimate = BadgeAnimationType.DRAG_DROP;
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
   * 拖动app到app触发动效：APP背板放大 || 缩小
   *
   * @param isAppBackplaneOpen app背板是否放大
   */
  private showAppBackplaneAnimate(isAppBackplaneOpen: boolean): void {
    // 锁定布局时不显示动效
    if (lockLayoutManager.isLockLayout()) {
      return;
    }
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
        onFinish: () => {
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

  private showAppFromDialog(isCancel: boolean): void {
    if (isCancel) {
      animateTo({
        curve: curves.springMotion(0.468, 0.63),
        onFinish: () => {
          this.isShowingUninstallDialog = UninstallDialogStatus.INITIAL_STATE;
          this.dragToUninstallItemInfo = new DockItemInfo();
        }
      }, () => {
        this.animationVm.scaleSize = 1;
      })
    }
  }

  private dockAppIconOpacity: Function = (opacityScale: number): void => {
    this.animationVm.alpha = opacityScale;
  };

  /* 提供在非拖拽场景的index/column索引接口 */
  private getIndex(): number {
    return this.appList.findIndex((item) => item.keyName === this.appInfo.keyName);
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

  private updateCurrentData(folder: GridLayoutItemInfo): void {
    log.showInfo(`resident folder updateCurrentData`);
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
        (param: GravityAnimationParameter) => {
          this.animationEvent.startGravityAnimation(param, this.appInfo);
        },
        () => {
          this.updatePosition();
        });
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

  private initAppIconConfig(): void {
    this.appIconConfig
      .setEnableNameAnim(false)
      .setEnableMultiSelect(false)
      .setEnableBackplane(false)
      .setEnableHoverAnimation(true)
      .setEnableSupportCheckAndFix(true)
      .setAppDataOfTransactionController(AppDataWrapper.getDefaultAppData(this.appInfo,
        this.mSmartDockStyleConfig.mIconRadius))
      .setIsDesktopItem(false)
      .setKeepMenuOrder(true)
      .setExternCb({
        getNotInstalledMenuMap: () => this.notInstalledMenuMap,
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
          return this.initMenuInfo();
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
        },
        onIconClick: (event?: ClickEvent, fingers?: number): void => {
          log.showInfo('onClick icon');
          this.itemOnClick(event);
        },
        onMenuDragStart: (x: number, y: number): void => {
          this.isAppIconDrag = false;
          PageDesktopDragHandler.getInstance(this.singleContext).onDragStart(x, y);
        }
      });
    // 预览图底部margin设置为0，防止菜单生成时组件位置突变
    // dock在屏幕底端，下方设置有24vp的安全间隔，由于与导航条间隔太近，会使预览图生成的时候往上偏，预期是菜单原地生成，因此将该属性设为0
    this.appIconMenuVm.setLayoutRegionMargin({ bottom: 0 });
  }

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
    this.mGridSize = folderStyleConfig.mGridSize;
    this.mFolderAppSize = folderStyleConfig.mFolderAppSize;
    this.mFolderRadius = folderStyleConfig.mFolderRadius as number;
    this.mClosedFolderIconRadius = folderStyleConfig.mClosedFolderIconRadius ?? 0;
    this.mIconSize = DockRegionLayoutModel.getInstance().getIconSize();
    if (!GridLayoutUtil.isAppInstalled(this.appInfo)) {
      let downloadInfo: DownloadStatusInfo | undefined =
        AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo(this.appInfo.bundleName);
      this.itemAppStatus = (downloadInfo ? downloadInfo.status : this.appInfo.appStatus) as AppStatus;
    }
    this.getSmallFolderItem();
    if (this.appInfo.itemType === CommonConstants.TYPE_FOLDER) {
      FolderDataModelManager.getInstance().updateFolderDataModel(this.mFolderItemInfo);
      this.mFolderViewModel.registerFolderLayoutChangeListener(this.mFolderItemInfo, this.folderLayoutChangeListener);
    }
    log.showInfo(`aboutToAppear: mFolderItemInfo: ${this.mFolderItemInfo.id}  ${this.mFolderItemInfo.folderId} ${this.mFolderItemInfo.folderName}`);
    log.showInfo(`aboutToAppear: appInfo: ${this.appInfo.id} ${this.appInfo.bundleName} ${this.appInfo.appIndex} ${this.appInfo.typeId} ${this.appInfo.appName}`);
    this.initContinueBadgeStatus();
    this.initAppIconConfig();

    if (!GridLayoutUtil.isAppInstalled(this.appInfo)) {
      if (this.appInfo.bundleName) {
        this.appGalleryStatusChangeEventId =
          `appGalleryStatusChange${this.appInfo.bundleName}${this.appInfo.appIndex}item`;
        this.desktopContext?.eventHub.off(this.appGalleryStatusChangeEventId);
        this.desktopContext?.eventHub.on(this.appGalleryStatusChangeEventId,
          (eventInfo: AppGalleryEventInfo): void => this.appGalleryStatusChangeEvent(eventInfo));
        log.showInfo(`onEventhubAppDownloadStatusChangedEvent for AppName ${this.appGalleryStatusChangeEventId}`);
      }
    }
    viewMgrPolicy.registerViewCallback(ViewType.KEYGUARD, this.keyguardCallback);
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
    if (DeviceHelper.isUltraScreenProduct()) {
      this.tripleController = {
        itemId: `${TAG}_dock`,
        onTripleAnimation: (oldState: ScreenState, newState: ScreenState, isNeedAnimation: boolean) =>
        this.tripleAppItemAnimation(oldState, newState, isNeedAnimation),
      };
      SCBTransitionManager.getInstance().registerTripleAnimationController(this.tripleController);
    }
    this.registerEventhub();
    this.registerDragEvent();
    this.initDragParam();
    this.registerGravityAnimation();
    let iconOpacity: string = `Opacity_${DockUtils.getDockItemId(this.appInfo)}.${this.appInfo.abilityName}.` +
      `${this.appInfo.moduleName}.${this.appInfo.typeId}`;
    this.desktopContext?.eventHub.on(iconOpacity, this.dockAppIconOpacity);
    if (SmartDockDragHandler.getInstance(this.singleContext).getEmptyItemExist()) {
      this.animationVm.translateX =
        SmartDockDragHandler.getInstance(this.singleContext).getDockItemTranslate(this.appInfo.keyName ?? '');
    }
    SmartDockEventMgr.getInstance(this.singleContext).setUIContext(this.getUIContext());
    this.appIconCommonEvent.setIconActiveEvent(this.appIconActiveEvent);
  }

  private initDragParam(): void {
    const dragItemInfo: GridLayoutItemInfo = AppStorage.get<GridLayoutItemInfo>('dragItemInfo') as GridLayoutItemInfo;
    const isInDropAnimation = dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP, this.itemKey);
    this.isDragStart = GridLayoutUtil.generateUniqueKey(dragItemInfo) === this.itemKey && !isInDropAnimation;
    this.isInDrag = this.isDragStart || isInDropAnimation;
    log.showInfo(`initDragParam key:${this.itemKey} isDragStart:${this.isDragStart} isInDrag:${this.isInDrag}`);
  }

  private registerDragEvent(): void {
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
        AppStorage.setOrCreate('isDockItemMove', false);
        this.isInDrag = false;
        this.gravity?.setActive(true);
        dragSnapshotHelper.releaseSnapshot(SnapshotType.BOTH, this.itemKey);
      }
    };
    DragEventManager.getInstance().registerDragEvent(this.dragEventCallback, this.itemKey);
  }

  private unregisterDragEvent(): void {
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
    this.animationEvent.foldedAnimation(this.screenWidth, this.getIndex(), this.appList.length);
  }

  private expandedAnimation(): void {
    log.showInfo('dock execute expandedAnimation');
    this.animationEvent.expandedAnimation(this.screenWidth, this.screenHeight, DockUtils.getDockItemId(this.appInfo),
      this.getIndex());
  }

  private tripleAppItemAnimation(oldState: ScreenState, newState: ScreenState, isNeedAnimation: boolean): void {
    log.showInfo(`resident dock item execute tripleAnimation, oldState is ${oldState}, newState is ${newState}`);
    if (!isNeedAnimation) {
      log.showInfo(`resident dock item noneed tripleAnimation`);
      return;
    }
    let stateChange: SCBTripleStateChange = UltraScreenExpandAnimUtils.getTripleDesktopStateChange(newState, oldState);
    let col: number[] = UltraScreenExpandAnimUtils.getTripleDockColumn(this.getIndex());
    animateTo({
      duration: 0,
    }, () => {
      this.animationVm.translateX =
        UltraScreenExpandAnimUtils.initTripleDockAnimTranslateX(this.screenWidth, stateChange);
      this.animationVm.alpha = UltraScreenExpandAnimUtils.initTripleResidentDockItemAnimAlpha(stateChange);
    });
    animateTo({
      curve: UltraScreenAnimationConstants.TRANSLATE_CURVES,
      duration: UltraScreenAnimationConstants.ANIMATION_DURATION,
    }, () => {
      this.animationVm.translateX = 0;
    });
    let alphaDelayTime: number = UltraScreenExpandAnimUtils.getUltraScreenExpandAlphaDelayTime(col[0], stateChange);
    animateTo({
      curve: Curve.Linear,
      delay: alphaDelayTime,
      duration: UltraScreenAnimationConstants.ALPHA_DURATION,
    }, () => {
      this.animationVm.alpha = 1;
    });
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
      this.mFolderItemInfo.appStatus = this.appInfo.appStatus;
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
    this.animationEvent.onScreenOn();
  }

  aboutToDisappear(): void {
    viewMgrPolicy.unRegisterViewCallback(ViewType.KEYGUARD, this.keyguardCallback);
    SCBTransitionManager.getInstance().unRegisterFoldAnimationController(this.foldController);
    SCBTransitionManager.getInstance().unRegisterExpandAnimationController(this.expandController);
    if (DeviceHelper.isUltraScreenProduct()) {
      SCBTransitionManager.getInstance().unRegisterTripleAnimationController(this.tripleController);
    }
    this.unregisterDragEvent();
    this.unregisterGravityAnimation();
    this.unregisterEventhub();
    let iconOpacity: string = `Opacity_${DockUtils.getDockItemId(this.appInfo)}.${this.appInfo.abilityName}.` +
      `${this.appInfo.moduleName}.${this.appInfo.typeId}`;
    this.desktopContext?.eventHub.off(iconOpacity, this.dockAppIconOpacity);
    if (this.appInfo.itemType === CommonConstants.TYPE_FOLDER) {
      this.mFolderViewModel.unregisterFolderLayoutChangeListener(this.mFolderItemInfo,
        this.folderLayoutChangeListener);
    }
    if (!CheckEmptyUtils.isEmpty(this.appGalleryStatusChangeEventId)) {
      this.desktopContext?.eventHub.off(this.appGalleryStatusChangeEventId);
    }
  }

  private onLockReceived(): void {
    log.showDebug(`onLockReceived, isLockReceived: ${this.isLockReceived}`);
    if (!this.isLockReceived) {
      return;
    }
    this.animationEvent.lockAnimation(this.screenWidth, this.screenHeight, DockUtils.getDockItemId(this.appInfo));
  }

  private onUnLockReceived(): void {
    log.showDebug(`onUnLockReceived, isUnLockReceived: ${this.isUnLockReceived}`);
    if (this.isUnLockReceived === false) {
      return;
    }
    if (!(AppStorage.get<boolean>('shieldAnim') ?? false)) {
      this.animationEvent.unlockAnimation(this.screenWidth, this.screenHeight, DockUtils.getDockItemId(this.appInfo),
        () => {
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
  }

  private dockItemMoveAnimationFunc(newCenterX: number, immediate: boolean): void {
    const oldIndex: number = this.appList.findIndex((item: DockItemInfo) => item.keyName === this.appInfo.keyName);
    if(SmartDockZoomFeatureSwitch.isSupportZoom()) {
      //嵌套if用于SmartDockZoomManager懒加载
      if (SmartDockZoomManager.isZoom()) {
        const offsetForScaleChange: number = this.layoutPropertyVm.listPadding *
          (this.layoutPropertyVm.scale -
          DockRegionLayoutModel.getInstance().calculateScaleWithRegionNum(this.appList.length)) /
        this.layoutPropertyVm.scale;
        this.animationEvent.moveAnimation(newCenterX + offsetForScaleChange, immediate, this.appInfo.keyName ?? '',
          this.appList.length, oldIndex);
        return;
      }
    }
    this.animationEvent.moveAnimation(newCenterX, immediate, this.appInfo.keyName ?? '', this.appList.length, oldIndex);
  }

  @Builder
  IconBuilder(resource: string | PixelMap) {
    Image(resource)
      .draggable(false)
      .width(this.mIconSize)
      .height(this.mIconSize)
      .borderRadius(this.mSmartDockStyleConfig.mIconRadius)
      .backgroundImage(ShortcutViewModel.getInstance().getShortcutBackgroundImage(this.appInfo))
      .backgroundImageSize(ImageSize.Cover)
      .backgroundImagePosition(Alignment.Center)
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
      return ShortcutViewModel.getInstance().getShortcutImageSync(this.appInfo);
    } else {
      return IconResourceManager.getInstance().getCachedCombIconSync(this.appInfo.bundleName,
        this.appInfo.moduleName as string, this.appInfo.abilityName);
    }
  }

  @Builder
  AppPixmapCreator() {
    Stack() {
      if (this.itemAppStatus !== AppStatus.INSTALLED) {
        if (this.appInfo.iconResource) {
          this.IconBuilder(this.appInfo.iconResource);
        } else {
          this.IconBuilder(this.updateIconImage());
        }
      } else {
        this.IconBuilder(this.dragIcon);
      }
    }
  }

  @Builder
  FolderPixmapCreator(cachedIcon: string) {
    this.IconBuilder(cachedIcon);
  }

  private isPcOrPadLauncher(): boolean {
    return SettingsModel.getInstance().getDevice() !== CommonConstants.DEFAULT_DEVICE_TYPE &&
      this.appInfo.bundleName === CommonConstants.LAUNCHER_BUNDLE;
  }

  private getAppIcon() {
    if (this.isPcOrPadLauncher() && this.appInfo.abilityName === CommonConstants.APPCENTER_ABILITY) {
      return StyleConstants.DEFAULT_ALL_APP_IMAGE;
    } else if (this.isPcOrPadLauncher() && this.appInfo.abilityName === CommonConstants.RECENT_ABILITY) {
      return StyleConstants.DEFAULT_TASK_IMAGE;
    } else {
      let icon = IconResourceManager.getInstance().getCachedCombIconSync(this.appInfo.bundleName,
        this.appInfo.moduleName, this.appInfo.abilityName, this.appInfo.appIndex, 'CombIcon_ResidentLayout');
      if (CheckEmptyUtils.isEmpty(icon)) {
        log.showWarn('get icon from getCombIcon');
        IconResourceManager.getInstance().getCombIcon(this.appInfo.bundleName, this.appInfo.moduleName,
          this.appInfo.abilityName)
          .then((image) => {
            icon = image
          })
          .catch((err: Error) => {
            log.showError('getCombIcon error error %{public}s', err.message);
          });
      }
      return icon;
    }
  }

  private onDockListChange(): void {
    let isExist: boolean = false;
    const folderMgr: FolderManager = FolderManager.getInstance();
    const isFolderOpen: boolean = folderMgr.isFolderOpen();
    this.appList.forEach((info: DockItemInfo, index: number) => {
      if (info.keyName !== this.appInfo.keyName) {
        return;
      }
      isExist = true;
      if (info.itemType === CommonConstants.TYPE_APP) {
        this.appInfo = info;
      } else if (info.itemType === CommonConstants.TYPE_FOLDER) {
        info.column = index;
        this.appInfo = info;
        this.getSmallFolderItem();
        log.showInfo(`onDockListChange  ${this.mFolderItemInfo.layoutInfo?.flat().length}`);
      }
    });
    this.isRemoved = !isExist;
  }

  private onDockIconReduction(index: number): void {
    if(DeviceHelper.isPhone() && !GridLayoutUtil.isLargeFoldOrTrifoldExpanded()) {
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
    if(SmartDockZoomFeatureSwitch.isSupportZoom()) {
      //嵌套if用于SmartDockZoomManager懒加载
      if(SmartDockZoomManager.isZoom()){
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

  dragStart(event?: DragEvent): DragItemInfo {
    this.isMenuShow = false;
    AppStorage.setOrCreate('isDrag', true);
    this.dragItemType = CommonConstants.DRAG_FROM_DOCK;
    this.appInfo.area = [1, 1];
    if (this.appInfo.typeId === CommonConstants.TYPE_FOLDER) {
      SettingsModel.getInstance().getResidentList().forEach((dockItem: DockItemInfo) => {
        if (dockItem?.keyName === this.mFolderItemInfo?.keyName && dockItem.typeId === CommonConstants.TYPE_FOLDER) {
          log.showInfo('dragStart update folder name, before: ' + this.mFolderItemInfo.appName + ', after: ' +
          dockItem.appName);
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
      const center: number[] = SmartDockDragHandler.getInstance(this.singleContext).getDockItemPosition(this.getIndex());
      const startPosition: DragItemPosition = {
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
  private renameClick(): void {
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

  private convertToBigFolder(): void {
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
    BigFolderViewModel.getInstance().openFolder(false, folderItem);
  }

  private dealDragStart: (event: DragEvent) => CustomBuilder | DragItemInfo = (event: DragEvent) => {
    return this.dragStart(event);
  }

  @Styles
  itemGesture() {
    .visibility(this.animationVm.visible)
    .scale({ x: this.itemScale, y: this.itemScale })
    .onHover((isHover: boolean): void => this.handleHoverEvent(isHover))
    .parallelGesture(
      LongPressGesture({ repeat: false, duration: 250 })
        .onAction((event?: GestureEvent) => {
          log.showInfo('onAction start');
          this.isShow = true;
          AppStorage.setOrCreate('isLongPress', true);
          let rect: RectInfo = ItemUtils.getRectById(DockUtils.getDockItemId(this.appInfo));
          let appIconInfo: LongPressAppIconInfo = {
            badgeNumber: this.appInfo.badgeNumber as number,
            iconSize: this.mIconSize,
            iconId: this.appInfo.appIconId as number,
            bundleName: this.appInfo.bundleName as string,
            moduleName: this.appInfo.moduleName as string,
            icon: this.getAppIcon(),
            positionX: rect.left,
            positionY: rect.top,
            item: this.appInfo as DockItemInfo
          }
          AppStorage.setOrCreate('appIconInfo', appIconInfo);
          const isSmallFolder: boolean = this.appInfo.itemType === CommonConstants.TYPE_FOLDER;
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
        })
    )
    .onTouch((event?: TouchEvent) => {
      log.showInfo(`onTouch event type: ${event?.type}`);
      if (AppStorage.get<boolean>('isDrag')) {
        this.isShow = false;
      }
      if (event?.type === CommonConstants.TOUCH_TYPE_DOWN) {
        log.showInfo('onTouch down start');
        this.isTouchUp = false;
      } else if (event?.type === CommonConstants.TOUCH_TYPE_UP) {
        this.dealWithTouchUp();
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
            new AppIconEventData({
              bundleName: this.appInfo.bundleName as string,
              isLongPress: true,
              type: 'longPressZoomIn'
            }));
        })
    )
  }

  private handleHoverEvent(isHover: boolean): void {
    HoverAnimationUtil.hoverEffect(isHover, true, (hoverScale: number) => {
      this.itemScale = hoverScale;
    });
  }

  private dealWithTouchUp(): void {
    if (this.initMenuInfo().length === 0) {
      this.isTouchUp = false;
      if (!editModeManager.isInEditMode()) {
        setTimeout(() => {
          this.badgeAnimate = BadgeAnimationType.TOUCH_UP;
        }, 450)
      }
    } else {
      this.isTouchUp = true;
    }
  }

  private initMenuInfo(): MenuInfo[] {
    if (GridLayoutUtil.isAppInstalled(this.appInfo)) {
      return this.buildMenu?.(this.appInfo);
    } else {
      return this.notInstalledMenuMap.get(this.appInfo.appStatus as AppStatus) ?? [];
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
    .backgroundBlurStyle(BlurStyle.Thin, { policy: 1 }, { disableSystemAdaptation: true })
    .translate({ x: this.animationVm.translateX, y: this.animationVm.translateY })
    .id(`${TAG}_Column_backboard`)
  }

  private isContinueMerged(appInfo: DockItemInfo): boolean {
    return this.deviceInfo && appInfo.appIndex === 0 && appInfo.typeId === CommonConstants.TYPE_APP &&
      this.deviceInfo.bundleName === appInfo.bundleName;
  }

  private onContinueDeviceChange(): void {
    let isIconBadgeCustom = this.isContinueMerged(this.appInfo);
    log.showWarn(`ContinuableViewModel : onContinueDeviceChange ,${isIconBadgeCustom}`);
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

  private isSimpleLayoutMode(): boolean {
    return LayoutViewModel.getInstance().getDesktopModel() === DesktopLayoutState.SIMPLE_LAUNCHER_MODEL;
  }

  private getDeviceTypeIconOffset(): LocalizedEdges {
    let marginSize: number = this.isSimpleLayoutMode() ? SmartDockConstants.SIMPLE_TYPE_ICON_MARGIN :
    SmartDockConstants.TYPE_ICON_MARGIN;
    let deviceTypeBgSize: number =
      this.isSimpleLayoutMode() ? SmartDockConstants.DEVICE_TYPE_SIMPLE_BG_SIZE_DEFAULT :
      SmartDockConstants.DEVICE_TYPE_BG_SIZE_DEFAULT;
    return {
      top: LengthMetrics.vp(-marginSize * this.layoutPropertyVm.scale),
      start: LengthMetrics.vp(this.mIconSize + (marginSize - deviceTypeBgSize) * this.layoutPropertyVm.scale)
    };
  }

  @Builder
  residentLayoutIconBuilder() {
    ListItem() {
      AppIconCommonView({
        item: this.appInfo,
        appIconConfig: this.appIconConfig,
        iconRadius: this.layoutPropertyVm.iconRadius,
        iconSize: this.mIconSize,
        isInDrag: this.isInDrag,
        isDragStart: this.isDragStart,
        iconBadgeVm: this.iconBadgeVm,
        iconMenuVm: this.appIconMenuVm,
        appNameVm: this.appNameVm,
        iconEvent: this.appIconCommonEvent,
        iconModifier: this.iconModifier,
        nameSize: 0
      });
    }
    .foregroundEffect({ radius: this.animationVm.blurRadius })
    .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
    .width(this.mIconSize)
    .height(this.mIconSize)
    .zIndex(1)
    .backgroundColor(this.mSmartDockStyleConfig.mItemBackgroundColor)
    .borderRadius(this.mSmartDockStyleConfig.mItemBorderRadius)
    .visibility(this.animationVm.visible === Visibility.Hidden ||
      (AppStorage.get<string>('device') === CommonConstants.DEFAULT_DEVICE_TYPE &&
        (this.isDragStart || this.isShowCancelDialog())) ? Visibility.Hidden : Visibility.Visible)
    .translate({ x: this.animationVm.translateX, y: this.animationVm.translateY })
    .scale(this.getScaleOptions())
    .opacity(this.animationVm.alpha)
    .id(DockUtils.getDockItemId(this.appInfo))
    .hitTestBehavior(this.editModeState.isInEditMode() ? HitTestMode.None : HitTestMode.Default)
  }

  private getScaleOptions(): ScaleOptions {
    return {
      x: this.animationVm.scaleSize,
      y: this.animationVm.scaleSize,
      centerX: this.animationVm.centerX,
      centerY: this.animationVm.centerY,
    };
  }

  private readerAccessibilityDock(): void {
    if (AppStorage.get<boolean>('hadFocusDock')) {
      AppStorage.setOrCreate<string>('accessibility_dock', '');
      return;
    }
    AppStorage.setOrCreate<string>('accessibility_dock',
      `${ResourceManager.getInstance().getStringByName('accessibility_dock')},`);
    AppStorage.setOrCreate<boolean>('hadFocusDock', true);
  }

  @Builder
  iconWithBackGround() {
    ListItem() {
      if (this.isAppBackplaneAppear) {
        this.iconBackGroundBuilder();
      }
      this.residentLayoutIconBuilder();
    }
    .onClick(this.isAccessibilityMode ? (event) => {
      this.itemOnClick?.(event);
    } : undefined)
    .onAccessibilityHover((isHover, event) => {
      if (!isHover) {
        return;
      }
      AppStorage.setOrCreate<string>('accessibility_dock', '');
      if (AppStorage.get<boolean>('hadFocusDock')) {
        this.appNameVm.modifier.attribute?.accessibilityText(this.appInfo.appName);
        return;
      }
      let text = ResourceManager.getInstance()
        .getStringByName('accessibility_dock') + ',' + this.appInfo.appName;
      log.showInfo(`accessibilityText: ${text}`);
      this.appNameVm.modifier.attribute?.accessibilityText(text);
      AppStorage.setOrCreate<boolean>('hadFocusDock', true);
    })
    .accessibilityDescription(DesktopUtils.getAccessibilityDescription(this.isAccessibilityMode, false,
      this.appInfo))
    .focusable(true)
  }

  build() {
    if (this.appInfo.itemType === CommonConstants.TYPE_FOLDER && !this.isRemoved) {
      ListItem() {
        Stack({ alignContent: Alignment.Top }) {
            ContractedFolder({
              folderId: this.mFolderItemInfo.folderId,
              desktopStyle: this.desktopStyle,
              isEnableName: false,
              dragStart: (event: DragEvent): DragItemInfo => this.dragStart(event),
              isInDock: true,
              zoomScale: this.layoutPropertyVm.scale
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
              .onAccessibilityHover((isHover, event) => {
                if (!isHover) {
                  AppStorage.setOrCreate<string>('accessibility_dock', '');
                  return;
                }
                this.readerAccessibilityDock();
              })
        }
        .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
        .itemGesture()
      }
      .scale({
        x: 1,
      })
      .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
      .zIndex(1)
      .focusable(true)
    } else {
      this.iconWithBackGround()
    }
  }
}
