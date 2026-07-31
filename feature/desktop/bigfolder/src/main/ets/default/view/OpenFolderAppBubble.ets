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

import { image } from '@kit.ImageKit';
import { AlertDialog } from '@ohos.arkui.advanced.Dialog';
import { ArrayUtils, CheckEmptyUtils, CommonUtils, LogDomain, LogHelper, StartType } from '@ohos/basicutils';
import { DragConstants } from '@ohos/commonconstants';
import { DropAnimationScene } from '@ohos/componentanimator';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import { DragDataType, DragEventCallback, DragEventManager, DragExtraInfo } from '@ohos/componentdrag';
import { dragSnapshotHelper, ObjectCopyUtil, SnapshotType } from '@ohos/componenthelper';
import { AppInstallingDataManager } from '@ohos/launchercommon/src/main/ets/appinstall/AppInstallingDataManager';
import {
  DeviceHelper,
  DownloadingProgressChangeEvent,
  DownloadStatusChangeEvent,
  GlobalContext,
  HiSysEventUtil,
  IconResourceManager,
  InstallStatusChangeEvent,
  localEventManager,
  ResourceManager
} from '@ohos/frameworkwrapper';
import {
  AppInstallUtils,
  AppModel,
  AppToHapMappingManager,
  InstalledDialogType,
  DesktopUtils,
  EventConstants,
  FolderConstants,
  LaunchLayoutCacheManager,
  ListenerItemType,
  launcherAbilityManager,
  lockedAppUninstallModel,
  MultiSelectListenerType,
  multiSelectListenManger,
  MultiSelectManager,
  NotHarmonyUtil,
  ShortcutViewModel,
  ShowNameState,
  PreInstallUtils,
  FolderManager,
  ContractedFolderCommonViewModel,
  FolderCommonUtil,
  FolderCommonConstants,
  FolderDropType,
  DragViewModelUtil,
  FolderStyleManager,
  lockLayoutManager,
  MenuInfoType,
} from '@ohos/launchercommon';
import {
  AppIconCommonEvent,
  AppIconCommonView,
  AppIconConfig,
  UninstallDialog,
  DeliverDialogUtil,
  UninstallDialogUtil,
  ReConfirmationUninstallDialog,
  DragProxyManager,
  DragHandlerType,
  IDesktopDragHandler,
} from '@ohos/launchercommon/Index';
import { deliverDialogType } from '@ohos/launchercommon/src/main/ets/base/AppToHapMappingManager';
import GridLayoutItemInfo from '@ohos/launchercommon/src/main/ets/bean/GridLayoutItemInfo';
import { MenuInfo } from '@ohos/launchercommon/src/main/ets/bean/MenuInfo';
import {
  AppDownloadInfo,
  AppGalleryEventInfo,
  AppStatus,
  CommonConstants,
  DeleteAction,
  DownloadStatusInfo
} from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { PresetStyleConstants } from '@ohos/launchercommon/src/main/ets/constants/PresetStyleConstants';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/constants/StyleConstants';
import { EditModeState } from '@ohos/launchercommon/src/main/ets/editmode/data/EditModeState';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import { FolderIconConfigUtil } from '@ohos/launchercommon/src/main/ets/folder/model/FolderIconConfigUtil';
import {
  openFolderAppBubbleLayout
} from '@ohos/launchercommon/src/main/ets/folder/viewmdoel/OpenFolderAppBubbleLayout';
import { AppIconExternCb } from '@ohos/launchercommon/src/main/ets/launchericon/interface/AppIconExternCb';
import { AppIconBadgeVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconBadgeVm';
import { AppIconData } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconData';

import { AppNameVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppNameVm';
import { CustomBadgeManager } from '@ohos/launchercommon/src/main/ets/model/CustomBadgeManager';
import {
  AppGalleryDownloadManager,
  AppItemInfo,
  CloseAppManager,
  DeliverUtil,
  EditModeUtils,
  FolderData,
  FolderLayoutCacheManager,
  GrayAppListManager,
  DialogConfig,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { AppNameModifier } from '@ohos/launchercommon/src/main/ets/uicomponents/AppName';
import GridLayoutUtil from '@ohos/launchercommon/src/main/ets/utils/GridLayoutUtil';
import { SCBSceneSessionManager, StartAbilityUtil } from '@ohos/windowscene';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import FeatureConstants from '../common/constants/FeatureConstants';
import { DragItemFromFolderStartInfo } from '../common/DragItemFromFolderStartInfo';
import { FolderAccessibilityUtils } from '../common/FolderAccessibilityUtils';
import OpenFolderDragHandler from '../common/OpenFolderDragHandler';

import { BigFolderViewModel } from '../viewmodel/BigFolderViewModel';
import { OpenFolderAppMoveVm } from '../viewmodel/OpenFolderAppMoveVM';
import { openFolderAppMoveVMManager } from '../viewmodel/OpenFolderAppMoveVMManager';
import { OpenFolderBadgeManager } from '../viewmodel/OpenFolderBadgeManager';
import { UninstallViewModel } from '../viewmodel/uninstall/UninstallViewModel';
import { openFolderVm } from '../viewmodel/OpenFolderViewModel';
import { DragViewModel } from '../viewmodel/drag/DragViewModel';
import { FormManagerDialog } from '@ohos/form';
import { PC_IN_PHONE_LIST } from '@ohos/windowscene';

const TAG = 'OpenFolderAppBubble';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export struct OpenFolderAppBubble {
  @StorageLink('uninstallAppInfo') uninstallAppInfo: AppItemInfo = new AppItemInfo();
  @StorageLink('isDrag') isDrag: boolean = false;
  // 待确认同uninstallAppInfo合并
  @StorageLink('unInstallItemInfo') folderUnInstallItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();

  @Provide itemAppStatus: AppStatus = AppStatus.INSTALLED;
  @Provide downloadProgress: number = 0;
  @Provide isAppInstalled: boolean = true;

  @Prop nameHeight: number = 0;
  @Prop nameWidth: number = 0;
  @Prop nameSize: number = 0;
  @Prop appItemWidth: number = 0;
  @Prop nameLines: number = PresetStyleConstants.DEFAULT_APP_NAME_LINES;
  @Prop mIconNameMargin: number = PresetStyleConstants.DEFAULT_ICON_NAME_GAP;
  @Prop @Watch('onMenuInfoChange') menuInfo: Array<MenuInfo> = [];
  @Prop @Watch('updateAppItemInfo') item: GridLayoutItemInfo = new GridLayoutItemInfo();
  @Prop isSmallFolder: boolean = false;
  @Prop bindFolderId: string = '';
  @Prop mFolderIconRadius: number = CommonConstants.DEFAULT_ICON_RADIUS;

  @State bundleName: string = '';
  @State abilityName: string = '';
  @State moduleName: string = '';
  @State appIconId: string = '';
  @State appLabelId: string = '';
  @State animaterPositionY: number = 0;
  @State isIconShow: boolean = true;
  @State editModeState: EditModeState = editModeManager.getEditModeState();
  @State badgeNumber: number = 0;
  @State isGrayIcon: boolean = false;
  @State isDragStart: boolean = false;
  @State isDragDrop: boolean = false;
  @State translateX: number = 0;
  @State translateY: number = 0;
  @State pageIndex: number = 0;
  @State index: number = -1;
  @State isMenuShow: boolean = false;
  @State showNameState: ShowNameState = editModeManager.getShowNameState();
  @State mIsLongPressHideMask: boolean = false;
  @State dragItemOpacity: number = 1;
  @State mOpenFolderAppMoveVm: OpenFolderAppMoveVm = new OpenFolderAppMoveVm();
  @State iconBadgeVm: AppIconBadgeVm = new AppIconBadgeVm();
  @State appData: AppIconData = new AppIconData();
  isSelect: boolean = false;
  shortCutEnabled: boolean = false;
  private appIconConfig: AppIconConfig = new AppIconConfig();
  private mFolderViewModel: BigFolderViewModel = BigFolderViewModel.getInstance();
  private mFolderMgr: FolderManager = FolderManager.getInstance();
  private dragEventCallback: DragEventCallback = {};
  private itemKey: string = '';
  private clearForm: Function = (): void => {
  };
  private iconEvent: AppIconCommonEvent | null = new AppIconCommonEvent();
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private iconRadius: number = CommonConstants.INVALID_VALUE;
  private appNameVm: AppNameVm = new AppNameVm();
  public nameModifier: AppNameModifier = new AppNameModifier();
  private onShowFolderBadgeAnimation: Function = (): void => this.showFolderBadgeAnimation();
  private onFolderOpenedBadgeAnimation: Function = (): void => this.folderBadgeOnOpenClose();
  private removeNotInstalledApp: Function = (): void => {
  };
  private onFolderOpenedIconRadiusChange: Function =
    (radius: number): void => this.folderOpenedIconRadiusChange(radius);

  private multiSelectListener?: MultiSelectListenerType = undefined;
  private isRemoveAction: boolean = false;
  private mOpenFolderBadgeManager: OpenFolderBadgeManager =
    new OpenFolderBadgeManager(this.iconBadgeVm, this.item);
  // 该图标在对应文件夹折叠态中的偏移参数和缩放大小
  private aniParameters: number[] = [0, 0, 1, 1];

  private openFolderIconNameOpt: number = 1;

  private hasMenuDragStart: boolean = false;

  private appGalleryStatusChangeEventId: string = '';

  // 卸载时，移位动效结束后布局还未更新到最新，延长动效时长200 -> 250(可调)
  private moveIconAnimationDuration = 250;

  /**
   * 是否强制显示应用角标：针对反选进文件夹的应用，在首屏显示时需要显示角标
   */
  private forceShowBadge: boolean = false;

  private uninstallDialogController: CustomDialogController | null = new CustomDialogController({
    builder: UninstallDialog({
      cancel: () => {
        const folderType: number = DeliverUtil.getFolderTypeByFolderId(this.mFolderMgr.getOpenFolderId());
        HiSysEventUtil.reportCancelUninstallSingleApp(this.bundleName, folderType);
      },
      confirm: () => {
        // PC定制逻辑，当前PC独立布局，冗余流程，后期审视删除
        if (DeviceHelper.isPC()) {
          let uninstalledFolderItem: GridLayoutItemInfo = this.mFolderViewModel
            .deleteAppFromOpenFolder(this.uninstallAppInfo as GridLayoutItemInfo);
          this.mFolderViewModel.refreshFolder(uninstalledFolderItem);
        } else {
          this.uninstallDialogConfirm();
        }
      },
      dialogName: FolderCommonUtil.getUninstallDialogName(this.uninstallAppInfo?.appName),
      isFromDesktop: true
    }),
    cancel: () => {
      const folderType: number = DeliverUtil.getFolderTypeByFolderId(this.mFolderMgr.getOpenFolderId());
      HiSysEventUtil.reportCancelUninstallSingleApp(this.bundleName, folderType);
    },
    autoCancel: true,
    showInSubWindow: true,
    alignment: DialogAlignment.Center,
  });

  private uninstallDialogConfirm(): void {
    if (UninstallDialogUtil.getIsNeedReConfirmationApp(this.uninstallAppInfo.bundleName)) {
      this.reConfirmationDialogController?.open();
    } else {
      this.uninstallConfirm();
    }
  }

  /**
   * 二次卸载菜单弹框
   */
  private reConfirmationDialogController: CustomDialogController | null = new CustomDialogController({
    builder: ReConfirmationUninstallDialog({
      confirm: () => { this.uninstallConfirm(); },
      appIndex: this.uninstallAppInfo.appIndex,
      bundleName: this.uninstallAppInfo.bundleName,
      moduleName: this.uninstallAppInfo.moduleName,
      abilityName: this.uninstallAppInfo.abilityName
    }),
    cancel: () => { log.showInfo('cancel app uninstall dialog'); },
    autoCancel: true,
    showInSubWindow: true,
    alignment: DialogAlignment.Center,
  });

  private formManagerDialogController: CustomDialogController | null = new CustomDialogController({
    builder: FormManagerDialog({
      cancel: (callback?: Function): void => {
        // delete all form
        if (callback !== undefined) {
          this.clearForm = callback;
        } else {
          log.showError('FormManagerDialog callback error'); // 维测日志
        }
      },
      confirm: (formCardItem: GridLayoutItemInfo): void => {
        // add form to desktop
        log.showDebug('createCardToDeskTop formCardItem: %{public}s', formCardItem.cardId);
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_FORM_ITEM_ADD, formCardItem);
      },
      bundleName: this.item.bundleName,
      appName: IconResourceManager.getInstance().getAppNameByCache(this.item.appLabelId, this.item.bundleName,
        this.item.moduleName, '', this.item.appIndex),
      appLabelId: this.item.applicationLabelId
    }),
    cancel: this.cancelFormDialog,
    autoCancel: false,
    customStyle: true,
    showInSubWindow: true,
    alignment: DialogAlignment.Center,
  });

  /*
   * 移除菜单弹框，CustomDialogController必须在@Component struct内部定义时赋值才有效
  */
  private removeDialogController: CustomDialogController | null = new CustomDialogController({
    builder: UninstallDialog({
      fromRemoveAction: this.isRemoveAction ? DeleteAction.ACTION_REMOVE : DeleteAction.ACTION_UNINSTALL,
      cancel: () => {},
      confirm: () => {
        let hapAppItems: GridLayoutItemInfo[] =
          LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(this.item.bundleName);
        let findApp: GridLayoutItemInfo | undefined = hapAppItems.find((item: GridLayoutItemInfo) => {
          return item.typeId === CommonConstants.TYPE_APP && item.appIndex === this.item.appIndex
        });
        log.showInfo(`appInstall removeDialogController findApp:${DesktopUtils.desktopItemsToString(findApp)}`);
        //appStatus =0 下载完成，下载完不移除
        if (findApp && findApp.appStatus !== AppStatus.INSTALLED) {
          ContractedFolderCommonViewModel.getInstance().removeItem(this.item, this.mFolderMgr.getOpenFolderId());
        } else {
          log.showWarn('appInstall removeDialogController app has installed');
        }
      },
      dialogName: this.isRemoveAction ? $r('app.string.is_remove', this.item.appName) :
        $r('app.string.isUninstall', this.item.appName),
      dialogContent: this.isRemoveAction ? $r('app.string.remove_content') : $r('app.string.delete_app_dialog_content'),
      isFromDesktop: true
    }),
    cancel: () => { log.showInfo('cancel app uninstall dialog'); },
    autoCancel: true,
    showInSubWindow: true,
    alignment: DialogAlignment.Center,
  });

  private openFolderIconExternCb: AppIconExternCb = {
    getIndexInSwiper: (): number => this.pageIndex,
    dragStartExtend: (event: DragEvent): DragItemInfo => this.dragStart(event),
    dragEndExtend: (event: DragEvent): void => this.dragEnd(event),
    getNotInstalledMenuMap: () => this.getNotStalledMenoInfo(),
    getMenuInfo: (): MenuInfo[] => {
      return this.getMenuInfo();
    },
    onIconClick: (event?: ClickEvent, fingers?: number): void => {
      log.showWarn('onClick icon');
      this.checkClickEvent(event);
    },
    onMenuDragStart: (x: number, y: number) => this.menuDragStart(x, y),
    onMenuDisappear: (isLongPressShow: boolean) => this.onMenuDisappear(isLongPressShow),
    onIconTouch: (event?: TouchEvent) => {
      if (event?.type === CommonConstants.TOUCH_TYPE_DOWN) {
        log.showInfo('create folderApp pixmap start');
        this.desktopContext?.eventHub.emit(EventConstants.EVENT_FOLDER_CLOSE_RENAME_INPUT);
        if (DeliverUtil.isSupportAppType(this.item.bundleName) && DeliverUtil.isSupportDeliver()) {
          SCBSceneSessionManager.getInstance().preloadApp(this.item.bundleName);
        }
        this.isGrayIcon = GrayAppListManager.getInstance().isGrayAppIcon(this.item);
      } else if (event?.type === CommonConstants.TOUCH_TYPE_UP) {
        log.showInfo('touch up start');
      }
    }
  }

  private clearAppIconExternCb(): void {
    this.openFolderIconExternCb.getIndexInSwiper = undefined;
    this.openFolderIconExternCb.dragStartExtend = undefined;
    this.openFolderIconExternCb.getNotInstalledMenuMap = undefined;
    this.openFolderIconExternCb.getMenuInfo = undefined;
    this.openFolderIconExternCb.onIconClick = undefined;
    this.openFolderIconExternCb.onMenuDragStart = undefined;
    this.openFolderIconExternCb.onMenuDisappear = undefined;
    this.openFolderIconExternCb.onIconTouch = undefined;
  }

  /**
   * 初始化展开态图标动效参数
   */
  private initOpenFolderAnimate(): void {
    if (this.aniParameters.length >= StyleConstants.DEFAULT_3) {
      this.appData.transX = this.aniParameters[0];
      this.appData.transY = this.aniParameters[1];
      this.appData.setIconScale(this.aniParameters[2]);
      this.appData.setIconOpacity(this.aniParameters[3] ?? 1, TAG, 'initOpenFolderAnimate');
    }
  }

  private registerMultiSelectListener() {
    this.multiSelectListener = {
      id: multiSelectListenManger.getListenerId(ListenerItemType.OPENFOLDER_APP, this.itemKey),
      onItemDropped: (): void => {
        this.isDragStart = false;
        this.isDragDrop = false;
      },
      onFinish: (): void => {
        if (this.isDragStart) {
          this.isDragStart = false;
        }
        this.isDragDrop = false;
      }
    }
    multiSelectListenManger.register(this.multiSelectListener);
  }

  private folderOpenedIconRadiusChange(radius: number): void {
    this.mFolderIconRadius = radius;
  }

  private unRegisterMultiSelectListener(): void {
    if (this.multiSelectListener) {
      multiSelectListenManger.unregister(this.multiSelectListener);
      this.multiSelectListener = undefined;
    }
  }

  async updateAppItemInfo() {
    this.bundleName = this.item.bundleName;
    this.abilityName = this.item.abilityName;
    this.moduleName = this.item.moduleName ?? '';
    this.appIconId = this.item.appIconId?.toString();
    this.appLabelId = this.item.appLabelId?.toString() ?? '';
    this.badgeNumber = this.item.badgeNumber ?? 0;
    this.iconEvent?.onItemAppStatusChange(this.item.appStatus ?? AppStatus.INSTALLED);
  }

  private uninstallConfirm(): void {
    const folderId: string = this.mFolderMgr.getOpenFolderId();
    if (this.item.isAppLocked) {
      UninstallViewModel.getInstance().uninstallLockedItem('uninstall locked app on openedFolder', folderId, this.item);
    } else {
      UninstallViewModel.getInstance().uninstallItem('uninstall app on openedFolder', folderId, this.item, true);
    }
  }

  private onMenuInfoChange(): void {
    if (this.menuInfo?.length === 0 && !GridLayoutUtil.isAppInstalled(this.item)) {
      this.onAppStatusChange();
    }
  }

  private onFolderItemAccessibilityClick = (): void => {
    log.showInfo(`onFolderItemAccessibilityClick bundleName:${this.item.bundleName}`);
    this.checkClickEvent();
  }

  private dragAppNameAnimate(): void {
    this.dragItemOpacity = 0;
    animateTo({
      delay: 100,
      duration: 300,
      curve: Curve.Linear
    }, () => {
      this.dragItemOpacity = 1;
    });
  }

  aboutToAppear() {
    this.bundleName = this.item.bundleName;
    this.abilityName = this.item.abilityName;
    this.moduleName = this.item.moduleName ?? '';
    this.appIconId = this.item.appIconId?.toString();
    this.appLabelId = this.item.appLabelId?.toString() ?? '';
    this.badgeNumber = this.item.badgeNumber ?? 0;
    let appIndex = this.item.appIndex ?? 0;
    if (this.item.typeId === CommonConstants.TYPE_APP && GridLayoutUtil.isAppInstalled(this.item)) {
      let appName = IconResourceManager.getInstance().getCachedIconNameSync(this.item.bundleName,
        this.item.moduleName, this.item.abilityName, appIndex);
      this.item.appName = CheckEmptyUtils.checkStrIsEmpty(appName) ? this.item.appName : appName;
    }
    if (this.item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      this.item.appName = ResourceManager.getInstance().getCachedAppName(this.appLabelId,
        this.item.bundleName, this.item.moduleName) ?? this.item.appName;
    }
    log.showInfo(`FolderItem aboutToAppear, bundleName: ${this.item.bundleName}, appName: ${this.item.appName} on page ${this.pageIndex} ` +
      `with badge ${this.badgeNumber} appStatus: ${this.item.appStatus}`);
    /*
     * 默认第二页的图标，有角标的时候显示出来，这样翻页的时候不会有动效触发，也能正常显示。
     * 如果第一页也默认显示，在小文件夹打开的时候会闪一个新的角标。
     * 文件夹反选直接显示在第一页，强制显示角标。
     */
    const is4x2Folder: boolean = ArrayUtils.equalsArr(this.mFolderMgr.getOpenedFolder().area, [4, 2]);
    if (this.badgeNumber && (this.pageIndex > 0 || this.forceShowBadge || is4x2Folder)) {
      this.iconBadgeVm.visible = true;
    } else {
      this.iconBadgeVm.visible = false;
    }

    this.itemKey = GridLayoutUtil.generateUniqueKey(this.item);

    openFolderAppBubbleLayout.setIconData(this.item.keyName ?? this.item.bundleName, this.appData);
    this.mOpenFolderAppMoveVm.id = openFolderAppMoveVMManager.generatedItemId(this.item);
    OpenFolderDragHandler.getInstance().judgeTranslateBeforeInit(this.mOpenFolderAppMoveVm);
    openFolderAppMoveVMManager.registerItem(this.mOpenFolderAppMoveVm);
    if (!GridLayoutUtil.isAppInstalled(this.item) && AppStorage.get<string>('device') === CommonConstants.DEFAULT_DEVICE_TYPE) {
      this.getAppInstallStatus();
      this.onAppStatusChange();
      this.isAppInstalled = false;
      this.initEventhubEvent();
    }
    this.desktopContext?.eventHub.on(CommonConstants.DRAG_FOLDER_OPEN_APP_NAME_ANIMATE + this.item?.keyName,
      (): void => {
        this.dragAppNameAnimate();
      });

    this.desktopContext?.eventHub.on(FolderAccessibilityUtils.getFolderItemAccessibilityClickEventName(this.item),
      this.onFolderItemAccessibilityClick);
    const menu: MenuInfoType = {
      appInfo: this.item as AppItemInfo,
      dialog: this.uninstallDialogController,
      formDialog: this.formManagerDialogController
    } as MenuInfoType;
    ContractedFolderCommonViewModel.getInstance().buildAppMenu(menu);
    this.initDragParam();
    this.initDragEvent();

    this.init();
    this.registerMultiSelectListener();
    this.initOpenFolderAnimate();
  }

  private initDragParam(): void {
    // dragItemInfo清空在挤位场景下存在清空较慢情况，如果触发新建时已开始落位动效则代表拖拽已结束
    const multiSelectManager = MultiSelectManager.getInstance();
    if (multiSelectManager.isInMultiSelect && multiSelectManager.isItemSelected(this.item)) {
      this.isDragStart = true;
      this.isDragDrop = true;
    } else {
      let isInDropAnimation: boolean = dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP,
        this.itemKey);
      let dragItemInfo: GridLayoutItemInfo = OpenFolderDragHandler.getInstance().getDragItemInfo();
      this.isDragStart = this.itemKey === GridLayoutUtil.generateUniqueKey(dragItemInfo) && !isInDropAnimation;
      this.isDragDrop = this.isDragStart || isInDropAnimation;
    }
  }

  private initDragEvent(): void {
    this.dragEventCallback = {
      onItemDropStartEvent: () => {
        log.showInfo('drop start, keyName: %{public}s', this.item.keyName);
        this.isDragStart = false;
      },
      onItemDropEndEvent: () => {
        log.showInfo('drop animation end, keyName: %{public}s', this.item.keyName);
        this.isDragDrop = false;
        OpenFolderDragHandler.getInstance().resetTranslateZero('by drop end');
        AppStorage.setOrCreate('dragFolderApp', false);
        AppStorage.setOrCreate('isAddIconHidden', false);
      }
    };
    DragEventManager.getInstance().registerDragEvent(this.dragEventCallback, this.itemKey);

    this.desktopContext?.eventHub.on(DragConstants.EVENT_FOLDER_ITEM_SQUEEZE_RESET, (): void => {
      this.onResetTranslateXY();
    });
  }

  private onResetTranslateXY(): void {
    if (this.translateX !== 0 || this.translateY !== 0) {
      this.translateX = 0;
      this.translateY = 0;
    }
  }

  private init(): void {
    this.appNameVm.modifier.onInit = (instance?: CommonAttribute) => {
      instance?.opacity(this.openFolderIconNameOpt).width(this.nameWidth);
      this.appNameVm.modifier.onInit = undefined;
    };
    this.appIconConfig = this.getAppIconConfig();
    openFolderAppBubbleLayout.setNameData(this.item.keyName ?? this.item.bundleName, this.appNameVm);
    this.desktopContext?.eventHub.on(`${FolderConstants.OPEN_FOLDER_ITEM_BADGE_CHANGE}${this.item.keyName}`,
      this.onShowFolderBadgeAnimation);
    this.desktopContext?.eventHub.on(FolderConstants.OPEN_FOLDER_ICON_RADIUS_CHANGE,
      this.onFolderOpenedIconRadiusChange);
    this.desktopContext?.eventHub.on(`${FolderConstants.OPEN_CLOSE_FOLDER_ITEM_BADGE_CHANGE}${this.item.keyName}`,
      this.onFolderOpenedBadgeAnimation);
  }

  private getAppStatus(): AppStatus {
    let itemAppStatus: AppStatus = this.item.appStatus as AppStatus;
    // 如果是主应用，从缓存中查询最新的状态
    if (this.item.appIndex === CommonConstants.MAIN_APP_INDEX) {
      let hapAppItems: GridLayoutItemInfo[] =
        LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(this.item.bundleName);
      let findApp: GridLayoutItemInfo | undefined = hapAppItems.find((item: GridLayoutItemInfo) => {
        return item.typeId === CommonConstants.TYPE_APP && item.appIndex === CommonConstants.MAIN_APP_INDEX
      });
      if (findApp) {
        itemAppStatus = findApp.appStatus as AppStatus;
      }
    }
    return itemAppStatus;
  }

  private checkClickEvent(event?: ClickEvent): void {
    if (this.editModeState.isInEditMode() && !GridLayoutUtil.isAddIcon(this.item)) {
      //编辑模式屏蔽应用点击事件
      log.showInfo('click app Inactive, because is in editmode');
      const isAccessibilityMode = AppStorage.get<boolean>('isAccessibilityMode') ?? false;
      if (isAccessibilityMode) {
        log.showInfo(`onClick. bundleName = ${this.item.bundleName}, appStatus = ${this.item.appStatus}`);
        const manager = MultiSelectManager.getInstance();
        if (manager.getStatus().isSelectAble() && this.getAppIconConfig().enableMultiSelect) {
          manager.onIconClick(manager.getUniqueId(this.item));
        }
      }
      return;
    }
    if (this.mFolderMgr.isFolderClosing()) {
      // 当前如果正处于打开关闭文件夹动效过程中，点击图标则不会打开应用
      log.showInfo('click app Inactive, because folder opening or closing');
      return;
    }
    // 如果应用正在安装（更新过程中的安装，第一次下载应用安装由于有动效不需要toast），点击应用弹出toast
    if (AppInstallingDataManager.getInstance().isInstalling(this.item.bundleName)) {
      AppInstallingDataManager.getInstance().toastInstalling(this.item.bundleName);
      return;
    }
    if (DeliverUtil.isContainerItem(this.item.intent)) {
      log.showWarn(`onContainerAppIconClick, containerItem is ${JSON.stringify(this.item)}`);
      this.checkContainerAppClickEvent(this.item as AppItemInfo);
      return;
    }
    if (DeliverUtil.needOpendeliverAppAlertDialog(this.item)) {
      let content: string = 'app.string.deliver_app_unavailable_dialog_content';
      this.builddeliverAppAlertDialog(content).open();
      HiSysEventUtil.reportdeliverDialogOpen(this.item.bundleName);
      return;
    }
    let itemAppStatus: AppStatus = this.getAppStatus();
    if (itemAppStatus === AppStatus.INSTALLED || itemAppStatus === undefined) {
      this.onAppClick();
      return;
    } else if ((this.item.appIndex && this.item.appIndex > 0) ||
      this.item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      AppInstallUtils.getInstance().clickTwinApp(this.item.bundleName);
      return;
    }
    if (itemAppStatus === AppStatus.DOWNLOADING || itemAppStatus === AppStatus.UPDATING) {
      //  调用暂停接口
      AppInstallUtils.getInstance().pauseTask(this.item.bundleName);
    } else if (itemAppStatus === AppStatus.PENDING || itemAppStatus === AppStatus.WAIT_FOR_HARMONY) {
      if (PreInstallUtils.checkIsNeedInstallAppByIntent(this.item)) {
        AppInstallUtils.getInstance().requestTask(this.item);
      } else {
        //  调用检查接口
        AppInstallUtils.getInstance().checkTask(this.item as AppItemInfo);
      }
      this.reportFolderAppClick();
    } else if (itemAppStatus === AppStatus.PAUSING || itemAppStatus === AppStatus.WIFI_WAITING) {
      //  调用恢复接口
      AppInstallUtils.getInstance().resumeTask(this.item.bundleName);
    } else if (itemAppStatus === AppStatus.WAITING) {
      AppInstallUtils.getInstance().dealClickPreDownload(this.item);
    }
  }

  /**
   * 根据所点击的应用的类型、是否安装以及是否启动来响应不同的操作
   * @param appItem 点击的应用
   */
  private checkContainerAppClickEvent(appItem: AppItemInfo): void {
    if (!GridLayoutUtil.isAppInstalled(appItem)) {
      let installSource: string = DeliverUtil.getInstallSourceByIntent(appItem.intent);
      if (installSource === DeliverUtil.DELIVER_APPSTORE_PKG) {
        if (DeliverUtil.isdeliverHapExist()) {
          DeliverUtil.startdeliverAutoOhosAbility(appItem.bundleName, appItem.iconResource);
        } else {
          this.alertDialogByMatchContainerHapStatus(appItem);
        }
      } else if (installSource === DeliverUtil.APP_PKG) {
        if (DeliverUtil.isAppExist()) {
          DeliverUtil.startAppAutoOhosAbility(appItem.bundleName, appItem.iconResource);
        } else {
          this.alertDialogByMatchContainerHapStatus(appItem);
        }
      } else {
        AppInstallUtils.getInstance().checkTask(appItem);
        this.reportFolderAppClick();
      }
    } else {
      let isDeliverStart: boolean = DeliverUtil.getDeliverStartStatus() === DeliverUtil.DELIVER_START_FINISHED_CODE;
      if (isDeliverStart || (!isDeliverStart && DeliverUtil.isMatchContainerHapExist(appItem as GridLayoutItemInfo))) {
        this.openDialogOrApplication();
      } else {
        this.alertDialogByMatchContainerHapStatus(appItem);
      }
    }
    return;
  }

  /**
   * 根据点击的应用所对应的克隆应用/应用的状态来响应不同的弹框
   * @param appItem 点击的应用
   */
  private alertDialogByMatchContainerHapStatus(appItem: AppItemInfo): void {
    let isdeliverApp: boolean =
      DeliverUtil.getInstallSourceByIntent(appItem.intent) === DeliverUtil.DELIVER_APPSTORE_PKG;
    let result: GridLayoutItemInfo[];
    if (isdeliverApp) {
      result =
        LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(DeliverUtil.DELIVER_APP_BUNDLE_NAME_REAL);
    } else {
      result = LaunchLayoutCacheManager.getInstance()
        .getAllSameBundleNameAppItem(DeliverUtil.APP_APP_BUNDLE_NAME_REAL);
    }
    if (CheckEmptyUtils.isEmptyArr(result)) {
      let content: string = 'app.string.deliver_app_unavailable_dialog_content';
      this.builddeliverAppAlertDialog(content).open();
      HiSysEventUtil.reportdeliverDialogOpen(appItem?.bundleName);
      return;
    }
    let containerItem: GridLayoutItemInfo = result[0];
    let downloadStatusInfo: DownloadStatusInfo | undefined =
      AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo(DeliverUtil.DELIVER_APP_BUNDLE_NAME_REAL);
    let containerItemStatus: number =
      downloadStatusInfo ? downloadStatusInfo.status : containerItem.appStatus as number;
    if (containerItemStatus === AppStatus.DOWNLOADING || containerItemStatus === AppStatus.INSTALLING ||
      containerItemStatus === AppStatus.INSTALL_WAITING) {
      let content: string = 'app.string.deliver_app_installing_dialog_content';
      this.builddeliverAppAlertDialog(content).open();
      HiSysEventUtil.reportdeliverDialogOpen(appItem?.bundleName);
      return;
    } else if (containerItemStatus === AppStatus.WAITING || containerItemStatus === AppStatus.WIFI_WAITING ||
      containerItemStatus === AppStatus.PENDING) {
      let content: string = 'app.string.deliver_app_wait_download_dialog_content';
      this.builddeliverAppChooseDialog(content, containerItem, containerItemStatus, DeliverUtil.DIALOG_TYPE_WAIT_DOWNLOAD)
        .open();
      HiSysEventUtil.reportdeliverDialogOpen(appItem?.bundleName);
      return;
    } else if (containerItemStatus === AppStatus.PAUSING) {
      let content: string = 'app.string.deliver_app_pause_download_dialog_content';
      this.builddeliverAppChooseDialog(content, containerItem, containerItemStatus, DeliverUtil.DIALOG_TYPE_PAUSE_DOWNLOAD)
        .open();
      HiSysEventUtil.reportdeliverDialogOpen(appItem?.bundleName);
      return;
    }
    return;
  }

  private onAppClick(): void {
    if (this.isDrag) {
      log.showInfo('checkClickEvent isDrag, skip onAppClick');
      return;
    }
    log.showInfo('OpenFolderAppItem onClick');
    this.setStartAppInfo();
    this.reportFolderAppClick(); // 文件夹打点 - 点击文件夹内app
    if (this.item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      ShortcutViewModel.getInstance().onShortcutAppClick(this.item as Object as AppItemInfo);
    } else {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_OPEN_APPLICATION, this.item);
    }
  }

  /**
   * 文件夹打点上报 - 点击文件夹内app
   */
  private reportFolderAppClick(): void {
    const screenPageCount: number = FolderLayoutCacheManager.getInstance().selectPageCount();
    const folderItem: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    if (folderItem) {
      let folderPositionInDesktop: string = `SCREENCOUNT: ${screenPageCount}, SCREENINDEX: ${folderItem.page}` +
        ` CELLX: ${folderItem.column}, CELLY: ${folderItem.row}, isInDock:false`;
      const appInFolderPosition: number[] = openFolderVm.calculateArea(folderItem.layoutInfo, this.item);
      if (appInFolderPosition && appInFolderPosition.length >= 3) {
        let iconPositionInFolder: string =
          `SCREENCOUNT: ${folderItem.layoutInfo?.length}, SCREENINDEX:${appInFolderPosition[2]},` +
            ` CELLX: ${appInFolderPosition[1]}, CELLY: ${appInFolderPosition[0]}, isInDock: false`;
        const iconPositionInDesktop = '-1';
        let itemAppType: number = DeliverUtil.getAppType(this.item)
        let containerType: string = ''
        if (ArrayUtils.equalsArr(folderItem.area, [1, 1])) {
          containerType = 'folderIcon';
        } else {
          containerType = 'cardFolderOpen';
        }
        // 未鸿蒙化应用增加打点（点亮字段）或者置灰应用增加打点
        if (itemAppType === DeliverUtil.APPTYPE_COMMON || itemAppType === DeliverUtil.APPTYPE_TYPE_GRAY) {
          HiSysEventUtil.reportClickAppIcon(this.item.bundleName, containerType, '-1', folderPositionInDesktop,
            iconPositionInFolder, 'true', 'false', folderItem.folderId, itemAppType, this.item.appIndex, '', '');
        } else if (itemAppType === DeliverUtil.APPTYPE_TYPE_NOTHARMONY &&
          this.item?.appStatus === AppStatus.WAIT_FOR_HARMONY) {
          if (CommonUtils.jsonStrToMap(this.item.intent).get(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE) !== 1) {
            HiSysEventUtil.reportClickAppIcon(this.item.bundleName, containerType, '-1', folderPositionInDesktop,
              iconPositionInFolder, 'true', 'false', folderItem.folderId, itemAppType, this.item.appIndex, 'false',
              '0');
          } else {
            let intentMap: Map<string, Object> = CommonUtils.jsonStrToMap(this.item?.intent);
            let lightData: number = intentMap.get('lightData') as number;
            let timeSpan: number;
            if (lightData) {
              timeSpan = new Date().getTime() - lightData;
            } else {
              timeSpan = -1;
            }
            HiSysEventUtil.reportClickAppIcon(this.item.bundleName, containerType, '-1', folderPositionInDesktop,
              iconPositionInFolder, 'true', 'false', folderItem.folderId, itemAppType, this.item.appIndex, 'true',
              timeSpan.toString());
          }
        } else {
          HiSysEventUtil.reportClickAppIcon(this.item.bundleName, containerType, '-1', folderPositionInDesktop,
            iconPositionInFolder, 'true', 'false', folderItem.folderId, itemAppType, this.item.appIndex, '', '');
        }
        if (this.item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
          HiSysEventUtil.reportClickShortcut(this.item.bundleName, this.item.shortcutId, containerType,
            iconPositionInDesktop, folderPositionInDesktop, iconPositionInFolder,
            folderItem?.folderId as string);
        }
      }
    }
  }

  private setStartAppInfo() {
    if (this.item.badgeNumber as number > 0) {
      CustomBadgeManager.getInstance().setAppBadgeValue(this.item, this.item.badgeNumber);
    }
    let startType: StartType = StartType.FOLDER;
    if (this.item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      startType = StartType.SHORTCUT_APP;
    }
    CloseAppManager.getInstance().setStartAppType(startType, undefined, undefined, this.item.shortcutId);
  }

  private cancelFormDialog() {
    log.showDebug('form manager cancel dialog');
    this.clearForm();
  }

  private dragStart(event: DragEvent): DragItemInfo {
    const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    AppStorage.setOrCreate('dragFolderApp', true);
    AppStorage.setOrCreate('isAddIconHidden', true);
    this.isDrag = true;
    ContextMenu.close();
    let itemType = openFolderData.isInDock ? CommonConstants.DRAG_FROM_FOLDER_IN_DOCK :
    CommonConstants.DRAG_FROM_FOLDER;
    let dragItem: GridLayoutItemInfo = new GridLayoutItemInfo();
    ObjectCopyUtil.deepClone(this.item, dragItem);
    let folderDrag: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();
    folderDrag.dragStart(dragItem, event, itemType);

    this.isDragStart = true;
    this.isDragDrop = true;
    this.mFolderMgr.setDragItemFolder(undefined);
    log.showInfo('dragStart dragItem: %{public}s', dragItem?.appName);

    dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, this.itemKey)
    ?.setWidth(EditModeUtils.convertWithDesktopScale(this.appItemWidth))
      .setHeight(EditModeUtils.convertWithDesktopScale(this.appItemWidth))
      .setRadius(EditModeUtils.convertWithDesktopScale(this.mFolderIconRadius));
    const dragItemFolderPosition: number[] = openFolderVm.calculateArea(openFolderData?.layoutInfo, this.item);
    let dragItemInfo: DragItemInfo = {
      pixelMap: dragSnapshotHelper.getSnapshot(SnapshotType.DRAG, this.itemKey),
      extraInfo: new DragExtraInfo(DragDataType.APP).setRadius(CommonConstants.DEFAULT_ICON_RADIUS).toString(),
    };
    const startInfo: DragItemFromFolderStartInfo = {
      page: this.item.page,
      row: this.item.row,
      column: this.item.column,
      folderId: openFolderData.folderId,
      bundleName: this.item.bundleName,
      dragItemFolderPosition: dragItemFolderPosition
    }
    this.mFolderViewModel.setDragFromFolderStartInfo(startInfo);
    FolderManager.getInstance().setDragLeaveFolderId(FolderCommonConstants.INVALID_FOLDER_ID);
    return dragItemInfo;
  }

  private dragEnd(event: DragEvent): void {
    const folderId: string = this.mFolderMgr.getDragLeaveFolderId();
    if (folderId !== FolderCommonConstants.INVALID_FOLDER_ID && DragViewModel.getInstance().getDragLeaveItemHasDeal()) {
      ContractedFolderCommonViewModel.getInstance()
        .drop('folder app back', folderId, FolderDropType.DROP_BACK, DragViewModelUtil.getDragParams([this.item]));
    }
    this.mFolderMgr.setDragItemFolder(undefined);
    DragViewModel.getInstance().setDragLeaveItemHasDeal(true);
  }

  private buildNotInstalledAppMenuInFolder(gridLayoutInfo: GridLayoutItemInfo): Map<AppStatus, MenuInfo[]> {
    let removeInfo: MenuInfo = new MenuInfo();
    let bundleName: string = gridLayoutInfo.bundleName;
    let appIndex: number = gridLayoutInfo.appIndex ?? 0;
    let notInstalledMenuMap: Map<AppStatus, MenuInfo[]> = new Map();
    if (!lockLayoutManager.isLockLayout()) {
      removeInfo.menuType = CommonConstants.MENU_TYPE_FIXED;
      this.isRemoveAction = gridLayoutInfo.appStatus !== AppStatus.WAIT_FOR_HARMONY;
      if (!this.isRemoveAction) {
        removeInfo.menuImgSrc = '/common/pics/ic_public_delete.svg';
        removeInfo.menuText = $r('app.string.uninstall');
        bundleName = CommonUtils.jsonStrToMap(gridLayoutInfo.intent).get('requestBundleName') as string ?? bundleName;
      } else {
        removeInfo.menuText = $r('app.string.delete_app');
        removeInfo.menuImgSrc = '/common/pics/ic_public_remove.svg';
      }
      removeInfo.onMenuClick = (): void => {
        // 长按移除打点,未鸿蒙化应用走卸载打点
        if (DeviceHelper.isPhoneOrPad()) {
          const openFolderId: string = this.mFolderMgr.getOpenFolderId();
          let folderType: number = DeliverUtil.getFolderTypeByFolderId(openFolderId);
          if (this.isRemoveAction) {
            HiSysEventUtil.reportClickDeleteAppDialog(bundleName, folderType);
          } else {
            const isCardFolder: boolean = GridLayoutUtil.isBigFolder(this.mFolderMgr.getOpenedFolder());
            HiSysEventUtil.reportOpenUninstallAppDialog(bundleName, folderType, isCardFolder);
          }
        }

        // 菜单消失后再执行移除逻辑,避免菜单预览图动效残影
        this.removeNotInstalledApp = (): void => {
          this.desktopContext?.eventHub.off(CommonConstants.EVENTHUB_APP_MENU_DISAPPEAR,
            this.removeNotInstalledApp);
          this.removeMenuClick(bundleName);
        }
        this.desktopContext?.eventHub.on(CommonConstants.EVENTHUB_APP_MENU_DISAPPEAR,
          this.removeNotInstalledApp);
      }
      notInstalledMenuMap.set(AppStatus.PENDING, [removeInfo]);
      notInstalledMenuMap.set(AppStatus.WAIT_FOR_HARMONY, [removeInfo]);
      notInstalledMenuMap.set(AppStatus.WAITING, [removeInfo]);
      notInstalledMenuMap.set(AppStatus.DOWNLOADING, [removeInfo]);
      notInstalledMenuMap.set(AppStatus.UPDATING, [removeInfo]);
      notInstalledMenuMap.set(AppStatus.WIFI_WAITING, [removeInfo]);
      notInstalledMenuMap.set(AppStatus.PAUSING, [removeInfo]);
      notInstalledMenuMap.set(AppStatus.INSTALL_WAITING, []);
      notInstalledMenuMap.set(AppStatus.INSTALLING, []);
    }
    return notInstalledMenuMap;
  }

  private removeMenuClick(bundleName: string): void {
    if (DeviceHelper.isPC()) {
      let uninstalledFolderItem: GridLayoutItemInfo =
        this.mFolderViewModel.deleteAppFromOpenFolder(this.uninstallAppInfo as GridLayoutItemInfo);
      this.mFolderViewModel.refreshFolder(uninstalledFolderItem);
    } else {
      // 取消更新逻辑，如果appStatus = UPDATING，或者从BMS中查询到该应用，则取消更新
      let apps = launcherAbilityManager.getLauncherAbilityInfoByBundleName(bundleName);
      if (this.item.typeId !== CommonConstants.TYPE_SHORTCUT_ICON &&
        this.item.appIndex === CommonConstants.MAIN_APP_INDEX &&
        (this.item.appStatus === AppStatus.UPDATING || apps.length > 0)) {
        AppInstallUtils.getInstance().cancelTask(bundleName);
        this.isAppInstalled = true;
        this.itemAppStatus = AppStatus.INSTALLED;
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
        return;
      }
      if (this.item.callerName === CommonConstants.SOURCE_CLONE ||
        this.item.callerName === CommonConstants.SOURCE_UPGRADE) {
        let moveItemData: AppItemInfo = new AppItemInfo();
        moveItemData.iconResource = this.item.iconResource;
        AppStorage.setOrCreate('uninstallAppInfo', moveItemData);
        this.removeDialogController?.open();
      } else {
        ContractedFolderCommonViewModel.getInstance().removeItem(this.item, this.mFolderMgr.getOpenFolderId());
      }
    }
  }

  private removeShortCut(): void {
    this.desktopContext?.eventHub.on(CommonConstants.EVENTHUB_APP_MENU_DISAPPEAR,
      this.removeShortCutCallback);
  }

  // 删除快捷方式后，待菜单关闭后再执行删除快捷方式逻辑，避免菜单节点残留桌面问题
  private removeShortCutCallback = (): void => {
    this.desktopContext?.eventHub.off(CommonConstants.EVENTHUB_APP_MENU_DISAPPEAR,
      this.removeShortCutCallback);
    ContractedFolderCommonViewModel.getInstance().removeItem(this.item, this.mFolderMgr.getOpenFolderId());
  }

  private updateIconImage(): string | image.PixelMap {
    if (this.item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      return ResourceManager.getInstance().getCachedAppIcon(this.item.appIconId,
        this.item.bundleName, this.item.moduleName as string);
    } else {
      return IconResourceManager.getInstance().getCachedCombIconSync(this.item.bundleName,
        this.item.moduleName as string, this.item.abilityName);
    }
  }

  private getMenuInfo(): MenuInfo[] {
    DeliverUtil.refreshContainerAppUninstallStatus(this.item);
    const menu: MenuInfoType = {
      appInfo: this.item as AppItemInfo,
      dialog: this.uninstallDialogController,
      formDialog: this.formManagerDialogController,
      openClick: (): void => this.setStartAppInfo(),
      removeShortcut: () => this.removeShortCut()
    } as MenuInfoType;
    return ContractedFolderCommonViewModel.getInstance().buildAppMenu(menu);
  }

  private getNotStalledMenoInfo(): Map<AppStatus, MenuInfo[]> {
    return this.buildNotInstalledAppMenuInFolder(this.item);
  }

  private initEventhubEvent(): void {
    if (this.item === undefined) {
      log.showError('initEventhubEvent data error');
      return;
    }

    if (!GridLayoutUtil.isAppInstalled(this.item) && this.item.bundleName) {
      this.appGalleryStatusChangeEventId = `appGalleryStatusChange${this.item.bundleName}${this.item.appIndex}folder`;
      this.desktopContext?.eventHub.off(this.appGalleryStatusChangeEventId);
      this.desktopContext?.eventHub.on(this.appGalleryStatusChangeEventId, (eventInfo: AppGalleryEventInfo): void =>
      this.appGalleryStatusChangeEvent(eventInfo));
      log.showInfo(`onEventhubAppDownloadStatusChangedEvent for OpenFolderAppBubble
          ${this.appGalleryStatusChangeEventId}`);
    }
  }

  aboutToDisappear() {
    log.showInfo(`FolderItem aboutToDisappear: ${this.item.bundleName}`);
    if (!CheckEmptyUtils.isEmpty(this.appGalleryStatusChangeEventId)) {
      this.desktopContext?.eventHub.off(this.appGalleryStatusChangeEventId);
    }
    this.desktopContext?.eventHub.off(CommonConstants.DRAG_FOLDER_OPEN_APP_NAME_ANIMATE + this.item?.keyName);
    this.desktopContext?.eventHub.off(CommonConstants.EVENTHUB_APP_MENU_DISAPPEAR, this.removeNotInstalledApp);
    this.desktopContext?.eventHub.off(DragConstants.EVENT_FOLDER_ITEM_SQUEEZE_RESET);
    DragEventManager.getInstance().unRegisterDragEvent(this.dragEventCallback, this.itemKey);
    this.desktopContext?.eventHub.off(CommonConstants.EVENTHUB_APP_MENU_DISAPPEAR,
      this.removeShortCutCallback);
    this.desktopContext?.eventHub.off(FolderAccessibilityUtils.getFolderItemAccessibilityClickEventName(this.item),
      this.onFolderItemAccessibilityClick);
    this.desktopContext?.eventHub.off(`${FolderConstants.OPEN_FOLDER_ITEM_BADGE_CHANGE}${this.item.keyName}`,
      this.onShowFolderBadgeAnimation);
    this.desktopContext?.eventHub.off(`${FolderConstants.OPEN_CLOSE_FOLDER_ITEM_BADGE_CHANGE}${this.item.keyName}`,
      this.onFolderOpenedBadgeAnimation);
    this.desktopContext?.eventHub.off(FolderConstants.OPEN_FOLDER_ICON_RADIUS_CHANGE,
      this.onFolderOpenedIconRadiusChange);
    openFolderAppMoveVMManager.unregisterItem(this.mOpenFolderAppMoveVm);
    this.unRegisterMultiSelectListener();
    this.clear();
  }

  private clearIconEvent(): void {
    this.iconEvent?.destroy()
  }

  private clear(): void {
    this.clearIconEvent();
    this.clearAppIconExternCb();
    this.dragEventCallback = {};
    this.removeShortCutCallback = () => {};
    this.onFolderItemAccessibilityClick = () => {};
    this.onShowFolderBadgeAnimation = () => {};
    this.onFolderOpenedBadgeAnimation = () => {};
    this.onFolderOpenedIconRadiusChange = (radius: number) => {};
    this.uninstallDialogController = null;
    this.formManagerDialogController = null;
    this.removeDialogController = null;
    this.reConfirmationDialogController = null;
    this.openFolderIconExternCb = {};
    this.desktopContext = undefined;
    this.clearForm = () => {};
    this.removeNotInstalledApp = () => {};
    this.iconEvent = null;
  }

  private appGalleryStatusChangeEvent(eventInfo: AppGalleryEventInfo): void {
    switch (eventInfo.eventType) {
      case DownloadStatusChangeEvent.DOWNLOAD_STATUS_CHANGE:
        this.onEventhubAppDownloadStatusChangedEvent(eventInfo);
        break;
      case DownloadingProgressChangeEvent.DOWNLOAD_PROGRESS_CHANGE:
        this.onEventhubAppDownloadProgressChangedEvent(eventInfo);
        break;
      case InstallStatusChangeEvent.INSTALL_STATUS_CHANGE:
        this.onEventhubAppInstallStatusChangedEvent();
        break;
    }
  }

  private onEventhubAppDownloadProgressChangedEvent(eventInfo: AppGalleryEventInfo): void {
    if (eventInfo.totalSize && eventInfo.downloadedSize) {
      let totalSize: number = eventInfo.totalSize;
      let downloadedSize: number = eventInfo.downloadedSize;
      this.downloadProgress = downloadedSize / totalSize;
      this.itemAppStatus = AppStatus.DOWNLOADING;
      log.showInfo(`onEventhubAppDownloadProgressChangedEvent: ${this.downloadProgress}`)
    }
  }

  private onEventhubAppInstallStatusChangedEvent(): void {
    this.isAppInstalled = true;
    this.itemAppStatus = AppStatus.INSTALLED;
    openFolderVm.updateOpenFolderAppStatus(this.item.bundleName, AppStatus.INSTALLED);
  }

  private onEventhubAppDownloadStatusChangedEvent(eventInfo: AppGalleryEventInfo): void {
    this.itemAppStatus = eventInfo.status as AppStatus;
  }

  private getAppInstallStatus(): void {
    if (!GridLayoutUtil.isAppInstalled(this.item)) {
      let downloadStatusInfo: DownloadStatusInfo | undefined =
        AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo(this.bundleName);
      // 如果缓存中存在，那么肯定缓存中的状态是最新的，否则可以使用数据库中的了
      if (downloadStatusInfo && !this.item.appIndex) {
        log.showInfo(`getAppInstallStatus find downloadStatusInfo: ${downloadStatusInfo.status}`)
        this.itemAppStatus = downloadStatusInfo.status;
        switch (this.itemAppStatus) {
          case AppStatus.PENDING:
          case AppStatus.WAIT_FOR_HARMONY:
            this.isAppInstalled = false;
            this.downloadProgress = 0;
            break;
          case AppStatus.WAITING:
          case AppStatus.WIFI_WAITING:
          case AppStatus.DOWNLOADING:
          case AppStatus.PAUSING:
            this.isAppInstalled = false;
            let appDownloadInfo: AppDownloadInfo | undefined =
              AppGalleryDownloadManager.getInstance().getDownloadProgressInfo(this.bundleName);
            if (appDownloadInfo) {
              this.downloadProgress = appDownloadInfo.downloadedSize / appDownloadInfo.totalSize;
              log.showInfo(`getAppInstallStatus find appDownloadInfo: ${this.downloadProgress}`)
            } else {
              this.downloadProgress = this.item.downloadProgress as number;
            }
            break;
          case AppStatus.INSTALL_WAITING:
          case AppStatus.INSTALLING:
            this.isAppInstalled = false;
            this.downloadProgress = (CommonConstants.MAX_DOWNLOAD_VALUE - 1) /
            CommonConstants.MAX_DOWNLOAD_VALUE as number;
        }
      } else {
        this.itemAppStatus = this.item.appStatus as AppStatus;
        this.isAppInstalled = false;
        this.downloadProgress = this.item.downloadProgress as number;
      }
    } else {
      this.isAppInstalled = true;
      this.itemAppStatus = AppStatus.INSTALLED;
    }
  }

  private onAppStatusChange(): void {
    log.showInfo(`onAppStatusChange change ${this.itemAppStatus}`)
    if (!GridLayoutUtil.isAppInstalled(this.item) && !this.isMenuShow) {
      let notInstalledMenuMap = this.getNotStalledMenoInfo();
      let menuInfo: MenuInfo[] = notInstalledMenuMap.get(this.itemAppStatus) ?? [];
      if (this.menuInfo?.length === 0 && menuInfo.length === 0) {
        log.showInfo('onAppStatusChange menuInfo all empty by map');
        return;
      }
      this.menuInfo = menuInfo;
    } else if (this.itemAppStatus === AppStatus.INSTALLED && !this.isMenuShow) {
      if (this.getMenuInfo && !this.isMenuShow) {
        let menuInfo: MenuInfo[] = this.getMenuInfo();
        if (this.menuInfo?.length === 0 && menuInfo.length === 0) {
          log.showInfo('onAppStatusChange menuInfo all empty by function data');
          return;
        }
        this.menuInfo = menuInfo;
      }
    }
    //app更新和下载时，使用缓存角标数量
    if (this.itemAppStatus === AppStatus.UPDATING || this.itemAppStatus === AppStatus.DOWNLOADING) {
      //badgeNumber为0或者undefined情况更新数据
      if (!(this.iconBadgeVm.badgeNumber > 0)) {
        let bgNumber = CustomBadgeManager.getInstance().getAppBadgeValue({
          bundleName: this.item.bundleName,
          appIndex: this.item.appIndex
        });
        this.iconBadgeVm.badgeNumber = bgNumber;
        this.badgeNumber = bgNumber;
        log.showInfo(`onAppStatusChange DOWNLOADING bundleName ${this.bundleName} badgeNumber ${this.badgeNumber}`);
      }
    }
  }

  showFolderBadgeAnimation() {
    this.mOpenFolderBadgeManager.showFolderBadgeAnimation();
    if (this.item.appIndex || DeliverUtil.isdeliverApp(this.item.intent) ||
      PC_IN_PHONE_LIST.includes(this.item.bundleName) || NotHarmonyUtil.isWaitingDownloadApp(this.item)) {
      this.mOpenFolderBadgeManager.showFolderCloneBadgeAnimation();
    }
  }

  folderBadgeOnOpenClose() {
    this.mOpenFolderBadgeManager.badgeChangeOnOpenClose();
  }

  private builddeliverAppDialog(hapBundleName: string | undefined,
    appName?: string): CustomDialogController {
    let deliverAppDialog = new CustomDialogController({
      builder: AlertDialog({
        primaryTitle: $r('app.string.deliver_app_dialog_title'),
        content: $r('app.string.deliver_app_dialog_text', appName),
        primaryButton: DeliverDialogUtil.createDialogPrimaryButton(this.item.bundleName,
          $r('app.string.deliver_app_dialog_cancel'), () => {
            HiSysEventUtil.reportdeliverDialogOperation(this.item.bundleName, DeliverUtil.DIALOG_TYPE_NEW_VERSION,
              DeliverUtil.CLICK_IGNORE)
            log.showInfo('deliver_app_dialog_title cancel');
            localEventManager.sendLocalEventSticky(EventConstants.EVENT_OPEN_APPLICATION, this.item);
            deliverAppDialog?.close();
          }),
        secondaryButton: {
          value: $r('app.string.deliver_app_dialog_confirm'),
          action: () => {
            HiSysEventUtil.reportdeliverDialogOperation(this.item.bundleName, DeliverUtil.DIALOG_TYPE_NEW_VERSION,
              DeliverUtil.CLICK_UPDATE)
            log.showInfo('deliver_app_dialog_title confirm');
            DeliverUtil.leavingLakeStartAppGalleryDetail(hapBundleName, this.item.bundleName);
            deliverAppDialog?.close();
          }
        },
      }),
      cancel: () => {
        HiSysEventUtil.reportdeliverDialogOperation(this.item.bundleName, DeliverUtil.DIALOG_TYPE_NEW_VERSION,
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
    hapBundleName?: string): CustomDialogController {
    let hapAppName: string = GridLayoutUtil.getdeliverAppName(hapBundleName);
    let dialogConfig: DialogConfig = DeliverUtil.getStringByDialogType(installedDialogType);
    let uninstalldeliverAppDialog: CustomDialogController = new CustomDialogController({
      builder: AlertDialog({
        primaryTitle: $r('app.string.uninstall_deliver_app_dialog_title'),
        content: $r(dialogConfig.content, hapAppName),
        primaryButton: DeliverDialogUtil.createUninstallDialogPrimaryButton(installedDialogType,
          $r(dialogConfig.primaryButton), () => {
            HiSysEventUtil.reportdeliverDialogOperation(this.item?.bundleName, DeliverUtil.DIALOG_TYPE_NEXT_VERSION,
              DeliverUtil.CLICK_IGNORE);
            log.showInfo('uninstalldeliverAppDialog cancel');
            localEventManager.sendLocalEventSticky(EventConstants.EVENT_OPEN_APPLICATION, this.item);
            uninstalldeliverAppDialog?.close();
          }),
        secondaryButton: {
          value: $r(dialogConfig.secondaryButton),
          fontColor: $r(dialogConfig.fontColor),
          action: () => {
            if (installedDialogType === InstalledDialogType.OPEN) {
              log.showInfo('uninstalldeliverAppDialog open');
              HiSysEventUtil.reportdeliverDialogOperation(this.item?.bundleName, DeliverUtil.DIALOG_TYPE_NEXT_VERSION,
                DeliverUtil.CLICK_OPEN_NEXT);
              let itemList: GridLayoutItemInfo[] =
                LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(hapBundleName);
              if (!CheckEmptyUtils.isEmptyArr(itemList)) {
                StartAbilityUtil.startAbilityByName(itemList[0].abilityName, itemList[0].bundleName,
                  itemList[0].moduleName);
              }
              uninstalldeliverAppDialog?.close();
            } else {
              HiSysEventUtil.reportdeliverDialogOperation(this.item?.bundleName, DeliverUtil.DIALOG_TYPE_UNINSTALL,
                DeliverUtil.CLICK_UNINSTALL);
              log.showInfo('uninstalldeliverAppDialog uninstall');
              uninstalldeliverAppDialog?.close();
              AppStorage.setOrCreate('uninstallAppInfo', this.item);
              AppStorage.setOrCreate('showUninstallDialog', true);
              this.uninstallDialogController?.open();
            }
          }
        },
      }),
      cancel: () => {
        HiSysEventUtil.reportdeliverDialogOperation(this.item.bundleName, DeliverUtil.DIALOG_TYPE_NEXT_VERSION,
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

  private builddeliverAppAlertDialog(content: string): CustomDialogController {
    let deliverAppAlertDialog: CustomDialogController = new CustomDialogController({
      builder: AlertDialog({
        primaryTitle: $r('app.string.deliver_app_unavailable_dialog_title'),
        content: $r(content, DeliverUtil.getContainerFolderNameForDialog(this.item)),
        primaryButton: {
          value: $r('app.string.deliver_app_unavailable_dialog_know'),
          fontColor: $r('sys.color.ohos_id_color_text_primary_activated'),
          action: () => {
            HiSysEventUtil.reportdeliverDialogOperation(this.item.bundleName, DeliverUtil.DIALOG_TYPE_UNAVAILABLE,
              DeliverUtil.CLICK_KNOW)
            log.showInfo('deliverAppAlertDialog know');
            deliverAppAlertDialog?.close();
          },
        },
      }),
      cancel: () => {
        HiSysEventUtil.reportdeliverDialogOperation(this.item.bundleName, DeliverUtil.DIALOG_TYPE_UNAVAILABLE,
          DeliverUtil.CLICK_BLANK_AREA)
        log.showInfo('deliverAppAlertDialog cancel');
        deliverAppAlertDialog?.close();
      },
      autoCancel: true,
      customStyle: false,
      alignment: DialogAlignment.Center,
    });
    return deliverAppAlertDialog;
  }

  private builddeliverAppChooseDialog(content: string, containerItem: GridLayoutItemInfo,
    containerItemStatus: number, dialogType?: number): CustomDialogController {
    let deliverAppAlertDialog: CustomDialogController = new CustomDialogController({
      builder: AlertDialog({
        primaryTitle: $r('app.string.deliver_app_unavailable_dialog_title'),
        content: $r(content, DeliverUtil.getContainerFolderNameForDialog(this.item)),
        primaryButton: {
          value: $r('app.string.cancel'),
          fontColor: $r('sys.color.ohos_id_color_text_primary_activated'),
          action: () => {
            HiSysEventUtil.reportdeliverDialogOperation(this.item?.bundleName,
              dialogType ?? DeliverUtil.DIALOG_TYPE_UNAVAILABLE, DeliverUtil.CLICK_CANCEL);
            log.showInfo('deliverAppChooseDialog cancel');
            deliverAppAlertDialog?.close();
          },
        },
        secondaryButton: {
          value: $r('app.string.confirm_dialog'),
          fontColor: $r('sys.color.ohos_id_color_warning'),
          action: () => {
            HiSysEventUtil.reportdeliverDialogOperation(this.item?.bundleName,
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
        HiSysEventUtil.reportdeliverDialogOperation(this.item?.bundleName,
          dialogType ?? DeliverUtil.DIALOG_TYPE_UNAVAILABLE, DeliverUtil.CLICK_CONFIRM);
        log.showInfo('deliverAppChooseDialog cancel');
        deliverAppAlertDialog?.close();
      },
      autoCancel: true,
      customStyle: false,
      alignment: DialogAlignment.Center,
    });
    return deliverAppAlertDialog;
  }

  private openDialogOrApplication(event?: ClickEvent): void {
    let mappingManager = AppToHapMappingManager.getInstance();
    let hapBundleName: string = mappingManager.getMapping().get(this.item.bundleName) as string;
    switch (mappingManager.shouldOpenDialog(this.item.bundleName)) {
      case deliverDialogType.NOT_EXIST_MAPPING_NEXT_VERSION:
        this.onAppClick();
        break;
      case deliverDialogType.NEXT_VERSION_NOT_INSTALLED:
        GridLayoutUtil.checkCurrentItemAppName(this.item);
        let showAppName: string = IconResourceManager.getInstance()
          .getAppNameByCache(this.item.appLabelId, this.item.bundleName, this.item.moduleName, '', this.item.appIndex);
        if (CheckEmptyUtils.isEmpty(showAppName)) {
          showAppName = this.item.appName ?? '';
        }
        this.builddeliverAppDialog(hapBundleName, showAppName).open();
        HiSysEventUtil.reportdeliverDialogOpen(this.item.bundleName);
        break;
      case deliverDialogType.NEXT_VERSION_INSTALLED:
        GridLayoutUtil.checkCurrentItemAppName(this.item);
        DeliverUtil.refreshContainerAppUninstallStatus(this.item);
        let installedDialogType: InstalledDialogType = mappingManager.getInstalledDialogType(this.item.bundleName);
        this.buildUninstalldeliverAppDialog(installedDialogType, hapBundleName).open();
        HiSysEventUtil.reportdeliverDialogOpen(this.item.bundleName);
        break;
      default :
        log.showWarn('openDialogOrApplication type error');
    }
  }

  @Builder
  FolderAppPixmapCreater() {
    if (!GridLayoutUtil.isAppInstalled(this.item)) {
      if (this.item.iconResource) {
        Image(this.item.iconResource)
          .width(EditModeUtils.convertWithDesktopScale(this.appItemWidth))
          .height(EditModeUtils.convertWithDesktopScale(this.appItemWidth))
          .sourceSize({
            width: StyleConstants.APP_ICON_SOURCE_SIZE,
            height: StyleConstants.APP_ICON_SOURCE_SIZE
          })
          .borderRadius(EditModeUtils.convertWithDesktopScale(this.mFolderIconRadius))
          .syncLoad(GridLayoutUtil.isImageSyncLoad(this.item.iconResource))
          .interpolation(ImageInterpolation.Medium)
          .autoResize(false)
      }
    } else {
      Image(this.updateIconImage())
        .draggable(false)
        .width(EditModeUtils.convertWithDesktopScale(this.appItemWidth))
        .height(EditModeUtils.convertWithDesktopScale(this.appItemWidth))
        .sourceSize({
          width: StyleConstants.APP_ICON_SOURCE_SIZE,
          height: StyleConstants.APP_ICON_SOURCE_SIZE
        })
        .borderRadius(EditModeUtils.convertWithDesktopScale(this.mFolderIconRadius))
        .syncLoad(true)
        .interpolation(ImageInterpolation.Medium)
        .autoResize(false)
        .backgroundImage(ShortcutViewModel.getInstance().getShortcutBackgroundImage(this.item))
        .backgroundImageSize(ImageSize.Cover)
        .backgroundImagePosition(Alignment.Center)
      Column()
        .width(EditModeUtils.convertWithDesktopScale(this.appItemWidth))
        .height(EditModeUtils.convertWithDesktopScale(this.appItemWidth))
        .backgroundColor(StyleConstants.APP_ICON_GRAY_COLOR)
        .visibility(this.isGrayIcon ? Visibility.Visible : Visibility.Hidden)
        .borderRadius(EditModeUtils.convertWithDesktopScale(this.mFolderIconRadius))
    }
  }

  private menuDragStart(x: number, y: number): void {
    const dragProxy: IDesktopDragHandler =
      DragProxyManager.getInstance().get('drag start on folder', DragHandlerType.DESKTOP) as IDesktopDragHandler;
    dragProxy?.onDragStart(x, y);
    this.hasMenuDragStart = true;
  }

  private onMenuDisappear(isLongPressShow: boolean): void {
    if (this.hasMenuDragStart) {
      ContractedFolderCommonViewModel.getInstance().closeFolder('close folder by menu drag');
      this.hasMenuDragStart = false;
    }
  }

  private getAppIconConfig(): AppIconConfig {
    const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    let enableMultiSelect : boolean = MultiSelectManager.getInstance().debug_enabledAppInFolder &&
    DeliverUtil.canFolderItemDragOut(openFolderData.folderId, this.item.bundleName);
    return FolderIconConfigUtil
      .getOpenFolderAppIconConfig(this.item, this.mFolderIconRadius, this.openFolderIconExternCb)
      .setEnableMultiSelect(enableMultiSelect);
  }

  build() {
    AppIconCommonView({
      item: this.item as AppItemInfo,
      iconSize: this.appItemWidth,
      maxNameLines: this.nameLines,
      nameHeight: this.nameHeight,
      nameWidth: this.nameWidth,
      nameSize: this.nameSize,
      appNameVm: this.appNameVm,
      nameMarginTop: this.mIconNameMargin,
      isDragStart: this.isDragStart,
      isInDrag: this.isDragDrop,
      iconBadgeVm: this.iconBadgeVm,
      appIconConfig: this.appIconConfig,
      iconData: this.appData,
      iconRadius: this.mFolderIconRadius,
      isFolderAppName: true,
      iconEvent: this.iconEvent as AppIconCommonEvent,
      nameFontColor: FolderStyleManager.getInstance().getNameFontColor()
    })
      .id(`${TAG}_AppBubble_${this.item.bundleName}`)
      .translate({ x: this.mOpenFolderAppMoveVm.translateX, y: this.mOpenFolderAppMoveVm.translateY })
      .accessibilityLevel('no')
      .onMouse((event?: MouseEvent) => {
        if (event?.button === MouseButton.Right) {
          event.stopPropagation?.();
          log.showDebug('OpenFolderAppItem onMouse MouseButton Right');
          AppStorage.setOrCreate<string>('selectDesktopAppItem', this.item.keyName as string);
          AppStorage.setOrCreate<string>('selectItemInFolder', this.item.bundleName);
        }
      })
  }
}