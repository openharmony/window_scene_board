/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import systemparameter from '@ohos.systemparameter';
import { LogDomain, LogHelper } from './LogHelper';

const TAG = 'DeliverUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class DeliverUtil {
  static isSupportDeliver(): boolean {
    let res1: string = systemparameter.getSync('const.app_eco.support_ohos', 'default');
    let res2: string = systemparameter.getSync('persist.ohos_fusion_mgr.ctl.support_ohos', 'default');
    log.showInfo('get default const.app_eco.support_ohos: ' + res1 + ' get default persist.ohos_fusion_mgr.ctl.support_ohos: ' + res2);

    return res1 === 'true' || res2 === 'true';
  }
}