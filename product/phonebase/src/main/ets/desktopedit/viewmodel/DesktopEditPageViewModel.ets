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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { WantParams } from '@ohos/desktopedit/src/main/ets/default/common/constants/EditModeConstants';

const TAG = 'DesktopEditPageViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 图标编辑页面ViewModel
 */
export class DesktopEditPageViewModel {
  /**
   * 处理初始化参数
   */
  public dealParms(pageInfos: NavPathStack): void {
    let navName: string = '';
    let params: WantParams | undefined = LocalStorage.getShared()?.get<WantParams>('params');
    if (params && params.nav) {
      navName = params.nav;
    }
    log.showInfo('aboutToAppear params: %{public}s', JSON.stringify(params));
    pageInfos.pushPath({ name: navName, param: params }, false);
  }
}

export const desktopEditPageViewModel: DesktopEditPageViewModel =
  SingletonHelper.getInstance(DesktopEditPageViewModel, TAG);