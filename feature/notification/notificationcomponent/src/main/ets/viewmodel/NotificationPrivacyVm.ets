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
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { INotificationCardVm, INotificationSwipeVm, NotificationItemBaseVm } from '@ohos/systemuicommon/newIndex';
import { NormalNotification, NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import {
  INotificationPrivacyVm
} from '@ohos/systemuicommon/src/main/ets/notification/interface/INotificationPrivacyVm';
import { AppProtectedStatusVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedStatusVm';
import { hideBannerNtfContentObj } from '../model/HideBannerNtfContentObj';
import { BannerShowStatusModel } from '@ohos/systemuicommon/src/main/ets/notification/model/BannerShowStatusModel';

const TAG = 'NotificationPrivacyVm';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 应用锁保护通知VM
 */
@ObservedV2
export class NotificationPrivacyVm extends NotificationItemBaseVm<NotificationBase>
implements INotificationPrivacyVm {
  @Trace public protectedStatusVm: AppProtectedStatusVm = AppProtectedStatusVm.instance;
  @Trace public bannerShowStatusModel: BannerShowStatusModel = BannerShowStatusModel.instance;

  @Computed get latestNotification(): NormalNotification {
    if (this.ntf.isNormalGroup()) {
      return this.ntf.children[0];
    }
    return this.ntf as NormalNotification;
  }

  @Computed get isProtected(): boolean {
    if (this.ntf.isLiveView()) {
      return false;
    }
    return this.protectedStatusVm.isProtected(this.ntf.creatorBundleName, this.ntf.appIndex);
  }

  @Computed get isHidden(): boolean {
    return hideBannerNtfContentObj.isUseSwing() && !this.bannerShowStatusModel.isShow;
  }

  @Computed get swipeVm(): INotificationSwipeVm | undefined {
    return this.vmInjector.getSwipeVm(this.ntf);
  }

  @Computed get content(): ResourceStr {
    if (this.isProtected) {
      return ResUtils.getInnerPluralByResource($r('app.plural.ntf_hide_content_count'), this.ntfCount);
    }
    return this.getHiddenContent();
  }

  @Computed get ntfCount(): number {
    if (this.ntf.isNormalGroup()) {
      const ntfCount = this.ntf.children.length;
      log.showInfo('ntf is group, get ntfCount:%{public}d', ntfCount);
      return Math.max(1, ntfCount);
    }
    return 1;
  }

  @Computed get titleFontSize(): Length {
    return $r('app.float.ntf_title_font_size');
  }

  @Computed get titleLineHeight(): Length {
    return $r('app.float.ntf_text_line_height_fp');
  }

  protected getHiddenContent() {
    return ResUtils.getInnerPluralByResource($r('app.plural.ntf_hide_content_count'), 1);
  }

  onClick(): void {
    log.showInfo(`Click for container ${this.ntf.hashCode}`);
    if (this.swipeVm?.offsetX !== 0) {
      this.swipeVm?.resetOffsetX(true);
      return;
    }
    this.getCardVm().onClick(this.ntf);
  }

  getCardVm(): INotificationCardVm {
    return this.vmInjector.getCardVm(this.latestNotification);
  }
}