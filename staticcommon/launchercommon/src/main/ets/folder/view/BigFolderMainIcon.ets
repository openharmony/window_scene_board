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
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { AppIconConfig } from '../../launchericon/config/AppIconConfig';
import { AppIconCommonView } from '../../launchericon/view/AppIconCommonView'
import { AppIconBadgeVm } from '../../launchericon/viewmodel/AppIconBadgeVm';
import { AppItemInfo, CommonConstants, FolderAppItemInfo, DeliverUtil, NotHarmonyUtil } from '../../TsIndex';
import { BigFolderAppDefaultModifier } from '../viewmdoel/BigFolderAppDefaultModifier';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { BadgeAnimationType } from '../../uicomponents/CustomBadge';
import { PC_IN_PHONE_LIST } from '@ohos/windowscene';

/*
 * 大文件夹可直接点击进入的图标
 *
*/

const TAG = 'BigFolderMainIcon';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export struct BigFolderMainIcon {
  private appIconConfig: AppIconConfig = new AppIconConfig();
  private bigFolderIconModifier : BigFolderAppDefaultModifier = new BigFolderAppDefaultModifier();
  private item: AppItemInfo = new AppItemInfo();
  private folderId: string = '';
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private onSetBadgeVisibleState: Function = (data: FolderAppItemInfo): void => this.setBadgeVisibleState(data);
  @Prop iconSize: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  @Prop iconRadius: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  @State iconBadgeVm: AppIconBadgeVm = new AppIconBadgeVm();

  aboutToAppear() {
    this.desktopContext?.eventHub.on(`${CommonConstants.EVENTHUB_BIG_FOLDER_OPEN_STATUS}${this.item.keyName}`, this.onSetBadgeVisibleState);
  }

  aboutToDisappear() {
    this.desktopContext?.eventHub.off(`${CommonConstants.EVENTHUB_BIG_FOLDER_OPEN_STATUS}${this.item.keyName}`, this.onSetBadgeVisibleState);
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

  build() {
    AppIconCommonView({
      item: this.item,
      iconSize: this.iconSize,
      iconRadius: this.iconRadius,
      appIconConfig: this.appIconConfig,
      iconModifier: this.bigFolderIconModifier,
      iconBadgeVm: this.iconBadgeVm,
    })
  }
}
