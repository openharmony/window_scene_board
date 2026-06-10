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
  LogHelper,
  StartType,
  CheckEmptyUtils,
  DomainName,
  TraceUtil,
  SingleContext
} from '@ohos/basicutils';
import {
  DeviceHelper,
  HiSysEventUtil,
  localEventManager,
  ResourceManager,
  GlobalContext
} from '@ohos/frameworkwrapper';
import { MemoryManager } from '@ohos/frameworkcommon';
import {
  ResUtils,
  EventType,
  scbEventExclusiveManager,
  launcherStatusUtil,
  StartAbilityUtil
} from '@ohos/windowscene';
import curves from '@ohos.curves';
import { FormCardItem, FormManagerDialog } from '@ohos/form';
import {
  UninstallDialog,
  ReConfirmationUninstallDialog,
  UninstallDialogUtil,
  AppIconContainerModifier,
  AppIconConfig,
  AppIconCommonView,
  AppIconCommonEvent,
  AppIconDefaultModifier
} from '@ohos/launchercommon/Index';
import {
  AppDataWrapper,
  AppGalleryDownloadManager,
  AppItemInfo,
  AppStatus,
  AppInstallUtils,
  CloseAppManager,
  CommonConstants,
  DownloadStatusInfo,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LaunchLayoutCacheManager,
  LayoutDescription,
  MenuInfo, PresetStyleConstants,
  ShortcutViewModel,
  StyleConstants,
  AppToHapMappingManager,
  DesktopUtils,
  PreInstallUtils,
  InstalledDialogType,
  CardItemInfo,
  EventConstants,
  UninstallListener,
  DragCoveredItem
} from '@ohos/launchercommon';
import { DeleteAction } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { AppIconData } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconData';
import { PageDesktopDragHandler } from '../PageDesktopDragHandler';
import { PageDesktopViewModel } from '../viewmodel/PageDesktopViewModel';
import { DeskTopItemStyle } from '@ohos/launchercommon/Index';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import { ForceType, GravityAnimationConfig, GravityAnimationManager } from '@ohos/componentanimator/Index';
import { SwiperLoadData } from '@ohos/swiperdata';
import { AutoAlignDataManager } from '../autoalign/AutoAlignDataManager';
import { AppIconMenuVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconMenuVm';
import { common, Want } from '@kit.AbilityKit';
import { AlertDialog } from '@ohos.arkui.advanced.Dialog';
import lazy { outerAddAppIconManager } from '@ohos/launchercommon/src/main/ets/manager/OuterAddAppIconManager';
import { AppInstallingDataManager } from '@ohos/launchercommon/src/main/ets/appinstall/AppInstallingDataManager';
import { Prompt } from '@kit.ArkUI';
import { AbilityConstant } from '@kit.AbilityKit';

const TAG = 'DesktopAppIcon';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const UNINSTALL_APP_DURATION = 500;
const FOREGROUND_BLUR_RADIUS = 70;

@Component
export struct DesktopAppIcon {
  item: AppItemInfo = new AppItemInfo();
  @Prop singleContext?: SingleContext;
  maxNameLines: number = PresetStyleConstants.DEFAULT_APP_NAME_LINES;
  private getIndexInSwiper: Function = (): number => 0;
  isDesktopItem: boolean = false;

  private pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance(this.singleContext);
  private startType: StartType = StartType.APP;
  private clearForm?: Function;

  private nameHeight: number = StyleConstants.DEFAULT_APP_NAME_HEIGHT;
  private nameWidth: number = StyleConstants.DEFAULT_APP_NAME_WIDTH;
  private nameSize: number = StyleConstants.DEFAULT_APP_NAME_SIZE;
  private nameMarginTop: number = PresetStyleConstants.DEFAULT_ICON_NAME_MARGIN_TOP;
  private nameFontColor: string = '';
  private isExistsItem : boolean = false;

  private appIconContainerModifier: AppIconContainerModifier = new AppIconContainerModifier(
    () => this.updateModifier());
  private appIconConfig: AppIconConfig = new AppIconConfig();
  @State iconData: AppIconData = new AppIconData();
  @State iconMenuVm: AppIconMenuVm = new AppIconMenuVm();

  @State iconRadius: number = CommonConstants.DEFAULT_ICON_RADIUS;
  @Prop isSelect: boolean = false; // 仅PC使用
  @Link iconSize: number;
  @Prop isGainFocus: boolean = false; // appName使用

  @Link isDragStart: boolean;
  @Link isInDrag: boolean;
  // 拖拽挤位相关
  @Link translateX: number;
  @Link translateY: number;

  @ObjectLink @Watch('onDesktopStyleChange') desktopStyle: DeskTopItemStyle;
  @StorageLink('uninstallAppInfo') uninstallAppInfo: AppItemInfo = new AppItemInfo();
  @StorageLink('formAppInfo') formAppInfo: AppItemInfo = new AppItemInfo();
  @StorageLink('itemPadding') @Watch('onItemPaddingChange') itemPadding: number = 0;
  @StorageLink('themeStyle') @Watch('onThemeChange') themeStyle: string = '';
  @StorageLink('desktopIconChange') @Watch('onThemeChange') desktopIconChange: number = 0;
  @StorageLink('addOuterAppItem') @Watch('setOpacityByAddOuterApp') addAppItem?: GridLayoutItemInfo = undefined;
  private iconEvent: AppIconCommonEvent = new AppIconCommonEvent();
  private iconModifier: AppIconDefaultModifier = new AppIconDefaultModifier();

  private unInstallListener: UninstallListener = {
    uninstallApp: (bundleName: string, appIndex?: number, shortcutId?: string): void => {},
    uninstallAppResult: (bundleName: string, resultCode: number, appIndex?: number, shortcutId?: string):
      void => this.uninstallAppResult(bundleName, resultCode, appIndex, shortcutId)
  };

  private setOpacityByAddOuterApp(): void {
      return;
  }

  // CustomDialogController必须在@Component struct内部定义时赋值才有效，
  /**
   * 卸载菜单弹框
   */
  private menuDialogController: CustomDialogController | null = new CustomDialogController({
    builder: UninstallDialog({
      cancel: () => {},
      confirm: () => {
        this.uninstallDialogConfirm();
      },
      dialogName: this.getMenuDialogName(this.uninstallAppInfo),
      dialogContent: this.getMenuDialogContent(this.uninstallAppInfo),
      isFromDesktop: true
    }),
    cancel: () => {
      log.showInfo('cancel app uninstall dialog');
    },
    autoCancel: true,
    showInSubWindow: true,
    alignment: DialogAlignment.Center,
  });

  private uninstallDialogConfirm(): void {
    if (UninstallDialogUtil.getIsNeedReConfirmationApp(this.uninstallAppInfo.bundleName)) {
      this.reConfirmationDialogController?.open();
    } else {
      this.onMenuDialogConfirm(this.uninstallAppInfo);
    }
  }

  /**
   * 二次卸载菜单弹框
   */
  private reConfirmationDialogController: CustomDialogController | null = new CustomDialogController({
    builder: ReConfirmationUninstallDialog({
      cancel: () => {
      },
      confirm: () => {
        this.onMenuDialogConfirm(this.uninstallAppInfo);
      },
      appIndex: this.uninstallAppInfo.appIndex,
      bundleName: this.uninstallAppInfo.bundleName,
      moduleName: this.uninstallAppInfo.moduleName,
      abilityName: this.uninstallAppInfo.abilityName
    }),
    cancel: () => {
      log.showInfo('cancel app uninstall dialog');
    },
    autoCancel: true,
    showInSubWindow: true,
    alignment: DialogAlignment.Center,
  });

  /**
   * 服务卡片菜单弹框
   */
  private menuFormManagerDialogController: CustomDialogController | null = new CustomDialogController({
    builder: FormManagerDialog({
      singleContext: this.singleContext,
      cancel: (callback?: Function): void => { this.onFormDialogCancel(callback);},
      confirm: (formCardItem: FormCardItem): void => { this.onFormDialogConfirm(formCardItem); },
      bundleName: this.formAppInfo.bundleName,
      appName: this.formAppInfo.applicationName,
      appLabelId: this.formAppInfo.applicationLabelId,
      isPcEditCard: DeviceHelper.DEVICE_TYPE !== CommonConstants.DEFAULT_DEVICE_TYPE
    }),
    cancel: (): void => { this.onCancelFormDialog() },
    autoCancel: true,
    customStyle: true,
    showInSubWindow: true
  });

  /*
  * 移除菜单弹框，CustomDialogController必须在@Component struct内部定义时赋值才有效
  */
  private removeDialogController: CustomDialogController = new CustomDialogController({
    builder: UninstallDialog({
      fromRemoveAction: DeleteAction.ACTION_REMOVE,
      cancel: () => {},
      confirm: () => { this.onRemoveDialogConfirm(this.item); },
      dialogName: this.getMenuDialogName(this.item, DeleteAction.ACTION_REMOVE),
      dialogContent: this.getMenuDialogContent(this.item, DeleteAction.ACTION_REMOVE),
      isFromDesktop: true
    }),
    cancel: () => { log.showInfo('cancel app uninstall dialog'); },
    autoCancel: true,
    showInSubWindow: true,
    alignment: DialogAlignment.Center,
  });

  private onThemeChange(): void {
    log.showInfo('onThemeChange');
    if (!launcherStatusUtil.isCurrentDesktopVisible()) {
      return
    }
    this.initStyleConfig();
  }

  private onItemPaddingChange(): void {
    this.appIconContainerModifier.attribute?.padding({ top: this.itemPadding, bottom: this.itemPadding });
  }

  private updateModifier(): void {
    this.appIconContainerModifier.attribute?.translate({
      x: CheckEmptyUtils.isEmpty(this.desktopStyle) ? 0 : this.desktopStyle.translateX,
      y: CheckEmptyUtils.isEmpty(this.desktopStyle) ? 0 : this.desktopStyle.translateY
    });
    this.appIconContainerModifier.attribute?.opacity(CheckEmptyUtils.isEmpty(this.desktopStyle) ?
      1 : this.desktopStyle.alpha);
    this.appIconContainerModifier.attribute?.scale(this.getScale());
    this.appIconContainerModifier.attribute?.padding({ top: this.itemPadding, bottom: this.itemPadding });
  }

  private getScale(): ScaleOptions {
    if (CheckEmptyUtils.isEmpty(this.desktopStyle)) {
      return {
        x: 1,
        y: 1,
      }
    } else {
      return {
        x: this.desktopStyle.scale,
        y: this.desktopStyle.scale,
        centerX: this.desktopStyle.unLockAnimate ? this.desktopStyle.centerX : '50%',
        centerY: this.desktopStyle.unLockAnimate ? this.desktopStyle.centerY : '50%',
      }
    }
  }

  private onDesktopStyleChange(): void {
    this.updateModifier();
  }

  private onFormDialogCancel(callback?: Function): void {
    // delete all form
    if (callback !== undefined) {
      this.clearForm = callback;
    } else {
      log.showError('FormManagerDialog callback error'); // 维测日志
    }
  }

  private onFormDialogConfirm(formCardItem: FormCardItem): void {
    // add form to desktop
    log.showInfo(`createCardToDeskTop formCardItem: ${JSON.stringify(formCardItem)}`);
    this.pageDesktopViewModel.createCardToDeskTop(formCardItem as CardItemInfo);
    // delete other form
  }

  private onCancelFormDialog(): void {
    log.showInfo('cancel form dialog');
    this.clearForm?.();
  }

  private getMenuDialogContent(uninstallAppInfo: AppItemInfo, type: number = 0): string | Resource {
    if (type === DeleteAction.ACTION_REMOVE) {
      return $r('app.string.remove_content');
    }
    let dialogContent = ResUtils.getInnerStringNumS($r('app.string.pinch_to_enter_the_editing_page'),
      ResUtils.getOutString($r('app.string.external_screen_application')), uninstallAppInfo?.appName);
    return '';
  }

  private getMenuDialogName(uninstallAppInfo: AppItemInfo, type: number = 0): string | Resource {
    if (type === DeleteAction.ACTION_REMOVE) {
      return $r('app.string.is_remove', uninstallAppInfo.appName);
    } else if (uninstallAppInfo.appIndex) {
      return $r('app.string.is_delete', uninstallAppInfo.appName);
    }
    return $r('app.string.isUninstall', uninstallAppInfo.appName)
  }

  private onRemoveDialogConfirm(moveInfo: AppItemInfo): void {
    this.pageDesktopViewModel.removeNotInstall(moveInfo);
  }

  private onMenuDialogAutoAlign(): void {
    let uninstallAppItemInfoArr: AppItemInfo[] = [];
    uninstallAppItemInfoArr.push(this.uninstallAppInfo);
    AutoAlignDataManager.getInstance().init();
    AutoAlignDataManager.getInstance().addAutoAlginItem(this.uninstallAppInfo.bundleName + this.uninstallAppInfo.typeId + this.uninstallAppInfo.appIndex);
    if (this.uninstallAppInfo.appIndex === 0) {
      let gridLayoutItemList: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance()
        .selectItemListByPageAndArea(this.uninstallAppInfo.page, this.uninstallAppInfo.area);
      gridLayoutItemList.forEach(itemInfo => {
        let flagName: string = itemInfo.bundleName + itemInfo.typeId + itemInfo.appIndex;
        if (itemInfo.bundleName === this.uninstallAppInfo.bundleName && itemInfo.appIndex !== 0) {
          uninstallAppItemInfoArr.push(itemInfo as AppItemInfo);
          AutoAlignDataManager.getInstance().addAutoAlginItem(flagName);
        }
        if (itemInfo.bundleName === this.uninstallAppInfo.bundleName && itemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
          uninstallAppItemInfoArr.push(itemInfo as AppItemInfo);
          AutoAlignDataManager.getInstance().addAutoAlginItem(flagName);
        }
      });
    }
    log.showInfo('onMenuDialogConfirm autoAlign uninstallAppInfo bundleName %{public}s, uninstallAppInfo appName %{public}s' +
      'uninstallAppItemInfoArr length: %{public}d', this.uninstallAppInfo.bundleName, this.uninstallAppInfo.appName, uninstallAppItemInfoArr.length);
    this.pageDesktopViewModel.autoAlignAfterUninstall(uninstallAppItemInfoArr);
  }

  private onMenuDialogConfirm(uninstallAppInfo: AppItemInfo): void {
    log.showWarn('onMenuDialogConfirm click');
      this.updateItemPosition(uninstallAppInfo);
      this.pageDesktopViewModel.uninstallApp(uninstallAppInfo.bundleName,
        uninstallAppInfo.isUninstallAble as boolean, uninstallAppInfo.appIndex);
      this.onMenuDialogAutoAlign();
  }

  private uninstallAppBlurAnimation(): void {
    if (editModeManager.isInEditMode()) {
      log.showInfo('no need to trigger gravity animation');
      return;
    }
    log.showInfo(`remove animation bundelName:${this.item.bundleName}, appIndex:${this.item.appIndex}, ` +
      `shortcutId:${this.item.shortcutId}`);
    if (this.isExistsItem) {
      log.showInfo('trigger gravity animation with application [%{public}d:%{public}d,%{public}d] uninstalled',
        this.getIndexInSwiper(), this.item.row, this.item.column);
      const cachedPos: number[] = GridLayoutUtil.getIconCenterPosition(this.item.row, this.item.column, this.item.area,
        this.getIndexInSwiper());
      setTimeout(() => {
        GravityAnimationManager.getInstance().run(
          SwiperLoadData.getInstance().getSwiperKeyByIndex(this.getIndexInSwiper()),
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
      this.iconData.containerScale = 0;
      this.iconData.containerForeEffectRadius = FOREGROUND_BLUR_RADIUS;
    })
  }

  private triggerGravityAnimation(item: AppItemInfo): void {
    if (!item) {
      return;
    }
    log.showInfo('trigger gravity animation with appIcon remove');
    const cachedPos: number[] = GridLayoutUtil.getIconCenterPosition(item.row, item.column, item.area,
      this.getIndexInSwiper());
    setTimeout(() => {
      GravityAnimationManager.getInstance().run(
        SwiperLoadData.getInstance().getSwiperKeyByIndex(this.getIndexInSwiper()),
        cachedPos[0], cachedPos[1], ForceType.GRAVITATION);
    }, GravityAnimationConfig.getDelayOnRemoveApplication());
  }

  private deleteAppFunc: () => void = () => this.deleteApp(this.uninstallAppInfo);

  private deleteApp(deleteAppInfo: AppItemInfo): void {
    log.showInfo('application %{public}s will be deleted', this.item.bundleName);
    if (this.item.bundleName === deleteAppInfo.bundleName &&
      this.item.appIndex === (deleteAppInfo.appIndex ?? 0) &&
      this.item.shortcutId === (deleteAppInfo.shortcutId ?? '')) {
      log.showInfo('trigger gravity animation with application [%{public}d:%{public}d, %{public}d] deleted',
        this.getIndexInSwiper(), this.item.row, this.item.column);
      const cachedPos: number[] = GridLayoutUtil.getIconCenterPosition(this.item.row, this.item.column, this.item.area,
        this.getIndexInSwiper());
      setTimeout(() => {
        GravityAnimationManager.getInstance().run(
          SwiperLoadData.getInstance().getSwiperKeyByIndex(this.getIndexInSwiper()),
          cachedPos[0], cachedPos[1], ForceType.GRAVITATION);
      }, GravityAnimationConfig.getDelayOnRemoveApplication());
    } else {
      log.showError('cannot get item %{public}s/%{public}s info', this.item.typeId, this.item.bundleName);
    }

    animateTo({
      duration: UNINSTALL_APP_DURATION,
      curve: curves.cubicBezierCurve(0.4, 0, 0.67, 1),
      onFinish: (() => {
        this.iconData.containerOpacity = 1;
        this.iconData.containerScale = 1;
        this.iconData.containerForeEffectRadius = -1;
      })
    }, () => {
      this.iconData.containerOpacity = 0;
      this.iconData.containerScale = 0;
      this.iconData.containerForeEffectRadius = FOREGROUND_BLUR_RADIUS;
    });
  }

  public uninstallAppResult(bundleName: string, resultCode: number, appIndex?: number, shortcutId?: string): void {
    if (this.isEquals(bundleName, appIndex, shortcutId)) {
      if (this.item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        this.updateItemPosition(this.item);
      }
      if (resultCode === CommonConstants.UNINSTALL_SUCCESS) {
        this.uninstallAppBlurAnimation();
      } else {
        this.iconData.containerScale = 1;
        this.iconData.containerForeEffectRadius = -1;
      }
    }
  }

  private setStartAppInfo(): void {
    log.showInfo('set start app type: StartType.APP');
    CloseAppManager.getInstance().setStartAppType(StartType.APP);
  }

  private dragStart(x: number, y: number): void {
    AppStorage.setOrCreate<string>('selectItem', '');
    if (!DeviceHelper.isPhone()) {
      this.pageDesktopViewModel.selectItemClear();
    }
    PageDesktopDragHandler.getInstance(this.singleContext).onDragStart(x, y);
  }

  private getItemAppStatus(): AppStatus {
    if (!GridLayoutUtil.isAppInstalled(this.item)) {
      let downloadStatusInfo: DownloadStatusInfo | undefined =
        AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo(this.item.bundleName);
      if (downloadStatusInfo && !this.item.appIndex) {
        return downloadStatusInfo.status;
      } else {
        return this.iconData.appStatus;
      }
    }
    return AppStatus.INSTALLED;
  }

  private initStartType(): void {
    if (this.item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      this.startType = StartType.SHORTCUT_APP;
      return;
    }
    this.startType = this.pageDesktopViewModel.getDevice() ? StartType.DESKTOP_APP : StartType.APP;
  }

  private async reportClickAppIcon(): Promise<void> {
    let component: string = this.item.bundleName;
    let containerType: string = 'desktop';
    let description: LayoutDescription = LaunchLayoutCacheManager.getInstance().selectLayoutDescription();
    const screenPageCount: number = description ? description.pageCount : 0;
    let position: string = `SCREENCOUNT: ${screenPageCount}SCREENINDEX:${this.item.page}` +
      `CELLX:${this.item.column}CELLY:${this.item.row}isInDock:false`;
    if (this.item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      HiSysEventUtil.reportClickShortcut(component, this.item.shortcutId, containerType, position,
        '-1', '-1', '-1');
    }
  }

  private launchApp(): void {
    CloseAppManager.getInstance().setStartAppType(this.startType, undefined, undefined, this.item.shortcutId);
    if (this.startType === StartType.SHORTCUT_APP) {
      ShortcutViewModel.getInstance()
        .onShortcutAppClick(this.item, undefined, AbilityConstant.REASON_MESSAGE_DESKTOP_SHORTCUT);
    } else {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_APP_DOUBLE_CLICK, {
        abilityName: this.item.abilityName,
        bundleName: this.item.bundleName,
        moduleName: this.item.moduleName as string,
        appIndex: this.item.appIndex
      });
    }
  }

  private dealClickEvent(event?: ClickEvent, fingers?: number): void {
    if (scbEventExclusiveManager.isExclusive(EventType.DESKTOP_CLICK)) {
      if (fingers === 1) {
        scbEventExclusiveManager.restoreAllEventExclusive(EventType.DESKTOP_CLICK);
      }
      return;
    }

    this.reportClickAppIcon();
    if (event?.source === SourceType.Mouse) {
      PageDesktopViewModel.getInstance(this.singleContext).onAppClick(this.item.abilityName,
        this.item.bundleName, this.item.moduleName as string, this.item.appIndex);
    } else {
      log.showWarn('tap click, bundleName:%{public}s, abilityName:%{public}s, page:%{public}d, row:%{public}d, ' +
        'column:%{public}d', this.item.bundleName, this.item.abilityName, this.item.page, this.item.row,
        this.item.column);
      this.launchApp();
      MemoryManager.getInstance().notifyClearOpenApp();
    }
  }

  private outerUninstallAppClickTips(itemAppStatus: number, bundleName: string): void {
    log.showInfo(`checkClickEvent itemAppStatus: ${itemAppStatus}, bundleName: ${bundleName}`);
    let gridLayoutItemInfo: GridLayoutItemInfo[] =
      LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(bundleName);
    if (CheckEmptyUtils.isEmptyArr(gridLayoutItemInfo)) {
      log.showInfo(`this grid Layout itemInfo is empty.`);
      return;
    }
    let mainAppItem: GridLayoutItemInfo = gridLayoutItemInfo[0];
    if (CheckEmptyUtils.isEmpty(mainAppItem)) {
      log.showInfo(`this app item is empty.`);
      return;
    }
    if (itemAppStatus === AppStatus.DOWNLOADING) {
      Prompt.showToast({
        message: ResUtils.getInnerStringNumS($r('app.string.click_twin_app_download_start'), `${mainAppItem.appName}`)
      });
      return;
    }
    if (itemAppStatus === AppStatus.INSTALLING) {
      Prompt.showToast({
        message: ResUtils.getInnerStringNumS($r('app.string.click_twin_app_download_installing'), `${mainAppItem.appName}`)
      });
      return;
    }
    Prompt.showToast({
      message: ResUtils.getInnerStringNumS($r('app.string.click_twin_app_not_installed'), `${mainAppItem.appName}`)
    });
  }

  private checkClickEvent(event?: ClickEvent, fingers?: number): void {
    if (editModeManager.isInEditMode()) {
      log.showInfo(`ignore click in edit mode. keyName:${this.item.keyName}`);
      return;
    }
    // 如果应用正在安装（更新过程中的安装，第一次下载应用安装由于有动效不需要toast），点击应用弹出toast
    if (AppInstallingDataManager.getInstance().isInstalling(this.item.bundleName)) {
      AppInstallingDataManager.getInstance().toastInstalling(this.item.bundleName);
      return;
    }
    let itemAppStatus: AppStatus = this.getItemAppStatus();
    if (itemAppStatus === AppStatus.INSTALLED || itemAppStatus === undefined) {
      log.showInfo(`dealClickEvent fingers: ${fingers}.`);
      this.dealClickEvent(event, fingers);
      return;
    } else if ((this.item.appIndex && this.item.appIndex > 0) ||
      this.item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      AppInstallUtils.getInstance().clickTwinApp(this.item.bundleName);
      return;
    }
    if (itemAppStatus === AppStatus.DOWNLOADING || itemAppStatus === AppStatus.UPDATING) {
      log.showInfo('clickAppToPause');
      //  调用暂停接口
      AppInstallUtils.getInstance().pauseTask(this.item.bundleName);
      HiSysEventUtil.reportPauseAppDownload(this.item.bundleName);
    } else if (itemAppStatus === AppStatus.PENDING || itemAppStatus === AppStatus.WAIT_FOR_HARMONY) {
      if (PreInstallUtils.checkIsNeedInstallAppByIntent(this.item)) {
        log.showInfo('clickPreInstallGrayAppToDownLoad');
        AppInstallUtils.getInstance().requestTask(this.item);
      } else {
        //  调用检查接口
        log.showInfo('clickAppToCheck');
        AppInstallUtils.getInstance().checkTask(this.item);
      }
      this.reportClickAppIcon();
    } else if (itemAppStatus === AppStatus.PAUSING || itemAppStatus === AppStatus.WIFI_WAITING) {
      //  调用恢复接口
      log.showInfo('clickAppToResume');
      AppInstallUtils.getInstance().resumeTask(this.item.bundleName);
      HiSysEventUtil.reportContinueAppDownload(this.item.bundleName);
    } else if (itemAppStatus === AppStatus.WAITING) {
      AppInstallUtils.getInstance().dealClickPreDownload(this.item as GridLayoutItemInfo);
    }
  }

  private openDialogOrApplication(event?: ClickEvent, fingers?: number): void {
    let mappingManager: AppToHapMappingManager = AppToHapMappingManager.getInstance();
    let hapBundleName: string = mappingManager.getMapping().get(this.item.bundleName) as string;
  }

  private checkCurrentItemAppName(appItem: GridLayoutItemInfo | AppItemInfo): void {
    if (CheckEmptyUtils.isEmpty(appItem.appName)) {
      appItem.appName =
        ResourceManager.getInstance().getCachedAppName(appItem.appLabelId, appItem.bundleName, appItem.moduleName);
    }
  }

  private initStyleConfig(): void {
    let styleConfig = this.pageDesktopViewModel.getPageDesktopStyleConfig();
    this.iconSize = styleConfig.mIconSize;
    this.iconRadius = styleConfig.mIconRadius;
    this.nameHeight = styleConfig.mNameHeight;
    this.nameWidth = styleConfig.mNameWidth;
    this.nameSize = styleConfig.mNameSize;
    if (this.isDesktopItem && DeviceHelper.isPC()) {
      this.nameMarginTop = styleConfig.mIconNameMargin + StyleConstants.DEFAULT_0;
    } else {
      this.nameMarginTop = styleConfig.mIconNameMargin + styleConfig.mIconNameMarginTop;
    }
    this.nameFontColor = styleConfig.mNameFontColor;
    log.showInfo(`iconSize: ${this.iconSize}, iconRadius: ${this.iconRadius} nameMarginTop ${this.nameMarginTop}`);
  }

  private updateItemPosition(uninstallAppInfo: AppItemInfo): void {
    const cached = LaunchLayoutCacheManager.getInstance().selectGridLayoutItemByItem(
      uninstallAppInfo as Object as GridLayoutItemInfo);
    // 如果缓存中可以获得且为同一应用则更新item的位置信息用于引力动效
    if (this.isEquals(uninstallAppInfo.bundleName, uninstallAppInfo.appIndex, uninstallAppInfo.shortcutId) && cached) {
      log.info(`update item position : row: ${cached.row},column: ${cached.column}, area: ${cached.area}`);
      this.item.row = cached.row;
      this.item.column = cached.column;
      this.item.area = cached.area;
      this.isExistsItem = true;
    }
  }

  private isEquals(bundleName: string, appIndex?: number, shortcutId?: string): boolean {
    return this.item.bundleName === bundleName && this.item.appIndex === (appIndex ?? 0) &&
      (this.item.shortcutId ?? '') === (shortcutId ?? '');
  }

  private initAppIconConfig(): void {
    this.appIconConfig.setEnableHoverAnimation(true)
      .setIsDesktopItem(this.isDesktopItem)
      .setEnableSupportCheckAndFix(true)
      .setAppDataOfTransactionController(AppDataWrapper.getDefaultAppData(this.item, this.iconRadius))
      .setExternCb({
        getIndexInSwiper: (): number => this.getIndexInSwiper(),
        getNotInstalledMenuMap: () => {
          return this.pageDesktopViewModel.buildNotInstalledAppMenu(this.item, this.removeDialogController,
            (item: AppItemInfo): void => {
              this.triggerGravityAnimation(item);
            });
        },
        dragStartExtend: (event: DragEvent): void => this.dragStart(event.getWindowX(), event.getWindowY()),
        getMenuInfo: (): MenuInfo[] => {
          // 文件夹卸载后剩一个应用场景，需要刷新下应用的卸载状态
          return this.pageDesktopViewModel.buildMenuInfoList(this.item, this.menuDialogController,
            null, this.menuFormManagerDialogController, (): void => this.setStartAppInfo());
        },
        onIconClick: (event?: ClickEvent, fingers?: number): void => {
          log.showInfo('onClick icon');
          this.checkClickEvent(event, fingers);
        },
        onMenuDragStart: (x: number, y: number): void => this.dragStart(x, y),
        isHideIconContainer: () => {
          let dragCoveredItem = AppStorage.get<DragCoveredItem>('DragCoveredItem');
          if (dragCoveredItem?.isCreateSmallFolder && dragCoveredItem?.dragItemInfo?.keyName === this.item.keyName) {
            return true;
          }
          return false;
        }
      });
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    // 初始化透明度,防止正在走外屏添加app的动效时对应AppItem显现桌面上
    this.setOpacityByAddOuterApp();
    this.initStyleConfig();
    this.initStartType();
    this.initAppIconConfig();
    this.pageDesktopViewModel.registerUninstallListener(this.unInstallListener);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.pageDesktopViewModel.unregisterUninstallListener(this.unInstallListener);
  }

  build() {
    AppIconCommonView({
      iconContainerModifier: this.appIconContainerModifier,
      appIconConfig: this.appIconConfig,
      iconData: this.iconData,
      item: this.item,
      iconRadius: this.iconRadius,
      iconSize: this.iconSize,
      isSelect: this.isSelect,
      isGainFocus: this.isGainFocus,
      maxNameLines: this.maxNameLines,
      nameHeight: this.nameHeight,
      nameWidth: this.nameWidth,
      nameSize: this.nameSize,
      nameMarginTop: this.nameMarginTop,
      nameFontColor: this.nameFontColor,
      isDragStart: this.isDragStart,
      isInDrag: this.isInDrag,
      translateX: this.translateX,
      translateY: this.translateY,
      iconMenuVm: this.iconMenuVm,
      iconEvent: this.iconEvent,
      iconModifier: this.iconModifier
    })
  }
}