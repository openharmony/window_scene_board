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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { HiDfxEventUtil } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { AppItemInfo, CommonConstants, DeliverUtil } from '../../TsIndex';
import { AppIconTouchEventIface } from '../interface/AppIconTouchEventIface';
import { AppIconData } from './AppIconData';
import { SCBConstants } from '@ohos/commonconstants';

const TAG = 'AppIconContainerTouchEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);

export interface AppIconContainerTouchEventParam {
  itemInfo: AppItemInfo;
  iconData: AppIconData;
}

export class AppIconContainerTouchEvent implements AppIconTouchEventIface {
  private itemInfo?: AppItemInfo;
  private iconData?: AppIconData;

  public initContainerTouchParam(param: AppIconContainerTouchEventParam): AppIconTouchEventIface {
    if (!param || !param.itemInfo || !param.iconData) {
      return this;
    }

    this.itemInfo = param.itemInfo;
    this.iconData = param.iconData;
    return this;
  }

  public onTouch(event: TouchEvent): void {
    if (event?.type !== CommonConstants.TOUCH_TYPE_DOWN || !this.itemInfo || !this.iconData) {
      return;
    }

    log.showInfo(`on icon container touch down start: ${!this.iconData.isSuperposeApp}`);
    // 点击堆叠处的DH应用不预加载
    if (!this.iconData.isSuperposeApp && DeliverUtil.isSupportAppType(this.itemInfo.bundleName) &&
      DeliverUtil.isSupportDeliver()) {
      SCBSceneSessionManager.getInstance().preloadApp(this.itemInfo.bundleName);
    }
  }

  public onClick(event?: ClickEvent | undefined): void {
    // 判断iconOpacity
    if ((this.iconData?.containerOpacity ?? 0) <= SCBConstants.NEAR_ZERO_VALUE) {
      HiDfxEventUtil.reportIconStatusAbnormal('icon container visibility invalid', this.itemInfo?.bundleName);
    }
  }
}