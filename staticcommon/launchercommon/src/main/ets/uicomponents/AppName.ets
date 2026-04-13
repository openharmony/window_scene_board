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

import { LengthMetrics } from '@kit.ArkUI';
import { CheckEmptyUtils, LogDomain, LogHelper, } from '@ohos/basicutils';
import {
  DeviceHelper,
  ResourceManager,
  DownloadingProgressChangeEvent,
  DownloadStatusChangeEvent,
  InstallStatusChangeEvent,
  GlobalContext,
  WallpaperColorManager,
  TextColor,
  IconResourceManager
} from '@ohos/frameworkwrapper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { WallpaperConstants } from '@ohos/commonconstants';
import { } from '@ohos/windowscene';
import { PresetStyleConstants } from '../constants/PresetStyleConstants';
import {
  AppGalleryEventInfo,
  AppStatus,
  CommonConstants,
  DownloadStatusInfo,
  DeviceState
} from '../constants/CommonConstants';
import { StyleConstants } from '../constants/StyleConstants';
import inspector from '@ohos.arkui.inspector';
import { AttributeUpdater } from '@ohos.arkui.modifier';
import { ColorUtil } from '../utils/ColorUtil';
import ComponentPosShadowCache from '../cache/ComponentPosShadowCache';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { AppGalleryDownloadManager } from '../manager/AppGalleryDownloadManager';
import { ViewType, ViewManagerPolicy } from '@ohos/frameworkwrapper';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { AppListInfo } from '../folder/FolderModel';
import GridLayoutUtil from '../utils/GridLayoutUtil';
import {
  AppItemInfo,
  DisposedEventManager,
  editModeManager,
  EventConstants,
  ShowNameState,
  textShadowMgr,
} from '../TsIndex';

import { desktopFontScaleManager } from '../TsIndex';
import { DesktopFontScaleState } from '../TsIndex';
import { NoIconAppModel } from '../model/NoIconAppModel';
import type ctx from '@ohos.app.ability.common';
import { AppIconMenu } from '../launchericon/view/AppIconMenu';
import { AppIconCommonEvent } from '../launchericon/viewmodel/AppIconCommonEvent';
import { AppIconMenuEvent } from '../launchericon/viewmodel/AppIconMenuEvent';
import { AppInstallEventKey, AppInstallEventType } from '../appinstall/AppInstallEventKey';
import { AppStatusNameMapping } from '../appinstall/AppStatusNameMapping';
import { AppIconConfig } from '../launchericon/config/AppIconConfig';

const TAG = "AppName";
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);
const HEXADECIMAL_VALUE = 36;
const UPDATE_SHADOW_TIMEOUT = 80;
const SHADOW_ANIMATION_DURATION = 800;
const SHADOW_PADDING = PresetStyleConstants.DEFAULT_DESKTOP_NAME_PADDING;
const SHADOW_NAME_MAX_LENGTH: number = 14;
const LINE_BREAKABLE_FONT_SIZE = 1;
const MAX_RETRY_COUNT = 3;
const LAUNCHER_PHONE_MODULE = 'phone_sceneboard';
const LAUNCHER_FORM_ABILITY = 'SceneBoardFormAbility';

export class AppNameModifier extends AttributeUpdater<CommonAttribute> {
  public onInit?: (instance: CommonAttribute) => void;
  /**
   * 名称颜色根据壁纸颜色，默认：true
   */
  public enableWallpaperFontColor: boolean = true;
  /**
   * 名称是否支持拖拽落位渐隐动效，默认：true
   */
  public enableNameAnimate: boolean = true;

  initializeModifier(instance: CommonAttribute): void {
    this.onInit?.(instance);
  }
}

