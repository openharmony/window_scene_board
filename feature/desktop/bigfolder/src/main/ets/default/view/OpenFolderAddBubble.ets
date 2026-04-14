/*
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext, ResourceManager, HiSysEventUtil, localEventManager } from '@ohos/frameworkwrapper';
import {
  AppBubbleParams,
  AppIconCommonView,
} from '@ohos/launchercommon/Index';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { AppIconBadgeVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconBadgeVm';
import {
  AppItemInfo,
  GridLayoutItemInfo,
  folderGesData,
  MultiSelectManager,
  CommonConstants,
  lockLayoutManager,
  EventConstants,
  FolderManager,
  FolderStyleManager,
  FolderCommonConstants,
  GridLayoutUtil
} from '@ohos/launchercommon';
import { FolderAccessibilityUtils } from '../common/FolderAccessibilityUtils';
import { AppIconData } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconData';
import {
  openFolderAppBubbleLayout
} from '@ohos/launchercommon/src/main/ets/folder/viewmdoel/OpenFolderAppBubbleLayout';
import { AppNameVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppNameVm';
import { OpenFolderAppMoveVm } from '../viewmodel/OpenFolderAppMoveVM';
import { openFolderAppMoveVMManager } from '../viewmodel/OpenFolderAppMoveVMManager';
import { AlertDialog } from '@kit.ArkUI';
import FeatureConstants from '../common/constants/FeatureConstants';
import { FolderIconConfigUtil } from '@ohos/launchercommon/src/main/ets/folder/model/FolderIconConfigUtil';
import {
  BigFolderAppDefaultModifier
} from '@ohos/launchercommon/src/main/ets/folder/viewmdoel/BigFolderAppDefaultModifier';
import { FolderAddEventParams } from '../common/constants/FolderAddDialogConstant';

const TAG = 'OpenFolderAddBubble';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹展开态+号组件
 */
@Component
export struct OpenFolderAddBubble {
  @Prop appItemWidth: number = 0;
  @StorageLink('isDrag') isDrag: boolean = false;
  @State iconBadgeVm: AppIconBadgeVm = new AppIconBadgeVm();
  @State mOpenFolderAppMoveVm: OpenFolderAppMoveVm = new OpenFolderAppMoveVm();

  // 卸载时，移位动效结束后布局还未更新到最新，延长动效时长200 -> 250(可调)
  private moveIconAnimationDuration = 250;

  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private mMultiSelectManager: MultiSelectManager = MultiSelectManager.getInstance();
  private item: GridLayoutItemInfo = new GridLayoutItemInfo();
  private params: AppBubbleParams = new AppBubbleParams;
  @State appData: AppIconData = new AppIconData();
  private appNameVm: AppNameVm = new AppNameVm();

  aboutToAppear(): void {
    log.showInfo('aboutToAppear bundleName:%{public}s', this.item.bundleName);
    openFolderAppBubbleLayout.setIconData(this.item.keyName ?? this.item.bundleName, this.appData);
    this.appNameVm.modifier.onInit = (instance?: CommonAttribute) => {
      instance
      ?.opacity(this.params.openFolderIconNameOpt)
        .width(this.params.common.nameWidth)
    };
    openFolderAppBubbleLayout.setNameData(this.item.keyName ?? this.item.bundleName, this.appNameVm);
    this.item.appLabelId = $r('app.string.folder_add').id;
    this.item.appName = ResourceManager.getInstance().getStringByName('folder_add');
    this.mOpenFolderAppMoveVm.id = this.item.keyName ?? '';
    openFolderAppMoveVMManager.registerItem(this.mOpenFolderAppMoveVm);
    this.registerAccessibilityClickEvent();
    this.initAddButtonParam();
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear bundleName:%{public}s', this.item.bundleName);
    openFolderAppBubbleLayout.deleteIconData(this.item.keyName ?? this.item.bundleName);
    openFolderAppBubbleLayout.deleteNameData(this.item.keyName ?? this.item.bundleName);
    openFolderAppMoveVMManager.unregisterItem(this.mOpenFolderAppMoveVm);
    this.unregisterAccessibilityClickEvent();
  }

  // 无障碍模式下点击事件注册
  private registerAccessibilityClickEvent = (): void => {
    this.unregisterAccessibilityClickEvent();
    this.desktopContext?.eventHub.on(
      FolderAccessibilityUtils.getFolderItemAccessibilityClickEventName(this.item), this.onIconClick);
  };

  // 无障碍模式下点击事件反注册
  private unregisterAccessibilityClickEvent = (): void => {
    this.desktopContext?.eventHub.off(
      FolderAccessibilityUtils.getFolderItemAccessibilityClickEventName(this.item), this.onIconClick);
  };

