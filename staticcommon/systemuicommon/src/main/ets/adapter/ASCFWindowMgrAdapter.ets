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
import lazy { SCBScreenSessionManager } from '@ohos/windowscene';
import lazy { DeviceHelper } from '@ohos/frameworkwrapper';

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { threadCall, ThreadCallType } from '../messageChannel/ThreadCall';
import { ASCFWindowMgr, WindowMode } from '@ohos/windowscene';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'ASCFWindowMgrAdapter');

export class ASCFWindowMgrAdapter {
  @threadCall(ThreadCallType.Async)
  public static async isWindowModeForMetaService(bundleName: string = ''): Promise<boolean> {
    if (!ASCFWindowMgrAdapter.isSupportAtomicServiceFloatScene()) {
      log.showInfo(`device is not support.`);
      return false;
    }

    if (!bundleName.startsWith('com.atomicservice.')) {
      log.showInfo(`${bundleName} is not AtomicService`);
      return false;
    }

    const windowMode = await ASCFWindowMgr.queryWindowMode(bundleName);
    log.showInfo(`window mode is ${windowMode}, bundleName: ${bundleName}`);

    if (windowMode === WindowMode.FLOATINGWINDOW) {
      return true;
    }

    return false;
  }

  private static isSupportAtomicServiceFloatScene(): boolean {
    return DeviceHelper.isPad() || (DeviceHelper.isThreeFoldProduct() &&
    SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus() &&
      !DeviceHelper.isThreeFoldGPortrait()) ||
      (DeviceHelper.isPhone() && DeviceHelper.isFoldExpandedOrHalfButNotSmallFoldProduct());
  }
}
