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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { NumberConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { evtHubMgr } from '@ohos/frameworkwrapper/src/main/ets/manager/EventHubManager';
import { AppName } from '../../../../uicomponents/AppName';
import { AppIconConfig } from '../../../../launchericon/config/AppIconConfig';
import { AppIconCommonView } from '../../../../launchericon/view/AppIconCommonView';
import { AppIconBadgeVm } from '../../../../launchericon/viewmodel/AppIconBadgeVm';
import { AppIconCommonEvent } from '../../../../launchericon/viewmodel/AppIconCommonEvent';
import { AppIconData } from '../../../../launchericon/viewmodel/AppIconData';
import { AppItemInfo, CommonConstants, FolderAppItemInfo, GridLayoutItemInfo } from '../../../../TsIndex';
import { AppStatus } from '../../../../constants/CommonConstants';
import { BadgeAnimationType } from '../../../../uicomponents/CustomBadge';
import { NotHarmonyUtil } from '../../../../utils/NotHarmonyUtil';
import { BigFolderAppDefaultModifier } from '../../../viewmdoel/BigFolderAppDefaultModifier';
import { folderIconDataMgr } from '../viewmodel/manager/ContractedFolderIconDataManager';
import { PC_IN_PHONE_LIST } from '@ohos/windowscene';

const TAG = 'ContractedFolderItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹关闭态图标
 */
@Component
export struct ContractedFolderItem {
  @State iconBadgeVm: AppIconBadgeVm = new AppIconBadgeVm();
  @State appData: AppIconData = new AppIconData();
  @Prop iconSize: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  @Prop iconRadius: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  @Prop @Watch('onResizeModeChange') editFolderMode: boolean = false;
  @Prop @Require public index: number = 0;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @BuilderParam extendBadgeBuilder?: CustomBuilder;

  public appIconConfig: AppIconConfig = new AppIconConfig();
  public bigFolderIconModifier: BigFolderAppDefaultModifier = new BigFolderAppDefaultModifier();
  public iconEvent: AppIconCommonEvent = new AppIconCommonEvent();
  public item: AppItemInfo = new AppItemInfo();
  public folderId: string = '';
  public isShowMask: boolean = false;
  public isSmall: boolean = false;
  public maskBgColor: string = '#00000000';
  public onAppClick: (msg: string, folderId: string, item: GridLayoutItemInfo) => void = () => {};
  private badgeVisibleEventKey: string = CommonConstants.EVENTHUB_BIG_FOLDER_OPEN_STATUS + this.item.keyName;
  private badgeVisibleEvent: Function = (data: FolderAppItemInfo): void => this.setBadgeVisibleState(data);

  aboutToAppear() {
    // 克隆过来的占位的快捷方式图标使用的自定义蒙层，处于占位状态不能清空蒙层
    const isPendShortcut: boolean = this.isPendShortcut();
    if (this.isShowMask && !isPendShortcut) {
      this.appData.isShowMask = true;
      this.appData.maskBgColor = this.maskBgColor;
      this.appData.maskOpacity = 1;
    }
    if (this.editFolderMode) {
      folderIconDataMgr.setIconData(String(this.index), this.appData);
      if (isPendShortcut) {
        folderIconDataMgr.setCustomMask(this.appData);
      }
    }
    this.badgeVisibleEventKey = CommonConstants.EVENTHUB_BIG_FOLDER_OPEN_STATUS + this.item.keyName;
    evtHubMgr.on(this.badgeVisibleEventKey, this.badgeVisibleEvent);
    this.iconBadgeVm.visible = !this.editFolderMode;
    this.iconBadgeVm.bindFolderId = this.folderId;
  }

  aboutToDisappear() {
    evtHubMgr.off(this.badgeVisibleEventKey, this.badgeVisibleEvent);
  }

  onResizeModeChange(): void {
    if (this.editFolderMode) {
      folderIconDataMgr.setIconData(String(this.index), this.appData);
      if (this.isPendShortcut()) {
        folderIconDataMgr.setCustomMask(this.appData);
      }
      this.iconBadgeVm.animate = BadgeAnimationType.OPACITY_ZERO;
    } else {
      this.iconBadgeVm.visible = true;
      this.iconBadgeVm.animate = BadgeAnimationType.CLOSE_FOLDER_COMPONENT_SHOW;
    }
  }

  private isPendShortcut(): boolean {
    return this.item.typeId === CommonConstants.TYPE_SHORTCUT_ICON && this.item.appStatus === AppStatus.PENDING;
  }

  private setBadgeVisibleState(data: FolderAppItemInfo): void {
    if (!data || !data.folderId || this.folderId !== data.folderId) {
      return;
    }
    if (data.isOpenFolder) {
      this.iconBadgeVm.visible = false;
      this.iconBadgeVm.animate = BadgeAnimationType.DEFAULT;
    } else {
      this.iconBadgeVm.visible = true;
      this.iconBadgeVm.animate = BadgeAnimationType.CLOSE_FOLDER_COMPONENT_SHOW;
    }
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
      appIconConfig: this.appIconConfig,
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
      .onClick((event?: ClickEvent) => this.onAppClick(TAG, this.folderId, this.item as GridLayoutItemInfo))
    } else {
      this.appIconBuilder();
    }
  }
}
