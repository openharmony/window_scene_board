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
import lazy { SCBVisualEffectMgr } from '@ohos/componenthelper';
import { threadCall, ThreadCallType } from '../messageChannel/ThreadCall';

const TAG = 'SCBVisualEffectManagerAdapter';
const log = LogHelper.getLogHelper(LogDomain.CC, TAG);

export class SCBVisualEffectManagerAdapter {
  @threadCall(ThreadCallType.Sync)
  public static isFeatureParamTrue(feature: string): boolean {
    log.showInfo(`isFeatureParamTrue ${feature}`);
    return SCBVisualEffectMgr.isFeatureParamTrue(feature);
  }

  @threadCall(ThreadCallType.Sync)
  public static getFeatureParam(feature: string): string | undefined {
    log.showInfo(`getFeatureParam ${feature}`);
    return SCBVisualEffectMgr.getFeatureParam(feature);
  }
}