@Component
export struct AppName {
  @Prop nameSize: number = 0;
  nameHeight: number = 0; // 单行高度
  nameWidth: number = 0;
  @Prop bundleName: string = '';
  @Prop moduleName: string = '';
  parentItem: GridLayoutItemInfo | AppItemInfo = new GridLayoutItemInfo();
  zValue: number = 0;
  alignOption: AlignRuleOption | null = null;
  modifier: AppNameModifier = new AppNameModifier();
  isNeedUpdateName: boolean = true;
  @State showNameState: ShowNameState = editModeManager.getShowNameState();
  @State isInEditMode: boolean = editModeManager.isInEditMode();
  @State desktopMaxNameLines: number = PresetStyleConstants.DEFAULT_APP_NAME_LINES;
  @Prop nameBackgroundColor: string = StyleConstants.DEFAULT_DESKTOP_BACKGROUND_COLOR;
  @Prop labelId: number = 0;
  @Prop @Watch("updateName") appName: string = '';
  @StorageLink('desktopAppNameChange') @Watch('onLanguageChange') language: string = '';
  @Prop nameFontColor: ResourceColor = '#ffffff';
  @StorageProp('wallpaperChangeFlag') @Watch('wallpaperChange') wallpaperValue: boolean = true;
  @StorageProp('wallpaperSnapshotChangeFlag') @Watch('updateAppNameShadow') wallpaperSnapshotValue: boolean = false;
  @StorageProp('pageIndex') @Watch('updateShadowWhenTurnPage') swiperIndex: number = 0;
  @StorageProp('outerPageIndex') @Watch('updateShadowWhenTurnPage') outerSwiperIndex: number = 0;
  @StorageLink('folderStatus') @Watch('folderStatusChange') folderStatus: number = DeviceState.DEFAULT_STATE;
  @StorageLink('foldStatusForOuterScreen') @Watch('folderStatusChange') foldStatusForOuterScreen: number = DeviceState.DEFAULT_STATE;
  @State shadowOption: ShadowOptions = {
    radius: StyleConstants.APP_NAME_SHADOW_RADIUS,
    color: ColorUtil.convertRGBA2ResourceColor(0, 0, 0, 0),
    fill: true
  };
  private isOuterDesktop: boolean = false;
  useCache: boolean = true;
  nameLines: number = PresetStyleConstants.DEFAULT_APP_NAME_LINES;
  @Prop @Watch('changeMaxLines') maxLines: number = PresetStyleConstants.DEFAULT_APP_NAME_LINES;
  marginTop: number = PresetStyleConstants.DEFAULT_ICON_NAME_GAP;
  marginLeft: number = PresetStyleConstants.DEFAULT_DESKTOP_NAME_MARGIN;
  private currentFontColor?: ResourceColor;
  private colStart: number = 0;
  private colEnd: number = 0;
  private rowEnd: number = 0;
  private isPhone: boolean = false;
  // appName text whether or not the single shadow
  private isSingleShadow: boolean = false;
  private appNameId: string = this.getUUID();
  private getIndexInSwiper: Function = (): number => 0;
  private onAppGalleryEvent: Function = (eventInfo: AppGalleryEventInfo):
    void => this.appGalleryStatusChangeEvent(eventInfo);
  private onAppGalleryUpdateEvent: Function = (eventInfo: AppGalleryEventInfo):
    void => this.appGalleryUpdateEvent(eventInfo);
  private isNeedUpdateShadow: boolean = true;
  private isDesktopItem: boolean = false;
  private isNewStyle: boolean = AppStorage.get<boolean>('desktopNewStyle') ?? true;
  private desktopTextShadow: boolean = AppStorage.get<boolean>('desktopTextShadow') ?? true;
  private itemStatus?: AppStatus = AppStatus.INSTALLED;
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  @StorageLink('appListInfo') @Watch('updateShadowAfterAppListChange') appListInfo: AppListInfo = new AppListInfo();
  @StorageLink('outAppListInfo') @Watch('updateShadowAfterAppListChange') outerAppListInfo: AppListInfo = new AppListInfo();
  private appNameObserver: inspector.ComponentObserver | null = null;
  private iconId: string = '';
  // 图标事件处理类
  private iconEvent: AppIconCommonEvent = new AppIconCommonEvent();
  // 外部通用配置
  private appIconConfig: AppIconConfig = new AppIconConfig();
  @Prop private isAppNameHover: boolean = false;
  private popupPlacement: Placement = Placement.BottomLeft;
  private popupOffset: Position = { x: 0, y: 8 };
  private observerCallback: () => void = () => {
    log.showInfo('observerCallback appName: %{public}s, bundleName: %{public}s, labelId: %{public}d', this.appName,
      this.bundleName, this.labelId);
    setTimeout(() => {
      this.isNeedUpdateShadow = true;
      this.updateShadowOption();
    }, UPDATE_SHADOW_TIMEOUT);
    return;
  };
  @Prop isSelect: boolean = false;
  @Prop isGainFocus: boolean = false;
  @Prop mTranslate: TranslateOptions = { x: 0, y: 0 };
  @Prop iconRadius: number;
  @Prop mOpacity: number = 1;
  appIconId: string = '';
  private isFolderAppName: boolean = false;
  private isHideLogName: boolean = false;
  /**
   * 长辈模式字体
   */
  @State fontScaleState: DesktopFontScaleState = desktopFontScaleManager.getSysFontScaleState();
  private marginValue: Margin = {
    top: this.marginTop
  };
  private paddingValue : Padding = {
    bottom: StyleConstants.DEFAULT_2,
    top: StyleConstants.DEFAULT_2,
    left: StyleConstants.DEFAULT_2,
    right: StyleConstants.DEFAULT_2
  };

  // 是否拦截updateName，默认不拦截当前只有智慧屏拦截
  private isBlockUpdateName: boolean = false;

  // 是否支持拖拽
  private enableDrag: boolean = true;

  // 是否开启节点组缓存
  @State enableRenderGroup: boolean = true;
  private enableRenderGroupChange: Function = (enableRenderGroup: boolean) => {
    this.enableRenderGroup = enableRenderGroup;
  }

