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
import { display } from '@kit.ArkUI';
import type ctx from '@ohos.app.ability.common';
import { DeviceHelper, XTLayoutType } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/DeviceHelper';
import {
  LogDomain,
  LogHelper,
  PinTopLimitDialogInterface } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { fontScaleManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/fontScaleManager';
import { FontScaleState } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/fontScaleState';
import { ContextManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/ContextManager';

const TAG = 'NotificationMgmtPinTopLimitDialogVm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class NotificationMgmtPinTopLimitDialogVm implements PinTopLimitDialogInterface {
  public context: ctx.ServiceExtensionContext | ctx.UIExtensionContext | ctx.Context = ContextManager.getContext();

  public fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();
  /**
   * 是否采用横屏布局
   */
  public getIsLandLayout(): boolean {
    let foldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
    try {
      foldStatus = display.getFoldStatus();
    } catch (e) {
      log.showError(`get foldStatus err, code:${e?.code}, msg:${e?.message}`);
    }
    //XT仅单屏幕按直板机
    if (DeviceHelper.isXTProductType()) {
      return DeviceHelper.isMatchXTFoldMode(XTLayoutType.F) ? true : false;
    }
    // 大大屏幕机，折叠态按直板机处理
    if (DeviceHelper.isFold()) {
      return foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED;
    }
    // PAD无横屏展示，直板机或平板跟随屏方向：横屏显示
    return !DeviceHelper.isPad();
  }

  /**
   * 获取字体放大倍数（systemUI限制在2倍）
   */
  public getFontScale(): number {
    return this.fontScaleState.getFontScale();
  }
}
