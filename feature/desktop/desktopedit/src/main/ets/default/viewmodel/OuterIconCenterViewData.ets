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
import FormStyleConstants from '@ohos/form/src/main/ets/default/common/constants/FormStyleConstants';
import { launcherStatusUtil } from '@ohos/windowscene';
import { ViewData } from './OuterEditCenterObservedData';

const TAG: string = 'OuterIconCenterViewData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 外屏编辑页面APP管理页参数
 */
export class OuterIconCenterViewData {
  private static mInstance: OuterIconCenterViewData;
  private mViewData: ViewData = new ViewData();

  /**
   * 构造方法
   */
  constructor() {
    log.showInfo('OuterIconCenterInit');
  }

  /**
   * 单例
   *
   * @returns 本类对象
   */
  public static getInstance(): OuterIconCenterViewData {
    if (OuterIconCenterViewData.mInstance == null) {
      OuterIconCenterViewData.mInstance = new OuterIconCenterViewData();
    }
    return OuterIconCenterViewData.mInstance;
  }

  /**
   * 获得屏编辑页面APP管理页参数数据
   *
   * @param isPortrait
   * @returns
   */
  public getViewData(isPortrait?: boolean): ViewData {
    this.updateViewDate(isPortrait);
    return this.mViewData;
  }

  /**
   * 更新参数
   *
   * @param isPortrait 屏幕距离
   */
  public updateViewDate(isPortrait?: boolean) {
    // 半模态宽度为横屏8栅格
    log.showInfo(`updateViewDate isPortrait: ${isPortrait}`);
    let screenWidth: number = AppStorage.get('screenWidth') as number;
    let screenHeight: number = AppStorage.get('screenHeight') as number;
    this.mViewData.bindSheetWidth = screenWidth;
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      this.mViewData.bindSheetHeight = screenHeight - FormStyleConstants.OUTER_FORM_CENTER_VIEW_TOP_HEIGHT;
    } else {
      this.mViewData.bindSheetHeight = screenHeight - FormStyleConstants.FORM_CENTER_VIEW_TOP_HEIGHT;
    }
  }
}