  public aboutToAppear(): void {
    this.isNewStyle = AppStorage.get<boolean>('desktopNewStyle') ?? true;
    this.desktopTextShadow = AppStorage.get<boolean>('desktopTextShadow') ?? true;
    let device: string = AppStorage.get('device') as string;
    this.isPhone = (device === CommonConstants.DEFAULT_DEVICE_TYPE);
    log.showInfo(`aboutToAppear appName: ${this.getLogName(this.appName)} labelId: ${this.labelId} bundleName: ${this.bundleName}, moduleName: ` +
      `${this.parentItem.moduleName}, abilityName: ${this.parentItem.abilityName} typeId: ${this.parentItem?.typeId} isNeedUpdateName: ${this.isNeedUpdateName}`);
    if (this.itemStatus === AppStatus.INSTALLED) {
      this.updateName();
      this.initDisposedRuleEvent();
    } else {
      // 兼容处理，目前只有手机适配了新的应用安装卸载，如果都适配了可以去掉
      let downloadStatusInfo: DownloadStatusInfo | undefined =
      AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo(this.bundleName);
      if (downloadStatusInfo && !this.parentItem.appIndex) {
        this.itemStatus = downloadStatusInfo.status;
      }
      if(this.itemStatus !== AppStatus.PENDING && this.itemStatus !== AppStatus.WAIT_FOR_HARMONY &&
        this.parentItem.typeId !== CommonConstants.TYPE_SHORTCUT_ICON) {
        this.appName = AppStatusNameMapping.getInstance().getDownloadEventNameByAppStatus(this.itemStatus);
      }
    }
    this.updateFontColor();
    this.initAppInstallEvent();
    if (this.isPhone) {
      this.appNameObserver = inspector.createComponentObserver(this.getAppNameComponentId());
      this.appNameObserver.on('layout', this.observerCallback);
      if (this.isNewStyle && this.desktopTextShadow) {
        this.desktopContext?.eventHub.off(CommonConstants.TEXT_SHADOW_CHANGE, this.onTextShadowChangeEvent);
        this.desktopContext?.eventHub.on(CommonConstants.TEXT_SHADOW_CHANGE, this.onTextShadowChangeEvent);
      }
    }
    this.desktopContext?.eventHub.on(EventConstants.EVENT_CHANGE_DESKTOP_MODE_NAME, this.onDesktopModeChangeEvent);
    if (DeviceHelper.isPC()) {
      this.desktopContext?.eventHub.on(CommonConstants.DESKTOP_ITEM_ENABLE_RENDER_GROUP, this.enableRenderGroupChange);
    }
  }

  aboutToReuse(params: Record<string, ESObject>): void {
    this.parentItem = params.parentItem;
    this.bundleName = this.parentItem.bundleName;
    this.moduleName = this.parentItem.moduleName as string;
    this.labelId = this.parentItem.appLabelId as number;
    this.appName = this.parentItem.appName ?? '';
    log.showInfo(`aboutToReuse appName: ${this.appName}, bundleName: ${this.bundleName}, labelId: ${this.labelId}`);
    this.initDisposedRuleEvent();
    this.initAppInstallEvent();
  }

  aboutToRecycle(): void {
    log.showInfo(`aboutToRecycle appName: ${this.appName}, bundleName: ${this.bundleName}`);
    this.offDisposedRuleEvent();
    this.offAppInstallEvent();
  }

  private isInFolderClosing: boolean = false;

  private onDesktopModeChangeEvent: Function = (): void => this.onEditModeChange();

  private onEditModeChange(): void {
    if (!this.isInFolderClosing) {
      this.isInEditMode = editModeManager.isInEditMode();
    }
  }

