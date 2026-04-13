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
import { display } from '@kit.ArkUI';
import type ctx from '@ohos.app.ability.common';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { LayoutUtils, XTLayoutType } from '@ohos/systemuiutils/src/main/ets/base/LayoutUtils';
import { PinTopLimitDialogInterface } from './PinTopLimitDialogInterface';
import { fontScaleManager } from '@ohos/systemuiutils/src/main/ets/fontScale/fontScaleManager';
import { FontScaleState } from '@ohos/systemuiutils/src/main/ets/fontScale/fontScaleState';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { ViewType } from '@ohos/frameworkwrapper/src/main/ets/manager/view/ViewManagerPolicy';

const TAG = 'PinTopLimitDialogVm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class PinTopLimitDialogVm implements PinTopLimitDialogInterface {
  context: ctx.ServiceExtensionContext | ctx.UIExtensionContext | ctx.Context = GlobalContext.getContext();

  fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();
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
    if (DeviceHelper.isSmallFoldProduct()) {
      return true;
    }
    //XT仅单屏幕按直板机
    if (LayoutUtils.isXTProductType()) {
      return LayoutUtils.isMatchXTFoldMode(XTLayoutType.F) ? true : false;
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

  onFocus(): void {
    log.debug('pinDialog onFocus');
    GlobalContext.getContext().eventHub.emit('SubWindowVisible', ViewType.NOTIFICATION_CENTER, true);
  }

  onBlur(): void {
    log.debug('pinDialog onBlur');
    GlobalContext.getContext().eventHub.emit('SubWindowVisible', ViewType.NOTIFICATION_CENTER, false);
  }
}
