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
import { SingletonHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { DeviceHelper } from '@ohos/managementcomponent';
import { ContextManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/ContextManager';
import { display } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';

const TAG = 'NotificationMgmt_SheetModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

@Observed
export class SheetModel {
  public static get = SingletonHelper.createFactory(() => new SheetModel());

  /**
   * 半模态Sheet高度
   */
  public height: Length = 0;

  public calcHeight(): void {
    let newHeight: Length = this.getHeight();
    if (this.height === newHeight || newHeight <= 0) {
      return;
    }
    this.height = newHeight;
  }

  private getHeight(): Length {
    /* Pad或折叠屏展开态且非分屏模式使用设备短边的90%作为高度 */
    try {
      if (((DeviceHelper.isPad() || DeviceHelper.isFoldExpandedOrHalfButNotSmallFoldProduct()) &&
        ContextManager.windowWidthByVp >= px2vp(display.getDefaultDisplaySync().width)) ||
        DeviceHelper.isBigScreenDevice()) {
        return Math.min(ContextManager.windowWidthByVp, ContextManager.windowHeightByVp) * 0.9;
      }
    } catch (error) {
      log.showError(`getHeight error: ` + error);
    }
    return SheetSize.LARGE;
  }
}