  private getMaxNameLines(): number {
    let fontSizeScale =
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).config.fontSizeScale ||
        1;
    return fontSizeScale > LINE_BREAKABLE_FONT_SIZE ? 1 : this.maxLines;
  }

  private changeMaxLines(): void {
    this.desktopMaxNameLines = this.getMaxNameLines();
  }

  initDisposedRuleEvent(): void {
  }

  private offDisposedRuleEvent(): void {
  }

  private onDisposedRuleEvent: Function = (params: number) => {
    log.showInfo(`onDisposedRuleEvent params ` + params);
    if (params === 1) {
      this.appName = getContext(this).resourceManager.getStringSync($r('app.string.wait_data_recover'));
    } else {
      IconResourceManager.getInstance().getAppNameWithCallback(this.labelId, this.bundleName, this.moduleName,
        this.appName, (name: string): void => this.appNameLoadCallback(name), this.parentItem?.appIndex);
    }
  }

  public aboutToDisappear(): void {
    if (this.appNameObserver) {
      this.desktopContext?.eventHub.off(CommonConstants.TEXT_SHADOW_CHANGE, this.onTextShadowChangeEvent);
      this.appNameObserver.off('layout', this.observerCallback);
      this.appNameObserver = null;
    }
    this.offDisposedRuleEvent();
    this.desktopContext?.eventHub.off(EventConstants.EVENT_CHANGE_DESKTOP_MODE_NAME, this.onDesktopModeChangeEvent);
    this.offAppInstallEvent();
    if (DeviceHelper.isPC()) {
      this.desktopContext?.eventHub.off(CommonConstants.DESKTOP_ITEM_ENABLE_RENDER_GROUP, this.enableRenderGroupChange);
    }
  }

  private onLanguageChange(): void {
    this.updateName();
  }

  private updateAppNameOfInstalledApp(): void {
    // 如果父组件指定了名称，且指定不需要刷新（说明父组件已经做了语言刷新等动作），则直接用指定的名称显示
    if (!this.isNeedUpdateName && !CheckEmptyUtils.isEmpty(this.appName)) {
      log.showWarn(`need not update name. isNeedUpdateName: ${this.isNeedUpdateName}, appName ${this.appName}`);
      return;
    }
    // 若bundleName为空，则认为资源ID为sceneBoard内部资源
    if (CheckEmptyUtils.isEmpty(this.bundleName) && this.labelId !== 0) {
      this.bundleName = CommonConstants.SCENEBOARD_BUNDLE;
    }
    // 待整改，公共组件移除定制逻辑
    if (this.parentItem?.typeId === CommonConstants.TYPE_CARD &&
      NoIconAppModel.getInstance().checkIfBundleIsNoIconApp(this.bundleName)) {
      this.getNoIconCardName();
      return;
    }
    IconResourceManager.getInstance().getAppNameWithCallback(this.labelId, this.bundleName, this.moduleName,
      this.appName, (name: string): void => this.appNameLoadCallback(name), this.parentItem?.appIndex);
  }

  private getNoIconCardName(): void {
    if (this.bundleName === CommonConstants.SCENEBOARD_BUNDLE) {
      if (this.parentItem?.moduleName === LAUNCHER_PHONE_MODULE &&
        this.parentItem?.abilityName === LAUNCHER_FORM_ABILITY) {
        return
      }
      this.appName = ResourceManager.getInstance().getStringByName('lock_screen');
      return
    }
    this.appName = NoIconAppModel.getInstance().updateNoIconAppInfo(this.bundleName).label;
  }

  private initAppInstallEvent(): void {
    // 只有图标才注册这个事件
    if (!this.parentItem.bundleName || this.parentItem.typeId !== CommonConstants.TYPE_APP) {
      log.showInfo('initAppInstallEvent bundleName:%{public}s, typeId:%{public}d return', this.parentItem.bundleName,
        this.parentItem.typeId);
      return;
    }
    // 分身和快捷方式不监听应用市场事件
    if (this.parentItem.appIndex !== CommonConstants.MAIN_APP_INDEX ||
      this.parentItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      return;
    }
    log.showInfo('initAppInstallEvent bundleName: %{public}s', this.parentItem.bundleName);
    this.offAppInstallEvent();
    // 监听应用升级名称变化事件
    if (this.itemStatus === AppStatus.INSTALLED) {
      this.desktopContext?.eventHub.on(AppInstallEventKey.getStatusChangeEventKey(this.parentItem.bundleName,
        AppInstallEventType.UPDATE_NAME), this.onAppGalleryUpdateEvent);
    } else {
      // 监听应用下载名称变化事件
      this.desktopContext?.eventHub.on(AppInstallEventKey.getStatusChangeEventKey(this.parentItem.bundleName,
        AppInstallEventType.NAME), this.onAppGalleryEvent);
    }
  }

  private offAppInstallEvent(): void {
    let bundleName = this.parentItem.bundleName;
    let updateKey = AppInstallEventKey.getStatusChangeEventKey(bundleName, AppInstallEventType.UPDATE_NAME);
    this.desktopContext?.eventHub.off(updateKey, this.onAppGalleryUpdateEvent);
    let installKey = AppInstallEventKey.getStatusChangeEventKey(bundleName, AppInstallEventType.NAME);
    this.desktopContext?.eventHub.off(installKey, this.onAppGalleryEvent);
  }

  private getSwiperIndex(): number {
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      return this.outerSwiperIndex;
    } else {
      return this.swiperIndex;
    }
  }

  private onTextShadowChangeEvent: Function = () => {
    if (this.getIndexInSwiper() === this.getSwiperIndex() ||
      (this.folderStatus === DeviceState.EXPAND_STATE && this.getNeighborPage(this.getIndexInSwiper()) === this.swiperIndex)) {
      this.isNeedUpdateShadow = true;
      this.updateShadowOption();
    }
  }

  private appGalleryUpdateEvent(eventInfo: AppGalleryEventInfo): void {
    this.desktopContext?.eventHub.on(AppInstallEventKey.getStatusChangeEventKey(this.parentItem.bundleName,
      AppInstallEventType.NAME), this.onAppGalleryEvent);
    this.desktopContext?.eventHub.off(AppInstallEventKey.getStatusChangeEventKey(this.parentItem.bundleName,
      AppInstallEventType.UPDATE_NAME), this.onAppGalleryUpdateEvent);
    this.onEventhubAppDownloadStatusChangedEvent(eventInfo as DownloadStatusInfo);
  }

  private appGalleryStatusChangeEvent(eventInfo: AppGalleryEventInfo): void {
    log.showWarn('appInstall onAppGalleryEvent %{public}s eventType:%{public}s appStatus:%{public}d',
      eventInfo.bundleName, eventInfo.eventType, eventInfo.status);
    switch (eventInfo.eventType) {
      case DownloadStatusChangeEvent.DOWNLOAD_STATUS_CHANGE:
      case InstallStatusChangeEvent.INSTALL_STATUS_CHANGE:
        this.onEventhubAppDownloadStatusChangedEvent(eventInfo as DownloadStatusInfo);
        break;
      case DownloadingProgressChangeEvent.DOWNLOAD_PROGRESS_CHANGE:
        this.onEventhubAppDownloadProgressChangedEvent(eventInfo);
        break;
      default:
        this.appName = '';
        break;
    }
  }

  private onEventhubAppDownloadStatusChangedEvent(eventInfo: DownloadStatusInfo): void {
    this.itemStatus = eventInfo.status as AppStatus;
    if (this.itemStatus === AppStatus.INSTALLED || this.itemStatus === AppStatus.PENDING) {
      this.appName = this.parentItem.appName ?? '';
      log.showInfo(`onInstalled appName: ${this.appName}`);
      // 重新注册监听
      this.initAppInstallEvent();
      return;
    }
    this.appName = AppStatusNameMapping.getInstance().getDownloadEventNameByAppStatus(this.itemStatus);
    log.showInfo(`onEventhubAppDownloadStatusChangedEvent appname: ${this.appName}`);
  }

  private onEventhubAppDownloadProgressChangedEvent(eventInfo: AppGalleryEventInfo): void {
    this.itemStatus = eventInfo.status === AppStatus.UPDATING ? AppStatus.UPDATING : AppStatus.DOWNLOADING;
    this.appName = AppStatusNameMapping.getInstance().getDownloadEventNameByAppStatus(this.itemStatus);
  }

  public appNameLoadCallback(name: string): void {
    log.showInfo(`appNameLoadCallback, moduleName: ${this.moduleName}, labelId: ${this.labelId}, name: ${this.getLogName(name)}`);
    if (GridLayoutUtil.isShortcutToDesktopInApp(this.parentItem)) {
      log.showInfo(`appNameLoadCallback return, item is shortcut to desktop`);
      return;
    }
    this.appName = name;
  }

  public updateName(): void {
    if (this.isBlockUpdateName) {
      return;
    }
    // 数据迁移恢复中名称显示，无需区分元素类型
    if (DisposedEventManager.getInstance().getRuledBundleNamesMap().has(this.bundleName)) {
      this.appName = getContext(this).resourceManager.getStringSync($r('app.string.wait_data_recover'));
      return;
    }
    // 如果是下载过程中状态的图标，则显示对应状态名称，若无需显示状态名称，则需根据传入状态
    let name = AppStatusNameMapping.getInstance().getDownloadEventNameByAppStatus(this.itemStatus);
    if (!CheckEmptyUtils.checkStrIsEmpty(name)) {
      this.appName = name;
      return;
    }
    this.updateAppNameOfInstalledApp();
  }

  private wallpaperChange(): void {
    this.updateFontColor();
    if (this.isPhone) {
      this.updateAppNameShadow();
    }
  }

  public updateFontColor(): void {
    if (!this.modifier.enableWallpaperFontColor) {
      log.showInfo('updateFontColor return for not wallpaper font color.');
      return;
    }
    let textColor: TextColor | undefined = WallpaperColorManager?.getInstance()?.mTextColor;
    if (textColor === undefined || textColor.mTextColor === undefined) {
      log.showError('textColor params error');
      this.retryUpdateFontColor(MAX_RETRY_COUNT);
      return;
    }
    log.showWarn(`updateFontColor:${textColor?.mTextColor}`);
    this.nameFontColor = textColor.mTextColor;
  }

  private retryUpdateFontColor(retryCount: number): void {
    if (retryCount <= 0) {
      log.showWarn(`no left retry count,nameFontColor:${this.nameFontColor}`);
      return;
    }
    setTimeout(() => {
      let textColor: TextColor | undefined = WallpaperColorManager?.getInstance()?.mTextColor;
      if (textColor === undefined || textColor.mTextColor === undefined) {
        this.retryUpdateFontColor(--retryCount);
        return;
      }
      log.showWarn(`retryUpdateFontColor mTextColor:${textColor?.mTextColor} retryCount:${retryCount}`);
      this.nameFontColor = textColor.mTextColor;
    }, 1000);
  }

  private updateAppNameShadow(): void {
    if (this.isPhone) {
      this.isNeedUpdateShadow = true;
      this.updateShadowOption();
    }
  }

  private updateShadowWhenTurnPage(): void {
    if (this.isPhone) {
      setTimeout(() => {
        this.updateShadowOption();
      }, UPDATE_SHADOW_TIMEOUT);
    }
  }

  private updateShadowAfterAppListChange(): void {
    if (this.getIndexInSwiper() === this.getSwiperIndex() && this.isPhone ||
      (this.folderStatus === DeviceState.EXPAND_STATE && this.getNeighborPage(this.getIndexInSwiper()) === this.swiperIndex)) {
      this.isNeedUpdateShadow = true;
      this.updateShadowOption();
    }
  }

  private folderStatusChange(): void {
  }

  getNameBackgroundColor(): string | Resource {
    if (this.isSelect) {
      if (this.isGainFocus) {
        return $r('sys.color.ohos_id_color_activated');
      } else {
        return $r('sys.color.ohos_id_color_bottom_tab_icon_auxcolor_off01');
      }
    } else {
      return StyleConstants.DEFAULT_DESKTOP_BACKGROUND_COLOR;
    }
  }

  @Builder
  PcDesktopAppNameBuilder() {
    Text(this.appName)
      .alignRules(this.alignOption)
      .draggable(this.enableDrag)
      .fontSize(this.nameSize)
      .fontColor(this.nameFontColor)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .textAlign(TextAlign.Center)
      .maxLines(this.desktopMaxNameLines)
      .lineHeight(this.nameHeight)
      .id(`AppName_text_${this.bundleName}`)
      .padding(this.paddingValue)
      .fontWeight(FontWeight.Medium)
      .clip(false)
      .textShadow(this.isSelect ? [] : this.getShadow())
      .renderGroup(this.enableRenderGroup)
      .border({
        width: StyleConstants.DEFAULT_1,
        color: this.isSelect ? $r('sys.color.ohos_id_color_switch_bg_off') : StyleConstants.DEFAULT_DESKTOP_BACKGROUND_COLOR,
        radius: $r('sys.float.ohos_id_corner_radius_default_xs')
      })
      .backgroundColor(this.getNameBackgroundColor())
      .margin(this.marginValue)
      .bindContextMenu(this.appIconConfig.enableRightMenuFromName ? this.rightClickMenuBuilder : (): void => {},
        ResponseType.RightClick, this.getContextMenu())
      .onMouse((event: MouseEvent) => {
        this.handleMouseEvent(event);
      })
      .attributeModifier(this.modifier)
      .dragPreview(this.iconId)
      .dragStyles()
      .translate(this.mTranslate)
      .onAreaChange((o, n) => {
        this.desktopMaxNameLines = this.getMaxNameLines();
      })
  }

  @Styles
  dragStyles() {
    .onDragStart((event: DragEvent) => { return this.iconEvent.getIconDragEventIface()?.onDragStart(event); })
    .onDragEnd((event: DragEvent) => this.iconEvent.getIconDragEventIface()?.onDragEnd(event))
    .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
      return this.iconEvent.getIconGestureJudgeIface()?.onGestureJudgeBegin(gestureInfo, event);
    })
    .dragPreviewOptions({}, {
      isDragPreviewEnabled: false,
    })
  }

  handleMouseEvent(event: MouseEvent) {
    if (!event) {
      log.showError('onMouse failed, event is invalid');
      return;
    }
    if (!this.appIconConfig?.externCb) {
      log.showError('onMouse failed, appIconConfig.externCb is invalid');
      return;
    }
    if (event.button === MouseButton.Right && event.action === MouseAction.Press) {
      this.iconEvent.getIconMenuEvent().setMenuInfo(this.appIconConfig.externCb.getMenuInfo,
        this.appIconConfig.externCb.getNotInstalledMenuMap);
    }
  }

  @Builder
  rightClickMenuBuilder() {
    AppIconMenu({
      isLongPressShow: false,
      appIconId: this.iconId,
      iconMenuVm: this.iconEvent.getIconMenuVm(),
      iconMenuEvent: this.iconEvent.getIconMenuEvent() as AppIconMenuEvent,
      iconSize: this.parentItem.appIconId,
      iconRadius: this.iconRadius,
      dragStart: this.appIconConfig.externCb?.onMenuDragStart,
      appItem: this.parentItem as AppItemInfo,
    })
  }

  build() {
    if (DeviceHelper.isPC() && this.isDesktopItem) {
      this.PcDesktopAppNameBuilder()
    } else {
      Text(this.appName)
        .draggable(false)
        .fontSize(this.appIconConfig.isAppCenterItem ? this.nameSize : this.fontScaleState.getScaleSize(this.nameSize))
        .fontColor(this.currentFontColor ?? this.nameFontColor)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Center)
        .maxLines(!this.isFolderAppName ? 1 : this.maxLines)
        .id(this.getAppNameComponentId())
        .fontWeight(this.isPhone ? FontWeight.Normal : FontWeight.Medium)
        .fontFamily(null)
        .clip(this.isPhone && !this.isFolderAppName)
        .margin({
          top: LengthMetrics.vp(this.fontScaleState.getFontMarginTop(this.marginTop)),
          start: LengthMetrics.vp(this.marginLeft),
          end: LengthMetrics.vp(this.marginLeft),
        })
        .padding({
          left: this.getAppNameLength(this.appName) >= SHADOW_NAME_MAX_LENGTH ? 0 : SHADOW_PADDING,
          right: this.getAppNameLength(this.appName) >= SHADOW_NAME_MAX_LENGTH ? 0 : SHADOW_PADDING
        })
        .shadow((this.isPhone && this.isNewStyle && this.desktopTextShadow &&
          !this.isInEditMode && !this.isFolderAppName && this.appIconConfig.enableNameShadow) ?
        this.shadowOption : null)
        .zIndex(this.zValue)
        .visibility(!this.showNameState.isShowName() || this.isOuterDesktop ?
        Visibility.Hidden : Visibility.Visible)
        .alignRules(this.alignOption)
        .renderGroup(((this.isPhone && !this.isFolderAppName) || this.appIconConfig.isAppCenterItem))
        .opacity(this.mOpacity)
        .attributeModifier(this.modifier)
        .accessibilityLevel('auto')
        .translate(this.mTranslate)
        .bindContextMenu(this.appIconConfig.enableRightMenuFromName ? this.rightClickMenuBuilder : (): void => {},
          ResponseType.RightClick, this.getContextMenu())
        .onMouse((event: MouseEvent) => {
          this.handleMouseEvent(event);
        })
        .bindPopup(this.isAppNameHover, {
          message: this.appName,
          placement: this.popupPlacement,
          enableArrow: false,
          offset: this.popupOffset,
          backgroundBlurStyle: BlurStyle.COMPONENT_ULTRA_THICK,
          targetSpace: 0,
          showInSubWindow: true,
          mask: false,
          transition: TransitionEffect.OPACITY
        })
    }
  }

  /**
   * 获取菜单的配置信息
   * @returns ContextMenuOptions
   */
  public getContextMenu(): ContextMenuOptions {
    return {
      offset: this.iconEvent.getIconMenuVm()?.menuOffset,
      placement: this.iconEvent.getIconMenuVm()?.getMenuPlacement(false),
      backgroundBlurStyle: this.iconEvent.getIconMenuVm()?.backgroundBlurStyle,
    };
  }

  /**
   * get text's shadow, single shadow in phone ,double shadow in pc
   * @returns object or array
   */
  private getShadow(): ShadowOptions | ShadowOptions[] {
    if (this.currentFontColor || this.isPhone || !this.isDesktopItem || !this.appIconConfig.enableNameShadow) {
      return { radius: 0 };
    } else {
      const nameFontColorUpper = this.nameFontColor ? this.nameFontColor.toString().toUpperCase() : '';
      // return shadow only when this.nameFontColor is white
      if (nameFontColorUpper === StyleConstants.APP_NAME_WHITE_COLOR || nameFontColorUpper === StyleConstants.APP_NAME_WHITE_COLOR_ALPHA) {
        if (this.isSingleShadow) {
          return {
            radius: StyleConstants.APP_CENTER_NAME_SHADOW_RADIUS,
            color: StyleConstants.APP_CENTER_NAME_SHADOW_COLOR,
            offsetY: StyleConstants.APP_CENTER_NAME_SHADOW_OFFSET_Y
          };
        } else {
          return [
            {
              radius: StyleConstants.APP_NAME_FIRST_SHADOW_RADIUS,
              color: StyleConstants.APP_NAME_FIRST_SHADOW_COLOR,
              offsetY: StyleConstants.APP_NAME_FIRST_SHADOW_OFFSET_Y
            },
            {
              radius: StyleConstants.APP_NAME_SECOND_SHADOW_RADIUS,
              color: StyleConstants.APP_NAME_SECOND_SHADOW_COLOR,
              offsetY: StyleConstants.APP_NAME_SECOND_SHADOW_OFFSET_Y
            }
          ];
        }
      }
      return { radius: 0 };
    }
  }

  private getAppNameComponentId(): string {
    return `AppName_text_${this.bundleName}_${this.appName}_${this.appNameId}`;
  }

  private getUUID(): string {
    let id = Date.now().toString(HEXADECIMAL_VALUE);
    id += Math.random().toString(HEXADECIMAL_VALUE).substring(2);
    return id;
  }

  private updateShadowOption(): void {
    if (!(this.isNewStyle && this.desktopTextShadow)) {
      return;
    }

    if (!this.isNeedShadow()) {
      return;
    }

    let key = this.getShadowCacheKey();
    let cache = ComponentPosShadowCache.getInstance().getCache(key);
    if (cache !== CommonConstants.INVALID_VALUE.toString()) {
      log.showInfo('updateShadowOption from cache %{public}s key %{public}s', cache, key);
      this.updateShadowColor(cache);
      return;
    }
  }

  private isNeedAppNameShadowAnimate(): boolean {
    if (AppStorage.get('openFolderStatus') === CommonConstants.OPEN_FOLDER_STATUS_TRANSITION_START) {
      return false;
    }
    if (ViewManagerPolicy.isViewShowing(ViewType.GLOBAL_SEARCH)) {
      return false;
    }
    return true;
  }

  private updateShadowColor(color: Color | string): void {
    log.showInfo('updateShadowColor, %{public}s color:%{public}s', this.appName, color);
    let refreshColor: Color | string = (color !== undefined) ? color : ColorUtil.convertRGBA2ResourceColor(0, 0, 0, 0);
    if (this.isNeedAppNameShadowAnimate() && refreshColor !== this.shadowOption.color) {
      animateTo({
        duration: SHADOW_ANIMATION_DURATION,
        curve: Curve.LinearOutSlowIn
      }, () => {
        this.shadowOption.color = refreshColor;
      });
    } else {
      this.shadowOption.color = refreshColor;
    }
  }

  private isNeedShadow(): boolean {
    if (!this.modifier.enableWallpaperFontColor) {
      return false;
    }
    if (!this.isNeedUpdateShadow) {
      return false;
    }
    if (ViewManagerPolicy.getViewController(ViewType.KEYGUARD)?.isShowing()) {
      this.isNeedUpdateShadow = true;
      log.showDebug('isNeedShadow, No update required in keyGurad.');
      return false;
    }
    let textColor: TextColor | undefined = WallpaperColorManager?.getInstance()?.mTextColor;
    if (textColor && WallpaperConstants.WALLPAPER_TYPE_NO_NEED_TXT_SHADOW.includes(textColor.mWallpaperType)) {
      log.showDebug('isNeedShadow, wallpaper type:%{public}d, does not need shadows', textColor.mWallpaperType);
      this.updateShadowColor(StyleConstants.DEFAULT_TRANSPARENT_COLOR);
      this.isNeedUpdateShadow = false;
      return false;
    }
    if (this.getIndexInSwiper() !== this.getSwiperIndex() &&
      !(this.folderStatus === DeviceState.EXPAND_STATE && this.getNeighborPage(this.getIndexInSwiper()) === this.swiperIndex)) {
      log.showDebug('isNeedShadow, The shadow of appName does not need to be updated. getIndexInSwiper():%{public}d swiperIndex:%{public}d',
        this.getIndexInSwiper(), this.getSwiperIndex());
      return false;
    }
    this.isNeedUpdateShadow = false;
    return true;
  }

  private getNeighborPage(page: number): number {
    if (page % StyleConstants.DEFAULT_2 === 0) {
      return page + StyleConstants.DEFAULT_1;
    } else {
      return page - StyleConstants.DEFAULT_1;
    }
  }

  private getShadowCacheKey(): string {
    if (this.colEnd < this.colStart || this.colStart < 0 || this.colEnd < 0) {
      log.showWarn(`getShadowCacheKey fail! colStart ${this.colStart} colEnd ${this.colEnd}`);
      return CommonConstants.INVALID_SHADOW_CACHE_KEY;
    }
    // 移动卡片时不会触发卡片组件build，无法正确更新col和row，需要主动刷新卡片名字的col和row
    this.updateAppNamePosition();
    let colTrans: number = this.colStart * StyleConstants.DEFAULT_2 + (this.colEnd - this.colStart);
    let textShadowScreen: number = 0;
    if (this.folderStatus === DeviceState.EXPAND_STATE) {
      textShadowScreen = textShadowMgr.getTextShadowScreenType(false,
        (this.getIndexInSwiper() % StyleConstants.DEFAULT_2 === 0));
    } else {
      textShadowScreen = textShadowMgr.getTextShadowScreenType(true, true);
    }
    return textShadowMgr.generateShadowKey(textShadowScreen, this.rowEnd, colTrans);
  }

  updateAppNamePosition(): void {
    let currentItemList: GridLayoutItemInfo[] = [];
    if (CheckEmptyUtils.isEmpty(this.parentItem)) {
      log.showInfo('updateAppNamePosition failure as the parentItem is null');
      return;
    }
    if (this.getIndexInSwiper() >= 0 && this.getIndexInSwiper() < this.appListInfo.appGridInfo.length) {
      currentItemList = this.appListInfo.appGridInfo[this.getIndexInSwiper()];
    }
    currentItemList.forEach(item => {
      if (item.typeId === CommonConstants.TYPE_APP && item.keyName === this.parentItem.keyName) {
        this.colStart = item.column ?? this.colStart;
        this.colEnd = GridLayoutUtil.calculateItemColEnd(item);
        this.rowEnd = GridLayoutUtil.calculateItemRowEnd(item);
      } else {
        let tmpItem: GridLayoutItemInfo = this.parentItem as GridLayoutItemInfo;
        if ((item.typeId === CommonConstants.TYPE_CARD && item.cardId === tmpItem.cardId) ||
          (item.typeId === CommonConstants.TYPE_FORM_STACK && item.formStackId === tmpItem.formStackId) ||
          (item.typeId === CommonConstants.TYPE_FOLDER && item.folderId == tmpItem.folderId)) {
          this.colStart = item.column ?? this.colStart;
          this.colEnd = GridLayoutUtil.calculateItemColEnd(item);
          this.rowEnd = GridLayoutUtil.calculateItemRowEnd(item);
        }
      }
    });
  }

  private getAppListInfo(): AppListInfo {
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      return this.outerAppListInfo;
    } else {
      return this.appListInfo;
    }
  }

  private getAppNameLength(str: string): number {
    let strlen = 0;
    if (str) {
      for (let i = 0; i < str.length; i++) {
        if (str.charCodeAt(i) > 255) {
          strlen += 2;
        } else {
          strlen++;
        }
      }
    }
    return strlen;
  }

  private getLogName(name: string) {
    return this.isHideLogName ? '' : name;
  }
}