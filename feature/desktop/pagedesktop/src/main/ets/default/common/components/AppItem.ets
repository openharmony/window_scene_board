/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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
  StyleConstants,
  PresetStyleConstants,
  CommonConstants,
  GrayAppListManager,
  AppItemInfo,
  MenuInfo,
  AppGalleryDownloadManager,
  UninstallDialogStatus,
  LaunchLayoutCacheManager,
  EditModeUtils,
  ShortcutViewModel,
  CloseAppManager,
  AppIconModel,
  AppDataWrapper,
  AppInstallUtils,
  keyEventManager,
  CardItemInfo,
  PageDesktopViewModelForPC,
  DragAppToFolderData,
  UninstallListener,
  DragCoveredItem
} from '@ohos/launchercommon';
import {
  UninstallDialog,
  AppIconContainerModifier,
  AppIconConfig,
  AppIconCommonView,
  DeskTopItemStyle,
  dragTriggerUtil,
  AppIconDefaultModifier,
  AppIconCommonEvent,
  nameAppearAnimate,
  AppNameModifier
} from '@ohos/launchercommon/Index';
import {
  StartType,
  LogDomain,
  LogHelper,
  CheckEmptyUtils,
  DomainName,
  TraceUtil,
  CommonUtils,
  SingleContext
} from '@ohos/basicutils';
import {
  HiSysEventUtil,
  GlobalContext,
  DeviceHelper,
  DownloadingProgressChangeEvent,
  DownloadStatusChangeEvent,
  localEventManager,
  ResourceManager,
  IconResourceManager,
} from '@ohos/frameworkwrapper';
import { scbEventExclusiveManager, EventType, SCBSceneSessionManager } from '@ohos/windowscene';
import {
  CellAndSpan,
  DragExtraInfo,
  DragDataType,
  DragEventManager,
  windowManager
} from '@ohos/componentdrag';
import { DropAnimationScene } from '@ohos/componentanimator';
import { SwiperLoadData } from '@ohos/swiperdata';
import { DragConstants, NumberConstants, SCBConstants } from '@ohos/commonconstants';
import { MemoryManager } from '@ohos/frameworkcommon';
import { dragSnapshotHelper, ObjectCopyUtil, SnapshotType, ItemUtils } from '@ohos/componenthelper';
import { PageDesktopDragHandler } from '../PageDesktopDragHandler';
import {
  FormCardItem,
  FormManagerDialog
} from '@ohos/form/src/main/ets/default/common/uicomponents/FormManagerDialog';
import { PageDesktopViewModel } from '../viewmodel/PageDesktopViewModel';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { GridLayoutItemInfo, EventConstants } from '@ohos/launchercommon';
import curves from '@ohos.curves';
import { AppGalleryEventInfo } from '@ohos/launchercommon';
import { AppStatus, DownloadStatusInfo } from '@ohos/launchercommon';
import { GridLayoutUtil } from '@ohos/launchercommon';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import { dropAnimationManager, ForceType, GravityAnimationConfig } from '@ohos/componentanimator/Index';
import { multiSelectListenerManger } from '../MultiSelectListenerManager';
import { componentUtils, display, LengthMetrics, performanceMonitor } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { DragControllerParams } from '@ohos/componenthelper/Index';
import {
  gravityAnimationManager
} from '@ohos/componentanimator/src/main/ets/service/animator/gravity/manager/GravityAnimationManager';
import {
  AppIconHoverEventIface
} from '@ohos/launchercommon/src/main/ets/launchericon/interface/AppIconHoverEventIface';
import { AppIconTouchEvent } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconTouchEvent';
import { AppIconBackplaneVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconBackplaneVm';
import { AppIconMenuVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconMenuVm';
import { AppIconData } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconData';
import { AppNameVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppNameVm'
import { AppIconDragEventIface } from '@ohos/launchercommon/src/main/ets/launchericon/interface/AppIconDragEventIface';
import {
  AppIconGestureJudgeIface
} from '@ohos/launchercommon/src/main/ets/launchericon/interface/AppIconGestureJudgeIface';
import measure from '@ohos.measure';
import type ctx from '@ohos.app.ability.common';
import UDC from '@ohos.data.unifiedDataChannel';
import { PageDesktopGridStyleConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';
import { KeyCode } from '@kit.InputKit';
import inspector from '@ohos.arkui.inspector';
import { AppItemViewIf } from '@ohos/launchercommon/src/main/ets/pagedesktop/viewmodel/DesktopItemBuilderProxy';

const UNINSTALL_APP_DURATION = 500;

const TAG = 'Desktop-AppItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const FOREGROUND_BLUR_RADIUS = 70;
const MAX_HOVER_TIPS_WIDTH : number = 480;
const CLICK_DELAY: number = 300;
const defaultMenuOffset: Position = {x: 0, y: 5};
const POPUP_WIDTH_FROM_THE_SCREEN: number = 8;
const HOVER_MENU_FONT_SIZE: number = 14;
const TEXTAREA_MIN_HEIGHT: number = 22;
const NO_KEYBOARD_STATUS = -1;
const regionAppAnimScale: AnimationRange<number> =
  [StyleConstants.MENU_ANIMATION_FROM_ICON, StyleConstants.MENU_ANIMATION_FROM];

@Component
export default struct AppItem {
  @StorageLink('dragItemType') dragItemType: number = CommonConstants.DRAG_FROM_DESKTOP;
  @Prop singleContext?: SingleContext;
  @StorageLink('uninstallAppInfo') appInfo: AppItemInfo = new AppItemInfo();
  @StorageLink('formAppInfo') formAppInfo: AppItemInfo = new AppItemInfo();
  @State mIconBlur: number = -1;
  @State animateScale: number = 1.0;
  @State mAppNameHeight: number = StyleConstants.DEFAULT_APP_NAME_HEIGHT;
  @Prop mMaxNameLines: number = PresetStyleConstants.DEFAULT_APP_NAME_LINES;
  mIconNameMarginTop: number = StyleConstants.DEFAULT_6;
  private item: AppItemInfo = new AppItemInfo();
  private mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance(this.singleContext);
  private isPad: boolean = false;
  private mPageDesktopDragHandler?: PageDesktopDragHandler;
  private clearForm?: Function;
  private isExistsItem: boolean = false;
  @State isAppBubbleBackgroundOpen: boolean = false;
  @State appBubbleBackplaneRatio: number = 1;
  @State itemScale: number = 1;
  @State isDragFlag: boolean = false;
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  @Consume isShowingUninstallDialog: number;
  @Consume dragToUninstallItemInfo: AppItemInfo;
  @Provide titleDisappearStatus: boolean = false;
  private getIndexInSwiper: Function = (): number => 0;
  private isDesktopItem: boolean = false;
  private containerBelong?: GridLayoutItemInfo;
  @Provide itemAppStatus: AppStatus = AppStatus.INSTALLED;
  private iconScale: number = 1.0;
  private iconData: AppIconData = new AppIconData();
  @Prop @Watch('onSelectChange') isSelect: boolean = false;
  @Prop isGainFocus: boolean = false;
  private menuInfo: MenuInfo[] = [];
  onItemSelect?: Function;
  dragStart?: Function;
  dragEnd?: Function;
  private onCoveredAppEvent: Function = (isShow: boolean): void => this.onEventhubCoveredItemEvent(isShow);
  private onCancelUninstallEvent: Function = (isCancel: boolean): void => this.onEventhubCancelItemEvent(isCancel);
  private onAppItemAccessibilityClickEvent: Function = (): void => this.appItemAccessibilityClickEvent();
  private onAppGalleryStatusChangeEvent: Function = (eventInfo: AppGalleryEventInfo):
    void => this.appGalleryStatusChangeEvent(eventInfo);

  @ObjectLink @Watch('onDesktopStyleChange') desktopStyle: DeskTopItemStyle;
  @StorageLink('itemPadding') @Watch('onItemPaddingChange') itemPadding: number = 0;
  private appIconContainerModifier: AppIconContainerModifier = new AppIconContainerModifier(
    () => this.updateModifier());
  private disableMaskModifier: AppIconContainerModifier = new AppIconContainerModifier();
  private appNameVm: AppNameVm = new AppNameVm();
  private appIconConfig: AppIconConfig = new AppIconConfig();
  private iconEvent: AppIconCommonEvent = new AppIconCommonEvent();
  private isMultiSelect: boolean = false;
  private multiSelectMap: Map<string, image.PixelMap> = new Map();
  private backplaneVm: AppIconBackplaneVm = new AppIconBackplaneVm();
  private backPlaneTopMargin: number = StyleConstants.DEFAULT_5;
  private dBackPlaneSize: number = StyleConstants.DEFAULT_8;
  @State iconMenuVm: DeskTopIconMenuVm = new DeskTopIconMenuVm();
  private menuOffset: Position = defaultMenuOffset;
  private layoutRegionMargin: Margin | undefined = DeviceHelper.isBigScreenMachine() ? {
    top: 0,
    left: 0,
    right: 0,
    bottom: 0
  } : undefined;
  private rectangleSelect: boolean = false;
  @State appNameHover : boolean = false;
  @State isShowNameHoverTips: boolean = false;
  @State hoverTipAppNameLenVp: number = 0;
  @Link isDragStart: boolean;
  @Link @Watch('inDragStateChange') isInDrag: boolean;
  private hoverTipDisPlayPosition: Position = { x: 0, y: 0 };
  private hoverTipPosition: Position = { x: 0, y: 0 };
  private displayWidth: number = windowManager.getWindowWidth() ?? 0;
  private displayHeight: number = windowManager.getWindowHeight() ?? 0;
  private timerId: number = -1;
  @Consume translateX: number;
  @Consume translateY: number;
  @Consume itemOpacity: number;
  @StorageLink('isDrag') isDrag: boolean = true;
  private unInstallListener: UninstallListener = {
    uninstallApp: (bundleName: string): void => {},
    uninstallAppResult: (bundleName: string, resultCode: number, appIndex?: number, shortcutId?: string):
      void => this.uninstallAppResult(bundleName, resultCode, appIndex, shortcutId)
  };
  private itemKey: string = '';
  private appGalleryStatusChangeEventId: string = '';
  private isClicked: boolean = false;
  styleConfig:PageDesktopGridStyleConfig = this.mPageDesktopViewModel.getPageDesktopStyleConfig();
  @Prop mIconSize: number = this.styleConfig.mIconSize;
  @State mAppNameSize: number = this.styleConfig.mNameSize;
  @Prop mAppNameWidth: number = this.styleConfig.mNameWidth;
  private iconRadius: number = this.styleConfig.mIconRadius;
  private marginValue: Margin = {
    top: PresetStyleConstants.DEFAULT_ICON_NAME_GAP
  };
  private paddingValue : Padding = {
    bottom: StyleConstants.DEFAULT_2,
    top: StyleConstants.DEFAULT_2,
    left: StyleConstants.DEFAULT_2,
    right: StyleConstants.DEFAULT_2
  };
  @Prop nameFontColor: string = this.mPageDesktopViewModel.getPageDesktopStyleConfig().mNameFontColor;
  @StorageProp('desktopIconChange') @Watch('onIconChange') desktopIconChange: number = 0;
  private isIconSizeFixed: boolean = false;
  @Consume @Watch('onFocusedChange') isFocused: boolean;
  private containerItem?: GridLayoutItemInfo;
  private componentObserver: inspector.ComponentObserver | null = null;
  // 是否开启节点组缓存
  @State enableRenderGroup: boolean = true;
  private enableRenderGroupChange: Function = (enableRenderGroup: boolean) => {
    this.enableRenderGroup = enableRenderGroup;
  }

  onFocusedChange(): void {
    log.showInfo(`AppItem onFocusedChange ${this.item.appName}, isFocused:${this.isFocused}`);
    if (this.isFocused) {
      focusControl.requestFocus(`${TAG}_app_${this.itemKey}`);
    }
  }

  private onIconChange(): void {
    if (this.isIconSizeFixed) {
      log.showInfo(`region folder icon size not change`);
      return;
    }
    this.mIconSize = this.mPageDesktopViewModel?.getPageDesktopStyleConfig()?.mIconSize;
    log.showInfo(`desktopIconChange Icon is: ${this.desktopIconChange}, iconSize: ${this.mIconSize}`);
  }

  private initEventhubEvent(): void {
    // 注册appItem覆盖背板动效事件
    let coveredItemEventId: string = `coveredApp${this.item.keyName}`;
    if (coveredItemEventId !== '') {
      this.desktopContext?.eventHub.off(coveredItemEventId);
      this.desktopContext?.eventHub.on(coveredItemEventId, this.onCoveredAppEvent);
      log.showDebug(`onEventhubCoveredItemEvent for AppItem ${coveredItemEventId}`);
    }

    let cancelItemEventId: string = `cancelUninstall${this.item.keyName}`;
    if (!CheckEmptyUtils.isEmpty(this.item.keyName)) {
      this.desktopContext?.eventHub.off(cancelItemEventId);
      this.desktopContext?.eventHub.on(cancelItemEventId, this.onCancelUninstallEvent);
      log.showDebug(`onEventhubCancelItemEvent for AppItem ${cancelItemEventId}`);
    }

    if (!GridLayoutUtil.isAppInstalled(this.item)) {
      if (this.item.bundleName) {
        this.appGalleryStatusChangeEventId = `appGalleryStatusChange${this.item.bundleName}${this.item.appIndex}item`;
        this.desktopContext?.eventHub.off(this.appGalleryStatusChangeEventId);
        this.desktopContext?.eventHub.on(this.appGalleryStatusChangeEventId, this.onAppGalleryStatusChangeEvent);
        log.showDebug(`onEventhubAppDownloadStatusChangedEvent for AppName ${this.appGalleryStatusChangeEventId}`);
      }
    }

    // appItem无障碍模式点击
    let appItemAccessibilityClickEventId: string = `appItemAccessibilityClick${this.item.keyName}`;
    this.desktopContext?.eventHub.off(appItemAccessibilityClickEventId, this.onAppItemAccessibilityClickEvent);
    this.desktopContext?.eventHub.on(appItemAccessibilityClickEventId, this.onAppItemAccessibilityClickEvent);
    log.showInfo(`DesktopAccessibility onAppItemAccessibilityClickEvent register for AppItem ${appItemAccessibilityClickEventId}`);
  }

  private appGalleryStatusChangeEvent(eventInfo: AppGalleryEventInfo): void {
    switch (eventInfo.eventType) {
      case DownloadStatusChangeEvent.DOWNLOAD_STATUS_CHANGE:
        let appStatus: AppStatus = eventInfo.status as AppStatus;
        this.itemAppStatus = appStatus;
        break;
      case DownloadingProgressChangeEvent.DOWNLOAD_PROGRESS_CHANGE:
        this.itemAppStatus = AppStatus.DOWNLOADING;
        break;
      default:
        break;
    }
  }

  private onEventhubCoveredItemEvent(isShow: boolean): void {
    log.showInfo(`onEventhubCoveredItemEvent item:${this.item.keyName}, isShow:${isShow}`);
    const dragItemType: number = AppStorage.get<number>('dragItemType') as number;
    if ((dragItemType === CommonConstants.DRAG_FROM_DESKTOP || dragItemType === CommonConstants.DRAG_FROM_APP_ICON ||
      dragItemType === CommonConstants.DRAG_FROM_DOCK ||
      dragItemType === CommonConstants.DRAG_FROM_FOLDER ||
      dragItemType === CommonConstants.DRAG_FROM_REGION_FOLDER ||
      dragItemType === CommonConstants.DRAG_FROM_FOLDER_IN_DOCK) &&
      AppStorage.get<string>('device') === CommonConstants.DEFAULT_DEVICE_TYPE) {
      this.showAppBackplaneAnimate(isShow);
    }
  }

  private appItemAccessibilityClickEvent(): void {
    log.showInfo(`DesktopAccessibility appItemAccessibilityClickEvent item:${this.item.keyName}, appName:${this.item.appName}`);
    this.checkClickEvent(undefined, this.item);
  }

  private onEventhubCancelItemEvent(isCancel: boolean): void {
    log.showInfo(`onEventhubCancelItemEvent item:${this.item.keyName}, isCancel:${isCancel}`);
    this.itemScale = 0;
    this.showAppFromDialog(isCancel);
  }

  private showAppFromDialog(isCancel: boolean): void {
    if (isCancel) {
      animateTo({
        curve: curves.springMotion(0.468, 0.63),
        onFinish: () => {
          this.isShowingUninstallDialog = UninstallDialogStatus.INITIAL_STATE;
          this.dragToUninstallItemInfo = new AppItemInfo();
        }
      }, () => {
        this.itemScale = 1;
      })
    }
  }

  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: UninstallDialog({
      cancel: () => {},
      confirm: () => {
        if (this.isPad) {
          this.mPageDesktopViewModel.deleteAppItem({
            bundleName: this.appInfo.bundleName,
            keyName: this.appInfo.keyName,
            abilityName: this.appInfo.abilityName,
            moduleName: this.appInfo.moduleName,
            appIndex: this.appInfo.appIndex,
            container: this.appInfo.container,
            typeId: CommonConstants.TYPE_APP
          });
        } else {
          this.updateItemPosition(this.appInfo);
          this.mPageDesktopViewModel.uninstallApp(this.appInfo.bundleName as string,
            this.appInfo.isUninstallAble as boolean);
          this.mPageDesktopViewModel.autoAlignAfterUninstall([this.appInfo]);
        }
      },
      dialogName: this.isPad ? $r('app.string.is_delete_app', this.appInfo.appName) : $r('app.string.isUninstall', this.appInfo.appName),
      isFromDesktop: true,
      isBusinessStyle: true
    }),
    cancel: this.cancelDialog,
    autoCancel: true,
    customStyle: DeviceHelper.isPC(),
    showInSubWindow: true,
    alignment: DialogAlignment.Center,
  });

  /**
   * Dialog for form manager view (pad adaptation).
   */
  formManagerDialogController: CustomDialogController | null = new CustomDialogController({
    builder: FormManagerDialog({
      singleContext: this.singleContext,
      cancel: (callback?: Function) => {
        // delete all form
        if (callback !== undefined) {
          this.clearForm = callback;
        } else {
          log.showError('FormManagerDialog callback error'); // 维测日志
        }
      },
      confirm: (formCardItem: CardItemInfo) => {
        // add form to desktop
        log.showInfo(`createCardToDeskTop formCardItem: ${JSON.stringify(formCardItem)}`);
        this.mPageDesktopViewModel.createCardToDeskTop(formCardItem);
        // delete other form
      },
      bundleName: this.formAppInfo.bundleName,
      appName: this.formAppInfo.applicationName,
      appLabelId: this.formAppInfo.applicationLabelId,
      isPcEditCard: !DeviceHelper.isPhone(),
    }),
    cancel: this.cancelFormDialog,
    autoCancel: true,
    customStyle: true,
    showInSubWindow: true
  });

  /**
   * When click cancel dialog, this function will be called.
   */
  cancelFormDialog() {
    log.showInfo('cancel form dialog');
    if (this.clearForm) {
      this.clearForm();
    }
  }

  private onMenuPreviewAnimate: Function = (isMenuShow: boolean): void => {
    log.showInfo(`onMenuPreviewAnimate: ${isMenuShow}`);
    const iconScale = isMenuShow ? 1.1 : 1.0;
    animateTo({
      duration: 200,
      curve: Curve.Sharp
    }, () => {
      this.iconScale = iconScale;
      this.iconModifier.attribute?.scale({ x: this.iconScale, y: this.iconScale });
      this.disableMaskModifier.attribute?.scale({ x: this.iconScale, y: this.iconScale });
    });
  }

  aboutToAppear(): void {
    this.initAppNameModifier();
    this.initAppIconBackplaneModifier();
    this.initAppIconConfig();
    this.initIconMenuVm();
    this.mPageDesktopDragHandler = PageDesktopDragHandler.getInstance(this.singleContext);
    this.isPad = this.mPageDesktopViewModel.getDevice();
    let styleConfig = this.mPageDesktopViewModel.getPageDesktopStyleConfig();
    this.mAppNameHeight = styleConfig.mNameHeight;
    this.itemKey = GridLayoutUtil.generateUniqueKey(this.item as Object as GridLayoutItemInfo);
    this.componentObserver = inspector.createComponentObserver(this.getComponentId());
    this.componentObserver.on('draw', () => {
      if (this.iconEvent.getIconDynamicShadowEvent()) {
        this.iconEvent.getIconDynamicShadowEvent().update(this.styleConfig.mAppIconShadowRadius, 0,
          this.styleConfig.mAppIconShadowOffsetY, this.styleConfig.mAppIconShadowColor);
      }
    });
    this.iconMenuVm.setMenuOffset(this.menuOffset);
    this.iconMenuVm.setLayoutRegionMargin(this.layoutRegionMargin);
    this.initEventhubEvent();
    this.initIconEvent();
    log.showInfo('aboutToAppear keyName=%{public}s, isInDrag=%{public}s', this.item.keyName, this.isInDrag);
    if (!GridLayoutUtil.isAppInstalled(this.item)) {
      let downloadStatusInfo: DownloadStatusInfo | undefined =
        AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo(this.item.bundleName);
      if (downloadStatusInfo && !this.item.appIndex) {
        this.itemAppStatus = downloadStatusInfo.status;
      } else {
        this.itemAppStatus = this.item.appStatus as AppStatus;
      }
    }
    this.mPageDesktopViewModel.registerUninstallListener(this.unInstallListener);
    if (this.isSelect) {
      const key: string = this.mPageDesktopViewModel.getItemKeyByType(this.item as GridLayoutItemInfo);
      this.mPageDesktopViewModel.onSelectItemChange([key], true, true);
    }
    if (this.isInDrag) {
      this.iconData.enableDrag = !this.isInDrag;
    }
    if (this.containerBelong?.typeId === CommonConstants.TYPE_REGION_FOLDER) {
      this.iconMenuVm.setMenuPreviewAnimScale(regionAppAnimScale);
    }
    this.desktopContext?.eventHub.on(CommonConstants.DESKTOP_ITEM_ENABLE_RENDER_GROUP, this.enableRenderGroupChange);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear keyName=%{public}s, isInDrag=%{public}s', this.item.keyName, this.isInDrag);
    this.dialogController = null;
    this.formManagerDialogController = null;

    let coveredItemEventId: string = `coveredApp${this.item.keyName}`;
    if (coveredItemEventId !== '') {
      this.desktopContext?.eventHub.off(coveredItemEventId, this.onCoveredAppEvent);
    }

    let cancelItemEventId: string = `cancelUninstall${this.item.keyName}`;
    if (!CheckEmptyUtils.isEmpty(this.item.keyName)) {
      this.desktopContext?.eventHub.off(cancelItemEventId, this.onCancelUninstallEvent);
    }

    let appItemAccessibilityClickEventId: string = `appItemAccessibilityClick${this.item.keyName}`;
    this.desktopContext?.eventHub.off(appItemAccessibilityClickEventId, this.onAppItemAccessibilityClickEvent);

    if (!CheckEmptyUtils.isEmpty(this.appGalleryStatusChangeEventId)) {
      this.desktopContext?.eventHub.off(this.appGalleryStatusChangeEventId);
    }
    this.mPageDesktopViewModel.unregisterUninstallListener(this.unInstallListener);
    if (this.componentObserver) {
      this.componentObserver.off('draw');
      this.componentObserver = null;
    }
    this.desktopContext?.eventHub.off(CommonConstants.DESKTOP_ITEM_ENABLE_RENDER_GROUP, this.enableRenderGroupChange);
  }

  private uninstallAppBlurAnimation(): void {
    log.showInfo('application %{public}s will be removed', this.item.bundleName);
    if (this.isExistsItem) {
      log.showInfo('trigger gravity animation with application [%{public}d:%{public}d,%{public}d] uninstalled',
        this.getIndexInSwiper(), this.item.row, this.item.column);
      const cachedPos: number[] = GridLayoutUtil.getIconCenterPosition(this.item.row, this.item.column, this.item.area,
        this.getIndexInSwiper());
      setTimeout(() => {
        gravityAnimationManager.run(SwiperLoadData.getInstance()
          .getSwiperKeyByIndex(this.getIndexInSwiper()),
          cachedPos[0], cachedPos[1], ForceType.GRAVITATION);
      }, GravityAnimationConfig.getDelayOnRemoveApplication());
      this.isExistsItem = false;
    } else {
      log.showError('cannot get item %{public}s/%{public}s cache info', this.item.typeId, this.item.bundleName);
    }

    animateTo({
      duration: UNINSTALL_APP_DURATION,
      curve: curves.cubicBezierCurve(0.4, 0, 0.67, 1),
      onFinish: (() => {
        TraceUtil.endTrace(DomainName.HOME, TraceUtil.UNINSTALL_APP);
      })
    }, () => {
      this.mIconBlur = FOREGROUND_BLUR_RADIUS;
      this.animateScale = 0;
    })
  }

  public uninstallAppResult(bundleName: string, resultCode: number, appIndex?: number, shortcutId?: string): void {
    if (this.isEquals(bundleName, appIndex, shortcutId)) {
      if (this.item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        this.updateItemPosition(this.item);
      }
      if (resultCode === CommonConstants.UNINSTALL_SUCCESS) {
        this.uninstallAppBlurAnimation();
      } else {
        this.mIconBlur = -1;
        this.animateScale = 1.0;
      }
    }
  }

  private isEquals(bundleName: string, appIndex?: number, shortcutId?: string): boolean {
    return this.item.bundleName === bundleName && this.item.appIndex === (appIndex ?? 0) &&
      (this.item.shortcutId ?? '') === (shortcutId ?? '');
  }

  /**
   * When click cancel dialog, this function will be called.
   */
  cancelDialog() {
    log.showInfo('cancel app uninstall dialog');
  }

  // 拖动app到app触发动效：APP背板放大 || 缩小
  private showAppBackplaneAnimate(isAppBackplaneOpen: boolean): void {
    if (isAppBackplaneOpen) {
      log.showInfo('showAppBackplaneAnimate start');
      this.titleDisappearStatus = true;

      animateTo({
        curve: curves.springCurve(1.5, 1.5, 230, 25),
      }, () => {
        this.isAppBubbleBackgroundOpen = true;
        this.appBubbleBackplaneRatio = 1.15;
      })
    } else {
      log.showInfo('showAppBackplaneAnimate end');
      this.titleDisappearStatus = false;

      animateTo({
        curve: curves.springCurve(1.5, 1.5, 230, 25),
      }, () => {
        this.isAppBubbleBackgroundOpen = false;
        this.appBubbleBackplaneRatio = 1.0;
      })
    }
  }

  private checkClickEvent(event?: ClickEvent, item ?: AppItemInfo): void {
    if (this.itemAppStatus === AppStatus.INSTALLED || this.itemAppStatus === undefined) {
      this.dealClickEvent(event);
    } else if (this.item.appIndex && this.item.appIndex > 0) {
      AppInstallUtils.getInstance().clickTwinApp(this.item.bundleName);
      return;
    } else if (this.itemAppStatus === AppStatus.DOWNLOADING) {
      //  调用暂停接口
      AppInstallUtils.getInstance().pauseTask(this.item.bundleName);
      HiSysEventUtil.reportPauseAppDownload(this.item.bundleName);
    } else if (this.itemAppStatus === AppStatus.PENDING || this.itemAppStatus === AppStatus.WAIT_FOR_HARMONY) {
      //  调用检查接口
      AppInstallUtils.getInstance().checkTask(this.item);
      this.reportAppItemClick();
    } else if (this.itemAppStatus === AppStatus.PAUSING || this.itemAppStatus === AppStatus.WIFI_WAITING) {
      //  调用恢复接口
      AppInstallUtils.getInstance().resumeTask(this.item.bundleName);
      HiSysEventUtil.reportContinueAppDownload(this.item.bundleName);
    }
  }

  // click事件触发通用接口
  private dealClickEvent(event?: ClickEvent) {
    let isDrag: boolean = AppStorage.get('isDrag') as boolean;
    let position: Position | undefined = event?.target.area.globalPosition;
    log.showInfo('tap action, globalPosition:{x:%{public}d, y:%{public}d}, desktopMode:%{public}d, isDrag:%{public}s',
      position?.x, position?.x, editModeManager.getDesktopMode(), isDrag);
    if (editModeManager.isInEditMode() || scbEventExclusiveManager.isExclusive(EventType.DESKTOP_CLICK)) {
      return;
    }
    this.reportAppItemClick();
    if (event?.source === SourceType.Mouse) {
      this.mPageDesktopViewModel.onAppClick(this.item.abilityName as string,
        this.item.bundleName as string, this.item.moduleName as string);
    } else {
      log.showInfo('tap click, bundleName:%{public}s, abilityName:%{public}s, page:%{public}d, row:%{public}d, column:%{public}d',
        this.item.bundleName, this.item.abilityName, this.item.page, this.item.row, this.item.column);
      this.clickLaunchApp();
      MemoryManager.getInstance().notifyClearOpenApp();
    }
  }

  private reportAppItemClick(): void {
    let component: string = this.item.bundleName;
    let containerType: string = 'desktop';
    const screenPageCount: number = LaunchLayoutCacheManager.getInstance().selectPageCount();
    let iconPositionInDesktop: string =
      'SCREENCOUNT:' + screenPageCount + 'SCREENINDEX:' + this.item.page + 'CELLX:' + this.item.column +
        'CELLY:' + this.item.row + 'isInDock:false';
    if (this.item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      HiSysEventUtil.reportClickShortcut(component, this.item.shortcutId, containerType, iconPositionInDesktop,
        '-1', '-1', '-1');
    }
  }

  private isShowCancelDialog(): boolean {
    return (this.isShowingUninstallDialog === UninstallDialogStatus.CONFIRM_STATE ||
      this.isShowingUninstallDialog === UninstallDialogStatus.UNINSTALLING_STATE) &&
      this.dragToUninstallItemInfo.keyName === this.item.keyName;
  }

  private updateModifier(): void {
    this.appIconContainerModifier.attribute?.translate({
      x: CheckEmptyUtils.isEmpty(this.desktopStyle) ? 0 : this.desktopStyle.translateX,
      y: CheckEmptyUtils.isEmpty(this.desktopStyle) ? 0 : this.desktopStyle.translateY
    });
    this.appIconContainerModifier.attribute?.opacity(CheckEmptyUtils.isEmpty(this.desktopStyle) ?
      1 : this.desktopStyle.alpha);
    this.appIconContainerModifier.attribute?.padding({ top: this.itemPadding, bottom: this.itemPadding });
    this.appIconContainerModifier.attribute?.margin({ top: this.backPlaneTopMargin })
  }

  private onItemPaddingChange(): void {
    if (this.isIconSizeFixed) {
      log.showInfo('onItemPaddingChange region folder icon size not change');
      this.itemPadding = 0;
    }
    this.appIconContainerModifier.attribute?.padding({ top: this.itemPadding, bottom: this.itemPadding });
  }

  private onDesktopStyleChange(): void {
    this.updateModifier();
  }

  private inDragStateChange(): void {
    log.showInfo(`desktop drag inDragStateChange: ${this.isInDrag}`);
    this.iconData.enableDrag = !this.isInDrag;
  }

  private initAppIconConfig(): void {
    this.appIconConfig
      .setEnableRightMenuFromName(true)
      .setEnableHoverAnimation(true)
      .setIsDesktopItem(this.isDesktopItem)
      .setEnableTouchMask(false)
      .setEnableInstallAnimate(false)
      .setIconBackPlaneSize(this.dBackPlaneSize)
      .setIconMarginTop(this.dBackPlaneSize / 2)
      .setEnableNameAnim(false)
      .setEnableLongPressIconVisibility(false)
      .setEnableShadow(true)
      .setEnableDynamicIconShadow(true)
      .setAlignRuleOption({
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
        top: { anchor: '__container__', align: VerticalAlign.Top },
      })
      .setAppDataOfTransactionController(
        AppDataWrapper.getDefaultAppData(this.item, this.iconRadius)
          .setExtraId(TAG)
          .setStartType(StartType.DESKTOP_APP))
      .setEnableMouseLongPressVibration(false)
      .setExternCb({
        setMenuPosition: (event: TouchEvent, iconId: string) => {
          this.setAppMenuPosition(event);
        },
        getMenuInfo: (): MenuInfo[] => {
          return this.getMenuInfo();
        },
        onIconClick: (event?: ClickEvent, fingers?: number): void => {
          log.showInfo('onClick icon');
          this.checkClickEvent(event);
        },
        onIconTouch: (event: TouchEvent) => {
          const isTouchDown: boolean = event?.source === SourceType.TouchScreen && event?.type === TouchType.Down;
          const isMultiSelected: boolean = this.isMultiSelectedItems() && this.getSelectItemContainCurrentApp?.();
          if (isTouchDown && !isMultiSelected) {
            this.onItemSelect?.(this.item);
          }
          // 鼠标左键选中，鼠标右键不响应onTouch事件
          if (event?.source === SourceType.Mouse && event?.type === TouchType.Down) {
            this.mousePressSelectItem(event);
          }
          this.triggerDrag(event);
          event?.stopPropagation();
        },
        getMixMenuInfo: (): MenuInfo[] => {
          return this.getMixMenuInfo();
        },
        isMultiselect: (): boolean => {
          return this.isMultiSelectedItems();
        },
        onMenuDisappear: (isLongPressShow: boolean) => {
          if (isLongPressShow) {
            this.onMenuPreviewAnimate(false);
          }
          this.desktopContext?.eventHub.emit(CommonConstants.EVENTHUB_MENU_DISAPPEAR);
        },
        onMenuAppear: (isLongPressShow: boolean) => {
          if (isLongPressShow) {
            // 图标长按1.1放大动效，菜单预览图不显示
            this.onMenuPreviewAnimate(true);
          }
        }
      })
      .setEnableLongPressMenuPreview(false)
      .setEnableRightClickMenuFollowIcon(false)
      .setEnableContainerClickEvent(false)
      .setEnableFocus(false);
    this.item.componentId = AppIconModel.getInstance().getIconId(this.item,
      this.appIconConfig.appDataOfTransitionController?.extraId, this.appIconConfig.isOuterDesktop);
    log.showInfo('initAppIconConfig: ' + this.item.componentId);
  }

  private isMultiSelectedItems(): boolean {
    return this.getSelectItemLength?.() > 1;
  }

  private getMenuInfo(): MenuInfo[] {
    let removeShortcutItem = () => {};
    return this.mPageDesktopViewModel.buildMenuInfoList(this.item,
    this.dialogController, undefined, this.formManagerDialogController, (): void => this.setStartAppInfo(),
      this.containerBelong ? removeShortcutItem : undefined);
  }

  private getMixMenuInfo(): MenuInfo[] {
    return this.mPageDesktopViewModel.buildMixedMenuInfo(this.item, (): void => this.setStartAppInfo());
  }

  private initIconMenuVm(): void {
    this.iconMenuVm.setBackgroundBlurStyle(DeviceHelper.is2In1DevicePcType() ? BlurStyle.COMPONENT_ULTRA_THICK :
    BlurStyle.COMPONENT_REGULAR);
    this.iconMenuVm.setMenuOffset(defaultMenuOffset);
  }

  private initIconEvent(): void {
    const iconHoverEventIface: DesktopAppIconHoverEvent =
      new DesktopAppIconHoverEvent((isHover: boolean, event: HoverEvent) => {
        this.handleHoverEvent(isHover, event);
      });
    const appIconDragEvent: AppIconDragEventIface = {
      onDragStart: (event: DragEvent): CustomBuilder | DragItemInfo => {
        this.rectangleSelect = false;
        if (this.dragStart) {
          return this.dragStart(event, this.item.componentId);
        }
        return this.defaultDragStart(event, this.item.componentId);
      },
      onDragEnd: (event: DragEvent): void => { return this.handlerDragEnd(event); },
      onPreDrag: (preDragStatus: PreDragStatus): void => {},
      getDragPreviewBuilder: (): string | CustomBuilder | DragItemInfo => {}
    }
    const appIconTouchEvent: DesktopAppIconTouchEvent = new DesktopAppIconTouchEvent();
    appIconTouchEvent.initEventParam({
      itemInfo: this.appInfo,
      iconData: this.iconData,
      appIconConfig: this.appIconConfig,
      touchDownCb: (event: TouchEvent) => { this.setAppMenuPosition(event); },
      iconScaleCb: (scale: number) => {},
      iconSizeCb: () => this.mIconSize,
      iconLongPressAnimation: (isZoomOut: boolean) => {}
    });
    const appIconGestureJudge: AppIconGestureJudgeIface = {
      onGestureJudgeBegin: (gestureInfo: GestureInfo, event: BaseGestureEvent) => {
        if (gestureInfo.type === GestureControl.GestureType.DRAG && this.isMultiSelect) {
          log.showWarn('cannot start drag when multi select');
          return GestureJudgeResult.REJECT;
        }
        return GestureJudgeResult.CONTINUE;
      }
    }
    this.iconEvent.setIconHoverEventIface(iconHoverEventIface);
    this.iconEvent.setIconDragEventIface(appIconDragEvent);
    this.iconEvent.setIconTouchEventIface(appIconTouchEvent);
    this.iconEvent.setIconGestureJudgeIface(appIconGestureJudge);
  }

  private handleHoverEvent(isHover: boolean, event: HoverEvent): void {
    const iconScale = isHover ? 1.08 : 1;
    animateTo({
      duration: 150,
      curve: Curve.Sharp
    }, () => {
      this.iconScale = iconScale;
      this.iconModifier.attribute?.scale({ x: this.iconScale, y: this.iconScale });
      this.disableMaskModifier.attribute?.scale({ x: this.iconScale, y: this.iconScale });
    });
  }

  private itemTouchEvent(): void {
    if (!this.iconMenuVm.isMenuShow()) {
      if (this.isClicked) {
        return;
      }
      this.isClicked = true;
      setTimeout(() => {
        this.isClicked = false;
      }, CLICK_DELAY);
      this.clickLaunchApp();
    }
  }

  private appNameTouchEvent(event: TouchEvent): void {
    if (event?.source === SourceType.TouchScreen && event?.type === TouchType.Down) {
      this.onItemSelect?.(this.item);
    }
    if (!this.getSelectItemContainCurrentApp?.() && event?.type === TouchType.Down) {
      if (event?.source === SourceType.Mouse) {
        this.onItemSelect?.(this.item);
      }
    }
  }

  private initAppNameModifier(): void {
    this.appNameVm.modifier = this.appNameModifier;
  }

  private getMaxNameLines(): number {
    if (this.containerBelong?.typeId === CommonConstants.TYPE_REGION_FOLDER) {
      return this.mMaxNameLines;
    }
    let fontSizeScale = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).config.fontSizeScale ||
      1;
    return fontSizeScale > 1.15 ? 1 : 2
  }

  private isHoverTips(): boolean {
    this.hoverTipAppNameLenVp = px2vp(Number(this.getTextSizeWidth(this.item.appName).width));
    let appNameOver: boolean = this.hoverTipAppNameLenVp > this.mAppNameWidth * this.getMaxNameLines();
    log.showInfo(`AppNameOver: ${appNameOver}, AppNameLenVp: ${this.hoverTipAppNameLenVp},mAppNameWidth:${this.mAppNameWidth} getMaxNameLines ${this.getMaxNameLines()}`);
    return appNameOver;
  }

  private isHoverTipsWidth(): number {
    this.hoverTipAppNameLenVp = px2vp(Number(this.getTextSizeWidth(this.item.appName).width));
    let hoverTipsWidth: number = Math.min(this.hoverTipAppNameLenVp + StyleConstants.DEFAULT_8 * 2,
      MAX_HOVER_TIPS_WIDTH);
    return hoverTipsWidth;
  }

  private initAppIconBackplaneModifier(): void {
    this.backplaneVm.modifier.onInit = (instance: CommonAttribute) => {
      if (instance) {
        instance
          .border(this.isSelect ? {
            width: StyleConstants.DEFAULT_2,
            color: $r('sys.color.ohos_id_color_switch_bg_off')
          } : undefined)
          .backgroundColor(this.isSelect ? $r('sys.color.ohos_id_color_bottom_tab_icon_auxcolor_off01') : undefined)
          .borderRadius(this.iconRadius + StyleConstants.DEFAULT_2)
      }
    }
    this.backplaneVm.visible = true;
    this.backplaneVm.useEffect = false;
  }

  private updateMenuInfoAndOffset(event?: MouseEvent): void {
    if (event && event.button === MouseButton.Right && event.action === MouseAction.Press) {
      this.iconEvent?.getIconMenuEvent()?.setMenuInfo((): MenuInfo[] => { return this.getMenuInfo(); });
      const menuInfo = this.isMultiSelectedItems() ? this.getMixMenuInfo() : this.getMenuInfo();
      this.menuOffset = PageDesktopViewModelForPC.getInstance().getRightMenuViewModel()?.getMenuOffset(event, menuInfo, TAG);
      this.iconMenuVm.setMenuOffset(this.menuOffset);
      log.showInfo(`updateMenuInfoAndOffset: ${this.menuOffset.y}`);
    }
  }

  /**
   * 长按不支持混选。混选下长按弹出普通长按菜单
   * @param event
   */
  private setAppMenuPosition(event: TouchEvent): void {
    if (event.type === TouchType.Down) {
      const menuInfo = this.isMultiSelectedItems() ? this.getMixMenuInfo() : this.getMenuInfo();
      const menuPlacement = PageDesktopViewModelForPC.getInstance().getRightMenuViewModel().getMenuPlacement(event,
        menuInfo, TAG);
      const offset = PageDesktopViewModelForPC.getInstance().getRightMenuViewModel().getMenuOffset(event, menuInfo, TAG);
      this.iconMenuVm.setMenuOffset(offset);
      this.iconMenuVm.setMenuPlacement(menuPlacement ?? Placement.BottomLeft);
      log.showInfo(`setAppMenuPosition: ${menuPlacement} ${offset.x} ${offset.y}`);
    }
  }

  private triggerDrag(event?: TouchEvent, isPressNameDrag: boolean = false): void {
    if (!event || !event?.touches || event?.touches?.length === 0) {
      log.showWarn('triggerDrag event invalid');
      return;
    }
    if (event.type === TouchType.Down) {
      dragSnapshotHelper.snapshotFromId(this.item.componentId, SnapshotType.BOTH,
        this.getSnapshotKey(), null, undefined, undefined, 'AppItem_triggerDrag');
      this.isMultiSelect = this.isMultiSelectedItems() && this.getSelectItemContainCurrentApp?.();
      log.showInfo(`desktop drag this app isMultiSelect = ${this.isMultiSelect}`);
    }
    if (!this.isMultiSelect) {
      log.showWarn('desktop drag triggerDrag event: isMultiSelect invalid');
      return;
    }
    if (event.type === TouchType.Down && this.isMultiSelect) {
      this.initMultiSelectDragParams(event, isPressNameDrag);
    }
    // 松手后，需要能框选
    if (event.type === TouchType.Up) {
      this.mPageDesktopViewModel.setMultiDragStart(false);
    }
    dragTriggerUtil.preDragTrigger(event);
  }

  private getSnapshotKey(): string {
    return GridLayoutUtil.generateUniqueKey(this.item as Object as GridLayoutItemInfo);
  }

  private handleKeyboardEvent(event: KeyEvent): void {
    if (keyEventManager.getIsAltKeyDown()) {
      return;
    }
    if (event.keyCode === KeyCode.KEYCODE_ENTER) {
      if (this.isMultiSelectedItems() && this.getSelectItemContainCurrentApp?.()) {
        // 单选时公共的按键监听会处理回车打开应用，此处只处理多选的情况避免打开两次
        this.launchAppItem();
      }
    }
  }

  private initMultiSelectDragParams(event: TouchEvent, isPressNameDrag: boolean): void {
    let cachedItemInfo: GridLayoutItemInfo | undefined = this.getCachedItemInfo();
    if (!cachedItemInfo) {
      log.showError('cannot get cache %{public}s/%{public}s', this.item.typeId, this.item.bundleName);
      return;
    }
    let cachedPos: number[] = [];
    if (DeviceHelper.isBigScreenMachine()) {
      this.mPageDesktopViewModel.setMultiDragStart(true);
      const isPortrait: boolean = AppStorage.get<boolean>('isPortrait') as boolean;
      const page: number = cachedItemInfo.page ?? 0;
      cachedPos =
        GridLayoutUtil.getIconCenterPosition(cachedItemInfo.row, cachedItemInfo.column, [1, 1], page, isPortrait);
    } else {
      cachedPos = GridLayoutUtil.getIconCenterPosition(cachedItemInfo.row, cachedItemInfo.column);
    }
    let dragInfoList: DragItemInfo[] = [];
    log.showInfo(`desktop drag currentDragAppSnapInMap: ${this.isCurrentDragSnapInMap?.()}`);
    if (this.isCurrentDragSnapInMap?.()) {
      let dragItemInfo: DragItemInfo = {
        pixelMap: this.getCurrentTouchItem?.(),
        extraInfo: new DragExtraInfo(DragDataType.APP).setRadius(CommonConstants.DEFAULT_ICON_RADIUS).toString()
      }
      dragInfoList.push(dragItemInfo);
    }
    this.setDragInfoList(dragInfoList);
    let dragControllerParams: DragControllerParams = {
      key: this.isCurrentDragSnapInMap?.() ? [] :
        [GridLayoutUtil.generateUniqueKey(this.item as Object as GridLayoutItemInfo)],
      dragItemInfo: dragInfoList,
      dragInfo: {
        pointerId: 0,
        data: this.getDragEventData?.(),
        touchPoint: {
          x: event.touches[0].windowX - cachedPos[0] + this.mIconSize / 2,
          y: event.touches[0].windowY - cachedPos[1] + this.mIconSize / 2,
        },
        previewOptions: { numberBadge: this.getSelectItemLength?.() }
      },
      dragStartCallback: ((event: DragEvent) => {
        this.handlerDragStart(event);
      }),
      dragEndCallback: ((event: DragEvent) => {
        this.handlerDragEnd(event);
      })
    };
    if (isPressNameDrag && dragControllerParams?.dragInfo?.touchPoint) {
      dragControllerParams.dragInfo.touchPoint.y = this.mIconSize / 2;
    }
    if (this.containerItem?.typeId === CommonConstants.TYPE_REGION_FOLDER &&
      dragControllerParams?.dragInfo?.touchPoint) {
      dragControllerParams.dragInfo.touchPoint.x = this.mIconSize / 2;
      dragControllerParams.dragInfo.touchPoint.y = this.mIconSize / 2;
    }
    dragTriggerUtil.initDragParams(dragControllerParams);
  }

  private getCachedItemInfo(): GridLayoutItemInfo | undefined {
    let itemInfo = this.item as Object as GridLayoutItemInfo;
    return LaunchLayoutCacheManager.getInstance().selectGridLayoutItemByItem(itemInfo);
  }

  private setDragInfoList(dragInfoList: DragItemInfo[]): void {
    try {
      this.multiSelectMap = this.getMultiSelectMap?.();
      let key = this.getItemKey?.();
      Array.from(this.multiSelectMap.values()).filter(value => value !==
      this.multiSelectMap.get(key)).forEach((image) => {
        let dragItemInfo: DragItemInfo = {
          pixelMap: image,
          extraInfo: new DragExtraInfo(DragDataType.APP).setRadius(CommonConstants.DEFAULT_ICON_RADIUS).toString()
        }
        dragInfoList.push(dragItemInfo);
      })
      log.showInfo(`dragInfo.length: ${dragInfoList.length}`)
    } catch (err) {
      log.showError(`setDragInfoList error, code: ${err?.code}, message: ${err?.message}`);
    }
  }

  private handlerDragStart(event: DragEvent): void {
    if (!event) {
      log.showError('desktop drag handlerDragStart no event');
    }
    log.showInfo('desktop drag handlerDragStart');
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_DESKTOP_MENU_EVENT, 1);
    performanceMonitor.begin(HiSysEventUtil.DRAG_ITEM_ANI, performanceMonitor.ActionType.FIRST_MOVE, 'item:[App]');
    TraceUtil.startTrace(DomainName.HOME, HiSysEventUtil.DRAG_ITEM_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    this.isDragFlag = true;
    try {
      if (this.dragStart) {
        this.dragStart(event);
      } else {
        this.defaultDragStart(event);
      }
    } catch (error) {
      log.showError(`appitem drag start error ${error?.code}, ${error?.message}`);
    }
  }

  private handlerDragEnd(event: DragEvent): void {
    log.showInfo('desktop drag drag app end');
    this.isDragFlag = false;
    if (this.dragEnd) {
      this.dragEnd(event);
      return;
    }
    this.defaultDragEnd(event);
  }

  private defaultDragEnd(event: DragEvent): void {
    log.showInfo(`desktop drag defaultDragEnd, isMultiSelect = ${this.isMultiSelect}`);
    if (!this.isMultiSelect) {
      nameAppearAnimate(() => {
        try {
          this.appNameVm?.modifier.attribute?.opacity(1);
          this.backplaneVm?.modifier.attribute?.opacity(1);
        } catch (error) {
          log.showError(`handlerDragEnd nameAppearAnimate error ${error?.code}, ${error?.message}`);
        }
      })
      this.desktopContext?.eventHub.emit(CommonConstants.EVENTHUB_ICON_OR_CARD_DROP);
    }
    AppStorage.setOrCreate<boolean>('isDrag', false);
    multiSelectListenerManger.executeFinish();
    AppStorage.setOrCreate<Object>('dragItemInfo', {});
    this.dragItemType = CommonConstants.DRAG_FROM_UNKNOWN;
    DragEventManager.getInstance().startDrop(
      GridLayoutUtil.generateUniqueKey(this.item as Object as GridLayoutItemInfo));
    this.desktopContext?.eventHub.emit(`appIconRestore${this.item.keyName}`);
  }

  private mousePressSelectItem(event: TouchEvent): void {
    if (this.getSelectItemContainCurrentApp?.()) {
      this.rectangleSelect = true;
      return;
    } else {
      this.onItemSelect?.(this.item);
      this.rectangleSelect = false;
    }
  }

  private selectItem: (event?: MouseEvent) => void =
    (event?: MouseEvent) => {
      if (!event) {
        log.showInfo('selectItem MouseEvent is invalid')
        return;
      }
      if (event.button === MouseButton.Right && event.action === MouseAction.Press) {
        log.showInfo(`selectItemContainCurrentApp: ${this.getSelectItemContainCurrentApp?.()}`)
        if (!this.getSelectItemContainCurrentApp?.()) {
          this.onItemSelect?.(this.item);
        }
      }
      if (event.button === MouseButton.Left && event.action === MouseAction.Release) {
        if (this.rectangleSelect && !this.isDragFlag) {
          this.onItemSelect?.(this.item);
        }
        this.rectangleSelect = false;
      }
    }

  appNameModifier: DesktopAppNameDefaultModifier = new DesktopAppNameDefaultModifier(
    this.selectItem,
    (event?: MouseEvent) => {
      this.updateMenuInfoAndOffset(event);
    },
    (event: MouseEvent) => {
      this.setHoverParameter(event);
    },
    (isHover: boolean) => {
      this.isAppNameHover(isHover)
    },
    (event: TouchEvent) => {
      this.appNameTouchEvent(event);
      this.triggerDrag(event, true);
    },
  )

  iconModifier: DesktopAppIconDefaultModifier = new DesktopAppIconDefaultModifier(
    this.selectItem,
    this.dBackPlaneSize,
    (event?: MouseEvent) => { this.updateMenuInfoAndOffset(event); }
  );

  private hoverTipPositionHandle(): Position {
    let res: Position = { x: 0, y: 0 };
    // 判断超过屏幕右侧
    if (Number(this.hoverTipDisPlayPosition.x) + this.isHoverTipsWidth() > this.displayWidth) {
      // 超过屏幕右侧但是小于总宽度
      if (Number(this.hoverTipDisPlayPosition.x) - Number(this.hoverTipPosition.x) + this.isHoverTipsWidth() <
      this.displayWidth) {
        res.x = Number(this.hoverTipPosition.x) - this.isHoverTipsWidth();
      } else {
        res.x = Number(this.hoverTipDisPlayPosition.x) - this.displayWidth + TEXTAREA_MIN_HEIGHT;
      }
    } else {
      res.x = this.hoverTipPosition.x;
    }
      res.y = Number(this.hoverTipPosition.y) + HOVER_MENU_FONT_SIZE + StyleConstants.DEFAULT_8;
    return res;
  };

  private getAppName(): string {
    log.showInfo(`getAppName ${this.item.appLabelId} ${this.item.bundleName} ${this.item.moduleName} ${this.item.abilityName}`);
    let cacheKey: string = `${this.item.appLabelId}${this.item.bundleName}${this.item.moduleName}`;
    let resName: string = ResourceManager.getInstance().getAppResourceCache(cacheKey, 'name') as string;
    if (CheckEmptyUtils.isEmpty(resName)) {
      resName = IconResourceManager.getInstance().getCachedIconNameSync(this.item.bundleName,
        this.item.moduleName, this.item.abilityName, this.item.appIndex);
    }
    if (!CommonUtils.isInvalid(resName) && this.item.appIndex !== undefined && this.item.appIndex > 0) {
      return `${resName}${this.item.appIndex}`;
    }
    return resName;
  }

  private getTextSizeWidth(str: string) {
    let newString = str;
    let itemLenWithPX: SizeOptions = measure.measureTextSize({
      textContent: newString,
      fontSize: this.mAppNameSize
    });
    return itemLenWithPX;
  }

  private hoverTipOverScreen() : boolean {
    // Hopper折叠屏无键盘场景使用screenHeight，其他场景|其他设备 使用displayHeight
    let isFoldNoKeyboard: boolean = DeviceHelper.isBigScreenMachine() &&
      this.mPageDesktopViewModel.getKeyBoardStatus() === NO_KEYBOARD_STATUS;
    let realScreenHeight: number = isFoldNoKeyboard ? AppStorage.get<number>('screenHeight') ?? 0 : this.displayHeight;
    if (Number(this.hoverTipDisPlayPosition.y) - Number(this.hoverTipPosition.y) + HOVER_MENU_FONT_SIZE +
      POPUP_WIDTH_FROM_THE_SCREEN > realScreenHeight) {
      return true;
    } else {
      return false;
    }
  }

  private getComponentId(): string {
    return `${TAG}_app_${this.itemKey}`;
  }

  private setHoverParameter(event: MouseEvent) {
    this.hoverTipDisPlayPosition.x = event.displayX;
    this.hoverTipDisPlayPosition.y = event.displayY;
    let newPosition: Position = { x: event.x, y: event.y - Number(event.target.area.height)};
    this.hoverTipPosition = newPosition;
  }

  public hideHoverTips(): void {
    log.showInfo('hide hover tips');
    this.isShowNameHoverTips = false;
    if (this.timerId !== -1) {
      clearTimeout(this.timerId);
      this.timerId = -1;
    }
  }

  public showHoverTips(): void {
    this.timerId = setTimeout(() => {
      log.showInfo('set hover tips time out.');
      this.isShowNameHoverTips = this.isHoverTips();
      if (this.timerId !== -1) {
        clearTimeout(this.timerId);
        this.timerId = -1;
      }
    }, 1000)
  }

  private isAppNameHover(isHover: boolean): void {
    this.appNameHover = isHover;
    if (this.appNameHover) {
      this.showHoverTips();
    } else {
      this.hideHoverTips();
    }
  }

  private isEnableRenderGroup(): boolean {
    if (this.isIconSizeFixed) {
      log.showInfo('region folder not use renderGroup');
      return false;
    }
    let textWidth: number = Number(this.getTextSizeWidth(this.item.appName)?.width);
    let isOneLine: boolean = textWidth < this.mAppNameWidth;
    return !this.isDrag && isOneLine && this.enableRenderGroup;
  }

  @Builder hoverAppNameTipsBuilder() {
    Row() {
      Text(this.item.appName)
        .wordBreak(WordBreak.BREAK_ALL)
        .padding({
          left: StyleConstants.DEFAULT_8,
          right: StyleConstants.DEFAULT_8,
          top: StyleConstants.DEFAULT_8,
          bottom: StyleConstants.DEFAULT_8
        })
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
    }
    .borderRadius(StyleConstants.DEFAULT_8)
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      if (this.isAppBubbleBackgroundOpen) {
        Column() {
          // 文件夹形成之前背板
          Column() {
          }
          .width(this.mIconSize)
          .height(this.mIconSize)
          .borderRadius(this.iconRadius)
          .useEffect(true)
          .scale({ x: this.appBubbleBackplaneRatio, y: this.appBubbleBackplaneRatio })
          .id(`${TAG}_Column_backboard`)
        }
        .width('100%')
        .height('100%')
      }
      AppIconCommonView({
        iconContainerModifier: this.appIconContainerModifier,
        iconModifier: this.iconModifier,
        appIconConfig: this.appIconConfig,
        item: this.item,
        iconRadius: this.iconRadius,
        iconSize: this.mIconSize,
        isSelect: this.isSelect,
        isGainFocus: this.isGainFocus,
        maxNameLines: this.mMaxNameLines,
        nameHeight: this.mAppNameHeight,
        nameWidth: this.mAppNameWidth,
        nameSize: this.mAppNameSize,
        nameMarginTop: this.mIconNameMarginTop,
        nameFontColor: this.nameFontColor,
        isDragStart: this.isDragStart,
        isInDrag: this.isInDrag,
        translateX: this.translateX,
        translateY: this.translateY,
        backplaneVm: this.backplaneVm,
        iconMenuVm: this.iconMenuVm,
        iconEvent: this.iconEvent,
        appNameVm: this.appNameVm,
        iconData: this.iconData,
        disableMaskModifier: this.disableMaskModifier,
        marginValue: this.marginValue,
        paddingValue: this.paddingValue
      });
    }
    .id(this.getComponentId())
    .renderGroup(this.isEnableRenderGroup())
    .foregroundEffect(CommonUtils.equals(this.mIconBlur, -1) ? null : { radius: this.mIconBlur })
    .scale({ x: this.animateScale, y: this.animateScale })
    .parallelGesture(
      GestureGroup(GestureMode.Parallel,
        TapGesture({ count: 1 })
          .onAction((event: GestureEvent) => {
            if (event && event?.source === SourceType.TouchScreen) {
              this.itemTouchEvent();
            }
          }),
        TapGesture({ count: 2 })
          .onAction((event: GestureEvent) => {
            if (event?.source === SourceType.Mouse) {
              this.clickLaunchApp();
            }
          })
      )
    )
    .onBlur(()=> {
      log.showInfo(`onBlur appitem: ${this.item.componentId}`);
      this.isFocused = false;
    })
    .onKeyEvent((event) => {
      if (!event || event.type !== KeyType.Down) {
        return;
      }
      log.showInfo(`appitem onKeyEvent code: ${event.keyCode}, ${event.type}`);
      if (this.isSelect) {
        this.handleKeyboardEvent(event);
      }
    })
    .onMouse((event?: MouseEvent): void => {
      if (event?.button === MouseButton.Right && event.action === MouseAction.Release) {
        log.showInfo('onMouse mouse button right');
        AppStorage.setOrCreate<string>('selectDesktopAppItem', this.item.keyName as string);
        AppStorage.setOrCreate<string>('selectItem', this.item.bundleName as string);
      }
    })
    .onTouch((event?: TouchEvent): void => {
      if (event?.type === CommonConstants.TOUCH_TYPE_DOWN) {
        log.showInfo('onTouch down start');
      }
    })
    .focusBox({ strokeWidth: new LengthMetrics(0) })
    .width(StyleConstants.PERCENTAGE_100)
    .height(StyleConstants.PERCENTAGE_100)
    .bindPopup(this.isShowNameHoverTips, {
      builder:this.hoverAppNameTipsBuilder(),
      placement: this.hoverTipOverScreen() ? Placement.TopLeft : Placement.BottomLeft,
      mask: false,
      enableArrow: false,
      targetSpace:StyleConstants.DEFAULT_8,
      showInSubWindow: true,
      backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR,
      transition: TransitionEffect.OPACITY,
      width:this.isHoverTipsWidth(),
      offset: this.hoverTipPositionHandle(),
      onStateChange: (event) => {
        // 当系统状态变为隐藏时，进行tips隐藏后续处理
        if (event?.isVisible === false) {
          this.hideHoverTips();
        }
      }
    })
  }

  private getVisibility(): Visibility {
    let isAppNameHide: boolean = this.isAppNameHidden();
    if (isAppNameHide) {
      log.showInfo(`getVisibility, ${this.item?.bundleName} isHide = ${isAppNameHide}`);
    }
    return isAppNameHide ? Visibility.Hidden : Visibility.Visible;
  }

  private isAppNameHidden(): boolean {
    if (!(this.dragItemType === CommonConstants.DRAG_FROM_DESKTOP ||
      this.dragItemType === CommonConstants.DRAG_FROM_APP_ICON || DeviceHelper.isPhone())) {
      return false;
    }
    if (this.isDragStart) {
      log.showInfo('isAppNameHidden: dragStart');
      return true;
    }
    if (this.isShowCancelDialog()) {
      log.showInfo('isAppNameHidden: showCancelDialog');
      return true;
    }
    let dragCoveredItem = AppStorage.get<DragCoveredItem>('DragCoveredItem');
    if (dragCoveredItem?.isCreateSmallFolder && dragCoveredItem?.dragItemInfo?.keyName === this.item.keyName) {
      log.showInfo('isAppNameHidden: dragCoveredItem');
      return true;
    }
    let dragAppToFolderData: DragAppToFolderData =
      AppStorage.get<DragAppToFolderData>('dragAppToFolderData') as DragAppToFolderData;
    if (dragAppToFolderData?.appKeyName === this.item.keyName) {
      log.showInfo('isAppNameHidden: dragAppToFolderData');
      return true;
    }
    return false;
  }

  /**
   * 双击打开应用
   * */
  private clickLaunchApp = () => {
    log.showInfo('clickLaunchApp');
    this.launchAppItem();
    this.mPageDesktopViewModel.selectItemClear();
    AppStorage.setOrCreate('selectItem', '');
  }

  /**
   * When app is double clicked, call this method.
   */
  private launchApp(): void {
    this.setStartAppInfo();
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_APP_DOUBLE_CLICK, {
      abilityName: this.item.abilityName as string,
      bundleName: this.item.bundleName as string,
      moduleName: this.item.moduleName as string,
      appIndex: this.item.appIndex as number
    });
  }

  private launchAppItem(): void {
    log.showInfo(`launchAppItem, typeId = ${this.item.typeId}`);
    switch (this.item.typeId) {
      case CommonConstants.TYPE_SHORTCUT_ICON:
        ShortcutViewModel.getInstance().onShortcutAppClick(this.item);
        break;
      case CommonConstants.TYPE_APP:
        this.launchApp();
        break;
      default:
        break;
    }
  }

  private defaultDragStart(event: DragEvent, id?: string): DragItemInfo {
    AppStorage.setOrCreate<boolean>('isDrag', true);
    ContextMenu.close();
    AppStorage.setOrCreate<string>('selectItem', '');
    this.dragItemType = CommonConstants.DRAG_FROM_DESKTOP;
    let selectItemInfoList: GridLayoutItemInfo[] = this.mPageDesktopViewModel.getCurrentSelectItemsInfo();
    AppStorage.setOrCreate<GridLayoutItemInfo[]>('dragItemInfo', selectItemInfoList);

    let image = this.mPageDesktopViewModel.getMultiSelectMap()
      .get(this.mPageDesktopViewModel.getItemKeyByType(this.item as GridLayoutItemInfo));
    //放入空数据，防止起拖携带image默认数据，导致落位三方应用生成文件。
    if (selectItemInfoList.length === 1) {
      this.appNameVm?.modifier.attribute?.opacity(0);
      this.backplaneVm?.modifier.attribute?.opacity(0);
      let unifiedData: UDC.UnifiedData | null = new UDC.UnifiedData(new UDC.SystemDefinedAppItem());
      event.setData?.(unifiedData);
    }
    log.showInfo(`desktop drag pageDesktopDragItemInfo: length = ${selectItemInfoList.length}, ${JSON.stringify(selectItemInfoList)}`);
    if (editModeManager.isInEditMode()) {
      this.isShowingUninstallDialog = UninstallDialogStatus.INITIAL_STATE;
      this.dragToUninstallItemInfo = new AppItemInfo();
      ObjectCopyUtil.deepClone(this.item, this.dragToUninstallItemInfo);
    }

    log.showInfo('desktop drag pageDesktopDragItemInfo bundleName: %{public}s, page: %{public}d, column: %{public}d, row: %{public}d, abilityName: %{public}s, moduleName: %{public}s',
      this.item.bundleName, this.item.page, this.item.column, this.item.row, this.item.abilityName,
      this.item.moduleName);
    this.mPageDesktopDragHandler?.onDragStart(event.getWindowX(), event.getWindowY());
    multiSelectListenerManger.executeDragging();
    // PC上，图标位于背板中，由于设置了居中，且背板size比图标大，导致图标顶部到背板顶部有间隙，落位点需要设置偏差
    const iconAroundMargin: number = DeviceHelper.isBigScreenMachine() ?
      this.dBackPlaneSize / 2 + this.backPlaneTopMargin -
      GridLayoutUtil.getFloorVp(this.mPageDesktopViewModel.getIconMarginVertical()):
    GridLayoutUtil.getFloorVp((StyleConstants.APPICON_BACKGROUND_HEIGHT - this.mIconSize) / 2);
    dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, this.itemKey)
      ?.setWidth(EditModeUtils.convertWithDesktopScale(this.mIconSize))
      .setHeight(EditModeUtils.convertWithDesktopScale(this.mIconSize))
      .setRadius(EditModeUtils.convertWithDesktopScale(this.iconRadius))
      .setOffset(0, iconAroundMargin);
    let dragItemInfo: DragItemInfo = {
      pixelMap: dragSnapshotHelper.getSnapshot(SnapshotType.DRAG, this.itemKey),
      extraInfo: new DragExtraInfo(DragDataType.APP).setRadius(CommonConstants.DEFAULT_ICON_RADIUS).toString(),
    };
    if (id) {
      try {
        const info: componentUtils.ComponentInfo = componentUtils.getRectangleById(id);
        const x = info.screenOffset.x;
        const y = info.screenOffset.y;
        const dx = event.getWindowX() - px2vp(x);
        const dy = event.getWindowY() - px2vp(y);
        const rect: Rectangle = {
          x: dx,
          y: dy,
          width: px2vp(info.size.width),
          height: px2vp(info.size.height)
        };
        GlobalContext.getContext()?.eventHub.emit(DragConstants.DRAG_START_PREPARE_STATUS_CHANGE_EVENT, rect);
      } catch (err) {
        log.showError(`failed to getRectangleById. code is ${err?.code}, message is ${err?.message}`);
      }
    }
    return dragItemInfo;
  }

  private updateItemPosition(uninstallAppInfo: AppItemInfo): void {
    const cached = LaunchLayoutCacheManager.getInstance().selectGridLayoutItemByItem(
      uninstallAppInfo as Object as GridLayoutItemInfo);
    // 如果缓存中可以获得且为同一应用则更新item的位置信息用于引力动效
    if (this.item.bundleName === uninstallAppInfo.bundleName &&
      this.item.appIndex === (uninstallAppInfo.appIndex ?? 0) &&
      this.item.shortcutId === (uninstallAppInfo.shortcutId ?? '') && cached) {
      log.info(`update item position : row: ${cached.row},column: ${cached.column}, area: ${cached.area}`);
      this.item.row = cached.row;
      this.item.column = cached.column;
      this.item.area = cached.area;
      this.isExistsItem = true;
    }
  }

  /**
   * set start app info
   */
  private setStartAppInfo() {
    let startType = this.isPad ? StartType.DESKTOP_APP : StartType.APP;
    CloseAppManager.getInstance().setStartAppType(startType);
  }

  getSelectItemLength = () => {
    log.showInfo('app is on desktop');
    return this.mPageDesktopViewModel.getCurrentSelectItems().length;
  }

  getDragEventData = () => {
    return this.mPageDesktopViewModel.getDragEventData(this.containerItem);
  }

  getMultiSelectMap = () => {
    return this.mPageDesktopViewModel.getMultiSelectMap();
  }

  getSelectItemContainCurrentApp = () => {
    let key: string = this.mPageDesktopViewModel?.getItemKeyByType(this.item as GridLayoutItemInfo) as string;
    let isExistInDesktop = this.mPageDesktopViewModel.getCurrentSelectItems().indexOf(key) !== -1;
    log.showInfo(`isExistInDesktop:${isExistInDesktop}`);
    return isExistInDesktop;
  }

  isCurrentDragSnapInMap = () => {
    let key: string = this.mPageDesktopViewModel?.getItemKeyByType(this.item as GridLayoutItemInfo) as string;
    return this.mPageDesktopViewModel.isCurrentItemInMultiMap(key);
  }

  getCurrentTouchItem = () => {
    return this.mPageDesktopViewModel.getCurrentTouchItem(this.item as Object as GridLayoutItemInfo);
  }

  getItemKey = () => {
    return this.mPageDesktopViewModel?.getItemKeyByType(this.item as GridLayoutItemInfo) as string;
  }

  onSelectChange(): void {
    this.backplaneVm.modifier.attribute?.border(this.isSelect ? {
      width: StyleConstants.DEFAULT_2,
      color: $r('sys.color.ohos_id_color_switch_bg_off')
    } : {
      width: 0,
      color: Color.Transparent
    });
    this.backplaneVm.modifier.attribute?.backgroundColor(this.isSelect ?
    $r('sys.color.ohos_id_color_bottom_tab_icon_auxcolor_off01') : undefined);
    this.backplaneVm.modifier.attribute?.borderRadius(this.iconRadius + StyleConstants.DEFAULT_2)
  }
}

