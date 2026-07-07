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

import { CheckEmptyUtils, LogDomain, LogHelper, StartType } from '@ohos/basicutils/src/main/ets/TsIndex';
import { NumberConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { evtHubMgr } from '@ohos/frameworkwrapper/src/main/ets/manager/EventHubManager';
import { StartAbilityUtil } from '@ohos/windowscene';
import { editModeManager } from '../../../../editmode/model/EditModeManager';
import { AlertDialog } from '@ohos.arkui.advanced.Dialog';
import { AppIconConfig } from '../../../../launchericon/config/AppIconConfig';
import { AppIconCommonView } from '../../../../launchericon/view/AppIconCommonView';
import { AppIconBadgeVm } from '../../../../launchericon/viewmodel/AppIconBadgeVm';
import { AppIconCommonEvent } from '../../../../launchericon/viewmodel/AppIconCommonEvent';
import { AppIconData } from '../../../../launchericon/viewmodel/AppIconData';
import { AppInstallingDataManager } from '../../../../appinstall/AppInstallingDataManager';
import {
  AppItemInfo,
  AppGalleryDownloadManager,
  CommonConstants,
  DeliverUtil,
  FolderAppItemInfo,
  GridLayoutItemInfo,
  GridLayoutUtil,
  AppToHapMappingManager,
  FolderCommonUtil,
  InstalledDialogType,
  DialogConfig,
} from '../../../../TsIndex';
import { AppName } from '../../../../uicomponents/AppName';
import { FolderIconConfigUtil } from '../../../model/FolderIconConfigUtil';
import { AppStatus, DownloadStatusInfo } from '../../../../constants/CommonConstants'
import { deliverDialogType } from '../../../../base/AppToHapMappingManager';
import { BadgeAnimationType } from '../../../../uicomponents/CustomBadge';
import { NotHarmonyUtil } from '../../../../utils/NotHarmonyUtil';
import { BigFolderAppDefaultModifier } from '../../../viewmdoel/BigFolderAppDefaultModifier';
import { folderIconDataMgr } from '../viewmodel/manager/ContractedFolderIconDataManager';
import { HiSysEventUtil, IconResourceManager } from '@ohos/frameworkwrapper';
import { common } from '@kit.AbilityKit';
import { AppInstallUtils } from '../../../../appinstall/AppInstallUtils';
import { DeliveryDialogItem } from '../../common/model/data/DeliveryDialogItem';
import { UninstallDialog } from '../../../../uicomponents/UninstallDialog';
import { LaunchLayoutCacheManager } from '../../../../cache/layout/LaunchLayoutCacheManager';
import { FolderReporter } from '../../../FolderReporter';
import { IContractedFolderEventViewModel } from '../viewmodel/manager/IContractedFolderEventViewModel';
import { ContractedFolderViewModelType } from '../viewmodel/manager/ContractedFolderViewModelManager';
import { ContractedFolderViewModelManager } from '../viewmodel/manager/ContractedFolderViewModelManager';
import { ContractedFolderLayoutViewModel } from '../viewmodel/layout/ContractedFolderLayoutViewModel';
import { DeliverDialogUtil } from '../../../../utils/DeliverDialogUtil';
import { CloseAppManager } from '../../../../manager/CloseAppManager';

const TAG = 'DeliveryFolderItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹关闭态图标
 */
@Component
export struct DeliveryFolderItem {
  @State iconBadgeVm: AppIconBadgeVm = new AppIconBadgeVm();
  @State appData: AppIconData = new AppIconData();
  @Prop iconSize: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  @Prop iconRadius: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  @Prop @Watch('onResizeModeChange') editFolderMode: boolean = false;
  @Prop @Require public index: number = 0;
  @BuilderParam extendBadgeBuilder?: CustomBuilder;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;

  private taskparam: string = '{"backup":1}';
  private taskcontext: string = '{"backup":1}';
  private isSmall: boolean = false;
  public appIconConfig: AppIconConfig = new AppIconConfig();
  public bigFolderIconModifier: BigFolderAppDefaultModifier = new BigFolderAppDefaultModifier();
  public iconEvent: AppIconCommonEvent = new AppIconCommonEvent();
  public item: AppItemInfo = new AppItemInfo();
  public folderId: string = '';
  public isShowMask: boolean = false;
  public maskBgColor: string = '#00000000';
  private badgeVisibleEventKey: string = CommonConstants.EVENTHUB_BIG_FOLDER_OPEN_STATUS + this.item.keyName;
  private eventMgr: IContractedFolderEventViewModel = ContractedFolderViewModelManager.getInstance()
    .get(ContractedFolderViewModelType.EVENT) as IContractedFolderEventViewModel;
  private readonly mDoriItemUnable: Resource = $r('app.string.deliver_app_unavailable_dialog_title');
  private readonly mDoriInstallKnowBt: Resource = $r('app.string.deliver_app_unavailable_dialog_know');
  private readonly mTextPrimaryColor: Resource = $r('sys.color.ohos_id_color_text_primary_activated');
  private readonly mTextWarnColor: Resource = $r('sys.color.ohos_id_color_warning');
  private readonly mTextCancel: Resource = $r('app.string.cancel');
  private readonly mTextConfirm: Resource = $r('app.string.confirm_dialog');
  private readonly mDoriAppTitle: Resource = $r('app.string.deliver_app_dialog_title');
  private readonly mDoriIgnoreBt: Resource = $r('app.string.deliver_app_dialog_cancel');
  private readonly mDoriUpdateBt: Resource = $r('app.string.deliver_app_dialog_confirm');
  private readonly mDoriInstalledTitle: Resource = $r('app.string.uninstall_deliver_app_dialog_title');
  private readonly mTextUninstall: Resource = $r('app.string.uninstall');

  aboutToAppear() {
    if (this.isShowMask) {
      this.appData.isShowMask = true;
      this.appData.maskBgColor = this.maskBgColor;
      this.appData.maskOpacity = 1;
    }
    if (this.editFolderMode) {
      folderIconDataMgr.setIconData(String(this.index), this.appData);
    }
    this.badgeVisibleEventKey = CommonConstants.EVENTHUB_BIG_FOLDER_OPEN_STATUS + this.item.keyName;
    this.iconBadgeVm.visible = !this.editFolderMode;
    this.iconBadgeVm.bindFolderId = this.folderId;
  }

  aboutToDisappear() {
  }

  onResizeModeChange(): void {
    if (this.editFolderMode) {
      folderIconDataMgr.setIconData(String(this.index), this.appData);
      this.iconBadgeVm.animate = BadgeAnimationType.OPACITY_ZERO;
    } else {
      this.iconBadgeVm.visible = true;
      this.iconBadgeVm.animate = BadgeAnimationType.CLOSE_FOLDER_COMPONENT_SHOW;
    }
  }

  /**
   * 根据所点击的应用的类型、是否安装以及是否启动来响应不同的操作
   * @param appItem 点击的应用
   */
  private checkContainerAppClickEvent(appItem: AppItemInfo): void {
    if (editModeManager.isInEditMode() || ContractedFolderLayoutViewModel.getInstance().getViewOsrMgr(this.folderId)
      .getIsMenuShow()) {
      log.showInfo('open folder app fail as edit mode or menu show');
      return;
    }
    if (!appItem) {
      log.showWarn('open folder app fail with null item');
      return;
    }
    // 如果应用正在安装（更新过程中的安装，第一次下载应用安装由于有动效不需要toast），点击应用弹出toast
    if (AppInstallingDataManager.getInstance().isInstalling(this.item.bundleName)) {
      AppInstallingDataManager.getInstance().toastInstalling(this.item.bundleName);
      return;
    }
    if (!GridLayoutUtil.isAppInstalled(appItem)) {
      let installSource: string = DeliverUtil.getInstallSourceByIntent(appItem.intent);
      if (installSource === DeliverUtil.DELIVER_APPSTORE_PKG) {
        if (DeliverUtil.isdeliverHapExist()) {
          DeliverUtil.startdeliverAutoEnterLakeAbility(appItem.bundleName, appItem.iconResource);
        } else {
          this.alertDialogByMatchContainerHapStatus(appItem);
        }
      } else if (installSource === DeliverUtil.ABROAD_APP_PKG) {
        if (DeliverUtil.isEasyAbroadExist()) {
          DeliverUtil.startEasyAbroadAutoEnterLakeAbility(appItem.bundleName, appItem.iconResource);
        } else {
          this.alertDialogByMatchContainerHapStatus(appItem);
        }
      } else {
        AppInstallUtils.getInstance().checkTask(appItem);
        FolderReporter.getInstance().reportClickAppIconInFolderEvent(ContractedFolderLayoutViewModel.getInstance()
            .getFolderDataById(this.folderId)
            .getGridInfo(), appItem as GridLayoutItemInfo);
      }
    } else {
      let isDeliverStart: boolean = DeliverUtil.getDeliverStartStatus() === DeliverUtil.DELIVER_START_FINISHED_CODE;
      if (isDeliverStart || (!isDeliverStart && DeliverUtil.isMatchContainerHapExist(appItem as GridLayoutItemInfo))) {
        this.openDialogOrApplication(appItem);
      } else {
        this.alertDialogByMatchContainerHapStatus(appItem);
      }
    }
    return;
  }

  /**
   * 打开弹窗或者应用
   *
   * @param appItem 元素item
   */
  public openDialogOrApplication(appItem: AppItemInfo): void {
    let mappingManager = AppToHapMappingManager.getInstance();
    let hapBundleName: string = mappingManager.getMapping().get(appItem.bundleName) as string;
    let dialogItem: DeliveryDialogItem = new DeliveryDialogItem();
    switch (mappingManager.shouldOpenDialog(appItem.bundleName)) {
      case deliverDialogType.NOT_EXIST_MAPPING_NEXT_VERSION:
        CloseAppManager.getInstance().setStartAppType(StartType.FOLDER);
        this.eventMgr?.openApplication('openDialog', appItem as GridLayoutItemInfo);
        break;
      case deliverDialogType.NEXT_VERSION_NOT_INSTALLED:
        GridLayoutUtil.checkCurrentItemAppName(appItem);
        dialogItem.appItem = appItem;
        dialogItem.hapBundleName = hapBundleName;
        let showAppName: string = IconResourceManager.getInstance()
          .getAppNameByCache(this.item.appLabelId, this.item.bundleName, this.item.moduleName, '', this.item.appIndex);
        if (CheckEmptyUtils.isEmpty(showAppName)) {
          showAppName = this.item.appName ?? '';
        }
        this.builddeliverAppDialog(dialogItem, showAppName).open();
        HiSysEventUtil.reportdeliverDialogOpen(appItem.bundleName);
        break;
      case deliverDialogType.NEXT_VERSION_INSTALLED:
        GridLayoutUtil.checkCurrentItemAppName(appItem);
        dialogItem.appItem = appItem;
        dialogItem.hapBundleName = hapBundleName
        let installedDialogType: InstalledDialogType = mappingManager.getInstalledDialogType(appItem.bundleName);
        this.buildUninstalldeliverAppDialog(installedDialogType, dialogItem).open();
        HiSysEventUtil.reportdeliverDialogOpen(appItem.bundleName);
        break;
      default :
        log.showWarn('openDialogOrApplication type error');
    }
  }

  /**
   * 根据点击的应用所对应的克隆应用/应用的状态来响应不同的弹框
   *
   * @param appItem 点击的应用
   */
  public alertDialogByMatchContainerHapStatus(appItem: AppItemInfo): void {
    let isdeliverApp: boolean =
      DeliverUtil.getInstallSourceByIntent(appItem.intent) === DeliverUtil.DELIVER_APPSTORE_PKG;
    let result: GridLayoutItemInfo[];
    if (isdeliverApp) {
      result =
        LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(DeliverUtil.DELIVER_APP_BUNDLE_NAME_REAL);
    } else {
      result = LaunchLayoutCacheManager.getInstance()
        .getAllSameBundleNameAppItem(DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME_REAL);
    }
    if (CheckEmptyUtils.isEmptyArr(result)) {
      let content: string = 'app.string.deliver_app_unavailable_dialog_content';
      this.builddeliverAppAlertDialog(appItem, content, DeliverUtil.DIALOG_TYPE_UNAVAILABLE).open();
      HiSysEventUtil.reportdeliverDialogOpen(appItem?.bundleName);
      return;
    }
    let containerItem: GridLayoutItemInfo = result[0];
    let downloadStatusInfo: DownloadStatusInfo | undefined =
      AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo(DeliverUtil.DELIVER_APP_BUNDLE_NAME_REAL);
    let containerItemStatus: number =
      downloadStatusInfo ? downloadStatusInfo.status : containerItem.appStatus as number;
    log.showInfo(`container is ${containerItem.bundleName}`);
    log.showInfo(`containerItemStatus is ${containerItemStatus}`);
    if (containerItemStatus === AppStatus.DOWNLOADING || containerItemStatus === AppStatus.INSTALLING ||
      containerItemStatus === AppStatus.INSTALL_WAITING) {
      let content: string = 'app.string.deliver_app_installing_dialog_content';
      this.builddeliverAppAlertDialog(appItem, content, DeliverUtil.DIALOG_TYPE_INSTALLING).open();
      HiSysEventUtil.reportdeliverDialogOpen(appItem?.bundleName);
    } else if (containerItemStatus === AppStatus.WAITING || containerItemStatus === AppStatus.WIFI_WAITING ||
      containerItemStatus === AppStatus.PENDING) {
      let content: string = 'app.string.deliver_app_wait_download_dialog_content';
      this.builddeliverAppChooseDialog(appItem, content, containerItem, containerItemStatus,
        DeliverUtil.DIALOG_TYPE_WAIT_DOWNLOAD).open();
      HiSysEventUtil.reportdeliverDialogOpen(appItem?.bundleName);
    } else if (containerItemStatus === AppStatus.PAUSING) {
      let content: string = 'app.string.deliver_app_pause_download_dialog_content';
      this.builddeliverAppChooseDialog(appItem, content, containerItem, containerItemStatus,
        DeliverUtil.DIALOG_TYPE_PAUSE_DOWNLOAD).open();
      HiSysEventUtil.reportdeliverDialogOpen(appItem?.bundleName);
    }
  }

  /**
   * 构建克隆应用弹框
   *
   * @param appItem 元素item
   * @param content 弹窗内容
   * @returns 弹框
   */
  public builddeliverAppAlertDialog(appItem: AppItemInfo, content: string, dialogType?: number): CustomDialogController {
    let deliverAppAlertDialog: CustomDialogController = new CustomDialogController({
      builder: AlertDialog({
        primaryTitle: this.mDoriItemUnable,
        content: $r(content, DeliverUtil.getContainerFolderNameForDialog(appItem)),
        primaryButton: {
          value: this.mDoriInstallKnowBt,
          fontColor: this.mTextPrimaryColor,
          action: () => {
            HiSysEventUtil.reportdeliverDialogOperation(this.item?.bundleName,
              dialogType ?? DeliverUtil.DIALOG_TYPE_UNAVAILABLE, DeliverUtil.CLICK_KNOW);
            log.showInfo('click know for doriApp AlertDialog');
            deliverAppAlertDialog?.close();
          },
        },
      }),
      cancel: () => {
        HiSysEventUtil.reportdeliverDialogOperation(this.item?.bundleName,
          dialogType ?? DeliverUtil.DIALOG_TYPE_UNAVAILABLE, DeliverUtil.CLICK_BLANK_AREA);
        log.showInfo('click cancel for doriApp AlertDialog');
        deliverAppAlertDialog?.close();
      },
      autoCancel: true,
      customStyle: false,
      alignment: DialogAlignment.Center,
    });
    return deliverAppAlertDialog;
  }

  private builddeliverAppChooseDialog(appItem: AppItemInfo, content: string, containerItem: GridLayoutItemInfo,
    containerItemStatus: number, dialogType?: number): CustomDialogController {
    let deliverAppAlertDialog: CustomDialogController = new CustomDialogController({
      builder: AlertDialog({
        primaryTitle: this.mDoriItemUnable,
        content: $r(content, DeliverUtil.getContainerFolderNameForDialog(appItem as GridLayoutItemInfo)),
        primaryButton: {
          value: this.mTextCancel,
          fontColor: this.mTextPrimaryColor,
          action: () => {
            HiSysEventUtil.reportdeliverDialogOperation(appItem?.bundleName,
              dialogType ?? DeliverUtil.DIALOG_TYPE_UNAVAILABLE, DeliverUtil.CLICK_CANCEL);
            log.showInfo('deliverAppChooseDialog cancel');
            deliverAppAlertDialog?.close();
          },
        },
        secondaryButton: {
          value: this.mTextConfirm,
          fontColor: this.mTextWarnColor,
          action: () => {
            HiSysEventUtil.reportdeliverDialogOperation(appItem?.bundleName,
              dialogType ?? DeliverUtil.DIALOG_TYPE_UNAVAILABLE, DeliverUtil.CLICK_CONFIRM);
            log.showInfo('deliverAppChooseDialog confirm');
            if (containerItemStatus === AppStatus.WAITING || containerItemStatus === AppStatus.WIFI_WAITING) {
              AppInstallUtils.getInstance().clickAppToPreDownload(containerItem);
            } else if (containerItemStatus === AppStatus.PAUSING) {
              AppInstallUtils.getInstance().resumeTask(containerItem.bundleName);
            }
            deliverAppAlertDialog?.close();
          }
        },
      }),
      cancel: () => {
        HiSysEventUtil.reportdeliverDialogOperation(appItem?.bundleName, dialogType ?? DeliverUtil.DIALOG_TYPE_UNAVAILABLE,
          DeliverUtil.CLICK_BLANK_AREA);
        log.showInfo('deliverAppChooseDialog cancel');
        deliverAppAlertDialog?.close();
      },
      autoCancel: true,
      customStyle: false,
      alignment: DialogAlignment.Center,
    });
    return deliverAppAlertDialog;
  }

  private builddeliverAppDialog(dialogItem: DeliveryDialogItem, appName: string): CustomDialogController {
    const appItem: AppItemInfo = dialogItem.appItem;
    const hapBundleName: string = dialogItem.hapBundleName;
    let deliverAppDialog = new CustomDialogController({
      builder: AlertDialog({
        primaryTitle: this.mDoriAppTitle,
        content: $r('app.string.deliver_app_dialog_text', appName),
        primaryButton: DeliverDialogUtil.createDialogPrimaryButton(appItem.bundleName, this.mDoriIgnoreBt, () => {
          HiSysEventUtil.reportdeliverDialogOperation(appItem.bundleName, DeliverUtil.DIALOG_TYPE_NEW_VERSION,
            DeliverUtil.CLICK_IGNORE)
          log.showInfo('deliver_app_dialog_title cancel');
          this.eventMgr?.openApplication('DoriAppDia', appItem as GridLayoutItemInfo);
          deliverAppDialog?.close();
        }),
        secondaryButton: {
          value: this.mDoriUpdateBt,
          action: () => {
            HiSysEventUtil.reportdeliverDialogOperation(appItem?.bundleName, DeliverUtil.DIALOG_TYPE_NEW_VERSION,
              DeliverUtil.CLICK_UPDATE)
            log.showInfo('deliver_app_dialog_title confirm');
            const want: Want = {
              uri: `id=${hapBundleName}&taskparam=${this.taskparam}&taskcontext=${this.taskcontext}&scene=leavingLake`,
              action: 'action.system.home'
            };
            const context = getContext(this) as common.UIAbilityContext;
            context.startAbility(want).catch(() => {
              // 拉起失败
            });
            deliverAppDialog?.close();
          }
        },
      }),
      cancel: () => {
        HiSysEventUtil.reportdeliverDialogOperation(appItem.bundleName, DeliverUtil.DIALOG_TYPE_NEW_VERSION,
          DeliverUtil.CLICK_BLANK_AREA)
        log.showInfo('deliver_app_dialog_title cancel');
        deliverAppDialog?.close();
      },
      autoCancel: true,
      customStyle: false,
      alignment: DialogAlignment.Center,
    });
    return deliverAppDialog;
  }

  private buildUninstalldeliverAppDialog(installedDialogType: InstalledDialogType,
    dialogItem: DeliveryDialogItem): CustomDialogController {
    let hapAppName = GridLayoutUtil.getdeliverAppName(dialogItem.hapBundleName);
    let appItem: AppItemInfo = dialogItem.appItem;
    let hapAppItems = LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(dialogItem.hapBundleName);
    let dialogConfig: DialogConfig = DeliverUtil.getStringByDialogType(installedDialogType);
    let uninstalldeliverAppDialog: CustomDialogController = new CustomDialogController({
      builder: AlertDialog({
        primaryTitle: this.mDoriInstalledTitle,
        content: $r(dialogConfig.content, hapAppName),
        primaryButton: DeliverDialogUtil.createUninstallDialogPrimaryButton(installedDialogType,
          $r(dialogConfig.primaryButton), () => {
            HiSysEventUtil.reportdeliverDialogOperation(appItem?.bundleName, DeliverUtil.DIALOG_TYPE_NEXT_VERSION,
              DeliverUtil.CLICK_IGNORE);
            log.showInfo('uninstalldeliverAppDialog cancel');
            this.eventMgr?.openApplication('open DoriApp', appItem as GridLayoutItemInfo);
            uninstalldeliverAppDialog?.close();
          }),
        secondaryButton: {
          value: $r(dialogConfig.secondaryButton),
          fontColor: $r(dialogConfig.fontColor),
          action: () => {
            if (installedDialogType === InstalledDialogType.OPEN) {
              log.showInfo('uninstalldeliverAppDialog open');
              HiSysEventUtil.reportdeliverDialogOperation(appItem?.bundleName, DeliverUtil.DIALOG_TYPE_NEXT_VERSION,
                DeliverUtil.CLICK_OPEN_NEXT);
              if (!CheckEmptyUtils.isEmptyArr(hapAppItems)) {
                StartAbilityUtil.startAbilityByName(hapAppItems[0].abilityName, hapAppItems[0].bundleName,
                  hapAppItems[0].moduleName);
              }
              uninstalldeliverAppDialog?.close();
            } else {
              HiSysEventUtil.reportdeliverDialogOperation(appItem?.bundleName, DeliverUtil.DIALOG_TYPE_UNINSTALL,
                DeliverUtil.CLICK_UNINSTALL);
              log.showInfo('uninstalldeliverAppDialog uninstall');
              uninstalldeliverAppDialog?.close();
              AppStorage.setOrCreate('uninstallAppInfo', appItem);
              AppStorage.setOrCreate('showUninstallDialog', true);
              this.buildUninstallDialog(appItem)?.open();
            }
          }
        },
      }),
      cancel: () => {
        HiSysEventUtil.reportdeliverDialogOperation(appItem.bundleName, DeliverUtil.DIALOG_TYPE_NEXT_VERSION,
          DeliverUtil.CLICK_BLANK_AREA)
        log.showInfo('uninstalldeliverAppDialog cancel');
        uninstalldeliverAppDialog?.close();
      },
      autoCancel: true,
      customStyle: false,
      alignment: DialogAlignment.Center,
    });
    return uninstalldeliverAppDialog;
  }

  private buildUninstallDialog(appItem: AppItemInfo): CustomDialogController {
    let uninstallDialog: CustomDialogController = new CustomDialogController({
      builder: UninstallDialog({
        cancel: () => {
          uninstallDialog.close();
        },
        confirm: () => {
          this.eventMgr?.uninstallApplication('uninstall deliveryItem', appItem as GridLayoutItemInfo);
          uninstallDialog.close();
        },
        dialogName: FolderCommonUtil.getUninstallDialogName(appItem?.appName),
        isFromDesktop: true
      }),
      cancel: () => {},
      autoCancel: true,
      showInSubWindow: true,
      alignment: DialogAlignment.Center,
    });
    return uninstallDialog;
  }

  @Builder
  accessibilityNameBuilder(item: AppItemInfo) {
    if (this.isAccessibilityMode) {
      // 仅用于无障碍屏幕朗读模式下app名称播报
      AppName({
        nameHeight: 0,
        nameWidth: 0,
        nameSize: 0,
        bundleName: item.bundleName,
        moduleName: item.moduleName,
        parentItem: item,
        appName: item.appName,
        labelId: item.appLabelId,
        useCache: true,
        itemStatus: item?.appStatus,
        zValue: -1,
      })
    }
  }

  @Builder
  appIconBuilder() {
    AppIconCommonView({
      item: this.item,
      iconSize: this.iconSize,
      iconRadius: this.iconRadius,
      appIconConfig: FolderIconConfigUtil.getDeliveryFolderIconConfig(this.folderId, this.appIconConfig,
        this.isAccessibilityMode, this.isSmall, (item: AppItemInfo) => this.checkContainerAppClickEvent(item),
        this.item),
      iconModifier: this.bigFolderIconModifier,
      iconBadgeVm: this.iconBadgeVm,
      iconData: this.appData,
      iconEvent: this.iconEvent,
      extendBadgeBuilder: this.extendBadgeBuilder,
    })
  }


  build() {
    if (this.isAccessibilityMode && !this.isSmall) {
      Stack({ alignContent: Alignment.Center }) {
        this.accessibilityNameBuilder(this.item)
        this.appIconBuilder()
      }
      .onClick((event?: ClickEvent) => this.checkContainerAppClickEvent(this.item))
    } else {
      this.appIconBuilder();
    }
  }
}