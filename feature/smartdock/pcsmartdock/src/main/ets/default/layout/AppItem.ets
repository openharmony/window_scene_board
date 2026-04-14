/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  StartType,
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  ObjUtil,
  Trace,
  RectInfo,
  SingleContext
} from '@ohos/basicutils';
import { ItemUtils } from '@ohos/componenthelper';
import { DragDataType, DragEventCallback, DragExtraInfo } from '@ohos/componentdrag';
import { DragConstants, NumberConstants } from '@ohos/commonconstants';
import {
  EventManager,
  EvtBus,
  GlobalContext,
  HideWindowPanelEvent,
  HiSysEventUtil,
  localEventManager,
  ResourceManager,
  ScreenLockEvent,
  sEventManager,
  ViewManagerPolicy,
  ViewType,
  viewMgrPolicy,
  DeviceHelper,
} from '@ohos/frameworkwrapper';
import {
  ResUtils,
  SCBSceneSessionManager,
  SCBSceneInfo,
  windowMgr,
  SystemBarType,
  SCBScreenProperty,
  SCBSceneResourceManager
} from '@ohos/windowscene';
import {
  AppModel,
  CommonConstants,
  DockContinuableInfo,
  DockItemInfo,
  EventConstants,
  HiSysContinueFuncResult,
  MenuInfo,
  ReceiveEventInfo,
  RecentBundleMissionInfo,
  SCBHiSysEventUtil,
  StyleConstants,
  UdmfUtils,
  AppIconModel,
  AppItemInfo,
  vibratorMgr,
  AppDataWrapper,
  GrayAppListManager,
  GridLayoutItemInfo
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import curves from '@ohos.curves';
import image from '@ohos.multimedia.image';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { LayeredDrawableDescriptor } from '@ohos.arkui.drawableDescriptor';
import Want from '@ohos.app.ability.Want';
import {
  AppIconCommonEvent,
  AppIconCommonView,
  AppIconConfig,
  AppIconContainerModifier,
  BadgeAnimationType,
  RunningTask
} from '@ohos/launchercommon/Index';
import SmartDockConstants from '@ohos/smartdock/src/main/ets/default/common/constants/SmartDockConstants';
import { DockItemPosition } from '@ohos/smartdock/src/main/ets/default/common/DockItemPosition';
import HoverEffectConstants from '../common/constants/HoverEffectConstants';
import { SuggestAppMenu } from './SuggestAppMenu';
import PcSmartDockViewModel from '../viewmodel/SmartDockViewModel';
import { PcDockPopupMgr } from '../manager/PcDockPopupMgr';
import { PCDockUtils } from '../utils/PCDockUtils';
import { DockCompanionEffect, EdgeFlag, PcDockAnimationMgr } from '../manager/PcDockAnimationMgr';
import { FixedDockResource, HoverItemInfo, FixedDockConstants } from '../common/constants/FixedDockConstants';
import { DockMenu } from './DockMenu';
import { PcDockHiSysEventMgr } from '../manager/PcDockHiSysEventMgr';
import BundleManager from '@ohos.bundle.bundleManager';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { FileFolderManager, fileFolderManagerFactory } from '@ohos/desktopfilefolder';
import { PCDockDragMgr } from '../manager/PCDockDragMgr';
import SmartDockModel from '@ohos/smartdock/src/main/ets/default/model/SmartDockModel';
import { WindowConstants } from '@ohos/commonconstants';
import { SessionIconListener } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneSessionManager';
import {
  AppIconHoverEventIface
} from '@ohos/launchercommon/src/main/ets/launchericon/interface/AppIconHoverEventIface';
import { IconType } from '@ohos/launchercommon/src/main/ets/bean/DockItemInfo';
import { AppIconResIface } from '@ohos/launchercommon/src/main/ets/launchericon/interface/AppIconResIface';
import { AppIconData } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconData';
import { AppIconShadowViewModel } from '@ohos/launchercommon/src/main/ets/viewmodel/AppIconShadowViewModel';
import { HashMap } from '@kit.ArkTS';
import {
  AppIconActiveEventIface
} from '@ohos/launchercommon/src/main/ets/launchericon/interface/AppIconActiveEventIface';
import {
  AppIconTouchEventIface
} from '@ohos/launchercommon/src/main/ets/launchericon/interface/AppIconTouchEventIface';
import { AppIconDragEventIface } from '@ohos/launchercommon/src/main/ets/launchericon/interface/AppIconDragEventIface';
import { PcDockAppIconImageModel } from '../model/PcDockAppIconImageModel';
import IconInfo from '@ohos/frameworkwrapper/src/main/ets/resourcemanager/IconInfo';
import {
  AppIconLongPressGestureEventIface
} from '@ohos/launchercommon/src/main/ets/launchericon/interface/AppIconLongPressGestureEventIface';
import { AppIconShadowData } from '@ohos/launchercommon/src/main/ets/bean/AppIconShadowData';
import { componentSnapshot, LengthMetrics } from '@kit.ArkUI';
import { BaseBundleInfo } from '@ohos/launchercommon/src/main/ets/bean/BaseBundleInfo';
import { AppIconBadgeVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconBadgeVm';
import { PcDockStyleConfig, PcSmartDockStyleManager } from '../common/PcSmartDockStyleManager';
import SuggestMenuModel from '../model/SuggestMenuModel';
import { PluginWindowManager } from '@ohos/statusbarcomponent/src/main/ets/pc/pluginwindow/PluginWindowManager';
import { PcModeDockUtils } from '@ohos/smartdock/src/main/ets/default/utils/PcModeDockUtils';
import PcModeContinuableModel from '@ohos/smartdock/src/main/ets/default/pcmode/model/PcModeContinuableModel';
import { DockMenuViewModel } from '../viewmodel/DockMenuViewModel';

const TAG = 'PCDock-AppItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
PersistentStorage.persistProp<boolean>('isDockRecycleBinEmpty', true);

const APP_ICON_PRE = 'SmartDock_AppIcon';
const SPLIT_STR = '_';

@Component
export default struct AppItem {
  @Link screenProp: SCBScreenProperty;
  private screenId: number = 0;
  @Prop singleContext?: SingleContext;
  @Prop ratio: number = 1;
  @State iconBadgeVm: AppIconBadgeVm = new AppIconBadgeVm();
  @State continueBadgeVisible: boolean = true;
  private appInfo: DockItemInfo = new DockItemInfo();
  private iconRect: RectInfo = new RectInfo();
  private updateAppItem: Function = () => {
  };
  private pcDockAnimationMgr: PcDockAnimationMgr = PcDockAnimationMgr.getInstance(0);
  private smartDockViewModel: PcSmartDockViewModel = PcSmartDockViewModel.getInstance();
  private mouseX: number = 0;
  private mouseY: number = 0;
  private appIconShadowViewModel?: AppIconShadowViewModel;
  private curve1: curves.ICurve = curves.cubicBezierCurve(0.2, 0.0, 0.2, 1.0);
  private currentForegroundMaxTranslate: number = 0;
  private currentShadowMaxTranslate: number = 0;
  private isNeedReset:boolean = false;
  private dockType: number = SmartDockConstants.RESIDENT_DOCK_TYPE;
  private iconBorderRadios: number = 10;
  private onContinueItemChange: Function = (data: DockContinuableInfo): void => this.continueItemChange(data);
  private minSuggestMenuTextWidth: number = 108;
  private systemFlag: boolean = false;
  private residentFlag: boolean = false;
  private listWidthChange: Function = () => {
  };
  private wpsPreExitFunc: Function = () => {};
  private isWpsEventRegistered: boolean = false;
  private isHover: boolean = false;
  private eventMgr: EventManager = EvtBus.createEventManager();
  private popupMgr: PcDockPopupMgr = PcDockPopupMgr.getInstance();
  private appItemPadding: number = PcSmartDockStyleManager.getStyle(this.screenProp).mListItemGap / 2;
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private continueItemVisibleFunc?: Function = (): boolean => {
    return true;
  };
  private getContinuableItemIndex?: Function = (): number => {
    return -1;
  };

  private fileFolderManager: FileFolderManager = fileFolderManagerFactory.getFileFolderManager();
  private firstLoaded: boolean = false;
  private snapshotId: string = '';
  private mDragEventCallback: DragEventCallback = {};
  private itemRect: Rectangle = {
    x: 0,
    y: 9,
    width: 0,
    height: 0
  };
  private appIconContainerModifier: AppIconContainerModifier = new AppIconContainerModifier(
    (): void => this.updateModifier());
  private appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
  private appIconConfig: AppIconConfig = new AppIconConfig();
  private isMousePressed: boolean = false;
  @State iconSize: number = PcSmartDockStyleManager.getStyle(this.screenProp).mIconSize;
  @State isShowContinuableItemPopup: boolean = false;
  @State continueDeviceName: string | undefined = '';
  @State continueAppName: string | undefined = '';
  @State isUnLockReceived: boolean = true;

  @State isShow: boolean = false;
  @State inHover: boolean = false;

  @State shadowRotateX: number = 0;
  @State shadowRotateY: number = 0;
  @State shadowRotateAngle: number = 0;
  @State shadowTranslateX: number = 0;
  @State shadowTranslateY: number = 0;
  @State iconShadowOffsetX: number = 0;
  @State iconShadowOffsetY: number = SmartDockConstants.DOCK_ITEM_SHADOW_OFFSETY_ONE;
  @State iconData: AppIconData = new AppIconData();
  @State shadowScale: number = 1.0;
  @State shadowOpacity: number = 0.0;
  @State listItemWidth: number = PcSmartDockStyleManager.getStyle(this.screenProp).mListItemWidth;
  @State appItemMouseEvent: MouseEvent | undefined = undefined;
  @Provide shadowPixelmap: image.PixelMap | null = null;
  @State isMinimize: boolean = false;

  @StorageLink('isDockRecycleBinEmpty') isRecycleBinEmpty: boolean = true;
  @StorageLink('continueDeviceInfo') @Watch('onContinueDeviceChange') deviceInfo: DockContinuableInfo =
    new DockContinuableInfo();

  private iconImageModel: PcDockAppIconImageModel = new PcDockAppIconImageModel(this.iconBorderRadios);
  private mPCDockDragMgr: PCDockDragMgr = PCDockDragMgr.getInstance();
  private isAllowDockDragMoveOrDrop: boolean = false;
  private isAllowDockDragStart: boolean = false;
  private isShowDockMenu: boolean = false;
  @State isDraggable: boolean = true;
  @Prop currColorMode: number = 1;
  @Link enableScrollInteraction: boolean;
  /**
   * 当前图标可见性
   */
  @State itemVisibility: Visibility = Visibility.Visible;
  /**
   * 是否显示落位框
   */
  @State isShowDropFrame: boolean = false;

  /**
   * 落位框是否显示在右边
   */
  @State isShowRightDropFrame: boolean = false;

  /**
   * 正在做动效的图标id
   */
  @Prop animatedIconId: number = -1;
  @State isGestureMenuShow: boolean = false;
  private isLongGesture: boolean = false;
  @State appIconId: string = '';

  //Dock栏图标Y轴位移与Dock栏顶端的距离
  private iconTranslateAdd = 8;
  private iconTranslateAddForHover = 2;
  /**
   * 当前是否是通信共享动态加载电话短信图标
   */
  private isCollaborationItem: boolean = false;
  @State dockMenuViewModel: DockMenuViewModel = new DockMenuViewModel();

  private onContinueDeviceChange(): void {
    let isIconBadgeCustom = this.isContinueMerged(this.appInfo);
    if (isIconBadgeCustom && !this.iconBadgeVm.isCustom) {
      animateTo({
        duration: 250,
        curve: curves.cubicBezierCurve(0.33, 0, 0.2, 1),
      }, () => {
        this.iconBadgeVm.animate = BadgeAnimationType.HIDE_WITHOUT_ANIM;
        this.iconBadgeVm.isCustom = isIconBadgeCustom;
      })
    }
    if (this.iconBadgeVm.isCustom && !isIconBadgeCustom && !this.mPCDockDragMgr.isDockDragging) {
      log.showInfo(`ContinuableViewModel : deviceTypeIcon disappear `);
      this.iconBadgeVm.isCustom = isIconBadgeCustom;
      this.iconBadgeVm.animate = BadgeAnimationType.DEFAULT;
    }
  }

  private isContinueMerged(appInfo: DockItemInfo): boolean {
    return this.screenId === SCBSceneSessionManager.getInstance().mainScreenId &&
      this.deviceInfo?.bundleName === appInfo?.bundleName && (appInfo.appIndex ?? 0) === 0 &&
      (appInfo.typeId ?? 0) === CommonConstants.TYPE_APP;
  }

  private initContinueBadgeStatus(): void {
    if (this.isContinueMerged(this.appInfo)) {
      log.showInfo(`Continuable item appear, ${this.appInfo?.bundleName}`);
      this.iconBadgeVm.isCustom = true;
    }
  }

  private updateIsDraggable(): void {
    this.appIconConfig.setEnableDrag(this.isAllowDockDragStart);
    this.iconData.enableDrag = this.isAllowDockDragStart && !this.mPCDockDragMgr.isDockDragging && !this.isMinimize;
    if (this.isCollaborationItem) {
      this.appIconConfig.setEnableDrag(false);
      this.iconData.enableDrag = false;
      this.isAllowDockDragMoveOrDrop = false;
    }
    log.showInfo(`updateIsDraggable ${this.appInfo?.bundleName}, ${this.appInfo?.abilityName},` +
      `enableDrag: ${this.iconData.enableDrag}, isAllowDockDragStart: ${this.isAllowDockDragStart},` +
      `isDockDragging: ${this.mPCDockDragMgr.isDockDragging}, isMinimize: ${this.isMinimize}`);
  }

  // 日历图标刷新时重新生成前景和阴影层
  private calendarImageChangeCb: (image: PixelMap) => void = (image: PixelMap) => {
    this.getCalendarForegroundImage(this.iconData)
      .then(() => this.iconImageModel.updateCalendarShadowImage(this.appInfo, this.iconData))
      .catch(() => log.showError('updateCalendarShadowImage error'))
  };

  private companionEffect: DockCompanionEffect = {
    triggerCompanionEffect: (companionScale: number, shadowOffsetX?: number, shadowOffsetY?: number): void => {
      if (this.iconData.containerScale !== companionScale) {
        log.showDebug(`triggerCompanionEffect,%{public}s,%{public}s,%{public}d,%{public}d`,
          this.appInfo?.bundleName, this.appInfo?.abilityName, companionScale, this.iconData.containerScale);
        let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
        this.iconData.containerScale = companionScale;
        this.listItemWidth = config.mListItemWidth * this.iconData.containerScale +
        config.mListItemGap;
      }
      log.showDebug(`triggerCompanionEffect,%{public}s,%{public}s,%{public}d,%{public}d`,
        this.appInfo?.bundleName, this.appInfo?.abilityName, shadowOffsetX, this.iconShadowOffsetX);
      if (shadowOffsetX !== undefined && this.iconShadowOffsetX !== shadowOffsetX) {
        this.iconShadowOffsetX = shadowOffsetX;
      }
      log.showDebug(`triggerCompanionEffect,%{public}s,%{public}s,%{public}d,%{public}d`,
        this.appInfo?.bundleName, this.appInfo?.abilityName, shadowOffsetY, this.iconShadowOffsetY);
      if (shadowOffsetY !== undefined && this.iconShadowOffsetY !== shadowOffsetY) {
        this.iconShadowOffsetY = shadowOffsetY;
      }
      if (this.appIconCommonEvent.getIconDynamicShadowEvent()) {
        this.appIconCommonEvent.getIconDynamicShadowEvent().update(this.isMinimize ? 0 :
          HoverEffectConstants.ITEM_SHADOW_RADIUS, this.iconShadowOffsetX, this.iconShadowOffsetY);
      }
    }
  };

  public onActiveCallBack(): void {
    this.enableScrollInteraction = false;
    this.isMinimize = true;
  }

  public onInactiveCallBack(): void {
    this.enableScrollInteraction = true;
    this.isMinimize = false;
  }
  private readonly dockAppItemListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: SCBSceneInfo): void => {
      log.showInfo(`dock receive event: ${event}, params: ${params}`);
      if (event === EventConstants.EVENT_REQUEST_DOCK_CTRL_Q_CALLBACK) {
        this.closeAllWindowCallBack(params);
      }
    }
  };

  private readonly dockItemChangeListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: string): void => {
      log.showInfo(`dock receive event: ${event}, params: ${params}`);
      if (event === EventConstants.EVENT_PC_DOCK_ITEM_CHANGE && this.appInfo?.bundleName === params) {
        const newAppInfo: DockItemInfo = this.updateAppItem(this.appInfo);
        if (!CheckEmptyUtils.isEmpty(newAppInfo)) {
          this.mPCDockDragMgr.unRegisterDragEvent(this.mDragEventCallback, this.appInfo);
          this.appInfo = newAppInfo;
          this.mPCDockDragMgr.registerDragEvent(this.mDragEventCallback, this.appInfo);
        }
      }
    }
  };

  private readonly dockItemHoverListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: HoverItemInfo): void => {
      if (event === EventConstants.EVENT_PC_DOCK_ITEM_HOVER_CHANGE && !CheckEmptyUtils.isEmpty(params) &&
        this.screenId === params.screenId && PCDockUtils.getAppItemColumnId(this.appInfo) === params.hoverItemId &&
        !this.isMousePressed) {
        this.onHoverItemScale(true, (this.listItemWidth / 2));
      }
    }
  };

  private readonly updateIconDragListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: string): void => {
      log.showDebug(`dock receive event: ${event}, params: ${params}`);
      if (event === EventConstants.EVENT_PC_DOCK_DRAG_CHANGE) {
        this.updateIsDraggable();
      }
    }
  };

  private closeAllWindowCallBack = (sceneInfo: SCBSceneInfo): void => {
    log.showInfo(`eventCtrlQCallBack,item:${sceneInfo?.bundleName},onHoverItem:${this.popupMgr.getCurrItem()?.bundleName}`);
    if (!CheckEmptyUtils.isEmpty(sceneInfo) &&
      sceneInfo.bundleName === this.appInfo?.bundleName &&
      sceneInfo.abilityName === this.appInfo?.abilityName &&
      this.popupMgr.isItemPopupShowing(this.appInfo)) {
      log.showDebug(`reset snapshotList empty, ${this.appInfo?.bundleName}`);
      PCDockUtils.clearSnapshotList();
      this.popupMgr.setCurrItem(null);
      this.popupMgr.hide(this.screenId);
    }
  }

  // 右键菜单删除图标时，因图标节点消失，对应菜单的onDisappear回调不会触发，改为自定义builder的生命周期函数来调用
  private menuOnAppear = (): void => {
    this.popupMgr.setIsDockMenuShow(this.screenProp.screenId, true);
    log.showDebug(`onAppear  ${this.appInfo?.bundleName}, ${this.isLongGesture}`);
    // 手势长按显示菜单时的图标放大动效和onDragStart浮起动效冲突，触控屏手势长按时没有图标放大动效
    if (this.iconData.containerScale != HoverEffectConstants.FIXED_HOVER_MASTER_SCALE &&
      !PCDockUtils.is2D() && !this.isLongGesture) {
      this.onHoverAnimation(-1, -1, true);
    }
    this.isLongGesture = false;
  }

  private menuOnDisAppear = (): void => {
    log.showDebug(`onDisappear  ${this.appInfo?.bundleName}`);
    this.desktopContext?.eventHub.emit(CommonConstants.EVENTHUB_MENU_DISAPPEAR);
    if (!this.pcDockAnimationMgr.getIsHoveringDock() && !this.popupMgr.isDockMenuShow(this.screenProp.screenId)) {
      animateTo({
        curve: HoverEffectConstants.FIXED_HOVER_EFFECT_CURVES,
      }, () => {
        this.pcDockAnimationMgr.resetAllEffect();
        this.listWidthChange(this.residentFlag, 0);
      })
    }
  }

  /**
   * 监听锁定，三指捏合以及应用状态变更事件
   *
   */
  private eventListener(): void {
    this.eventMgr
      .on(ScreenLockEvent, this.onScreenLockEvent)
      .on(HideWindowPanelEvent, this.hideWindowPanelEvent)
  }

  /**
   * 锁定状态事件
   *
   * @param event 事件
   */
  private onScreenLockEvent = (event: ScreenLockEvent): void => {
    log.showInfo('dock on ScreenLockEvent');
    this.popupMgr.hide(this.screenId);
    this.popupMgr.closeMenu();
  }

  /**
   * 三指捏合事件
   *
   * @param event 事件
   */
  private hideWindowPanelEvent = (event: HideWindowPanelEvent): void => {
    log.showDebug('dock on HideWindowPanelEvent');
    this.popupMgr.hide(this.screenId);
    this.popupMgr.closeMenu();
  }

  private continueItemChange(data: DockContinuableInfo): void {
    if (ObjUtil.isInvalid(data) ||
      ObjUtil.isInvalid(data?.bundleName) ||
      ObjUtil.isInvalid(data?.sourceDeviceName)) {
      this.isShowContinuableItemPopup = false;
      this.continueDeviceName = '';
      this.continueAppName = '';
    } else {
      this.continueDeviceName = data?.sourceDeviceName;
      this.continueAppName = data?.appName;
      this.deviceInfo = data;
      if (this.appInfo?.bundleName !== data.bundleName) {
        log.showInfo(`continueItemChange oldInfo: ${this.appInfo?.bundleName}, newInfo: ${data?.bundleName}`);
        this.pcDockAnimationMgr.unRegisterCompanionEffect(this.appInfo, this.companionEffect);
        this.appInfo = data;
        this.pcDockAnimationMgr.registerCompanionEffect(this.appInfo, this.companionEffect);
      }
    }
  }

  private onMouseItem(event: MouseEvent | undefined, item: DockItemInfo): void {
    if (event && event.action === MouseAction.Press) {
      log.showInfo(`dock item mouse Press`);
      this.popupMgr.hideOnClickItem(this.screenId, this.appInfo);
    } else if (event && event.action === MouseAction.Hover || event?.action === MouseAction.Move) {

    }
    // 这里原来还需要做event.action == MouseAction.Release的判断，但是bindContextMenu导致这里收不到release事件
    if (event && event.button === MouseButton.Right && event.action == MouseAction.Press) {
      this.initDockMenuInfo();
      localEventManager.sendLocalEvent(EventConstants.EVENT_RESET_HIDE_DOCK_AFTER_POPUP_STATE_CALLBACK,
        this.screenProp.screenId);
      log.showInfo(`dock item right click bundleName: ${item?.bundleName},abilityName: ${item?.abilityName}`);
      if (event.stopPropagation) {
        event.stopPropagation();
      }
      AppStorage.setOrCreate('selectDesktopAppItem', '');
      this.popupMgr.hide(this.screenId);
    }
  }

  private initDockMenuInfo(): void {
    this.dockMenuViewModel.initMenuTaskList();
    if (!this.dockMenuViewModel.isMenuInitComplete()) {
      this.dockMenuViewModel.menuInfoInit();
    }
  }

  private hideExtAppOrRecentWindow(screenId: number): void {
    let isExtShowing = viewMgrPolicy.getViewController(ViewType.APP_CENTER_EXT) &&
      viewMgrPolicy.isViewShowing(ViewType.APP_CENTER_EXT);
    if (isExtShowing) {
      if (GlobalContext.getInstance().hasObject('hideExtAppCenterWithAnimation')) {
        let hideAppCenterWithAnimation = (GlobalContext.getInstance()
          .getObject('hideExtAppCenterWithAnimation')) as Function;
        log.showInfo(`hideExtAppCenterWithAnimation screenId ${screenId}`)
        hideAppCenterWithAnimation(screenId);
      }
    }
    if (AppStorage.get('showRecent') as boolean) {
      AppStorage.setOrCreate('showRecent', false);
    }
  }

  private onClickItem(event: ClickEvent | null, item: DockItemInfo, isTouchScreen: boolean = false): void {
    log.showInfo(`onClickItem: ${this.appInfo?.bundleName}, abilityName: ${this.appInfo?.abilityName}`);
    if (this.mPCDockDragMgr.isDockDragging) {
      log.showInfo(`onClickItem, isDockDragging: ${this.mPCDockDragMgr.isDockDragging}`);
      return;
    }
    if (SCBSceneSessionManager.getInstance().isPcMode()) {
      // pad触碰和鼠标操作不同的地方：pad触碰单击图标出缩略图时没有hover过程，故需要在单击时改变此状态。
      AppStorage.setOrCreate<string>('hoverItemBundleName', item?.bundleName);
    }
    if (event) {
      this.mPCDockDragMgr.setDragMovePos(event.windowX, event.windowY);
    }
    const isItemPopupShowing: boolean = this.popupMgr.isPopupShowing(this.screenId, this.appInfo);
    this.popupMgr.hideOnClickItem(this.screenId, this.appInfo);
    log.showInfo(`onClickItem, ispopupshow false - ${this.screenId}, isItemPopupShowing: ${isItemPopupShowing}`);
    PcModeContinuableModel.getInstance().isOpenPopupOnContinuableItem = this.isContinueMerged(this.appInfo);
    this.pcDockAnimationMgr.setDockIconSize(this.iconSize);
    this.smartDockViewModel.onItemClickWithDisplay(event, item, this.screenId);
    // 是否点击已经触发了任务popup窗口
    let isClickOpenPopup: boolean | undefined = AppStorage.get('isClickOpenPopup');
    if (isClickOpenPopup && !isItemPopupShowing) {
      this.popupMgr.setCurrItem(this.appInfo);
      this.popupMgr.setIsShowCloseButton(isTouchScreen);
      this.popupMgr.show(this.screenId, this.appInfo, PCDockUtils.getAppItemColumnId(this.appInfo)); // 点击无须延时
      log.showInfo(`onClickItem ${isClickOpenPopup},currItem: ${this.popupMgr.getCurrItem()?.bundleName}`);
    } else if (!isClickOpenPopup && isItemPopupShowing) {
      // 单实例窗口预览窗出现时点击响应窗口最大化/最小化时候隐藏预览窗
      this.popupMgr.hide(this.screenId);
    }
    AppStorage.setOrCreate('isClickOpenPopup', false);
  }

  private checkPopupShow(isHover: boolean, item: DockItemInfo): void {
    const isDockInDragging = this.mPCDockDragMgr.isDockDragging;
    const isDockMenuShow = this.popupMgr.isDockMenuShow(this.screenProp.screenId);
    log.showInfo(`checkPopupShow, ${item?.bundleName}, isHover: ${isHover}, ` +
      `isDockMenuShow: ${isDockMenuShow}, isDockInDragging: ${isDockInDragging}, isMousePressed:${this.isMousePressed} `);
    if (this.isMousePressed) {
      return;
    }
    if (isDockMenuShow) {
      return;
    }
    this.isHover = isHover;
    AppStorage.setOrCreate<string>('hoverItemBundleName', isHover ? item?.bundleName ?? '' : '');
    const itemId: string = PCDockUtils.getAppItemColumnId(this.appInfo);
    const hoverItemColumnId: string = isHover ? itemId ?? '' : '';
    this.pcDockAnimationMgr.setHoverItemColumnId(hoverItemColumnId);
    this.popupMgr.updateHoverState(this.screenId, item, itemId, isDockInDragging, isHover);
  }

  private getIdPrefixForIcon(): string {
    return this.dockType === SmartDockConstants.RESIDENT_DOCK_TYPE ? 'ResidentLayoutForPC' : 'RecentLayout';
  }

  private getBottomBinaryHeight(): number {
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    return (config.mDockHeight - config.mIconSize - 2) / 2;
  }

  private getTopBinaryHeight(): number {
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    return (config.mDockHeight - config.mIconSize + 2) / 2;
  }

  private getDockHeight(): number {
    return PcSmartDockStyleManager.getStyle(this.screenProp).mDockHeight;
  }

  private prepareMenu(): boolean {
    let traceId: string = APP_ICON_PRE;
    if (this.appInfo?.persistentId) {
      traceId = traceId + SPLIT_STR + this.appInfo?.persistentId;
    }
    this.iconRect = ItemUtils.getRectById(AppModel.getInstance().getAppIconContainerId(
      'SmartDock_AppIcon', this.appInfo?.bundleName as string, this.appInfo?.abilityName as string,
      this.appInfo?.appIndex as number, this.appInfo?.appInstanceKey as string));
    DockItemPosition.getInstance().setIconRect(this.iconRect);
    return true;
  }

  private onHoverIconInAnimation(scale?: number) {
    Trace.start('dockShowHoverIn');
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    this.inHover = true;
    let x = this.mouseX;
    let y = this.mouseY;
    const size = config.mIconSize;
    const halfSize = size / 2;
    let expectAngleX = (y / halfSize - 1) * HoverEffectConstants.BACKGROUND_ROTATE_ANGLE_X;
    let expectAngleY = (x / halfSize - 1) * HoverEffectConstants.BACKGROUND_ROTATE_ANGLE_Y;
    let angle = Math.sqrt(Math.pow(expectAngleX, 2) + Math.pow(expectAngleY, 2))
    let maxDis = Math.sqrt(Math.pow(halfSize, 2) + Math.pow(halfSize, 2));
    let curDis = Math.sqrt(Math.pow(x - halfSize, 2) + Math.pow(y - halfSize, 2));

    let currentForegroundTranslate = HoverEffectConstants.FOREGROUND_BASE_TRANSLATE *
    this.curve1.interpolate((maxDis - curDis) / (maxDis));
    this.currentForegroundMaxTranslate = Math.max(this.currentForegroundMaxTranslate, currentForegroundTranslate);
    let currentShadowTranslate = HoverEffectConstants.SHADOW_BASE_TRANSLATE *
    this.curve1.interpolate((maxDis - curDis) / (maxDis));
    this.currentShadowMaxTranslate = Math.max(this.currentShadowMaxTranslate, currentShadowTranslate);
    animateTo({
      curve: HoverEffectConstants.FIXED_HOVER_EFFECT_CURVES,
    }, () => {
      if (scale) {
        this.iconData.containerScale = scale;
      }
      this.shadowRotateX = expectAngleX;
      this.shadowRotateY = expectAngleY;
      this.shadowRotateAngle = angle * HoverEffectConstants.FOREGROUND_ROTATE_ANGLE_MULTIPLE;
      this.shadowTranslateX = -(x - halfSize) / halfSize * this.currentShadowMaxTranslate;
      this.shadowTranslateY = -(y - halfSize) / halfSize * this.currentShadowMaxTranslate;
      this.shadowScale = HoverEffectConstants.FIXED_SHADOW_SCALE;
      this.shadowOpacity = HoverEffectConstants.SHADOW_OPACITY;
      Trace.end('dockShowHoverIn');
    })
  }

  private onHoverIconOutAnimation(scale?: number): void {
    this.inHover = false;
    animateTo({
      curve: curves.responsiveSpringMotion(0.35, 0.86, 0.25),
      onFinish: () => {
       }
    }, () => {
      if (scale) {
        this.iconData.containerScale = scale;
      }
      this.shadowRotateX = 0;
      this.shadowRotateY = 0;
      this.shadowRotateAngle = 0;
      this.shadowTranslateX = 0;
      this.shadowTranslateY = 0;
      this.shadowScale = 1.0;
      this.shadowOpacity = 0;
    })
  }

  private onHoverIconHandler(isHover: boolean, scale?: number): void {
    log.showInfo(` handleHoverState ${isHover} bundleName :${this.appInfo?.bundleName}`);
    if (isHover) {
      this.onHoverIconInAnimation(scale);
    } else {
      this.onHoverIconOutAnimation(scale);
    }
  }

  private registerWpsEvent(): void {
    if (!SCBSceneSessionManager.getInstance().isPcMode() ||
      this.appInfo?.bundleName !== FixedDockConstants.WPS_BUNDLE_NAME) {
      return;
    }
    log.showInfo('registerWpsEvent FloatingSceneAbilityEvent');
    this.isWpsEventRegistered = true;
    sEventManager.subscribe('FloatingSceneAbilityEvent', this.wpsModalWindowOpenListener);
  }

  private unregisterWpsEvent(): void {
    if (!this.isWpsEventRegistered ||
      this.appInfo?.bundleName !== FixedDockConstants.WPS_BUNDLE_NAME) {
      return;
    }
    log.showInfo('unregisterWpsEvent FloatingSceneAbilityEvent');
    this.isWpsEventRegistered = false;
    sEventManager.off('FloatingSceneAbilityEvent', this.wpsModalWindowOpenListener);
  }

  // wps “未读消息”模态窗的打开和关闭按钮监听
  private wpsModalWindowOpenListener = (isOpen: boolean) => {
    if (isOpen) {
      log.showInfo('open wps');
    } else {
      log.showInfo('close wps');
      this.wpsPreExitFunc();
    }
  }

  private updateHoverConfigForPC(isHover: boolean): void {
    let dockHoverConfig = AppStorage.get('dockHoverConfig') as HashMap<string, Object>;
    if (!dockHoverConfig) {
      dockHoverConfig = new HashMap<string, Object>();
    }
    dockHoverConfig.set('isHover', isHover);
    dockHoverConfig.set('screenId', this.screenId);
    const shadowData: AppIconShadowData | undefined = this.appIconShadowViewModel?.getAppIconShadowData();
    if (shadowData) {
      dockHoverConfig.set('appIconShadowData', shadowData);
    } else {
      dockHoverConfig.set('appIconShadowData', new AppIconShadowData());
    }
    AppStorage.setOrCreate('dockHoverConfig', dockHoverConfig);
  }

  private onMouseAppIconShadow(event?: MouseEvent): void {
    if (event === undefined || event?.x === undefined || event?.y === undefined) {
      return;
    }
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    let mouseEvent = event;
    const dockHeight = config.mDockHeight;
    if (dockHeight && this.listItemWidth) {
      mouseEvent.x = (event.x / this.listItemWidth) * config.mIconSize;
      mouseEvent.y = (event.y / dockHeight) * config.mIconSize;
    } else {
      log.showWarn(`dockHeight is undefined`);
    }
    this.appItemMouseEvent = mouseEvent;
    this.appIconShadowViewModel?.onIconShadowAnimateInForPc(this.appItemMouseEvent);
    this.updateHoverConfigForPC(true);
  }

  /**
   *
   * @param isAppOrRecentCenter  是否hover的应用中心和任务中心，应用中心和任务中心没有左右两侧的伴生动效
   * @param isHover
   */
  private onHoverItemScale(isHover?: boolean, leftDistance?: number, topDistance?: number): void {
    if (this.mPCDockDragMgr.isDockDragging) {
      return;
    }
    log.showInfo(`onHoverItemScale, ${this.appInfo?.bundleName}, ${isHover}, ${this.screenId}`);
    if (!isHover || this.appInfo?.bundleName === undefined) {
      return;
    }
    if (this.popupMgr.isDockMenuShow(this.screenProp.screenId)) {
      return;
    }
    if (PCDockUtils.is2D()) {
      log.showError(`not handle hover in pc emulator`);
      return;
    }
    if (!this.pcDockAnimationMgr.isInVisibleArea(this.appInfo, this.residentFlag, this.systemFlag)) {
      return;
    }
    this.onHoverAnimation(leftDistance, topDistance);
  }

  private getAdditionWidth(config: PcDockStyleConfig): number {
    let additionWidth: number = 0;
    let edgeFlag: EdgeFlag = { index: -1, isInEdge: false };
    edgeFlag = this.pcDockAnimationMgr.judgeEdgeItem(this.appInfo, this.residentFlag, this.systemFlag);

    if (edgeFlag.isInEdge) {
      const companionScale = edgeFlag.index === 0 ? this.pcDockAnimationMgr.getNextItemScale() :
        this.pcDockAnimationMgr.getPrevItemScale();
      additionWidth = config.mListItemWidth * (this.pcDockAnimationMgr.getCurrentItemScale() + companionScale - 2);
    } else {
      const totalScale: number = this.pcDockAnimationMgr.getCurrentItemScale() +
                                 this.pcDockAnimationMgr.getPrevItemScale() +
                                 this.pcDockAnimationMgr.getNextItemScale();
      additionWidth = config.mListItemWidth * (totalScale - 3);
    }
    return additionWidth;
  }

  private onHoverAnimation(leftDistance: number = -1, topDistance: number = -1, menuAppear: boolean = false): void {
    Trace.start('onHoverScaleAnimation');
    if (!menuAppear) {
      this.pcDockAnimationMgr.computeHoverScale(this.appInfo, leftDistance, this.appItemPadding, this.listItemWidth);
    }
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    this.pcDockAnimationMgr.computeIconShadow(leftDistance, topDistance, this.listItemWidth, config.mDockHeight);
    const additionWidth: number = this.getAdditionWidth(config);
    animateTo({
      curve: HoverEffectConstants.FIXED_HOVER_EFFECT_CURVES,
    }, () => {
      if (this.iconData.containerScale !== this.pcDockAnimationMgr.getCurrentItemScale()) {
        this.iconData.containerScale = this.pcDockAnimationMgr.getCurrentItemScale();
        this.listItemWidth = config.mListItemWidth * this.iconData.containerScale +
        config.mListItemGap;
        this.listWidthChange(this.residentFlag, additionWidth);
      }
      this.iconShadowOffsetX = this.pcDockAnimationMgr.getCurrentIconShadowOffsetX();
      this.iconShadowOffsetY = this.pcDockAnimationMgr.getCurrentIconShadowOffsetY();
      if (this.appIconCommonEvent.getIconDynamicShadowEvent()) {
        this.appIconCommonEvent.getIconDynamicShadowEvent().update(this.isMinimize ? 0 :
          HoverEffectConstants.ITEM_SHADOW_RADIUS, this.iconShadowOffsetX, this.iconShadowOffsetY);
      }
      Trace.end('onHoverScaleAnimation');
    })
    log.showInfo(`onHoverItemScale, ${this.appInfo?.bundleName}, ${this.iconData.containerScale}, ${additionWidth}, ${this.listItemWidth}`);
  }

  private getMenuOptions(): ContextMenuOptions {
    return {
      placement: Placement.TopLeft,
      enableArrow: false,
      borderRadius: StyleConstants.DEFAULT_8 * this.ratio,
      offset: { x: FixedDockResource.DOCK_MENU_OFFSET_X, y: FixedDockResource.DOCK_MENU_OFFSET_Y },
      backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR,
      aboutToDisappear: () => {
        this.isGestureMenuShow = false;
        this.iconData.isShowMask = false;
        this.isShowDockMenu = false;
        this.popupMgr.setIsDockMenuShow(this.screenProp.screenId, false);
        this.popupMgr.setIsDockPopupShow(this.screenProp.screenId, false);
        PCDockUtils.callHideDock(this.screenProp.screenId);
      },
      aboutToAppear: async () => {
        log.showInfo('getMenuOptions aboutToAppear');
        this.iconData.isShowMask = true;
        this.isShowDockMenu = true;
        if (this.isAppCenter(this.appInfo)) {
          PcDockHiSysEventMgr.reportAppCenterMenu();
        }
        this.popupMgr.hide(this.screenId);
      }
    }
  }

  private isAppCenter(item: DockItemInfo): boolean {
    return item?.abilityName === CommonConstants.APPCENTER_ABILITY;
  }

  /**
   * 获取日历图标前景图
   * @param iconData
   * @returns
   */
  private async getCalendarForegroundImage(iconData: AppIconData): Promise<void> {
  }

  /**
   * 初始化控制分层图标阴影层
   * @param iconData
   */
  private initIconShadowViewModel(iconData: AppIconData) {
    if (!this.appIconShadowViewModel) {
      this.appIconShadowViewModel = this.appIconCommonEvent.getIconShadowViewModel();
      this.appIconShadowViewModel?.init(PCDockUtils.is2D(), this.iconSize, false,
        async (image: IconInfo | string | LayeredDrawableDescriptor, isAdaptive: boolean, item: AppItemInfo) => {
          if (iconData.isDynamicIcon && item.bundleName === CommonConstants.CALENDAR_BUNDLE) {
            await this.getCalendarForegroundImage(iconData);
          }
          this.iconImageModel.iconLoadCallback(image, isAdaptive, item, iconData);
        });
    }
  }

  private async getIconImage(itemInfo: AppItemInfo, iconData: AppIconData): Promise<void> {
    if (!itemInfo || !iconData) {
      log.showError('initIconImage failed, itemInfo or iconData is invalid!');
      return;
    }
    this.initIconShadowViewModel(iconData);
    this.iconData.maskBgColor = FixedDockResource.ICON_SELECT_COLOR;
    this.iconData.maskOpacity = 1;
    iconData.isDynamicIcon = AppIconModel.getInstance().isDynamicIcon(itemInfo);
    iconData.setIconId(AppModel.getInstance().getAppIconContainerId(APP_ICON_PRE,
      itemInfo.bundleName, itemInfo.abilityName, itemInfo.appIndex, itemInfo?.appInstanceKey));
    log.showInfo(`init icon image bundleName:${itemInfo.bundleName}, appIndex:${itemInfo.appIndex}, ` +
      `shortcutId:${itemInfo.shortcutId}, isDynamicIcon: ${iconData.isDynamicIcon}`);
    if (iconData.isDynamicIcon && itemInfo.bundleName === CommonConstants.CALENDAR_BUNDLE) {
      await this.getCalendarForegroundImage(iconData);
    }

    if (itemInfo.persistentId) {
      let traceId: string = APP_ICON_PRE + SPLIT_STR + itemInfo.persistentId;
      iconData.setIconId(AppModel.getInstance().getAppIconContainerId(traceId,
        itemInfo.bundleName, itemInfo.abilityName, itemInfo.appIndex, itemInfo?.appInstanceKey));
      const image = SCBSceneResourceManager.getInstance().getSessionIconCache(itemInfo.persistentId);
      log.showInfo(`updateIcon image: ${!image}`);
      if (!CheckEmptyUtils.isEmpty(image)) {
        iconData.image = image as string | PixelMap;
        return;
      }
    }
    return await this.iconImageModel.updateIcon(itemInfo, iconData, this.iconSize);
  }

  private initAppIconEvent() {
    const hoverEvent: AppIconHoverEventIface = {
      onHover: (isHover: boolean, event: HoverEvent, updateScale: (scale: number) => void): void => {}
    }
    const appIconResource: AppIconResIface = {
      initIconImage: (itemInfo: AppItemInfo): Promise<void> => {
        return this.getIconImage(itemInfo, this.iconData);
      }
    }
    const appIconActiveEvent: AppIconActiveEventIface = {
      onActive: (): void => {
        this.enableScrollInteraction = false;
        this.continueBadgeVisible = false;
        if (globalThis.attractionAnimController && globalThis.attractionAnimController.isAttractionEnabled()) {
          const dockHeight: number = this.getDockHeight();
          const iconHeight: number = this.getAppIconSize();
          if (dockHeight) {
            let iconTranslateY = (dockHeight - iconHeight) / 2;
            let translateYTemp = -iconTranslateY + this.iconTranslateAdd;
            const dockHoverConfig = AppStorage.get('dockHoverConfig') as HashMap<string, Object>;
            if (dockHoverConfig) {
              //Dock栏图标是否放大
              let isHover = dockHoverConfig.get('isHover') as boolean;
              if (isHover) {
                translateYTemp = translateYTemp + this.iconTranslateAddForHover;
              }
            } else {
              log.showWarn(`dockHoverConfig is undefined!`);
            }
            this.iconData.transY = translateYTemp;
          } else {
            log.showWarn(`dockHeight is undefined!`);
          }
          return;
        }
        this.iconData.setContainerOpacity(0);
        this.isMinimize = true;
        if (this.appIconCommonEvent.getIconDynamicShadowEvent()) {
          this.appIconCommonEvent.getIconDynamicShadowEvent().update(0, this.iconShadowOffsetX, this.iconShadowOffsetY);
        }
      },
      onInactive: (): void => {
        this.enableScrollInteraction = true;
        this.continueBadgeVisible = true;
        if (globalThis.attractionAnimController && globalThis.attractionAnimController.isAttractionEnabled()) {
          this.iconData.transY = 0;
          return;
        }
        this.isMinimize = false;
        this.updateIsDraggable();
        this.iconData.setContainerOpacity(1);
        if (this.appIconCommonEvent.getIconDynamicShadowEvent()) {
          this.appIconCommonEvent.getIconDynamicShadowEvent().update(
            HoverEffectConstants.ITEM_SHADOW_RADIUS, this.iconShadowOffsetX, this.iconShadowOffsetY);
        }
      }
    }
    const appIconDragEvent: AppIconDragEventIface = {
      onDragStart: (event: DragEvent): CustomBuilder | DragItemInfo => {
        performanceMonitor.begin(HiSysEventUtil.DRAG_ITEM_ANI, performanceMonitor.ActionType.FIRST_MOVE, 'item:[DockApp]');
        const scaledWidth = ResUtils.getNumberFromLength(this.itemRect.width) * this.iconData.containerScale;
        const scaledHeight = ResUtils.getNumberFromLength(this.itemRect.height) * this.iconData.containerScale;
        const halfAddScaledWidth = (ResUtils.getNumberFromLength(this.itemRect.width) *
          (this.iconData.containerScale - 1)) / 2;
        const halfAddScaledHeight = (ResUtils.getNumberFromLength(this.itemRect.height) *
          (this.iconData.containerScale - 1)) / 2;
        const scaledX = ResUtils.getNumberFromLength(this.itemRect?.x) - halfAddScaledWidth;
        const scaledY = ResUtils.getNumberFromLength(this.itemRect?.y) - halfAddScaledHeight;
        this.mPCDockDragMgr.setDragSnapshotRelativeRect({
          x: event.getWindowX() - scaledX,
          y: event.getWindowY() - scaledY,
          width: scaledWidth,
          height: scaledHeight
        });
        this.mPCDockDragMgr.onDragStart(this.appInfo, this.dockType, event);
        ContextMenu.close();
        this.popupMgr.hide(this.screenId);
        const dragItemInfo: DragItemInfo = {
          extraInfo: new DragExtraInfo(DragDataType.DOCK_APP).setRadius(CommonConstants.DEFAULT_ICON_RADIUS).toString(),
        };
        return dragItemInfo;
      },
      onDragEnd: (event: DragEvent): void => {
        this.mPCDockDragMgr.onDragEnd();
        this.iconData.isShowMask = false;
        this.iconData.enableDrag = true;
      },
      onPreDrag: (preDragStatus: PreDragStatus): void => {
      },
      getDragPreviewBuilder: (): string | CustomBuilder | DragItemInfo => {
       return AppModel.getInstance().getAppIconContainerId(APP_ICON_PRE,
         this.appInfo?.bundleName, this.appInfo?.abilityName, this.appInfo?.appIndex, this.appInfo?.appInstanceKey);
      }
    }
    // 替换默认的长按事件实现
    const appIconLongPressEvent: AppIconLongPressGestureEventIface = {
      onLongPressPreGatherAction: (event: GestureEvent): void => {},
      onLongPressPreGatherActionEnd: (event: GestureEvent): void => {},
      onLongPressSnapshotAction: (event: GestureEvent): void => {},
      onLongPressGatherAction: (event: GestureEvent): void => {},
      onLongPressGatherActionEnd: (event: GestureEvent): void => {},
      onLongPressVibrateAction: (event: GestureEvent): void => {
        if (event?.source === SourceType.TouchScreen) {
          log.showWarn('zzhTouchScreen')
          vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
            CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
        }
      },
      onLongPressVibrateActionEnd: (event: GestureEvent): void => {},
      onLongPressVibrateActionCancel: (): void => {},
      onLongPressZoomInAction: (event: GestureEvent): void => {},
      onIconLongPressZoomAnimation: (isZoomOut: boolean, bundleName: string): void => {},
      onLongPressSnapshotActionEnd: (event: GestureEvent): void => {},
      onLongPressSnapshotActionCancel: (): void => {}
    }
    const touchEvent: AppIconTouchEventIface = {
      onTouch: (event: TouchEvent): void => {},
      onClick: (event?: ClickEvent | undefined): void => {}
    }
    this.appIconCommonEvent.setLongPressGestureEventIface(appIconLongPressEvent);
    this.appIconCommonEvent.setIconDragEventIface(appIconDragEvent);
    this.appIconCommonEvent.setIconHoverEventIface(hoverEvent);
    this.appIconCommonEvent.setIconResIface(appIconResource);
    this.appIconCommonEvent.setIconActiveEvent(appIconActiveEvent);
    // 不使用默认的onTouch事件
    this.appIconCommonEvent.setIconTouchEventIface(touchEvent);
  }

  private updateModifier() {
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    this.appIconContainerModifier.attribute?.margin({ top: this.getTopBinaryHeight() });
    this.appIconContainerModifier.attribute?.borderRadius(config.mItemBorderRadius);
    this.appIconContainerModifier.attribute?.pixelRound({
      start: PixelRoundCalcPolicy.NO_FORCE_ROUND,
      end: PixelRoundCalcPolicy.NO_FORCE_ROUND,
      top: PixelRoundCalcPolicy.NO_FORCE_ROUND,
      bottom: PixelRoundCalcPolicy.NO_FORCE_ROUND
    });
    this.appIconContainerModifier.attribute?.onAreaChange((oldValue: Area, newValue: Area) => {
      this.itemRect = {
        x: newValue.globalPosition.x,
        y: newValue.globalPosition.y,
        width: newValue.width,
        height: newValue.height
      };
    });
  }

  /**
   * 处理当前图标是否应该显示禁用蒙层
   */
  private isDisableMaskHandler = (param?: boolean) => {
    if (param !== undefined) {
      // 回调场景
      if (PCDockUtils.isPcFileManager(this.appInfo?.bundleName)) {
        const eventKey = GrayAppListManager.getInstance()
          .getGrayAppIconEventKey({ bundleName: CommonConstants.LAUNCHER_BUNDLE });
        localEventManager.sendLocalEventSticky(eventKey, param);
        return param;
      }
      if (this.appInfo?.bundleName === CommonConstants.LAUNCHER_BUNDLE) {
        if (this.appInfo?.abilityName === CommonConstants.RECYCLE_BIN_ABILITY) {
          return param;
        }
        return false;
      }
      return param;
    }
    // 初始化场景
    if (this.appInfo?.bundleName === CommonConstants.LAUNCHER_BUNDLE) {
      if (this.appInfo?.abilityName === CommonConstants.RECYCLE_BIN_ABILITY) {
        const bundleInfo: BaseBundleInfo = DeviceHelper.is2In1DevicePcType() ?
          { bundleName: CommonConstants.PHONE_FILE_MANAGER_BUNDLE, appIndex: 0 } :
          { bundleName: CommonConstants.FILE_MANAGER_BUNDLE, appIndex: 0 };
        return GrayAppListManager.getInstance().isGrayAppIcon(bundleInfo);
      }
      return false;
    }
    return GrayAppListManager.getInstance().isGrayAppIcon(this.appInfo);
  }

  private initAppIconConfig() {
    this.initAppIconEvent();
    const appData: AppDataWrapper = AppDataWrapper.getDefaultAppData(this.appInfo, this.iconBorderRadios);
    let traceId: string = APP_ICON_PRE;
    if (this.appInfo?.persistentId) {
      traceId = traceId + SPLIT_STR + this.appInfo?.persistentId;
    }
    appData.setStartType(StartType.DOCK_APP)
      .setAppIconId(AppModel.getInstance().getAppIconContainerId(traceId,
        this.appInfo?.bundleName, this.appInfo?.abilityName, this.appInfo?.appIndex,  this.appInfo?.appInstanceKey))
      .setScreenId(this.screenId)
      .setPersistentId(this.appInfo?.persistentId ?? '')
    this.appIconConfig.setIsDesktopItem(false)
      .setEnableName(false)
      .setEnableMultiSelect(false)
      .setEnableInstallAnimate(false)
      .setEnableBackplane(false)
      .setEnableExtendResponseRegion(false)
      .setEnableTouchMask(false)
      .setEnableHoverAnimation(false)
      .setEnableShadow(true)
      // AppItem自定义菜单, 不使用图标组件内部菜单
      .setEnableMenu(false)
      .setEnableDynamicIconShadow(true)
      .setIconContainerSize(PcSmartDockStyleManager.getStyle(this.screenProp).mListItemWidth)
      .setAppDataOfTransactionController(appData)
      .setExternCb({
        isDisableMask: this.isDisableMaskHandler
      })

    if (DeviceHelper.is2In1DevicePcType()) {
      this.appIconConfig.setEnableRadiusAll(true);
    }
  }

  private updateListItemWidth(): void {
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    this.listItemWidth = config.mListItemWidth + config.mListItemGap;
  }

  private recycleBinCallback = (isEmpty: boolean) => {
    log.showInfo(`recycleBinCallback next: ${isEmpty}, curr: ${this.isRecycleBinEmpty} screenId: ${this.screenId}`);
    if (DeviceHelper.is2In1DevicePcType()) {
      if (this.isRecycleBinEmpty !== isEmpty) {
        this.isRecycleBinEmpty = isEmpty;
        this.iconImageModel.updateIcon(this.appInfo, this.iconData, this.iconSize);
      }
      return;
    }

    if (isEmpty) {
      log.showInfo('set recycleBin empty');
      this.isRecycleBinEmpty = true;
      this.iconData.foregroundImagePixel = StyleConstants.DEFAULT_RECYCLE_BIN_FOREGROUND_IMAGE;
    } else {
      log.showInfo('set recycleBin full');
      this.isRecycleBinEmpty = false;
      this.iconData.foregroundImagePixel = StyleConstants.DEFAULT_RECYCLE_BIN_FULL_FOREGROUND_IMAGE;
    }
  }

  private registerRecycleBinListener(): void {
    log.showInfo(`dock registerRecycleBinListener`);
    this.fileFolderManager.registerRecycleBinListener(this.screenId, this.recycleBinCallback);
  }

  private unRegisterRecycleBinListener(): void {
    log.showInfo(`dock unRegisterRecycleBinListener`);
    this.fileFolderManager.unRegisterRecycleBinListener(this.screenId);
  }

  private initRecycleBinIconState(): void {
    this.fileFolderManager.refreshRecycleBinIconState(this.recycleBinCallback);
  }

  private getMenuEnable(): boolean {
    return (!this.mPCDockDragMgr.isDockDragging) && this.itemVisibility === Visibility.Visible
      && !this.pcDockAnimationMgr.isListScrolling();
  }

  private checkIsRunning(): boolean {
    return SmartDockModel.getInstance().checkAppIsRunning(this.appInfo);
  }

  private isDark(): boolean {
    return this.currColorMode === 0;
  }

  private isShowRunTaskIcon(): boolean {
    if (this.appInfo.bundleName === CommonConstants.LAUNCHER_BUNDLE) {
      return false;
    }
    return this.animatedIconId != this.appInfo?.appIconId;
  }

  /**
   * resident local Listener
   */
  @Builder MenuBuilder() {
    if (this.prepareMenu()) {
    }
    if (this.getMenuEnable()) {
      DockMenu({
        viewModel: this.dockMenuViewModel,
        ratio: this.ratio,
        closeMenu: () => {
          this.popupMgr.setIsDockMenuShow(this.screenProp.screenId, false);
          SCBSceneSessionManager.getInstance().updateSystemBarProperty();
        },
        minTextWidth: FixedDockResource.MENU_TEXT_WIDTH,
        menuOnAppear: this.menuOnAppear,
        menuOnDisAppear: this.menuOnDisAppear
      })
        .id(`${this.getIdPrefixForIcon()}_AppMenu_MenuBuilder`)
    }
  }

  @Builder SuggestMenuBuilder() {
    if (this.getMenuEnable()) {
      SuggestAppMenu({
        menuInfoList: this.dockMenuViewModel.getAllMenuInfoList(),
        closeMenu: () => {
          this.popupMgr.setIsDockMenuShow(this.screenProp.screenId, false);
          SCBSceneSessionManager.getInstance().updateSystemBarProperty();
        },
        ratio: this.ratio,
        minTextWidth: this.minSuggestMenuTextWidth,
        menuOnAppear: this.menuOnAppear,
        menuOnDisAppear: this.menuOnDisAppear,
        screenId: this.screenId
      })
        .id('ResidentLayoutForPC_suggestAppMenu_MenuBuilder')
    }
  }

  @Builder
  ContinueItemPopupBuilder(info: DockContinuableInfo) {
    Column() {
      Text(this.continueAppName ? this.continueAppName : info?.appName)
        .draggable(false)
        .fontSize(SmartDockConstants.CONTINUABLE_ICON_POPUP_TITLE_SIZE)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .margin(SmartDockConstants.CONTINUABLE_ICON_POPUP_TEXT_MARGIN)
      Text($r('app.string.continue_hap_come_from', this.continueDeviceName ? this.continueDeviceName :
        info?.sourceDeviceName))
        .draggable(false)
        .fontSize(SmartDockConstants.CONTINUABLE_ICON_POPUP_DESC_SIZE)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .margin(SmartDockConstants.CONTINUABLE_ICON_POPUP_TEXT_MARGIN)
    }
    .alignItems(HorizontalAlign.Start)
    .padding(SmartDockConstants.CONTINUABLE_ICON_POPUP_PADDING)
  }

  @Builder defaultBuilder() {
    AppIconCommonView({
      iconBadgeVm: this.iconBadgeVm,
      item: this.appInfo,
      appIconConfig: this.appIconConfig,
      iconSize: this.iconSize,
      iconRadius: this.iconBorderRadios,
      iconEvent: this.appIconCommonEvent,
      iconData: this.iconData,
      iconContainerModifier: this.appIconContainerModifier,
    })

    RunningTask({
      appInfo: this.appInfo,
      ratio: this.ratio,
      shadowStyle: {
        radius: SmartDockConstants.RUNNING_SHADOW_RADIUS,
        color: SmartDockConstants.RUNNING_SHADOW_COLOR,
        offsetY: SmartDockConstants.RUNNING_SHADOW_OFFSETY
      },
      currColorMode: this.currColorMode
    })
      .height(this.getBottomBinaryHeight())
      .padding({ top: StyleConstants.DEFAULT_6 * this.ratio})
      .visibility(this.isShowRunTaskIcon() ? Visibility.Visible : Visibility.Hidden)
      .transition(TransitionEffect.opacity(0).animation({
        duration: 100,
      }))
  }

  private getAppIconByInfo(appInfo: DockItemInfo) {
    log.showInfo(`getAppIconByInfo keyName: ${appInfo.keyName}`);
    return ResourceManager.getInstance().getCachedAppIcon(appInfo.appIconId,
      appInfo.bundleName as string, appInfo.moduleName as string);
  }

  private getAppIconSize(): number {
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    return (config.mIconSize - StyleConstants.DEFAULT_3 * StyleConstants.DEFAULT_2 * this.ratio);
  }

  @Builder dropFrameBuilder() {
    Column() {
      Row()
        .backgroundColor(this.isDark() ? FixedDockResource.FRAME_BACKGROUND_DARK_COLOR :
          FixedDockResource.FRAME_BACKGROUND_LIGHT_COLOR)
        .width(PcSmartDockStyleManager.getStyle(this.screenProp).mListItemWidth)
        .height(PcSmartDockStyleManager.getStyle(this.screenProp).mListItemHeight)
        .borderWidth('1px')
        .borderColor(SmartDockConstants.DOCK_DROP_FRAME_BORDER_COLOR)
        .borderRadius(this.iconBorderRadios)
        .outlineWidth('1px')
        .outlineColor(this.isDark() ? FixedDockResource.OUTLINE_DART_COLOR :
          FixedDockResource.OUTLINE_LIGHT_COLOR)
        .outlineRadius(this.iconBorderRadios)
        .transition(TransitionEffect.IDENTITY)
        .margin({
          top: this.getTopBinaryHeight()
        })
        .onAreaChange((oldValue: Area, newValue: Area) => {
          let rect: Rectangle = {
            x: newValue.globalPosition.x,
            y: newValue.globalPosition.y,
            width: newValue.height,
            height: newValue.height
          };
          this.mPCDockDragMgr.setDropFrameRect(rect, this.appInfo?.bundleName);
        })
    }
    .width(PcSmartDockStyleManager.getStyle(this.screenProp).mListItemWidth +
        PcSmartDockStyleManager.getStyle(this.screenProp).mListItemGap)
    .padding({
      left: this.appItemPadding,
      right: this.appItemPadding
    })
    .height('100%')
  }

  private isAdaptiveCalendarIcon(): boolean {
    const isDynamicIcon = AppIconModel.getInstance().isDynamicIcon(this.appInfo);
    return isDynamicIcon &&
      this.appInfo?.bundleName === CommonConstants.CALENDAR_BUNDLE;
  }

  aboutToAppear(): void {
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    this.ratio = config.updateConfig(this.screenProp);
    log.showInfo(`aboutToAppear, screenId: ${this.screenId}`);
    this.iconBorderRadios *= this.ratio;
    this.iconBadgeVm.ratio = this.ratio;
    this.iconSize = config?.mIconSize;
    this.pcDockAnimationMgr = PcDockAnimationMgr.getInstance(this.screenId);
    this.dockMenuViewModel.init(this.screenProp.screenId, this.appInfo, this.dockType);
    if (this.isAppCenter(this.appInfo)) {
      SuggestMenuModel.getInstance();
    }
    this.updateListItemWidth();
    this.eventListener();
    this.registerWpsEvent();

    localEventManager.registerEventListener(this.updateIconDragListener, [EventConstants.EVENT_PC_DOCK_DRAG_CHANGE])
    localEventManager.registerEventListener(this.dockItemChangeListener, [EventConstants.EVENT_PC_DOCK_ITEM_CHANGE]);
    localEventManager.registerEventListener(this.dockItemHoverListener,
      [EventConstants.EVENT_PC_DOCK_ITEM_HOVER_CHANGE]);
    localEventManager.registerEventListener(this.dockAppItemListener,
      [EventConstants.EVENT_REQUEST_DOCK_CTRL_Q_CALLBACK]);
    if (!SCBSceneSessionManager.getInstance().isPcMode() &&
      this.appInfo?.abilityName === CommonConstants.RECYCLE_BIN_ABILITY) {
      // 如果不设置延迟执行，读取持久化数据会失败
      setTimeout(() => {
        log.showInfo(`recycleBin persistent isRecycleBinEmpty: ${this.isRecycleBinEmpty}`);
        if (DeviceHelper.is2In1DevicePcType()) {
          this.iconImageModel.updateIcon(this.appInfo, this.iconData, this.iconSize);
        } else {
          this.iconData.foregroundImagePixel = this.isRecycleBinEmpty
            ? StyleConstants.DEFAULT_RECYCLE_BIN_FOREGROUND_IMAGE
            : StyleConstants.DEFAULT_RECYCLE_BIN_FULL_FOREGROUND_IMAGE;
        }
      }, 300);
      // 注册主副屏的回收站回调
        setTimeout(() => {
          log.showInfo('recycleBin appear, try register listener');
          this.registerRecycleBinListener();
        }, 1000);
    }
    this.pcDockAnimationMgr.registerCompanionEffect(this.appInfo, this.companionEffect);
    if (this.appInfo?.appIndex !== undefined && this.appInfo?.appIndex > 0) {
      this.snapshotId = `${this.getIdPrefixForIcon()}_AppIcon_${this.appInfo?.bundleName}_${this.appInfo?.appIndex}`;
    } else {
      this.snapshotId = `${this.getIdPrefixForIcon()}_AppIcon_${this.appInfo?.bundleName}`;
    }
    if (SCBSceneSessionManager.getInstance().mainScreenId === this.screenId) {
      this.isAllowDockDragMoveOrDrop = this.mPCDockDragMgr.getDockDragMoveOrDropEnable(this.appInfo, this.residentFlag);
      this.isAllowDockDragStart =
        this.mPCDockDragMgr.getDockDragStartEnable(this.appInfo, false);
      this.initDragEventCallback();
      this.mPCDockDragMgr.registerDragEvent(this.mDragEventCallback, this.appInfo);
    }
    this.updateIsDraggable();
    this.initAppIconConfig();
    this.initContinueBadgeStatus();
    this.appIconId = AppIconModel.getInstance().getIconId(this.appInfo);
    this.registerSessionIconListener();
    this.pcDockAnimationMgr.setIconData(this.appInfo, this.iconData);
    log.showInfo('aboutToAppear bunleName: ' + this.appInfo?.bundleName + ', abilityName: ' + this.appInfo?.abilityName +
    ', allowDrag: ' + this.isAllowDockDragMoveOrDrop + ',' + this.isAllowDockDragStart + ', appIconId: ' + this.appIconId);
  }

  private registerSessionIconListener(): void {
    if (!CheckEmptyUtils.isEmpty(this.appInfo?.persistentId)) {
      log.showDebug(`registerSessionIconListener bunleName: ${this.appInfo?.bundleName}, abilityName: ${this.appInfo?.abilityName}, ` +
       `persistentId: ${this.appInfo?.persistentId}`);
      SCBSceneSessionManager.getInstance().registerSessionIconListener(this.appInfo?.persistentId,
        this.sessionIconListener);
    }
  }

  private unRegisterSessionIconListener(): void {
    if (!CheckEmptyUtils.isEmpty(this.appInfo?.persistentId)) {
      log.showDebug(`unRegisterSessionIconListener bunleName: ${this.appInfo?.bundleName}, abilityName: ${this.appInfo?.abilityName}, ` +
       `persistentId: ${this.appInfo?.persistentId}`);
      SCBSceneSessionManager.getInstance().unRegisterSessionIconListener(this.appInfo?.persistentId,
        this.sessionIconListener);
    }
  }

  private sessionIconListener: SessionIconListener = {
    onUpdate: (icon: image.PixelMap) => {
      if (!CheckEmptyUtils.isEmpty(this.appInfo?.persistentId)) {
        const image = SCBSceneResourceManager.getInstance().getSessionIconCache(this.appInfo?.persistentId);
        log.showInfo(`onUpdate image: ${!image}`);
        if (!CheckEmptyUtils.isEmpty(image)) {
          this.iconData.image = image as string | PixelMap;
          return;
        }
      }
    }
  }

  private updateDockDropFrameState(state: boolean): void {
    this.desktopContext?.eventHub.emit(DragConstants.WHITE_BOX_CHANGE_EVENT, state);
    log.showInfo(`updateDockDropFrameState: ${state}`);
  }

  private initDragEventCallback(): void {
    this.mDragEventCallback = {
      onItemDragStartEvent: (): void => {
        log.showInfo(`onItemDragStartEvent ${this.appInfo?.bundleName},appIndex:${this.appInfo?.appIndex}`);
        this.itemVisibility = Visibility.None;
      },
      onItemDropStartEvent: (): void => {

      },
      onItemDropEndEvent: (): void => {
        // 显示起拖图标
        log.showInfo(`onItemDropEndEvent ${this.appInfo?.bundleName},appIndex:${this.appInfo?.appIndex}`);
        this.itemVisibility = Visibility.Visible;
      },
      onStartSqueezedEvent: (event, params): void => {
        // 显示落位框
        const isShowRight = params?.options as boolean ?? false;
        log.showInfo(`onStartSqueezedEvent ${this.appInfo?.bundleName}, ${this.mPCDockDragMgr.isDragStartDropFrameShow},appIndex:${this.appInfo?.appIndex} ${isShowRight}`);
        const popupItem = this.popupMgr.getCurShowingItem();
        if (popupItem) {
          this.popupMgr.hide(this.screenId);
        }
        if (this.mPCDockDragMgr.isDragStartDropFrameShow) {
          this.isShowDropFrame = true;
          this.isShowRightDropFrame = isShowRight;
          this.updateDockDropFrameState(this.isShowDropFrame);
        } else {
          animateTo({
            curve: curves.interpolatingSpring(0, 1, 660, 66)
          }, () => {
            this.isShowDropFrame = true;
            this.isShowRightDropFrame = isShowRight;
            this.updateDockDropFrameState(this.isShowDropFrame);
          })
        }
      },
      onCancelSqueezedEvent: (hasAnimation: boolean): void => {
        // 隐藏落位框
        log.showInfo(`onCancelSqueezedEvent ${this.appInfo?.bundleName}, hasAnimation: ${hasAnimation}`);
        if (hasAnimation) {
          animateTo({
            curve: curves.interpolatingSpring(0, 1, 660, 66)
          }, () => {
            this.isShowDropFrame = false;
            this.updateDockDropFrameState(this.isShowDropFrame);
          })
        } else {
          this.isShowDropFrame = false;
          this.updateDockDropFrameState(this.isShowDropFrame);
        }
      }
    }
  }
  private isNeedResetAllEffect(event: MouseEvent): boolean {
    return event?.y < 0 || event.x < 0 || event.x > this.listItemWidth &&
       (event.button === MouseButton.Right || event.button === MouseButton.Left);
  }

  aboutToDisappear(): void {
    localEventManager.unregisterEventListener(this.updateIconDragListener)
    localEventManager.unregisterEventListener(this.dockItemChangeListener);
    localEventManager.unregisterEventListener(this.dockItemHoverListener);
    localEventManager.unregisterEventListener(this.dockAppItemListener);
    this.unregisterWpsEvent();
    this.pcDockAnimationMgr.unRegisterCompanionEffect(this.appInfo, this.companionEffect);
    this.eventMgr.offAll();
    if (!SCBSceneSessionManager.getInstance().isPcMode() &&
      this.appInfo?.abilityName === CommonConstants.RECYCLE_BIN_ABILITY) {
      this.unRegisterRecycleBinListener();
    }
    this.mPCDockDragMgr.unRegisterDragEvent(this.mDragEventCallback, this.appInfo);
    this.appIconShadowViewModel?.destroy();
    this.unRegisterSessionIconListener();
    this.pcDockAnimationMgr.deleteIconData(this.appInfo);
    log.showInfo(`aboutToDisappear bunleName: ${this.appInfo?.bundleName}, abilityName: ${this.appInfo?.abilityName}`);
  }

  build() {
    Row() {
      if (this.isShowDropFrame && !this.isShowRightDropFrame) {
        this.dropFrameBuilder();
      }
      Column() {
          this.defaultBuilder();
      }
      .id(PCDockUtils.getAppItemColumnId(this.appInfo))
      .visibility(this.itemVisibility)
      .width(this.listItemWidth)
      .padding({
        left: this.appItemPadding,
        right: this.appItemPadding
      })
      .bindContextMenu(this.isAppCenter(this.appInfo) ? this.SuggestMenuBuilder() : this.MenuBuilder(),
        ResponseType.RightClick, this.getMenuOptions())
      .bindContextMenu(this.isGestureMenuShow,
        this.isAppCenter(this.appInfo) ? this.SuggestMenuBuilder() : this.MenuBuilder(), this.getMenuOptions())
      .onHover((isHover: boolean, event: HoverEvent) => {
        if (event.sourceTool === SourceTool.Pen) {
          return;
        }
        if (!isHover) {
          this.iconData.isShowMask = this.isShowDockMenu;
          this.appItemMouseEvent = undefined;
          this.appIconShadowViewModel?.onIconShadowAnimateOutForPc();
          this.updateHoverConfigForPC(false);
        }
        if (isHover && this.mPCDockDragMgr.isDropping()) {
          log.showWarn('isDropAnimationGoing true');
          // 拖拽释放的时候触发了一次hover true
          return;
        }
        this.checkPopupShow(isHover, this.appInfo);
      })
      .onMouse((event: MouseEvent) => {
        if (event?.action === MouseAction.Press && !this.isAllowDockDragStart) {
          this.isMousePressed = true;
        } else if (event?.action === MouseAction.Release || event?.action === MouseAction.CANCEL) {
          this.isMousePressed = false;
        }

        if (this.mPCDockDragMgr.isDockDragging) {
          return;
        }
        this.updateIsDraggable();
        if (event?.action === MouseAction.Press) {
          this.iconData.isShowMask = true;
        } else if (event?.action === MouseAction.Release) {
          this.iconData.isShowMask = false;
        }
        if ((event?.action === MouseAction.Move || event?.action === MouseAction.Hover) &&
          !ViewManagerPolicy.isViewShowing(ViewType.KEYGUARD) &&
          !this.isMousePressed) {
          let lastIsNeedReset = this.isNeedReset;
          this.isNeedReset = this.isNeedResetAllEffect(event);
          if (!lastIsNeedReset && this.isNeedReset) {
            this.iconData.isShowMask = false;
            this.pcDockAnimationMgr.resetAllEffect();
          } else if (!this.isNeedReset && !this.pcDockAnimationMgr.isListScrolling()) {
            this.onHoverItemScale(true, event?.x, event?.y);
          }
        }
        this.onMouseItem(event, this.appInfo);
        if (event?.button === MouseButton.None && event?.action === MouseAction.Move) {
          this.onMouseAppIconShadow(event);
        }
      })
      .onClick((event?: ClickEvent) => {
        // 拖拽前初始化拖拽落位位置
        this.mPCDockDragMgr.setDragMovePos(event?.windowX as number, event?.windowY as number);
      })
      .parallelGesture(
        GestureGroup(GestureMode.Exclusive,
          LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_HIDE_BADGE })
            .onAction((event: GestureEvent) => {
              if (event?.source === SourceType.TouchScreen) {
                log.showInfo(`longPressGesture isDockDragging: ${this.mPCDockDragMgr.isDockDragging}`);
                this.isLongGesture = true;
                // 绑定手势时，当存在未被dragstart消费的长按手势时，手指或鼠标抬起时，触发了一次onclick。故只在允许dragStart的图标上处理
                if (!this.mPCDockDragMgr.isDockDragging) {
                  this.isGestureMenuShow = true;
                  this.popupMgr.setIsDockMenuShow(this.screenProp.screenId, true);
                }
              }
            }),
          TapGesture()
            .onAction((event: GestureEvent) => {
              const isTouchScreen: boolean = event.source === SourceType.TouchScreen;
              this.onClickItem(null, this.appInfo, isTouchScreen);
            })
        )
      )
      if (this.isShowDropFrame && this.isShowRightDropFrame) {
        this.dropFrameBuilder();
      }
    }
    .onDrop((event?: DragEvent, extraParams?: string) => {
      performanceMonitor.end(HiSysEventUtil.DRAG_ITEM_ANI);
      log.showInfo(`onDrop ${this.isAllowDockDragMoveOrDrop}`);
      if (this.isAllowDockDragMoveOrDrop) {
        this.mPCDockDragMgr.onDrop(this.iconBorderRadios);
        this.checkPopupShow(false, this.appInfo);
      }
      if (!(event && extraParams && this.getDragUris)) {
        log.showError('onDrop params is invalid');
        return;
      }
      event.useCustomDropAnimation = true;
      event.setResult(DragResult.DRAG_FAILED);
      this.isShow = false;
      this.popupMgr.setIsDockMenuShow(this.screenProp.screenId, false);
      this.onHoverIconHandler(false);
      if (!this.appInfo || this.appInfo?.abilityName !== CommonConstants.RECYCLE_BIN_ABILITY) {
        return;
      };
      let uris: string[] = this.getDragUris(event, extraParams);
      if (uris.length === 0) {
        return;
      }
      this.desktopContext?.eventHub.emit('dropToTrash', uris);
      event.setResult(DragResult.DRAG_SUCCESSFUL);
      let want: Want = {
        'bundleName': 'com.ohos.filemanager',
        'abilityName': 'RecycleBinServiceExtAbility',
        'parameters': {
          'mode': 'delete',
          'uris': uris
        }
      };
      try {
        GlobalContext.getContext().startServiceExtensionAbility(want).then(() => {
          log.showInfo('startServiceExtensionAbility success');
        }).catch((error: string) => {
          log.showInfo('startServiceExtensionAbility failed:' + error);
        })
      } catch (error) {
        log.showError('startAbilityForResult error : ' + error);
      }
    })
    .onDragEnter((event?: DragEvent, extraParams?: string) => {
      const dragItemInfo: GridLayoutItemInfo[] | undefined = AppStorage.get<GridLayoutItemInfo[]>('dragItemInfo');
      if (dragItemInfo && dragItemInfo.length > 1) {
        return;
      }
      this.checkPopupShow(true, this.appInfo);
      if (this.isAllowDockDragMoveOrDrop) {
        this.mPCDockDragMgr.onDragEnter(this.appInfo);
        this.mPCDockDragMgr.updateDragItemIconCache(PcSmartDockStyleManager.getStyle(this.screenProp).mIconSize);
      }
    })
    .onDragLeave((event?: DragEvent, extraParams?: string) => {
      if (!this.popupMgr.isDockMenuShow(this.screenProp.screenId)) {
        animateTo({
          curve: HoverEffectConstants.FIXED_HOVER_EFFECT_CURVES,
        }, () => {
          this.pcDockAnimationMgr.resetAllEffect();
          this.listWidthChange(this.residentFlag, 0);
        })
      }
      this.checkPopupShow(false, this.appInfo);

      if (this.isAllowDockDragMoveOrDrop) {
        this.mPCDockDragMgr.onDragLeave(this.appInfo);
      }
    })
    .onTouch((event: TouchEvent)=>{
      AppStorage.setOrCreate<string>('hoverItemBundleName', this.appInfo?.bundleName);
      if (event.type === TouchType.Down && !this.mPCDockDragMgr.isDockDragging) {
        log.showInfo(`dock item touch Press bundleName: ${this.appInfo?.bundleName}, abilityName: ${this.appInfo?.abilityName}`);
        this.initDockMenuInfo();
        this.iconData.isShowMask = true;
        this.popupMgr.hideOnClickItem(this.screenId, this.appInfo);
      }
      if ((event?.type === TouchType.Up || event?.type === TouchType.Cancel) && !this.isShowDockMenu) {
          this.iconData.isShowMask = false;
        }
    })
    .onDragMove((event: DragEvent) => {
      if (this.isAllowDockDragMoveOrDrop) {
        this.mPCDockDragMgr.onDragMove(this.appInfo, this.dockType, this.itemRect, event);
      }
    })
  }

  getDragUris(event: DragEvent, extraParams: string): string[] {
    let uris: string[] = [];
    try {
      let dragData: UnifiedData = event.getData();
      if (dragData != undefined) {
        let record = dragData.getRecords();
        let len: number = record.length;
        log.showInfo('record.length: ' + len);
        let dataContent = '';
        for (let i: number = 0; i < len; i++) {
          let type: string = record[i].getType();
          dataContent = UdmfUtils.getRecordData(record[i], type);
          if (dataContent != '') {
            uris.push(dataContent);
          }
        }
        if (uris.length === 0 && extraParams.includes('extraInfo')) {
          try {
            JSON.parse(JSON.parse(extraParams).extraInfo).forEach((moveUri: string) => {
              uris.push(moveUri);
            })
          } catch (error) {
            log.showError(`getDragUris failed: ${error}, extraParams: ${extraParams}`);
          }
        }
      }
    } catch (error) {
      log.showError(`getDragUris failed: ${error}, extraParams: ${extraParams}`);
    }
    return uris;
  }
}


