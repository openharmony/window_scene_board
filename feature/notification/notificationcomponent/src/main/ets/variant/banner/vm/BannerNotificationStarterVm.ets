/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { NotificationStartWantAgentParams } from '@ohos/systemuicommon/newIndex';
import { NotificationUtil } from '@ohos/systemuicommon/newTsIndex';
import { NotificationStarterVm } from '../../../viewmodel/NotificationStarterVm';

const TAG = 'BannerNotificationStarterVm';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class BannerNotificationStarterVm extends NotificationStarterVm {
  isStartAppByOneMirror(params: NotificationStartWantAgentParams): boolean {
    const isTargetAppForeground = NotificationUtil.isTargetAppForeground(
      params.cardVm.ntf.creatorBundleName,
      params.cardVm.ntf.appIndex,
      params.wantAgentInfo?.want);
    if (isTargetAppForeground) {
      log.showInfo(`ntf ${params.cardVm.ntf.hashCode} is targeting foreground app:${params.wantAgentInfo?.bundleName}`);
      this.hidePanel();
      return false;
    }
    return true;
  }

  hidePanel(): void {
    log.showInfo('Hide panel');
    this.vmInjector.getBannerVm().releasePanel();
  }
}