  private onIconClick = (event?: ClickEvent): void => {
    // 打开关闭动画中不做处理
    const dataMgr: FolderManager = FolderManager.getInstance();
    const isOpenFolder: boolean = dataMgr.isFolderOpen();
    const isOpenFolderTouched: boolean = dataMgr.getIsOpenFolderIconTouchEnabled();
    if (!isOpenFolderTouched) {
      log.showInfo('click Add Inactive, because folder opening or closing');
      return;
    }
    // dialog已打开不做处理，避免重复点击打开多个dialog
    if (folderGesData.isAddDialogOpening()) {
      log.showInfo('click Add Inactive, because dialog is opened.');
      return;
    }
    // 文件夹已关闭不做处理
    if (!isOpenFolder) {
      log.showInfo('click Add Inactive, because folder is closed.');
      return;
    }
    const openFolderId: string = dataMgr.getOpenFolderId();
    const openFolder: GridLayoutItemInfo = dataMgr.getOpenedFolder();
    const isCardFolder: boolean = GridLayoutUtil.isBigFolder(openFolder);
    // 锁定布局时普通文件夹不可反选
    if (lockLayoutManager.isLockLayout()) {
      lockLayoutManager.toastLockedLayout();
      return;
    }
    log.showInfo('Click add to open dialog.');
    this.mMultiSelectManager.clearAllSelect();
    this.mMultiSelectManager.updateCheckboxSelectState();
    localEventManager.sendLocalEvent(EventConstants.EVENT_FOLDER_ADD_SHEET_REQUEST_OPEN,
      new FolderAddEventParams(FolderCommonConstants.OPEN_ADD_SHEET_ADD_BUBBLE, openFolderId));
    // 锁定布局时普通文件夹不可反选
    if (lockLayoutManager.isLockLayout()) {
      lockLayoutManager.toastLockedLayout();
      return;
    }
    log.showInfo('Click add to open dialog.');
    this.mMultiSelectManager.clearAllSelect();
    this.mMultiSelectManager.updateCheckboxSelectState();
    localEventManager.sendLocalEvent(EventConstants.EVENT_FOLDER_ADD_SHEET_REQUEST_OPEN,
      new FolderAddEventParams(FolderCommonConstants.OPEN_ADD_SHEET_ADD_BUBBLE, openFolderId));
  }

  private initAddButtonParam(): void {
    let aniParameters = this.params.openFolderAniParams;
    if (aniParameters.length >= FeatureConstants.OPEN_FOLDER_ANI_PARAM_LENGTH) {
      this.appData.transX = aniParameters[0];
      this.appData.transY = aniParameters[1];
      this.appData.setIconScale(aniParameters[2]);
      this.appData.setIconOpacity(aniParameters[3] ?? 1, TAG, 'initAddButtonParam');
    }
  }

  private getAddIconModifier(): BigFolderAppDefaultModifier {
    let modifier: BigFolderAppDefaultModifier = new BigFolderAppDefaultModifier();
    modifier.callback = (instance: CommonAttribute) => {
      instance
        .backgroundColor(FeatureConstants.OPEN_FOLDER_ADD_ICON_BACKGROUND_COLOR)
        .draggable(false)
        .width(this.appItemWidth)
        .height(this.appItemWidth)
        .borderRadius(this.params.common.mFolderIconRadius === 0 ? CommonConstants.DEFAULT_ICON_RADIUS :
          this.params.common.mFolderIconRadius)
    }
    return modifier;
  }

  @Builder
  AddButton() {
    Image(FeatureConstants.OPEN_FOLDER_ADD_ICON_SRC)
      .width(FeatureConstants.OPEN_FOLDER_ADD_ICON_IMAGE_SIZE)
      .height(FeatureConstants.OPEN_FOLDER_ADD_ICON_IMAGE_SIZE)
      .draggable(false)
  }

  build() {
    AppIconCommonView({
      item: this.item as AppItemInfo,
      iconSize: this.appItemWidth,
      nameSize: this.params.common.nameSize,
      nameFontColor: FolderStyleManager.getInstance().getNameFontColor(),
      nameWidth: this.params.common.nameWidth,
      nameHeight: this.params.common.nameHeight,
      nameMarginTop: this.params.common.mIconNameMargin,
      iconData: this.appData,
      appNameVm: this.appNameVm,
      isFolderAppName: true,
      iconModifier: this.getAddIconModifier(),
      extendIconBuilder: () => this.AddButton(),
      appIconConfig: FolderIconConfigUtil.getOpenFolderAddIconConfig({
        onIconClick:(event?: ClickEvent, fingers?: number): void => {
          this.onIconClick();
        }
      })
    })
      .accessibilityLevel('no')
      .translate({ x: this.mOpenFolderAppMoveVm.translateX, y: this.mOpenFolderAppMoveVm.translateY })
    }
}