class DesktopAppNameDefaultModifier extends AppNameModifier {
  private selectItem: Function;
  private updateMenuInfoAndOffset: Function;
  private setHoverParameter: Function;
  private isAppnameHover: Function;
  private appNameTouchEvent: Function;

  constructor(selectItem: Function, updateMenuInfoAndOffset: Function, setHoverParameter: Function, isAppnameHover: Function,
    appNameTouchEvent: Function) {
    super();
    this.selectItem = selectItem;
    this.updateMenuInfoAndOffset = updateMenuInfoAndOffset;
    this.setHoverParameter = setHoverParameter;
    this.isAppnameHover = isAppnameHover;
    this.appNameTouchEvent = appNameTouchEvent;
  }

  initializeModifier(instance: CommonAttribute): void {
    super.initializeModifier(instance);
    instance
      .onMouse((event: MouseEvent): void => {
        this.updateMenuInfoAndOffset?.(event);
        this.setHoverParameter?.(event, false);
        if (event?.action === MouseAction.Press && event?.button === MouseButton.Right) {
          this.selectItem?.(event);
        }
        event?.stopPropagation();
      })
      .focusBox({strokeWidth: new LengthMetrics(0)})
      .onHover((isHover: boolean, event: HoverEvent) => {
        this.isAppnameHover?.(isHover);
        log.showInfo(`initAppNameModifier: ${isHover} `);
      })
      .onTouch((event:TouchEvent):void=>{
        this.appNameTouchEvent?.(event);
        event?.stopPropagation();
      })
  }
}

