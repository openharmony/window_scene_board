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
  LogDomain,
  LogHelper,
  CheckEmptyUtils,
  CommonUtils,
  RectInfo,
  StartType
} from '@ohos/basicutils'
import { ItemUtils, SceneSessionUIContextManager } from '@ohos/componenthelper'
import { DragDataType, DragEventManager, DragExtraInfo, DragEventCallback } from '@ohos/componentdrag'
import {
  HiSysEventUtil,
  DownloadStatusChangeEvent,
  InstallStatusChangeEvent,
  DownloadingProgressChangeEvent,
  GlobalContext,
  IconResourceManager,
  ResourceManager,
  localEventManager
} from '@ohos/frameworkwrapper';
import measure from '@ohos.measure';
import {
  AppDataWrapper,
  AppGalleryDownloadManager,
  AppGalleryEventInfo,
  AppGridStyleConfig,
  AppIconModel,
  AppInstallUtils,
  AppItemInfo,
  AppStatus,
  CalculateAppCenterRst,
  DownloadStatusInfo,
  EventConstants,
  GridLayoutItemInfo,
  GridLayoutUtil,
  IconCanvasType,
  LayoutViewModel,
  MenuInfo,
  StyleConstants,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { AppIconCommonView, AppIconConfig, HoverAnimationUtil, AppIconCommonEvent, MenuCommonUtil } from '@ohos/launchercommon/Index';
import { AppIconData } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconData';
import { AppCenterIconMenuVm } from '../vm/AppCenterIconMenuVm';
import { dragTriggerUtil } from '@ohos/launchercommon/src/main/ets/utils/DragTriggerUtil';
import { AppNameVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppNameVm';
import { AppIconContainerModifier } from '@ohos/launchercommon/src/main/ets/launchericon/interface/AppIconContainerModifier';
import { CommonConstants } from '@ohos/launchercommon';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { AppCenterDragMgr } from '../controller/AppCenterDragMgr';
import { curves, display, performanceMonitor } from '@kit.ArkUI';
import { ResUtils, SCBSceneSessionManager } from '@ohos/windowscene';
import AppGridLayoutCacheManager from '../common/cache/AppGridLayoutCacheManager';
import { EVENT_ENABLE_DRAG_STATE_CHANGE } from '../constants/LayoutConstants';
import { EditModeUtils } from '@ohos/launchercommon';
import { ShortcutViewModel } from '@ohos/launchercommon/src/main/ets/TsIndex'
import { AppIconDisableMaskVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconDisableMaskVm';
import { SCBScreenProperty } from '@ohos/windowscene';
import { AppCenterIconModifier } from '../vm/AppCenterIconModifier';
import { AppGridPresenter } from '../common/presenter/AppGridPresenter';
import { appIconMsgKeyUtil } from '@ohos/launchercommon/src/main/ets/launchericon/common/AppIconMsgKeyUtil';
import { AC_DRAG_SQUEEZE_DURATION } from '../constants/LayoutConstants';
import { DomainName, TraceUtil } from '@ohos/basicutils';
import { CommonAcDragMgr } from '../controller/CommonAcDragMgr';
import DefaultAppCacheManager from '../common/cache/DefaultAppCacheManager';

//加悬停菜单宽度和高度
const HOVER_MENU_TEXT_OPACITY = 0.6;
const KEYCODE_ENTER = 2054;
const TAG = 'AppCenterItem';
const KEY_NAME = 'name';
const popupOffset: Position = { x: 0, y: 8 };
const popupPlacement: Placement = Placement.BottomLeft;
const DEFAULT_ICON_RADIUS = 20;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const ICON_HOVER_DURATION = 250;
const DEFAULT_ICON_SCALE = 1;
const ICON_HOVER_SCALE = 1.06;
const IN_PAGE_MENU_LONG_PRESS_TIME = 550;
const DEFAULT_FONT_SIZE: number = 16;
const DEFAULT_MENU_ITEM_SIDE_PADDING: number = 17;

@Component
export struct AppCenterItem {
  private traceId: string = TAG;
  private item: AppItemInfo = new AppItemInfo();
  private enableBadge: boolean = true;
  private appGridStyleConfig: AppGridStyleConfig = AppGridStyleConfig.getInstance();
  private mLayoutVM?: LayoutViewModel;
  private appCenterRst: CalculateAppCenterRst = new CalculateAppCenterRst();
  private buildMenu?: Function;
  private notInstalledMenuMap?: Function;
  private mIconNameMargin?: number = StyleConstants.DEFAULT_9;
  @Link @Watch('updateIconContainerModifier') appCenterBubbleMarginTop: number;
  @Link @Watch('updateIconContainerModifier') appCenterBubbleMarginBottom: number;
  private onItemClick?: Function;
  private onIconContainerClick?: (event?: ClickEvent) => void;
  private openInPageMenu?: Function;
  // icon容器
  private iconContainerModifier: AppIconContainerModifier = new AppIconContainerModifier(
    () => this.updateIconContainerModifier());
  // 菜单管理
  @State iconMenuVm: AppCenterIconMenuVm = new AppCenterIconMenuVm();
  // 图标Modifier
  private iconModifier: AppCenterIconModifier = new AppCenterIconModifier();
  // icon相关状态变量
  @State iconData: AppIconData = new AppIconData();
  // 获取当前页
  private getIndexInSwiper: Function = (): number => 0;
  private iconEvent: AppIconCommonEvent = new AppIconCommonEvent();
  private appNameVm: AppNameVm = new AppNameVm();
  private appIconConfig: AppIconConfig = new AppIconConfig();
  itemDragStart?: Function;
  itemDragEnd?: Function;
  @Link iconSize: number;
  @Link iconRadius: number;
  @Link nameSize: number;
  @Prop isDragStart: boolean;
  @State isInDrag: boolean = false;
  // 挤位偏移量
  @State translateX: number = 0;
  @State translateY: number = 0;
  private mDragEventCallback: DragEventCallback = {};
  private itemKey: string = '';
  private dragAllowed: boolean = false;
  private isDragging: boolean = false;
  @Provide itemAppStatus: AppStatus = AppStatus.INSTALLED;
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  @State isAppNameHover : boolean = false;//定义一个装饰器用于表示应用中心appName是否处于悬停状态
  tempWithVp: number = 0;
  tempHeightVp: number = 0;
  fileNameLenVp: number = 0;
  @State disableMaskVm: AppIconDisableMaskVm = new AppIconDisableMaskVm();
  @Prop screenProp: SCBScreenProperty;
  @Link acColumns: number; // 每行最大列信息
  private mCacheMgrImpl: DefaultAppCacheManager = new DefaultAppCacheManager();
  private mDragImpl: CommonAcDragMgr = new CommonAcDragMgr();
  private rect: RectInfo = this.getIconRect();
  private pageIndex: number = 0;

  aboutToAppear(): void {
    this.item.typeId = CommonConstants.TYPE_APP;
    this.itemKey = this.getItemKey();
    this.initDragEventCallback();
    this.registerDragEvent();
    this.initEventhubEvent();
    this.initItemData();
    this.mLayoutVM = LayoutViewModel.getInstance();
    this.appCenterRst = this.mLayoutVM.calculateAppCenter(
      this.screenProp.screenId, false, this.screenProp.width, this.screenProp.height);
    log.showInfo(`aboutToAppear: ${this.item.bundleName}-${this.item.moduleName}, isInDrag: ${this.isInDrag} bundleName: ${this.item?.bundleName}
     nameSize: ${this.appCenterRst.mNameSize} screenId: ${this.screenProp.screenId}`);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear: ${this.item.bundleName}-${this.item.moduleName}-${this.translateX}-${this.translateY}, ${this.item?.bundleName}`);
    this.unRegisterDragEvent();
    let appGalleryStatusChangeEventId: string =
      `appGalleryStatusChange${this.item.bundleName}${CommonConstants.MAIN_APP_INDEX}appCenter`;
    if (!CheckEmptyUtils.isEmpty(appGalleryStatusChangeEventId)) {
      this.desktopContext?.eventHub.off(appGalleryStatusChangeEventId, this.appGalleryStatusChangeCallBack);
    }
  }

  /**
   * 是否是主显示器
   *
   * @param screenId
   * @returns
   */
  private isMainScreen(screenId: number = 0): boolean {
    return SCBSceneSessionManager.getInstance().mainScreenId === screenId;
  }

  private appGalleryStatusChangeCallBack = (eventInfo: AppGalleryEventInfo): void => {
    this.appGalleryEvent(eventInfo)
  }

  private initItemData(): void {
    this.initAppNameModifier();
    this.initAppIconConfig();
    // 事件挂载优先通过这里，避免modifier时序问题
    this.initAppIconCommonEvent();
    this.initIconMenuVm();
    this.initDragStatus();
  }

  private initAppIconConfig(): void {
    this.appIconConfig
      .setEnableTouchMask(false)
      .setIsDesktopItem(false)
      .setEnableNameAnim(false)
      .setEnableLongPressIconVisibility(false)
      .setEnableRightMenuFromName(false)
      .setEnableMenu(false)
      .setEnableBadge(this.enableBadge)
      // 图标唯一性标识
      .setAppDataOfTransactionController(
        AppDataWrapper
          .getDefaultAppData(this.item, this.iconRadius)
          .setExtraId(CommonConstants.APPCENTER_ICON_EXTRA_ID)
          .setStartType(StartType.APP_CENTER_APP))
      .setExternCb({
        getIndexInSwiper: (): number => this.getIndexInSwiper(),
        getNotInstalledMenuMap: (): Map<AppStatus, MenuInfo[]> => this.notInstalledMenuMap?.(this.item),
        getMenuInfo: (): MenuInfo[] => {
          return this.buildMenu?.(this.item);
        },
        onMenuAppear: (isLongPressShow: boolean) => {
          this.iconData.isShowMask = false;
        }
      })
      .setEnableLongPressMenuPreview(false)
      .setEnableRightClickMenuFollowIcon(false)
      .setEnableMouseLongPressVibration(false)
      .setEnableHoverAnimation(true)
      .setIsAppCenterItem(true);
  }

  private initIconMenuVm(): void {
    this.iconMenuVm.setBackgroundBlurStyle(BlurStyle.COMPONENT_REGULAR);
    this.iconMenuVm.setMenuOffset({ x: 0, y: 5 });
    this.iconMenuVm.setAppItemInfo(this.item);
  }

  private getItemAppStatus(): AppStatus {
    let downloadStatusInfo: DownloadStatusInfo | undefined =
      AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo(this.item.bundleName);
    if (downloadStatusInfo && !this.item.appIndex) {
      return downloadStatusInfo.status;
    }
    return this.item.appStatus as AppStatus;
  }

  private getInPageMenuInfoList(): MenuInfo[] {
    if (!GridLayoutUtil.isAppInstalled(this.item)) {
      return this.notInstalledMenuMap?.(this.item)?.get(this.getItemAppStatus()) ?? [];
    }
    return this.buildMenu?.(this.item) ?? [];
  }

  private showInPageMenu(event?: MouseEvent): void {
    if (AppCenterDragMgr.getInstance().isInDragging()) {
      return;
    }
    let menuInfoList = this.getInPageMenuInfoList().filter((item: MenuInfo) => item !== undefined);
    if (menuInfoList.length === 0) {
      log.showWarn(`showInPageMenu menu empty, bundleName: ${this.item.bundleName}`);
      return;
    }
    ContextMenu.close();
    const iconRect: RectInfo = this.getIconRect();
    const menuPlacement: Placement = event ?
      MenuCommonUtil.getMenuPlacementByTouchX(event.displayX, iconRect) : Placement.BottomLeft;
    this.openInPageMenu?.(this.item, menuInfoList, iconRect, this.getInPageMenuWidth(menuInfoList), menuPlacement);
    log.showInfo(`showInPageMenu, bundleName: ${this.item.bundleName}, menu length: ${menuInfoList.length}`);
  }

  private measureInPageMenuWidth(menuItem: MenuInfo): number {
    let menuWidth: number = Math.ceil(px2vp(measure.measureText({
      textContent: menuItem.menuText,
      fontSize: DEFAULT_FONT_SIZE,
      fontWeight: 'medium',
    })));
    return menuWidth + DEFAULT_MENU_ITEM_SIDE_PADDING * 2 + StyleConstants.DEFAULT_24;
  }

  private getInPageMenuWidth(menuInfoList: MenuInfo[]): number {
    let menuWidth: number = StyleConstants.MENU_WIDTH_COLUMNS_PC;
    menuInfoList.forEach((menuItem: MenuInfo) => {
      let currItemWidth = this.measureInPageMenuWidth(menuItem);
      if (currItemWidth > menuWidth) {
        menuWidth = currItemWidth;
      }
    })
    return menuWidth;
  }

  // 挂载图标容器属性
  private updateIconContainerModifier(): void {
    this.iconContainerModifier.attribute?.padding({
      top: this.appCenterBubbleMarginTop, bottom: this.appCenterBubbleMarginBottom });
    this.iconContainerModifier.attribute?.focusable(true);
    this.iconContainerModifier.attribute?.onKeyEvent((event) => {
      if (event.type === KeyType.Down && event.keyCode === KEYCODE_ENTER) {
        this.onIconClickCallback;
      }
    });
    this.iconContainerModifier.setTag('appCenterIconContainer');
  }

  @Builder
  DragAppIconWithDisableMask() {
    if (!this.iconData.isDynamicIcon) {
      Image(this.iconData.image)
        .draggable(false)
        .width(EditModeUtils.convertWithDesktopScale(this.iconSize))
        .height(EditModeUtils.convertWithDesktopScale(this.iconSize))
        .borderRadius(EditModeUtils.convertWithDesktopScale(this.iconRadius))
        .syncLoad(this.isSyncLoad())
        .interpolation(ImageInterpolation.Medium)
        .autoResize(false)
        .scale(AppIconModel.getInstance().getDragIconBuilderScale(this.item))
        .backgroundImage(ShortcutViewModel.getInstance().getShortcutBackgroundImage(this.item))
        .backgroundImageSize(ImageSize.Cover)
        .backgroundImagePosition(Alignment.Center)

    }
    if (this.iconData.isOnlineTheme) {
      Canvas(this.iconEvent.getIconMaskCanvas(IconCanvasType.LONG_PRESS_MASK)?.getContext())
        .onReady(() => {
          this.iconEvent.getIconMaskCanvas(IconCanvasType.LONG_PRESS_MASK)?.updateMask(this.iconData.image,
            this.iconSize, this.item);
        })
        .width(this.iconSize)
        .height(this.iconSize)
        .visibility(this.disableMaskVm.visible ? Visibility.Visible : Visibility.Hidden)
        .id(this.iconEvent.getIconMaskCanvas(IconCanvasType.LONG_PRESS_MASK)?.getCanvasId())
    } else {
      Column()
        .width(this.iconSize)
        .height(this.iconSize)
        .backgroundColor(StyleConstants.APP_ICON_GRAY_COLOR)
        .borderRadius(EditModeUtils.convertWithDesktopScale(this.iconRadius))
        .visibility(this.disableMaskVm.visible ? Visibility.Visible : Visibility.Hidden)
    }
  }

  private initAppIconCommonEvent(): void {
    this.iconData.maskBgColor = StyleConstants.APP_ICON_GRAY_COLOR;
    this.iconData.maskOpacity = 1;
    this.iconEvent.setIconTouchEventIface({
      onClick: this.onIconClickCallback,
      onTouch: (event: TouchEvent) => {
        if (event.type === TouchType.Down && !AppCenterDragMgr.getInstance().isInDragging()) {
          this.iconData.isShowMask = true;
        }
        if ((event?.type === TouchType.Up || event?.type === TouchType.Cancel)) {
          // 松手后重置图标组件长按标记位
          this.iconData.resetLongPressVibrated();
          if (!this.iconMenuVm.isMenuShow()) {
            this.iconData.isShowMask = false;
          }
        }
      }
    });
    this.iconEvent.setIconHoverEventIface({ onHover: this.onIconHoverCallback });
    this.iconEvent.setIconDragEventIface({
      onDragStart: (event: DragEvent) => this.handlerDragStart(event),
      onDragEnd: (event: DragEvent) => this.handlerDragEnd(event),
      onPreDrag: (preDragStatus: PreDragStatus) => {},
      getDragPreviewBuilder: () => this.DragAppIconWithDisableMask.bind(this) as CustomBuilder,
    });
    this.iconEvent.setIconContainerEventIface({
      onTouch: (event: TouchEvent): void => {},
      onClick: (event?: ClickEvent): void => {
        this.onIconContainerClick?.();
      }
    });
  }

  private isSyncLoad(): boolean {
    return (typeof this.iconData.image !== 'string') || GridLayoutUtil.isImageSyncLoad(this.iconData.image as string);
  }

  private initAppNameModifier(): void {
    this.appNameVm.modifier.onInit = (instance: CommonAttribute) => {
      if (!instance) {
        log.showError(`app name modifier not init`);
        return;
      }
      instance
        .onClick(this.onIconClickCallback)
        .onHover((isHover: boolean, event: HoverEvent) => {
          if (isHover && this.isShowPopup()) {
            this.isAppNameHover = true;
          } else {
            this.isAppNameHover = false;
          }
      });
    }
  }

  private isShowPopup(): boolean {
    this.fileNameLenVp = Number(this.measureTextSizeWidth(this.getAppName()));
    let fileNameOver: boolean = this.fileNameLenVp > this.appGridStyleConfig.mAppCenterItemWidth;
    log.showInfo(`fileNameOver: ${fileNameOver}, fileNameLenVp: ${this.fileNameLenVp},
    mGridWidth: ${this.appGridStyleConfig.mAppCenterItemWidth}===${fileNameOver}`);
    return fileNameOver;
  }

  private getItemKey(): string {
    let itemInfo: GridLayoutItemInfo = this.item as Object as GridLayoutItemInfo;
    itemInfo.typeId = CommonConstants.TYPE_APP;
    return `AppGrid_${GridLayoutUtil.generateUniqueKey(itemInfo)}`;
  }

  private dragStart(event: DragEvent): DragItemInfo {
    log.showInfo('dragStart');
    this.iconData.setIconOpacity(0, TAG, 'dragStart');
    this.setIconAndAppNameOpacity(0);
    this.desktopContext?.eventHub.emit(EVENT_ENABLE_DRAG_STATE_CHANGE, false);
    this.isDragging = true;
    this.iconData.enableDrag = !this.isDragging;
    AppStorage.setOrCreate<boolean>('isDrag', true);
    AppStorage.setOrCreate<number>('dragItemType', CommonConstants.DRAG_FROM_APPCENTER);
    let gridItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
    AppStorage.setOrCreate<GridLayoutItemInfo[]>('dragItemInfo', [gridItemInfo.fillInfoWithAppItem(this.item)]);
    ContextMenu.close();
    const scaledWidth = ResUtils.getNumberFromLength(this.rect.width);
    const scaledHeight = ResUtils.getNumberFromLength(this.rect.height);
    const halfAddScaledWidth = (scaledWidth * (this.iconData.iconScale - 1)) / 2;
    const halfAddScaledHeight = (scaledHeight * (this.iconData.iconScale - 1)) / 2;
    const scaledX = ResUtils.getNumberFromLength(this.rect?.left) - halfAddScaledWidth;
    const scaledY = ResUtils.getNumberFromLength(this.rect?.top) - halfAddScaledHeight;
    const rectangle: Rectangle = {
      x: event.getWindowX() - scaledX,
      y: event.getWindowY() - scaledY,
      width: scaledWidth,
      height: scaledHeight
    };
    AppCenterDragMgr.getInstance().setDragSnapshotRelativeRect(rectangle);
    dragTriggerUtil.setDragItemRect(this.rect);
    AppCenterDragMgr.getInstance().onDragStart(event, this.item, this.screenProp);
    this.itemDragStart?.();
    let dragItemInfo: DragItemInfo = {
      extraInfo: new DragExtraInfo(DragDataType.APP).setRadius(this.iconRadius).toString(),
    };
    return dragItemInfo;
  }

  /**
   * 设置整个图标、包括应用名称的透明度
   */
  private setIconAndAppNameOpacity(opacity: number) {
    this.iconData.containerOpacity = opacity;
  }

  private dragEnd(event: DragEvent): void {
    if (!this.isDragging) {
      log.showInfo('dragEnd, event has been consumed');
      return;
    }
    log.showInfo('dragEnd');
    this.isDragging = false;
    this.iconData.enableDrag = !this.isDragging;
    AppCenterDragMgr.getInstance().onDragEnd(event, this.screenProp?.screenId);
    AppStorage.setOrCreate('dragItemInfo', {});
    this.itemDragEnd?.();
    // 在图标重新渲染(aboutToAppear)后，在dragEnd回调以this.iconData设置新渲染的图标的透明度无效
    this.desktopContext?.eventHub.emit(appIconMsgKeyUtil.getIconContainerOpacityKey(this.item,
      this.appIconConfig.appDataOfTransitionController), 1);
  }

  private registerDragEvent(): void {
    log.showInfo('registerDragEvent, itemKey = %{public}s', this.itemKey);
    DragEventManager.getInstance().registerDragEvent(this.mDragEventCallback, this.itemKey);
    this.desktopContext?.eventHub.on(EVENT_ENABLE_DRAG_STATE_CHANGE, this.onEnableDragStateChange);
  }

  private unRegisterDragEvent(): void {
    log.showInfo('unRegisterDragEvent, itemKey = %{public}s', this.itemKey);
    DragEventManager.getInstance().unRegisterDragEvent(this.mDragEventCallback, this.itemKey);
    this.desktopContext?.eventHub.off(EVENT_ENABLE_DRAG_STATE_CHANGE, this.onEnableDragStateChange);
  }

  private onEnableDragStateChange = (enableDrag: boolean): void => {
    log.showInfo(`onEnableDragStateChange ${this.item.bundleName} enableDrag: ${enableDrag}`);
    enableDrag = enableDrag && this.dragAllowed && this.item.appStatus === AppStatus.INSTALLED;
    this.appIconConfig.setEnableDrag(enableDrag);
    this.iconData.enableDrag = enableDrag;
  }

  private onStartSqueezedEvent(translatePosition: number[][]): void {
    if (!translatePosition) {
      log.showError('onEventhubItemMoveEvent params error');
      return;
    }
    let endX: number = translatePosition[1][0] - translatePosition[0][0];
    let endY: number = translatePosition[1][1] - translatePosition[0][1];
    log.showInfo('onStartSqueezedEvent, name:%{public}s, endX:%{public}d, endY:%{public}d', this.item.bundleName, endX,
      endY);
    this.itemSqueezedAnimate(endX, endY);
  }

  private itemSqueezedAnimate(endX: number, endY: number, isCancel: boolean = false): void {
    animateTo({
      duration: AC_DRAG_SQUEEZE_DURATION,
      curve: curves.interpolatingSpring(0.5, 1, 228, 30),
      onFinish: () => {
        log.showDebug(`itemSqueezedAnimate finish-${this.item.bundleName}-${isCancel}`);
      }
    }, () => {
      // 基于当前位置做动画
      this.translateX = isCancel ? endX : this.translateX + endX;
      this.translateY = isCancel ? endY : this.translateY + endY;
      log.showInfo('itemSqueezedAnimate, bundleName:%{public}s, translateX:%{public}d, translateY:%{public}d',
        this.item.bundleName, this.translateX, this.translateY);
    });
  }

  private initDragEventCallback(): void {
    this.mDragEventCallback = {
      onItemDragStartEvent: (): void => {
      },
      onItemDropStartEvent: (): void => {
      },
      onItemDropEndEvent: (): void => {
        // 落位结束后显示图标和应用名称
        log.showInfo('onItemDropEndEvent, itemKey = %{public}s', this.itemKey);
        this.iconData.setIconOpacity(1, TAG, 'initDragEventCallback');
        this.setIconAndAppNameOpacity(1);
        if (!AppCenterDragMgr.getInstance().isAnimating()) {
          this.desktopContext?.eventHub.emit(EVENT_ENABLE_DRAG_STATE_CHANGE, true);
        }
      },
      onStartSqueezedEvent: (translatePosition: number[][]): void => {
        log.showInfo('onStartSqueezedEvent, itemKey = %{public}s', this.itemKey);
        this.onStartSqueezedEvent(translatePosition);
      },
      onCancelSqueezedEvent: (hasAnimation: boolean): void => {
        log.showInfo('onCancelSqueezedEvent, itemKey = %{public}s, hasAnimation = %{public}s ', this.itemKey,
          hasAnimation);
        if (hasAnimation) {
          this.itemSqueezedAnimate(0, 0, true);
        } else {
          this.translateX = 0;
          this.translateY = 0;
        }
      }
    }
  }

  private onIconHoverCallback = (isHover: boolean, event: HoverEvent, updateScale: (scale: number) => void) => {
    log.showInfo(`onIconHoverCallback isHover: ${isHover}`);
    animateTo({
      duration: ICON_HOVER_DURATION,
      curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1)
    }, () => {
      this.iconData.iconScale = isHover ? ICON_HOVER_SCALE : DEFAULT_ICON_SCALE;
    });
  }

  private onIconClickCallback = (event?: ClickEvent) => {
    log.showInfo(`onClick AppItem:${this.item.appStatus}`);
    if (this.isDragging) {
      log.showInfo(`isDragging, do not handle click event`);
      return;
    }
    if (this.item.appStatus === AppStatus.INSTALLED || this.item.appStatus === undefined) {
      this.onItemClick?.(event, this.item);
    } else if (this.item.appStatus === AppStatus.DOWNLOADING) {
      // 调用暂停接口
      AppInstallUtils.getInstance().pauseTask(this.item.bundleName);
      HiSysEventUtil.reportPauseAppDownload(this.item.bundleName);
    } else if (this.item.appStatus === AppStatus.PENDING || this.item.appStatus === AppStatus.WAIT_FOR_HARMONY) {
      // 调用检查接口
      AppInstallUtils.getInstance().checkTask(this.item);
    } else if (this.item.appStatus === AppStatus.PAUSING || this.item.appStatus === AppStatus.WIFI_WAITING) {
      // 调用恢复接口
      AppInstallUtils.getInstance().resumeTask(this.item.bundleName);
      HiSysEventUtil.reportContinueAppDownload(this.item.bundleName);
    }
  }

  private appGalleryEvent(eventInfo: AppGalleryEventInfo): void {
    if (!eventInfo || !eventInfo.bundleName) {
      log.showWarn(`eventInfo is null`);
    }
    log.showInfo(`appGalleryStatusChangeEvent for appCenter ${eventInfo.bundleName}`);
    switch (eventInfo.eventType) {
      case DownloadStatusChangeEvent.DOWNLOAD_STATUS_CHANGE:
        let appStatus: AppStatus = eventInfo.status as AppStatus;
        this.updateBundleStatus(eventInfo.bundleName, appStatus);
        break;
      case DownloadingProgressChangeEvent.DOWNLOAD_PROGRESS_CHANGE:
        this.updateBundleStatus(eventInfo.bundleName, AppStatus.DOWNLOADING);
        break;
      case InstallStatusChangeEvent.INSTALL_STATUS_CHANGE:
        let appInstallStatus: AppStatus = eventInfo.status as AppStatus;
        this.updateBundleStatus(eventInfo.bundleName, appInstallStatus);
        break;
      default:
        log.showDebug(`appGalleryStatusChangeEvent ${eventInfo.eventType}`);
        break;
    }
  }

  private updateBundleStatus(bundleName: string, appStatus: number) {
    this.item.appStatus = appStatus;
    let enableDrag: boolean = this.dragAllowed && this.item.appStatus === AppStatus.INSTALLED &&
      (!AppCenterDragMgr.getInstance().isInDragging());
    this.appIconConfig.setEnableDrag(enableDrag);
    this.iconData.enableDrag = enableDrag;
    log.showInfo(`updateBundleStatus for appCenter ${bundleName}. appStatus: ${appStatus}, enableDrag: ${enableDrag}`);
    AppGridLayoutCacheManager.getInstance().updateAppInstallStatus(this.item);
    if (appStatus === AppStatus.INSTALL_FAIL) {
      AppGridPresenter.getInstance().deleteInstallFailApp(bundleName);
    }
  }

  /**
   * 下载事件监听注册
   */
  private initEventhubEvent(): void {
    if (!GridLayoutUtil.isAppInstalled(this.item)) {
      let downloadStatusInfo: DownloadStatusInfo | undefined =
        AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo(this.item.bundleName);
      if (downloadStatusInfo) {
        this.item.appStatus = downloadStatusInfo.status;
      }
      let appGalleryStatusChangeEventId: string =
        `appGalleryStatusChange${this.item.bundleName}${CommonConstants.MAIN_APP_INDEX}appCenter`;
      if (appGalleryStatusChangeEventId) {
        this.desktopContext?.eventHub.off(appGalleryStatusChangeEventId, this.appGalleryStatusChangeCallBack);
        this.desktopContext?.eventHub.on(appGalleryStatusChangeEventId, this.appGalleryStatusChangeCallBack);
        log.showInfo(`onEventhubAppDownloadStatusChangedEvent for appCenter ${appGalleryStatusChangeEventId}`);
      }
    }
  }

  private measureTextSizeWidth(str: string): number {
    let newString = str;
    let itemLenWithPX: SizeOptions = measure.measureTextSize({
      textContent: newString,
      fontSize: this.nameSize
    });
    return this.getUIContext()?.px2vp(Number(itemLenWithPX.width));
  }

  private getAppName(): string {
    log.showInfo(`getAppName ${this.item.appLabelId} ${this.item.bundleName} ${this.item.moduleName} ${this.item.abilityName}`);
    let cacheKey: string = `${this.item.appLabelId}${this.item.bundleName}${this.item.moduleName}`;
    let resName: string = ResourceManager.getInstance().getAppResourceCache(cacheKey, KEY_NAME) as string;
    if (CheckEmptyUtils.isEmpty(resName)) {
      resName = IconResourceManager.getInstance().getCachedIconNameSync(this.item.bundleName,
        this.item.moduleName, this.item.abilityName, this.item.appIndex);
    }
    if (!CommonUtils.isInvalid(resName) && this.item.appIndex !== undefined && this.item.appIndex > 0) {
      return `${resName}${this.item.appIndex}`;
    }
    return resName;
  }

  private handlerDragEnd(event: DragEvent): void {
    log.showInfo('handle drag end');
    this.desktopContext?.eventHub.emit(CommonConstants.EVENTHUB_ICON_OR_CARD_DROP);
    AppStorage.setOrCreate<boolean>('isDrag', false);
    AppStorage.setOrCreate<Object>('dragItemInfo', {});
    DragEventManager.getInstance().startDrop(
      GridLayoutUtil.generateUniqueKey(this.item as Object as GridLayoutItemInfo));
    this.desktopContext?.eventHub.emit(`appIconRestore${this.item.keyName}`);
    this.dragEnd(event);
  }

  private handlerDragStart(event: DragEvent): DragItemInfo {
    log.showInfo('handle drag start');
    if (this.iconData.iconOpacity <= 0) {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_DESKTOP_MENU_EVENT, 1);
    }
    const index: number = this.mCacheMgrImpl.getAppItemIndex(this.item.bundleName, this.item.appIndex, this.pageIndex);
    const row =  Math.floor(index / this.acColumns); // 计算对应行信息
    const column = index % this.acColumns; // 计算对应列信息
    log.showInfo(`index:${index}, row:${row}, column:${column},acColumns:${this.acColumns}`);
    // 根据行列计算对应拖拽起始位置，用于拖拽落位动效
    this.rect = this.mDragImpl.getAppItemRectByPosition(row, column,
      this.pageIndex, this.screenProp.screenId) ?? this.getIconRect();
    performanceMonitor.begin(HiSysEventUtil.DRAG_ITEM_ANI, performanceMonitor.ActionType.FIRST_MOVE, 'item:[App]');
    TraceUtil.startTrace(DomainName.HOME, HiSysEventUtil.DRAG_ITEM_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    return this.dragStart?.(event);
  }

  private initDragStatus(): void {
    const isDragItem: boolean = AppCenterDragMgr.getInstance().isDragItem(this.item);
    log.showInfo(`initDragStatus ${this.item.bundleName}. isDragItem: ${isDragItem}, dragAllowed: ${this.dragAllowed}`);
    let enableDrag: boolean = this.dragAllowed && this.item.appStatus === AppStatus.INSTALLED;
    if (isDragItem) {
      this.iconData.setIconOpacity(0, TAG, 'initDragStatus');
      this.iconData.setContainerOpacity(0);
      enableDrag = false;
    }
    this.appIconConfig.setEnableDrag(enableDrag);
    this.iconData.enableDrag = enableDrag;
  }

  private getIconRect(): RectInfo {
    const iconId: string = AppIconModel.getInstance().getIconId(this.item, TAG);
    SceneSessionUIContextManager.getInstance().setUiContext(this.getUIContext());
    let itemRect = ItemUtils.getFrameNodeRectById(iconId);
    return itemRect;
  }
  /**
   * 处理鼠标事件
   *
   * @param event
   */
  private handleMouseEvent(event?: MouseEvent): void {
    if (event?.button === MouseButton.Right) {
      if (event.action === MouseAction.Press) {
        this.showInPageMenu(event);
      }
    } else if (event?.button === MouseButton.Left) {
      ContextMenu.close();
    }
  }

  build() {
    AppIconCommonView({
      iconData: this.iconData,
      iconContainerModifier: this.iconContainerModifier,
      iconMenuVm: this.iconMenuVm,
      iconEvent: this.iconEvent,
      appNameVm: this.appNameVm,
      appIconConfig: this.appIconConfig,
      item: this.item,
      iconRadius: this.iconRadius,
      iconSize: this.iconSize,
      isSelect: false,
      isGainFocus: false,
      maxNameLines: this.appCenterRst.mNameLines,
      nameHeight: this.appCenterRst.mNameHeight,
      nameWidth: this.appCenterRst.mNameWidth,
      nameSize: this.nameSize,
      nameMarginTop: this.mIconNameMargin,
      nameFontColor: this.appGridStyleConfig.mNameFontColor,
      isDragStart: this.isDragStart,
      isInDrag: this.isInDrag,
      translateX: this.translateX,
      translateY: this.translateY,
      disableMaskVm: this.disableMaskVm,
      isAppNameHover: this.isAppNameHover,
      popupOffset: popupOffset,
      popupPlacement: popupPlacement
    })
      .id(`${this.traceId}_AppBubble_${this.item.bundleName}`)
      .transition(AppStorage.get<boolean>('isDropAnimationGoing') ? TransitionEffect.OPACITY.animation({
        curve: Curve.FastOutSlowIn
      })
      .combine(TransitionEffect.scale({ x: 0.9, y: 0.9 }))
      .animation({ curve: curves.interpolatingSpring(0, 1, 342, 37) }) : TransitionEffect.IDENTITY)
      .parallelGesture(LongPressGesture({ repeat: false, duration: IN_PAGE_MENU_LONG_PRESS_TIME })
        .onAction(() => {
          this.showInPageMenu();
        }))
      .onMouse((event?: MouseEvent) => {
        this.handleMouseEvent(event);
      })
      .onClick((event) => {
        this.onIconContainerClick?.(event);
      })
      .clip(false)
      .onVisibleAreaChange([0, 1], (isVisible: boolean) => {
        if (!isVisible && this.isAppNameHover) {
          log.showInfo('close appName popup');
          this.isAppNameHover = false;
        }
      })
  }
}