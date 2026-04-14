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

import { INotificationNormalVm } from '@ohos/systemuicommon/newIndex';
import { ArrayUtils } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { NotificationStyle } from '../../../constants/NotificationStyle';
import { NotificationNormalVm } from '../../../viewmodel/NotificationNormalVm';

@ObservedV2
export class NotificationNormalBannerVm extends NotificationNormalVm implements INotificationNormalVm {
  @Trace public timeTranslate?: TranslateOptions;
  @Trace public contentTranslate?: TranslateOptions;
  @Trace public isExpandImmersive = false;
  @Trace public bodyOpacity = 1;

  public transition = undefined;

  public get isShowPinTop(): boolean {
    return false;
  }

  @Computed
  get height(): number | undefined {
    const verticalSwipeVm = this.vmInjector.getVerticalSwipeVm();
    if (!verticalSwipeVm?.isDeformFlag) {
      return undefined
    }
    // 当按钮和小横条存在时，调整高度
    const heightReducedByButton = ResUtils.getNumber($r('app.float.ntf_has_drop_bar_add_height')) -
      (!ArrayUtils.isEmpty(this.ntf.actionButtons) ? NotificationStyle.getActionBtnHeight(true) : 0);
    return verticalSwipeVm.bannerDeformState.bannerHeight + heightReducedByButton;
  }

  @Computed get isShowActionButton(): boolean {
    return true;
  }

  @Computed public get ntfTitle(): ResourceStr {
    if (this.vmInjector.getBannerVm().isShowImmersive || this.vmInjector.getBannerVm().isImmersiveExpanded) {
      return this.vmInjector.getImmersiveVm().title;
    }
    return super.ntfTitle;
  }

  onClick(): void {
    this.vmInjector.getBannerVm().onClick();
  }
}