class DesktopAppIconDefaultModifier extends AppIconDefaultModifier {
  private selectItem: Function;
  private dBackPlaneSize: number;
  private updateMenuInfoAndOffset: Function;

  constructor(selectItem: Function, dBackPlaneSize: number, updateMenuInfoAndOffset: Function) {
    super();
    this.selectItem = selectItem;
    this.dBackPlaneSize = dBackPlaneSize;
    this.updateMenuInfoAndOffset = updateMenuInfoAndOffset;
  }

  initializeModifier(instance: CommonAttribute): void {
    super.initializeModifier(instance);
    instance.margin({
      top: this.dBackPlaneSize / 2
    })
      .onMouse((event: MouseEvent): void => {
        this.selectItem?.(event);
        this.updateMenuInfoAndOffset?.(event);
        event?.stopPropagation();
      })
  }
}

class DesktopAppIconHoverEvent implements AppIconHoverEventIface {
  private hoverCallBack: Function;

  constructor(callback: Function) {
    this.hoverCallBack = callback;
  }

  public onHover(isHover: boolean, event: HoverEvent, updateScale: (scale: number) => void): AppIconHoverEventIface {
    this.hoverCallBack?.(isHover, true);
    return this;
  }
}

class DesktopAppIconTouchEvent extends AppIconTouchEvent {
  public onClick(event?: ClickEvent | undefined): void {
  }
}

@Observed
export class DeskTopIconMenuVm extends AppIconMenuVm {

  public getMenuPlacement(isLongPressMenu?: boolean): Placement | undefined {
    if (isLongPressMenu) {
      return this.menuPlacement;
    }

    return undefined;
  }

  public getMenuTransition(isLongPressMenu?: boolean): TransitionEffect | undefined {
    if (isLongPressMenu) {
      return TransitionEffect.asymmetric(
        TransitionEffect.opacity(0),
        TransitionEffect.IDENTITY.animation({ duration: 0 }));
    }

    return this.menuTransition;
  }

  public setMenuPreviewAnimScale(animScale: AnimationRange<number>): void {
    let contextMenu: ContextMenuAnimationOptions | undefined = super.getMenuPreviewAnimOptions();
    if (contextMenu) {
      contextMenu.scale = animScale;
    }
  }

}

@Builder export function AppItemBuilder($$: AppItemViewIf) {
  AppItem({
    desktopStyle: $$.desktopStyle,
    item: $$.item,
    mMaxNameLines: $$.nameMaxLines,
    mAppNameWidth: $$.nameWidth,
    mAppNameSize: $$.nameSize,
    getIndexInSwiper: $$.getIndexInSwiper,
    isDesktopItem: $$.isDesktopItem,
    mIconSize: $$.iconSize,
    iconRadius: $$.iconRadius,
    onItemSelect: $$.onItemSelect,
    marginValue: $$.marginValue,
    paddingValue: $$.paddingValue,
    appIconConfig: $$.appIconConfig,
    isSelect: $$.isSelect,
    isGainFocus: $$.isGainFocus,
    dragStart: $$.dragStart,
    dragEnd: $$.dragEnd,
    isDragStart: $$.isDragStart,
    isInDrag: $$.isInDrag,
    isIconSizeFixed: $$.isIconSizeFixed,
  })
    .id(`${$$.tag}_AppItem_${$$.item.bundleName}_${$$.item.appIconId}`)
    .translate({ x: $$.translateX, y: $$.translateY })
    .opacity($$.itemOpacity)
}